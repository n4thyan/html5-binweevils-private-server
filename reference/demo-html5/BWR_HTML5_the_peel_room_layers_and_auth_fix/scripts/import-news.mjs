import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT = path.resolve(__dirname, '..');
const SOURCE = path.join(ROOT, 'vendor', 'official-mirror', 'news.binweevils.app');
const OUT = path.join(ROOT, 'data', 'imported-posts.json');

function decodeHtml(value = '') {
  return value
    .replaceAll('&#8211;', '–')
    .replaceAll('&#8217;', '’')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#038;', '&');
}

function cleanText(value = '') {
  return decodeHtml(value.replace(/<[^>]+>/g, ' ')).replace(/\s+/g, ' ').trim();
}

function parseDate(value = '') {
  value = value.trim();
  const patterns = [
    /^(\d{2})\/(\d{2})\/(\d{4})$/,
    /^(\d{2})-(\d{2})-(\d{2})$/
  ];
  for (const pattern of patterns) {
    const match = value.match(pattern);
    if (!match) continue;
    const [, dd, mm, yyyy] = match;
    const year = yyyy.length === 2 ? `20${yyyy}` : yyyy;
    return `${year}-${mm}-${dd}`;
  }
  return '';
}

function extractSection(html, marker) {
  const start = html.indexOf(marker);
  if (start === -1) return '';
  let i = start;
  let depth = 0;
  let opened = false;
  while (i < html.length) {
    const openIndex = html.indexOf('<div', i);
    const closeIndex = html.indexOf('</div>', i);
    if (openIndex !== -1 && openIndex < closeIndex) {
      depth += 1;
      i = openIndex + 4;
      opened = true;
    } else if (closeIndex !== -1) {
      depth -= 1;
      i = closeIndex + 6;
      if (opened && depth === 0) {
        return html.slice(start, i);
      }
    } else {
      break;
    }
  }
  return '';
}

const indexHtml = fs.readFileSync(path.join(SOURCE, 'index.html'), 'utf8');
const cardBlocks = indexHtml.split('<div class="row blog-post-container">').slice(1);
const feed = new Map();

for (const block of cardBlocks) {
  const href = block.match(/<h2[^>]*>\s*<a href="([^"]+)"/i)?.[1] || '';
  const slug = href.replace(/\/$/, '').split('/').pop();
  if (!slug) continue;
  const title = cleanText(block.match(/<h2[^>]*>\s*<a [^>]*>([\s\S]*?)<\/a>/i)?.[1] || slug);
  const posted = cleanText(block.match(/<li>\s*Posted\s*([^<]+)<\/li>/i)?.[1] || '');
  const intro = block.match(/<div class="intro">([\s\S]*?)<\/div>/i)?.[1]?.trim() || '';
  const thumb = block.match(/<img[^>]+src="([^"]+)"/i)?.[1] || '';
  feed.set(slug, { title, posted, introHtml: intro, thumbnail: thumb });
}

const skip = new Set(['assets', 'assetsHome', 'cat', 'page', 'fan-art', 'help']);
const posts = [];

for (const entry of fs.readdirSync(SOURCE, { withFileTypes: true })) {
  if (!entry.isDirectory() || skip.has(entry.name)) continue;
  const file = path.join(SOURCE, entry.name, 'index.html');
  if (!fs.existsSync(file)) continue;
  const html = fs.readFileSync(file, 'utf8');
  const title = cleanText(html.match(/<h2 class="post-title">([\s\S]*?)<\/h2>/i)?.[1] || entry.name);
  const author = cleanText(html.match(/<li>\s*By\s*([^<]+)<\/li>/i)?.[1] || 'Official Post');
  const posted = cleanText(html.match(/<li>\s*Posted\s*([^<]+)<\/li>/i)?.[1] || '');
  const newsIn = extractSection(html, '<div class="news-v3-in">');
  let contentHtml = newsIn
    .replace(/<h2 class="post-title">[\s\S]*?<\/h2>/i, '')
    .replace(/<ul class="list-inline posted-info">[\s\S]*?<\/ul>/i, '')
    .replace(/<div class="post-counts[\s\S]*?<\/div>\s*<\/div>\s*$/i, '')
    .trim();

  const card = feed.get(entry.name) || {};
  posts.push({
    slug: entry.name,
    title,
    author,
    originalDateText: card.posted || posted,
    publishedAt: parseDate(card.posted || posted),
    introHtml: card.introHtml || '',
    thumbnail: card.thumbnail || '',
    contentHtml,
    sourceUrl: `https://news.binweevils.app/${entry.name}/`,
    originLabel: 'Official imported',
    type: 'official'
  });
}

posts.sort((a, b) => (b.publishedAt || '').localeCompare(a.publishedAt || ''));
fs.writeFileSync(OUT, JSON.stringify(posts, null, 2), 'utf8');
console.log(`Imported ${posts.length} official posts into ${OUT}`);
