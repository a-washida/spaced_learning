function imagePreview(){
  const hiddenFileFields = document.querySelectorAll('.hidden')
  const arrays = ["question", "answer"] 
  for(let i = 0; i < 2; i++){
    hiddenFileFields[i].addEventListener('change', (e) => {
      // 画像を取り込むと、その画像をプレビュー表示する関数式
      const questionOrAnswerImagePreview = (questionOrAnswer) => {
        // 画像が表示されている場合のみ、すでに存在している画像を削除する
        const imageContent = document.querySelector(`.img-preview-${questionOrAnswer}`);
        if (imageContent){
          imageContent.remove();
        };
        // 以下5行で、取り込んだ画像を表示する<img>要素作成
        const file = e.target.files[0];
        const blob = window.URL.createObjectURL(file);
        const blobImage = document.createElement('img')
        blobImage.setAttribute('src', blob)
        blobImage.setAttribute("class", `img-preview-${questionOrAnswer}`)

        const previewImage = document.getElementById(`insert-preview-image-${questionOrAnswer}`)
        previewImage.appendChild(blobImage)
      }

      questionOrAnswerImagePreview(arrays[i]);
    });
  }
}

function textareaPreview(){
  const InputTextareas = document.querySelectorAll(".input-textarea");
  const arrays = ["question", "answer"] 
  for(let i = 0; i < 2; i++){
    InputTextareas[i].addEventListener("input", (e) => {

      // テキストエリアに入力すると、その値をプレビュー表示する関数式
      const questionOrAnswerTextareaPreview = (questionOrAnswer) => {
      // 以下3行で、入力したテキストエリアの値を要素内に持つ<div>要素を生成
      const valueElement = document.createElement("div")
      valueElement.setAttribute("id", `data-${questionOrAnswer}-id`)
      valueElement.innerHTML = InputTextareas[i].value
      const previewTextareaInput = document.getElementById(`insert-preview-${questionOrAnswer}-textarea`)
      // answerテキストエリアに入力した値のプレビューが表示されている場合のみ、すでに存在しているプレビューを削除する
      const dataId = document.getElementById(`data-${questionOrAnswer}-id`)
      if (dataId){
        dataId.remove();
      };
      previewTextareaInput.appendChild(valueElement)
      }

      questionOrAnswerTextareaPreview(arrays[i])
    })
  }
}

window.addEventListener("load", textareaPreview);
window.addEventListener("load", imagePreview);