const appearElements = document.querySelectorAll('[class*="animation-"]');

setTimeout(() => {
    appearElements.forEach(element => {
        element.classList.add('appeared');
    });
}, 100);

function toggleClickAnimation(element) {
    if (element.classList.contains('clicked')) {
        element.classList.remove('clicked');
        element.classList.add('unclicked');
    } else {
        element.classList.remove('unclicked');
        element.classList.add('clicked');
    }
    return false;
}
