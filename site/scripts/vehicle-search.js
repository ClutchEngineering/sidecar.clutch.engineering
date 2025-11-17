// Wait for DOM to be ready before initializing search
document.addEventListener('DOMContentLoaded', function() {
  let searchIndex = null;
  let makesArray = null;
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
      makesArray = data.m;
      searchIndex = data.v;
    })
    .catch(error => {
      console.error('[Vehicle Search] Failed to load search index:', error);
    });

  // Search and filter vehicles
  function searchVehicles(query) {
    if (!searchIndex || !query.trim()) {
      hideResults();
      return;
    }

    // Normalize text for searching (remove spaces, hyphens, and lowercase)
    const normalizeForSearch = (text) => text.toLowerCase().replace(/[\s\-]/g, '');

    const normalizedQuery = normalizeForSearch(query);

    // Filter vehicles - search in make and model
    filteredResults = searchIndex.filter(vehicle => {
      const make = makesArray[vehicle.m];
      const normalizedMake = normalizeForSearch(make.n);
      const normalizedModel = normalizeForSearch(vehicle.n);
      const normalizedCombined = normalizeForSearch(`${make.n} ${vehicle.n}`);

      return normalizedMake.includes(normalizedQuery) ||
             normalizedModel.includes(normalizedQuery) ||
             normalizedCombined.includes(normalizedQuery);
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
      const make = makesArray[vehicle.m];
      const isPlaceholder = !vehicle.i;

      // Reconstruct full paths from compact format
      const iconPath = vehicle.t === 'm' ? `/gfx/make/${make.i}` :
                       vehicle.t === 'v' ? `/gfx/vehicle/${vehicle.i}` :
                       `/gfx/placeholder-car.png`;
      const url = vehicle.s
        ? `/cars/${make.s}/${vehicle.s}/`
        : `/cars/${make.s}/`;

      return `
        <a
          href="${url}"
          class="vehicle-search-result cursor-pointer flex items-center gap-3 px-4 py-3 transition-colors ${
            isSelected
              ? 'bg-zinc-200 dark:bg-zinc-700 text-zinc-900 dark:text-zinc-100'
              : 'hover:bg-zinc-100 dark:hover:bg-zinc-800 text-zinc-900 dark:text-zinc-100'
          }"
          data-index="${index}"
        >
          <img
            src="${iconPath}"
            alt="${make.n} ${vehicle.n}"
            class="w-8 ${isPlaceholder ? 'p-2' : ''} ${isSelected ? '' : 'dark:invert'}"
          />
          <div class="flex-1 min-w-0">
            <div class="font-bold text-base truncate">
              ${make.n}${vehicle.n ? ` ${vehicle.n}` : ''}
            </div>
            <div class="text-sm opacity-70">
              ${(() => {
                const hasDrivers = vehicle.d != null && vehicle.d > 0;
                const hasMiles = vehicle.k != null && vehicle.k > 0;

                // Format miles based on unit
                const formatMiles = (miles, unit) => {
                  if (unit === '1') {
                    return `${miles.toLocaleString()} mile${miles !== 1 ? 's' : ''}`;
                  } else {
                    return `${miles.toLocaleString()}k miles`;
                  }
                };

                if (!hasDrivers && !hasMiles) {
                  return 'No drivers yet';
                } else if (hasDrivers && !hasMiles) {
                  return `${vehicle.d.toLocaleString()} driver${vehicle.d !== 1 ? 's' : ''} · No miles driven yet`;
                } else if (!hasDrivers && hasMiles) {
                  return `No drivers · ${formatMiles(vehicle.k, vehicle.u)}`;
                } else {
                  return `${vehicle.d.toLocaleString()} driver${vehicle.d !== 1 ? 's' : ''} · ${formatMiles(vehicle.k, vehicle.u)}`;
                }
              })()}
            </div>
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
        ? `/cars/${make.s}/${vehicle.s}/`
        : `/cars/${make.s}/`;
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
  searchInput.addEventListener('input', (e) => {
    searchVehicles(e.target.value);
  });

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
});
