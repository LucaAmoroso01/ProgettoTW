/**
 * Function to load a page
 * @param {string} pageUrl page to load
 * @param {string} containerId container to put the page
 */
function loadNavbar(pageUrl, containerId) {
  fetch(pageUrl)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById(containerId).innerHTML = html;

      if (containerId === "registrationContainer") {
        loadSelectWithCountries();

        handleCheckPassword();

        const registrationButton = document.getElementById(
          "registration-button"
        );

        if (registrationButton) {
          registrationButton.addEventListener("click", handleRegistration);
        }
      }

      if (containerId === "loginContainer") {
        const loginButton = document.getElementById("login-button");

        if (loginButton) {
          loginButton.addEventListener("click", handleLogin);
        }
      }
    })
    .catch((error) => console.error("Error loading page content:", error));
}

/**
 * Function to do login
 * If login goes well, there'll be a redirect to home page
 */
function handleLogin() {
  const loginForm = document.getElementById("login-form");

  const submitHandler = function (e) {
    e.preventDefault();

    /**
     * @typedef {Object} LoginForm
     * @property {string} email The email to submit
     * @property {string} password The password to submit
     */

    /**
     * @type {LoginForm}
     */
    const formData = {
      email: document.getElementById("email").value,
      password: document.getElementById("password").value,
    };

    fetch("/auth/login", {
      method: "POST",
      body: JSON.stringify(formData),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Login failed");
        }

        return response.json();
      })
      .then(
        /**
         * @typedef {Object} LoginResponse
         * @property {string} message The message returned by server
         * @property {string} status The response status
         */

        /**
         * Function called after response get
         * @param {LoginResponse} data The data contained into response
         */
        (data) => {
          if (data.status === 200) {
            window.location.href = "/";
          }

          if (data.status === 401) {
            alert(data.message);
          }

          if (data.status === 404) {
            alert(data.message);
          }

          loginForm.removeEventListener("submit", submitHandler);
        }
      )
      .catch(function (error) {
        alert("Login failed: ", error);
      });
  };

  loginForm.addEventListener("submit", submitHandler);
}

/**
 * Function to load select with all countries
 */
function loadSelectWithCountries() {
  const select = document.getElementById("country");
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
}

/**
 * Function to do registration
 * If registration goes well, there'll be a redirect to home page
 */
function handleRegistration() {
  const registrationForm = document.getElementById("registration-form");

  const submitHandler = function (e) {
    e.preventDefault();

    /**
     * @typedef {Object} RegistrationForm
     * @property {string} title The title of the user who wants to register (possible values: 'Mr', 'Mrs', 'Ms', 'Miss')
     * @property {string} firstName The firstName of the user who wants to register
     * @property {string} lastName The last name of the user who wants to register
     * @property {string} country The country of the user who wants to register
     * @property {date} birthDate The birth date of the user who wants to register
     * @property {string} username The username of the user who wants to register
     * @property {string} email The email address of the user who wants to register
     * @property {string} password The password of the user who wants to register
     */

    /**
     * @type {RegistrationForm}
     */
    const formData = {
      title: document.getElementById("title").value,
      firstName: document.getElementById("firstName").value,
      lastName: document.getElementById("lastName").value,
      country: document.getElementById("country").value,
      birthDate: document.getElementById("birthDate").value,
      username: document.getElementById("username").value,
      email: document.getElementById("email").value,
      password: document.getElementById("password").value,
    };

    fetch("/auth/registration", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formData),
    })
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Registration failed");
        }

        return response.json();
      })
      .then((data) => {
        if (data.status === 409) {
          alert(data.message);
        }

        if (data.status === 201) {
          window.location.href = "/";
        }

        registrationForm.removeEventListener("submit", submitHandler);
      })
      .catch(function (error) {
        console.error("Registration failed: ", error);
      });
  };

  registrationForm.addEventListener("submit", submitHandler);
}

/**
 * Function to check if password and confirm password are the same
 */
function handleCheckPassword() {
  const passwordInput = document.getElementById("password");
  const confirmPasswordInput = document.getElementById("confirmPassword");
  const registrationForm = document.getElementById("registration-form");
  const passwordError = document.getElementById("password-error");
  const registrationButton = document.getElementById("registration-button");

  passwordInput.addEventListener("input", handlePasswordInput);
  confirmPasswordInput.addEventListener("input", handlePasswordInput);

  /**
   * Function to show password doesn't match error
   */
  function handlePasswordInput() {
    const passwordValue = passwordInput.value;
    const confirmPasswordValue = confirmPasswordInput.value;

    if (passwordValue !== "" && confirmPasswordValue !== "") {
      if (passwordValue === confirmPasswordValue) {
        passwordError.textContent = "";
        registrationForm.classList.remove("password-mismatch");
        registrationButton.disabled = false;
      } else {
        passwordError.textContent = "The passwords doesn't match";
        registrationForm.classList.add("password-mismatch");
        registrationButton.disabled = true;
      }
    } else {
      passwordError.textContent = "";
      registrationForm.classList.remove("password-mismatch");
    }
  }
}
