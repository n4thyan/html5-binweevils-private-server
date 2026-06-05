# Stage 1 migration report

## 1) Concise migration plan

1. Keep **BW Find4 / mirror** as the main website shell for login, account, news, navigation, and page framing.
2. Replace the old creator/editor entry points with the newer **HTML5 weevil creator** by hosting it as a same-origin sub-app under `/weevil-creator/`.
3. Change `/register` from a legacy form into a creator-host page that embeds the HTML5 creator in **register mode**.
4. Change `/weevil-studio` into the same creator-host page in **logged-in edit mode**, loading the signed-in user’s saved avatar without a second auth prompt.
5. Add creator-focused APIs so the creator can:
   - register + create the first weevil in one request
   - fetch the current signed-in avatar/session state
   - save edits back into the signed-in account
6. Keep legacy room/chat/stream code isolated and unreferenced for this stage; do not expand gameplay/realtime yet.
7. Introduce small service-layer modules for creator payload validation and session bootstrap so the next phase can move toward a WebSocket-ready backend cleanly.

## 2) Exact files created / edited / removed

### Edited
- `server.mjs`
- `lib/render.mjs`

### Created
- `lib/services/creator-service.mjs`
- `lib/services/session-state.mjs`
- `public/css/creator-shell.css`
- `public/js/creator-host.js`
- `public/weevil-creator/**` copied from `weevil_html5_project_main_with_hats_stable_hat_alignment/demo/**`
- `MIGRATION_STAGE1.patch`
- `MIGRATION_STAGE1_REPORT.md`

### Legacy code isolated but left in place for now
- `public/js/avatar-studio/**`
- `public/css/avatar-studio.css`
- room / stream / Find4 code paths in `server.mjs`

### Removed
- none in this stage; legacy creator/editor code is **unreferenced** rather than physically deleted.

## 3) What now works end-to-end

- `/login` → mirror-site login still uses the BW shell
- `/profile` → account page still uses the BW shell, but now points to the new HTML5 creator flow
- `/news` and news posts → unchanged BW shell/content flow
- `/register` → now opens the HTML5 creator as the **actual registration + character creation** flow
- `/weevil-studio` → now opens the same HTML5 creator in **edit mode** for signed-in users
- `/api/register-with-creator` → creates account + initial weevil + session in one step
- `/api/me/avatar` → loads/saves the signed-in creator state
- `/api/session` → session/bootstrap contract for future service/realtime work

## Route / API notes

### New / repurposed page flow
- `GET /register` → creator-host page in `mode=register`
- `GET /weevil-studio` → creator-host page in `mode=edit`

### New APIs
- `GET /api/session`
- `POST /api/register-with-creator`

### Extended API
- `GET /api/me/avatar`
- `POST /api/me/avatar`

## Storage notes

Avatar records now preserve:
- `weevilDef`
- `expression`
- `proboscis`
- `hatId`
- `hatColour`
- `preferredRenderer`

## Integration notes

- BW Find4 remains the outer shell and site framework.
- The HTML5 creator is mounted as a same-origin sub-app under `public/weevil-creator/`.
- The creator iframe uses same-origin cookies and the new creator APIs, so edit mode does **not** require another login prompt.
- Legacy room / stream systems are still present in code but are no longer part of the main registration / account / creator flow for this phase.
