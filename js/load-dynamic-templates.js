
/*This file loads dynamic templates used for the building the website*/

//This function loads a template from a given URL and inserts it into an element with the specified ID
function loadTemplate(url, elementId) {
  fetch(url)
    .then(response => {
      if (!response.ok) throw new Error(`Failed to load ${url}`);
      return response.text();
    })
    .then(data => {
      const element = document.getElementById(elementId);
      if (element) {
        element.innerHTML = data;
      } else {
        console.warn(`Element with ID "${elementId}" not found.`);
      }
    })
    .catch(error => console.error('Error loading template:', error));
}

// Load templates when the DOM is fully loaded
document.addEventListener("DOMContentLoaded", () => {
loadTemplate('/dynamic-templates/app-menu.html', 'appMenu');
loadTemplate('/dynamic-templates/footer-menu', 'footerMenu');
loadTemplate('/dynamic-templates/error.html', 'error');
loadTemplate('/dynamic-templates/footer.html', 'footer');
loadTemplate('/dynamic-templates/top-menu.html', 'topMenu');
loadTemplate('/dynamic-templates/head.html', 'head');
});