const root = "/";

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

const teamsArray = drivers
  .map((driver) => driver.team)
  .sort((a, b) => a.localeCompare(b));

/**
 * function to load navbar
 */
export function loadNavbar() {
  fetch("/navbar")
    .then((response) => response.text())
    .then(async (html) => {
      document.getElementById("navbar").innerHTML = html;

      loadTeamsAndDrivers();

      window.addEventListener("resize", handleNavbarClass);

      handleNavbarClass();

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
        .then((data) => {
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

            document.getElementById("login-buttons-responsive").style.cssText =
              "padding-bottom: 0 !important";

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
            logoutButton.addEventListener("click", () => logout());
          }
        });

      const homeResponsiveButton = document.getElementById("home-responsive");

      if (window.location.pathname === "/") {
        homeResponsiveButton.remove();
      }
    })
    .catch((error) => console.error("Error loading page content:", error));
}

function openLoginOrRegistration(path) {
  window.location.href = path;
}

function openDriver(driverToOpen) {
  window.location.href = `/drivers/${driverToOpen}`;
}

function openTeam(teamToOpen) {
  window.location.href = `/teams/${teamToOpen}`;
}

function openSchedule() {
  window.location.href = `/schedule`;
}

function loadTeamsAndDrivers() {
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

  const teamsArray = drivers
    .map((driver) => driver.team)
    .sort((a, b) => a.localeCompare(b));

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

function loadTeamsAndDriversResponsive(drivers, teamsArray) {
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
    .then((data) => {
      if (data.status === 200) {
        window.location.href = "/";
      }
    });
}

function handleNavbarClass() {
  const navbar = document.getElementById("navbar");
  const responsiveNavbar = document.getElementById("responsive-navbar");

  if (window.innerWidth <= 1050) {
    navbar.classList.remove("navbar-expand-lg");
    responsiveNavbar.style.display = "flex";
  } else {
    navbar.classList.add("navbar-expand-lg");
    responsiveNavbar.style.display = "none";
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
    submenu.style.cssText = "display: none !important";

    const teamsSubmenu = document.getElementById("dropdown-teams-submenu");
    teamsSubmenu.style.cssText = "display: none !important";

    const standingsSubmenu = document.getElementById(
      "dropdown-standings-submenu"
    );
    standingsSubmenu.style.cssText = "display: none !important";

    driversResponsiveButton.addEventListener("click", () => {
      if (submenu.style.display === "block") {
        submenu.style.cssText = "display: none !important";
      } else {
        submenu.style.cssText = "display: block !important";
      }
    });

    teamsResponsiveButton.addEventListener("click", () => {
      if (teamsSubmenu.style.display === "block") {
        teamsSubmenu.style.cssText = "display: none !important";
      } else {
        teamsSubmenu.style.cssText = "display: block !important";
      }
    });

    standingsResponsiveButton.addEventListener("click", () => {
      if (standingsSubmenu.style.display === "block") {
        standingsSubmenu.style.cssText = "display: none !important";
      } else {
        standingsSubmenu.style.cssText = "display: block !important";
      }
    });

    const menuButton = document.getElementById("menu-button");
    const menu = document.getElementById("dropdown-responsive");
    menu.style.display = "none";

    menuButton.addEventListener("click", (e) => {
      menu.style.display = menu.style.display === "none" ? "block" : "none";
    });
  }
}

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

function handleStyleScheduleResponsiveButton(scheduleButton) {
  scheduleButton.addEventListener("click", openSchedule);

  if (window.location.pathname === "/schedule") {
    scheduleButton.style.cssText = "background-color: red !important";
  }
}
