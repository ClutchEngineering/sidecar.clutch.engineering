// Wait for DOM to be ready before initializing search
document.addEventListener('DOMContentLoaded', function() {
  console.log('[Vehicle Search] DOM loaded, initializing search...');

  let searchIndex = null;
  let makesArray = null;
  let selectedIndex = -1;
  let filteredResults = [];

  const searchInput = document.getElementById('vehicle-search-input');
  const resultsContainer = document.getElementById('vehicle-search-results');

  console.log('[Vehicle Search] DOM elements:', {
    searchInput: searchInput ? 'Found' : 'Not found',
    resultsContainer: resultsContainer ? 'Found' : 'Not found'
  });

  if (!searchInput || !resultsContainer) {
    console.warn('[Vehicle Search] Required DOM elements not found, exiting');
    return; // Search components not present on this page
  }

  // Load the search index
  console.log('[Vehicle Search] Fetching search index from /vehicle-search-index.json');
  fetch('/vehicle-search-index.json')
    .then(response => {
      console.log('[Vehicle Search] Fetch response:', response.status, response.statusText);
      return response.json();
    })
    .then(data => {
      makesArray = data.m;
      searchIndex = data.v;
      console.log('[Vehicle Search] Index loaded successfully:', makesArray.length, 'makes,', searchIndex.length, 'entries');
      console.log('[Vehicle Search] First 3 entries:', searchIndex.slice(0, 3));
    })
    .catch(error => {
      console.error('[Vehicle Search] Failed to load search index:', error);
    });

  // Search and filter vehicles
  function searchVehicles(query) {
    console.log('[Vehicle Search] searchVehicles called with query:', query);
    console.log('[Vehicle Search] Search index loaded?', searchIndex !== null);

    if (!searchIndex || !query.trim()) {
      console.log('[Vehicle Search] Hiding results - no index or empty query');
      hideResults();
      return;
    }

    const lowerQuery = query.toLowerCase();
    console.log('[Vehicle Search] Searching for:', lowerQuery);

    // Filter vehicles - search in make and model
    filteredResults = searchIndex.filter(vehicle => {
      const make = makesArray[vehicle.m];
      const makeMatch = make.n.toLowerCase().includes(lowerQuery);
      const modelMatch = vehicle.n.toLowerCase().includes(lowerQuery);
      const combinedMatch = `${make.n} ${vehicle.n}`.toLowerCase().includes(lowerQuery);
      return makeMatch || modelMatch || combinedMatch;
    });

    console.log('[Vehicle Search] Found', filteredResults.length, 'results before limiting');

    // Limit to top 10 results
    filteredResults = filteredResults.slice(0, 10);

    console.log('[Vehicle Search] Showing', filteredResults.length, 'results');
    selectedIndex = filteredResults.length > 0 ? 0 : -1;
    displayResults();
  }

  // Display search results
  function displayResults() {
    console.log('[Vehicle Search] displayResults called with', filteredResults.length, 'results');

    if (filteredResults.length === 0) {
      console.log('[Vehicle Search] No results, showing "No vehicles found" message');
      resultsContainer.innerHTML = '<div class="px-4 py-3 text-zinc-500 dark:text-zinc-400">No vehicles found</div>';
      resultsContainer.classList.remove('hidden');
      return;
    }

    console.log('[Vehicle Search] Rendering results dropdown');
    resultsContainer.innerHTML = filteredResults.map((vehicle, index) => {
      const isSelected = index === selectedIndex;
      const make = makesArray[vehicle.m];
      const isMakeOnly = !vehicle.n;
      const isPlaceholder = !vehicle.i;

      // Reconstruct full paths from compact format
      const iconPath = vehicle.t === 'm' ? `/gfx/make/${make.i}` :
                       vehicle.t === 'v' ? `/gfx/vehicle/${vehicle.i}` :
                       `/gfx/placeholder-car.png`;
      const url = vehicle.s
        ? `/supported-cars/${make.s}/${vehicle.s}/`
        : `/supported-cars/${make.s}/`;

      return `
        <a
          href="${url}"
          class="vehicle-search-result cursor-pointer flex items-center gap-3 px-4 py-3 transition-colors ${
            isSelected
              ? 'bg-blue-500 text-white'
              : 'hover:bg-zinc-100 dark:hover:bg-zinc-700 text-zinc-900 dark:text-zinc-100'
          }"
          data-index="${index}"
        >
          <img
            src="${iconPath}"
            alt="${make.n} ${vehicle.n}"
            class="w-8 ${isPlaceholder ? 'p-2' : ''} ${isSelected ? 'invert brightness-0' : 'dark:invert'}"
          />
          <div class="flex-1 min-w-0">
            <div class="font-bold text-base truncate">
              ${make.n}${vehicle.n ? ` ${vehicle.n}` : ''}
            </div>
            ${isMakeOnly ? '<div class="text-sm opacity-80">View all models</div>' : ''}
          </div>
        </a>
      `;
    }).join('');

    resultsContainer.classList.remove('hidden');

    // Add click and hover handlers to results
    const resultElements = resultsContainer.querySelectorAll('.vehicle-search-result');
    resultElements.forEach((element, index) => {
      element.addEventListener('click', (e) => {
        e.preventDefault();
        navigateToSelected(index);
      });

      // Update selection on hover (only if it actually changed to prevent re-render loops)
      element.addEventListener('mouseenter', () => {
        if (selectedIndex !== index) {
          selectedIndex = index;
          displayResults();
        }
      });
    });

    // Scroll selected item into view
    if (selectedIndex >= 0 && resultElements[selectedIndex]) {
      resultElements[selectedIndex].scrollIntoView({
        block: 'nearest',
        behavior: 'smooth'
      });
    }
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
      const vehicle = filteredResults[index];
      const make = makesArray[vehicle.m];
      const url = vehicle.s
        ? `/supported-cars/${make.s}/${vehicle.s}/`
        : `/supported-cars/${make.s}/`;
      window.location.href = url;
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
  console.log('[Vehicle Search] Setting up event listeners');

  searchInput.addEventListener('input', (e) => {
    console.log('[Vehicle Search] Input event fired, value:', e.target.value);
    searchVehicles(e.target.value);
  });

  searchInput.addEventListener('keydown', handleKeyDown);

  console.log('[Vehicle Search] Event listeners attached successfully');

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

  console.log('[Vehicle Search] Initialization complete');
});
