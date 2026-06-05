import { getPublicRoomConfig, getRoomDefinition } from './room-data.mjs';
function escapeHtml(value = '') {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function formatLongDate(value) {
  if (!value) return '';
  const date = new Date(`${value}T12:00:00Z`);
  return date.toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'UTC' });
}

function formatShortDate(value) {
  if (!value) return '';
  const date = new Date(`${value}T12:00:00Z`);
  return date.toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric', timeZone: 'UTC' });
}

function slugPath(slug) {
  return `/news/${encodeURIComponent(slug)}`;
}

function asset(path) {
  return `/mirror-src/official-mirror/${path}`;
}

function siteLogoSmall() {
  return asset('binweevils.app/assetsHome/images/logo2.png__ver=1');
}

function siteLogoLarge() {
  return asset('binweevils.app/assetsHome/images/logoLarge.png__ver=1');
}

function localiseHtml(html = '') {
  return String(html)
    .replaceAll('https://news.binweevils.app/assets/', '/mirror-src/official-mirror/news.binweevils.app/assets/')
    .replaceAll('https://binweevils.app/assets/', '/mirror-src/official-mirror/binweevils.app/assets/')
    .replaceAll('https://binweevils.app/assetsHome/', '/mirror-src/official-mirror/binweevils.app/assetsHome/')
    .replaceAll('https://play.binweevils.app/assets/', '/mirror-src/official-mirror/play.binweevils.app/assets/')
    .replaceAll('https://cdn.binweevils.app/images/', '/mirror-src/official-mirror/cdn.binweevils.app/images/')
    .replaceAll('src="/assets/', 'src="/mirror-src/official-mirror/news.binweevils.app/assets/')
    .replaceAll("src='/assets/", "src='/mirror-src/official-mirror/news.binweevils.app/assets/")
    .replaceAll('href="/assets/', 'href="/mirror-src/official-mirror/news.binweevils.app/assets/')
    .replaceAll("href='/assets/", "href='/mirror-src/official-mirror/news.binweevils.app/assets/");
}

function shell({ title, bodyClass = '', styles = [], body = '', scripts = [], moduleScripts = [] }) {
  const headStyles = styles.map((href) => `<link rel="stylesheet" href="${href}">`).join('\n');
  const bodyScripts = scripts.map((src) => `<script src="${src}" defer></script>`).join('\n');
  const bodyModuleScripts = moduleScripts.map((src) => `<script type="module" src="${src}"></script>`).join('\n');
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow, noarchive, nosnippet, noimageindex">
<meta name="googlebot" content="noindex, nofollow, noarchive, nosnippet, noimageindex">
<title>${escapeHtml(title)}</title>
<link rel="icon" href="${asset('binweevils.app/icon.ico')}">
<link rel="stylesheet" href="/css/app.css">
${headStyles}
</head>
<body class="${escapeHtml(bodyClass)}">
${body}
${bodyScripts}
${bodyModuleScripts}
</body>
</html>`;
}

function topMenu(user) {
  return `
<div class="menu">
  <div class="menuBar">
    <img src="${asset('binweevils.app/assets/nav/images/GreenBar.png__ver=1')}" alt="">
    <div class="welcomeMembership"><a href="/downloads"><img src="${asset('binweevils.app/assets/nav/images/download-up.png')}" alt="Download"></a></div>
    <div class="welcomeWhatsnew"><a href="/community"><img src="${asset('binweevils.app/assets/nav/images/discord-up.png')}" alt="Community"></a></div>
    <div class="welcomeHelp"><a href="/news"><img src="${asset('binweevils.app/assets/nav/images/whatsNew-up.png')}" alt="News"></a></div>
    <div class="welcomeShop"><a href="/about"><img src="${asset('binweevils.app/assets/nav/images/help-up.png')}" alt="About"></a></div>
  </div>
  ${user?.isAdmin ? '<div class="mirror-admin-top-link"><a href="/admin">Admin</a></div>' : ''}
  <div class="welcomeLogin"><a href="${user ? '/profile' : '/login'}"><img src="${asset('binweevils.app/assets/nav/images/loginBtn-up.png')}" alt="${user ? 'Profile' : 'Login'}"></a></div>
  <div class="welcomeNewWeevil"><a href="${user ? '/logout' : '/register'}"><img src="${asset('binweevils.app/assets/nav/images/createWeevil-up.png')}" alt="${user ? 'Logout' : 'Register'}"></a></div>
</div>`;
}

function siteHeader(user, compact = false) {
  return `
<div class="wrapper">
  <div class="container" id="container-header">
    <div class="header">
      <div class="row nav-bar ${compact ? 'compact-bar' : ''}">
        <div class="logo"><a href="/"><img src="${siteLogoSmall()}" alt="Bin Weevils Rewritten"></a></div>
        ${topMenu(user)}
      </div>
    </div>
  </div>
</div>`;
}

function siteFooter() {
  return `
<div class="footer-v1 mirror-footer-wrap">
  <div class="footer">
    <div class="container">
      <div class="row footer-row">
        <div class="col-sm-8 col-xs-12" id="footer-links">
          <ul class="list-unstyled mirror-footer-links">
            <li><a href="/about">About</a></li>
            <li><a class="separator">|</a></li>
            <li><a href="/downloads">Downloads</a></li>
            <li><a class="separator">|</a></li>
            <li><a href="/community">Community</a></li>
            <li><a class="separator">|</a></li>
            <li><a href="/hall-of-shame">Hall of Shame</a></li>
            <li><a class="separator">|</a></li>
            <li><a href="/rules">Rules</a></li>
          </ul>
        </div>
        <div class="col-sm-8 col-xs-12">
          <a class="pull-left footer-ltd" style="float:left">Bin Weevils Rewritten 2026 · a true HTML5 Bin Weevils remake presented in the classic website style</a>
        </div>
      </div>
    </div>
  </div>
</div>`;
}

function flashBox(message, kind = 'info') {
  if (!message) return '';
  return `<div class="mirror-flash mirror-flash-${kind}">${escapeHtml(message)}</div>`;
}


function serialiseDatasetJson(value) {
  return escapeHtml(JSON.stringify(value || {}));
}

function authNotice() {
  return `<div class="mirror-account-note">These Bin Weevils Rewritten accounts power the creator, your profile, saved weevils and website features. The familiar Bin Weevils look remains, but the experience itself is being rebuilt in HTML5.</div>`;
}

function renderHome({ user, posts }) {
  const latest = posts.slice(0, 3).map((post) => `
    <article class="home-news-card">
      <div class="home-news-thumb">${post.thumbnail ? `<img src="${escapeHtml(localiseHtml(post.thumbnail))}" alt="">` : ''}</div>
      <div class="home-news-copy">
        <span class="home-badge ${post.type === 'official' ? 'official' : 'mirror'}">${post.type === 'official' ? 'Archive import' : 'Project update'}</span>
        <h3><a href="${slugPath(post.slug)}">${escapeHtml(post.title)}</a></h3>
        <p>${escapeHtml(formatLongDate(post.publishedAt))}</p>
      </div>
    </article>
  `).join('');

  const accountLine = user
    ? `<div class="home-user-note">Signed in as <strong>${escapeHtml(user.username)}</strong>. Open your <a href="/profile">account</a> or jump straight into the <a href="/weevil-studio?next=%2Fprofile">HTML5 weevil creator</a>.</div>`
    : `<div class="home-user-note">Create an account, build your weevil in the HTML5 creator and save it straight to your profile.</div>`;

  return shell({
    title: 'Bin Weevils Rewritten',
    bodyClass: 'home-page',
    styles: [
      '/mirror-src/official-mirror/binweevils.app/assets/css/welcomeD.css',
      '/css/source-patches.css'
    ],
    body: `
<div class="mainCointainer mirror-home">
  <div class="firstRow">
    <div class="logo"><img src="${siteLogoLarge()}" alt="Bin Weevils Rewritten"></div>
    <div class="menuBg"><img class="navBar" src="${asset('binweevils.app/assetsHome/images/GreenBar.png')}" alt=""></div>
    <div class="menu">
      <div class="topup"><a href="/downloads"><img class="menuBtn" src="${asset('binweevils.app/assets/nav/images/download-up.png')}" alt="Download"></a></div>
      <div class="discord"><a href="/community"><img class="menuBtn" src="${asset('binweevils.app/assets/nav/images/discord-up.png')}" alt="Community"></a></div>
      <div class="whatsNewMenu"><a href="/news"><img class="menuBtn" src="${asset('binweevils.app/assets/nav/images/whatsNew-up.png')}" alt="News"></a></div>
      <div class="helpMenu"><a href="/about"><img class="menuBtn" src="${asset('binweevils.app/assets/nav/images/help-up.png')}" alt="About"></a></div>
    </div>
    <div class="login"><a href="${user ? '/profile' : '/login'}"><img class="clickBtn" src="${asset('binweevils.app/assetsHome/images/Login_Up.png')}" alt="${user ? 'Profile' : 'Login'}"></a></div>
    <div class="createNewBtn"><a href="${user ? '/logout' : '/register'}"><img class="menuBtn" src="${asset('binweevils.app/assetsHome/images/createWeevil-up.png')}" alt="${user ? 'Logout' : 'Register'}"></a></div>
  </div>

  <div class="mainImage mirror-main-hero">
    <img src="${asset('binweevils.app/assetsHome/images/mainImage0.png__ver=1')}" alt="">
    <div class="home-overlay-card">
      <h1>Bin Weevils Rewritten</h1>
      <p>Bin Weevils Rewritten is being rebuilt as a true HTML5 Bin Weevils project. The familiar website look remains for atmosphere, while the creator, account flow and public pages are being rebuilt for a modern browser-first experience.</p>
      <p>This site is now the front door to that rewrite: create or edit your weevil in HTML5, manage your account, download the current build and follow project progress from one consistent place.</p>
      <div class="home-cta-row">
        <a class="mirror-pill" href="/downloads">Downloads</a>
        <a class="mirror-pill mirror-pill-alt" href="/news">Project news</a>
      </div>
      ${accountLine}
    </div>
  </div>

  <div class="playerButtons">
    <div class="newPlayer"><a href="/register"><img class="clickBtn" src="${asset('binweevils.app/assetsHome/images/NewPlayer_Up.png')}" alt="Register with creator"></a></div>
    <div class="returningPlayer"><a href="/login"><img class="clickBtn" src="${asset('binweevils.app/assetsHome/images/ReturningPlayer_Up.png')}" alt="Project sign in"></a></div>
  </div>

  <div class="tabs"><img src="${asset('binweevils.app/assetsHome/images/Three_Image_Panel.png')}" alt=""></div>

  <div class="shopWhatsNew">
    <img src="${asset('binweevils.app/assetsHome/images/ShopWhatsNew_BG.png')}" alt="">
    <div class="whatsNewBlog"><a href="/news"><img class="clickBtn" src="${asset('binweevils.app/assetsHome/images/WhatsNew_Up.png')}" alt="What's New"></a></div>
    <div class="bwDesc">The familiar Bin Weevils shell, rebuilt around an HTML5 creator, saved profiles and project updates.</div>
  </div>

  <section class="home-latest-strip">
    <div class="home-strip-head">
      <h2>Latest project posts</h2>
      <a href="/news">View all</a>
    </div>
    <div class="home-news-grid">
      ${latest}
    </div>
  </section>

  <div class="footer">
    <div class="footerLinks">
      <a href="/about">About</a> |
      <a href="/downloads">Downloads</a> |
      <a href="/community">Community</a> |
      <a href="/hall-of-shame">Hall of Shame</a> |
      <a href="/rules">Rules</a> |
      <a href="/news">News</a>
    </div>
    <div class="copyright">Bin Weevils Rewritten 2026 · a true HTML5 Bin Weevils remake with classic website styling</div>
  </div>
</div>`
  });
}

function renderAuth({ mode, user, message, error, formHtml }) {
  const leftHeading = mode === 'login' ? 'Sign in to your Bin Weevils Rewritten account' : 'Create your Bin Weevils Rewritten account';
  const leftCopy = mode === 'login'
    ? 'Use this sign-in to access the HTML5 creator, your saved weevil, your account page and the main website features. This is the account layer for the rewritten web experience.'
    : 'Registration now happens through the HTML5 creator itself. The classic Bin Weevils styling remains, but the account and character-creation flow now belong to the rewrite.';
  const art = mode === 'login'
    ? asset('binweevils.app/assets/login/images/returning_player.png')
    : asset('binweevils.app/assets/login/images/new_player-up.png');
  const flowLinks = mode === 'login'
    ? `<div class="auth-flow-box"><h2>After you sign in</h2><p>Open the HTML5 creator, update your weevil and save it straight back to your account without any extra login prompts.</p><div class="auth-side-links auth-side-links-stack"><a class="mirror-pill" href="/weevil-studio?next=%2Fprofile">Open creator</a><a class="mirror-pill mirror-pill-alt" href="/profile">Open account</a></div></div>`
    : `<div class="auth-flow-box"><h2>After registration</h2><p>You build your weevil as part of sign-up. There is no separate legacy form and no extra editor step — just one clean HTML5 creator flow.</p></div>`;

  return shell({
    title: mode === 'login' ? 'Bin Weevils Rewritten Login' : 'Bin Weevils Rewritten Register',
    bodyClass: 'auth-page',
    styles: [
      '/mirror-src/official-mirror/binweevils.app/assets/login/css/login.css__ver=1',
      '/css/source-patches.css'
    ],
    body: `
<div class="leftBg">
  <div id="mainContainer" class="auth-main">
    <div class="logo"><a href="/"><img src="${siteLogoSmall()}" alt=""></a></div>
    ${topMenu(user)}
    <div class="mainContainer mirror-login-shell">
      <div class="tinkClott"><img src="${asset('binweevils.app/assets/login/images/Tink_Clott.png')}" alt=""></div>
      <div class="download-section">
        <h1>${escapeHtml(leftHeading)}</h1>
        <p class="auth-intro">${escapeHtml(leftCopy)}</p>
        ${authNotice()}
        <div class="auth-side-links">
          <a class="mirror-pill" href="/downloads">Downloads</a>
          <a class="mirror-pill mirror-pill-alt" href="/news">Rewrite posts</a>
        </div>
        ${flowLinks}
        <div class="discord auth-side-box">
          <h2>Project focus</h2>
          <p>Bin Weevils Rewritten uses the familiar classic site styling as a shell, but the real goal is an HTML5-native project: creator, account flow, saved weevils, web pages and future game systems built around modern web technology.</p>
        </div>
      </div>
      <div class="newWeevil">
        <img class="newPlayer" src="${mode === 'login' ? asset('binweevils.app/assets/login/images/new_player-up.png') : asset('binweevils.app/assets/login/images/returning_player.png')}" width="70%" alt="">
      </div>
      <div class="loginForm">
        <div class="heading"><img height="80" src="${art}" alt=""></div>
        ${flashBox(error, 'error')}
        ${flashBox(message, 'success')}
        ${formHtml}
      </div>
    </div>
    <div class="bushes"><img src="${asset('binweevils.app/assets/login/images/Bottom_bushes.png')}" alt=""></div>
    <div class="footer">
      <div class="footerLinks">
        <a href="/about">About</a> |
        <a href="/downloads">Downloads</a> |
        <a href="/community">Community</a> |
        <a href="/rules">Rules</a>
        <br><span>Bin Weevils Rewritten 2026 · website accounts for the HTML5 Bin Weevils remake</span>
      </div>
    </div>
  </div>
</div>`
  });
}

function pagePanelLayout({ user, title, intro = '', sidebarTitle = 'Bin Weevils Rewritten', sidebar = '', content = '', styles = [], scripts = [], moduleScripts = [], bodyClass = 'panel-page' }) {
  return shell({
    title,
    bodyClass,
    styles: ['/css/source-patches.css', ...styles],
    body: `
${siteHeader(user, true)}
<div class="under-container-content">
  <div class="container white-content mirror-panel-page" id="container-content">
    <div class="container-content-pages">
      <h1 class="big-heading big-heading-blue align-center">${escapeHtml(title)}</h1>
      ${intro ? `<p class="panel-intro">${escapeHtml(intro)}</p>` : ''}
      <div class="panel-grid">
        <aside class="panel-sidebar">
          <h2>${escapeHtml(sidebarTitle)}</h2>
          ${sidebar}
        </aside>
        <main class="panel-main">
          ${content}
        </main>
      </div>
    </div>
  </div>
</div>
${siteFooter()}`,
    scripts,
    moduleScripts
  });
}

function sidebarNav(user) {
  return `
<nav class="mirror-side-nav">
  <a href="/downloads">Downloads</a>
  <a href="/news">News</a>
  <a href="/community">Community</a>
  <a href="/room">The Peel</a>
  <a href="/weevil-studio?next=%2Fprofile">Weevil Studio</a>
  ${user ? '<a href="/profile">Account</a>' : '<a href="/register">Register</a>'}
  ${user?.isAdmin ? '<a href="/admin">Admin</a>' : ''}
  <a href="/hall-of-shame">Hall of Shame</a>
  <a href="/about">About</a>
  <a href="/rules">Rules</a>
  <a href="${user ? '/logout' : '/login'}">${user ? 'Logout' : 'Login'}</a>
</nav>`;
}

function renderDownloads({ user, site }) {
  const buttons = Object.entries(site.downloads || {}).map(([key, item]) => `
    <a class="download-btn mirror-download-btn ${key}" href="${escapeHtml(item.url)}" target="_blank" rel="noopener">
      <span class="download-btn-label">${escapeHtml(item.label)}</span>
      <strong>Download</strong>
    </a>`).join('');

  const content = `
<section class="downloads-grid">
  ${buttons}
</section>
<section class="info-box">
  <h2>About this page</h2>
  <p>This download page sits at the centre of the Bin Weevils Rewritten website flow. It keeps the familiar Bin Weevils look while presenting the current build, the creator and the wider project as one coherent HTML5 remake.</p>
  <ul>
    <li>The current build is listed here first, not hidden away behind scattered links.</li>
    <li>Your website account, saved weevil and project news all connect back to the same site.</li>
    <li>The aim is to make the remake feel like one project rather than a collection of separate tools.</li>
  </ul>
</section>
<section class="info-box">
  <h2>Current version</h2>
  <p><strong>${escapeHtml(site.clientVersion || '1.0.4')}</strong></p>
  <p>This section highlights the current public build. Over time it can expand with changelogs, checksums, platform notes and milestone releases as the project grows.</p>
</section>
<section class="info-box">
  <h2>Install guidance</h2>
  <p>Download the build for your platform, install it, and use the website alongside it for news, account tools and the HTML5 creator/editor flow.</p>
</section>
<section class="info-box">
  <h2>What this page is becoming</h2>
  <p>This page is part of a broader HTML5 Bin Weevils remake. The classic website theme remains as the visual shell, while the project itself is focused on rebuilding the creator, accounts and public web flow properly.</p>
</section>`;

  return pagePanelLayout({
    user,
    title: 'Downloads',
    intro: 'Classic Bin Weevils styling outside, HTML5 project tools underneath.',
    sidebarTitle: 'Downloads',
    sidebar: sidebarNav(user) + `<div class="sidebar-note">This familiar website shell now fronts the HTML5 creator, account flow and project pages for Bin Weevils Rewritten.</div>`,
    content
  });
}

function renderCommunity({ user }) {
  const content = `
<section class="info-box">
  <h2>What this page is for</h2>
  <p>This community space now revolves around Bin Weevils Rewritten itself: project posts, saved weevils, account pages, creator access and the first public-facing web systems.</p>
</section>
<section class="info-box">
  <h2>Account guide</h2>
  <ul>
    <li><strong>Website account:</strong> used for the HTML5 creator, saved weevils, news comments and account pages.</li>
    <li><strong>Creator flow:</strong> the same tool now handles both first-time registration and returning-player editing.</li>
  </ul>
  <p>The aim is one coherent website flow, even while the wider project keeps evolving.</p>
</section>
<section class="info-box">
  <h2>Project identity</h2>
  <p>The goal is to feel recognisably Bin Weevils while clearly standing as a modern HTML5 remake: a proper creator, clean account flow, project news and room for future systems.</p>
</section>
<section class="info-box">
  <h2>Archive pages</h2>
  <p>There is also a separate <a href="/hall-of-shame">Hall of Shame</a> page for archived community write-ups. It remains a side archive rather than the main identity of the project.</p>
</section>
<section class="info-box">
  <h2>Current scope</h2>
  <p>The site is already centred on the creator and account flow. Realtime rooms and other systems can expand later, but the project now has a clear HTML5-first front door.</p>
</section>`;

  return pagePanelLayout({
    user,
    title: 'Community',
    intro: 'Community pages for the HTML5 Bin Weevils remake, presented in the familiar classic shell.',
    sidebarTitle: 'Community',
    sidebar: sidebarNav(user),
    content
  });
}

function renderAbout({ user }) {
  const content = `
<section class="info-box">
  <h2>What Bin Weevils Rewritten is</h2>
  <p>Bin Weevils Rewritten is presented here as a true HTML5 remake. The visual shell deliberately echoes the classic website, while the project itself focuses on a rebuilt creator, account flow and public web stack.</p>
  <p>This is no longer framed as a simple archive with old assets dropped into place. The website itself is intended to feel like part of the remake.</p>
</section>
<section class="info-box">
  <h2>What that means in practice</h2>
  <ul>
    <li>the website keeps the classic Bin Weevils look for familiarity</li>
    <li>the creator/editor flow is HTML5 and now acts as the main account-facing weevil tool</li>
    <li>account pages, registration and editing are all built around that creator</li>
    <li>older creator/editor ideas are being phased out rather than treated as the final goal</li>
  </ul>
</section>
<section class="info-box">
  <h2>Why this direction matters</h2>
  <p>It gives the project a cleaner identity: not just preserving familiar-looking pages, but rebuilding the weevil creator, account tools and public-facing web flow in HTML5.</p>
</section>
<section class="info-box">
  <h2>What changed</h2>
  <p>Downloads, news, account tools and the creator now read as one coherent website. The classic shell is still there for atmosphere, but the messaging now clearly presents Bin Weevils Rewritten as an HTML5 project.</p>
</section>`;

  return pagePanelLayout({
    user,
    title: 'About',
    intro: 'Built to feel recognisably Bin Weevils while clearly presenting the project as a genuine HTML5 remake.',
    sidebarTitle: 'About',
    sidebar: sidebarNav(user),
    content
  });
}

function renderRules({ user }) {
  const content = `
<section class="info-box">
  <h2>Keep it respectful</h2>
  <ul>
    <li>do not spam</li>
    <li>do not start arguments for the sake of it</li>
    <li>do not post abusive, hateful or inappropriate content</li>
    <li>do not impersonate other people</li>
    <li>do not share personal information</li>
  </ul>
</section>
<section class="info-box">
  <h2>What these rules are for</h2>
  <p>These are the rules for the Bin Weevils Rewritten website and its community features. They are kept clear and straightforward so the site stays welcoming and easy to understand.</p>
</section>
<section class="info-box">
  <h2>Comments and accounts</h2>
  <p>Use comments and account tools sensibly. Your website account powers the HTML5 creator and profile flow, so treat it as your project identity on the site.</p>
</section>`;

  return pagePanelLayout({
    user,
    title: 'Rules',
    intro: 'Straightforward rules for the Bin Weevils Rewritten website and its community features.',
    sidebarTitle: 'Rules',
    sidebar: sidebarNav(user),
    content
  });
}

function renderProfile({ user, comments, message, error }) {
  const recent = comments.slice(0, 8).map((comment) => `
    <li>
      <a href="${slugPath(comment.postSlug)}">${escapeHtml(comment.postTitle)}</a>
      <span>${escapeHtml(formatLongDate(comment.createdAt.slice(0, 10)))}</span>
    </li>`).join('');
  const avatarRecord = user.avatar || {};
  const avatarReady = Boolean(user.avatarConfigured || user.avatarUpdatedAt);
  const nextStudioHref = '/weevil-studio?next=%2Fprofile';
  const content = `
    ${flashBox(error, 'error')}
    ${flashBox(message, 'success')}
    <section class="info-box mirror-profile-hero">
      <div class="mirror-profile-hero-main">
        <h2>${escapeHtml(user.username)}</h2>
        <p><strong>Joined:</strong> ${escapeHtml(formatLongDate(user.createdAt.slice(0, 10)))}</p>
        <div class="mirror-flow-note">
          <h3>Account → creator flow</h3>
          <p><strong>1.</strong> Sign in. <strong>2.</strong> Open the HTML5 creator. <strong>3.</strong> Save your weevil back to your Bin Weevils Rewritten account.</p>
          <p>${avatarReady ? 'Your HTML5 weevil is already saved and ready to edit in place.' : 'You have not saved a weevil yet, so your account still needs its first creator save.'}</p>
        </div>
        <form method="post" action="/profile" class="profile-form">
          <label for="bio">Profile note</label>
          <textarea id="bio" name="bio" rows="5" maxlength="500" placeholder="Write a short note for your Bin Weevils Rewritten profile.">${escapeHtml(user.bio || '')}</textarea>
          <button type="submit" class="mirror-pill">Save profile</button>
        </form>
      </div>
      <aside class="mirror-profile-avatar-box profile-avatar-summary">
        <div class="profile-weevil-preview-card">
          <div class="profile-weevil-preview" data-profile-weevil-preview data-avatar-record="${serialiseDatasetJson(avatarRecord)}" aria-label="Saved weevil preview">
            <canvas width="220" height="220"></canvas>
          </div>
          <p class="profile-weevil-preview-copy">Your latest saved weevil appears here as your account avatar preview.</p>
        </div>
        <h3>Saved creator data</h3>
        <dl>
          <dt>Weevil def</dt><dd>${escapeHtml(String(avatarRecord.weevilDef || 'Not saved yet'))}</dd>
          <dt>Expression</dt><dd>${escapeHtml(String(avatarRecord.expression ?? 0))}</dd>
          <dt>Proboscis</dt><dd>${escapeHtml(String(avatarRecord.proboscis ?? 0))}</dd>
          <dt>Hat</dt><dd>${escapeHtml(String(avatarRecord.hatId ?? 0))}</dd>
          <dt>Hat colour</dt><dd>${escapeHtml(String(avatarRecord.hatColour ?? avatarRecord.hatColor ?? 'n/a'))}</dd>
          <dt>Saved</dt><dd>${user.avatarUpdatedAt ? escapeHtml(formatLongDate(user.avatarUpdatedAt.slice(0, 10))) : 'Not saved yet'}</dd>
        </dl>
        <p class="panel-intro">This account uses the HTML5 creator as the source of truth for weevil creation and editing.</p>
        <div class="mirror-pill-row"><a class="mirror-pill" href="${nextStudioHref}">${avatarReady ? 'Edit my weevil' : 'Create your weevil'}</a><a class="mirror-pill mirror-pill-alt" href="/room">Enter The Peel</a></div>
      </aside>
    </section>
    <section class="info-box">
      <h2>Recent comments</h2>
      ${recent ? `<ul class="recent-comments-list">${recent}</ul>` : `<p>No comments have been posted yet.</p>`}
    </section>
  `;

  return pagePanelLayout({
    user,
    title: 'My Account',
    intro: 'Your Bin Weevils Rewritten account lives here, with the HTML5 creator linked directly to your saved session.',
    sidebarTitle: 'My Account',
    sidebar: sidebarNav(user) + `<div class="sidebar-note">Signed in as <strong>${escapeHtml(user.username)}</strong> · creator account active · <a href="/logout">log out</a></div>`,
    content,
    styles: ['/css/creator-shell.css'],
    moduleScripts: ['/js/profile-weevil-preview.js']
  });
}

function renderWeevilStudio({ user, message = '', error = '', nextPath = '/profile', mode = 'edit' }) {
  const isRegister = mode === 'register';
  const framePath = `/weevil-creator/index.html?mode=${isRegister ? 'register' : 'edit'}&next=${encodeURIComponent(nextPath || '/profile')}`;
  const content = `
    ${flashBox(error, 'error')}
    ${flashBox(message, 'success')}
    <div class="creator-shell-wrap">
      <section class="creator-flow-card">
        <h2>${isRegister ? 'Register through the HTML5 creator' : 'Edit my weevil'}</h2>
        <p>${isRegister
          ? 'The old registration form has been replaced. The HTML5 creator now handles account creation and first-time weevil design for new Bin Weevils Rewritten accounts.'
          : 'The old editor has been replaced. This HTML5 creator now edits the weevil already attached to your signed-in Bin Weevils Rewritten account.'}</p>
      </section>
      <section class="creator-frame-shell">
        <iframe class="creator-frame" data-creator-frame src="${framePath}" title="Weevil Studio"></iframe>
      </section>
    </div>
  `;

  return pagePanelLayout({
    user,
    title: isRegister ? 'Register' : 'Weevil Studio',
    intro: isRegister
      ? 'The classic Bin Weevils shell stays in place while the HTML5 creator now handles registration and weevil creation.'
      : 'This creator runs inside the site account/session shell and saves directly back to your logged-in Bin Weevils Rewritten account.',
    sidebarTitle: isRegister ? 'Register' : 'Creator',
    sidebar: sidebarNav(user) + `<div class="sidebar-note creator-sidebar-note">${isRegister
      ? 'Create your account and your weevil in one HTML5 flow. There is no separate legacy registration form any more.'
      : `Signed in as <strong>${escapeHtml(user?.username || '')}</strong>. The creator loads your saved session state directly.`}</div>`,
    content,
    styles: ['/css/creator-shell.css'],
    scripts: ['/js/creator-host.js'],
    bodyClass: 'panel-page weevil-studio-page'
  });
}

function renderRoom({ user, message = '', error = '' }) {
  const roomConfig = getPublicRoomConfig();
  const initialRoom = getRoomDefinition(user.lastRoomId || roomConfig.defaultRoomId);
  const content = `
    ${flashBox(error, 'error')}
    ${flashBox(message, 'success')}
    <div id="mirrorRoomApp" class="mirror-room-app" data-current-user-id="${escapeHtml(user.id)}" data-room-name="${escapeHtml(initialRoom.name)}" data-room-background="${escapeHtml(initialRoom.backgroundPath)}" data-room-floor="${escapeHtml(initialRoom.floorPath || initialRoom.backgroundPath)}" data-room-foreground="${escapeHtml(initialRoom.foregroundPath || '')}" data-room-bounds='${serialiseDatasetJson(initialRoom.bounds)}' data-world-width="1024" data-world-height="640">
      <div class="mirror-room-shell">
        <div class="mirror-room-stage-wrap">
          <div class="mirror-room-stage" data-room-stage>
            <img class="mirror-room-floor" data-room-floor-img src="${escapeHtml(initialRoom.floorPath || initialRoom.backgroundPath)}" alt="" aria-hidden="true">
            <div class="mirror-room-world">
              <div class="mirror-room-stage-overlay">
                <div class="mirror-room-status" data-room-status>Connecting to The Peel...</div>
                <div class="mirror-room-stage-copy">The Peel is the first live HTML5 room test. Click anywhere on the floor to move your saved weevil, talk below to test bubbles and live updates, and use the left and right arrow keys to rotate the room camera.</div>
              </div>
              <div class="mirror-room-players" data-room-players></div>
              <img class="mirror-room-foreground" data-room-foreground-img src="${escapeHtml(initialRoom.foregroundPath || '')}" alt="" aria-hidden="true">
            </div>
          </div>
        </div>
        <section class="mirror-room-card mirror-room-chat-card">
          <form class="mirror-room-chat-form" data-room-chat-form>
            <label class="mirror-room-chat-label" for="roomChatInput">Room chat</label>
            <div class="mirror-room-chat-row">
              <input id="roomChatInput" name="message" type="text" maxlength="160" autocomplete="off" placeholder="Say something in The Peel...">
              <button type="submit" class="mirror-pill">Send</button>
            </div>
            <div class="mirror-room-chat-help" data-room-chat-help>Chat is live in The Peel. Click the room to move, talk below, and use the left and right arrow keys to rotate the room camera.</div>
          </form>
        </section>
        <div class="mirror-room-meta-grid">
          <section class="mirror-room-card mirror-room-online-card">
            <h2>Online now</h2>
            <div class="mirror-room-room-note">This room now uses the HTML5 creator renderer as the source of truth for room avatars.</div>
            <div class="mirror-room-online-list" data-room-online-list><p class="mirror-room-empty">No one is in The Peel yet.</p></div>
          </section>
          <section class="mirror-room-card mirror-room-feed-card">
            <h2>Room feed</h2>
            <div class="mirror-room-feed" data-room-feed><p class="mirror-room-empty">Room updates will appear here once people move and chat.</p></div>
          </section>
        </div>
      </div>
    </div>
    <noscript>This room needs JavaScript enabled.</noscript>
  `;

  return pagePanelLayout({
    user,
    title: 'The Peel',
    intro: 'The Peel is the first live HTML5 room test for movement, chat bubbles, account sessions and creator-backed weevil rendering.',
    sidebarTitle: 'The Peel',
    sidebar: sidebarNav(user) + `<div class="sidebar-note">Your saved HTML5 weevil becomes your live room avatar here. Sign in once, move with the mouse, test chat bubbles and keep everything inside the same website session.</div>`,
    content,
    styles: ['/css/room.css'],
    moduleScripts: ['/js/room.js'],
    bodyClass: 'panel-page room-page'
  });
}

function renderAdmin({ user, stats, users = [], comments = [], room = {}, posts = [], message = '', error = '' }) {
  const userRows = users.map((entry) => {
    const statusBits = [
      entry.isAdmin ? '<span class="admin-badge admin-badge-admin">admin</span>' : '<span class="admin-badge">user</span>',
      entry.avatarConfigured ? '<span class="admin-badge admin-badge-ok">avatar</span>' : '<span class="admin-badge">no avatar</span>',
      entry.isMuted ? '<span class="admin-badge admin-badge-warn">muted</span>' : '',
      entry.isBanned ? '<span class="admin-badge admin-badge-danger">banned</span>' : ''
    ].filter(Boolean).join(' ');
    const roleActionLabel = entry.isAdmin ? 'Demote to user' : 'Promote to admin';
    const muteActionLabel = entry.isMuted ? 'Unmute' : 'Mute';
    const banActionLabel = entry.isBanned ? 'Unban' : 'Ban';
    return `
      <tr>
        <td><strong>${escapeHtml(entry.username)}</strong><br><small>${escapeHtml(entry.email || 'no email set')}</small></td>
        <td>${statusBits}</td>
        <td>${escapeHtml(formatLongDate((entry.createdAt || '').slice(0, 10))) || '—'}</td>
        <td>
          <div class="admin-action-stack">
            ${entry.canEditRole ? `<form method="post" action="/admin/users/${encodeURIComponent(entry.id)}/role"><button type="submit" class="mirror-pill mirror-pill-small mirror-pill-alt">${roleActionLabel}</button></form>` : '<span class="admin-inline-note">current admin</span>'}
            ${entry.canModerate ? `<form method="post" action="/admin/users/${encodeURIComponent(entry.id)}/mute"><button type="submit" class="mirror-pill mirror-pill-small">${muteActionLabel}</button></form>` : ''}
            ${entry.canModerate ? `<form method="post" action="/admin/users/${encodeURIComponent(entry.id)}/ban"><button type="submit" class="mirror-pill mirror-pill-small mirror-pill-danger">${banActionLabel}</button></form>` : ''}
          </div>
        </td>
      </tr>`;
  }).join('');

  const commentRows = comments.length ? comments.map((comment) => `
    <tr>
      <td><strong>${escapeHtml(comment.username)}</strong><br><small>${escapeHtml(comment.postTitle || comment.postSlug || 'comment')}</small></td>
      <td>${escapeHtml(comment.body.slice(0, 180))}${comment.body.length > 180 ? '…' : ''}</td>
      <td>${escapeHtml(formatLongDate((comment.createdAt || '').slice(0, 10))) || '—'}</td>
      <td>
        <form method="post" action="/admin/comments/${encodeURIComponent(comment.id)}/delete">
          <button type="submit" class="mirror-pill mirror-pill-small mirror-pill-danger">Delete</button>
        </form>
      </td>
    </tr>`).join('') : '<tr><td colspan="4">No comments have been posted yet.</td></tr>';

  const roomPeople = (room.players || []).length ? (room.players || []).map((player) => `
    <li>
      <div>
        <strong>${escapeHtml(player.username)}</strong> · ${player.x}, ${player.y}${player.chatText ? ` · “${escapeHtml(player.chatText)}”` : ''}
      </div>
      <div class="admin-action-stack admin-action-stack-tight">
        <form method="post" action="/admin/users/${encodeURIComponent(player.userId)}/summon"><button type="submit" class="mirror-pill mirror-pill-small">Summon</button></form>
        <form method="post" action="/admin/users/${encodeURIComponent(player.userId)}/kick"><button type="submit" class="mirror-pill mirror-pill-small mirror-pill-danger">Kick</button></form>
      </div>
    </li>`).join('') : '<li>No one is in the room right now.</li>';

  const roomFeed = (room.feed || []).length ? (room.feed || []).slice().reverse().map((entry) => `
    <li><strong>${escapeHtml(entry.username || entry.type || 'feed')}</strong> · ${escapeHtml(entry.text || '')}</li>`).join('') : '<li>The room feed is empty right now.</li>';

  const postRows = posts.length ? posts.map((post) => `
    <tr>
      <td><strong><a href="${slugPath(post.slug)}">${escapeHtml(post.title)}</a></strong><br><small>${escapeHtml(post.slug)}</small></td>
      <td>${escapeHtml(post.author || 'BWR Team')}</td>
      <td>${escapeHtml(formatLongDate(post.publishedAt || '')) || '—'}</td>
      <td>
        <div class="admin-action-stack">
          <a class="mirror-pill mirror-pill-small mirror-pill-alt" href="${slugPath(post.slug)}">Open</a>
          <form method="post" action="/admin/posts/${encodeURIComponent(post.slug)}/delete">
            <button type="submit" class="mirror-pill mirror-pill-small mirror-pill-danger">Delete</button>
          </form>
        </div>
      </td>
    </tr>`).join('') : '<tr><td colspan="4">No project posts have been published yet.</td></tr>';

  const content = `
    ${flashBox(error, 'error')}
    ${flashBox(message, 'success')}
    <section class="info-box admin-overview-grid">
      <div class="admin-stat-card"><h3>Users</h3><p>${stats.users}</p></div>
      <div class="admin-stat-card"><h3>Admins</h3><p>${stats.admins}</p></div>
      <div class="admin-stat-card"><h3>Comments</h3><p>${stats.comments}</p></div>
      <div class="admin-stat-card"><h3>In room now</h3><p>${stats.roomPlayers}</p></div>
    </section>
    <section class="info-box admin-overview-grid admin-overview-grid-secondary">
      <div class="admin-stat-card"><h3>Project posts</h3><p>${stats.mirrorPosts || 0}</p></div>
      <div class="admin-stat-card"><h3>Quick room ops</h3><p>Kick · summon</p></div>
      <div class="admin-stat-card"><h3>Chat commands</h3><p>/help</p></div>
      <div class="admin-stat-card"><h3>Testing status</h3><p>Site open</p></div>
    </section>
    <section class="info-box">
      <h2>Admin pipeline</h2>
      <p>This panel is sitewide. It covers account access, creator-backed users, rewrite posts, profile moderation and the live room state. It is not just a chatroom tool.</p>
      <ul class="admin-quick-links">
        <li><a href="/profile">Profile</a></li>
        <li><a href="/weevil-studio">Weevil Studio</a></li>
        <li><a href="/room">Chat room</a></li>
        <li><a href="/news">News</a></li>
        <li><a href="/hall-of-shame">Hall of Shame</a></li>
      </ul>
    </section>
    <section class="info-box">
      <h2>Create project post</h2>
      <form method="post" action="/admin/posts/create" class="admin-post-form">
        <div class="admin-form-grid">
          <label><span>Title</span><input type="text" name="title" maxlength="140" required placeholder="Website progress update"></label>
          <label><span>Author</span><input type="text" name="author" maxlength="80" value="${escapeHtml(user.username)}"></label>
          <label><span>Published date</span><input type="date" name="publishedAt"></label>
          <label><span>Thumbnail URL</span><input type="text" name="thumbnail" maxlength="500" placeholder="/img/your-image.png"></label>
          <label><span>Source URL</span><input type="text" name="sourceUrl" maxlength="500" placeholder="Optional reference link"></label>
          <label><span>Origin label</span><input type="text" name="originLabel" maxlength="80" value="Project update"></label>
        </div>
        <label><span>Feed intro</span><textarea name="intro" rows="4" maxlength="1200" required placeholder="Write a short summary for the feed card."></textarea></label>
        <label><span>Body</span><textarea name="body" rows="10" maxlength="20000" required placeholder="Write the full post here. Blank lines become separate paragraphs."></textarea></label>
        <div class="admin-form-actions"><button type="submit" class="mirror-pill">Publish project post</button></div>
      </form>
    </section>
    <section class="info-box">
      <h2>Recent project posts</h2>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead><tr><th>Post</th><th>Author</th><th>Published</th><th>Action</th></tr></thead>
          <tbody>${postRows}</tbody>
        </table>
      </div>
    </section>
    <section class="info-box">
      <h2>Users</h2>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead><tr><th>Account</th><th>Status</th><th>Joined</th><th>Actions</th></tr></thead>
          <tbody>${userRows || '<tr><td colspan="4">No user accounts have been created yet.</td></tr>'}</tbody>
        </table>
      </div>
      <p class="admin-inline-note">On a fresh install, the first registered account becomes the first admin automatically so the panel always has an owner.</p>
    </section>
    <section class="info-box">
      <h2>Recent comments</h2>
      <div class="admin-table-wrap">
        <table class="admin-table">
          <thead><tr><th>Author</th><th>Comment</th><th>Posted</th><th>Action</th></tr></thead>
          <tbody>${commentRows}</tbody>
        </table>
      </div>
    </section>
    <section class="info-box admin-room-grid">
      <div>
        <h2>Live room players</h2>
        <ul class="admin-list admin-live-list">${roomPeople}</ul>
      </div>
      <div>
        <h2>Room feed</h2>
        <ul class="admin-list">${roomFeed}</ul>
      </div>
    </section>
  `;

  return pagePanelLayout({
    user,
    title: 'Admin',
    intro: 'Sitewide admin panel for accounts, project posts, comments and the live room.',
    sidebarTitle: 'Admin',
    sidebar: sidebarNav(user) + `<div class="sidebar-note">Signed in as <strong>${escapeHtml(user.username)}</strong>. This panel covers the wider website, not just the room.</div>`,
    content,
    bodyClass: 'panel-page admin-page'
  });
}

function renderNewsFeed({ user, posts }) {
  const items = posts.map((post) => `
<div class="row blog-post-container">
  <div class="col-sm-4 sm-margin-bottom-20">
    <div style="position: relative;">
      <a href="${slugPath(post.slug)}">
        <img alt="${escapeHtml(post.title)}" class="img-responsive img-back wp-post-image" src="${escapeHtml(localiseHtml(post.thumbnail || asset('news.binweevils.app/assets/img/blog/large-1.png')))}">
      </a>
    </div>
  </div>
  <div class="col-sm-8 news-v3">
    <div class="news-v3-in-sm no-padding">
      <ul class="list-inline posted-info">
        <li>Posted ${escapeHtml(formatShortDate(post.publishedAt))}</li>
      </ul>
      <div class="mirror-source-badge ${post.type === 'official' ? 'official' : 'mirror'}">${post.type === 'official' ? 'Archive import' : 'Project update'}</div>
      <h2 style="font-size: 21px"><a href="${slugPath(post.slug)}">${escapeHtml(post.title)}</a></h2>
      <div class="intro">${localiseHtml(post.introHtml || '')}</div>
      <div class="post-counts">
        <a class="button-comments-count button-comments-count-big count-button count-button-big" href="${slugPath(post.slug)}#comments"><span>${post.commentCount || 0}</span></a>
        <a class="read-more-btn pull-right" href="${slugPath(post.slug)}"></a>
      </div>
    </div>
  </div>
</div>
<div class="clearfix margin-bottom-5"></div>`).join('');

  const recentPosts = posts.slice(0, 5).map((post) => `
    <div class="blog-post-bg mirror-sidebar-post">
      <img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/sidebar-posts/recent_blog_post_base.png')}">
      <div class="col-md-5 blog-post-image">
        <a href="${slugPath(post.slug)}"><img alt="" class="img-responsive wp-post-image" src="${escapeHtml(localiseHtml(post.thumbnail || ''))}" style="width:102px;height:64px;"></a>
      </div>
      <div class="col-md-8 blog-post-text">
        <a href="${slugPath(post.slug)}"><p>${escapeHtml(post.title)}</p></a>
      </div>
    </div>`).join('');

  return shell({
    title: 'News',
    bodyClass: 'news-page',
    styles: [
      '/mirror-src/official-mirror/news.binweevils.app/assets/css/blog.css__ver=1_2_9',
      '/mirror-src/official-mirror/news.binweevils.app/assets/css/login.css__ver=1_2_9',
      '/css/source-patches.css',
      '/css/news-extra.css'
    ],
    body: `
<div class="wrapper" data-rsssl="1">
  <div class="container" id="container-header">
    <div class="header">
      <div class="row nav-bar">
        <div class="logo" style="top:0px"><a href="/"><img src="${siteLogoSmall()}" class="mirror-news-logo" alt=""></a></div>
        ${topMenu(user)}
      </div>
    </div>
  </div>

  <div class="under-container-content">
    <div class="container" id="container-content">
      <div class="row">
        <div class="col-md-8" id="content">
          <a href="/"><img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/large-1.png')}" style="margin-bottom: 12px"></a>
          <div class="mini-menu visible-lg hidden-md hidden-sm hidden-xs">
            <a class="mini-menu-32" href="/news"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_news_white.png')}"></a>
            <a class="mini-menu-33" href="/community"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_fanart_white.png')}"></a>
            <a class="mini-menu-18" href="/downloads"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_videos_white.png')}"></a>
            <a class="mini-menu-9" href="/about"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_contest_white.png')}"></a>
            <a class="mini-menu-6" href="/rules"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_codes_white.png')}"></a>
          </div>
          <div class="mirror-mini-extra"><a href="/hall-of-shame">Hall of Shame</a></div>
          <div class="news-v3 hall-intro-shell">
            <div class="news-v3-in">
              <div class="mirror-import-meta hall-intro-box">
                <span class="mirror-source-badge mirror">Project feed</span>
                <h2 class="post-title">News</h2>
                <p>Archive imports sit alongside fresh project posts so the site can show both the history of Bin Weevils and the direction of the remake.</p>
                <p>This is the Bin Weevils Rewritten website feed. Comments on these posts belong to this website and its account system.</p>
              </div>
            </div>
          </div>
          ${items}
        </div>

        <div class="col-md-4 magazine-page" id="sidebar">
          <div class="mirror-sidebar-box">
            <h3>Project note</h3>
            <p>Archive imports sit alongside new project posts so the site can carry history without losing its own voice. Comments below each post belong to this website.</p>
            <p><strong>The website is now framed around the HTML5 remake and creator flow.</strong></p>
            <p>This page is part of the Bin Weevils Rewritten website shell and supports the creator, account and profile experience.</p>
            <p><a href="/hall-of-shame">Open the Hall of Shame archive</a> for the separate infamous-weevils list.</p>
          </div>
          <div class="posts col-md-12 hidden-sm hidden-xs margin-bottom-30" id="sidebar-recent-posts">
            <img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/sidebar-posts/recent_blog_post_header.png')}">
            ${recentPosts}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>`
  });
}

function renderNewsPost({ user, post, comments, message, error }) {
  const commentsHtml = comments.map((comment) => `
    <article class="mirror-comment">
      <header>
        <strong>${escapeHtml(comment.username)}</strong>
        <span>${escapeHtml(formatLongDate(comment.createdAt.slice(0, 10)))}</span>
      </header>
      <p>${escapeHtml(comment.body)}</p>
    </article>`).join('');

  const commentForm = user ? `
    <form method="post" action="${slugPath(post.slug)}/comment" class="mirror-comment-form">
      <label for="commentBody">Leave a comment</label>
      <textarea id="commentBody" name="body" rows="5" maxlength="1200" required placeholder="Share your thoughts about this post."></textarea>
      <button type="submit" class="mirror-pill">Post comment</button>
    </form>
  ` : `<p class="comment-login-note"><a href="/login">Sign in</a> with your Bin Weevils Rewritten account to comment.</p>`;

  return shell({
    title: post.title,
    bodyClass: 'news-page',
    styles: [
      '/mirror-src/official-mirror/news.binweevils.app/assets/css/blog.css__ver=1_2_9',
      '/mirror-src/official-mirror/news.binweevils.app/assets/css/login.css__ver=1_2_9',
      '/css/source-patches.css',
      '/css/news-extra.css'
    ],
    body: `
<div class="wrapper" data-rsssl="1">
  <div class="container" id="container-header">
    <div class="header">
      <div class="row nav-bar">
        <div class="logo" style="top:0px"><a href="/"><img src="${siteLogoSmall()}" class="mirror-news-logo" alt=""></a></div>
        ${topMenu(user)}
      </div>
    </div>
  </div>

  <div class="under-container-content">
    <div class="container" id="container-content">
      <div class="row">
        <div class="col-md-8" id="content">
          <a href="/news"><img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/large-1.png')}" style="margin-bottom: 12px"></a>
          <div class="news-v3">
            <div class="news-v3-in">
              <div class="mirror-import-meta">
                <span class="mirror-source-badge ${post.type === 'official' ? 'official' : 'mirror'}">${post.type === 'official' ? 'Archive import' : 'Project update'}</span>
                <p>Published ${escapeHtml(formatLongDate(post.publishedAt))}${post.sourceUrl ? ` · <a href="${escapeHtml(post.sourceUrl)}" target="_blank" rel="noopener">archived source</a>` : ''}</p>
                <p>${post.type === 'official' ? 'Archived Bin Weevils article preserved locally as closely as possible.' : 'Written for the Bin Weevils Rewritten website.'}</p>
                <p>This page lives inside the Bin Weevils Rewritten website shell rather than the original news page.</p>
              </div>
              <h2 class="post-title">${escapeHtml(post.title)}</h2>
              <ul class="list-inline posted-info">
                <li>By ${escapeHtml(post.author || 'BWR Team')}</li>
                <li>Posted ${escapeHtml(post.originalDateText || formatShortDate(post.publishedAt))}</li>
              </ul>
              <div class="mirror-article-body">${localiseHtml(post.contentHtml)}</div>
              <div id="comments" class="mirror-comments-block">
                <h3>Comments</h3>
                ${flashBox(error, 'error')}
                ${flashBox(message, 'success')}
                ${commentForm}
                <div class="mirror-comments-list">
                  ${commentsHtml || '<p>No comments have been posted yet.</p>'}
                </div>
              </div>
              <div class="post-counts clearfix">
                <div class="pull-right">
                  <a href="/news"><img alt="Back to news" src="${asset('news.binweevils.app/assets/img/blog/main-btns/back1.png')}"></a>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4 magazine-page" id="sidebar">
          <div class="mirror-sidebar-box">
            <h3>Account guide</h3>
            <p>Comments here use the same Bin Weevils Rewritten account system that powers the HTML5 creator and saved weevils.</p>
          </div>
          <div class="mirror-sidebar-box">
            <h3>Need the current build?</h3>
            <p><a href="/downloads">Head to Downloads</a> for the latest build and install links.</p>
          </div>
          <div class="mirror-sidebar-box">
            <h3>Hall of Shame</h3>
            <p><a href="/hall-of-shame">Open the archive page</a> if you want to browse the infamous-weevil write-ups separately.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>`
  });
}


function renderHallOfShame({ user, entries }) {
  const cards = entries.length ? entries.map((entry) => `
<div class="hall-card row blog-post-container">
  <div class="col-sm-4 sm-margin-bottom-20">
    <div class="hall-thumb-wrap">
      <img alt="${escapeHtml(entry.name)}" class="img-responsive hall-thumb" src="${escapeHtml(localiseHtml(entry.thumbnail || asset('news.binweevils.app/assets/img/blog/How_to_draw_a_Binweevil_185x300.jpg')))}">
    </div>
  </div>
  <div class="col-sm-8 news-v3">
    <div class="news-v3-in-sm no-padding hall-copy">
      <div class="mirror-source-badge mirror hall-badge">${escapeHtml(entry.status || 'Listed')}</div>
      <h2 style="font-size: 24px">${escapeHtml(entry.name)}</h2>
      ${entry.handle ? `<p class="hall-handle">@${escapeHtml(entry.handle)}</p>` : ''}
      <p class="hall-summary">${escapeHtml(entry.summary || '')}</p>
      <div class="hall-meta-box">
        <h4>Why they are on the page</h4>
        <p>${escapeHtml(entry.reason || '')}</p>
      </div>
      <div class="hall-meta-box">
        <h4>Notes</h4>
        <p>${escapeHtml(entry.notes || '')}</p>
      </div>
      ${entry.tags?.length ? `<div class="hall-tags">${entry.tags.map((tag) => `<span>${escapeHtml(tag)}</span>`).join('')}</div>` : ''}
    </div>
  </div>
</div>
<div class="clearfix margin-bottom-5"></div>`).join('') : `
<div class="news-v3"><div class="news-v3-in"><p>No archive entries have been added yet.</p></div></div>`;

  const recentLinks = entries.slice(0, 5).map((entry) => `
    <div class="blog-post-bg mirror-sidebar-post hall-sidebar-post">
      <img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/sidebar-posts/recent_blog_post_base.png')}">
      <div class="col-md-5 blog-post-image">
        <img alt="" class="img-responsive wp-post-image" src="${escapeHtml(localiseHtml(entry.thumbnail || ''))}" style="width:102px;height:64px;object-fit:cover;">
      </div>
      <div class="col-md-8 blog-post-text">
        <p>${escapeHtml(entry.name)}</p>
      </div>
    </div>`).join('');

  return shell({
    title: 'Hall of Shame',
    bodyClass: 'news-page hall-page',
    styles: [
      '/mirror-src/official-mirror/news.binweevils.app/assets/css/blog.css__ver=1_2_9',
      '/mirror-src/official-mirror/news.binweevils.app/assets/css/login.css__ver=1_2_9',
      '/css/source-patches.css',
      '/css/news-extra.css'
    ],
    body: `
<div class="wrapper" data-rsssl="1">
  <div class="container" id="container-header">
    <div class="header">
      <div class="row nav-bar">
        <div class="logo" style="top:0px"><a href="/"><img src="${siteLogoSmall()}" class="mirror-news-logo" alt=""></a></div>
        ${topMenu(user)}
      </div>
    </div>
  </div>

  <div class="under-container-content">
    <div class="container" id="container-content">
      <div class="row">
        <div class="col-md-8" id="content">
          <a href="/"><img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/large-1.png')}" style="margin-bottom: 12px"></a>
          <div class="mini-menu visible-lg hidden-md hidden-sm hidden-xs">
            <a class="mini-menu-32" href="/news"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_news_white.png')}"></a>
            <a class="mini-menu-33" href="/community"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_fanart_white.png')}"></a>
            <a class="mini-menu-18" href="/downloads"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_videos_white.png')}"></a>
            <a class="mini-menu-9" href="/about"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_contest_white.png')}"></a>
            <a class="mini-menu-6" href="/rules"><img alt="" src="${asset('news.binweevils.app/assets/img/blog/mini-menu-btns/btn_codes_white.png')}"></a>
          </div>
          <div class="mirror-mini-extra"><a href="/hall-of-shame">Hall of Shame</a></div>
          <div class="news-v3 hall-intro-shell">
            <div class="news-v3-in">
              <div class="mirror-import-meta hall-intro-box">
                <span class="mirror-source-badge mirror">Community archive</span>
                <h2 class="post-title">Hall of Shame</h2>
                <p>This is a community-maintained archive page for infamous-weevil write-ups. It sits inside the Bin Weevils Rewritten website shell and is not an official moderation or ban page.</p>
                <p>This page is laid out as a separate archive section so these entries stay in one place without taking over the main project news feed.</p>
              </div>
            </div>
          </div>
          ${cards}
        </div>

        <div class="col-md-4 magazine-page" id="sidebar">
          <div class="mirror-sidebar-box">
            <h3>How to read this page</h3>
            <p>The current build includes archive entries for Bubswig, chelskisummers, Alioth and MistyDayz so the layout stays fully populated while longer write-ups are being prepared.</p>
          </div>
          <div class="mirror-sidebar-box">
            <h3>What it is not</h3>
            <p>It is not a formal moderation tool and it is not tied to game-side account actions. It is simply a community archive page inside the wider project website.</p>
          </div>
          <div class="mirror-sidebar-box">
            <h3>Website archive</h3>
            <p>This section belongs to the website archive layer only. It is not wired to in-game moderation or any official game-side systems.</p>
          </div>
          <div class="posts col-md-12 hidden-sm hidden-xs margin-bottom-30" id="sidebar-recent-posts">
            <img alt="" class="img-responsive" src="${asset('news.binweevils.app/assets/img/blog/sidebar-posts/recent_blog_post_header.png')}">
            ${recentLinks}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>`
  });
}

export {
  escapeHtml,
  formatLongDate,
  renderHome,
  renderAuth,
  renderDownloads,
  renderCommunity,
  renderAbout,
  renderRules,
  renderProfile,
  renderWeevilStudio,
  renderRoom,
  renderAdmin,
  renderNewsFeed,
  renderNewsPost,
  renderHallOfShame,
  slugPath
};
