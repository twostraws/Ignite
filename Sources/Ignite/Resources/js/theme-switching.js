(function() {
    function getThemePreference() {
        return localStorage.getItem('custom-theme') || 'auto';
    }

    function applyTheme(themeID) {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const lightThemeID = document.documentElement.getAttribute('data-light-theme') || 'light';
        const darkThemeID = document.documentElement.getAttribute('data-dark-theme') || 'dark';
        const actualThemeID = themeID === 'auto' ? (prefersDark ? darkThemeID : lightThemeID) : themeID;

        document.documentElement.setAttribute('data-bs-theme', actualThemeID);
        document.documentElement.setAttribute('data-theme-state', themeID);
    }

    function applySyntaxTheme() {
        const syntaxTheme = getComputedStyle(document.documentElement)
            .getPropertyValue('--syntax-highlight-theme').trim().replace(/"/g, '');

        if (!syntaxTheme) return;

        document.querySelectorAll('link[data-highlight-theme]').forEach(link => {
            link.setAttribute('disabled', 'disabled');
        });

        const themeLink = document.querySelector(`link[data-highlight-theme="${syntaxTheme}"]`);
        if (themeLink) {
            themeLink.removeAttribute('disabled');
        }
    }

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
        const currentTheme = getThemePreference();
        if (currentTheme === 'auto') {
            applyTheme('auto');
            applySyntaxTheme();
        }
    });

    const savedTheme = getThemePreference();
    applyTheme(savedTheme);
    applySyntaxTheme();
})();
