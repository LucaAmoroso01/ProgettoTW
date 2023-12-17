/**
 * Function to load footer
 */
export function loadFooter() {
  fetch("/footer")
    .then((response) => response.text())
    .then((html) => {
      const footer = document.getElementById("footer");

      if (footer) {
        document.getElementById("footer").innerHTML = html;
      }
    })
    .catch((error) => console.error("Error loading page content:", error));
}
