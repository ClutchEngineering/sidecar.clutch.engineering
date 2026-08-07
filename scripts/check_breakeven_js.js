// Minimal DOM stub: enough to run start() and catch missing symbols.
const els = {};
const stubEl = (id) => ({
  id, value: '1', checked: false, textContent: '', innerHTML: '', className: '',
  dataset: { rig: 'tower', capex: '1092', watts: '67', cores: '14', kind: 'linux', capacity: '510', finance: 'false', preset: 'startup', step: '1' },
  style: {}, classList: { add(){}, remove(){}, toggle(){}, contains(){ return false; } },
  clientWidth: 400, scrollHeight: 500, scrollTop: 0,
  appendChild(){}, removeChild(){}, setAttribute(){}, getAttribute(){ return null; },
  removeAttribute(){}, addEventListener(){}, querySelector(){ return stubEl('x'); },
  querySelectorAll(){ return []; }, closest(){ return null; }, select(){},
  getBoundingClientRect(){ return { top: 100, left: 0, width: 400, height: 200 }; },
  offsetWidth: 80, offsetHeight: 30,
});
const withParent = (e) => { e.parentElement = stubEl('parent'); return e; };
global.document = {
  readyState: 'complete',
  body: stubEl('body'),
  getElementById: (id) => (els[id] = els[id] || withParent(stubEl(id))),
  querySelector: (s) => withParent(stubEl(s)),
  querySelectorAll: () => [],
  createElement: () => stubEl('new'),
  createElementNS: () => stubEl('svg'),
  addEventListener(){},
};
global.window = {
  innerHeight: 900, addEventListener(){},
  matchMedia: () => ({ addEventListener(){} }),
  getComputedStyle: () => ({ getPropertyValue: () => '#000' }),
};
global.getComputedStyle = window.getComputedStyle;
global.navigator = { clipboard: null };
global.localStorage = { getItem: () => null, setItem() {} };
global.requestAnimationFrame = (fn) => fn();
global.setTimeout = (fn) => fn;
const src = require('fs').readFileSync('site/scripts/gitlab-breakeven.js', 'utf8');
try { new Function(src)(); console.log('RUNS CLEAN: no missing symbols'); }
catch (e) { console.log('RUNTIME ERROR:', e.constructor.name, e.message); process.exit(1); }
