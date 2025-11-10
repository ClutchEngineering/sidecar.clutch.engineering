/**
 * Widget Studio - Drag and Drop Editor for Custom Widget Interfaces
 */

// State management
const state = {
  draggingWidget: null,
  widgets: {
    'top-left': [],
    'top-center': [],
    'top-right': [],
    'left-center': [],
    'right-center': [],
    'bottom-left': [],
    'bottom-center': [],
    'bottom-right': []
  },
  map: null
};

// Widget types configuration
const widgetTypes = {
  'tire-pressure': {
    title: 'Tire Pressure',
    icon: '🛞',
    color: '#3B82F6'
  },
  'now-playing': {
    title: 'Now Playing',
    icon: '🎵',
    color: '#8B5CF6'
  },
  'battery': {
    title: 'Battery',
    icon: '🔋',
    color: '#10B981'
  },
  'speed': {
    title: 'Speed',
    icon: '🏎️',
    color: '#EF4444'
  },
  'temperature': {
    title: 'Temperature',
    icon: '🌡️',
    color: '#F59E0B'
  },
  'fuel': {
    title: 'Fuel',
    icon: '⛽',
    color: '#6366F1'
  }
};

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  initializeMap();
  initializeDragAndDrop();
  initializeDimensionControls();
  initializePhoneFrameResize();
});

/**
 * Initialize Apple Maps
 */
function initializeMap() {
  const mapContainer = document.getElementById('map-container');

  // Check if MapKit JS is available
  if (typeof mapkit !== 'undefined') {
    mapkit.init({
      authorizationCallback: (done) => {
        // In production, you would need a proper MapKit JS token
        // For now, we'll use a fallback
        done('YOUR_MAPKIT_JS_TOKEN');
      }
    });

    state.map = new mapkit.Map(mapContainer, {
      center: new mapkit.Coordinate(37.7749, -122.4194), // San Francisco
      zoom: 12,
      showsUserLocation: false,
      showsUserLocationControl: false,
      showsCompass: mapkit.FeatureVisibility.Hidden,
      showsMapTypeControl: false,
      showsZoomControl: false,
      showsScale: mapkit.FeatureVisibility.Hidden
    });
  } else {
    // Fallback to a static map image if MapKit JS is not available
    mapContainer.innerHTML = `
      <div class="w-full h-full flex items-center justify-center bg-gradient-to-br from-blue-400 to-blue-600">
        <div class="text-white text-center">
          <div class="text-6xl mb-4">🗺️</div>
          <div class="text-lg font-semibold">Apple Maps Preview</div>
          <div class="text-sm opacity-80 mt-2">Map display area</div>
        </div>
      </div>
    `;
  }
}

/**
 * Initialize drag and drop functionality
 */
function initializeDragAndDrop() {
  const widgetItems = document.querySelectorAll('.widget-item');
  const dropZones = document.querySelectorAll('.drop-zone');

  // Setup drag events for widget items
  widgetItems.forEach(item => {
    item.addEventListener('dragstart', handleDragStart);
    item.addEventListener('dragend', handleDragEnd);
  });

  // Setup drop zones
  dropZones.forEach(zone => {
    zone.addEventListener('dragover', handleDragOver);
    zone.addEventListener('dragenter', handleDragEnter);
    zone.addEventListener('dragleave', handleDragLeave);
    zone.addEventListener('drop', handleDrop);
  });
}

/**
 * Handle drag start event
 */
function handleDragStart(e) {
  const widgetType = e.target.dataset.widgetType;
  state.draggingWidget = widgetType;
  e.dataTransfer.effectAllowed = 'copy';
  e.dataTransfer.setData('text/plain', widgetType);

  // Show drop zones
  document.querySelectorAll('.drop-zone').forEach(zone => {
    zone.classList.add('drop-zone-active');
  });
}

/**
 * Handle drag end event
 */
function handleDragEnd(e) {
  state.draggingWidget = null;

  // Hide drop zones
  document.querySelectorAll('.drop-zone').forEach(zone => {
    zone.classList.remove('drop-zone-active', 'drop-zone-hover');
  });
}

/**
 * Handle drag over event
 */
function handleDragOver(e) {
  e.preventDefault();
  e.dataTransfer.dropEffect = 'copy';
}

/**
 * Handle drag enter event
 */
function handleDragEnter(e) {
  if (e.target.classList.contains('drop-zone')) {
    e.target.classList.add('drop-zone-hover');
  }
}

/**
 * Handle drag leave event
 */
function handleDragLeave(e) {
  if (e.target.classList.contains('drop-zone')) {
    e.target.classList.remove('drop-zone-hover');
  }
}

/**
 * Handle drop event
 */
function handleDrop(e) {
  e.preventDefault();
  e.stopPropagation();

  const widgetType = e.dataTransfer.getData('text/plain');
  const dropZone = e.target.closest('.drop-zone');

  if (dropZone && widgetType) {
    const position = dropZone.dataset.position;
    addWidgetToPosition(widgetType, position);
    renderWidgets();
  }

  dropZone.classList.remove('drop-zone-hover');
}

/**
 * Add a widget to a specific position
 */
function addWidgetToPosition(widgetType, position) {
  const widgetId = `widget-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  state.widgets[position].push({
    id: widgetId,
    type: widgetType
  });
}

/**
 * Remove a widget
 */
function removeWidget(widgetId, position) {
  state.widgets[position] = state.widgets[position].filter(w => w.id !== widgetId);
  renderWidgets();
}

/**
 * Render all widgets
 */
function renderWidgets() {
  const dropZones = document.querySelectorAll('.drop-zone');

  dropZones.forEach(zone => {
    const position = zone.dataset.position;
    const widgets = state.widgets[position];

    // Clear existing widget container
    let widgetContainer = zone.querySelector('.widget-container');
    if (!widgetContainer) {
      widgetContainer = document.createElement('div');
      widgetContainer.className = 'widget-container';
      zone.appendChild(widgetContainer);
    }
    widgetContainer.innerHTML = '';

    // Add widgets based on layout direction
    const layoutClass = getLayoutClassForPosition(position);
    widgetContainer.className = `widget-container ${layoutClass}`;

    widgets.forEach(widget => {
      const widgetEl = createWidgetElement(widget, position);
      widgetContainer.appendChild(widgetEl);
    });
  });
}

/**
 * Get layout class for position
 */
function getLayoutClassForPosition(position) {
  const layouts = {
    'top-left': 'flex flex-row gap-2',
    'top-center': 'flex flex-row gap-2',
    'top-right': 'flex flex-row-reverse gap-2',
    'left-center': 'flex flex-col gap-2',
    'right-center': 'flex flex-col gap-2',
    'bottom-left': 'flex flex-row gap-2',
    'bottom-center': 'flex flex-row gap-2',
    'bottom-right': 'flex flex-row-reverse gap-2'
  };
  return layouts[position] || 'flex flex-row gap-2';
}

/**
 * Create a widget element
 */
function createWidgetElement(widget, position) {
  const config = widgetTypes[widget.type];
  const div = document.createElement('div');
  div.className = 'widget-instance';
  div.dataset.widgetId = widget.id;
  div.style.backgroundColor = config.color;

  div.innerHTML = `
    <button class="widget-remove" data-widget-id="${widget.id}" data-position="${position}">×</button>
    <div class="widget-icon">${config.icon}</div>
    <div class="widget-title">${config.title}</div>
  `;

  // Add remove handler
  const removeBtn = div.querySelector('.widget-remove');
  removeBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    removeWidget(widget.id, position);
  });

  return div;
}

/**
 * Initialize dimension controls
 */
function initializeDimensionControls() {
  const widthInput = document.getElementById('width-input');
  const heightInput = document.getElementById('height-input');
  const phoneFrame = document.getElementById('phone-frame');
  const presetButtons = document.querySelectorAll('.dimension-preset');

  // Input change handlers
  widthInput.addEventListener('change', () => {
    updatePhoneFrameDimensions(parseInt(widthInput.value), null);
  });

  heightInput.addEventListener('change', () => {
    updatePhoneFrameDimensions(null, parseInt(heightInput.value));
  });

  // Preset button handlers
  presetButtons.forEach(button => {
    button.addEventListener('click', () => {
      const width = parseInt(button.dataset.width);
      const height = parseInt(button.dataset.height);
      updatePhoneFrameDimensions(width, height);
      widthInput.value = width;
      heightInput.value = height;
    });
  });
}

/**
 * Update phone frame dimensions
 */
function updatePhoneFrameDimensions(width, height) {
  const phoneFrame = document.getElementById('phone-frame');
  const currentWidth = parseInt(phoneFrame.style.width) || 390;
  const currentHeight = parseInt(phoneFrame.style.height) || 844;

  const newWidth = width !== null ? width : currentWidth;
  const newHeight = height !== null ? height : currentHeight;

  phoneFrame.style.width = `${newWidth}px`;
  phoneFrame.style.height = `${newHeight}px`;
}

/**
 * Initialize phone frame resize functionality
 */
function initializePhoneFrameResize() {
  const phoneFrame = document.getElementById('phone-frame');
  const widthInput = document.getElementById('width-input');
  const heightInput = document.getElementById('height-input');

  // Create resize observer to sync input values with actual size
  const resizeObserver = new ResizeObserver(entries => {
    for (let entry of entries) {
      const width = Math.round(entry.contentRect.width);
      const height = Math.round(entry.contentRect.height);
      widthInput.value = width;
      heightInput.value = height;
    }
  });

  resizeObserver.observe(phoneFrame);

  // Add manual resize handles (since CSS resize doesn't give us control)
  addResizeHandles(phoneFrame);
}

/**
 * Add resize handles to phone frame
 */
function addResizeHandles(element) {
  const handles = ['nw', 'ne', 'sw', 'se', 'n', 's', 'e', 'w'];

  handles.forEach(handle => {
    const handleEl = document.createElement('div');
    handleEl.className = `resize-handle resize-handle-${handle}`;
    element.appendChild(handleEl);

    handleEl.addEventListener('mousedown', (e) => {
      e.preventDefault();
      e.stopPropagation();
      startResize(e, element, handle);
    });
  });
}

/**
 * Start resize operation
 */
function startResize(e, element, handle) {
  const startX = e.clientX;
  const startY = e.clientY;
  const startWidth = parseInt(element.style.width) || element.offsetWidth;
  const startHeight = parseInt(element.style.height) || element.offsetHeight;

  function onMouseMove(e) {
    const deltaX = e.clientX - startX;
    const deltaY = e.clientY - startY;

    let newWidth = startWidth;
    let newHeight = startHeight;

    // Handle horizontal resize
    if (handle.includes('e')) {
      newWidth = startWidth + deltaX;
    } else if (handle.includes('w')) {
      newWidth = startWidth - deltaX;
    }

    // Handle vertical resize
    if (handle.includes('s')) {
      newHeight = startHeight + deltaY;
    } else if (handle.includes('n')) {
      newHeight = startHeight - deltaY;
    }

    // Apply constraints (minimum size)
    newWidth = Math.max(200, newWidth);
    newHeight = Math.max(300, newHeight);

    updatePhoneFrameDimensions(newWidth, newHeight);
  }

  function onMouseUp() {
    document.removeEventListener('mousemove', onMouseMove);
    document.removeEventListener('mouseup', onMouseUp);
  }

  document.addEventListener('mousemove', onMouseMove);
  document.addEventListener('mouseup', onMouseUp);
}

/**
 * Export current layout configuration
 */
function exportLayout() {
  const config = {
    dimensions: {
      width: parseInt(document.getElementById('width-input').value),
      height: parseInt(document.getElementById('height-input').value)
    },
    widgets: state.widgets
  };

  console.log('Layout configuration:', config);
  return config;
}

/**
 * Import layout configuration
 */
function importLayout(config) {
  if (config.dimensions) {
    updatePhoneFrameDimensions(config.dimensions.width, config.dimensions.height);
    document.getElementById('width-input').value = config.dimensions.width;
    document.getElementById('height-input').value = config.dimensions.height;
  }

  if (config.widgets) {
    state.widgets = config.widgets;
    renderWidgets();
  }
}

// Expose functions for external use
window.WidgetStudio = {
  exportLayout,
  importLayout
};
