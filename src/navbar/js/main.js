const root = "/";

export function loadPageContent(pageUrl, containerId) {
  fetch(pageUrl)
    .then((response) => response.text())
    .then((html) => {
      document.getElementById(containerId).innerHTML = html;

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
            driver.lastName.toLowerCase() &&
            `dropdown-item-${driver.team}-active`,
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
        sign in
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

      const loginButtonsContainer = document.querySelector(".login-buttons");
      loginButtonsContainer.appendChild(loginButton);
      loginButtonsContainer.appendChild(registrationButton);

      const driversDropdownContainer = document.getElementById(
        "drivers-dropdown-container"
      );
      const teamsDropdownContainer = document.getElementById(
        "teams-dropdown-container"
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
      } else {
        driversDropdownContainer.style.cssText = "left: -2.8rem !important";
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

      if (window.location.pathname === "/schedule") {
        const scheduleButton = document.getElementById("schedule");
        scheduleButton.classList.add("nav-link-active");

        scheduleButton.addEventListener("mouseenter", () => {
          scheduleButton.classList.add("nav-link-hover");
        });

        scheduleButton.addEventListener("mouseleave", () => {
          scheduleButton.classList.remove("nav-link-hover");
        });
      }
    })
    .catch((error) => console.error("Error loading page content:", error));
}
