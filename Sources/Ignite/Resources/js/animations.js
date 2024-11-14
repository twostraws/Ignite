function handleClickAnimation(event) {
    event.preventDefault();
    const element = this;
    const clickClasses = element.dataset.clickClasses.split(' ');
    applyClickAnimation(element, clickClasses);
}

function applyClickAnimation(element, clickClasses) {
    clickClasses.forEach(clickClass => {
        if (element.classList.contains(clickClass) && !element.classList.contains('reverse')) {
            element.classList.remove(clickClass);
            void element.offsetWidth;  // Force reflow
            element.classList.add(clickClass, 'reverse');
        } else {
            element.classList.remove(clickClass, 'reverse');
            void element.offsetWidth;  // Force reflow
            element.classList.add(clickClass);
        }
    });
}

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

// Add click handlers when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-click-classes]').forEach(element => {
        element.addEventListener('click', handleClickAnimation);
    });
});

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
