# Dev Ports Watcher (ports-tui)

A lightweight terminal TUI to monitor **development-related listening ports** and processes.

Designed for people running **multiple Node, Docker, and FastAPI services** on the same machine who want a **calm, focused view** instead of hundreds of system ports.

Inspired by tools like `htop`, `lazygit`, and `k9s`.

---

## What it shows

Only **development-relevant services**, by default:

- Node.js (`node`, Vite, Next.js, NestJS)
- Python web servers (`python`, `uvicorn`, `gunicorn`, FastAPI)
- Docker (`docker`, `containerd`)
- Common dev dependencies (`postgres`, `redis`)

Displayed in a fixed, refreshing table:

```
PROT │ ADDRESS │ PORT │ PID │ PROCESS
tcp │ 0.0.0.0 │ 8005 │ 1113121 │ python
```


---

## Features

- Fixed table layout (no scrolling spam)
- Auto-refresh every **60 seconds**
- Manual refresh with **`r`**
- Quit with **`q`**
- Optional interactive process selection & kill (via `fzf`)
- Linux-native on Ubuntu Server
- Minimal dependencies

---

## Requirements

### Ubuntu Server
- `bash`
- `ss` (from `iproute2`, installed by default)
- Optional: `fzf` (for interactive selection)

### Windows (Git Bash)
- Git Bash installed
- ⚠️ Linux version and Windows version differ  
  (this README covers both)

---

## Installation (Ubuntu Server)

### 1. Create the file
```bash
nano ports-tui.sh
```

Paste the script contents, then save (Ctrl + O, Enter, Ctrl + X).

2. Make it executable
chmod +x ports-tui.sh

3. (Optional) Install fzf for interactive selection
sudo apt update
sudo apt install -y fzf

4. Run
./ports-tui.sh

Controls (Ubuntu)
Key	Action
r	Refresh immediately
q	Quit
ENTER	Select a process (requires fzf)
y	Confirm kill

If fzf is not installed, the tool still works — selection is simply disabled.

# Recommended Usage

- Run this alongside:

 -Vite / Next.js / FastAPI dev servers

 - Docker Compose stacks

- Keep it open in a tmux pane or second terminal

- Use r when starting/stopping services

# Why this exists

On dev servers, most open ports are noise.

This tool intentionally:

- Ignores system services

- Focuses on developer workflows

- Refreshes slowly by default

- Avoids visual chaos

It’s meant to be calm, predictable, and useful.

License

MIT — use it, tweak it, steal ideas from it.
