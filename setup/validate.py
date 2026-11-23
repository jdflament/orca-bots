#!/usr/bin/env python3
"""Cheap structural checks for the config repo. No network, no dependencies."""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
errors = []

required = [
    "README.md",
    "setup/sync.sh",
    "setup/create-bots.sh",
    "setup/set-agent.mjs",
    "setup/bootstrap.md",
    "automations/README.md",
    "repos/TEMPLATE.md",
    "repos/REGISTRY.md",
    "captain/SOUL.md",
    "reviewer/SOUL.md",
    "craft/SOUL.md",
    "experience/SOUL.md",
    "issues/SOUL.md",
    "docs/SOUL.md",
]
for rel in required:
    if not (ROOT / rel).is_file():
        errors.append(f"missing: {rel}")

names = set()
for skill in sorted((ROOT / "skills").glob("*/SKILL.md")):
    lines = skill.read_text().splitlines()
    if not lines or lines[0].strip() != "---":
        errors.append(f"{skill.name}: no frontmatter")
        continue
    end = next((i for i, line in enumerate(lines[1:], 1) if line.strip() == "---"), None)
    if end is None:
        errors.append(f"{skill.name}: unclosed frontmatter")
        continue
    front = "\n".join(lines[1:end])
    if not re.search(r"^name:\s*\S+", front, re.M):
        errors.append(f"{skill.name}: no name")
    if not re.search(r"^description:", front, re.M):
        errors.append(f"{skill.name}: no description")
    m = re.search(r"^name:\s*(\S+)", front, re.M)
    if m:
        if m.group(1) in names:
            errors.append(f"duplicate skill: {m.group(1)}")
        names.add(m.group(1))
    if len(lines) > 80:
        errors.append(f"{skill.name}: over 80 lines ({len(lines)})")

for soul in sorted(ROOT.glob("*/SOUL.md")):
    text = soul.read_text()
    lines = text.splitlines()
    if len(lines) > 40:
        errors.append(f"{soul.parent.name}/SOUL.md: over 40 lines ({len(lines)})")
    for ref in set(re.findall(r"\bob-[a-z-]+", text)):
        if ref not in names:
            errors.append(f"{soul.parent.name}/SOUL.md: unknown skill {ref}")
    if soul.parent.name == "captain" and "orca-coordinator plugin is present" not in text:
        errors.append("captain/SOUL.md: optional coordinator rule missing")

secret = re.compile(r"(gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}|xox[baprs]-|AKIA[0-9A-Z]{16})")
stale = re.compile(r"orca-agents|\boa-[a-z-]+")
absolute = re.compile(r"(/Users/[^/\s]+|[A-Za-z]:\\Users\\)")
for path in ROOT.rglob("*"):
    if path.is_file() and path.suffix in {".md", ".sh", ".yml", ".py"}:
        for n, line in enumerate(path.read_text(errors="ignore").splitlines(), 1):
            if secret.search(line):
                errors.append(f"{path.relative_to(ROOT)}:{n}: possible secret")
            if path.name != "validate.py" and stale.search(line):
                errors.append(f"{path.relative_to(ROOT)}:{n}: stale project or skill name")
            if path.name != "validate.py" and absolute.search(line):
                errors.append(f"{path.relative_to(ROOT)}:{n}: private absolute path")

if errors:
    print("FAIL")
    for e in errors:
        print(" -", e)
    sys.exit(1)
print(f"OK ({len(names)} skills, {len(list(ROOT.glob('*/SOUL.md')))} bots)")
