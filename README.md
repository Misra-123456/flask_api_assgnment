# Assignment 1 — Flask REST API

This project implements a small Flask REST API and serves static files. It follows the assignment requirements: a venv, a branch named `Assignment1`, a JSON API endpoint and a `public/` folder for static assets.

## Project checklist (what you must have)
- A Git repository with a `.gitignore` that excludes:
  - `.venv/`
  - `__pycache__/`
  - `.env`
- A branch named `Assignment1` that you used for development and pushed to origin
- A Python virtual environment in the project root (named `.venv`)
- Dependencies installed: `Flask` and `python-dotenv` (and any others you use)
- `app.py` implementing the Flask app and an endpoint `GET /api/v1/cat`
- A `public/` folder with a sample image (served via Flask static configuration)
- A pinned `requirements.txt` produced with the assignment's required command
- The branch `Assignment1` merged into `main` and pushed to origin

---

## Quick setup (Windows / PowerShell)
Run these commands from the project root (`F:\Misra ICT\Fullstack Web devlopment\flask_app\flask-api-assignment`).

1) Create and activate the virtual environment
```powershell
python -m venv .venv
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
.\.venv\Scripts\Activate.ps1
```

2) Install required packages
```powershell
python -m pip install --upgrade pip
python -m pip install Flask python-dotenv
```

3) Run the app (development, auto-reload via Flask CLI)
```powershell
$env:FLASK_APP = 'app.py'
flask run --host 127.0.0.1 --port 3000
```
Or run directly (no auto-reload):
```powershell
python app.py
```

4) Verify endpoints and static file
```powershell
# API
Invoke-RestMethod -Uri http://127.0.0.1:3000/api/v1/cat
# Static file
Invoke-WebRequest -Uri http://127.0.0.1:3000/public/cat.svg -OutFile .\cat.svg
```

---

## Endpoint specification (required)
- GET /api/v1/cat
  - Returns a JSON object with these fields:
    - `cat_id` (string)
    - `name` (string)
    - `birthdate` (string)
    - `weight` (number)
    - `owner` (string)
    - `image` (string) — URL or static path (e.g. `/public/cat.svg`)

Example response:
```json
{
  "cat_id": "650f1a2b3c4d5e6f7a8b9c0d",
  "name": "Whiskers",
  "birthdate": "2020-04-15",
  "weight": 4.2,
  "owner": "6512b3c4d5e6f7a8b9c0d1e",
  "image": "/public/cat.svg"
}
```

---

## Git workflow (how the assignment should be submitted)
1. Create and switch to the assignment branch:
```powershell
git checkout -b Assignment1
```
2. Work, add and commit regularly:
```powershell
git add .
git commit -m "Assignment1: <short description>"
```
3. Push the branch to the remote:
```powershell
git push -u origin Assignment1
```
4. When finished, create a Pull Request or merge locally and push `main`:
```powershell
git checkout main
git pull origin main
git merge --no-ff Assignment1 -m "Merge Assignment1"
git push origin main
```

---

## Freezing dependencies (assignment requires this exact format)
After you've installed packages into the venv, create `requirements.txt` with:

```powershell
pip list --not-required --format freeze > requirements.txt
```

This lists top-level packages only (not sub-dependencies) as required by the assignment.

Commit and push the updated `requirements.txt`:
```powershell
git add requirements.txt
git commit -m "Update requirements.txt"
git push origin Assignment1
```

---

## Serving static files
Your Flask app is configured to serve files from the `public/` directory. Place an image there (for example `public/cat.svg`) and verify it at:

```
http://127.0.0.1:3000/public/cat.svg
```

In `app.py` the Flask application should be created like this to serve `public/` at `/public`:
```python
app = Flask(__name__, static_folder='public', static_url_path='/public')
```

---

## Tests
A small test harness `test_api.py` is included. Install `requests` in the venv and run it while the app is running:
```powershell
pip install requests
python test_api.py
```

---

## Deployment (short)
You can deploy to Metropolia ecloud either with Docker (recommended) or with systemd+gunicorn+nginx. A `deploy` branch contains example `Dockerfile`, `docker-compose.yml`, a systemd unit and an nginx site file plus a helper `deploy_server.sh`.

To run the Docker deploy on your VM (via Metropolia shell host):
```bash
ssh -J misrapas@shell.metropolia.fi misrapas@<server-ip> 'bash -s' <<'BASH'
# (example script: installs docker, clones repo deploy branch, builds image and runs container)
BASH
```

If you want a step-by-step deploy script (systemd/nginx) or a Docker one-shot I can provide the exact commands. If you have a domain and want HTTPS, say so and I'll add Certbot/nginx instructions.

---

## Notes / best practices
- Do not commit `.venv/` (it's in `.gitignore`).
- Use `.env` and `python-dotenv` for local configuration and secrets; do not commit `.env`.
- Use gunicorn in production behind nginx; do not use the Flask development server for public deployment.

---

If you'd like, I can now:
- Add HTTPS/nginx instructions and a Certbot command (if you have a domain), or
- Run the Docker one-shot on your server (I will need the server IP and sudo access confirmation), or
- Create a short PR from the `deploy` branch into `main` with the deployment files.

Tell me which of the above you want next.