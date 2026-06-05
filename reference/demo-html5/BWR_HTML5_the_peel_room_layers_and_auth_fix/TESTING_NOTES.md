# Testing notes

Recommended flow:

1. Start the server with `npm start` or `node server.mjs`.
2. Open `http://localhost:3000`.
3. Register a fresh mirror account.
4. Save a weevil in **Weevil Studio**.
5. Enter the **Single Room Chat**.
6. Log out.
7. Log back in and confirm the account lands back in the room once a weevil has already been saved.

Additional checks:

- Open `/news` and confirm the mirror post **Weevil Studio and Single Room Chat Demo** appears in the feed.
- Open `/hall-of-shame` and confirm the draft cards for Bubswig, chelskisummers, Alioth, and MistyDayz are present.
- Open `/robots.txt` and `/.well-known/security.txt` to confirm the crawl/security files are being served.

Notes:

- This remains a simple single-room MVP.
- Room state is still in memory only.
- Chat history and room positions reset when the server restarts.
- `robots.txt`, `X-Robots-Tag`, and the added headers are set for friend-testing / soft-live use, not as a substitute for a full production security review.


## Admin panel
- On a clean install, the first registered account becomes the first admin automatically.
- Visit `/admin` after signing in with that first account.
- The panel is sitewide, not just for the room.
