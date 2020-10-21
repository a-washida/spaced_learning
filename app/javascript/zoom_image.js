window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、index, reviewアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "index" || action === "review") ||
      controller === "shares" && action === "index"){

    // 画像をクリックすると画像を拡大表示し、再度画面をクリックすると拡大表示した画像を削除する関数式
    const zoom = (image) => {
      image.addEventListener("click", (e) => {
        // imageを複製する。imageをそのままappendChildすると、元のimageが画面上から消えてしまうため。
        const clone = image.cloneNode(false)
        clone.removeAttribute("style")
        clone.setAttribute("id", "image-clone")
        // imageから複製したclone要素を画面上に表示させるためのターゲットとなる要素を取得
        const imageTarget = document.getElementById("image-target")
        imageTarget.setAttribute("style", "display: block;")
        imageTarget.appendChild(clone)
        // imageTargetをクリックすると、拡大表示されていた画像が削除され、imageTargetの要素が再びdisplay: none;になる。
        imageTarget.addEventListener("click", (e) => {
          clone.remove()
          imageTarget.removeAttribute("style")
        })
      })
    }

    // 以下で画像を取得して、それぞれの画像に対して関数式zoomを実行
    const questionImages = document.querySelectorAll(".display-question-content__image")
    const answerImages = document.querySelectorAll(".display-answer-content__image")
    questionImages.forEach( function(questionImage){
      zoom(questionImage)
    })
    answerImages.forEach( function(answerImage){
      zoom(answerImage)
    })
  }
})

