// SECTION: Theme Switching -----------------------------------------------------------------

/**
 * Theme Switching Implementation
 *
 * Bootstrap's theming system only understands explicit themes (light/dark/custom)
 * through data-bs-theme. For "auto" theme support, our JavaScript code must
 * actively switch data-bs-theme between "light" and "dark" based on the system
 * preference (see lines 31-33, 39-44, and 51-54).
 *
 * This creates a problem: we lose track of the fact that we're in "auto" mode
 * since data-bs-theme can only be "light" or "dark". To solve this, we use:
 *
 * 1. data-bs-theme: Bootstrap's visual theming (always explicit: light/dark)
 * 2. data-theme-state: User's actual theme selection (light/dark/auto/custom)
 *
 * This separation lets us track the true theme state while still working within
 * Bootstrap's theming constraints.
 */

(function() {
    document.addEventListener('DOMContentLoaded', function() {
        const savedTheme = localStorage.getItem('custom-theme') || 'auto';
        const supportsLightTheme = getComputedStyle(document.documentElement).getPropertyValue('--supports-light-theme') === 'true';
        const supportsDarkTheme = getComputedStyle(document.documentElement).getPropertyValue('--supports-dark-theme') === 'true';
        const lightThemeID = getComputedStyle(document.documentElement).getPropertyValue('--light-theme-id').trim().replace(/"/g, '') || 'light';
        const darkThemeID = getComputedStyle(document.documentElement).getPropertyValue('--dark-theme-id').trim().replace(/"/g, '') || 'dark';

        if (savedTheme === 'auto') {
            if (supportsLightTheme && supportsDarkTheme) {
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                const themeID = prefersDark ? darkThemeID : lightThemeID;
                document.documentElement.setAttribute('data-bs-theme', themeID);
                document.documentElement.setAttribute('data-theme-state', themeID);
            } else if (supportsDarkTheme) {
                document.documentElement.setAttribute('data-bs-theme', darkThemeID);
                document.documentElement.setAttribute('data-theme-state', darkThemeID);
            } else if (supportsLightTheme) {
                document.documentElement.setAttribute('data-bs-theme', lightThemeID);
                document.documentElement.setAttribute('data-theme-state', lightThemeID);
            }
        } else {
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
            document.documentElement.setAttribute('data-theme-state', savedTheme);
        }

        // Apply initial syntax theme
        igniteApplySyntaxTheme();

        if (supportsLightTheme && supportsDarkTheme) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
                const currentTheme = localStorage.getItem('custom-theme');
                if (currentTheme === 'auto') {
                    const themeID = e.matches ? darkThemeID : lightThemeID;
                    document.documentElement.setAttribute('data-bs-theme', themeID);
                    document.documentElement.setAttribute('data-theme-state', themeID);
                    igniteApplySyntaxTheme();
                }
            });
        }
    });
})();

function igniteApplyTheme(themeID) {
    if (themeID === 'auto') {
        localStorage.removeItem('custom-theme');
    } else {
        localStorage.setItem('custom-theme', themeID);
    }

    const supportsLightTheme = getComputedStyle(document.documentElement).getPropertyValue('--supports-light-theme') === 'true';
    const supportsDarkTheme = getComputedStyle(document.documentElement).getPropertyValue('--supports-dark-theme') === 'true';
    const lightThemeID = getComputedStyle(document.documentElement).getPropertyValue('--light-theme-id').trim().replace(/"/g, '') || 'light';
    const darkThemeID = getComputedStyle(document.documentElement).getPropertyValue('--dark-theme-id').trim().replace(/"/g, '') || 'dark';

    if (themeID === 'auto' && supportsLightTheme && supportsDarkTheme) {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const themeID = prefersDark ? darkThemeID : lightThemeID;
        document.documentElement.setAttribute('data-bs-theme', themeID);
        document.documentElement.setAttribute('data-theme-state', themeID);
    } else {
        document.documentElement.setAttribute('data-bs-theme', themeID);
        document.documentElement.setAttribute('data-theme-state', themeID);
    }

    // Let the CSS update before getting the new syntax theme
    requestAnimationFrame(() => {
        igniteApplySyntaxTheme();
    });
}

function igniteApplySyntaxTheme() {
    // Get the current syntax theme from CSS variable
    const syntaxTheme = getComputedStyle(document.documentElement)
        .getPropertyValue('--syntax-highlight-theme').trim().replace(/"/g, '');

    // Disable all themes first
    const themeLinks = document.querySelectorAll('link[data-highlight-theme]');

    themeLinks.forEach(link => {
        link.setAttribute('disabled', 'disabled');
    });

    // Enable the selected theme
    const themeLink = document.querySelector(`link[data-highlight-theme="${syntaxTheme}"]`);

    if (themeLink) {
        themeLink.removeAttribute('disabled');
    }
}

function igniteSwitchTheme(themeID) {
    igniteApplyTheme(themeID);

    // Force style recalculation using CSS custom property
    const timestamp = Date.now();
    document.documentElement.style.setProperty('--theme-update', `"${timestamp}"`);

    // Additional force reflow with minimal DOM mutation
    const forceReflow = document.createElement('div');
    document.body.appendChild(forceReflow);
    document.body.offsetHeight; // Force reflow
    document.body.removeChild(forceReflow);

    // Final cleanup
    requestAnimationFrame(() => {
        document.documentElement.style.removeProperty('--theme-update');
    });
}

// SECTION: Email Protection ------------------------------------------------------------------

function encodeEmail(email) {
    return btoa(email);
}

function decode(encoded) {
    return atob(encoded);
}

// Decodes the display text when the page loads
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.protected-link').forEach(link => {
        const encodedDisplay = link.textContent;
        try {
            const decodedDisplay = decode(encodedDisplay);
            link.textContent = decodedDisplay;
        } catch {
            // If decoding fails, the display text wasn't encoded
        }
    });
});

// Handle clicks on protected links
document.addEventListener('click', (e) => {
    // Find closest parent link with protected-link class
    const protectedLink = e.target.closest('.protected-link');
    if (protectedLink) {
        e.preventDefault();
        const encodedUrl = protectedLink.getAttribute('data-encoded-url');
        const url = decode(encodedUrl);
        window.location.href = url;
    }
});

// SECTION: Animations ------------------------------------------------------------------------

document.addEventListener('DOMContentLoaded', () => {
    const appearElements = document.querySelectorAll('[class*="animation-"]');

    setTimeout(() => {
        appearElements.forEach(element => {
            element.classList.add('appeared');
        });
    }, 100);
});

function igniteToggleClickAnimation(element) {
    if (element.classList.contains('clicked')) {
        element.classList.remove('clicked');
        element.classList.add('unclicked');
    } else {
        element.classList.remove('unclicked');
        element.classList.add('clicked');
    }
    return false;
}
