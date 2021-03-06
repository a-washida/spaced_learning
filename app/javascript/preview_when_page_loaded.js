  // 問題編集ページを読み込んだ時やrender 'new', render 'edit'で再表示した時、プレビューエリアの表示が問題作成時と同じ見た目になるように以下のコードを記述
window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、create, edit, updateアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "edit" ||
                                            action === "update" ||
                                            action === "create")){

    // モジュールを読み込むことで、プルダウンでselectedされているoption要素を返す関数式を、変数に代入
    const getSelectedOptionInPulldown = require('./module_get_selected_option.js')

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
        // checkboxと紐付けるために、label要素を生成して変数destroyに代入
        const destroy = document.createElement("label")
        destroy.innerText = '画像を削除'
        destroy.setAttribute("class", `${questionOrAnswer}-preview__img-destroy`)
        destroy.setAttribute("for", `qa-form__${questionOrAnswer}-checkbox`)
        insertImage.insertAdjacentElement('beforeend', destroy)
        // destroyに、クリックするとボタンの見た目を変更するイベントを追加
        destroy.addEventListener("click", (e) => {
          if (destroy.getAttribute("data-clicked") == null){
            destroy.setAttribute("data-clicked", "true")
            destroy.setAttribute("style", "background-color: #282c2f; color: #fff;")
          } else {
            destroy.removeAttribute("data-clicked")
            destroy.removeAttribute("style")
          }
        })
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