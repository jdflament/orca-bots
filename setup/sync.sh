#!/usr/bin/env bash
# Guarded sync of canonical SOUL.md files into Orca bot folders.
# Never overwrites a file that changed locally since the last recorded apply.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROLES=(captain reviewer craft experience issues docs)
DST="${ORCA_BOTS_DIR:-$HOME/.orca/bots}"
STATE="${ORCA_BOTS_STATE:-$HOME/.local/state/orca-bots}"
DB="$STATE/manifest.tsv"
MODE="${1:-check}"

case "$MODE" in
  check|apply|adopt) ;;
  *) echo "usage: sync.sh check|apply|adopt" >&2; exit 2 ;;
esac

mkdir -p "$STATE"
[[ -f "$DB" ]] || : > "$DB"

hash() { shasum -a 256 "$1" | awk '{print $1}'; }
state() { awk -F'\t' -v p="$1" '$1==p {print $2 "\t" $3; exit}' "$DB"; }
record() {
  local path="$1" src="$2" applied="$3" tmp
  tmp="$(mktemp)"
  awk -F'\t' -v p="$path" '$1 != p' "$DB" > "$tmp"
  printf '%s\t%s\t%s\n' "$path" "$src" "$applied" >> "$tmp"
  mv "$tmp" "$DB"
}

fail=0
for role in "${ROLES[@]}"; do
  f="$ROOT/roles/$role/SOUL.md"
  target="$DST/$role/SOUL.md"
  sh="$(hash "$f")"

  if [[ ! -e "$target" ]]; then
    if [[ "$MODE" == apply ]]; then
      mkdir -p "$(dirname "$target")"
      cp "$f" "$target"
      record "$target" "$sh" "$sh"
      echo "created  $role"
    else
      echo "missing  $role"
      fail=1
    fi
    continue
  fi

  th="$(hash "$target")"
  if [[ "$MODE" == adopt ]]; then
    record "$target" "$sh" "$th"
    echo "adopted  $role"
    continue
  fi

  prev_src="" prev_applied=""
  IFS=$'\t' read -r prev_src prev_applied < <(state "$target") || true

  if [[ -z "$prev_src" ]]; then
    echo "unmanaged  $role (run: sync.sh adopt)"
    fail=1
  elif cmp -s "$f" "$target"; then
    record "$target" "$sh" "$th"
    echo "ok       $role"
  elif [[ "$prev_applied" == "$th" ]]; then
    if [[ "$MODE" == apply ]]; then
      cp "$f" "$target"
      record "$target" "$sh" "$sh"
      echo "updated  $role"
    else
      echo "update available  $role"
      fail=1
    fi
  else
    echo "CONFLICT $role (local edit kept, not overwritten)" >&2
    if [[ "$MODE" == apply ]]; then
      cp "$target" "$target.orca-bots.conflict" 2>/dev/null || true
    fi
    fail=1
  fi
done

exit "$fail"
