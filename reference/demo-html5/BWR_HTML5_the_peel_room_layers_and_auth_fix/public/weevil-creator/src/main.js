import { loadAtlasMap, loadImage } from "./runtime/canvasAtlasLoader.js";
import { clrs1, clrs2, getDefObj, getDefStr, intToHex } from "./runtime/WeevilDef.js";
import { WeevilCanvasRenderer } from "./runtime/WeevilCanvasRenderer.js";

const canvas = document.querySelector("#weevilCanvas");
const stageArea = document.querySelector("#viewer");
const statusEl = document.querySelector("#statusBar");
const selectorPanel = document.querySelector("#selectorPanel");
const typeGrid = document.querySelector("#typeGrid");
const colorTools = document.querySelector("#colorTools");
const paletteGrid = document.querySelector("#paletteGrid");
const panelHint = document.querySelector("#panelHint");
const hexColorText = document.querySelector("#hexColorText");
const applyHexBtn = document.querySelector("#applyHexBtn");
const categoryButtons = Array.from(document.querySelectorAll('.category-btn[data-category]'));
const randomizeBtn = document.querySelector("#randomizeBtn");
const defEditorBtn = document.querySelector("#defEditorBtn");
const defEditor = document.querySelector("#defEditor");
const defInput = document.querySelector("#defInput");
const applyDefBtn = document.querySelector("#applyDefBtn");
const spinLeftBtn = document.querySelector("#spinLeft");
const spinRightBtn = document.querySelector("#spinRight");
const signupCta = document.querySelector("#signupCta");
const signupModal = document.querySelector("#signupModal");
const closeSignupBtn = document.querySelector("#closeSignup");
const confirmSignupBtn = document.querySelector("#confirmSignup");
const lookCodeEl = document.querySelector("#lookCode");
const signupNameEl = document.querySelector("#signupName");
const signupEmailEl = document.querySelector("#signupEmail");
const signupPasswordEl = document.querySelector("#signupPassword");
const signupTitleEl = document.querySelector("#signupTitle");
const signupBlurbEl = signupTitleEl?.nextElementSibling;
const urlParams = new URLSearchParams(window.location.search);
const creatorMode = urlParams.get("mode") === "edit" ? "edit" : "register";
const nextPath = (() => {
  const raw = String(urlParams.get("next") || "/profile").trim();
  return raw.startsWith("/") && !raw.startsWith("//") ? raw : "/profile";
})();

const demoBaseUrl = new URL("../", import.meta.url).href.replace(/\/$/, "");
const [atlases, upperLegImage, lowerLegImage, lowerLegStripyImage] = await Promise.all([
  loadAtlasMap(demoBaseUrl),
  loadImage(`${demoBaseUrl}/assets/raw/misc/upper_leg.png`),
  loadImage(`${demoBaseUrl}/assets/raw/misc/lower_leg.png`),
  loadImage(`${demoBaseUrl}/assets/raw/misc/lower_leg_stripy.png`),
]);

const renderer = new WeevilCanvasRenderer(
  canvas,
  atlases,
  new Map([
    ["upper_leg.png", upperLegImage],
    ["lower_leg.png", lowerLegImage],
    ["lower_leg_stripy.png", lowerLegStripyImage],
  ]),
);

const BODY_SWATCHES = [
  clrs1[0], clrs1[1], clrs1[2], clrs1[27], clrs1[10],
  clrs1[5], clrs1[40], clrs1[7], clrs1[8], clrs1[19],
  clrs1[37], clrs1[46], clrs1[11], clrs1[12], clrs1[13],
  clrs1[20], clrs1[14], clrs1[15], clrs1[16], clrs1[17],
  clrs1[21], clrs1[29], clrs1[18], clrs1[33], clrs1[48],
];

const EYE_SWATCHES = [
  clrs2[30], clrs2[1], clrs2[41], clrs2[31], clrs2[43],
  clrs2[19], clrs2[4], clrs2[2], clrs2[20], clrs2[16],
  clrs2[0], clrs2[14], clrs2[21], clrs2[55], clrs2[57],
];

const ANTENNA_OPTIONS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const LEG_OPTIONS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
const HAT_OPTIONS = [0, 1];
const DEF_EDITOR_CATEGORY = "def";

const CATEGORY_CONFIG = {
  head: {
    label: "Head",
    typeKey: "ht",
    colorKey: "hc",
    palette: BODY_SWATCHES,
    options: [1, 2, 3, 4],
    hint: "",
  },
  body: {
    label: "Body",
    typeKey: "bt",
    colorKey: "bc",
    palette: BODY_SWATCHES,
    options: [1, 2, 3, 4],
    hint: "",
  },
  eyes: {
    label: "Eyes",
    typeKey: "et",
    colorKey: "ec",
    palette: EYE_SWATCHES,
    options: [1, 2, 3, 4, 5, 6],
    hint: "",
  },
  antenna: {
    label: "Antenna",
    typeKey: "at",
    colorKey: "ac",
    palette: BODY_SWATCHES,
    options: ANTENNA_OPTIONS,
    hint: "",
  },
  hats: {
    label: "Hats",
    typeKey: "hat",
    colorKey: "hatc",
    palette: BODY_SWATCHES,
    options: HAT_OPTIONS,
    hint: "",
  },
  legs: {
    label: "Legs",
    typeKey: "lt",
    colorKey: "lc",
    palette: BODY_SWATCHES,
    options: LEG_OPTIONS,
    hint: "",
  },
};

let currentCategory = "body";
let expressionIndex = 0;
let currentPitch = 16;
let currentYaw = 302;
let renderQueued = false;
let currentProboscis = 0;
let currentPreferredRenderer = "html5-canvas";

let currentDefObj = getDefObj("100100100040000000");
currentDefObj = {
  ...currentDefObj,
  ht: "2",
  hc: clrs1[20],
  bt: "1",
  bc: clrs1[13],
  et: "1",
  ec: clrs2[30],
  at: "05",
  ac: clrs1[14],
  hat: "0",
  hatc: clrs1[27],
  lc: clrs1[15],
  lt: "00",
};

renderer.autoRotate = false;

function resizeRenderer() {
  const rect = stageArea.getBoundingClientRect();
  renderer.resize(rect.width, rect.height);
  queueRender();
}

window.addEventListener("resize", resizeRenderer);
if (typeof ResizeObserver !== "undefined") {
  const resizeObserver = new ResizeObserver(() => resizeRenderer());
  resizeObserver.observe(stageArea);
}

function queueRender() {
  if (renderQueued) return;
  renderQueued = true;
  requestAnimationFrame(() => {
    renderQueued = false;
    renderer.setDefinition(structuredClone(currentDefObj), { expressionIndex });
    renderer.setView(currentPitch, currentYaw);
    renderer.render();
  });
}

function setStatus(message) {
  statusEl.textContent = message;
  lookCodeEl.textContent = getDefStr(currentDefObj);
}

function formatTypeValue(category, value) {
  if (category === "antenna") return String(Number(value)).padStart(2, "0");
  if (category === "legs") return String(Number(value)).padStart(2, "0");
  if (category === "hats") return String(Number(value));
  return String(Number(value));
}

function getCurrentValue(key) {
  return Number(currentDefObj[key]);
}

function randomChoice(values) {
  return values[Math.floor(Math.random() * values.length)];
}

function randomizeWeevil() {
  Object.entries(CATEGORY_CONFIG).forEach(([category, config]) => {
    currentDefObj[config.typeKey] = formatTypeValue(category, randomChoice(config.options));
    currentDefObj[config.colorKey] = Number(randomChoice(config.palette));
  });
  expressionIndex = Math.floor(Math.random() * 7);
}

function normalizeHex(value) {
  const cleaned = String(value || "").trim().replace(/^#/, "");
  if (!/^[0-9a-fA-F]{6}$/.test(cleaned)) return null;
  return `#${cleaned.toLowerCase()}`;
}

function hexToInt(hex) {
  return Number.parseInt(hex.slice(1), 16);
}

function syncColorInputs(category = currentCategory) {
  const config = CATEGORY_CONFIG[category];
  if (!config) return;
  const hex = intToHex(Number(currentDefObj[config.colorKey]) || 0).toUpperCase();
  hexColorText.value = hex;
}

function applyCurrentHexColor() {
  const config = CATEGORY_CONFIG[currentCategory];
  if (!config) return;
  const normalizedHex = normalizeHex(hexColorText.value);
  if (!normalizedHex) {
    syncColorInputs(currentCategory);
    setStatus("Enter a valid 6-digit hex colour like #A1B2C3.");
    return;
  }

  hexColorText.value = normalizedHex.toUpperCase();
  currentDefObj[config.colorKey] = hexToInt(normalizedHex);
  renderPalette(currentCategory);
  queueRender();
  setStatus(`${config.label} colour updated.`);
}

function svgWrap(inner, viewBox = "0 0 100 72") {
  return `<svg viewBox="${viewBox}" aria-hidden="true" focusable="false">${inner}</svg>`;
}

function shapeIcon(value) {
  const fill = "#f4f4f4";
  const stroke = "#9f9f9f";
  if (value === 1) {
    return svgWrap(`<ellipse cx="50" cy="36" rx="24" ry="22" fill="${fill}" stroke="${stroke}" stroke-width="4" />`);
  }
  if (value === 2) {
    return svgWrap(`<path d="M50 10 L76 58 Q78 64 71 64 H29 Q22 64 24 58 Z" fill="${fill}" stroke="${stroke}" stroke-width="4" stroke-linejoin="round" />`);
  }
  if (value === 3) {
    return svgWrap(`<path d="M22 14 H78 Q84 14 81 21 L60 61 Q57 66 50 66 Q43 66 40 61 L19 21 Q16 14 22 14 Z" fill="${fill}" stroke="${stroke}" stroke-width="4" stroke-linejoin="round" />`);
  }
  return svgWrap(`<rect x="23" y="12" width="54" height="50" rx="12" ry="12" fill="${fill}" stroke="${stroke}" stroke-width="4" />`);
}

function eyeIcon(value) {
  const irisOffsets = {
    1: [40, 60],
    2: [33, 67],
    3: [45, 55],
    4: [50, 50],
    5: [28, 72],
    6: [18, 82],
  };
  const [leftIris, rightIris] = irisOffsets[value] || irisOffsets[1];
  return svgWrap(`
    <ellipse cx="32" cy="36" rx="20" ry="16" fill="#ffffff" stroke="#9f9f9f" stroke-width="4" />
    <ellipse cx="68" cy="36" rx="20" ry="16" fill="#ffffff" stroke="#9f9f9f" stroke-width="4" />
    <circle cx="${leftIris}" cy="36" r="5" fill="#7ab800" />
    <circle cx="${rightIris}" cy="36" r="5" fill="#7ab800" />
    <circle cx="${leftIris}" cy="36" r="2.5" fill="#111111" />
    <circle cx="${rightIris}" cy="36" r="2.5" fill="#111111" />
  `);
}

function antennaIcon(value) {
  const grey = "#8e8e8e";
  const ball = "#f0f0f0";
  const stalk = (x1, y1, x2, y2) => `<path d="M${x1} ${y1} Q ${(x1 + x2) / 2} ${(y1 + y2) / 2 - 10}, ${x2} ${y2}" fill="none" stroke="${grey}" stroke-width="5" stroke-linecap="round" />`;
  const tip = (x, y) => `<circle cx="${x}" cy="${y}" r="6" fill="${ball}" stroke="#9f9f9f" stroke-width="3" />`;
  const parts = [];
  if (value === 0) {
    parts.push(`<path d="M25 52 H75" stroke="#bbbbbb" stroke-width="5" stroke-linecap="round" />`);
  }
  if (value === 1) {
    parts.push(stalk(50, 58, 50, 22), tip(50, 22));
  }
  if (value === 2) {
    parts.push(stalk(50, 58, 50, 14), tip(50, 14));
  }
  if (value === 3) {
    parts.push(stalk(50, 58, 66, 18), tip(66, 18));
  }
  if (value === 4) {
    parts.push(stalk(38, 58, 28, 26), tip(28, 26), stalk(62, 58, 72, 26), tip(72, 26));
  }
  if (value === 5) {
    parts.push(stalk(38, 58, 26, 16), tip(26, 16), stalk(62, 58, 74, 16), tip(74, 16));
  }
  if (value === 6) {
    parts.push(stalk(38, 58, 18, 18), tip(18, 18), stalk(62, 58, 82, 18), tip(82, 18));
  }
  if (value === 7) {
    parts.push(stalk(50, 58, 50, 16), tip(50, 16), stalk(38, 58, 28, 26), tip(28, 26), stalk(62, 58, 72, 26), tip(72, 26));
  }
  if (value === 8) {
    parts.push(stalk(50, 58, 50, 10), tip(50, 10), stalk(38, 58, 24, 18), tip(24, 18), stalk(62, 58, 76, 18), tip(76, 18));
  }
  if (value === 9) {
    parts.push(stalk(50, 58, 60, 10), tip(60, 10), stalk(38, 58, 16, 18), tip(16, 18), stalk(62, 58, 84, 18), tip(84, 18));
  }
  if (value === 10) {
    parts.push(
      stalk(50, 58, 50, 8), tip(50, 8),
      stalk(50, 58, 26, 12), tip(26, 12),
      stalk(50, 58, 74, 12), tip(74, 12),
      stalk(50, 58, 14, 22), tip(14, 22),
      stalk(50, 58, 86, 22), tip(86, 22),
    );
  }
  return svgWrap(parts.join(""));
}

function hatIcon(value) {
  if (value === 0) {
    return svgWrap(`<path d="M18 56 H82" stroke="#bcbcbc" stroke-width="6" stroke-linecap="round" />`);
  }
  return svgWrap(`
    <ellipse cx="50" cy="52" rx="30" ry="10" fill="#ececec" stroke="#9f9f9f" stroke-width="4" />
    <path d="M30 18 H70 L66 52 H34 Z" fill="#e7e7e7" stroke="#9f9f9f" stroke-width="4" stroke-linejoin="round" />
  `);
}

function legIcon(value) {
  const grey = "#8e8e8e";
  const accent = value === 0 ? "#dddddd" : value === 1 ? "#f7c833" : value === 2 ? "#f08bff" : value === 3 ? "#91eaff" : value === 4 ? "#f86b6b" : value === 5 ? "#9cff6f" : value === 6 ? "#ffffff" : value === 7 ? "#ffd966" : value === 8 ? "#c7a4ff" : "#9f9f9f";
  return svgWrap(`
    <path d="M28 12 L20 54" stroke="${grey}" stroke-width="6" stroke-linecap="round" />
    <path d="M50 12 L46 54" stroke="${grey}" stroke-width="6" stroke-linecap="round" />
    <path d="M72 12 L78 54" stroke="${grey}" stroke-width="6" stroke-linecap="round" />
    <path d="M20 54 H30" stroke="${accent}" stroke-width="8" stroke-linecap="round" />
    <path d="M46 54 H56" stroke="${accent}" stroke-width="8" stroke-linecap="round" />
    <path d="M70 54 H80" stroke="${accent}" stroke-width="8" stroke-linecap="round" />
  `);
}

function iconMarkup(category, value) {
  if (category === "head" || category === "body") return shapeIcon(value);
  if (category === "eyes") return eyeIcon(value);
  if (category === "antenna") return antennaIcon(value);
  if (category === "hats") return hatIcon(value);
  return legIcon(value);
}

function renderTypeButtons(category) {
  const config = CATEGORY_CONFIG[category];
  const current = getCurrentValue(config.typeKey);
  typeGrid.className = "";
  typeGrid.classList.add(`layout-${category}`);
  typeGrid.replaceChildren();
  config.options.forEach((value) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "type-btn";
    if (Number(current) === Number(value)) button.classList.add("is-active");
    button.innerHTML = iconMarkup(category, value);
    button.setAttribute("aria-label", `${config.label} option ${value}`);
    button.addEventListener("click", () => {
      currentDefObj[config.typeKey] = formatTypeValue(category, value);
      renderControls();
      queueRender();
      setStatus(`${config.label} updated.`);
    });
    typeGrid.appendChild(button);
  });
}

function renderPalette(category) {
  const config = CATEGORY_CONFIG[category];
  const activeColor = Number(currentDefObj[config.colorKey]);
  paletteGrid.replaceChildren();
  config.palette.forEach((color) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "swatch-btn";
    button.style.setProperty("--swatch", intToHex(color));
    if (Number(color) === activeColor) button.classList.add("is-active");
    button.title = intToHex(color).toUpperCase();
    button.addEventListener("click", () => {
      currentDefObj[config.colorKey] = Number(color);
      syncColorInputs(category);
      renderPalette(category);
      queueRender();
      setStatus(`${config.label} colour updated.`);
    });
    paletteGrid.appendChild(button);
  });
}

function renderControls() {
  const isDefMode = currentCategory === DEF_EDITOR_CATEGORY;
  selectorPanel.classList.toggle("is-def-mode", isDefMode);
  selectorPanel.dataset.category = isDefMode ? DEF_EDITOR_CATEGORY : currentCategory;
  defEditor.hidden = !isDefMode;
  colorTools.hidden = isDefMode;
  paletteGrid.hidden = isDefMode;

  categoryButtons.forEach((button) => {
    button.classList.toggle("is-active", !isDefMode && button.dataset.category === currentCategory);
  });
  randomizeBtn.classList.remove("is-active");
  defEditorBtn.classList.toggle("is-active", isDefMode);

  if (isDefMode) {
    typeGrid.className = "";
    typeGrid.replaceChildren();
    defInput.value = getDefStr(currentDefObj);
    panelHint.textContent = "";
    return;
  }

  renderTypeButtons(currentCategory);
  renderPalette(currentCategory);
  syncColorInputs(currentCategory);
  panelHint.textContent = "";
}

function openSignup() {
  lookCodeEl.textContent = getDefStr(currentDefObj);
  signupModal.classList.add("is-open");
  signupModal.setAttribute("aria-hidden", "false");
  signupNameEl.focus();
}

function closeSignup() {
  signupModal.classList.remove("is-open");
  signupModal.setAttribute("aria-hidden", "true");
}

function safeJson(response) {
  return response.json().catch(() => ({ ok: false, error: "Unexpected server response." }));
}

function creatorPayload() {
  return {
    weevilDef: getDefStr(currentDefObj),
    expression: expressionIndex,
    proboscis: currentProboscis,
    hatId: Number(currentDefObj.hat || 0),
    hatColour: Number(currentDefObj.hatc || clrs1[27]),
    preferredRenderer: currentPreferredRenderer || "html5-canvas",
  };
}

function applyAvatarRecord(record = {}) {
  const nextDef = /^\d{18}$/.test(String(record.weevilDef || "")) ? String(record.weevilDef) : getDefStr(currentDefObj);
  currentDefObj = {
    ...currentDefObj,
    ...getDefObj(nextDef),
    hat: String(Number(record.hatId ?? currentDefObj.hat ?? 0) || 0),
    hatc: Number(record.hatColour ?? record.hatColor ?? currentDefObj.hatc ?? clrs1[27]) || clrs1[27],
  };
  expressionIndex = Number(record.expression ?? expressionIndex ?? 0) || 0;
  currentProboscis = Number(record.proboscis ?? currentProboscis ?? 0) || 0;
  currentPreferredRenderer = String(record.preferredRenderer || currentPreferredRenderer || "html5-canvas");
}

function notifyParentAndNavigate(href) {
  const nextHref = String(href || "/profile");
  try {
    window.parent?.postMessage({ type: "creator:navigate", href: nextHref }, window.location.origin);
  } catch {}
  try {
    if (window.top && window.top !== window) {
      window.top.location.href = nextHref;
      return;
    }
  } catch {}
  window.location.href = nextHref;
}

async function bootstrapCreator() {
  if (creatorMode !== "edit") {
    signupCta.classList.remove("is-save-mode");
    signupCta.textContent = "SIGN UP";
    signupTitleEl.textContent = "Create account";
    if (signupBlurbEl) signupBlurbEl.textContent = "Choose a weevil name, add your account details and save this weevil to your new profile.";
    setStatus("Body options selected.");
    return;
  }

  signupCta.classList.add("is-save-mode");
  signupCta.textContent = "SAVE WEEVIL";
  signupTitleEl.textContent = "Save Weevil";
  if (signupBlurbEl) signupBlurbEl.textContent = "Your site session is already active. Saving here updates your existing weevil without another sign-in prompt.";
  closeSignupBtn.textContent = "Close";
  confirmSignupBtn.textContent = "Save now";

  const response = await fetch("/api/me/avatar", { headers: { Accept: "application/json" }, credentials: "same-origin" });
  const payload = await safeJson(response);
  if (!response.ok || !payload.ok) {
    notifyParentAndNavigate(`/login?next=${encodeURIComponent('/weevil-studio')}&error=${encodeURIComponent(payload.error || 'Please sign in first.')}`);
    return;
  }
  applyAvatarRecord(payload.avatar || {});
  renderControls();
  queueRender();
  setStatus("Your saved weevil is loaded. Save again when you are ready.");
}

async function submitRegistration() {
  const username = signupNameEl.value.trim();
  const email = signupEmailEl.value.trim();
  const password = signupPasswordEl.value.trim();
  if (!username || !email || !password) {
    setStatus("Add a weevil name, email address and password to create your account.");
    return;
  }

  confirmSignupBtn.disabled = true;
  try {
    const response = await fetch("/api/register-with-creator", {
      method: "POST",
      credentials: "same-origin",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify({
        username,
        email,
        password,
        passwordConfirm: password,
        nextPath,
        ...creatorPayload(),
      }),
    });
    const payload = await safeJson(response);
    if (!response.ok || !payload.ok) {
      if (response.status === 409 && /already signed in/i.test(String(payload.error || ''))) {
        notifyParentAndNavigate(`/weevil-studio?mode=edit&next=${encodeURIComponent(nextPath || '/profile')}`);
        return;
      }
      setStatus(payload.error || "We could not create your account.");
      return;
    }
    closeSignup();
    notifyParentAndNavigate(payload.redirectPath || nextPath || "/profile");
  } catch (error) {
    console.error(error);
    setStatus("The creator could not reach the site right now. Please try again.");
  } finally {
    confirmSignupBtn.disabled = false;
  }
}

async function saveExistingWeevil() {
  signupCta.disabled = true;
  try {
    const response = await fetch("/api/me/avatar", {
      method: "POST",
      credentials: "same-origin",
      headers: { "Content-Type": "application/json", Accept: "application/json" },
      body: JSON.stringify({
        nextPath,
        ...creatorPayload(),
      }),
    });
    const payload = await safeJson(response);
    if (!response.ok || !payload.ok) {
      setStatus(payload.error || "We could not save your weevil.");
      return;
    }
    notifyParentAndNavigate(payload.redirectPath || nextPath || "/profile");
  } catch (error) {
    console.error(error);
    setStatus("The creator could not save your weevil right now. Please try again.");
  } finally {
    signupCta.disabled = false;
  }
}

function validateWeevilDef(defString) {
  if (!/^\d{18}$/.test(defString)) {
    return { valid: false, message: "Weevil def must be exactly 18 digits." };
  }

  const values = {
    ht: Number(defString.slice(0, 1)),
    hc: Number(defString.slice(1, 3)),
    bt: Number(defString.slice(3, 4)),
    bc: Number(defString.slice(4, 6)),
    et: Number(defString.slice(6, 7)),
    ec: Number(defString.slice(7, 9)),
    lids: Number(defString.slice(9, 10)),
    at: Number(defString.slice(10, 12)),
    ac: Number(defString.slice(12, 14)),
    lc: Number(defString.slice(14, 16)),
    lt: Number(defString.slice(16, 18)),
  };

  if (values.ht < 1 || values.ht > 4) return { valid: false, message: "Head type must be between 1 and 4." };
  if (values.hc < 0 || values.hc >= clrs1.length) return { valid: false, message: "Head colour index is out of range." };
  if (values.bt < 1 || values.bt > 4) return { valid: false, message: "Body type must be between 1 and 4." };
  if (values.bc < 0 || values.bc >= clrs1.length) return { valid: false, message: "Body colour index is out of range." };
  if (values.et < 1 || values.et > 6) return { valid: false, message: "Eye type must be between 1 and 6." };
  if (values.ec < 0 || values.ec >= clrs2.length) return { valid: false, message: "Eye colour index is out of range." };
  if (values.lids < 0 || values.lids > 9) return { valid: false, message: "Lid value must be a single digit." };
  if (values.at < 0 || values.at > 10) return { valid: false, message: "Antenna type must be between 00 and 10." };
  if (values.ac < 0 || values.ac >= clrs1.length) return { valid: false, message: "Antenna colour index is out of range." };
  if (values.lc < 0 || values.lc >= clrs1.length) return { valid: false, message: "Leg colour index is out of range." };
  if (values.lt < 0 || values.lt > 9) return { valid: false, message: "Leg type must be between 00 and 09." };

  return { valid: true, defObj: getDefObj(defString) };
}

categoryButtons.forEach((button) => {
  button.addEventListener("click", () => {
    currentCategory = button.dataset.category;
    renderControls();
    setStatus(`${CATEGORY_CONFIG[currentCategory].label} options opened.`);
  });
});

randomizeBtn.addEventListener("click", () => {
  currentCategory = "body";
  randomizeWeevil();
  renderControls();
  queueRender();
  setStatus("Weevil randomised.");
});

defEditorBtn.addEventListener("click", () => {
  currentCategory = DEF_EDITOR_CATEGORY;
  renderControls();
  setStatus("Paste a weevil def and click Apply.");
  defInput.focus();
  defInput.select();
});

applyHexBtn.addEventListener("click", applyCurrentHexColor);
hexColorText.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    applyCurrentHexColor();
  }
});
hexColorText.addEventListener("blur", () => {
  if (normalizeHex(hexColorText.value)) {
    applyCurrentHexColor();
  } else {
    syncColorInputs(currentCategory);
  }
});

applyDefBtn.addEventListener("click", () => {
  const proposedDef = defInput.value.trim();
  const result = validateWeevilDef(proposedDef);
  if (!result.valid) {
    setStatus(result.message);
    defInput.focus();
    defInput.select();
    return;
  }

  currentDefObj = { ...currentDefObj, ...result.defObj };
  currentCategory = "body";
  renderControls();
  queueRender();
  setStatus(`Weevil def applied: ${proposedDef}.`);
});

defInput.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    applyDefBtn.click();
  }
});

spinLeftBtn.addEventListener("click", () => {
  currentYaw = (currentYaw - 20 + 360) % 360;
  queueRender();
  setStatus("Preview turned left.");
});

spinRightBtn.addEventListener("click", () => {
  currentYaw = (currentYaw + 20) % 360;
  queueRender();
  setStatus("Preview turned right.");
});

signupCta.addEventListener("click", () => {
  if (creatorMode === "edit") {
    saveExistingWeevil();
    return;
  }
  openSignup();
});
closeSignupBtn.addEventListener("click", closeSignup);
signupModal.addEventListener("click", (event) => {
  if (event.target === signupModal) closeSignup();
});


[signupNameEl, signupEmailEl, signupPasswordEl].forEach((field) => {
  field?.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      if (creatorMode === "edit") {
        saveExistingWeevil();
      } else {
        submitRegistration();
      }
    }
  });
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && signupModal.classList.contains("is-open")) {
    closeSignup();
  }
});

confirmSignupBtn.addEventListener("click", () => {
  if (creatorMode === "edit") {
    closeSignup();
    saveExistingWeevil();
    return;
  }
  submitRegistration();
});

renderControls();
resizeRenderer();
queueRender();
await bootstrapCreator();
