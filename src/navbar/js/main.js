const root = "/";

/**
 * @typedef {Object} Driver
 * @property {string} firstName The driver first name
 * @property {string} lastName The driver last name
 * @property {string} team The driver team
 */

/**
 * @type {Driver[]}
 */
const drivers = [
  { firstName: "Charles", lastName: "Leclerc", team: "ferrari" },
  { firstName: "Carlos", lastName: "Sainz", team: "ferrari" },
  { firstName: "Lewis", lastName: "Hamilton", team: "mercedes" },
  { firstName: "Valtteri", lastName: "Bottas", team: "alfa-romeo" },
  { firstName: "Max", lastName: "Verstappen", team: "red-bull" },
  { firstName: "Sergio", lastName: "Perez", team: "red-bull" },
  { firstName: "Lando", lastName: "Norris", team: "mclaren" },
  { firstName: "Oscar", lastName: "Piastri", team: "mclaren" },
  { firstName: "Daniel", lastName: "Ricciardo", team: "alphaTauri" },
  { firstName: "Pierre", lastName: "Gasly", team: "alpine" },
  { firstName: "Esteban", lastName: "Ocon", team: "alpine" },
  { firstName: "Lance", lastName: "Stroll", team: "aston-martin" },
  { firstName: "Fernando", lastName: "Alonso", team: "aston-martin" },
  { firstName: "George", lastName: "Russell", team: "mercedes" },
  { firstName: "Yuki", lastName: "Tsunoda", team: "alphaTauri" },
  { firstName: "Guanyu", lastName: "Zhou", team: "alfa-romeo" },
  { firstName: "Alexander", lastName: "Albon", team: "williams" },
  { firstName: "Kevin", lastName: "Magnussen", team: "haas" },
  { firstName: "Nico", lastName: "Hulkenberg", team: "haas" },
  { firstName: "Logan", lastName: "Sargeant", team: "williams" },
].sort((a, b) => a.lastName.localeCompare(b.lastName));

/**
 * teams array sorted alphabetically
 */
const teamsArray = drivers
  .map((driver) => driver.team)
  .sort((a, b) => a.localeCompare(b));

/**
 * Function to load navbar
 */
export function loadNavbar() {
  fetch("/navbar")
    .then((response) => response.text())
    .then(async (html) => {
      document.getElementById("navbar").innerHTML = html;

      handleNavbarClass();

      loadTeamsAndDrivers();

      window.addEventListener("resize", handleNavbarClass);

      toggleResponsiveNavbar();

      loadTeamsAndDriversResponsive(drivers, teamsArray);

      const loginButton = document.createElement("button");
      loginButton.classList.add("btn", "btn-primary", "btn-login-subscribe");
      loginButton.style.backgroundColor = "black";
      loginButton.style.borderColor = "black";
      loginButton.innerHTML = `<div
        style="
          display: flex;
          align-items: center;
          justify-items: center;
          gap: 10px;
        "
      >
        <i class="fa-regular fa-user"></i>
        login
      </div>`;
      loginButton.addEventListener("click", () => {
        openLoginOrRegistration(`/auth/login-registration?param=login`);
      });

      const registrationButton = document.createElement("button");
      registrationButton.classList.add(
        "btn",
        "btn-primary",
        "btn-login-subscribe"
      );
      registrationButton.style.backgroundColor = "black";
      registrationButton.style.borderColor = "black";
      registrationButton.innerHTML = `registration`;
      registrationButton.addEventListener("click", () =>
        openLoginOrRegistration(`/auth/login-registration?param=registration`)
      );

      const loginButtonResponsive = document.getElementById(
        "login-button-responsive"
      );
      loginButtonResponsive.addEventListener("click", () =>
        openLoginOrRegistration(`/auth/login-registration?param=login`)
      );

      const registrationButtonResponsive = document.getElementById(
        "registration-button-responsive"
      );
      registrationButtonResponsive.addEventListener("click", () =>
        openLoginOrRegistration(`/auth/login-registration?param=registration`)
      );

      const loginButtonsContainer = document.querySelector(".login-buttons");
      loginButtonsContainer.appendChild(loginButton);
      loginButtonsContainer.appendChild(registrationButton);

      const driversDropdownContainer = document.getElementById(
        "drivers-dropdown-container"
      );
      const teamsDropdownContainer = document.getElementById(
        "teams-dropdown-container"
      );
      const standingsDropdownContainer = document.getElementById(
        "standings-dropdown-container"
      );

      if (window.location.pathname !== root) {
        const navbarContainer = document.getElementById("navbar-links");

        const homeListContainer = document.createElement("li");

        homeListContainer.classList.add("nav-item", "dropdown");

        const homeButton = document.createElement("button");

        homeButton.classList.add("nav-link");

        homeButton.innerText = "Home";

        homeButton.addEventListener("click", () => {
          window.location.href = `/`;
        });

        homeListContainer.appendChild(homeButton);

        navbarContainer.insertBefore(
          homeListContainer,
          navbarContainer.firstChild
        );

        driversDropdownContainer.style.cssText = "left: -11em !important;";
        teamsDropdownContainer.style.cssText = "left: -23.5rem !important;";
        standingsDropdownContainer.style.cssText = "left: -46rem !important;";
      } else {
        driversDropdownContainer.style.cssText = "left: -2.8rem !important";
      }

      const scheduleButton = document.getElementById("schedule");
      const scheduleResponsiveButton = document.getElementById(
        "schedule-responsive"
      );
      handleStyleScheduleButton(scheduleButton);
      handleStyleScheduleResponsiveButton(scheduleResponsiveButton);

      const userCard = document.getElementById("user-card");
      userCard.style.display = "none";

      const userButton = document.getElementById("user-button");
      userButton.style.display = "none";

      const userCardResponsive = document.getElementById(
        "user-card-responsive"
      );
      userCardResponsive.style.display = "none";

      const userButtonResponsive = document.getElementById(
        "user-button-responsive"
      );
      userButtonResponsive.style.display = "none";

      fetch("/auth/user")
        .then((response) => {
          if (response.ok) {
            return response.json();
          } else {
            throw Error("Error getting user");
          }
        })
        .then(
          /**
           * @param {UserResponse} data The data response returned by server
           */
          (data) => {
            if (data.status !== 401) {
              const user = data.user;

              const dividerResponsive = document.getElementById(
                "dropdown-divider-responsive"
              );

              loginButton.style.display = "none";
              registrationButton.style.display = "none";

              loginButtonResponsive.remove();
              registrationButtonResponsive.remove();
              dividerResponsive.remove();

              document.getElementById(
                "login-buttons-responsive"
              ).style.cssText = "padding-bottom: 0 !important";

              userButton.style.cssText =
                "display: flex !important; border-radius: 100% !important;";

              userButtonResponsive.style.cssText =
                "display: flex !important; border-radius: 100% !important";

              userButton.addEventListener("click", () =>
                toggleUserCard(user, userButton, userCard)
              );

              userButtonResponsive.addEventListener("click", () => {
                toggleUserCard(user, userButtonResponsive, userCardResponsive);
              });

              const logoutButton = document.getElementById("logout-button");
              logoutButton.addEventListener("click", logout);

              const logoutButtonResponsive = document.getElementById(
                "logout-button-responsive"
              );
              logoutButtonResponsive.addEventListener("click", logout);
            }
          }
        );

      const homeResponsiveButton = document.getElementById("home-responsive");

      if (window.location.pathname === "/") {
        homeResponsiveButton.remove();
      }
    })
    .catch((error) => console.error("Error loading page content:", error));
}

/**
 * Function to open login/registration page
 * @param {string} path The page path
 */
function openLoginOrRegistration(path) {
  window.location.href = path;
}

/**
 * Function to open a driver page
 * @param {string} driverToOpen The driver page to open
 */
function openDriver(driverToOpen) {
  window.location.href = `/drivers/${driverToOpen}`;
}

/**
 * Function to open a team page
 * @param {string} teamToOpen The team page to open
 */
function openTeam(teamToOpen) {
  window.location.href = `/teams/${teamToOpen}`;
}

/**
 * Function to open the schedule page
 */
function openSchedule() {
  window.location.href = `/schedule`;
}

/**
 * Function to load teams and drivers into navbar dropdowns
 */
function loadTeamsAndDrivers() {
  /**
   * @type {Driver[]}
   */
  const drivers = [
    { firstName: "Charles", lastName: "Leclerc", team: "ferrari" },
    { firstName: "Carlos", lastName: "Sainz", team: "ferrari" },
    { firstName: "Lewis", lastName: "Hamilton", team: "mercedes" },
    { firstName: "Valtteri", lastName: "Bottas", team: "alfa-romeo" },
    { firstName: "Max", lastName: "Verstappen", team: "red-bull" },
    { firstName: "Sergio", lastName: "Perez", team: "red-bull" },
    { firstName: "Lando", lastName: "Norris", team: "mclaren" },
    { firstName: "Oscar", lastName: "Piastri", team: "mclaren" },
    { firstName: "Daniel", lastName: "Ricciardo", team: "alphaTauri" },
    { firstName: "Pierre", lastName: "Gasly", team: "alpine" },
    { firstName: "Esteban", lastName: "Ocon", team: "alpine" },
    { firstName: "Lance", lastName: "Stroll", team: "aston-martin" },
    { firstName: "Fernando", lastName: "Alonso", team: "aston-martin" },
    { firstName: "George", lastName: "Russell", team: "mercedes" },
    { firstName: "Yuki", lastName: "Tsunoda", team: "alphaTauri" },
    { firstName: "Guanyu", lastName: "Zhou", team: "alfa-romeo" },
    { firstName: "Alexander", lastName: "Albon", team: "williams" },
    { firstName: "Kevin", lastName: "Magnussen", team: "haas" },
    { firstName: "Nico", lastName: "Hulkenberg", team: "haas" },
    { firstName: "Logan", lastName: "Sargeant", team: "williams" },
  ].sort((a, b) => a.lastName.localeCompare(b.lastName));

  /**
   * teams array sorted alphabetically
   */
  const teamsArray = drivers
    .map((driver) => driver.team)
    .sort((a, b) => a.localeCompare(b));

  /**
   * Function to create a driver list item
   * @param {Driver} driver The driver to which create the list item
   * @returns The list item created
   */
  function createDriverListItem(driver) {
    const listItem = document.createElement("button");

    listItem.classList.add(
      "dropdown-item",
      "custom-dropdown-item",
      `dropdown-item-${driver.team}`,
      window.location.href.split("/").pop().replace(".html", "") ===
        driver.lastName.toLowerCase() && `dropdown-item-${driver.team}-active`,
      "btn-driver-name"
    );
    listItem.addEventListener("click", () =>
      openDriver(driver.lastName.toLowerCase())
    );

    const formattedName = `<i class="fa-sharp fa-light fa-rectangle-wide driver-${
      driver.team
    }-color"></i>
                            <div class="driver-name">
                              <p style="font-family: F1 Regular">
                                ${driver.firstName}
                              </p>
                              <p>${driver.lastName.toUpperCase()}</p>
                            </div>`;

    listItem.innerHTML = formattedName;
    return listItem;
  }

  /**
   * Function to create a team list item
   * @param {string} team The team to which create the list item
   * @returns The list item created
   */
  function createTeamListItem(team) {
    const listItem = document.createElement("button");
    listItem.classList.add(
      "dropdown-item",
      "custom-dropdown-item",
      `dropdown-item-${team}`,
      window.location.href.split("/").pop().replace(".html", "") === team &&
        `dropdown-item-${team}-active`
    );
    listItem.addEventListener("click", () => openTeam(team));

    const formattedTeamName = team
      .replace("-", " ")
      .replace(/\b\w/g, (char) => char.toUpperCase());

    const formattedName = `<div class="team-name">
                              <img alt="${team}-logo" src="/src/images/${team}-logo.png" class="teams-logo" style="width: ${
      team === "red-bull"
        ? "10rem"
        : team === "alfa-romeo"
        ? "10rem"
        : team === "mercedes"
        ? "6rem"
        : team === "alphaTauri"
        ? "10rem"
        : team === "haas"
        ? "9rem"
        : "7rem"
    }" />
                              <p style="font-family: F1 Regular; margin-top: 1rem">
                                ${formattedTeamName}
                              </p>
                            </div>`;

    listItem.innerHTML = formattedName;

    return listItem;
  }

  const driverListContainer = document.getElementById("drivers-dropdown");

  drivers.forEach((driver) => {
    const listItem = createDriverListItem(driver);
    driverListContainer.appendChild(listItem);
  });

  const teamsListContainer = document.getElementById("teams");
  const addedTeams = [];

  teamsArray.forEach((team) => {
    if (!addedTeams.includes(team)) {
      const listItemTeam = createTeamListItem(team);
      teamsListContainer.appendChild(listItemTeam);
      addedTeams.push(team);
    }
  });
}

/**
 * Function to load teams and drivers into responsive navbar dropdowns
 * @param {Driver[]} drivers The drivers to load into responsive drivers dropdown
 * @param {string[]} teamsArray The teams to load into responsive teams dropdown
 */
function loadTeamsAndDriversResponsive(drivers, teamsArray) {
  /**
   * Function to create a driver list item
   * @param {Driver} driver The driver to which create the list item
   * @returns The list item created
   */
  function createDriverListItem(driver) {
    const listItem = document.createElement("button");
    listItem.id = driver.lastName.toLowerCase();

    listItem.classList.add("dropdown-item", "dropdown-item-responsive");
    listItem.style.cssText = "padding: 0rem !important";

    listItem.addEventListener("click", () =>
      openDriver(driver.lastName.toLowerCase())
    );

    const formattedName = `
                            <div style="display: flex !important; align-content: center !important; margin-top: 1rem; gap: 10px; padding-inline: 2rem">
                              <i class="fa-sharp fa-light fa-rectangle-wide driver-${
                                driver.team
                              }-color"></i>
                              <div class="driver-name">
                                <p style="font-family: F1 Regular">
                                  ${driver.firstName}
                                </p>
                                <p>${driver.lastName.toUpperCase()}</p>
                              </div>
                            </div>`;

    listItem.innerHTML = formattedName;
    return listItem;
  }

  /**
   * Function to create a team list item
   * @param {string} team The team to which create the list item
   * @returns The list item created
   */
  function createTeamListItem(team) {
    const listItem = document.createElement("button");
    listItem.classList.add("dropdown-item", "dropdown-item-responsive");
    listItem.addEventListener("click", () => openTeam(team));

    const formattedTeamName = team
      .replace("-", " ")
      .replace(/\b\w/g, (char) => char.toUpperCase());

    const formattedName = `
                            <div style="display: flex !important; align-content: center !important; padding-inline: 2rem !important">
                            <div class="d-flex align-items-center" style="gap: 10px">
                                <i class="fa-sharp fa-light fa-rectangle-wide driver-${team}-color" style="margin-top: -3px"></i>
                                <p style="font-family: F1 Regular; margin-top: 1rem">
                                  ${formattedTeamName}
                                </p>
                              </div>
                            </div>`;

    listItem.innerHTML = formattedName;

    return listItem;
  }

  const driverListContainer = document.getElementById(
    "drivers-list-responsive"
  );

  drivers.forEach((driver) => {
    const listItem = createDriverListItem(driver);

    if (
      window.location.href.split("/").pop().replace(".html", "") ===
      driver.lastName.toLowerCase()
    ) {
      listItem.style.cssText = "background-color: red !important";
    }

    driverListContainer.appendChild(listItem);
  });

  const teamsListContainer = document.getElementById("teams-list-responsive");
  const addedTeams = [];

  teamsArray.forEach((team) => {
    if (!addedTeams.includes(team)) {
      const listItemTeam = createTeamListItem(team);

      if (window.location.href.split("/").pop().replace(".html", "") === team) {
        listItemTeam.style.cssText = "background-color: red !important";
      }

      teamsListContainer.appendChild(listItemTeam);
      addedTeams.push(team);
    }
  });
}

/**
 * Function to toggle the user card when user button has clicked
 * @param {User} user The logged-in user
 * @param {HTMLButtonElement} userButton The user button to click to toggle the user card
 * @param {HTMLDivElement} userCard The user card to toggle
 */
function toggleUserCard(user, userButton, userCard) {
  userCard.style.display = userCard.style.display === "none" ? "block" : "none";

  userButton.classList.toggle(
    "user-button-open",
    userCard.style.display === "block"
  );

  userButton.setAttribute("aria-expanded", userCard.style.display === "block");

  const userFirstName = document.getElementById("user-firstName");
  const userLastName = document.getElementById("user-lastName");
  const userEmail = document.getElementById("user-email");

  userFirstName.innerHTML = user.firstName;
  userLastName.innerHTML = user.lastName;
  userEmail.innerHTML = user.email;

  const userFirstNameResponsive = document.getElementById(
    "user-firstName-responsive"
  );
  const userLastNameResponsive = document.getElementById(
    "user-lastName-responsive"
  );
  const userEmailResponsive = document.getElementById("user-email-responsive");

  userFirstNameResponsive.innerHTML = user.firstName;
  userLastNameResponsive.innerHTML = user.lastName;
  userEmailResponsive.innerHTML = user.email;
}

/**
 * @typedef {Object} LogoutResponse
 * @property {string} message The message returned by server
 * @property {string} status The response status
 */

/**
 * Function to do logout
 * If logout goes well, there'll be the redirect to homepage
 */
function logout() {
  fetch("/auth/logout", {
    method: "POST",
  })
    .then((response) => {
      if (!response.ok) {
        throw Error("Error logging out");
      }

      return response.json();
    })
    .then(
      /**
       * Function called after response get
       * @param {LogoutResponse} data The data contained into response
       */
      (data) => {
        if (data.status === 200) {
          window.location.href = "/";
        }
      }
    );
}

/**
 * Function to manage responsive navbar
 */
function handleNavbarClass() {
  const navbar = document.getElementById("navbar");
  const responsiveNavbar = document.getElementById("responsive-navbar");

  if (window.innerWidth <= 1200) {
    responsiveNavbar.style.cssText = "display: flex !important";
  } else {
    responsiveNavbar.style.cssText = "display: none !important";
  }

  if (responsiveNavbar.style.display === "flex") {
    navbar.style.cssText = "padding: 0 !important; margin: 0 !important";

    const driversResponsiveButton = document.getElementById(
      "drivers-responsive-button"
    );

    const teamsResponsiveButton = document.getElementById(
      "teams-responsive-button"
    );

    const standingsResponsiveButton = document.getElementById(
      "standings-responsive-button"
    );

    const submenu = document.getElementById("dropdown-drivers-submenu");

    const teamsSubmenu = document.getElementById("dropdown-teams-submenu");

    const standingsSubmenu = document.getElementById(
      "dropdown-standings-submenu"
    );

    driversResponsiveButton.addEventListener("click", (e) => {
      e.preventDefault();

      submenu.classList.toggle("active");
    });

    teamsResponsiveButton.addEventListener("click", (e) => {
      e.preventDefault();

      teamsSubmenu.classList.toggle("active");
    });

    standingsResponsiveButton.addEventListener("click", (e) => {
      e.preventDefault();

      standingsSubmenu.classList.toggle("active");
    });
  }
}

/**
 * Function to toggle responsive navbar
 */
function toggleResponsiveNavbar() {
  const menuButton = document.getElementById("menu-button");
  const menu = document.getElementById("dropdown-responsive");

  menuButton.addEventListener("click", (e) => {
    e.preventDefault();

    menu.classList.toggle("active");
    menuButton.classList.toggle("active");
  });
}

/**
 * Function to style schedule button into normal navbar
 * @param {HTMLButtonElement} scheduleButton
 */
function handleStyleScheduleButton(scheduleButton) {
  scheduleButton.addEventListener("click", openSchedule);

  if (window.location.pathname === "/schedule") {
    scheduleButton.classList.add("nav-link-active");

    scheduleButton.addEventListener("mouseenter", () => {
      scheduleButton.classList.add("nav-link-hover");
    });

    scheduleButton.addEventListener("mouseleave", () => {
      scheduleButton.classList.remove("nav-link-hover");
    });
  }
}

/**
 * Function to style schedule button into responsive navbar
 * @param {HTMLButtonElement} scheduleButton
 */
function handleStyleScheduleResponsiveButton(scheduleButton) {
  scheduleButton.addEventListener("click", openSchedule);

  if (window.location.pathname === "/schedule") {
    scheduleButton.style.cssText = "background-color: red !important";
  }
}
