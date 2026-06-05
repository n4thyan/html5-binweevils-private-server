# Bin Weevils Rewritten Mirror

A cleaned, testable mirror-site build with local accounts, Weevil Studio, the single-room chatroom, admin tools, Find4, map switching, and a VPS/Cloudflare hardening pass.

## What this build is

This website is a separate fan-run mirror/community site. It is not the main game service and it does not sign players into the game client.

Mirror accounts are only for this website's features, including:
- profiles
- comments
- Weevil Studio
- room chat
- admin tools
- Find4

## Run locally

```bash
npm install
npm start
```

Then open `http://localhost:3000`.

## Important routes

- `/register`
- `/login`
- `/weevil-studio`
- `/room`
- `/admin`
- `/news`
- `/hall-of-shame`

## Production and VPS notes

This build now includes a basic hardening pass for moving onto a VPS behind Cloudflare.

### Recommended setup

- Keep the Node app listening on localhost only
- Put Cloudflare in front of the domain
- Prefer Cloudflare Tunnel or a reverse proxy like Caddy/Nginx on the VPS
- Enable HTTPS before turning on secure cookies and HSTS

### Environment variables

See `.env.example`. The most important ones are:

- `PUBLIC_BASE_URL`
- `NODE_ENV`
- `TRUST_PROXY`
- `SESSION_COOKIE_SECURE`
- `ALLOW_FIRST_USER_ADMIN`
- `ADMIN_USERNAMES`
- `ENABLE_HSTS`

### Admin bootstrap

For public deployment, do not rely on the old local-testing pattern where the first user automatically becomes admin.

Safer options:
- set `ADMIN_USERNAMES` before first launch on the VPS
- or set `ALLOW_FIRST_USER_ADMIN=false` and manually decide who should be admin

### What was hardened in this pass

- secure-cookie support for production
- stricter response headers
- same-origin checks on state-changing POST requests
- app-side in-memory rate limiting for login, register, room actions, avatar saves, comments, Find4 actions, and admin actions
- docs for VPS/Cloudflare deployment

## Quick checks

- register a mirror account
- save a weevil in `/weevil-studio`
- enter `/room`
- verify chat/movement/map switching still work
- verify `/admin` only appears for admin users

## Storage

This project still uses local JSON files in `data/`. That is fine for friend testing, but you should back them up regularly once it is live on a VPS.
