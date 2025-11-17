(function() {
  'use strict';

  let searchIndex = null;
  let selectedIndex = -1;
  let filteredResults = [];

  const searchInput = document.getElementById('vehicle-search-input');
  const resultsContainer = document.getElementById('vehicle-search-results');

  if (!searchInput || !resultsContainer) {
    return; // Search components not present on this page
  }

  // Load the search index
  fetch('/vehicle-search-index.json')
    .then(response => response.json())
    .then(data => {
      searchIndex = data.vehicles;
      console.log('Vehicle search index loaded:', searchIndex.length, 'entries');
    })
    .catch(error => {
      console.error('Failed to load vehicle search index:', error);
    });

  // Debounce function to limit search frequency
  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  // Search and filter vehicles
  function searchVehicles(query) {
    if (!searchIndex || !query.trim()) {
      hideResults();
      return;
    }

    const lowerQuery = query.toLowerCase();

    // Filter vehicles - search in make and model
    filteredResults = searchIndex.filter(vehicle => {
      const makeMatch = vehicle.make.toLowerCase().includes(lowerQuery);
      const modelMatch = vehicle.model.toLowerCase().includes(lowerQuery);
      const combinedMatch = `${vehicle.make} ${vehicle.model}`.toLowerCase().includes(lowerQuery);
      return makeMatch || modelMatch || combinedMatch;
    });

    // Limit to top 10 results
    filteredResults = filteredResults.slice(0, 10);

    selectedIndex = filteredResults.length > 0 ? 0 : -1;
    displayResults();
  }

  // Display search results
  function displayResults() {
    if (filteredResults.length === 0) {
      resultsContainer.innerHTML = '<div class="px-4 py-3 text-zinc-500 dark:text-zinc-400">No vehicles found</div>';
      resultsContainer.classList.remove('hidden');
      return;
    }

    resultsContainer.innerHTML = filteredResults.map((vehicle, index) => {
      const isSelected = index === selectedIndex;
      const isMakeOnly = !vehicle.model;

      return `
        <a
          href="${vehicle.url}"
          class="vehicle-search-result flex items-center gap-3 px-4 py-3 transition-colors ${
            isSelected
              ? 'bg-blue-500 text-white'
              : 'hover:bg-zinc-100 dark:hover:bg-zinc-700 text-zinc-900 dark:text-zinc-100'
          }"
          data-index="${index}"
        >
          <img
            src="${vehicle.iconPath}"
            alt="${vehicle.make} ${vehicle.model}"
            class="w-8 h-8 ${isSelected ? '' : 'dark:invert'}"
          />
          <div class="flex-1 min-w-0">
            <div class="font-bold text-base truncate">
              ${vehicle.make}${vehicle.model ? ` ${vehicle.model}` : ''}
            </div>
            ${isMakeOnly ? '<div class="text-sm opacity-80">View all models</div>' : ''}
          </div>
        </a>
      `;
    }).join('');

    resultsContainer.classList.remove('hidden');

    // Add click handlers to results
    const resultElements = resultsContainer.querySelectorAll('.vehicle-search-result');
    resultElements.forEach((element, index) => {
      element.addEventListener('click', (e) => {
        e.preventDefault();
        navigateToSelected(index);
      });
    });
  }

  // Hide results
  function hideResults() {
    resultsContainer.classList.add('hidden');
    resultsContainer.innerHTML = '';
    filteredResults = [];
    selectedIndex = -1;
  }

  // Navigate to selected result
  function navigateToSelected(index = selectedIndex) {
    if (index >= 0 && index < filteredResults.length) {
      window.location.href = filteredResults[index].url;
    }
  }

  // Handle keyboard navigation
  function handleKeyDown(e) {
    if (!resultsContainer.classList.contains('hidden') && filteredResults.length > 0) {
      switch(e.key) {
        case 'ArrowDown':
          e.preventDefault();
          selectedIndex = (selectedIndex + 1) % filteredResults.length;
          displayResults();
          break;
        case 'ArrowUp':
          e.preventDefault();
          selectedIndex = selectedIndex <= 0 ? filteredResults.length - 1 : selectedIndex - 1;
          displayResults();
          break;
        case 'Enter':
          e.preventDefault();
          navigateToSelected();
          break;
        case 'Escape':
          e.preventDefault();
          hideResults();
          searchInput.blur();
          break;
      }
    }
  }

  // Event listeners
  searchInput.addEventListener('input', debounce((e) => {
    searchVehicles(e.target.value);
  }, 200));

  searchInput.addEventListener('keydown', handleKeyDown);

  // Close results when clicking outside
  document.addEventListener('click', (e) => {
    if (!searchInput.contains(e.target) && !resultsContainer.contains(e.target)) {
      hideResults();
    }
  });

  // Focus input when clicking on results container
  resultsContainer.addEventListener('mousedown', (e) => {
    e.preventDefault(); // Prevent input from losing focus
  });
})();
