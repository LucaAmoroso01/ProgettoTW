document.addEventListener("DOMContentLoaded", () => {
  const circuits = [
    {
      round: "round 1",
      circuitName: "Bahrain",
      circuitFullName: "FORMULA 1 GULF AIR BAHRAIN GRAND PRIX 2023",
      dates: "03-05",
      month: "mar",
      flag: { src: "images/bahrain.avif", alt: "Bahrain flag" },
      circuitImg: {
        src: "images/bahrain-circuit.webp",
        alt: "Bahrain circuit",
      },
    },
    {
      round: "round 2",
      circuitName: "Saudi Arabia",
      circuitFullName: "FORMULA 1 STC SAUDI ARABIAN GRAND PRIX 2023",
      dates: "17-19",
      month: "mar",
      flag: { src: "images/saudi-arabia.avif", alt: "Saudi Arabia flag" },
      circuitImg: {
        src: "images/saudi-arabia-circuit.jpg",
        alt: "Saudi Arabia circuit",
      },
    },
    {
      round: "round 3",
      circuitName: "Australia",
      circuitFullName: "FORMULA 1 STC SAUDI ARABIAN GRAND PRIX 2023",
      dates: "31-02",
      month: "mar-apr",
      flag: { src: "images/australia.avif", alt: "Australia flag" },
      circuitImg: {
        src: "images/australia-circuit.jpg",
        alt: "Australia circuit",
      },
    },
    {
      round: "round 4",
      circuitName: "Azerbaijan",
      circuitFullName: "FORMULA 1 AZERBAIJAN GRAND PRIX 2023",
      dates: "28-30",
      month: "apr",
      flag: { src: "images/azerbaijan.avif", alt: "Azerbaijan flag" },
      circuitImg: {
        src: "images/azerbaijan-circuit.jpg",
        alt: "Azerbaijan circuit",
      },
    },
    {
      round: "round 5",
      circuitName: "United States",
      circuitFullName: "FORMULA 1 CRYPTO.COM MIAMI GRAND PRIX 2023",
      dates: "05-07",
      month: "may",
      flag: { src: "images/us.avif", alt: "US flag" },
      circuitImg: {
        src: "images/miami-circuit.jpg",
        alt: "Miami circuit",
      },
    },
    {
      round: "round 6",
      circuitName: "Italy",
      circuitFullName:
        "FORMULA 1 QATAR AIRWAYS GRAN PREMIO DEL MADE IN ITALY E DELL'EMILIA-ROMAGNA 2023",
      dates: "19-21",
      month: "may",
      flag: { src: "images/italy.avif", alt: "Italy flag" },
      circuitImg: {
        src: "images/imola-circuit.avif",
        alt: "Imola circuit",
      },
    },
    {
      round: "round 7",
      circuitName: "Monaco",
      circuitFullName: "FORMULA 1 GRAND PRIX DE MONACO 2023",
      dates: "26-28",
      month: "may",
      flag: { src: "images/monaco.avif", alt: "Monaco flag" },
      circuitImg: {
        src: "images/monaco-circuit.avif",
        alt: "Monaco circuit",
      },
    },
  ];

  const scheduleButton = document.getElementById("schedule");

  scheduleButton.addEventListener("mouseenter", () => {
    scheduleButton.classList.add("nav-link-hover");
  });

  scheduleButton.addEventListener("mouseleave", () => {
    scheduleButton.classList.remove("nav-link-hover");
  });

  const scheduleListContainer = document.getElementById("schedule-card");

  circuits.forEach((circuit) => {
    const circuitLayout = document.createElement("div");
    circuitLayout.classList.add("schedule-list");

    scheduleListContainer.appendChild(circuitLayout);

    const round = document.createElement("p");
    round.textContent = circuit.round;
    round.classList.add("schedule-list-title");

    if (round.textContent.length > 7) {
      round.style.width = "calc(29% + 2px)";
    }

    const monthDayContainer = document.createElement("div");
    monthDayContainer.classList.add("month-days-schedule");

    const day = document.createElement("p");
    day.textContent = circuit.dates;
    day.classList.add("week-schedule");

    const month = document.createElement("p");
    month.textContent = circuit.month;
    month.classList.add("month-schedule");

    monthDayContainer.appendChild(day);
    monthDayContainer.appendChild(month);

    const scheduleInfoContainer = document.createElement("div");
    scheduleInfoContainer.classList.add("schedule-info");

    const flag = document.createElement("img");
    flag.classList.add("flag-img");
    flag.src = circuit.flag.src;
    flag.alt = circuit.flag.alt;

    scheduleInfoContainer.appendChild(monthDayContainer);
    scheduleInfoContainer.appendChild(flag);

    const firstDivider = document.createElement("div");
    firstDivider.classList.add("section-divider");
    const secondDivider = document.createElement("div");
    secondDivider.classList.add("section-divider");

    const circuitContainer = document.createElement("div");
    circuitContainer.classList.add("circuit-container");

    const circuitName = document.createElement("h1");
    circuitName.textContent = circuit.circuitName;
    circuitName.classList.add("circuit-name");

    const circuitFullName = document.createElement("p");
    circuitFullName.textContent = circuit.circuitFullName;
    circuitFullName.classList.add("circuit-full-name");

    circuitContainer.appendChild(circuitName);
    circuitContainer.appendChild(circuitFullName);

    const circuitImgContainer = document.createElement("div");
    circuitImgContainer.classList.add("circuit-img-container");
    const circuitImg = document.createElement("img");
    circuitImg.classList.add("circuit-img");
    circuitImg.src = circuit.circuitImg.src;
    circuitImg.alt = circuit.circuitImg.alt;

    circuitImgContainer.appendChild(circuitImg);

    circuitLayout.appendChild(round);
    circuitLayout.appendChild(scheduleInfoContainer);
    circuitLayout.appendChild(firstDivider);
    circuitLayout.appendChild(circuitContainer);
    circuitLayout.appendChild(secondDivider);
    circuitLayout.appendChild(circuitImgContainer);

    circuitLayout.addEventListener("mouseenter", () => {
      round.style.color = "red";
      round.style.transition = "all 0.3s ease-in-out";
    });
    circuitLayout.addEventListener("mouseleave", () => {
      round.style.color = "inherit";
      round.style.transition = "none";
    });

    scheduleListContainer.appendChild(circuitLayout);
  });
});
