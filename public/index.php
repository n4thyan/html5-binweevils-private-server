<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>HTML5 Bin Weevils - Nest Hall Demo</title>
  <link rel="stylesheet" href="./src/client/room/room.css">
</head>
<body>
  <main class="bw-shell" aria-label="HTML5 Bin Weevils room demo">
    <header class="bw-topbar">
      <div>
        <strong id="roomTitle">Nest Hall</strong>
        <span id="roomSubtitle">Milestone 003 fixed-camera room slice</span>
      </div>
      <div class="bw-status" id="roomStatus">Loading room data...</div>
    </header>

    <section class="bw-stage-wrap">
      <canvas id="roomCanvas" width="960" height="600" aria-label="Room canvas"></canvas>
    </section>

    <form class="bw-chat" id="chatForm" autocomplete="off">
      <input id="chatInput" type="text" maxlength="120" placeholder="Click the room to walk. Type to chat..." aria-label="Chat message">
      <button type="submit">Send</button>
    </form>

    <details class="bw-debug">
      <summary>Debug</summary>
      <pre id="debugOutput"></pre>
    </details>
  </main>

  <script type="module" src="./src/client/room/main.js"></script>
</body>
</html>