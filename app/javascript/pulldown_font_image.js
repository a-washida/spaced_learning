window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、new, create, edit, updateアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "new" ||
                                            action === "create" ||
                                            action ===  "edit" ||
                                            action === "update")){

    pulldownFontOrImageSize()
  
    // プルダウンの項目を選択すると、プレビューエリアのフォントサイズや画像サイズを変化させる関数
    function pulldownFontOrImageSize(){
      // プルダウンの項目を選択すると、プレビューエリアのフォントサイズを変化させる関数式
      const pulldownFontFunction = (questionOrAnswer) => {
        const pulldownElement = document.getElementById(`question_answer_${questionOrAnswer}_option_attributes_font_size_id`)
        // プルダウンの項目を選択することでイベント発火する
        pulldownElement.addEventListener("change", (e) => {
          // 現在選択されているブルダウンの項目が、上から何番目の項目なのかを取得
          const value = pulldownElement.value
          const pulldownOptions = document.querySelectorAll(`#question_answer_${questionOrAnswer}_option_attributes_font_size_id option`);
          // 現在選択されているプルダウンの項目の要素(<option>)を取得
          const chosenDropdownList = pulldownOptions[value - 1];
          const previewTextarea = document.getElementById(`${questionOrAnswer}-preview__textarea`)
          previewTextarea.setAttribute("style", `font-size: ${chosenDropdownList.innerHTML}rem;`)
        })
      }
      pulldownFontFunction("question")
      pulldownFontFunction("answer")

      // プルダウンの項目を選択すると、プレビューエリアの画像サイズを変化させる関数式
      const pulldownImageFunction = (questionOrAnswer) => {
        const pulldownElement = document.getElementById(`question_answer_${questionOrAnswer}_option_attributes_image_size_id`)
        pulldownElement.addEventListener("change", (e) => {
          const value = pulldownElement.value
          const pulldownOptions = document.querySelectorAll(`#question_answer_${questionOrAnswer}_option_attributes_image_size_id option`);
          const chosenDropdownList = pulldownOptions[value - 1];
          // 画像の横幅のデフォルト(200px)に、プルダウンの選択した項目の値をかける
          const imageWidth = 200 * chosenDropdownList.innerHTML
          const previewImage = document.querySelector(`.img-preview-${questionOrAnswer}`)
          previewImage.setAttribute("style", `width: ${imageWidth}px;`)
        })
      }
      pulldownImageFunction("question")
      pulldownImageFunction("answer")
    }
  }
})