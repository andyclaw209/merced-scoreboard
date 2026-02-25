#!/bin/bash
# sync.sh — Export scoreboard data and push to GitHub
# Runs on the Mac Mini every 5 minutes via LaunchAgent

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DB_PATH="/Users/andyclaw/.openclaw/workspace/db/merced.db"

python3 << PYEOF > "$REPO_DIR/data.json"
import sqlite3, json
from datetime import datetime, timezone
con = sqlite3.connect('$DB_PATH')
con.row_factory = sqlite3.Row
rows = [dict(r) for r in con.execute('SELECT name, cars_sold_month, goal_month, streak, status FROM scoreboard WHERE status="Active" ORDER BY cars_sold_month DESC')]
totals = dict(con.execute('SELECT SUM(cars_sold_month) as total_cars, SUM(goal_month) as total_goal FROM scoreboard WHERE status="Active"').fetchone())
con.close()
print(json.dumps({'scoreboard': rows, 'teamTotals': totals, 'updatedAt': datetime.now(timezone.utc).isoformat()}, indent=2))
PYEOF

cd "$REPO_DIR"
git add data.json
if git diff --cached --quiet; then
  echo "[sync] No changes — skipping push"
else
  git commit -m "sync: scoreboard update $(date -u '+%Y-%m-%d %H:%M UTC')"
  git push origin main
  echo "[sync] Pushed at $(date)"
fi
