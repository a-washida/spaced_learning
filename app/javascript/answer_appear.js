// クリックすると解答の内容を画面上に表示する関数
function appearAnswer(){
  const clicks = document.querySelectorAll(".review-click")
  const answerContents = document.querySelectorAll(".display-answer-content")
  for (let i = 0; i < clicks.length; i++){
    clicks[i].addEventListener("click", (e) => {  
      clicks[i].setAttribute("style", "display: none;")
      answerContents[i].setAttribute("style", "display: block;")
    })
  }
}

window.addEventListener("load", appearAnswer);