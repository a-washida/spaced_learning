if (window.location.pathname.includes("edit")){
  // 問題編集ページを読み込んだ時、プレビューエリアの表示が問題作成時と全く同じになるように以下のコードを記述
  window.addEventListener("load", (e) => {
    // テキストエリアに入力された値を取得し、フォントサイズのプルダウンで設定された倍率を適用した上で、プレビュー表示する関数式
    const textareaSet = (questionOrAnswer) => {
      const textarea = document.querySelector(`.qa-form__textarea.js-${questionOrAnswer}`)
      const insertTextarea = document.getElementById(`${questionOrAnswer}-preview__textarea`)
      const fontSize = document.querySelector(`.font-size-${questionOrAnswer}`)
      insertTextarea.setAttribute("style", `font-size: ${fontSize.innerHTML}rem;`)
      insertTextarea.textContent = textarea.value
    }

    // 画像を取得し、画像サイズのプルダウンで設定された倍率を適用した上で、プレビュー表示する関数式
    const imageSet = (questionOrAnswer) => {
      const image = document.querySelector(`.img-preview-${questionOrAnswer}`)
      const imageSize = document.querySelector(`.img-size-${questionOrAnswer}`)
      // imageが存在する場合のみ以下のコードを実行
      if (image){
        image.setAttribute("style", `width: ${200 * imageSize.innerHTML}px;`)
        const insertImage = document.getElementById(`${questionOrAnswer}-preview__img`)
        insertImage.appendChild(image)
      }
    }

    // プルダウンのselected属性を適切なoption要素に設定する関数式
    const pulldownSelectedSet = (questionOrAnswer, fontOrImage) => {
      const selectedPosition = document.querySelector(`.${questionOrAnswer}-${fontOrImage}-selected-position`)
      const options = document.querySelectorAll(`#question_answer_${questionOrAnswer}_option_attributes_${fontOrImage}_size_id option`)
      // 最初に設定されているoption要素のselected属性を削除
      options.forEach( function(option){
        if (option.hasAttribute("selected")){
          option.removeAttribute("selected")
        }
      })
      options[selectedPosition.innerHTML - 1].setAttribute("selected", "selected")
    }

    const arrays = ["question", "answer"]
    for (let i = 0; i < arrays.length; i++){
      textareaSet(arrays[i])
      imageSet(arrays[i])
      pulldownSelectedSet(arrays[i], "font")
      pulldownSelectedSet(arrays[i], "image")
    }
  })
}