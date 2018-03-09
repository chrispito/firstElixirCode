import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
      channel.join()
        .receive("ok", resp => { 
          renderComments(resp.comments);
        })
        .receive("error", resp => { 
          console.log("Unable to join", resp) 
        })

  channel.on(`comments:${topicId}:new`, renderComment);

  document.querySelector('#send-comment-button').addEventListener('click', function() {
    var commentText = document.querySelector('#comment-text').value;
    channel.push('comment:hello', {comment: commentText});
    document.querySelector('#comment-text').value = ""
  })
}

function renderComment(event) {
  const renderedComment = commentTemplate(event.comment);

  document.querySelector('.comment-list').innerHTML += renderedComment;
}

function renderComments(comments) {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  })

  document.querySelector('.comment-list').innerHTML = renderedComments.join('');
}

function commentTemplate(comment) {
  let name = "Anonymous";
  if (comment.user) {
    name = comment.user.name;
  }
  return `
     <li class="collection-item">
      <div class="comment">
        <div class="c-head">
        <div>
          <span>Writen by:</span>
          <span class="autor-name">${name}</span>
        </div>
        </div>
        <div class="c-body">
          ${comment.comment}
        </div>
      </div>
     </li>
    `;
}

window.createSocket = createSocket;
