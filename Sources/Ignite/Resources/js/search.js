// Global variables for search
let idx;
let documents = [];

/**
 * @typedef {Object} SearchContext
 * @property {Array} results - The search results
 * @property {HTMLFormElement} mainSearchForm - The main search form
 * @property {HTMLElement} mainContent - The main content container
 * @property {HTMLElement} mainSearchResults - The search results container
 * @property {DocumentFragment} templateContent - The search result template content
 * @property {string} query - The search query
 */

// DOM Element Helpers
function getMainContent() {
    return document.querySelector('.ig-main-content');
}

function getOrCreateSearchResults(mainContent) {
    let mainSearchResults = mainContent.querySelector('.main-search-results');
    if (!mainSearchResults) {
        mainSearchResults = document.createElement('div');
        mainSearchResults.className = 'main-search-results';
        mainContent.insertBefore(mainSearchResults, mainContent.firstChild);
    }
    return mainSearchResults;
}

function hideOtherContent(mainContent, mainSearchResults) {
    Array.from(mainContent.children).forEach(child => {
        if (child !== mainSearchResults) {
            child.style.display = 'none';
        }
    });
}

function showAllContent(mainContent) {
    Array.from(mainContent.children).forEach(child => {
        child.style.display = '';
    });
}

// Search Field Management
function updateAllSearchFields(value) {
    document.querySelectorAll('[id^="search-input-"]').forEach(input => {
        input.value = value;
        const clearButton = input.parentElement.querySelector('.bi-x-circle-fill').closest('button');
        clearButton.style.visibility = value.trim() ? 'visible' : 'hidden';
    });
}

// Search Index Management
function loadSearchIndex() {
    return fetch('/search-index.json')
    .then(response => response.json())
    .then(data => {
        window.searchDocuments = data;
        window.searchIndex = createLunrIndex(data);
    });
}

function createLunrIndex(data) {
    return lunr(function () {
        this.ref('id');
        this.field('title');
        this.field('description');
        this.field('body');
        this.field('tags');

        data.forEach(function (doc) {
            this.add(doc);
        }, this);
    });
}

// Result Item Creation
function createResultItem(doc, templateContent) {
    const clone = templateContent.cloneNode(true);
    const resultItem = clone.querySelector('.search-results-item');
    const wrapperLink = createWrapperLink(doc);

    while (resultItem.firstChild) {
        wrapperLink.appendChild(resultItem.firstChild);
    }

    resultItem.innerHTML = '';
    resultItem.appendChild(wrapperLink);
    updateResultContent(wrapperLink, doc);

    return resultItem;
}

function createWrapperLink(doc) {
    const wrapperLink = document.createElement('a');
    wrapperLink.href = doc.id;
    wrapperLink.className = 'link-plain text-reset';
    return wrapperLink;
}

function updateResultContent(wrapperLink, doc) {
    updateTitle(wrapperLink, doc);
    updateDescription(wrapperLink, doc);
    updateDate(wrapperLink, doc);
    updateTags(wrapperLink, doc);
}

function updateTitle(wrapperLink, doc) {
    const title = wrapperLink.querySelector('.result-title');
    if (title) {
        title.textContent = doc.title;
    }
}

function updateDescription(wrapperLink, doc) {
    const description = wrapperLink.querySelector('.result-description');
    if (description) {
        description.textContent = (doc.description || '') + '...';
    }
}

function updateDate(wrapperLink, doc) {
    const date = wrapperLink.querySelector('.result-date');
    if (date) {
        if (doc.date && doc.date.trim()) {
            date.textContent = doc.date;
            date.style.display = 'unset';
        } else {
            date.style.display = 'none';
        }
    }
}

function updateTags(wrapperLink, doc) {
    const tags = wrapperLink.querySelector('.result-tags');
    if (tags) {
        if (doc.tags && doc.tags.trim()) {
            const tagList = doc.tags.split(',');
            const parentStyle = tags.getAttribute('style');
            const parentClasses = tags.getAttribute('class');

            const tagSpans = tagList.map(tag =>
                `<span class="tag ${parentClasses}" style="${parentStyle}">${tag}</span>`
            ).join('');

            tags.removeAttribute('style');
            tags.className = '';
            tags.style.display = 'unset';

            tags.innerHTML = `<div class="d-flex gap-2">${tagSpans}</div>`;
            tags.style.display = 'unset';
        } else {
            tags.style.display = 'none';
        }
    }
}

// Cloned Form Management
function setupClonedForm(context) {
    const { mainSearchForm, mainContent, mainSearchResults, query } = context;
    const clonedForm = mainSearchForm.cloneNode(true);
    clonedForm.classList.add('my-3');
    mainSearchResults.appendChild(clonedForm);
    setupClonedFormEventHandlers(clonedForm, mainContent, mainSearchResults);
    updateAllSearchFields(query);
    return clonedForm;
}

function setupClonedFormEventHandlers(clonedForm, mainContent, mainSearchResults) {
    const clonedInput = clonedForm.querySelector('[id^="search-input-"]');
    const clonedSearchButton = clonedForm.querySelector('button[type="submit"]');
    const clonedClearButton = clonedForm.querySelector('.bi-x-circle-fill').closest('button');

    clonedInput.addEventListener('input', function() {
        updateAllSearchFields(this.value);
    });

    clonedClearButton.addEventListener('click', function() {
        updateAllSearchFields('');
        showAllContent(mainContent);
        mainSearchResults.innerHTML = '';
    });

    clonedSearchButton.onclick = function() {
        performSearch(clonedInput.value);
    };
}

// Search Input Setup
function setupSearchInput(searchInput) {
    const clearButton = searchInput.parentElement.querySelector('.bi-x-circle-fill').closest('button');
    const searchButton = searchInput.closest('form').querySelector('button[type="submit"]');

    clearButton.style.visibility = 'hidden';
    setupSearchInputEventHandlers(searchInput, clearButton, searchButton);
}

function setupSearchInputEventHandlers(searchInput, clearButton, searchButton) {
    searchInput.addEventListener('input', function() {
        updateAllSearchFields(this.value);
    });

    clearButton.addEventListener('click', function() {
        updateAllSearchFields('');
        const mainContent = getMainContent();
        const mainSearchResults = mainContent.querySelector('.main-search-results');
        if (mainSearchResults) {
            mainSearchResults.innerHTML = '';
        }
        showAllContent(mainContent);
    });

    searchButton.onclick = function() {
        performSearch(searchInput.value);
    };

    searchInput.addEventListener('blur', handleSearchInputBlur);
}

function handleSearchInputBlur() {
    if (!this.value.trim()) {
        const mainContent = getMainContent();
        const mainSearchResults = mainContent.querySelector('.main-search-results');
        if (mainSearchResults) {
            mainSearchResults.innerHTML = '';
        }
        showAllContent(mainContent);
    }
}

// Main Search Function
function performSearch(query) {
    if (!window.searchIndex || !query || !query.trim()) {
        return;
    }

    // Get the search form that triggered this search
    const activeForm = event.target.closest('form');
    // Find the template that's closest to this form
    const template = activeForm.nextElementSibling;

    if (!template || template.tagName !== 'TEMPLATE') {
        console.error('No template found next to the search form');
        return;
    }

    const templateContent = template.content;
    const mainContent = getMainContent();
    const mainSearchResults = getOrCreateSearchResults(mainContent);
    const results = window.searchIndex.search(query);

    const searchContext = {
        results,
        mainSearchForm: activeForm,
        mainContent,
        mainSearchResults,
        templateContent,
        query
    };

    if (results.length === 0) {
        handleNoResults(searchContext);
        return;
    }

    displaySearchResults(searchContext);
}

function isInNavbar(element) {
    return element.closest('.navbar') !== null;
}

function displaySearchResults(context) {
    const { results, mainSearchForm, mainContent, mainSearchResults, templateContent, query } = context;
    mainSearchResults.innerHTML = '';
    const header = templateContent.querySelector('.search-results-header');

    if (header) {
        const clonedHeader = header.cloneNode(true);
        mainSearchResults.insertBefore(clonedHeader, mainSearchResults.firstChild);
    }

    if (mainSearchForm && !isInNavbar(mainSearchForm)) {
        setupClonedForm(context);
    }

    hideOtherContent(mainContent, mainSearchResults);

    results.forEach(result => {
        const doc = window.searchDocuments.find(doc => doc.id === result.ref);
        const resultItem = createResultItem(doc, templateContent);
        mainSearchResults.appendChild(resultItem);
    });
}

function handleNoResults(context) {
    const { mainSearchForm, mainContent, mainSearchResults, templateContent, query } = context;

    mainSearchResults.innerHTML = '';

    const header = templateContent.querySelector('.search-results-header');
    if (header) {
        const clonedHeader = header.cloneNode(true);
        mainSearchResults.appendChild(clonedHeader);
    }

    if (mainSearchForm && !isInNavbar(mainSearchForm)) {
        setupClonedForm(context);
    }

    mainSearchResults.insertAdjacentHTML('beforeend', '<p>No results found</p>');
    hideOtherContent(mainContent, mainSearchResults);
}
// Initialize
document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();
    document.querySelectorAll('[id^="search-input-"]').forEach(setupSearchInput);
});
