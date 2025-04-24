// Global variables for search
let idx;
let documents = [];
let originalTemplateId = null;

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
        const text = doc.description || '';

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

function createTagSpans(tagList, parentTags) {
    const parentStyle = parentTags.getAttribute('style');
    const parentClasses = parentTags.getAttribute('class');
    return tagList.map(tag =>
        `<span class="tag ${parentClasses}" style="${parentStyle}">${tag}</span>`
    ).join('');
}

function setupTagsContainer(tags, tagSpans) {
    tags.removeAttribute('style');
    tags.className = '';
    tags.style.display = 'unset';
    tags.innerHTML = `<div class="d-flex gap-2">${tagSpans}</div>`;
}

function updateTags(wrapperLink, doc) {
    const tags = wrapperLink.querySelector('.result-tags');
    if (!tags) {
        return;
    }
    
    if (!doc.tags?.trim()) {
        tags.style.display = 'none';
        return;
    }

    const tagList = doc.tags.split(',');
    const tagSpans = createTagSpans(tagList, tags);
    setupTagsContainer(tags, tagSpans);
}

// Form Event Handlers
function setupInputAndClearHandlers(input, clearButton) {
    input.addEventListener('input', function() {
        const hasText = this.value.trim();
        clearButton.style.visibility = hasText ? 'visible' : 'hidden';
        clearButton.style.display = hasText ? 'unset' : 'none';
    });

    clearButton.addEventListener('click', function() {
        input.value = '';
        clearButton.style.visibility = 'hidden';
        clearButton.style.display = 'none';
        const mainContent = getMainContent();
        const mainSearchResults = mainContent.querySelector('.main-search-results');
        if (mainSearchResults) {
            mainSearchResults.innerHTML = '';
        }
        showAllContent(mainContent);
    });
}

function setupSearchHandlers(input, clearButton, searchButton, onSearch) {
    input.closest('form').addEventListener('submit', function(e) {
        e.preventDefault();
        const query = input.value;
        const form = input.closest('form');

        // Only clear the input if it's not the results form
        if (!form.classList.contains('results-search-form')) {
            input.value = '';
            input.blur();
        }

        clearButton.style.visibility = 'hidden';
        clearButton.style.display = 'none';
        onSearch(query);
    });

    if (searchButton) {
        searchButton.onclick = function() {
            const query = input.value;
            const form = input.closest('form');

            // Only clear the input if it's not the results form
            if (!form.classList.contains('results-search-form')) {
                input.value = '';
                input.blur();
            }

            clearButton.style.visibility = 'hidden';
            clearButton.style.display = 'none';
            onSearch(query);
        };
    }
}

function setupSearchFormEventHandlers(input, clearButton, searchButton, onSearch) {
    setupInputAndClearHandlers(input, clearButton);
    setupSearchHandlers(input, clearButton, searchButton, onSearch);
}

// Results Form Management
function setupResultsForm(context) {
    const { mainSearchResults, query } = context;
    const resultsForm = mainSearchResults.querySelector('.results-search-form');

    const resultsInput = resultsForm.querySelector('[id^="search-input-"]');
    const resultsSearchButton = resultsForm.querySelector('button[type="submit"]');
    const resultsClearButton = resultsForm.querySelector('.bi-x-circle-fill').closest('button');

    setupSearchFormEventHandlers(resultsInput, resultsClearButton, resultsSearchButton, performSearch);

    resultsInput.value = query;
    resultsClearButton.style.visibility = query.trim() ? 'visible' : 'hidden';

    return resultsForm;
}

// Search Input Setup
function setupSearchInput(searchInput) {
    const clearButton = searchInput.parentElement.querySelector('.bi-x-circle-fill').closest('button');
    const searchButton = searchInput.closest('form').querySelector('button[type="submit"]');

    clearButton.style.visibility = 'hidden';
    clearButton.style.display = 'none';
    setupSearchFormEventHandlers(searchInput, clearButton, searchButton, performSearch);
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

function setupSearchResultsHeaderAndForm(context) {
    const { mainSearchResults, templateContent, query, mainContent } = context;

    const header = templateContent.querySelector('.search-results-header');
    if (header) {
        const clonedHeader = header.cloneNode(true);
        mainSearchResults.insertBefore(clonedHeader, mainSearchResults.firstChild);
    }

    const resultsForm = templateContent.querySelector('.results-search-form');
    if (resultsForm) {
        const clonedResultsForm = resultsForm.cloneNode(true);
        mainSearchResults.appendChild(clonedResultsForm);
        const resultsInput = clonedResultsForm.querySelector('[id^="search-input-"]');

        if (resultsInput) {
            resultsInput.value = query;

            const resultsClearButton = resultsInput.parentElement
                .querySelector('.bi-x-circle-fill')
                .closest('button');

            const hasText = query.trim();
            resultsClearButton.style.visibility = hasText ? 'visible' : 'hidden';
            resultsClearButton.style.display = hasText ? 'unset' : 'none';

            const resultsSearchButton = clonedResultsForm
                .querySelector('button[type="submit"]');

            setupSearchFormEventHandlers(
                resultsInput,
                resultsClearButton,
                resultsSearchButton,
                performSearch
            );
        }
    }
}

// Main Search Function
function performSearch(query) {
    if (!window.searchIndex || !query || !query.trim()) {
        return;
    }

    const activeForm = event.target.closest('form');

    // Store the template ID of the form that initiated search
    if (!activeForm.classList.contains('results-search-form')) {
        originalTemplateId = activeForm.nextElementSibling.id;
    }

    let template;
    if (activeForm.classList.contains('results-search-form')) {
        // If this is the results form, use the original form's template
        template = document.getElementById(originalTemplateId);
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

function displaySearchResults(context) {
    const { results, mainSearchForm, mainContent, mainSearchResults, templateContent, query } = context;
    mainSearchResults.innerHTML = '';

    setupSearchResultsHeaderAndForm(context);
    hideOtherContent(mainContent, mainSearchResults);

    results.forEach(result => {
        const doc = window.searchDocuments.find(doc => doc.id === result.ref);
        const resultItem = createResultItem(doc, templateContent, query);
        mainSearchResults.appendChild(resultItem);
    });
}

function handleNoResults(context) {
    const { mainSearchResults, mainContent, templateContent } = context;
    mainSearchResults.innerHTML = '';
    setupSearchResultsHeaderAndForm(context);

    const noResultsView = templateContent.querySelector('.no-results-view');
    if (noResultsView) {
        const clonedNoResultsView = noResultsView.cloneNode(true);
        mainSearchResults.appendChild(clonedNoResultsView);
    } else {
        mainSearchResults.insertAdjacentHTML('beforeend', '<p>No results found</p>');
    }

    hideOtherContent(mainContent, mainSearchResults);
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();
    document.querySelectorAll('[id^="search-input-"]').forEach(setupSearchInput);
});
