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
      circuitFullName: "FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX 2023",
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
    {
      round: "round 8",
      circuitName: "Spain",
      circuitFullName: "FORMULA 1 AWS GRAN PREMIO DE ESPAÑA 2023",
      dates: "02-04",
      month: "jun",
      flag: { src: "images/spain.avif", alt: "Spain flag" },
      circuitImg: {
        src: "images/spain-circuit.jpeg",
        alt: "Spain circuit",
      },
    },
    {
      round: "round 9",
      circuitName: "Canada",
      circuitFullName: "FORMULA 1 PIRELLI GRAND PRIX DU CANADA 2023",
      dates: "16-18",
      month: "jun",
      flag: { src: "images/canada.avif", alt: "Canada flag" },
      circuitImg: {
        src: "images/canada-circuit.jpeg",
        alt: "Canada circuit",
      },
    },
    {
      round: "round 10",
      circuitName: "Austria",
      circuitFullName: "FORMULA 1 ROLEX GROSSER PREIS VON ÖSTERREICH 2023",
      dates: "30-02",
      month: "jun-jul",
      flag: { src: "images/austria.avif", alt: "Austria flag" },
      circuitImg: {
        src: "images/austria-circuit.avif",
        alt: "Austria circuit",
      },
    },
    {
      round: "round 11",
      circuitName: "Great Britain",
      circuitFullName: "FORMULA 1 ARAMCO BRITISH GRAND PRIX 2023",
      dates: "07-09",
      month: "jul",
      flag: { src: "images/uk.avif", alt: "UK flag" },
      circuitImg: {
        src: "images/uk-circuit.jpeg",
        alt: "UK circuit",
      },
    },
    {
      round: "round 12",
      circuitName: "Hungary",
      circuitFullName: "FORMULA 1 QATAR AIRWAYS HUNGARIAN GRAND PRIX 2023",
      dates: "14-16",
      month: "jul",
      flag: { src: "images/hungary.avif", alt: "Hungary flag" },
      circuitImg: {
        src: "images/hungary-circuit.png",
        alt: "Hungary circuit",
      },
    },
    {
      round: "round 13",
      circuitName: "Belgium",
      circuitFullName: "FORMULA 1 MSC CRUISES BELGIAN GRAND PRIX 2023",
      dates: "28-30",
      month: "jul",
      flag: { src: "images/belgium.avif", alt: "Belgium flag" },
      circuitImg: {
        src: "images/belgium-circuit.jpeg",
        alt: "Belgium circuit",
      },
    },
    {
      round: "round 14",
      circuitName: "Netherlands",
      circuitFullName: "FORMULA 1 HEINEKEN DUTCH GRAND PRIX 2023",
      dates: "25-27",
      month: "aug",
      flag: { src: "images/netherlands.avif", alt: "Netherlands flag" },
      circuitImg: {
        src: "images/netherlands-circuit.jpeg",
        alt: "Netherlands circuit",
      },
    },
    {
      round: "round 15",
      circuitName: "Italy",
      circuitFullName: "FORMULA 1 PIRELLI GRAN PREMIO D’ITALIA 2023",
      dates: "01-03",
      month: "sep",
      flag: { src: "images/italy.avif", alt: "Italy flag" },
      circuitImg: {
        src: "images/monza-circuit.jpeg",
        alt: "Italy circuit",
      },
    },
    {
      round: "round 16",
      circuitName: "Singapore",
      circuitFullName: "FORMULA 1 SINGAPORE AIRLINES SINGAPORE GRAND PRIX 2023",
      dates: "15-17",
      month: "sep",
      flag: { src: "images/singapore.avif", alt: "Singapore flag" },
      circuitImg: {
        src: "images/singapore-circuit.webp",
        alt: "Singapore circuit",
      },
    },
    {
      round: "round 17",
      circuitName: "Japan",
      circuitFullName: "FORMULA 1 LENOVO JAPANESE GRAND PRIX 2023",
      dates: "22-24",
      month: "sep",
      flag: { src: "images/japan.avif", alt: "Japan flag" },
      circuitImg: {
        src: "images/japan-circuit.jpeg",
        alt: "Japan circuit",
      },
    },
    {
      round: "round 18",
      circuitName: "Qatar",
      circuitFullName: "FORMULA 1 QATAR AIRWAYS QATAR GRAND PRIX 2023",
      dates: "06-08",
      month: "oct",
      flag: { src: "images/qatar.avif", alt: "Qatar flag" },
      circuitImg: {
        src: "images/qatar-circuit.jpeg",
        alt: "Qatar circuit",
      },
    },
    {
      round: "round 19",
      circuitName: "United States",
      circuitFullName: "FORMULA 1 LENOVO UNITED STATES GRAND PRIX 2023",
      dates: "20-22",
      month: "oct",
      flag: { src: "images/us.avif", alt: "US flag" },
      circuitImg: {
        src: "images/austin-circuit.jpeg",
        alt: "Austin circuit",
      },
    },
    {
      round: "round 20",
      circuitName: "Mexico",
      circuitFullName: "FORMULA 1 GRAN PREMIO DE LA CIUDAD DE MÉXICO 2023",
      dates: "27-29",
      month: "oct",
      flag: { src: "images/mexico.avif", alt: "Mexico flag" },
      circuitImg: {
        src: "images/mexico-circuit.webp",
        alt: "Mexico circuit",
      },
    },
    {
      round: "round 21",
      circuitName: "Brazil",
      circuitFullName: "FORMULA 1 ROLEX GRANDE PRÊMIO DE SÃO PAULO 2023",
      dates: "03-05",
      month: "nov",
      flag: { src: "images/brazil.avif", alt: "Brazil flag" },
      circuitImg: {
        src: "images/brazil-circuit.jpeg",
        alt: "Brazil circuit",
      },
    },
    {
      round: "round 22",
      circuitName: "United States",
      circuitFullName: "FORMULA 1 HEINEKEN SILVER LAS VEGAS GRAND PRIX 2023",
      dates: "16-18",
      month: "nov",
      flag: { src: "images/us.avif", alt: "US flag" },
      circuitImg: {
        src: "images/las-vegas-circuit.webp",
        alt: "Las Vegas circuit",
      },
    },
    {
      round: "round 23",
      circuitName: "Abu Dhabi",
      circuitFullName: "FORMULA 1 ETIHAD AIRWAYS ABU DHABI GRAND PRIX 2023",
      dates: "24-26",
      month: "nov",
      flag: { src: "images/abu-dhabi.avif", alt: "Abu Dhabi flag" },
      circuitImg: {
        src: "images/abu-dhabi-circuit.jpeg",
        alt: "Abu Dhabi circuit",
      },
    },
  ];

  const scheduleListContainer = document.getElementById("schedule-card");

  circuits.forEach((circuit) => {
    const circuitLayout = document.createElement("div");
    circuitLayout.classList.add("schedule-list");

    scheduleListContainer.appendChild(circuitLayout);

    const round = document.createElement("p");
    round.textContent = circuit.round;
    round.classList.add("schedule-list-title");

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
    secondDivider.style.cssText = "margin-top: -12px";

    const circuitContainer = document.createElement("div");
    circuitContainer.classList.add("circuit-container");

    const circuitName = document.createElement("h1");
    circuitName.textContent = circuit.circuitName;
    circuitName.classList.add("circuit-name");

    const circuitFullName = document.createElement("p");
    circuitFullName.textContent = circuit.circuitFullName;
    circuitFullName.classList.add("circuit-full-name");

    const circuitNameContainer = document.createElement("div");
    circuitNameContainer.classList.add("circuit-name-container");

    circuitNameContainer.appendChild(circuitName);
    circuitNameContainer.appendChild(circuitFullName);

    circuitContainer.appendChild(firstDivider);
    circuitContainer.appendChild(circuitNameContainer);
    circuitContainer.appendChild(secondDivider);

    const scheduleCircuitContainer = document.createElement("div");
    scheduleCircuitContainer.classList.add("schedule-circuit-container");

    scheduleCircuitContainer.appendChild(scheduleInfoContainer);
    scheduleCircuitContainer.appendChild(circuitContainer);

    const circuitImgContainer = document.createElement("div");
    const circuitImg = document.createElement("img");
    circuitImg.classList.add("circuit-img");
    circuitImg.src = circuit.circuitImg.src;
    circuitImg.alt = circuit.circuitImg.alt;

    circuitImgContainer.appendChild(circuitImg);

    circuitContainer.appendChild(circuitImgContainer);

    circuitLayout.appendChild(round);
    circuitLayout.appendChild(scheduleInfoContainer);
    circuitLayout.appendChild(circuitContainer);

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
