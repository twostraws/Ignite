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
function createResultItem(doc, templateContent, query) {
    const clone = templateContent.cloneNode(true);
    const resultItem = clone.querySelector('.search-results-item');
    const wrapperLink = createWrapperLink(doc);

    while (resultItem.firstChild) {
        wrapperLink.appendChild(resultItem.firstChild);
    }

    resultItem.innerHTML = '';
    resultItem.appendChild(wrapperLink);
    updateResultContent(wrapperLink, doc, query);

    return resultItem;
}

function createWrapperLink(doc) {
    const wrapperLink = document.createElement('a');
    wrapperLink.href = doc.id;
    wrapperLink.className = 'link-plain text-reset';
    return wrapperLink;
}

function updateResultContent(wrapperLink, doc, query) {
    updateTitle(wrapperLink, doc);
    updateDescription(wrapperLink, doc, query);
    updateDate(wrapperLink, doc);
    updateTags(wrapperLink, doc);
}

function updateTitle(wrapperLink, doc) {
    const title = wrapperLink.querySelector('.result-title');
    if (title) {
        title.textContent = doc.title;
    }
}

function updateDescription(wrapperLink, doc, query) {
    const description = wrapperLink.querySelector('.result-description');
    if (description) {
        const text = (doc.description || '') + '...';

        // Create a case-insensitive regular expression from the search query
        const searchTerms = query.trim().split(/\s+/);
        const regex = new RegExp(`(${searchTerms.join('|')})`, 'gi');

        // Replace matches with marked version
        const markedText = text.replace(regex, '<mark>$1</mark>');

        // Use innerHTML instead of textContent to render the mark tags
        description.innerHTML = markedText;
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
    return clonedForm;
}

function setupClonedFormEventHandlers(clonedForm, mainContent, mainSearchResults) {
    const clonedInput = clonedForm.querySelector('[id^="search-input-"]');
    const clonedSearchButton = clonedForm.querySelector('button[type="submit"]');
    const clonedClearButton = clonedForm.querySelector('.bi-x-circle-fill').closest('button');

    clonedInput.addEventListener('input', function() {
        clonedClearButton.style.visibility = this.value.trim() ? 'visible' : 'hidden';
    });

    clonedClearButton.addEventListener('click', function() {
        clonedInput.value = '';
        clonedClearButton.style.visibility = 'hidden';
        showAllContent(mainContent);
        mainSearchResults.innerHTML = '';
    });

    clonedSearchButton.onclick = function() {
        const query = clonedInput.value;
        // Clear and blur the input after search
        clonedInput.value = '';
        clonedInput.blur();
        clonedClearButton.style.visibility = 'hidden';
        performSearch(query);
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
        clearButton.style.visibility = this.value.trim() ? 'visible' : 'hidden';
    });

    clearButton.addEventListener('click', function() {
        // Clear the input text
        searchInput.value = '';
        clearButton.style.visibility = 'hidden';
        const mainContent = getMainContent();
        const mainSearchResults = mainContent.querySelector('.main-search-results');
        if (mainSearchResults) {
            mainSearchResults.innerHTML = '';
        }
        showAllContent(mainContent);
    });

    searchButton.onclick = function() {
        const query = searchInput.value;
        // Clear and blur the input after search
        searchInput.value = '';
        searchInput.blur();
        clearButton.style.visibility = 'hidden';
        performSearch(query);
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

    const activeForm = event.target.closest('form');

    // Find the template - it's either next to the form or we need to find the original template
    let template;
    if (activeForm.classList.contains('results-search-form')) {
        // If this is the results form, find the original template
        template = document.querySelector('[id^="search-results-"]');
    } else {
        // If this is the original form, the template is next to it
        template = activeForm.nextElementSibling;
    }

    if (!template || template.tagName !== 'TEMPLATE') {
        console.error('No template found');
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

    const resultsForm = templateContent.querySelector('.results-search-form');
    if (resultsForm) {
        const clonedResultsForm = resultsForm.cloneNode(true);
        mainSearchResults.appendChild(clonedResultsForm);
        setupClonedFormEventHandlers(clonedResultsForm, mainContent, mainSearchResults);

        const resultsInput = clonedResultsForm.querySelector('[id^="search-input-"]');
        if (resultsInput) {
            resultsInput.value = query;
            const resultsClearButton = resultsInput.parentElement.querySelector('.bi-x-circle-fill').closest('button');
            resultsClearButton.style.visibility = query.trim() ? 'visible' : 'hidden';
        }
    }

    hideOtherContent(mainContent, mainSearchResults);

    results.forEach(result => {
        const doc = window.searchDocuments.find(doc => doc.id === result.ref);
        const resultItem = createResultItem(doc, templateContent, query);
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

    const resultsForm = templateContent.querySelector('.results-search-form');
    if (resultsForm) {
        const clonedResultsForm = resultsForm.cloneNode(true);
        mainSearchResults.appendChild(clonedResultsForm);
        setupClonedFormEventHandlers(clonedResultsForm, mainContent, mainSearchResults);

        const resultsInput = clonedResultsForm.querySelector('[id^="search-input-"]');
        if (resultsInput) {
            resultsInput.value = query;
            const resultsClearButton = resultsInput.parentElement.querySelector('.bi-x-circle-fill').closest('button');
            resultsClearButton.style.visibility = query.trim() ? 'visible' : 'hidden';
        }
    }

    mainSearchResults.insertAdjacentHTML('beforeend', '<p>No results found</p>');
    hideOtherContent(mainContent, mainSearchResults);
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();
    document.querySelectorAll('[id^="search-input-"]').forEach(setupSearchInput);
});
