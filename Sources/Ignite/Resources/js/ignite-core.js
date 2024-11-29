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

        document.documentElement.setAttribute('data-theme-state', savedTheme);

        if (savedTheme === 'auto') {
            if (supportsLightTheme && supportsDarkTheme) {
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                document.documentElement.setAttribute('data-bs-theme', prefersDark ? 'dark' : 'light');
            } else if (supportsDarkTheme) {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
            } else if (supportsLightTheme) {
                document.documentElement.setAttribute('data-bs-theme', 'light');
            }
        } else {
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        }

        // Setup theme change listener
        if (supportsLightTheme && supportsDarkTheme) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
                const currentTheme = localStorage.getItem('custom-theme');
                if (currentTheme === 'auto') {
                    document.documentElement.setAttribute('data-bs-theme', e.matches ? 'dark' : 'light');
                }
            });
        }
    });
})();

function igniteApplyTheme(themeID) {
    document.documentElement.setAttribute('data-theme-state', themeID);
    localStorage.setItem('custom-theme', themeID);

    if (themeID === 'auto') {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        document.documentElement.setAttribute('data-bs-theme', prefersDark ? 'dark' : 'light');
    } else {
        document.documentElement.setAttribute('data-bs-theme', themeID);
    }
}

// Switch theme action
function igniteSwitchTheme(themeID) {
    igniteApplyTheme(themeID);
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

const appearElements = document.querySelectorAll('[class*="animation-"]');

setTimeout(() => {
    appearElements.forEach(element => {
        element.classList.add('appeared');
    });
}, 100);

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
