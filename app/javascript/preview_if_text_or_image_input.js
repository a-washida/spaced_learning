window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、new, create, edit, updateアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && (action === "new" ||
                                            action === "create" ||
                                            action ===  "edit" ||
                                            action === "update")){

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
            const imageContent = document.querySelector(`.img-preview-${questionOrAnswer}`);
            let imageElement = ""
            if (imageContent){
              if(imageContent.hasAttribute("style")){
                // もし画像が存在し、さらにstyle属性を持つならば、styleの属性値を変数imageElementに代入
                imageElement = imageContent.getAttribute("style")
              }
              // 画像がブラウザ上に存在する場合のみ、すでに存在している画像を削除する
              imageContent.remove();
            };

            // 以下5行で、取り込んだ画像を表示する<img>要素作成
            const file = e.target.files[0];
            const blob = window.URL.createObjectURL(file);
            const blobImage = document.createElement('img')
            blobImage.setAttribute('src', blob)
            blobImage.setAttribute("class", `img-preview-${questionOrAnswer}`)
            // もしimageElementの値が存在するなら、上記で作成した<img>要素にstyle属性とその属性値としてimageElementを追加
            if (imageElement){
              blobImage.setAttribute("style", `${imageElement}`)
            }

            const previewImage = document.getElementById(`${questionOrAnswer}-preview__img`)
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