window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、new, create, edit, updateアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "new" ||
                                            action === "create" ||
                                            action ===  "edit" ||
                                            action === "update")){

    // モジュールを読み込むことで、プルダウンでselectedされているoption要素を返す関数式を、変数に代入
    const getSelectedOptionInPulldown = require('./module_get_selected_option.js')

    // プルダウンのselectedされているoption要素の値を用いて、プレビューエリアのフォントサイズを変更する関数式
    const changeFontSize = (questionOrAnswer) => {
      const pulldownElement = document.getElementById(`question_answer_${questionOrAnswer}_option_attributes_font_size_id`)
      pulldownElement.addEventListener("change", (e) => {
        selectedOption = getSelectedOptionInPulldown(questionOrAnswer, "font")
        const previewTextarea = document.getElementById(`${questionOrAnswer}-preview__textarea`)
        previewTextarea.setAttribute("style", `font-size: ${selectedOption.innerHTML}rem;`)
      })
    }

     // プルダウンのselectedされているoption要素の値を用いて、プレビューエリアの画像サイズを変更する関数式
    const changeImageSize = (questionOrAnswer) => {
      const pulldownElement = document.getElementById(`question_answer_${questionOrAnswer}_option_attributes_image_size_id`)
      pulldownElement.addEventListener("change", (e) => {
        selectedOption = getSelectedOptionInPulldown(questionOrAnswer, "image")
        // 画像の横幅のデフォルト(200px)に、プルダウンの選択した項目の値をかける
        const imageWidth = 200 * selectedOption.innerHTML
        const previewImage = document.querySelector(`.img-preview-${questionOrAnswer}`)
        if (previewImage !== null) {
          previewImage.setAttribute("style", `width: ${Math.floor(imageWidth)}px;`)
        }
      })
    }

    // 関数式を実行
    arrays = ["question", "answer"]
    arrays.forEach( function(array){
      changeFontSize(array)
      changeImageSize(array)
    })
    
  }
})