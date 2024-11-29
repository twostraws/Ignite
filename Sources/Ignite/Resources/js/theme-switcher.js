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

// Apply theme immediately before DOM loads
(function() {
    const savedTheme = localStorage.getItem('custom-theme') || 'auto';
    document.documentElement.setAttribute('data-theme-state', savedTheme);

    if (savedTheme === 'auto') {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        document.documentElement.setAttribute('data-bs-theme', prefersDark ? 'dark' : 'light');
    } else {
        document.documentElement.setAttribute('data-bs-theme', savedTheme);
    }
})();

// Setup listeners after DOM loads
document.addEventListener('DOMContentLoaded', function() {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
        const currentTheme = localStorage.getItem('custom-theme');
        if (currentTheme === 'auto') {
            document.documentElement.setAttribute('data-bs-theme', e.matches ? 'dark' : 'light');
        }
    });
});

function applyTheme(themeID) {
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
function switchTheme(themeID) {
    applyTheme(themeID);
}
