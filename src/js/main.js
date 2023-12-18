document.addEventListener("DOMContentLoaded", function () {
  const cardTextElements = document.querySelectorAll(".card-text");

  cardTextElements.forEach(function (element) {
    const text = element.textContent;

    const truncatedText = truncateText(text);

    element.textContent = truncatedText;
  });

  getNews();
});

/**
 * load service worker on page load
 */
window.onload = () => {
  "use strict";

  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("/sw").then(
      function (registration) {
        // Service worker registered correctly.
        console.log(
          "ServiceWorker registration successful with scope: ",
          registration.scope
        );
      },
      function (err) {
        // Troubles in registering the service worker. :(
        console.log("ServiceWorker registration failed: ", err);
      }
    );
  }
};

/**
 * Function to get news from server.
 * This function create news card loaded with json
 * returned by endpoint /news
 */
async function getNews() {
  try {
    const response = await fetch("/news");

    if (!response.ok) {
      throw new Error(`Errore nella richiesta: ${response.statusText}`);
    }

    const news = await response.json();

    createCardNews(news);
  } catch (error) {
    console.error(`Error: ${error.message}`);
  }
}

/**
 * Function to create card news
 * for each news into news array
 * @param {News[]} news news array
 */
function createCardNews(news) {
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
      () => (window.location.href = `/news/${element.id}/page`)
    );

    cardBody.appendChild(button);

    card.appendChild(cardBody);

    const newsSection = document.getElementById("news-section");

    if (newsSection) {
      newsSection.appendChild(card);
    }
  });
}

/**
 * Function to truncate text
 * @param {string} text
 * @returns The truncated text
 */
function truncateText(text) {
  return text.length > 180 ? text.substring(0, 180) + "..." : text;
}
