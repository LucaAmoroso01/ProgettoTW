document.addEventListener("DOMContentLoaded", async () => {
  const newsId = window.location.pathname.split("/")[2];

  getNewsById(newsId);

  const user = await getLoggedUser();

  const addCommentContainer = document.getElementById("add-comment-container");

  /**
   * show or hide add comment container
   * if user is logged or not
   */
  if (user) {
    addCommentContainer.style.display = "flex";
  } else {
    addCommentContainer.style.display = "none";
  }

  const addCommentButton = document.getElementById("add-comment-button");
  addCommentButton.addEventListener("click", () => handleAddComment(newsId));

  await loadAndDisplayComments(newsId);
});

/**
 * Load and display comments
 * @param {string} newsId The ID of the news
 */
async function loadAndDisplayComments(newsId) {
  const comments = await getNewsComments(newsId);
  createCommentsCards(comments);
}

/**
 * function to get the news by news id
 * and create the page with news obtained
 * @param {string} newsId The id of news
 */
async function getNewsById(newsId) {
  try {
    const response = await fetch(`/news/${newsId}`);

    if (!response.ok) {
      throw new Error(`Errore nella richiesta: ${response.statusText}`);
    }

    const news = await response.json();

    createNewsPage(news);
  } catch (error) {
    console.error(`Error: ${error.message}`);
  }
}

/**
 * @typedef {Object} User
 * @property {string} username The username of the logged user
 * @property {string} email The email address of the logged user
 * @property {number} userId The unique identifier of the logged user
 */

/**
 * function to get the logged user
 * @returns {User} The logged user
 */
async function getLoggedUser() {
  try {
    const response = await fetch("/auth/user");

    if (!response.ok) {
      throw new Error(`Errore nella richiesta: ${response.statusText}`);
    }

    const user = await response.json();

    if (user.status === 401) {
      return undefined;
    }

    return user.user;
  } catch (error) {
    console.error(`Error: ${error.message}`);
  }
}

/**
 * function to create the news page with a news
 * @param {object} news The news to load into page
 */
function createNewsPage(news) {
  document.title = `F1 Universe - ${news.title}`;

  const newsContainer = document.getElementById("news");

  const newsTitle = document.createElement("h5");
  newsTitle.classList.add("news-title");
  newsTitle.textContent = news.title;

  newsContainer.appendChild(newsTitle);

  const newsImgContainer = document.createElement("div");
  newsImgContainer.classList.add("img-container");
  const img = document.createElement("img");
  img.classList.add("img-news");
  img.src = news.img.src;
  img.alt = news.img.alt;

  newsImgContainer.appendChild(img);

  newsContainer.appendChild(newsImgContainer);

  const newsTextContainer = document.createElement("div");
  newsTextContainer.classList.add("card-text-news-container");

  const newsSubtitle = document.createElement("p");
  newsSubtitle.classList.add("card-subtitle-news");
  newsSubtitle.textContent = news.subtitle;

  newsTextContainer.appendChild(newsSubtitle);

  const newsText = document.createElement("div");
  newsText.classList.add("card-text-news");

  const paragraphs = news.text.split("\n\n");

  paragraphs.forEach((paragraph) => {
    const p = document.createElement("p");
    p.classList.add("card-text-news");
    p.textContent = paragraph;
    newsText.appendChild(p);
  });

  newsTextContainer.appendChild(newsText);

  newsContainer.appendChild(newsTextContainer);
}

/**
 * function to add a comment to a news
 * @param {string} newsId The news to add a comment
 */
function handleAddComment(newsId) {
  const commentForm = document.getElementById("comment-form");

  const submitHandler = async (e) => {
    e.preventDefault();

    // Verifica se l'evento di submit è già in corso
    if (commentForm.getAttribute("data-submitting") === "true") {
      return;
    }

    commentForm.setAttribute("data-submitting", "true");

    const commentTitle = document.getElementById("comment-title").value;
    const commentText = document.getElementById("comment-text").value;

    const commentData = {
      comment_title: commentTitle,
      comment_text: commentText,
    };

    try {
      const response = await fetch(`/comments/${newsId}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(commentData),
      });

      if (!response.ok) {
        throw new Error(`Error: ${response.statusText}`);
      }

      const data = await response.json();

      if (data.status === 200) {
        await loadAndDisplayComments(newsId);

        document.getElementById("comment-title").value = "";
        document.getElementById("comment-text").value = "";
      }
    } catch (error) {
      console.error(error.message);
    } finally {
      commentForm.setAttribute("data-submitting", "false");
    }
  };

  commentForm.addEventListener("submit", submitHandler);
}

/**
 * function to get comments of a news
 * @param {string} newsId The news id to get comments
 * @return {Array} The news comments
 */
async function getNewsComments(newsId) {
  try {
    const response = await fetch(`/comments/${newsId}`);

    if (!response.ok) {
      throw new Error(`Error: ${response.statusText}`);
    }

    const comments = await response.json();

    return comments;
  } catch (error) {
    console.error(`Error: ${error.message}`);
  }
}

/**
 * function to create comments cards
 * @param {Array} comments comments to create cards
 */
function createCommentsCards(comments) {
  const commentsContainer = document.getElementById("comments-container");

  // Rimuovi tutti i commenti esistenti
  while (commentsContainer.firstChild) {
    commentsContainer.removeChild(commentsContainer.firstChild);
  }

  comments.forEach((comment) => {
    const commentCard = document.createElement("div");
    commentCard.classList.add(
      "card",
      "d-flex",
      "align-items-start",
      "flex-column",
      "gap-3",
      "w-100"
    );
    commentCard.style.cssText =
      "background-color: white; padding: 1.5rem !important; margin-bottom: 3rem !important; border-radius: 15px !important;";

    const commentCardTitle = document.createElement("h4");
    commentCardTitle.classList.add(
      "card-header",
      "d-flex",
      "align-items-center",
      "w-100"
    );
    commentCardTitle.textContent = comment.title;

    commentCard.appendChild(commentCardTitle);

    const commentCardBody = document.createElement("div");
    commentCardBody.classList.add("card-body");

    const commentCardText = document.createElement("p");
    commentCardText.classList.add("card-text");
    commentCardText.style.cssText = "padding-inline: 2rem !important";
    commentCardText.textContent = comment.text;

    commentCardBody.appendChild(commentCardText);

    commentCard.appendChild(commentCardBody);

    const commentCardFooter = document.createElement("div");
    commentCardFooter.classList.add("card-footer", "w-100");

    const commentCardFooterText = document.createElement("h6");
    commentCardFooterText.classList.add(
      "d-flex",
      "align-items-center",
      "gap-3"
    );
    commentCardFooterText.style.cssText =
      "font-size: 1.3rem !important; justify-content: space-between !important;";
    commentCardFooterText.innerHTML = `
      <div class='d-flex align-items-center gap-2'>
        <span><i class="bi bi-calendar3"></i></span> ${differenceBetweenDates(
          new Date(comment.dateInsert)
        )}
      </div>
      <div class='d-flex align-items-center gap-2'>
        <span><i class="bi bi-person-circle"></i></span> ${comment.author}
      </div>
    `;

    commentCardFooter.appendChild(commentCardFooterText);

    commentCard.appendChild(commentCardFooter);

    commentsContainer.appendChild(commentCard);
  });
}

/**
 * function to get time elapsed from a comment date
 * @param {Date} commentDate The date when the comment has been inserted
 * @returns {string} The string with time elapsed
 */
const differenceBetweenDates = (commentDate) => {
  if (commentDate) {
    const today = new Date();

    const differenceInMs = today.getTime() - commentDate.getTime();
    const differenceInDays = Math.floor(differenceInMs / (1000 * 60 * 60 * 24));
    const differenceInHours = Math.floor(differenceInMs / (1000 * 60 * 60));

    if (differenceInHours >= 24) {
      if (differenceInDays === 1) {
        return `${differenceInDays} day ago`;
      } else {
        return `${differenceInDays} days ago`;
      }
    }

    if (differenceInHours > 0) {
      if (differenceInHours === 1) {
        return `${differenceInHours} hour ago`;
      } else {
        return `${differenceInHours} hours ago`;
      }
    }

    if (differenceInDays > 7) {
      return commentDate.toLocaleDateString();
    }

    return `now`;
  }
};
