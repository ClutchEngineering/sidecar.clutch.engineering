/* Charts and break-even math for the self-hosted GitLab cheat sheet.
 *
 * Uptime data is derived from the merged, maintenance-excluded downtime
 * windows published by https://mrshu.github.io/github-statuses/ (which replays
 * archived githubstatus.com Atom snapshots). Each entry is
 * [month, uptime percent, downtime minutes].
 */

/* Rolling 90-day uptime, one value per day from 2022-06-24 to 2026-08-05.
 * Same method as the source: merge every non-maintenance downtime window, then
 * for each day measure what fraction of the previous 90 days was healthy. */
const ROLLING_START = [2022, 6, 24];
const ROLLING = "97.17,97.26,97.26,97.45,97.49,97.61,97.54,97.8,97.79,97.79,97.79,97.79,97.79,97.79,97.79,97.79,97.79,97.79,97.9,98.05,98.12,98.12,98.12,98.12,98.12,98.26,98.26,98.26,98.26,98.26,98.26,98.5,98.5,98.56,98.49,98.19,98.19,98.19,98.19,98.19,98.19,98.19,98.19,98.19,98.19,98.19,98.19,98.28,98.22,98.22,98.22,98.22,98.22,98.14,98.01,98,97.9,97.9,97.88,97.78,97.92,98.07,98.06,98.06,98.06,98.06,98.06,97.8,97.83,97.83,97.83,97.83,97.83,97.83,97.83,97.79,97.22,97.02,96.97,96.97,97.1,97.1,96.69,95.85,95.95,95.95,95.95,96.16,96.37,96.31,96.31,96.16,96.16,96.16,96.16,96.18,96.22,96.04,96.05,96.05,96.05,96.05,96.05,95.97,95.74,95.7,95.7,95.7,95.7,95.7,95.7,95.68,95.51,95.51,95.51,95.58,95.58,95.56,95.43,95.43,95.39,95.39,95.24,95.24,95.24,95.34,95.27,95.27,95.27,95.27,95.27,95.19,95.19,95.16,95.15,95.15,95.13,94.9,94.89,94.89,94.89,94.89,94.89,95,95.13,95.08,95.22,95.22,95.23,95.33,95.3,95.3,95.31,95.39,95.39,95.2,95.16,95.42,95.4,95.38,95.33,95.33,95.33,95.33,95.33,95.34,95.77,95.96,96.02,96.02,96,96,96.41,97.2,97.2,97.16,97.16,97.16,97.16,97.25,97.14,97.29,97.29,97.29,97.29,97.29,97.31,97.49,97.49,97.49,97.49,97.42,97.33,97.41,97.64,97.68,97.68,97.68,97.65,97.65,97.65,97.62,97.79,97.75,97.75,97.66,97.66,97.64,97.77,97.68,97.46,97.46,97.62,97.62,97.68,97.88,97.83,97.8,97.8,97.65,97.65,97.47,97.13,97.15,96.97,96.97,96.98,97.21,97.17,97,96.21,96.21,96.21,96.21,96.21,96.25,96.24,96.23,96.24,96.22,96.18,96.15,96.15,96.15,96.15,96.34,96.38,96.38,96.4,96.28,96.26,96.12,96.09,95.83,95.83,95.88,95.92,95.9,95.9,95.8,95.82,95.82,95.82,95.87,95.87,95.85,95.85,95.85,95.85,95.85,95.92,95.9,95.79,95.74,95.72,95.72,95.71,95.66,95.59,95.38,95.38,95.41,95.5,95.5,95.4,95.4,95.4,95.4,95.43,95.43,95.43,95.49,95.49,95.53,95.53,95.61,95.61,95.65,95.61,95.65,95.85,95.85,95.85,95.85,95.85,95.7,95.65,95.66,95.61,95.74,95.74,96.01,96.34,96.32,96.51,96.49,96.49,96.49,96.59,96.78,96.97,96.45,96.17,96.17,96.17,96.19,96.2,96.19,96.08,96.09,96.16,96.2,96.2,96.2,96.2,96.2,96.2,96.2,96.2,96.33,96.41,96.55,96.58,96.84,96.84,96.84,96.94,96.97,96.97,96.98,96.93,96.89,96.89,96.89,96.83,96.88,96.88,96.85,96.84,96.84,96.89,96.89,96.99,97.04,97.07,97.07,97.08,97.11,97.18,97.39,97.33,96.92,96.92,96.92,97.02,96.99,96.99,96.73,96.73,96.67,96.67,96.67,96.67,96.67,96.64,96.64,96.64,96.64,96.68,96.74,96.74,96.74,96.74,96.7,96.7,96.85,97.03,97.05,97.03,96.96,96.84,96.84,96.84,96.88,96.87,96.89,96.89,96.89,96.89,96.89,97.49,98,98.26,98.08,98.04,98.04,98.05,98.07,97.97,97.97,97.94,97.94,97.94,97.94,97.88,97.83,97.8,97.8,97.8,97.8,97.8,97.8,97.53,97.34,97.34,97.31,97.31,97.31,97.27,96.95,96.77,96.79,96.79,96.79,96.85,96.86,96.86,96.73,96.7,96.7,96.7,96.72,96.71,96.53,96.28,96.28,96.26,96.27,96.27,96.27,96.33,96.77,96.77,96.77,96.77,96.79,96.79,97.05,97.05,97.01,96.92,96.92,96.92,96.9,96.93,96.93,96.93,96.93,96.93,96.93,96.97,96.85,96.85,96.89,96.89,96.89,96.85,96.86,96.92,96.9,97.02,97.02,97.02,97.02,97.03,97.03,97.03,97.03,96.88,96.88,96.88,96.88,96.88,97.05,97.09,97.09,97.06,97.06,97.24,97.24,97.2,97.2,97.2,97.2,97.25,97.3,97.28,97.28,97.28,97.28,97.28,97.28,97.47,97.57,97.57,97.59,97.48,97.48,97.52,97.94,98.16,98.18,98.18,98.18,98.18,98.18,98.18,98.35,98.38,98.38,98.38,98.38,98.39,98.56,98.74,98.74,98.76,98.76,98.76,98.76,98.76,98.79,98.69,98.68,98.59,98.59,98.59,98.59,98.59,98.5,98.58,98.58,98.58,98.6,98.45,98.34,98.34,98.34,98.34,98.34,98.34,98.46,98.46,98.46,98.46,98.46,98.5,98.22,98.22,98.19,98.19,98.19,98.19,98.19,97.58,97.58,97.58,97.55,97.63,97.63,97.63,97.63,97.65,97.65,97.65,97.65,97.67,97.67,97.69,97.43,97.51,97.51,97.51,97.51,97.51,97.51,97.56,97.56,97.56,97.56,97.56,97.56,97.62,97.64,97.64,97.64,97.67,97.56,97.56,97.56,97.56,97.56,97.56,97.56,97.56,97.56,97.56,97.26,97.2,97.1,97.1,97.07,97.07,97.08,97.15,97.15,97.15,97.15,97.15,97.15,97.15,97.15,97.25,97.26,97.35,97.35,97.35,97.35,97.35,97.55,97.55,97.5,97.46,97.43,97.59,97.7,97.59,97.47,97.47,97.47,97.47,97.12,97.03,97.03,96.99,96.97,96.97,97.25,97.25,97.39,97.39,97.1,97.1,97.03,97.63,97.63,97.63,97.66,97.73,97.5,97.38,97.38,97.39,97.39,97.32,97.32,97.33,97.33,97.33,97.6,97.45,97.33,97.33,97.29,97.29,97.29,97.29,97.28,96.94,96.94,96.92,96.92,96.92,97,97,96.95,97.03,97.14,97.14,97.14,97.14,97.14,97.14,97.03,97.01,97.01,97.01,97.31,97.38,97.42,97.42,97.45,97.45,97.45,97.45,97.45,97.41,97.37,97.37,97.37,97.37,97.37,97.37,97.37,97.37,97.34,97.09,97.09,97.09,97.05,96.94,96.94,96.98,96.92,96.92,96.92,97,97.12,97.12,96.95,96.95,96.41,96.5,96.5,96.44,96.41,96.34,96.12,96.12,96.12,96.12,96.39,96.39,96.44,96.44,96.44,96.44,96.44,96.23,96.2,96.33,96.33,96.33,96.33,96.4,96.4,96.4,96.4,96.4,96.4,96.55,96.64,96.62,96.62,96.57,96.57,96.57,96.59,96.93,96.93,96.9,96.84,96.84,96.84,96.84,96.89,96.85,96.77,96.65,96.65,96.65,96.65,96.65,96.76,96.78,96.71,96.71,96.71,96.71,96.76,96.76,96.76,96.76,96.69,96.67,96.67,96.61,96.65,96.65,96.65,96.65,96.65,96.65,96.65,96.64,96.62,96.62,96.62,96.62,96.67,96.76,96.82,96.82,96.9,96.9,96.9,96.93,96.93,96.63,96.8,96.8,97.4,97.35,97.35,97.45,97.5,97.56,97.78,97.78,97.78,97.78,97.8,97.8,97.83,97.8,97.8,97.8,97.8,98.01,98.26,98.15,98.15,98.15,98.15,98.15,98.15,98.15,98.15,98.15,98.15,98.15,98.18,98.2,98.24,98.28,98.28,98.28,98.28,98.28,98.28,98.32,98.38,98.31,98.31,98.31,98.31,98.22,98.31,98.43,98.32,98.32,98.32,98.29,98.24,98.19,98.24,98.24,98.22,98.22,98.22,98.22,98.22,98.22,98.29,98.32,98.32,98.42,98.42,98.37,98.37,98.37,98.35,98.35,98.35,98.36,98.41,98.65,98.65,98.65,98.65,98.66,98.66,98.66,98.66,98.57,98.56,98.56,98.56,98.86,98.78,98.78,98.85,98.9,98.9,98.9,98.88,98.85,98.85,98.43,98.43,98.43,98.43,98.43,98.43,98.47,98.14,98.14,98.14,98.14,98.13,98.24,98.16,98.11,98.11,98.11,98.11,98.11,98.11,97.98,97.91,97.91,97.91,97.91,97.91,97.87,97.8,97.8,97.62,97.43,97.4,97.42,97.42,97.48,97.48,97.48,97.48,97.62,97.46,97.32,97.31,97.27,97.24,97.27,97.32,97.31,97.34,97.34,97.35,97.28,97.24,97.24,97.24,97.24,97.21,97.21,97.21,97.21,97.21,97.06,96.88,96.84,96.8,96.55,96.55,96.55,96.55,96.55,96.55,96.55,96.45,96.45,96.45,96.38,96.34,96.37,96.37,96.37,96.37,96.37,96.44,96.42,96.46,96.46,96.44,96.44,96.46,96.5,96.21,95.51,94.69,94.69,94.69,94.69,94.69,94.69,94.97,94.97,94.97,94.97,94.98,94.83,94.78,94.79,94.75,94.75,94.75,94.75,94.75,94.88,94.95,94.87,94.87,94.87,94.87,94.9,94.96,94.53,94.02,93.54,93.45,93.45,93.45,93.24,93.24,93.15,93.11,93.11,93.26,93.25,93.18,93.05,93.08,92.72,92.72,92.78,92.78,92.78,92.72,92.73,92.64,92.64,92.64,92.64,92.12,92.04,91.89,91.89,91.89,92.09,92.27,92.29,91.81,92.05,92.03,92.03,92.03,92.03,91.96,91.97,91.65,91.65,91.65,91.72,91.73,91.79,91.78,91.71,91.71,91.71,91.71,91.67,91.75,91.75,91.76,91.76,91.76,91.76,92.06,93.17,93.84,93.84,93.84,93.84,93.84,93.72,93.76,93.71,93.71,93.71,93.71,93.85,93.65,93.48,93.52,93.52,93.45,93.45,93.45,93.45,93.33,93.42,93.42,93.42,93.42,93.43,93.41,93.67,94.37,94.86,94.97,94.97,94.97,95.18,95.14,95.21,95.12,95.12,95.12,95.28,95.46,95.63,95.59,95.95,95.95,95.95,95.95,95.95,95.99,96.06,96.08,96.08,96.08,96.08,96.63,96.71,96.83,96.83,96.83,96.31,95.2,94.25,94.74,94.61,94.63,94.63,94.63,94.63,94.7,94.53,94.91,94.88,94.88,94.88,94.91,94.85,94.88,94.21,93.16,93.11,93.11,93.17,93.27,93.08,93.07,92.98,92.98,92.98,92.98,92.98,93.02,93.02,93.02,92.97,92.97,93.09,92.88,92.65,92.59,92.43,92.4,92.4,92.74,92.89,92.86,92.54,92.6,92.6,92.43,92.43,92.3,92.3,92.26,92.26,92.26,92.26,92.27,92.44,92.24,92.23,92.22,92.22,92.22,92.22,92.12,92.06,91.84,90.73,90.71,90.71,90.71,90.62,90.66,90.66,90.66,90.59,90.59,90.59,90.61,90.61,90.65,90.65,90.48,90.48,90.48,90.37,90.4,90.25,90.09,90.61,91.72,92.69,92.55,92.68,92.68,92.56,92.56,92.56,92.56,92.71,92.68,92.71,92.71,92.71,92.71,92.77,92.77,93.51,93.7,93.75,93.75,93.75,93.75,93.94,93.87,93.84,93.81,93.52,93.41,93.41,93.51,93.38,93.14,93.06,93.05,92.92,93.13,93.41,93.35,93.4,93.37,93.37,93.37,93.42,93.24,93.56,93.54,93.54,93.69,93.69,93.93,93.64,93.43,93.44,93.44,93.37,93.37,93.37,92.89,92.58,92.21,91.53,91.47,91.47,91.62,91.69,91.96,93.03,93.04,92.73,92.73,92.82,92.53,92.49,92.42,92.44,92.26,92.26,92.26,92.08,91.77,91.77,91.7,91.37,91.37,91.48,91.33,91.45,91.5,90.67,90.56,90.56,90.75,90.73,90.73,90.72,90.24,90.23,90.23,90.21,90.27,90.06,90.06,90.06,89.95,89.95,89.95,89.8,89.96,89.43,89.24,89.24,89.24,89.24,89.31,89.43,89.47,89.15,89.25,89.25,89.26,89.23,89.28,89.41,89.26,89.37,89.37,89.37,89,88.4,87.78,87.54,87.31,87.3,87.5,87.21,86.78,85.67,84.58,84.38,84.38,84.68,84.88,84.65,84.34,84.31,84.31,84.31,84.99,85.49,85.73,86.35,86.41,86.38,86.38,86.38,86.47,86.08,86,86.31,86.31,86.15,86.44,86.47,86.37,86.37,86.45,86.45,86.45,86.62,86.6,86.59,86.46,86.52,86.47,86.32,86.47,86.39,86.5,87.27,87.31,87.31,87.31,87.33,87.26,87.35,87.43,87.43,87.43,87.48,87.48,87.69,87.67,87.67,87.76,87.76,87.46,87.47,88.17,88.69,88.76,88.69,88.69,88.69,88.69,88.69,88.59,89.19,88.74,88.74,88.74,88.9,89.07,88.98,89.14,89.01,89,89,89.47,89.85,90.32,90.45,90.6,90.53,90.46,90.75,91.19,92.3,93.31,93.45,93.45,93.36,93.41,93.57,93.88".split(',').map(Number);


const MONTH_NAMES = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const SVG_NS = 'http://www.w3.org/2000/svg';

// The box draws power around the clock.
const HOURS_PER_MONTH = 730;

// Nobody works 730 hours a month, so an outage only costs you the part of it
// that lands while somebody is trying to push.
const WORK_HOURS_PER_MONTH = 160;

// Starting points, so the sliders open somewhere real.
const PROFILES = {
  ios: {
    label: 'Solo iOS dev',
    note: 'An hour costs what you could have earned selling it. Mac runs macOS runners, mini PC hosts GitLab.',
    machines: { budget: 1, mac: 1, ups: 1 },
    finance: true,
    values: { devs: 1, rate: 95, plan: 0, linux: 1500, macos: 5000, ghup: 89.9, selfup: 99.5, block: 25, kwh: 0.16, admin: 2 },
  },
  web: {
    label: 'Solo web dev',
    note: 'A senior freelance web rate, where an idle hour is unbilled.',
    machines: { budget: 1, ups: 1 },
    values: { devs: 1, rate: 115, plan: 0, linux: 3000, macos: 0, ghup: 89.9, selfup: 99.5, block: 20, kwh: 0.16, admin: 2 },
  },
  startup: {
    label: 'Small startup',
    note: 'Eight salaried engineers on Team seats, costed as staff rather than contractors.',
    machines: { tower: 1, ups: 1 },
    values: { devs: 8, rate: 85, plan: 1, linux: 20000, macos: 2000, ghup: 89.9, selfup: 99.5, block: 15, kwh: 0.16, admin: 3 },
  },
  scaleup: {
    label: 'Scaling team',
    note: 'Thirty engineers on Enterprise. 80,000 minutes is eight jobs at once in business hours, so one tower runs GitLab and one runs the runners.',
    machines: { tower: 2, mac: 1, ups: 2 },
    values: { devs: 30, rate: 95, plan: 2, linux: 80000, macos: 6000, ghup: 89.9, selfup: 99.7, block: 15, kwh: 0.16, admin: 8 },
  },
};

// Read off github.com/pricing on 2026-08-06. Both paid tiers are advertised as
// first-12-months rates and Enterprise is "starting at", so these are floors.
const PLANS = [
  { name: 'Free', seat: 0, included: 2000 },
  { name: 'Team', seat: 4, included: 3000 },
  { name: 'Enterprise', seat: 21, included: 50000 },
];

// CI minutes span three orders of magnitude, from a solo dev's few thousand to
// a fleet's half million, so the sliders are logarithmic: 1000 ticks mapped
// onto a curve that keeps fine control down at the low end.
const MINUTE_CEILING = 500000;
const MINUTE_TICKS = 1000;

function tickToMinutes(tick) {
  if (tick <= 0) return 0;
  const raw = Math.pow(MINUTE_CEILING + 1, tick / MINUTE_TICKS) - 1;
  const step = raw < 1000 ? 10 : raw < 20000 ? 100 : 500;
  return Math.round(raw / step) * step;
}

function minutesToTick(minutes) {
  if (minutes <= 0) return 0;
  const tick = MINUTE_TICKS * Math.log(minutes + 1) / Math.log(MINUTE_CEILING + 1);
  return Math.round(Math.max(0, Math.min(MINUTE_TICKS, tick)));
}

// Published per-minute rates. `standard` runners draw on the plan's free
// allowance; larger runners are billed from the first minute and never touch it.
const LINUX_RATE = 0.006;
const MACOS_MULTIPLIER = 10;

const LINUX_TIERS = [
  { label: '2-core', rate: 0.006, cores: 2, standard: true },
  { label: '4-core', rate: 0.012, cores: 4, standard: false },
  { label: '8-core', rate: 0.022, cores: 8, standard: false },
  { label: '16-core', rate: 0.042, cores: 16, standard: false },
];

// Apple silicon is dearer than Intel here despite fewer cores: the 5-core
// M2 Pro bills at $0.102 against $0.077 for the 12-core Intel.
const MAC_TIERS = [
  { label: '4-core', rate: 0.062, cores: 4, standard: true },
  { label: '5-core M2 Pro', rate: 0.102, cores: 5, standard: false },
  { label: '12-core Intel', rate: 0.077, cores: 12, standard: false },
];

// ---------------------------------------------------------------- utilities

function el(name, attrs, text) {
  const node = document.createElementNS(SVG_NS, name);
  for (const key in attrs) node.setAttribute(key, attrs[key]);
  if (text !== undefined) node.textContent = text;
  return node;
}

// Reading a custom property forces a style recalc, and the charts read eleven
// of them per draw. They only change with the colour scheme.
let inkCache = null;

function ink(role) {
  if (!inkCache) {
    const styles = getComputedStyle(document.querySelector('.cs'));
    inkCache = {};
    ['--grid', '--axis', '--ink-muted', '--surface', '--good', '--warning',
     '--serious', '--critical', '--series-1', '--series-2', '--ink']
      .forEach((token) => { inkCache[token] = styles.getPropertyValue(token).trim(); });
  }
  return inkCache[role] || '';
}

function money(value) {
  const rounded = Math.round(value);
  if (Math.abs(rounded) >= 1000000) return '$' + (rounded / 1000000).toFixed(2) + 'M';
  if (Math.abs(rounded) >= 10000) return '$' + Math.round(rounded / 1000) + 'k';
  return '$' + rounded.toLocaleString('en-US');
}


function rollingDate(index) {
  const d = new Date(Date.UTC(ROLLING_START[0], ROLLING_START[1] - 1, ROLLING_START[2]));
  d.setUTCDate(d.getUTCDate() + index);
  return MONTH_NAMES[d.getUTCMonth()] + ' ' + d.getUTCDate() + ', ' + d.getUTCFullYear();
}


/** Attaches a crosshair + tooltip to a plot.
 *
 *  Assigns rather than adds, because the wrapper outlives the SVG: the draw
 *  functions run on every refresh, and addEventListener would stack a new
 *  handler each time until a single mouse move ran hundreds of them.
 *  Points are uniformly spaced, so the nearest index is closed-form.
 */
function bindHover(svg, tip, { count, x, y, describe }, render) {
  const wrap = svg.parentElement;

  wrap.onpointermove = (event) => {
    const box = svg.getBoundingClientRect();
    const span = count > 1 ? x(count - 1) - x(0) : 1;
    const ratio = (event.clientX - box.left - x(0)) / span;
    const index = Math.max(0, Math.min(count - 1, Math.round(ratio * (count - 1))));

    tip.innerHTML = describe(index);
    tip.style.opacity = '1';
    const half = tip.offsetWidth / 2;
    tip.style.left = Math.round(Math.min(Math.max(x(index), half), box.width - half)) + 'px';
    tip.style.top = Math.round(Math.max(y(index) - 12, tip.offsetHeight + 2)) + 'px';
    render(index);
  };

  wrap.onpointerleave = () => {
    tip.style.opacity = '0';
    render(-1);
  };
}

// The uptime chart exposes a marker so other parts of the page can point at a
// date on it; the drawing pass installs the implementation.
let markUptimeDay = () => {};

// -------------------------------------------------------------- uptime chart

function drawUptime() {
  const svg = document.getElementById('uptime-plot');
  const tip = document.getElementById('uptime-tip');
  if (!svg) return;

  const width = svg.clientWidth || svg.parentElement.clientWidth;
  if (!width) return;
  const compact = width < 620;
  const height = compact ? 190 : 240;
  const pad = { top: 20, right: compact ? 10 : 96, bottom: 34, left: 38 };
  const plotW = width - pad.left - pad.right;
  const plotH = height - pad.top - pad.bottom;

  svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
  svg.setAttribute('height', height);
  svg.innerHTML = '';

  const yMin = 75;
  const yMax = 100;
  const last = ROLLING.length - 1;
  const x = (i) => pad.left + (plotW * i) / last;
  const y = (v) => pad.top + plotH * (1 - (Math.max(yMin, Math.min(yMax, v)) - yMin) / (yMax - yMin));

  const gridColor = ink('--grid');
  const muted = ink('--ink-muted');
  const surface = ink('--surface');
  const good = ink('--good');
  const warning = ink('--warning');
  const serious = ink('--serious');
  const critical = ink('--critical');

  // The line is coloured by how bad the number is, and the number maps to
  // height, so one vertical gradient does the whole job.
  const defs = el('defs');
  const ramp = [[100, good], [96.5, good], [94, warning], [90, serious], [86, critical], [75, critical]];
  const stroke = el('linearGradient', {
    id: 'uptimeStroke', gradientUnits: 'userSpaceOnUse',
    x1: 0, y1: pad.top, x2: 0, y2: pad.top + plotH,
  });
  const fill = el('linearGradient', {
    id: 'uptimeFill', gradientUnits: 'userSpaceOnUse',
    x1: 0, y1: pad.top, x2: 0, y2: pad.top + plotH,
  });
  ramp.forEach(([value, color]) => {
    const offset = ((yMax - value) / (yMax - yMin) * 100).toFixed(1) + '%';
    stroke.appendChild(el('stop', { offset, 'stop-color': color }));
    fill.appendChild(el('stop', {
      offset, 'stop-color': color,
      'stop-opacity': (0.30 * (1 - (yMax - value) / (yMax - yMin))).toFixed(3),
    }));
  });
  defs.appendChild(stroke);
  defs.appendChild(fill);
  svg.appendChild(defs);

  for (let v = yMin; v <= yMax; v += 5) {
    svg.appendChild(el('line', {
      x1: pad.left, x2: pad.left + plotW, y1: y(v), y2: y(v),
      stroke: gridColor, 'stroke-width': 1, 'stroke-dasharray': v === yMin ? '' : '3 4',
    }));
    svg.appendChild(el('text', {
      x: pad.left - 7, y: y(v) + 3.5, 'text-anchor': 'end', 'font-size': 10, fill: muted,
    }, v + '%'));
  }

  // Two nines, which is the bar GitHub is now failing to clear.
  svg.appendChild(el('line', {
    x1: pad.left, x2: pad.left + plotW, y1: y(99), y2: y(99),
    stroke: critical, 'stroke-width': 1.5, 'stroke-dasharray': '5 4', opacity: 0.7,
  }));
  if (!compact) {
    svg.appendChild(el('text', {
      x: pad.left + plotW + 6, y: y(99) + 3.5, 'font-size': 10.5, fill: critical,
    }, '99% ("two nines")'));
  }

  // Year boundaries.
  for (let year = 2023; year <= 2026; year++) {
    const index = Math.round(
      (Date.UTC(year, 0, 1) - Date.UTC(ROLLING_START[0], ROLLING_START[1] - 1, ROLLING_START[2])) / 86400000
    );
    if (index < 0 || index > last) continue;
    svg.appendChild(el('line', {
      x1: x(index), x2: x(index), y1: pad.top, y2: pad.top + plotH,
      stroke: gridColor, 'stroke-width': 1,
    }));
    svg.appendChild(el('text', {
      x: x(index), y: height - 20, 'text-anchor': 'middle', 'font-size': 11,
      'font-weight': 600, fill: muted,
    }, String(year)));
  }

  const line = ROLLING.map((v, i) => `${i ? 'L' : 'M'}${x(i).toFixed(1)} ${y(v).toFixed(1)}`).join(' ');
  svg.appendChild(el('path', {
    d: `${line} L${x(last).toFixed(1)} ${pad.top + plotH} L${pad.left} ${pad.top + plotH} Z`,
    fill: 'url(#uptimeFill)',
  }));
  svg.appendChild(el('path', {
    d: line, fill: 'none', stroke: 'url(#uptimeStroke)', 'stroke-width': 1.75,
    'stroke-linejoin': 'round',
  }));

  // Peak, trough, today.
  let peak = 0;
  let low = 0;
  ROLLING.forEach((v, i) => {
    if (v > ROLLING[peak]) peak = i;
    if (v < ROLLING[low]) low = i;
  });

  const annotate = (i, color, dy, text) => {
    svg.appendChild(el('circle', {
      cx: x(i), cy: y(ROLLING[i]), r: 4, fill: color, stroke: surface, 'stroke-width': 2,
    }));
    if (compact) return;
    const anchor = i > last - 120 ? 'end' : i < 120 ? 'start' : 'middle';
    svg.appendChild(el('text', {
      x: x(i) + (anchor === 'end' ? 8 : anchor === 'start' ? -8 : 0),
      y: y(ROLLING[i]) + dy, 'text-anchor': anchor,
      'font-size': 11, 'font-weight': 700, fill: color,
    }, text));
  };

  annotate(peak, good, -10, `peak: ${ROLLING[peak].toFixed(2)}% (${rollingDate(peak)})`);
  annotate(low, critical, 20, `low: ${ROLLING[low].toFixed(2)}% (${rollingDate(low)})`);
  annotate(last, critical, -10, `today: ${ROLLING[last].toFixed(2)}%`);

  svg.appendChild(el('text', {
    x: pad.left, y: height - 4, 'font-size': 10, fill: muted,
  }, 'start: ' + rollingDate(0)));
  svg.appendChild(el('text', {
    x: pad.left + plotW, y: height - 4, 'text-anchor': 'end', 'font-size': 10, fill: muted,
  }, 'today: ' + rollingDate(last)));

  const crosshair = el('line', {
    y1: pad.top, y2: pad.top + plotH, stroke: muted, 'stroke-width': 1, opacity: 0,
  });
  const marker = el('circle', { r: 4, fill: surface, stroke: muted, 'stroke-width': 2, opacity: 0 });
  svg.appendChild(crosshair);
  svg.appendChild(marker);

  markUptimeDay = (index, label) => {
    if (index < 0) {
      crosshair.setAttribute('opacity', 0);
      marker.setAttribute('opacity', 0);
      tip.style.opacity = '0';
      return;
    }
    crosshair.setAttribute('x1', x(index));
    crosshair.setAttribute('x2', x(index));
    crosshair.setAttribute('opacity', 1);
    marker.setAttribute('cx', x(index));
    marker.setAttribute('cy', y(ROLLING[index]));
    marker.setAttribute('opacity', 1);
    tip.innerHTML = `<b>${rollingDate(index)}</b><br>${ROLLING[index].toFixed(2)}% over the prior 90 days`;
    const half = tip.offsetWidth / 2;
    tip.style.left = Math.round(Math.min(Math.max(x(index), half), width - half)) + 'px';
    tip.style.top = Math.round(Math.max(y(ROLLING[index]) - 12, tip.offsetHeight + 2)) + 'px';
    tip.style.opacity = '1';
  };

  bindHover(svg, tip, {
    count: ROLLING.length,
    x,
    y: (i) => y(ROLLING[i]),
    describe: (i) => `<b>${rollingDate(i)}</b><br>${ROLLING[i].toFixed(2)}% over the prior 90 days`,
  }, (index) => {
    const visible = index >= 0 ? 1 : 0;
    crosshair.setAttribute('opacity', visible);
    marker.setAttribute('opacity', visible);
    if (index < 0) return;
    crosshair.setAttribute('x1', x(index));
    crosshair.setAttribute('x2', x(index));
    marker.setAttribute('cx', x(index));
    marker.setAttribute('cy', y(ROLLING[index]));
  });
}

// ------------------------------------------------------------ break-even model

function readInputs() {
  const num = (id) => parseFloat(document.getElementById(id).value);
  const totals = machineTotals();
  return {
    devs: num('f-devs'),
    rate: num('f-rate'),
    plan: PLANS[Number(document.querySelector('input[name="plan"]:checked').value)],
    linuxTier: LINUX_TIERS[Number(document.getElementById('f-linux-tier').value)],
    macTier: MAC_TIERS[Number(document.getElementById('f-mac-tier').value)],
    linux: tickToMinutes(num('f-linux')),
    macos: tickToMinutes(num('f-macos')),
    githubUptime: num('f-ghup'),
    selfUptime: num('f-selfup'),
    blocked: num('f-block') / 100,
    capex: totals.capex,
    watts: totals.watts,
    financed: financeOn() ? totals.financeable : 0,
    hasMachines: totals.capex > 0,
    totals,
    kwh: num('f-kwh'),
    admin: num('f-admin'),
  };
}

// Apple Card spreads a Mac over 12 interest-free instalments.
const FINANCE_MONTHS = 12;
const AMORTIZE_MONTHS = 36;

function financeOn() {
  const box = document.getElementById('f-finance');
  return Boolean(box && box.checked);
}

function model(input) {
  const seats = input.devs * input.plan.seat;

  // Standard runners eat the free allowance, priced in 2-core-equivalent
  // minutes. Larger runners bypass it and bill from minute one.
  let allowanceMinutes = 0;
  let actions = 0;
  if (input.linuxTier.standard) allowanceMinutes += input.linux;
  else actions += input.linux * input.linuxTier.rate;
  if (input.macTier.standard) allowanceMinutes += input.macos * MACOS_MULTIPLIER;
  else actions += input.macos * input.macTier.rate;

  const chargeable = Math.max(0, allowanceMinutes - input.plan.included);
  actions += chargeable * LINUX_RATE;

  const githubDownHours = ((100 - input.githubUptime) / 100) * WORK_HOURS_PER_MONTH;
  const selfDownHours = ((100 - input.selfUptime) / 100) * WORK_HOURS_PER_MONTH;
  const githubDowntime = input.devs * githubDownHours * input.blocked * input.rate;
  const selfDowntime = input.devs * selfDownHours * input.blocked * input.rate;

  const power = (input.watts * HOURS_PER_MONTH / 1000) * input.kwh;
  const admin = input.admin * input.rate;

  const githubMonthly = seats + actions + githubDowntime;
  const selfMonthly = power + admin + selfDowntime;
  const delta = githubMonthly - selfMonthly;

  // Anything on Apple Card is not owed on day one.
  const upfront = input.capex - input.financed;
  const perInstalment = input.financed / FINANCE_MONTHS;
  const selfCumulative = (m) =>
    upfront + selfMonthly * m + perInstalment * Math.min(m, FINANCE_MONTHS);

  // The instalment plan makes the curve piecewise, so solve it by walking it.
  // With nothing in the basket there is no outlay to pay off at all.
  let breakeven = null;
  if (input.hasMachines) {
    for (let m = 0.05; m <= 120; m += 0.05) {
      if (githubMonthly * m >= selfCumulative(m)) { breakeven = m; break; }
    }
  }

  return {
    seats, actions, chargeable, allowanceMinutes, githubDownHours, selfDownHours,
    githubDowntime, selfDowntime, power, admin,
    githubMonthly, selfMonthly, delta,
    hardwareMonthly: input.capex / AMORTIZE_MONTHS,
    selfAllIn: selfMonthly + input.capex / AMORTIZE_MONTHS,
    selfCumulative,
    breakeven,
    threeYear: githubMonthly * 36 - selfCumulative(36),
  };
}

function drawBreakeven(input, result) {
  const svg = document.getElementById('breakeven-plot');
  const tip = document.getElementById('breakeven-tip');
  if (!svg) return;

  const months = 36;
  const width = svg.clientWidth || svg.parentElement.clientWidth;
  if (!width) return;
  const compact = width < 480;
  const height = compact ? 150 : 168;
  const pad = { top: 14, right: compact ? 10 : 48, bottom: 20, left: 42 };
  const plotW = width - pad.left - pad.right;
  const plotH = height - pad.top - pad.bottom;

  svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
  svg.setAttribute('height', height);
  svg.innerHTML = '';

  const github = [];
  const self = [];
  for (let m = 0; m <= months; m++) {
    github.push(result.githubMonthly * m);
    self.push(result.selfCumulative(m));
  }

  const peak = Math.max(github[months], self[months], 1);
  const yMax = peak * 1.1;
  const x = (m) => pad.left + (plotW * m) / months;
  const y = (v) => pad.top + plotH * (1 - v / yMax);

  const gridColor = ink('--grid');
  const muted = ink('--ink-muted');
  const axisColor = ink('--axis');
  const surface = ink('--surface');
  const ghColor = ink('--series-2');
  const selfColor = ink('--series-1');

  for (let i = 0; i <= 3; i++) {
    const v = (yMax * i) / 3;
    svg.appendChild(el('line', {
      x1: pad.left, x2: pad.left + plotW, y1: y(v), y2: y(v),
      stroke: gridColor, 'stroke-width': 1,
    }));
    svg.appendChild(el('text', {
      x: pad.left - 7, y: y(v) + 3.5, 'text-anchor': 'end',
      'font-size': 10, fill: muted,
    }, money(v)));
  }

  for (let m = 0; m <= months; m += 12) {
    svg.appendChild(el('text', {
      x: x(m), y: height - 8, 'text-anchor': 'middle', 'font-size': 10, fill: muted,
    }, m === 0 ? 'day 1' : m + 'mo'));
  }

  const path = (values) => values.map((v, m) => `${m ? 'L' : 'M'}${x(m).toFixed(1)} ${y(v).toFixed(1)}`).join(' ');

  // Break-even marker, drawn under the lines.
  if (result.breakeven !== null && result.breakeven <= months) {
    const bx = x(result.breakeven);
    svg.appendChild(el('line', {
      x1: bx, x2: bx, y1: pad.top, y2: pad.top + plotH,
      stroke: axisColor, 'stroke-width': 1.5, 'stroke-dasharray': '4 3',
    }));
    svg.appendChild(el('circle', {
      cx: bx, cy: y(result.selfCumulative(result.breakeven)), r: 5,
      fill: ink('--good'), stroke: surface, 'stroke-width': 2,
    }));
    svg.appendChild(el('text', {
      x: bx + 6, y: pad.top + 11, 'font-size': 10.5, 'font-weight': 600, fill: ink('--good'),
    }, 'break-even'));
  }

  svg.appendChild(el('path', { d: path(github), fill: 'none', stroke: ghColor, 'stroke-width': 2, 'stroke-linejoin': 'round' }));
  svg.appendChild(el('path', { d: path(self), fill: 'none', stroke: selfColor, 'stroke-width': 2, 'stroke-linejoin': 'round' }));

  if (!compact) {
    svg.appendChild(el('text', {
      x: x(months) + 6, y: y(github[months]) + 3.5, 'font-size': 10.5,
      'font-weight': 600, fill: ghColor,
    }, 'GitHub'));
    svg.appendChild(el('text', {
      x: x(months) + 6, y: y(self[months]) + 3.5, 'font-size': 10.5,
      'font-weight': 600, fill: selfColor,
    }, 'Self'));
  }

  const crosshair = el('line', { y1: pad.top, y2: pad.top + plotH, stroke: axisColor, 'stroke-width': 1, opacity: 0 });
  const ghDot = el('circle', { r: 4, fill: ghColor, stroke: surface, 'stroke-width': 2, opacity: 0 });
  const selfDot = el('circle', { r: 4, fill: selfColor, stroke: surface, 'stroke-width': 2, opacity: 0 });
  svg.appendChild(crosshair);
  svg.appendChild(ghDot);
  svg.appendChild(selfDot);

  bindHover(svg, tip, {
    count: months + 1,
    x,
    y: (m) => Math.min(y(github[m]), y(self[m])),
    describe: (m) =>
      `<b>Month ${m}</b><br>GitHub ${money(github[m])}<br>Self-hosted ${money(self[m])}`,
  }, (index) => {
    const visible = index >= 0 ? 1 : 0;
    crosshair.setAttribute('opacity', visible);
    ghDot.setAttribute('opacity', visible);
    selfDot.setAttribute('opacity', visible);
    if (index < 0) return;
    crosshair.setAttribute('x1', x(index));
    crosshair.setAttribute('x2', x(index));
    ghDot.setAttribute('cx', x(index));
    ghDot.setAttribute('cy', y(github[index]));
    selfDot.setAttribute('cx', x(index));
    selfDot.setAttribute('cy', y(self[index]));
  });
}

function refresh() {
  const input = readInputs();
  const result = model(input);

  const set = (id, value) => { const node = document.getElementById(id); if (node) node.textContent = value; };

  set('v-devs', input.devs);
  set('v-rate', input.rate);
  set('v-linux', input.linux.toLocaleString('en-US'));
  set('v-macos', input.macos.toLocaleString('en-US'));
  set('v-ghup', input.githubUptime.toFixed(1));
  set('v-selfup', input.selfUptime.toFixed(1));
  set('v-block', Math.round(input.blocked * 100));
  set('v-kwh', input.kwh.toFixed(2));
  set('v-admin', input.admin);

  const hint = document.getElementById('minutes-hint');
  if (hint) {
    hint.innerHTML =
      `<span>${input.plan.included.toLocaleString('en-US')} free with ${input.plan.name}. ` +
      `macOS used 10\u00d7 faster.</span>` +
      `<span>Yours count as ${Math.round(result.allowanceMinutes).toLocaleString('en-US')}. ` +
      `Billed for ${Math.round(result.chargeable).toLocaleString('en-US')}` +
      `${input.linuxTier.standard && input.macTier.standard ? '' : ', plus every larger-runner minute'}.</span>`;
  }

  // A side-by-side beats three separate figures you have to compare yourself.
  const rows = [
    ['Seats', result.seats, 0],
    ['CI minutes', result.actions, 0],
    ['Lost to outages', result.githubDowntime, result.selfDowntime],
    ['Hardware', 0, result.hardwareMonthly],
    ['Power', 0, result.power],
    ['Your admin time', 0, result.admin],
  ];
  const body = document.getElementById('cost-rows');
  if (body) {
    body.innerHTML = rows
      .filter(([, a, b]) => a > 0.5 || b > 0.5)
      .map(([label, a, b]) =>
        `<tr><td>${label}</td><td class="num">${money(a)}</td><td class="num">${money(b)}</td></tr>`)
      .join('') +
      `<tr class="cs-compare-total"><td>Total</td>` +
      `<td class="num">${money(result.githubMonthly)}</td>` +
      `<td class="num">${money(result.selfAllIn)}</td></tr>`;
  }

  // The summary card at the top of the rail.
  set('s-capex', money(input.capex));
  if (!input.hasMachines) {
    set('s-payoff', 'n/a');
  } else if (result.breakeven === null) {
    set('s-payoff', 'Never');
  } else if (result.breakeven < 1) {
    set('s-payoff', Math.max(1, Math.round(result.breakeven * 30)) + ' days');
  } else if (result.breakeven < 24) {
    set('s-payoff', result.breakeven.toFixed(1) + ' months');
  } else {
    set('s-payoff', Math.round(result.breakeven) + ' months');
  }
  const payoff = document.getElementById('s-payoff');
  if (payoff) {
    payoff.className = input.hasMachines && (result.breakeven === null || result.breakeven > 36) ? 'cs-bad' : '';
  }

  const speed = document.getElementById('speed-hint');
  if (speed) {
    const best = (kind) => Math.max(0, ...Object.values(MACHINES)
      .filter((m) => m.qty && m.kind === kind).map((m) => m.cores));
    const linuxCores = best('linux');
    const macCores = best('macos');
    const gain = (own, hosted) => Math.min(4, own / hosted);
    const bits = [];
    if (linuxCores) {
      bits.push(`${input.linuxTier.label} Linux job runs ` +
        `<b>${gain(linuxCores, input.linuxTier.cores).toFixed(1)}\u00d7</b> faster on ${linuxCores} cores`);
    }
    if (macCores) {
      bits.push(`${input.macTier.label} macOS job runs ` +
        `<b>${gain(macCores, input.macTier.cores).toFixed(1)}\u00d7</b> faster on ${macCores}`);
    }
    speed.innerHTML = bits.map((b) => `<span>A ${b}.</span>`).join('');
  }

  fillPrompts(input);

  const verdict = document.getElementById('verdict');
  if (!input.hasMachines) {
    verdict.innerHTML =
      `<span>Add a machine to price this up.</span>` +
      `<span>GitHub costs you <strong>${money(result.githubMonthly)} a month</strong> today.</span>`;
  } else if (result.breakeven === null) {
    verdict.innerHTML =
      `<span>GitHub wins here.</span>` +
      `<span>Self-hosting costs <strong>${money(-result.delta)} a month more</strong>.</span>`;
  } else if (result.breakeven > 36) {
    verdict.innerHTML =
      `<span>Break-even at <strong>${Math.round(result.breakeven)} months</strong>.</span>` +
      `<span>Past the life of the hardware.</span>`;
  } else {
    const when = result.breakeven < 1
      ? '<1 month'
      : result.breakeven.toFixed(1) + ' months';
    verdict.innerHTML =
      `<span>Pays for itself in <strong>${when}</strong>.</span>` +
      `<span>Then saves <strong>${money(result.delta)} a month</strong>.</span>`;
  }

  drawBreakeven(input, result);
}

// ------------------------------------------------------------------- startup

/** Every rig card on the page, keyed by slug, with how many you want of each. */
const MACHINES = {};

function readMachineCards() {
  document.querySelectorAll('.cs-qty').forEach((node) => {
    MACHINES[node.dataset.rig] = {
      name: node.dataset.name,
      capex: Number(node.dataset.capex),
      watts: Number(node.dataset.watts),
      financeable: node.dataset.finance === 'true',
      cores: Number(node.dataset.cores) || 0,
      ram: Number(node.dataset.ram) || 0,
      kind: node.dataset.kind || '',
      capacity: Number(node.dataset.capacity) || 0,
      qty: 0,
      node,
    };
  });
}

function machineTotals() {
  let capex = 0;
  let watts = 0;
  let financeable = 0;
  const parts = [];
  for (const slug in MACHINES) {
    const machine = MACHINES[slug];
    if (!machine.qty) continue;
    capex += machine.capex * machine.qty;
    watts += machine.watts * machine.qty;
    if (machine.financeable) financeable += machine.capex * machine.qty;
    parts.push((machine.qty > 1 ? machine.qty + ' × ' : '') + machine.name);
  }
  return { capex, watts, financeable, label: parts.join(' + ') || 'nothing yet' };
}

function setQuantity(slug, qty) {
  const machine = MACHINES[slug];
  if (!machine) return;
  machine.qty = Math.max(0, Math.min(9, qty));
  machine.node.querySelector('[data-qty]').textContent = machine.qty;
  machine.node.setAttribute('data-chosen', machine.qty > 0 ? 'true' : 'false');
}

/** Same markup CodeBlock emits, so JS-built blocks get copy buttons too. */
function renderCode(target, lines) {
  const node = document.getElementById(target);
  if (!node) return;
  const esc = (t) => t.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  const attr = (t) => esc(t).replace(/"/g, '&quot;');
  node.innerHTML = lines.length ? '<pre class="cs-code">' + lines.map((line) => {
    if (!line.trim()) return '<span class="cs-gap"></span>';
    if (line.trim().startsWith('#')) {
      return `<span class="cs-line cs-line-comment"><span class="cs-line-text c">${esc(line)}</span></span>`;
    }
    return `<span class="cs-line"><span class="cs-line-text">${esc(line)}</span>` +
      `<button type="button" class="cs-copy" data-copy="${attr(line)}" ` +
      `aria-label="Copy this line">Copy</button></span>`;
  }).join('') + '</pre>' : '';
}

/** gitlab.rb values follow whichever Linux machine is selected. */
function renderTuning() {
  const host = Object.values(MACHINES)
    .filter((m) => m.qty && m.kind === 'linux')
    .sort((a, b) => b.cores - a.cores)[0];
  const label = document.getElementById('tuning-for');
  const note = document.getElementById('tuning-note');
  if (!host) {
    if (label) label.textContent = 'Pick a machine in step 1 and these values follow its cores and memory.';
    renderCode('tuning-code', []);
    if (note) note.textContent = "Omnibus bundles Prometheus for GitLab's built-in performance dashboards. Whether to keep it depends on the memory you have.";
    return;
  }

  const workers = Math.max(2, Math.min(8, Math.round(host.cores / 2)));
  const sidekiq = Math.max(5, Math.min(20, host.cores));
  const buffers = Math.max(1, Math.round(host.ram / 4));
  const keepPrometheus = host.ram >= 32;

  if (label) label.innerHTML = `Sized for the <b>${host.name}</b>: ${host.cores} cores, ${host.ram} GB.`;
  renderCode('tuning-code', [
    '# /etc/gitlab/gitlab.rb',
    `puma['worker_processes'] = ${workers}`,
    `sidekiq['max_concurrency'] = ${sidekiq}`,
    `postgresql['shared_buffers'] = "${buffers}GB"`,
    `prometheus_monitoring['enable'] = ${keepPrometheus}`,
  ]);
  if (note) {
    note.innerHTML = keepPrometheus
      ? `Omnibus bundles Prometheus to collect metrics for GitLab's own performance ` +
        `dashboards. At ${host.ram} GB there is room to leave it running.`
      : `Omnibus bundles Prometheus to collect metrics for GitLab's own performance ` +
        `dashboards. It costs about a gigabyte of RAM, which is worth reclaiming ` +
        `under 32 GB. You lose the dashboards, not any GitLab feature.`;
  }
}

/** Only show the runner instructions for machines actually selected. */
function renderRunnerTiles() {
  const has = (kind) => Object.values(MACHINES).some((m) => m.qty && m.kind === kind);
  const toggle = (name, on) => {
    const tile = document.querySelector('.' + name);
    if (tile) tile.classList.toggle('is-dimmed', !on);
  };
  toggle('tile-linux-runner', has('linux'));
  toggle('tile-macos-runner', has('macos'));
  toggle('tile-runner-config', has('linux') || has('macos'));
}

function renderMachines() {
  const totals = machineTotals();
  // Flag the smallest UPS that can actually carry what is selected.
  const load = totals.watts;
  const ups = Object.values(MACHINES)
    .filter((m) => m.capacity && m.capacity < 1500)
    .sort((a, b) => a.capacity - b.capacity);
  const fit = ups.find((m) => m.capacity >= Math.max(load, 1));
  ups.forEach((m) => {
    if (m === fit && load > 0) m.node.setAttribute('data-fits', 'true');
    else m.node.removeAttribute('data-fits');
  });
  const capex = document.getElementById('r-capex');
  const watts = document.getElementById('r-watts');
  const note = document.getElementById('rig-note');
  if (capex) capex.textContent = money(totals.capex);
  if (watts) watts.textContent = totals.watts + ' W';
  if (note) note.textContent = totals.label;
  renderTuning();
  renderRunnerTiles();
}

let activePreset = null;

function applyProfile(key) {
  const profile = PROFILES[key];
  if (!profile) return;
  activePreset = key;
  for (const field in profile.values) {
    if (field === 'plan') {
      const radio = document.getElementById('f-plan-' + profile.values.plan);
      if (radio) radio.checked = true;
      continue;
    }
    const node = document.getElementById('f-' + field);
    if (!node) continue;
    node.value = (field === 'linux' || field === 'macos')
      ? minutesToTick(profile.values[field])
      : profile.values[field];
  }
  for (const slug in MACHINES) setQuantity(slug, (profile.machines || {})[slug] || 0);
  const finance = document.getElementById('f-finance');
  if (finance) finance.checked = Boolean(profile.finance);
  renderMachines();
  document.querySelectorAll('.cs-preset').forEach((button) => {
    button.setAttribute('aria-pressed', String(button.dataset.preset === key));
  });
  const note = document.getElementById('preset-note');
  if (note) note.textContent = profile.note;
  refresh();
}

/** Hovering an outage row marks that day on the uptime chart. */
function wireOutageRows() {
  const rows = document.querySelectorAll('tr[data-day]');
  if (!rows.length) return;
  const origin = Date.UTC(ROLLING_START[0], ROLLING_START[1] - 1, ROLLING_START[2]);

  rows.forEach((row) => {
    const [y, m, d] = row.dataset.day.split('-').map(Number);
    const index = Math.round((Date.UTC(y, m - 1, d) - origin) / 86400000);
    if (index < 0 || index >= ROLLING.length) return;
    row.classList.add('is-linked');
    row.addEventListener('pointerenter', () => markUptimeDay(index, row.dataset.day));
    row.addEventListener('pointerleave', () => markUptimeDay(-1));
    row.addEventListener('focusin', () => markUptimeDay(index, row.dataset.day));
    row.addEventListener('focusout', () => markUptimeDay(-1));
  });
}

/** Lights the jump-nav chip for whichever section is currently in view. */
function trackSections() {
  const links = Array.from(document.querySelectorAll('.cs-jump a'));
  const sections = links
    .map((link) => ({ link, node: document.querySelector(link.getAttribute('href')) }))
    .filter((entry) => entry.node);
  if (!sections.length) return;

  let current = null;
  const mark = (entry) => {
    if (entry === current) return;
    current = entry;
    links.forEach((link) => link.removeAttribute('aria-current'));
    if (entry) entry.link.setAttribute('aria-current', 'true');
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      const match = sections.find((s) => s.node === entry.target);
      if (match) mark(match);
    });
  }, { rootMargin: '-78px 0px -55% 0px', threshold: 0 });

  sections.forEach((entry) => observer.observe(entry.node));
}

/** Copy buttons on every command in the page's shell transcripts. */
function wireCopyButtons() {
  document.addEventListener('click', (event) => {
    const button = event.target.closest('.cs-copy');
    if (!button) return;
    const done = () => {
      button.classList.add('is-copied');
      button.textContent = 'Copied';
      setTimeout(() => {
        button.classList.remove('is-copied');
        button.textContent = 'Copy';
      }, 1200);
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(button.dataset.copy).then(done, () => {});
      return;
    }
    // Plain http has no async clipboard in some browsers.
    const scratch = document.createElement('textarea');
    scratch.value = button.dataset.copy;
    scratch.style.position = 'fixed';
    scratch.style.opacity = '0';
    document.body.appendChild(scratch);
    scratch.select();
    try { document.execCommand('copy'); done(); } catch (e) { /* nothing to do */ }
    document.body.removeChild(scratch);
  });
}

/** Lets the rail scroll internally only once it is anchored under the top bar.
 *  Before that the page owns the wheel, so the panel scrolls into view first. */
function trackRailPin() {
  const rail = document.querySelector('.cs-rail');
  if (!rail) return;
  const TOP = 38;
  let queued = false;

  const measure = () => {
    queued = false;
    const pinned = rail.classList.contains('is-pinned');
    // While pinned the rail sits exactly at TOP, so ask the placeholder space
    // above it whether the page has scrolled back past the anchor point.
    const top = rail.getBoundingClientRect().top;
    if (!pinned && top <= TOP + 0.5) {
      rail.classList.add('is-pinned');
    } else if (pinned && rail.scrollTop === 0 && top > TOP + 0.5) {
      rail.classList.remove('is-pinned');
    }
  };

  const onScroll = () => {
    if (queued) return;
    queued = true;
    requestAnimationFrame(measure);
  };

  window.addEventListener('scroll', onScroll, { passive: true });
  window.addEventListener('resize', onScroll);
  measure();
  return measure;
}

// Safari in private browsing throws on localStorage, so never touch it raw.
const store = {
  get(key) { try { return localStorage.getItem(key); } catch (e) { return null; } },
  set(key, value) { try { localStorage.setItem(key, value); } catch (e) { /* fine */ } },
};

// Every command and prompt is written against this hostname, so swapping it
// is a straight text substitution over the rendered blocks.
const HOST_PLACEHOLDER = 'gitlab.example.com';
const originalMarkup = new WeakMap();

function template(node, read) {
  if (!originalMarkup.has(node)) originalMarkup.set(node, read());
  return originalMarkup.get(node);
}

function currentHost() {
  const field = document.getElementById('f-host');
  return (field && field.value.trim()) || HOST_PLACEHOLDER;
}

/** A prompt input, falling back to the placeholder the prompt would show. */
function fieldValue(id, fallback) {
  const node = document.getElementById(id);
  const value = node && node.value.trim();
  return value || fallback;
}

/** Whatever GitHub URLs were pasted into the migrate prompt. */
function pastedRepos() {
  const field = document.getElementById('f-repos');
  const raw = (field && field.value) || '';
  const parsed = raw.split(/\s+/).map((t) => t.trim()).filter(Boolean).map((line) => {
    const match = line.match(/github\.com[/:]([^/\s]+)\/([^/\s]+?)(?:\.git)?$/i);
    return match ? { owner: match[1], repo: match[2] } : { owner: null, repo: line };
  });
  const owners = [...new Set(parsed.map((r) => r.owner).filter(Boolean))];
  return {
    source: owners.length ? owners.join(' and ') : '<org or user>',
    repos: parsed.length
      ? parsed.map((r) => (r.owner ? r.owner + '/' + r.repo : r.repo)).join(', ')
      : '<list, or "everything">',
  };
}

/** Values from the calculator, dropped into the agent prompts. */
function promptVars(input) {
  const totals = input.totals;
  const linuxHost = Object.values(MACHINES)
    .filter((m) => m.qty && m.kind === 'linux').sort((a, b) => b.cores - a.cores)[0];
  const hasMac = Object.values(MACHINES).some((m) => m.qty && m.kind === 'macos');
  const hosts = [];
  const ip = fieldValue('f-runnerip', '<ip>');
  if (linuxHost) hosts.push(`${linuxHost.name} at ${ip}`);
  if (hasMac) hosts.push(`Mac mini at ${ip}`);
  const repos = pastedRepos();
  return {
    ssh: fieldValue('f-ssh', '<user>@<ip>'),
    tls: fieldValue('f-tls', "<Let's Encrypt | my own certificate>"),
    bucket: fieldValue('f-bucket', '<S3-compatible bucket>'),
    vault: fieldValue('f-vault', '<password manager or vault>'),
    workflows: fieldValue('f-workflows', '<paths to .github/workflows/*.yml>'),
    source: repos.source,
    repos: repos.repos,
    devs: String(input.devs),
    plan: input.plan.name,
    platforms: hasMac || input.macos > 0 ? 'Linux and Apple platforms' : 'Linux only',
    linux: input.linux.toLocaleString('en-US'),
    macos: input.macos.toLocaleString('en-US'),
    budget: totals.capex ? money(totals.capex) : '<$Z>',
    machines: totals.capex ? totals.label : 'nothing chosen yet',
    cores: linuxHost ? String(linuxHost.cores) : '<N>',
    ram: linuxHost ? String(linuxHost.ram) : '<M>',
    runnerhosts: hosts.length ? hosts.join(' and ') : '<Linux machine at <ip>, Mac mini at <ip>, or both>',
  };
}

// Where each substituted value came from, shown on hover.
const PROMPT_SOURCES = {
  devs: 'Developers slider',
  plan: 'GitHub plan control',
  platforms: 'Derived from the machines you picked and your macOS minutes',
  linux: 'Linux minutes slider',
  macos: 'macOS minutes slider',
  budget: 'Total cost of the machines you picked',
  machines: 'Machines you picked',
  cores: 'Cores of the Linux machine you picked',
  ram: 'Memory of the Linux machine you picked',
  runnerhosts: 'Machines you picked',
  host: 'Your domain field. Click to change it',
  source: 'Parsed from the URLs you pasted',
  repos: 'Parsed from the URLs you pasted',
  ssh: 'The login field, above',
  tls: 'TLS field, above',
  bucket: 'Backup bucket field, above',
  vault: 'The secrets field, above',
  workflows: 'Workflows field, above',
};

function fillPrompts(input) {
  const host = currentHost();
  const vars = promptVars(input);
  const esc = (t) => String(t).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  const attr = (t) => esc(t).replace(/"/g, '&quot;');
  const mark = (value, source, extra) =>
    `<mark class="cs-fill${extra ? ' ' + extra : ''}" data-src="${attr(source)}" ` +
    `tabindex="0">${esc(value)}</mark>`;

  // The visible prompt highlights every filled value; the copy button carries
  // the same text with no markup in it.
  const fill = (text, decorate) => {
    let out = text.split(HOST_PLACEHOLDER)
      .join(decorate ? mark(host, PROMPT_SOURCES.host, 'cs-fill-host') : host);
    for (const key in vars) {
      const value = decorate ? mark(vars[key], PROMPT_SOURCES[key] || 'From the calculator') : vars[key];
      out = out.split('{{' + key + '}}').join(value);
    }
    return out;
  };

  document.querySelectorAll('.cs-prompt-body').forEach((pre) => {
    pre.innerHTML = fill(template(pre, () => pre.innerHTML), true);
  });
  document.querySelectorAll('.cs-copy-block').forEach((button) => {
    button.dataset.copy = fill(template(button, () => button.dataset.copy), false);
  });
}

function applyHost(host) {
  const target = host.trim() || HOST_PLACEHOLDER;
  document.querySelectorAll('pre.cs-code').forEach((pre) => {
    if (pre.classList.contains('cs-prompt-body')) return;
    const source = template(pre, () => pre.innerHTML);
    if (!source.includes(HOST_PLACEHOLDER)) return;
    pre.innerHTML = source.split(HOST_PLACEHOLDER).join(target);
  });
}

/** Every prompt input: remembered between visits, and re-fills on change. */
function wirePromptFields() {
  ['f-repos', 'f-ssh', 'f-tls', 'f-bucket', 'f-vault', 'f-runnerip', 'f-workflows']
    .forEach((id) => {
      const field = document.getElementById(id);
      if (!field) return;
      const saved = store.get('cs-' + id);
      if (saved) field.value = saved;
      const handler = () => {
        store.set('cs-' + id, field.value);
        queueRefresh();
      };
      field.addEventListener('input', handler);
      field.addEventListener('change', handler);
    });
}

function wireHostField() {
  const field = document.getElementById('f-host');
  if (!field) return;

  // Clicking the hostname anywhere in a prompt takes you to the field.
  document.addEventListener('click', (event) => {
    if (!event.target.closest('.cs-fill-host')) return;
    field.focus();
    field.select();
    field.classList.add('is-flashing');
    setTimeout(() => field.classList.remove('is-flashing'), 900);
  });
  const saved = store.get('cs-host');
  if (saved) field.value = saved;
  const update = () => {
    applyHost(field.value);
    store.set('cs-host', field.value);
    queueRefresh();
  };
  field.addEventListener('input', update);
  update();
}

/** Swaps the manual tiles for a copyable prompt per section. */
function wireModeToggle() {
  const buttons = Array.from(document.querySelectorAll('.cs-mode-btn'));
  if (!buttons.length) return;
  const set = (mode) => {
    document.body.classList.toggle('mode-agent', mode === 'agent');
    buttons.forEach((b) => b.setAttribute('aria-pressed', String(b.dataset.mode === mode)));
    store.set('cs-mode', mode);
  };
  buttons.forEach((b) => b.addEventListener('click', () => set(b.dataset.mode)));
  set(store.get('cs-mode') === 'agent' ? 'agent' : 'human');
}

/** Checklists remember what you have ticked, per browser. */
function wireChecklists() {
  document.querySelectorAll('.cs-checklist').forEach((list) => {
    const name = list.dataset.checklist;
    const boxes = Array.from(list.querySelectorAll('input[type="checkbox"]'));
    const status = document.getElementById(name + '-status');

    const paint = () => {
      const done = boxes.filter((b) => b.checked).length;
      boxes.forEach((b) => b.closest('li').classList.toggle('is-done', b.checked));
      if (!status) return;
      status.textContent = done === boxes.length
        ? 'All ' + boxes.length + ' done'
        : done + ' of ' + boxes.length + ' done';
    };

    boxes.forEach((box) => {
      box.checked = store.get('cs-check-' + box.dataset.key) === '1';
      box.addEventListener('change', () => {
        store.set('cs-check-' + box.dataset.key, box.checked ? '1' : '0');
        paint();
      });
    });
    paint();
  });

  document.querySelectorAll('.cs-checklist-reset').forEach((button) => {
    button.addEventListener('click', () => {
      const list = document.querySelector(`.cs-checklist[data-checklist="${button.dataset.reset}"]`);
      if (!list) return;
      list.querySelectorAll('input[type="checkbox"]').forEach((box) => {
        box.checked = false;
        store.set('cs-check-' + box.dataset.key, '0');
        box.dispatchEvent(new Event('change'));
      });
    });
  });
}

let refreshQueued = false;

function queueRefresh() {
  if (refreshQueued) return;
  refreshQueued = true;
  requestAnimationFrame(() => {
    refreshQueued = false;
    refresh();
  });
}

function start() {
  wireCopyButtons();
  wireChecklists();
  wireOutageRows();
  wireModeToggle();
  readMachineCards();
  trackSections();
  drawUptime();
  document.querySelectorAll('.cs-fields input').forEach((node) => {
    node.addEventListener('input', () => {
      if (node.type === 'radio') { queueRefresh(); return; }
      if (activePreset) {
        activePreset = null;
        document.querySelectorAll('.cs-preset').forEach((b) => b.setAttribute('aria-pressed', 'false'));
        const note = document.getElementById('preset-note');
        if (note) note.textContent = 'Custom';
      }
      queueRefresh();
    });
  });
  const repin = trackRailPin();
  document.querySelectorAll('.cs-preset').forEach((button) => {
    button.addEventListener('click', () => {
      applyProfile(button.dataset.preset);
      if (repin) repin();
    });
  });

  // The steppers on the rig cards are what set hardware cost and power draw.
  const finance = document.getElementById('f-finance');
  if (finance) finance.addEventListener('change', refresh);

  document.querySelectorAll('.cs-fields select').forEach((node) => {
    node.addEventListener('change', refresh);
  });

  document.querySelectorAll('.cs-qty button').forEach((button) => {
    button.addEventListener('click', () => {
      const card = button.closest('.cs-qty');
      setQuantity(card.dataset.rig, MACHINES[card.dataset.rig].qty + Number(button.dataset.step));
      renderMachines();
      refresh();
    });
  });
  applyProfile('startup');
  wireHostField();
  wirePromptFields();

  let timer;
  window.addEventListener('resize', () => {
    clearTimeout(timer);
    timer = setTimeout(() => { drawUptime(); refresh(); }, 120);
  });

  if (window.matchMedia) {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      inkCache = null;
      drawUptime();
      refresh();
    });
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', start);
} else {
  start();
}
