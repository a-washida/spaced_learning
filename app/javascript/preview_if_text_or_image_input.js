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

    imagePreview()
    textareaPreview()

    // 問題欄もしくは解答欄で画像を取り込んだ場合に、その画像をプレビュー表示する関数
    function imagePreview(){
      const hiddenFileFields = document.querySelectorAll('.hidden')
      const arrays = ["question", "answer"] 
      for(let i = 0; i < 2; i++){
        hiddenFileFields[i].addEventListener('change', (e) => {
          // 画像を取り込むと、その画像をプレビュー表示する関数式
          const questionOrAnswerImagePreview = (questionOrAnswer) => {
            const previewImage = document.getElementById(`${questionOrAnswer}-preview__img`);
            // previewImageに子要素が存在する場合、全て削除する(画像と削除ボタンの2つが存在する場合がある)
            while (previewImage.firstChild){
              previewImage.removeChild(previewImage.firstChild);
            };

            // 以下5行で、取り込んだ画像を表示する<img>要素作成
            const file = e.target.files[0];
            const blob = window.URL.createObjectURL(file);
            const blobImage = document.createElement('img')
            blobImage.setAttribute('src', blob)
            blobImage.setAttribute("class", `img-preview-${questionOrAnswer}`)
            // img要素に、プルダウンで選択されている値を考慮したwidthを設定
            const selectedOption = getSelectedOptionInPulldown(questionOrAnswer, "image")
            blobImage.setAttribute("style", `width: ${Math.floor(200 * selectedOption.innerHTML)}px;`)

            previewImage.appendChild(blobImage)
          }

          questionOrAnswerImagePreview(arrays[i]);
        });
      }
    }

    // 問題欄もしくは解答欄にテキストを入力すると、その値をプレビュー表示する関数
    function textareaPreview(){
      const InputTextareas = document.querySelectorAll(".qa-form__textarea");
      const arrays = ["question", "answer"] 
      for(let i = 0; i < 2; i++){
        InputTextareas[i].addEventListener("input", (e) => {
          // テキストエリアに入力すると、その値をプレビュー表示する関数式
          const questionOrAnswerTextareaPreview = (questionOrAnswer) => {
          const previewTextarea = document.getElementById(`${questionOrAnswer}-preview__textarea`)
          // previewTextareaInputにinnerHTMLが存在するなら削除する
          if (previewTextarea.innerHTML) {
            previewTextarea.innerHTML = ""
          }
          previewTextarea.textContent = InputTextareas[i].value
          }
          questionOrAnswerTextareaPreview(arrays[i])
        })
      }
    }
  }
})