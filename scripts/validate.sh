#!/usr/bin/env bash
# validate.sh — structural validation for the research-engine plugin (single-purpose tool).
# Pure python3 stdlib — no pip deps. Run: bash scripts/validate.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT" <<'PY'
import sys, os, re, json, glob

ROOT = sys.argv[1]
errors, warns = [], []
def err(m): errors.append(m)
def warn(m): warns.append(m)

# ---------- 1. JSON validity + version consistency ----------
def load_json(rel):
    p = os.path.join(ROOT, rel)
    try:
        return json.load(open(p, encoding="utf-8"))
    except FileNotFoundError:
        err(f"{rel}: missing"); return None
    except json.JSONDecodeError as e:
        err(f"{rel}: invalid JSON ({e})"); return None

plugin = load_json(".claude-plugin/plugin.json")
market = load_json(".claude-plugin/marketplace.json")
pv = plugin.get("version") if plugin else None
if plugin and not pv:
    err("plugin.json: no version")
if plugin and market:
    mvs = [p.get("version") for p in market.get("plugins", [])]
    if pv not in mvs:
        err(f"version skew: plugin.json={pv} but marketplace.json={mvs}")

# ---------- 2. Per-skill SKILL.md checks ----------
skill_dirs = sorted(d for d in glob.glob(os.path.join(ROOT, "skills", "*")) if os.path.isdir(d))
if not skill_dirs:
    err("no skills found under skills/")
for d in skill_dirs:
    folder = os.path.basename(d)
    md = os.path.join(d, "SKILL.md")
    if not os.path.isfile(md):
        err(f"{folder}: no SKILL.md"); continue
    txt = open(md, encoding="utf-8").read()
    fm = re.match(r"^---\n(.*?)\n---", txt, re.S)
    if not fm:
        err(f"{folder}: no YAML frontmatter (--- ... ---)"); continue
    front = fm.group(1)
    kv = dict(re.findall(r"^([A-Za-z0-9_-]+):[ ](.*)$", front, re.M))
    name = kv.get("name", "")
    if name != folder:
        err(f"{folder}: frontmatter name='{name}' != folder")
    desc = kv.get("description", "").strip()
    if not desc:
        err(f"{folder}: empty/missing description")
    else:
        if desc[:1] in ('"', "'"):
            err(f"{folder}: description starts with a quote (breaks YAML)")
        if '"' in desc:
            err(f"{folder}: description contains a double-quote (use «» or rephrase)")
        if ': ' in desc:
            err(f"{folder}: description contains ': ' (breaks YAML mapping parse)")

# ---------- 3. Reference deps present ----------
for ref in ("strategy-template.md", "methodology.md", "hook-bank.md", "notion-schema.md"):
    if not os.path.isfile(os.path.join(ROOT, "reference", ref)):
        err(f"reference/{ref}: missing (skill depends on it)")

# ---------- report ----------
print(f"Checked {len(skill_dirs)} skill(s).")
for w in warns:
    print(f"  WARN  {w}")
if errors:
    for e in errors:
        print(f"  FAIL  {e}")
    print(f"\n✗ {len(errors)} error(s).")
    sys.exit(1)
print(f"\n✓ All checks passed ({len(warns)} warning(s)). Plugin version: {pv}")
PY
