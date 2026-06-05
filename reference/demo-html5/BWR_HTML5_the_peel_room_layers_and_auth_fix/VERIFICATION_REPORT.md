# Verification report

Checked on the hardened pass before packaging:

- local register flow still works
- `/room` still blocks access until an avatar is saved
- `/api/me/avatar` still saves a valid compact weevil payload
- `/room` loads after avatar save
- same-origin protection blocks a cross-origin avatar save attempt
- room chat rate limiting trips after repeated spam requests
- in production mode, the session cookie becomes `Secure` and uses the `__Host-` prefix
- in production mode with `ALLOW_FIRST_USER_ADMIN=false`, the first registered account is not auto-promoted to admin
