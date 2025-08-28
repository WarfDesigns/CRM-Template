// Map of pages to their titles
const pageTitles = {
  "/index.html": "Home - CRM Template",
  "/pages/site-map.html": "Site Map",
  "/pages/accessibility-policy.html": "Accessibility Policy",
  "/pages/privacy-policy.html": "Privacy Policy",
  "/pages/dashboard/index.html": "Dashboard",
  "/pages/dashboard/analytics/index.html": "Analytics",
};

// Function to set the title dynamically
function setPageTitle() {
  const page = window.location.pathname.split("/").pop();
  const title = pageTitles[page] || "My Website";
  document.title = title;
}

document.addEventListener("DOMContentLoaded", setPageTitle);