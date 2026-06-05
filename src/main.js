import { GameApp } from './core/GameApp.js';
import './styles/app.css';

const root = document.querySelector('#app');

if (!root) {
  throw new Error('Missing #app root element.');
}

const app = new GameApp({ root });
app.boot();
