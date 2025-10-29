const API_BASE_URL = 'https://analytics.clutch.engineering';

document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('survey-form');
  const submitButton = document.querySelector('#submit-button, button#submit-button, a#submit-button');
  const errorMessage = document.getElementById('error-message');
  const successMessage = document.getElementById('success-message');
  const currencySelect = document.getElementById('currency');
  const tokenField = document.getElementById('survey-token');

  // Extract token from URL and populate hidden field
  const urlParams = new URLSearchParams(window.location.search);
  const token = urlParams.get('token');

  // Send ping notification to analytics backend
  const pingPayload = token ? { token: token } : {};

  fetch(`${API_BASE_URL}/v1/surveys/lifetime/ping`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(pingPayload)
  })
    .then(response => {
      if (response.ok) {
        return response.json();
      }
      throw new Error('Ping failed');
    })
    .then(data => {
      // If we have a token in the response and no token was provided, use it
      if (data.token && !token && tokenField) {
        tokenField.value = data.token;
      } else if (token && tokenField) {
        // Otherwise use the token from URL if provided
        tokenField.value = token;
      }
    })
    .catch(error => {
      // Silently fail - don't interrupt user experience if ping fails
      console.error('Failed to send ping:', error);
      // If we have a token from URL, still populate it even if ping failed
      if (token && tokenField) {
        tokenField.value = token;
      }
    });

  // Currency symbol mapping
  const currencySymbols = {
    'USD': '$', 'EUR': '€', 'GBP': '£', 'JPY': '¥', 'AUD': '$', 'CAD': '$', 'CHF': 'CHF', 'CNY': '¥',
    'SEK': 'kr', 'NZD': '$', 'MXN': '$', 'SGD': '$', 'HKD': '$', 'NOK': 'kr', 'KRW': '₩', 'TRY': '₺',
    'RUB': '₽', 'INR': '₹', 'BRL': 'R$', 'ZAR': 'R', 'DKK': 'kr', 'PLN': 'zł', 'TWD': 'NT$', 'THB': '฿',
    'IDR': 'Rp', 'MYR': 'RM', 'PHP': '₱', 'CZK': 'Kč', 'ILS': '₪', 'CLP': '$', 'PKR': '₨', 'VND': '₫',
    'AED': 'د.إ', 'SAR': '﷼', 'QAR': '﷼', 'KWD': 'د.ك', 'BHD': 'د.ب', 'OMR': '﷼', 'JOD': 'د.ا',
    'EGP': '£', 'LBP': 'ل.ل', 'MAD': 'د.م.', 'TND': 'د.ت', 'DZD': 'د.ج', 'IQD': 'ع.د', 'LYD': 'ل.د',
    'NGN': '₦', 'KES': 'Sh', 'GHS': '₵', 'ARS': '$', 'COP': '$', 'PEN': 'S/', 'UYU': '$', 'VES': 'Bs.',
    'HUF': 'Ft', 'RON': 'lei', 'BGN': 'лв', 'HRK': 'kn', 'ISK': 'kr', 'UAH': '₴', 'BDT': '৳',
    'LKR': 'Rs', 'NPR': '₨', 'AFN': '؋', 'IRR': '﷼', 'AMD': '֏', 'AZN': '₼', 'GEL': '₾', 'KZT': '₸',
    'UZS': "so'm", 'MMK': 'K', 'LAK': '₭', 'KHR': '៛', 'BND': '$', 'MOP': 'MOP$', 'XOF': 'CFA',
    'XAF': 'FCFA', 'ETB': 'Br', 'UGX': 'Sh', 'TZS': 'Sh', 'RWF': 'Fr', 'MUR': '₨', 'MWK': 'MK',
    'ZMW': 'ZK', 'BWP': 'P', 'NAD': '$', 'SZL': 'L', 'LSL': 'L', 'ANG': 'ƒ', 'AWG': 'ƒ', 'BBD': '$',
    'BMD': '$', 'BSD': '$', 'BZD': '$', 'FJD': '$', 'GYD': '$', 'HTG': 'G', 'JMD': '$', 'KYD': '$',
    'PGK': 'K', 'SBD': '$', 'SRD': '$', 'TOP': 'T$', 'TTD': '$', 'WST': 'T', 'YER': '﷼', 'SYP': '£',
    'SDG': 'ج.س.', 'SOS': 'Sh', 'DOP': '$', 'GTQ': 'Q', 'HNL': 'L', 'NIO': 'C$', 'PAB': 'B/.',
    'CRC': '₡', 'BOB': 'Bs.', 'PYG': '₲', 'ALL': 'L', 'BAM': 'KM', 'MKD': 'ден', 'RSD': 'дин.',
    'MDL': 'L', 'BYN': 'Br', 'TMT': 'm', 'TJS': 'ЅМ', 'KGS': 'с', 'MNT': '₮', 'BTN': 'Nu.',
    'MVR': 'Rf', 'AOA': 'Kz', 'MZN': 'MT', 'CVE': '$', 'GMD': 'D', 'GNF': 'Fr', 'LRD': '$',
    'SLL': 'Le', 'STN': 'Db', 'SCR': '₨', 'MRU': 'UM', 'CDF': 'Fr', 'BIF': 'Fr', 'DJF': 'Fr',
    'ERN': 'Nfk', 'KMF': 'Fr', 'MGA': 'Ar', 'SSP': '£', 'VUV': 'Vt', 'XPF': '₣'
  };

  // Handle currency change
  if (currencySelect) {
    currencySelect.addEventListener('change', function() {
      const selectedCurrency = this.value;
      const symbol = currencySymbols[selectedCurrency] || '$';

      // Update all currency symbols in the form
      const currencySymbolElements = document.querySelectorAll('.currency-symbol');
      currencySymbolElements.forEach(element => {
        element.textContent = symbol;
      });
    });
  }

  // Handle subscription plan radio buttons to show/hide conditional fields
  const subscriptionPlanRadios = document.getElementsByName('subscription-plan');
  const cancellationReasonContainer = document.getElementById('cancellation-reason-container');
  const neverSubscribedReasonContainer = document.getElementById('never-subscribed-reason-container');

  if (subscriptionPlanRadios.length > 0) {
    subscriptionPlanRadios.forEach(radio => {
      radio.addEventListener('change', function() {
        // Handle cancellation reason field
        if (cancellationReasonContainer) {
          if (this.value === 'Cancelled') {
            cancellationReasonContainer.classList.remove('hidden');
          } else {
            cancellationReasonContainer.classList.add('hidden');
            // Clear the textarea value when hiding
            const textarea = document.getElementById('cancellation-reason');
            if (textarea) {
              textarea.value = '';
            }
          }
        }

        // Handle never subscribed reason field
        if (neverSubscribedReasonContainer) {
          if (this.value === 'None') {
            neverSubscribedReasonContainer.classList.remove('hidden');
          } else {
            neverSubscribedReasonContainer.classList.add('hidden');
            // Clear the textarea value when hiding
            const textarea = document.getElementById('never-subscribed-reason');
            if (textarea) {
              textarea.value = '';
            }
          }
        }
      });
    });
  }

  // Define all required fields
  const requiredFields = [
    { id: 'too-cheap', label: 'Price concern (too cheap)', type: 'number' },
    { id: 'bargain', label: 'Bargain price', type: 'number' },
    { id: 'expensive-but-ok', label: 'Getting expensive price', type: 'number' },
    { id: 'too-expensive', label: 'Too expensive price', type: 'number' },
    { name: 'obd-frequency', label: 'OBD features usage frequency', type: 'radio' },
    { name: 'trip-frequency', label: 'Trip logger usage frequency', type: 'radio' },
    { name: 'carplay-frequency', label: 'CarPlay widgets usage frequency', type: 'radio' },
    { name: 'subscription-plan', label: 'Current subscription status', type: 'radio' }
  ];

  if (!submitButton) {
    console.error('Submit button not found');
    return;
  }

  // Add blur event listeners to pricing fields for real-time validation
  const pricingFields = ['too-cheap', 'bargain', 'expensive-but-ok', 'too-expensive'];
  pricingFields.forEach(fieldId => {
    const field = document.getElementById(fieldId);
    if (field) {
      field.addEventListener('blur', function() {
        validatePricingOrder();
      });
    }
  });

  function clearFieldError(fieldId) {
    const errorContainer = document.getElementById(`${fieldId}-error`);
    if (errorContainer) {
      errorContainer.textContent = '';
      errorContainer.classList.add('hidden');
    }
  }

  function showFieldError(fieldId, message) {
    const errorContainer = document.getElementById(`${fieldId}-error`);
    if (errorContainer) {
      errorContainer.textContent = message;
      errorContainer.classList.remove('hidden');
    }
  }

  function validatePricingOrder() {
    // Clear all field errors
    pricingFields.forEach(fieldId => clearFieldError(fieldId));

    const tooCheapInput = document.getElementById('too-cheap');
    const bargainInput = document.getElementById('bargain');
    const expensiveButOkInput = document.getElementById('expensive-but-ok');
    const tooExpensiveInput = document.getElementById('too-expensive');

    let isValid = true;

    // Validate each pair of consecutive fields if both have values
    if (tooCheapInput.value && bargainInput.value) {
      const tooCheap = parseFloat(tooCheapInput.value);
      const bargain = parseFloat(bargainInput.value);

      if (tooCheap >= bargain) {
        showFieldError('bargain', 'This price must be higher than the "too cheap" price.');
        isValid = false;
      }
    }

    if (bargainInput.value && expensiveButOkInput.value) {
      const bargain = parseFloat(bargainInput.value);
      const expensiveButOk = parseFloat(expensiveButOkInput.value);

      if (bargain >= expensiveButOk) {
        showFieldError('expensive-but-ok', 'This price must be higher than the bargain price.');
        isValid = false;
      }
    }

    if (expensiveButOkInput.value && tooExpensiveInput.value) {
      const expensiveButOk = parseFloat(expensiveButOkInput.value);
      const tooExpensive = parseFloat(tooExpensiveInput.value);

      if (expensiveButOk >= tooExpensive) {
        showFieldError('too-expensive', 'This price must be higher than the "getting expensive" price.');
        isValid = false;
      }
    }

    return isValid;
  }

  submitButton.addEventListener('click', async function(e) {
    e.preventDefault();

    // Clear previous messages
    errorMessage.classList.add('hidden');
    successMessage.classList.add('hidden');
    errorMessage.querySelector('span')?.remove();
    successMessage.querySelector('span')?.remove();

    // Validate all required fields
    const missingFields = [];

    requiredFields.forEach(field => {
      if (field.type === 'number') {
        const input = document.getElementById(field.id);
        if (!input || !input.value || input.value.trim() === '') {
          missingFields.push(field.label);
        }
      } else if (field.type === 'radio') {
        const radios = document.getElementsByName(field.name);
        const isChecked = Array.from(radios).some(radio => radio.checked);
        if (!isChecked) {
          missingFields.push(field.label);
        }
      }
    });

    // Show error if any fields are missing
    if (missingFields.length > 0) {
      const errorText = document.createElement('span');
      errorText.textContent = `Please complete the following required fields: ${missingFields.join(', ')}`;
      errorMessage.appendChild(errorText);
      errorMessage.classList.remove('hidden');
      return;
    }

    // Validate that pricing fields are monotonically increasing
    if (!validatePricingOrder()) {
      return;
    }

    // Collect form data
    const formData = {
      currency: currencySelect ? currencySelect.value : 'USD'
    };

    // Include token if present
    if (tokenField && tokenField.value) {
      formData.token = tokenField.value;
    }

    requiredFields.forEach(field => {
      if (field.type === 'number') {
        const input = document.getElementById(field.id);
        formData[field.id] = input.value;
      } else if (field.type === 'radio') {
        const radios = document.getElementsByName(field.name);
        const selected = Array.from(radios).find(radio => radio.checked);
        if (selected) {
          formData[field.name] = selected.value;
        }
      }
    });

    // Include cancellation reason if provided
    const cancellationReasonTextarea = document.getElementById('cancellation-reason');
    if (cancellationReasonTextarea && cancellationReasonTextarea.value.trim()) {
      formData['cancellation-reason'] = cancellationReasonTextarea.value.trim();
    }

    // Include never-subscribed reason if provided
    const neverSubscribedReasonTextarea = document.getElementById('never-subscribed-reason');
    if (neverSubscribedReasonTextarea && neverSubscribedReasonTextarea.value.trim()) {
      formData['never-subscribed-reason'] = neverSubscribedReasonTextarea.value.trim();
    }

    // Submit the form
    try {
      submitButton.disabled = true;
      submitButton.textContent = 'Submitting...';

      // Convert formData object to URLSearchParams for standard form encoding
      const urlEncodedData = new URLSearchParams();
      for (const [key, value] of Object.entries(formData)) {
        urlEncodedData.append(key, value);
      }

      const response = await fetch(`${API_BASE_URL}/v1/surveys/lifetime`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: urlEncodedData
      });

      if (response.ok) {
        // Show success message (text and image are already in the HTML)
        successMessage.classList.remove('hidden');

        // Hide the form (success message is now a sibling, so it will remain visible)
        form.style.display = 'none';
      } else {
        // Try to parse error response
        let errorBody;
        try {
          errorBody = await response.json();
        } catch {
          throw new Error('Failed to submit survey');
        }

        // Handle validation errors
        if (errorBody.detail && Array.isArray(errorBody.detail)) {
          // Clear any previous field errors
          pricingFields.forEach(fieldId => clearFieldError(fieldId));

          // Display field-specific errors
          errorBody.detail.forEach(err => {
            // Extract field name from location array (e.g., ["body", "too-cheap"])
            const fieldName = err.loc && err.loc.length > 1 ? err.loc[1] : null;
            if (fieldName && pricingFields.includes(fieldName)) {
              showFieldError(fieldName, err.msg || 'Invalid value');
            }
          });

          // Show general error message
          const errorText = document.createElement('span');
          errorText.textContent = 'Please fix the validation errors above.';
          errorMessage.appendChild(errorText);
          errorMessage.classList.remove('hidden');
        } else if (errorBody.detail && typeof errorBody.detail === 'string') {
          // Handle simple string error message
          const errorText = document.createElement('span');
          errorText.textContent = errorBody.detail;
          errorMessage.appendChild(errorText);
          errorMessage.classList.remove('hidden');
        } else {
          throw new Error('Failed to submit survey');
        }

        submitButton.disabled = false;
        submitButton.textContent = 'Submit Responses';
        return;
      }
    } catch (error) {
      const errorText = document.createElement('span');
      errorText.textContent = 'An error occurred while submitting your responses. Please try again.';
      errorMessage.appendChild(errorText);
      errorMessage.classList.remove('hidden');

      submitButton.disabled = false;
      submitButton.textContent = 'Submit Responses';
    }
  });
});
