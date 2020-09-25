  // 問題編集ページを読み込んだ時やrender 'new', render 'edit'で再表示した時、プレビューエリアの表示が問題作成時と同じ見た目になるように以下のコードを記述
window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、create, edit, updateアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "edit" ||
                                            action === "update" ||
                                            action === "create")){

    // プルダウンのoption要素の中でselectedされている要素を返り値として返す関数式
    const getSelectedOptionInPulldown = (questionOrAnswer, fontOrImage) => {
      const pulldownElement = document.getElementById(`question_answer_${questionOrAnswer}_option_attributes_${fontOrImage}_size_id`)
      // 現在選択されているブルダウンの項目が、上から何番目の項目なのかを取得
      const value = pulldownElement.value
      // プルダウン内のoption要素を全て取得
      const pulldownOptions = document.querySelectorAll(`#question_answer_${questionOrAnswer}_option_attributes_${fontOrImage}_size_id option`);
      // 現在選択されているプルダウンの項目の要素(<option>)を取得
      const selectedOption = pulldownOptions[value - 1];
      return selectedOption
    }

    // テキストエリアに入力された値を取得し、フォントサイズのプルダウンで設定された倍率を適用した上で、プレビュー表示する関数式
    const setText = (questionOrAnswer) => {
      const textarea = document.querySelector(`.qa-form__textarea.js-${questionOrAnswer}`)
      const insertTextarea = document.getElementById(`${questionOrAnswer}-preview__textarea`)
      selectedOption = getSelectedOptionInPulldown(questionOrAnswer, "font")
      insertTextarea.setAttribute("style", `font-size: ${selectedOption.innerHTML}rem;`)
      insertTextarea.textContent = textarea.value
    }

    // 画像を取得し、画像サイズのプルダウンで設定された倍率を適用した上で、プレビュー表示する関数式
    const setImage = (questionOrAnswer) => {
      const image = document.querySelector(`.img-preview-${questionOrAnswer}`)
      selectedOption = getSelectedOptionInPulldown(questionOrAnswer, "image")
      // imageが存在する場合のみ以下のコードを実行
      if (image){
        image.setAttribute("style", `width: ${Math.floor(200 * selectedOption.innerHTML)}px;`)
        const insertImage = document.getElementById(`${questionOrAnswer}-preview__img`)
        insertImage.appendChild(image)
        // checkboxと紐付けるlabel要素を生成
        const destroy = document.createElement("label")
        destroy.innerText = '削除'
        destroy.setAttribute("class", `${questionOrAnswer}-preview__img-destroy`)
        destroy.setAttribute("for", `qa-form__${questionOrAnswer}-checkbox`)
        insertImage.insertAdjacentElement('beforeend', destroy)
      }
    }

    // 関数式を実行
    const arrays = ["question", "answer"]
    arrays.forEach( function(array){
      setText(array)
      setImage(array)
    })
  }
})