// Global variables for search
let idx;
let documents = [];

// Function to load the search index
function loadSearchIndex() {
    return fetch('/search-index.json')
        .then(response => response.json())
        .then(data => {
            documents = data;
            // Create the Lunr index
            idx = lunr(function () {
                this.ref('id');
                this.field('title');
                this.field('description');
                this.field('body');
                this.field('tags');

                documents.forEach(function (doc) {
                    this.add(doc);
                }, this);
            });
        });
}

// Load the index when the page loads
document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();
});

// Global variables for search
window.searchIndex = null;
window.searchDocuments = [];

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

    // Get the template from the nav
    const searchTemplate = document.getElementById('search-results').querySelector('.search-result-item');

    // Get the main content area using class
    const mainContent = document.querySelector('.ig-main-content');

    // Get or create the search results container in main content
    let mainSearchResults = mainContent.querySelector('.main-search-results');
    if (!mainSearchResults) {
        mainSearchResults = document.createElement('div');
        mainSearchResults.className = 'main-search-results';
        mainContent.insertBefore(mainSearchResults, mainContent.firstChild);
    }

    // Add check for empty query
    if (!query || query.trim() === '') {
        mainSearchResults.innerHTML = '<p>Please enter a search term</p>';
        Array.from(mainContent.children).forEach(child => {
            if (child !== mainSearchResults) child.style.display = '';
        });
        return;
    }

    const results = window.searchIndex.search(query);

    if (results.length === 0) {
        mainSearchResults.innerHTML = '<p>No results found</p>';
        // Hide other content
        Array.from(mainContent.children).forEach(child => {
            if (child !== mainSearchResults) child.style.display = 'none';
        });
        return;
    }

    // Clear and prepare search results
    mainSearchResults.innerHTML = '';

    // Hide other content
    Array.from(mainContent.children).forEach(child => {
        if (child !== mainSearchResults) child.style.display = 'none';
    });

    results.forEach(result => {
        const doc = window.searchDocuments.find(doc => doc.id === result.ref);
        const clone = searchTemplate.cloneNode(true);

        // Make the clone visible and add styling
        clone.style.display = 'block';
        clone.style.marginBottom = '1.5rem';

        // Create a wrapper link for the entire item
        const wrapperLink = document.createElement('a');
        wrapperLink.href = doc.id;
        wrapperLink.className = 'link-plain text-reset';

        // Move all the content into the link
        while (clone.firstChild) {
            wrapperLink.appendChild(clone.firstChild);
        }

        // Clear the clone and add the wrapper link
        clone.innerHTML = '';
        clone.appendChild(wrapperLink);

        // Update the content inside the wrapper
        const title = wrapperLink.querySelector('.result-title');
        if (title) {
            title.textContent = doc.title;
            title.style.marginBottom = '0.5rem';
        }

        const description = wrapperLink.querySelector('.result-description');
        if (description) {
            description.textContent = (doc.description || '') + '...';
            description.style.marginBottom = '0.5rem';
        }

        const tags = wrapperLink.querySelector('.result-tags');
        if (tags && doc.tags) {
            tags.innerHTML = doc.tags.split(' ').map(tag =>
                `<span class="tag">${tag}</span>`
            ).join('');
        }

        mainSearchResults.appendChild(clone);
    });
}

document.addEventListener('DOMContentLoaded', function() {
    loadSearchIndex();

    const searchInput = document.getElementById('search-input');
    const clearButton = document.querySelector('.bi-x-circle-fill').closest('button');

    // Initially hide the clear button
    clearButton.style.visibility = 'hidden'; // Changed from display to visibility

    // Show/hide clear button based on input content
    searchInput.addEventListener('input', function() {
        clearButton.style.visibility = this.value.trim() ? 'visible' : 'hidden';
    });

    // Clear button click handler
    clearButton.addEventListener('click', function() {
        searchInput.value = '';
        clearButton.style.visibility = 'hidden';

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
