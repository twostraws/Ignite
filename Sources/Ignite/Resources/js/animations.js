function handleClickAnimation(event) {
    event.preventDefault();
    const element = this;
    
    // Toggle between clicked and clicked+reverse states
    if (element.classList.contains('clicked') && !element.classList.contains('reverse')) {
        element.classList.remove('clicked');
        void element.offsetWidth;  // Force reflow
        element.classList.add('clicked', 'reverse');
    } else {
        element.classList.remove('clicked', 'reverse');
        void element.offsetWidth;  // Force reflow
        element.classList.add('clicked');
    }
}

// Add click handlers when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-click-classes]').forEach(element => {
        element.addEventListener('click', handleClickAnimation);
    });
});

function handleAppearAnimation() {
    if (!this.dataset.appearClasses) return;
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                requestAnimationFrame(() => {
                    const classes = this.dataset.appearClasses.split(' ');
                    classes.forEach((cls) => {
                        if (cls) this.classList.add(cls.trim());
                    });
                });
                observer.unobserve(this);
            }
        });
    }, { threshold: 0.1, rootMargin: '50px' });
    
    observer.observe(this);
}

// Immediately handle elements that are already in the DOM
function initializeAppearAnimations() {
    document.querySelectorAll('[data-appear-classes]').forEach(element => {
        handleAppearAnimation.call(element);
    });
}

// Run immediately for elements already in DOM
initializeAppearAnimations();

// Run again after DOMContentLoaded for dynamically added elements
window.addEventListener('DOMContentLoaded', () => {
    requestAnimationFrame(initializeAppearAnimations);
});
