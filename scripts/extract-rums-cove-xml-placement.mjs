import { readFile } from 'node:fs/promises';
import path from 'node:path';

import {
  extractRumsCoveXmlPlacement,
  formatPlacementReport
} from '../src/rooms/RumsCoveXmlPlacementExtract.js';

const inputPath = process.argv[2] || 'xml/RumsAirport_dynamAds_videoPodv2.xml';
const absolutePath = path.resolve(process.cwd(), inputPath);
const xmlText = await readFile(absolutePath, 'utf8');
const result = extractRumsCoveXmlPlacement(xmlText);

console.log(formatPlacementReport(result));
