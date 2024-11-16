function igniteHandleClickAnimation(event) {
    event.preventDefault();
    const element = this;
    const clickClasses = element.dataset.clickClasses.split(' ');
    const appearClasses = element.dataset.appearClasses?.split(' ') || [];
    
    // Check if any appear animation is still running
    if (appearClasses.some(appearClass => element.classList.contains(appearClass))) {
        element.addEventListener('animationend', () => {
            igniteApplyClickAnimation(element, clickClasses);
        }, { once: true });
        return;
    }
    
    igniteApplyClickAnimation(element, clickClasses);
}

function igniteApplyClickAnimation(element, clickClasses) {
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

// Add click handlers when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-click-classes]').forEach(element => {
        element.addEventListener('click', igniteHandleClickAnimation);
    });
});

function igniteHandleAppearAnimation() {
    if (!this.dataset.appearClasses) return;
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                requestAnimationFrame(() => {
                    const classes = this.dataset.appearClasses.split(' ');
                    classes.forEach((cls) => {
                        if (cls) {
                            this.classList.add(cls.trim());
                            // Remove appear class after animation completes
                            this.addEventListener('animationend', () => {
                                this.classList.remove(cls.trim());
                                // Keep the opacity at 1
                                this.style.opacity = '1';
                            }, { once: true });
                        }
                    });
                });
                observer.unobserve(this);
            }
        });
    }, { threshold: 0.1, rootMargin: '50px' });
    
    observer.observe(this);
}

// Immediately handle elements that are already in the DOM
function igniteInitializeAppearAnimations() {
    document.querySelectorAll('[data-appear-classes]').forEach(element => {
        igniteHandleAppearAnimation.call(element);
    });
}

// Run immediately for elements already in DOM
igniteInitializeAppearAnimations();

// Run again after DOMContentLoaded for dynamically added elements
window.addEventListener('DOMContentLoaded', () => {
    requestAnimationFrame(igniteInitializeAppearAnimations);
});
