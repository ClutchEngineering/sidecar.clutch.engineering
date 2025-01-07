// Configuration
const MILES_PER_DAY = 3000; // Miles per day growth rate
const MAX_ANIMATION_INTERVAL_MS = 100; // Maximum update interval

// Calculate how many milliseconds it takes to accumulate 1 mile
const MS_PER_MILE = (24 * 60 * 60 * 1000) / MILES_PER_DAY;
// Use the larger of: time for 1 mile or max interval
const ANIMATION_INTERVAL_MS = Math.max(MAX_ANIMATION_INTERVAL_MS, Math.ceil(MS_PER_MILE));

class MilesCounter {
  constructor(elementId, baseValue, snapshotDate) {
    this.element = document.getElementById(elementId);
    if (!this.element) {
      console.error(`Element with id ${elementId} not found`);
      return;
    }

    this.baseValue = baseValue;
    this.snapshotDate = new Date(snapshotDate);
    this.formatter = new Intl.NumberFormat('en-US', {
      maximumFractionDigits: 0
    });

    this.startAnimation();
  }

  getCurrentValue() {
    const now = new Date();
    const timeDiffMs = now - this.snapshotDate;
    const daysPassed = timeDiffMs / (1000 * 60 * 60 * 24);
    const additionalMiles = daysPassed * MILES_PER_DAY;
    return this.baseValue + additionalMiles;
  }

  formatNumber(value) {
    return this.formatter.format(Math.floor(value));
  }

  updateDisplay() {
    const currentValue = this.getCurrentValue();
    this.element.textContent = this.formatNumber(currentValue);
  }

  startAnimation() {
    // Update immediately
    this.updateDisplay();

    // Then update periodically
    setInterval(() => {
      this.updateDisplay();
    }, ANIMATION_INTERVAL_MS);
  }
}

// Initialize when the DOM is loaded
var milesCounter = null;
document.addEventListener('DOMContentLoaded', () => {
  const totalMilesElement = document.getElementById('total-miles-counter');
  if (totalMilesElement && totalMilesElement.dataset.baseValue && totalMilesElement.dataset.snapshotDate) {
    milesCounter = new MilesCounter(
      'total-miles-counter',
       parseFloat(totalMilesElement.dataset.baseValue),
       totalMilesElement.dataset.snapshotDate
    );
  }
});

