// Extract code parameter from URL and set it to #code element
document.addEventListener('DOMContentLoaded', function() {
  const urlParams = new URLSearchParams(window.location.search);
  const code = urlParams.get('code');
  const codeElement = document.getElementById('code');
  const redeemLink = document.getElementById('redeem-link');

  if (code && codeElement) {
    codeElement.textContent = code;

    // Update the redeem link with the code
    if (redeemLink) {
      redeemLink.href = `https://apps.apple.com/redeem?ctx=offercodes&id=1663683832&code=${code}`;
    }

    // Send POST request to track redemption (only once per code)
    const storageKey = `betacode_redeemed_${code}`;
    if (!localStorage.getItem(storageKey)) {
      fetch('https://analytics.clutch.engineering/v1/betacode/redeem', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ code: code })
      })
        .then(function() {
          localStorage.setItem(storageKey, 'true');
        })
        .catch(function(error) {
          console.error('Failed to send redemption tracking:', error);
        });
    }
  }

  // Handle copy button clicks
  const copyButton = document.getElementById('copy-code-button');
  const copiedMessage = document.getElementById('copied-message');
  if (copyButton) {
    copyButton.addEventListener('click', function() {
      const codeText = codeElement ? codeElement.textContent : '';
      if (codeText) {
        navigator.clipboard.writeText(codeText);

        // Show the "Copied!" message
        if (copiedMessage) {
          copiedMessage.style.opacity = '1';
          setTimeout(function() {
            copiedMessage.style.opacity = '0';
          }, 1000);
        }
      }
    });
  }
});