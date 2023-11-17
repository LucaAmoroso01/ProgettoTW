document.addEventListener("DOMContentLoaded", function () {
  var cardTextElements = document.querySelectorAll(".card-text");

  cardTextElements.forEach(function (element) {
    var text = element.textContent;

    var truncatedText =
      text.length > 180 ? text.substring(0, 180) + "..." : text;

    element.textContent = truncatedText;
  });

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
      `dropdown-item-${team}`
    );
    listItem.addEventListener("click", () => console.log(team)); // TODO: set window location to single page team

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

  const driverListContainer = document.querySelector(".dropdown-list-layout");

  drivers.forEach((driver) => {
    const listItem = createDriverListItem(driver);
    driverListContainer.appendChild(listItem);
  });

  const teamsListContainer = document.getElementById("teams");
  const addedTeams = []; // Array per tenere traccia dei team già aggiunti

  teamsArray.forEach((team) => {
    if (!addedTeams.includes(team)) {
      const listItemTeam = createTeamListItem(team);
      teamsListContainer.appendChild(listItemTeam);
      addedTeams.push(team);
    }
  });
});

function openDriver(driverToOpen) {
  const url = document.location.pathname.split("/");

  if (!url.includes("drivers")) {
    window.location.href = `/src/drivers/${driverToOpen}.html`;
  } else {
    window.location.href = `${driverToOpen}.html`;
  }
}
