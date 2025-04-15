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

    const results = window.searchIndex.search(query);
    const resultsContainer = document.getElementById('search-results');
    const template = resultsContainer.querySelector('.search-result-item');

    // Clear existing results but keep the template
    resultsContainer.innerHTML = '';
    if (template) {
        resultsContainer.appendChild(template);
    }

    if (results.length === 0) {
        resultsContainer.innerHTML = '<p>No results found</p>';
        return;
    }

    results.forEach(result => {
        const doc = window.searchDocuments.find(doc => doc.id === result.ref);
        const clone = template.cloneNode(true);

        // Update the title - try different approaches
        const title = clone.querySelector('.result-title');
        if (title) {
            // Try setting innerHTML with the link
            title.innerHTML = `<a href="${doc.id}">${doc.title}</a>`;
            console.log('Title updated:', doc.title); // Debug log
        }

        // Update the description
        const description = clone.querySelector('.result-description');
        if (description) {
            description.textContent = doc.description || '';
        }

        // Update the tags
        const tags = clone.querySelector('.result-tags');
        if (tags && doc.tags) {
            tags.innerHTML = doc.tags.split(' ').map(tag =>
                `<span class="tag">${tag}</span>`
            ).join('');
        }

        resultsContainer.appendChild(clone);
    });
}

// Handle search form submission
document.getElementById('search-form').addEventListener('submit', function(e) {
    e.preventDefault();
    const query = document.getElementById('search-input').value;
    performSearch(query);
});
