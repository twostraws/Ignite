// Global variables for search
let idx;
let documents = [];

// Function to update all search fields and their clear buttons
function updateAllSearchFields(value) {
    document.querySelectorAll('[id^="search-input-"]').forEach(input => {
        input.value = value;
        const clearButton = input.parentElement.querySelector('.bi-x-circle-fill').closest('button');
        clearButton.style.visibility = value.trim() ? 'visible' : 'hidden';
    });
}

// Function to load the search index
function loadSearchIndex() {
    return fetch('/search-index.json')
    .then(response => response.json())
    .then(data => {
        window.searchDocuments = data;
        // Create the Lunr index
        window.searchIndex = lunr(function () {
            this.ref('id');
            this.field('title');
            this.field('description');
            this.field('body');
            this.field('tags');

            window.searchDocuments.forEach(function (doc) {
                this.add(doc);
            }, this);
        });
    });
}

// Load the index when the page loads
document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();
});

function performSearch(query) {
    if (!window.searchIndex) {
        console.error('Search index not loaded yet');
        return;
    }

    // Get the template and its content
    const template = document.getElementById('search-results');
    const templateContent = template.content;

    // Get the main content area using class
    const mainContent = document.querySelector('.ig-main-content');

    // Get or create the search results container in main content
    let mainSearchResults = mainContent.querySelector('.main-search-results');
    if (!mainSearchResults) {
        mainSearchResults = document.createElement('div');
        mainSearchResults.className = 'main-search-results';
        mainContent.insertBefore(mainSearchResults, mainContent.firstChild);
    }

    // Find the search form in the main content area
    const mainSearchForm = mainContent.querySelector('form');

    // Add check for empty query
    if (!query || query.trim() === '') {
        return; // Just return without doing anything
    }

    const results = window.searchIndex.search(query);

    if (results.length === 0) {
        // Clone the search form if it's in main content
        if (mainSearchForm) {
            const clonedForm = mainSearchForm.cloneNode(true);
            clonedForm.classList.add('my-3');
            mainSearchResults.innerHTML = '';
            mainSearchResults.appendChild(clonedForm);
            mainSearchResults.insertAdjacentHTML('beforeend', '<p>No results found</p>');

            // Set up event handlers for the cloned form
            const clonedInput = clonedForm.querySelector('[id^="search-input-"]');
            const clonedClearButton = clonedForm.querySelector('.bi-x-circle-fill').closest('button');
            const clonedSearchButton = clonedForm.querySelector('button[type="submit"]');

            // Input handler
            clonedInput.addEventListener('input', function() {
                updateAllSearchFields(this.value);
            });

            // Clear button handler
            clonedClearButton.addEventListener('click', function() {
                updateAllSearchFields('');
                Array.from(mainContent.children).forEach(child => {
                    child.style.display = '';
                });
                mainSearchResults.innerHTML = '';
            });

            // Search button handler
            clonedSearchButton.onclick = function() {
                performSearch(clonedInput.value);
            };

            updateAllSearchFields(query);
        } else {
            mainSearchResults.innerHTML = '<p>No results found</p>';
        }

        // Hide other content
        Array.from(mainContent.children).forEach(child => {
            if (child !== mainSearchResults) {
                child.style.display = 'none';
            }
        });
        return;
    }

    // Clear and prepare search results
    mainSearchResults.innerHTML = '';

    // Clone the search form if it's in main content and add it to results
    if (mainSearchForm) {
        const clonedForm = mainSearchForm.cloneNode(true);
        clonedForm.classList.add('my-3');
        mainSearchResults.appendChild(clonedForm);
        updateAllSearchFields(query);
    }

    // Hide other content
    Array.from(mainContent.children).forEach(child => {
        if (child !== mainSearchResults) {
            child.style.display = 'none';
        }
    });

    results.forEach(result => {
        const doc = window.searchDocuments.find(doc => doc.id === result.ref);
        const clone = templateContent.cloneNode(true);
        const resultItem = clone.querySelector('.search-results-item');

        // Create a wrapper link for the entire item
        const wrapperLink = document.createElement('a');
        wrapperLink.href = doc.id;
        wrapperLink.className = 'link-plain text-reset';

        // Move all the content into the link
        while (resultItem.firstChild) {
            wrapperLink.appendChild(resultItem.firstChild);
        }

        // Clear the result item and add the wrapper link
        resultItem.innerHTML = '';
        resultItem.appendChild(wrapperLink);

        // Update the content inside the wrapper
        const title = wrapperLink.querySelector('.result-title');
        if (title) {
            title.textContent = doc.title;
        }

        const description = wrapperLink.querySelector('.result-description');
        if (description) {
            description.textContent = (doc.description || '') + '...';
        }

        const date = wrapperLink.querySelector('.result-date');
        if (date && doc.date) {
            date.textContent = doc.date;
        }

        const tags = wrapperLink.querySelector('.result-tags');
        if (tags) {
            if (doc.tags && doc.tags.trim()) {  // Check if tags exist and aren't just whitespace
                tags.innerHTML = doc.tags.split(' ').map(tag =>
                    `<span class="tag">${tag}</span>`
                ).join('');
                tags.style.display = 'block';  // Show if there are tags
            } else {
                tags.style.display = 'none';  // Hide if no tags
            }
        }

        mainSearchResults.appendChild(resultItem);
    });

    // Set up event handlers for the cloned form
    if (mainSearchForm) {
        const clonedForm = mainSearchResults.querySelector('form');
        const clonedInput = clonedForm.querySelector('[id^="search-input-"]');
        const clonedSearchButton = clonedForm.querySelector('button[type="submit"]');
        const clonedClearButton = clonedForm.querySelector('.bi-x-circle-fill').closest('button');

        // Input handler will be handled by updateAllSearchFields
        clonedInput.addEventListener('input', function() {
            updateAllSearchFields(this.value);
        });

        // Clear button handler
        clonedClearButton.addEventListener('click', function() {
            updateAllSearchFields(''); // This will clear all search fields including nav bar

            // Show original content
            Array.from(mainContent.children).forEach(child => {
                child.style.display = '';
            });
            mainSearchResults.innerHTML = '';
        });

        clonedSearchButton.onclick = function() {
            performSearch(clonedInput.value);
        };
    }
}

document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();

    // Handle all search inputs that start with "search-input-"
    document.querySelectorAll('[id^="search-input-"]').forEach((searchInput) => {
        const clearButton = searchInput.parentElement.querySelector('.bi-x-circle-fill').closest('button');
        const searchButton = searchInput.closest('form').querySelector('button[type="submit"]');

        // Initially hide the clear button
        clearButton.style.visibility = 'hidden';

        // Show/hide clear button based on input content
        searchInput.addEventListener('input', function() {
            updateAllSearchFields(this.value);
        });

        // Clear button click handler
        clearButton.addEventListener('click', function() {
            updateAllSearchFields('');

            // Clear search results and show main content
            const mainContent = document.querySelector('.ig-main-content');
            const mainSearchResults = mainContent.querySelector('.main-search-results');
            if (mainSearchResults) {
                mainSearchResults.innerHTML = '';
            }
            // Show all content again
            Array.from(mainContent.children).forEach(child => {
                child.style.display = '';
            });
        });

        // Add search button click handler
        searchButton.onclick = function() {
            performSearch(searchInput.value);
        };

        // Keep existing blur handler
        searchInput.addEventListener('blur', function() {
            if (!this.value.trim()) {
                const mainContent = document.querySelector('.ig-main-content');
                const mainSearchResults = mainContent.querySelector('.main-search-results');
                if (mainSearchResults) {
                    mainSearchResults.innerHTML = '';
                }
                // Show all content again
                Array.from(mainContent.children).forEach(child => {
                    child.style.display = '';
                });
            }
        });
    });
});
