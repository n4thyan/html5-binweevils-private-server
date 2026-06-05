# VPS and Cloudflare deployment notes

## Recommended pattern

Use Cloudflare in front of the VPS and keep the Node app bound to localhost.

Recommended order:
1. Point the domain at Cloudflare
2. Proxy the DNS record through Cloudflare
3. Run the Node app on `127.0.0.1:3000`
4. Use Cloudflare Tunnel or a reverse proxy on the VPS
5. Only enable `SESSION_COOKIE_SECURE=true` and `ENABLE_HSTS=true` once HTTPS is working properly

## Suggested production env

```env
NODE_ENV=production
PORT=3000
PUBLIC_BASE_URL=https://your-domain.example
TRUST_PROXY=true
SESSION_COOKIE_SECURE=true
ALLOW_FIRST_USER_ADMIN=false
ADMIN_USERNAMES=youradminname
ENABLE_HSTS=true
```

## Cloudflare tips

- proxy the DNS record, do not leave the origin exposed if you can avoid it
- rate-limit `/login`, `/register`, and interactive room/game endpoints in Cloudflare too
- keep the origin firewall as tight as possible
- if you use Cloudflare Tunnel, keep the Node app on localhost only

## App-side limits included

This build already rate-limits:
- sign-in
- sign-up
- profile saves
- room move/chat/map actions
- avatar saves
- Find4 actions
- admin actions
- comments

These are in-memory limits. They are useful for a small live test, but Cloudflare should still be your front-line protection.
