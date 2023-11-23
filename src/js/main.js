const root = "/ProgettoTW/src";

document.addEventListener("DOMContentLoaded", function () {
  var cardTextElements = document.querySelectorAll(".card-text");

  cardTextElements.forEach(function (element) {
    var text = element.textContent;

    var truncatedText =
      text.length > 180 ? text.substring(0, 180) + "..." : text;

    element.textContent = truncatedText;
  });
});
