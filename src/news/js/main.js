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
 * @typedef {'t' | 'T' | 'f' | 'F'} JournalistEnum
 */

/**
 * @typedef {Object} User
 * @property {string} title The title of the logged-in user (possible values: 'Mr', 'Mrs', 'Ms', 'Miss')
 * @property {string} firstName The firstName of the logged-in user
 * @property {string} lastName The last name of the logged-in user
 * @property {string} country The country of the logged-in user
 * @property {date} birthDate The birth date of the logged-in user
 * @property {string} username The username of the logged-in user
 * @property {string} email The email address of the logged-in user
 * @property {date} dateIns The date when logged-in user is inserted into database
 * @property {JournalistEnum} journalist Value to check if the logged-in user is a journalsit
 */

/**
 * @typedef {Object} UserResponse
 * @property {User} user The logged-in user
 * @property {string} status The response status
 */

/**
 * Function to retrieve the logged-in user
 * @returns {Promise<User | undefined>} A Promise containing the logged-in user or undefined in case of an error
 */
async function getLoggedUser() {
  try {
    const response = await fetch("/auth/user");

    if (!response.ok) {
      throw new Error(`Error in request: ${response.statusText}`);
    }

    /**
     * @type {UserResponse}
     */
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
 * @typedef {Object} NewsImg
 * @property {string} src The news image src
 * @property {string} alt The news image alt
 */

/**
 * @typedef {Object} News
 * @property {number} id The news id
 * @property {string} title The news title
 * @property {string} subtitle The news subtitle
 * @property {string} text The news text
 * @property {NewsImg} img The news image
 */

/**
 * Function to create the news page with a news
 * @param {News[]} news The news to load into page
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
 * @typedef {Object} CommentType
 * @property {number} id The comment id
 * @property {string} author The comment author
 * @property {number} newsId The news to which the comment refers
 * @property {string} title The comment title
 * @property {string} text The comment text
 * @property {date} dateInsert The date when comment was added
 */

/**
 * @typedef {Object} AddCommentResponse
 * @property {string} message The message returned by server
 * @property {number} status The response status
 */

/**
 * function to add a comment to a news
 * @param {string} newsId The news to add a comment
 */
function handleAddComment(newsId) {
  const commentForm = document.getElementById("comment-form");

  const submitHandler = async (e) => {
    e.preventDefault();

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

      /**
       * @type {AddCommentResponse}
       */
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
 * Function to get comments of a news
 * @param {number} newsId The news id to get comments
 * @return {CommentType[]} The news comments
 */
async function getNewsComments(newsId) {
  try {
    const response = await fetch(`/comments/${newsId}`);

    if (!response.ok) {
      throw new Error(`Error: ${response.statusText}`);
    }

    /**
     * @type {CommentType[]}
     */
    const comments = await response.json();

    return comments;
  } catch (error) {
    console.error(`Error: ${error.message}`);
  }
}

/**
 * Function to create comments cards
 * @param {CommentType[]} comments comments to create cards
 */
function createCommentsCards(comments) {
  const commentsContainer = document.getElementById("comments-container");

  // delete all comments
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
    commentCardFooterText.style.cssText = `font-size: ${
      window.innerWidth < 1201 ? "1rem" : "1.3rem"
    } !important; justify-content: space-between !important;`;
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
 * @param {Date} commentDate The date when the comment was inserted
 * @returns {string} The string with time elapsed
 */
function differenceBetweenDates(commentDate) {
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
}
