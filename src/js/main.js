const news = [
  {
    img: {
      src: "https://images.radiox.co.uk/images/59032?width=1548&crop=1_1&signature=x4sJxlWxwadyYPBdXGBEjiy2UmY=",
      alt: "Kings of Leon",
    },
    title:
      "Kings of Leon to headline the 2024 British Grand Prix's opening concert",
    text: "Silverstone has announced that Kings of Leon will headline the 2024 British Grand Prix’s iconic Opening Concert on Thursday, July 4, 2024.",
    redirect: "news/kings_leon.html",
  },
  {
    img: {
      src: "https://i.redd.it/0bsjmkvaoxyb1.jpg",
      alt: "Devastated Leclerc",
    },
    title:
      "‘Why am I so unlucky?’ – Leclerc left devastated by formation lap failure in Brazil",
    text: "It wasn’t to be for Charles Leclerc in Brazil, the Ferrari driver suffering a mechanical failure on the formation lap that ultimately took him out of the race.",
    redirect: "news/devastated_leclerc.html",
  },
  {
    img: {
      src: "https://saltwire.imgix.net/2023/11/5/motor-racing-verstappen-wins-in-sao-paulo-for-17th-win-of-th_uMeMDQ7.jpg?cs=srgb&fit=crop&h=568&w=847&dpr=1&auto=format%2Cenhance%2Ccompress",
      alt: "Verstappen's Red Bull on track",
    },
    title:
      "Winners and Losers from Sao Paulo – Who left Interlagos the happiest in the final Sprint weekend of the season?",
    text: "Max Verstappen extended his record of most wins in a season to 17. But while there was joy for the Dutchman, there was frustration for others, not least those caught up in the opening lap melee.",
    redirect: "news/verstappen_redbull_on_track.html",
  },
  {
    img: {
      src: "https://www.f1sport.it/wp-content/uploads/2023/11/c.webp",
      alt: "Perez and Alonso's battle",
    },
    title:
      "Perez found ‘intense’ battle with Alonso ‘super enjoyable’ despite missing out on the podium",
    text: "Sergio Perez missed out on a top three finish in Sao Paulo by just 0.053s, as Fernando Alonso pipped him in a drag race across the finishing line. It was the perfect end to an epic battle that had been going on for many laps between the Red Bull and the Aston Martin.",
    redirect: "news/perez_alonso_battle.html",
  },
  {
    img: {
      src: "https://www.f1sport.it/wp-content/uploads/2020/06/F1-Wolff-Mercedes-Fotocattagni-o3pth4z8o1rrgi5n3fnlk8gzbi8iqj8oqpgrmlmhog-1200x799-1.jpg",
      alt: "Toto Wolff",
    },
    title:
      "‘Inexcusable performance’ – Wolff brands Mercedes’ W14 ‘miserable’ as car ‘doesn’t deserve a win’",
    text: "Toto Wolff has labelled Mercedes’ W14 “miserable” following an “inexcusable performance” at the Sao Paulo Grand Prix.",
    redirect: "news/toto_wolff.html",
  },
  {
    img: {
      src: "https://preview.redd.it/lando-norris-mclaren-lift-his-2nd-place-trophy-race-2023-v0-3582q5fhrryb1.jpg?auto=webp&s=b7701b91af8aaf5bc46f7343ff78653f68625d20",
      alt: "Lando Norris lift his 2nd place trophy",
    },
    title:
      "‘Close to perfect weekend’ for Norris as he grabs fifth podium in six races",
    text: "Lando Norris shot off the line to launch himself past both Aston Martins into second at the first corner, and from there, never looked back.",
    redirect: "news/verstappen_redbull_on_track.html",
  },
  {
    img: {
      src: "https://cdn.racingnews365.com/2023/Hulkenberg/_1125x633_crop_center-center_85_none/XPB_1246392_HiRes.jpg?v=1699120887",
      alt: "Haas car on track",
    },
    title:
      "Stewards to consider Haas ‘Right of Review’ request over US Grand Prix result",
    text: "United States Grand Prix stewards are to consider a request from the Haas team for a Right of Review of the Austin race results in relation to track limit infringements, including those by Williams’ Alex Albon.",
    redirect: "news/haas_car.html",
  },
  {
    img: {
      src: "https://sportsbase.io/images/gpfans/copy_1200x800/4af3b21d901c5f4085ae8fb4c04695b68a724ca1.jpg",
      alt: "Gianpiero Lambiase",
    },
    title:
      "Lambiase reveals his ‘biggest fear’ about Verstappen relationship going forward",
    text: "Max Verstappen and his race engineer Gianpiero Lambiase have forged a formidable partnership during their time together at Red Bull – but the journey to title-winning glory has not been without some bumps in the road.",
    redirect: "news/gianpiero_lambiase.html",
  },
];

document.addEventListener("DOMContentLoaded", function () {
  const cardTextElements = document.querySelectorAll(".card-text");

  cardTextElements.forEach(function (element) {
    const text = element.textContent;

    const truncatedText =
      text.length > 180 ? text.substring(0, 180) + "..." : text;

    element.textContent = truncatedText;
  });

  createCardNews();
});

function createCardNews() {
  news.forEach((element) => {
    const card = document.createElement("div");
    card.classList.add("card", "border-0");

    const newsImg = document.createElement("img");
    newsImg.classList.add("card-img-top");
    newsImg.src = element.img.src;
    newsImg.alt = element.img.alt;

    card.appendChild(newsImg);

    const cardBody = document.createElement("div");
    cardBody.classList.add("card-body", "border-bottom", "border-end");

    const cardTitle = document.createElement("h5");
    cardTitle.classList.add("card-title");
    cardTitle.textContent = element.title;

    cardBody.appendChild(cardTitle);

    const cardText = document.createElement("p");
    cardText.classList.add("card-text");
    cardText.textContent = truncateText(element.text);

    cardBody.appendChild(cardText);

    const button = document.createElement("button");
    button.classList.add("btn", "btn-primary", "read-more");
    button.textContent = "Read more";
    button.addEventListener(
      "click",
      () => (window.location.href = element.redirect)
    );

    cardBody.appendChild(button);

    card.appendChild(cardBody);

    const newsSection = document.getElementById("news-section");
    newsSection.appendChild(card);
  });
}

function truncateText(text) {
  return text.length > 180 ? text.substring(0, 180) + "..." : text;
}
