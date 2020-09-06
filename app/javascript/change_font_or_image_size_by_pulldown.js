window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、new, create, edit, updateアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "new" ||
                                            action === "create" ||
                                            action ===  "edit" ||
                                            action === "update")){

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
          previewImage.setAttribute("style", `width: ${imageWidth}px;`)
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