# Admin Notes

This build now includes a simple **sitewide admin panel** at `/admin`.

## How admin bootstrap works
- On a clean install, the **first registered account becomes the first admin automatically**.
- After that, admins can promote or demote other accounts from the admin panel.
- You can also predefine admin usernames by adding an `adminUsernames` array in `data/site.json` or by setting `ADMIN_USERNAMES` in the environment as a comma-separated list.

## What the admin panel covers
- sitewide account moderation
- promote/demote admin
- mute/unmute account
- ban/unban account
- comment deletion
- live room player/feed visibility

## What mute and ban do
- **Mute** blocks room chat and site comments.
- **Ban** blocks sign-in and kicks the account out of normal site use on the next request.

## Safety notes
- The panel stops you from banning, muting, or demoting your own currently signed-in admin account from the UI.
- This admin system is intentionally simple and server-rendered so it is easy to test and maintain.
