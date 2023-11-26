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

      if (containerId === "registrationContainer") {
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

        const registrationButton = document.getElementById("submit-button");
        registrationButton.addEventListener("click", () =>
          handleRegistration()
        );
      }
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

function handleRegistration() {
  const registrationForm = document.getElementById("registration-form");

  registrationForm.addEventListener("submit", function (e) {
    e.preventDefault();

    const formData = {
      title: document.getElementById("title").value,
      firstName: document.getElementById("firstName").value,
      lastName: document.getElementById("lastName").value,
      country: document.getElementById("country").value,
      birthDate: document.getElementById("birthDate").value,
      username: document.getElementById("username").value,
      email: document.getElementById("email").value,
      password: document.getElementById("password").value,
      confirmPassword: document.getElementById("confirmPassword").value,
    };

    fetch("/auth/registration", {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: JSON.stringify(formData),
    })
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Registration failed");
        }

        if (response.status === 201) {
          window.location.href = "/";
        }

        console.log(response.status);

        if (response.status === 409) {
          alert("User already exists");
        }
      })
      .catch(function (error) {
        // Handle error response
        console.error("Registration failed: ", error);
      });
  });
}
