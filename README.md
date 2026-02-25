# Merced Sales Scoreboard

TV-optimized sales scoreboard for Merced Hyundai • KIA • VW.  
Deployed on Vercel. Data synced from the Mac Mini every 5 minutes.

## How it works
- `index.html` — full-screen scoreboard display
- `data.json` — scoreboard data, auto-committed by the Mac Mini sync script
- Vercel auto-deploys on every push (< 30 seconds)

## Deploy
1. Connect this repo to Vercel
2. Framework: **Other** (pure static)
3. Output directory: `.` (root)
4. Done — no build step needed

## Data Sync
The Mac Mini runs `sync.sh` every 5 minutes via LaunchAgent.  
It exports the SQLite database → `data.json` → commits → pushes → Vercel redeploys.
