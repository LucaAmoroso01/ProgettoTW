/**
 * function to load a page
 * @param pageUrl page to load
 * @param containerId container to put the page
 */
function loadPageContent(pageUrl, containerId) {
  fetch(pageUrl)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById(containerId).innerHTML = html;

      const select = document.getElementById("country");
      /**
       * Load select with all countries
       */
      fetch("https://restcountries.com/v3.1/all")
        .then((response) => response.json())
        .then((countries) => {
          countries
            .sort((a, b) => a.name.common.localeCompare(b.name.common))
            .forEach((country) => {
              const option = document.createElement("option");
              option.value = country.name.common.toLowerCase();
              option.text = country.name.common;
              select.add(option);
            });
        })
        .catch((error) => console.error("Error fetching countries:", error));
    })
    .catch((error) => console.error("Error loading page content:", error));
}

/**
 * submit form handler
 */
function handleLoginFormSubmit() {
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;

  /**
   * use setTimeout to show email e password into the alert
   */
  setTimeout(function () {
    alert("email: " + email + "\npassword: " + password);
  }, 0);
}

/**
 * register form handler
 */
function handleRegisterFormSubmit() {
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;

  setTimeout(function () {
    alert("email: " + email + "\npassword: " + password);
  }, 0);
}
