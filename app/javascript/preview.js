function imagePreview(){
  document.querySelector('.hidden').addEventListener('change', (e) => {
    // 画像が表示されている場合のみ、すでに存在している画像を削除する
    const imageContent = document.querySelector('img');
    if (imageContent){
      imageContent.remove();
    };
    // 以下5行で、取り込んだ画像を表示する<img>要素作成
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    const blobImage = document.createElement('img')
    blobImage.setAttribute('src', blob)
    blobImage.setAttribute("class", "img-preview")

    const previewImage = document.getElementById("preview-image")
    previewImage.appendChild(blobImage)
  });
}

function textareaPreview(){
  const answerInputArea = document.querySelector(".answer-input-area");
  answerInputArea.addEventListener("input", (e) => {
    // 以下3行で、入力したテキストエリアの値を要素内に持つ<div>要素を生成
    const valueElement = document.createElement("div")
    valueElement.setAttribute("id", "data-id")
    valueElement.innerHTML = answerInputArea.value
    const previewTextareaInput = document.getElementById("preview-textarea-input")
    // answerテキストエリアに入力した値のプレビューが表示されている場合のみ、すでに存在しているプレビューを削除する
    const dataId = document.getElementById("data-id")
    if (dataId){
      dataId.remove();
    };
    previewTextareaInput.appendChild(valueElement)
  })
}

window.addEventListener("load", textareaPreview);
window.addEventListener("load", imagePreview);