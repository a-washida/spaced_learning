window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // sharesコントローラーの、indexアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "shares" && action === "index"){ 

    const likes = document.querySelectorAll(".share-index__hollow-heart")
    const counts = document.querySelectorAll(".share-index__like-count")
    for(let i = 0; i < likes.length; i++){
      likes[i].addEventListener("click", (e) => {
        const shareId = likes[i].getAttribute("data-id")
        const XHR = new XMLHttpRequest();
        XHR.open("POST", `/shares/${shareId}/likes`, true);
        XHR.responseType = "json";
        // head内のCSRFトークンを取得。この情報を送らないとActionController::InvalidAuthenticityTokenが出るため。
        const token = document.getElementsByName('csrf-token').item(0).content;
        XHR.setRequestHeader( 'X-CSRF-Token', token );
        XHR.send();
        XHR.onload = () => {
          // 以下4行で、画面上に新たに表示するimg要素を作成
          const image = document.createElement('img')
          image.setAttribute('src', '/assets/share_index_heart.png')
          image.setAttribute("class", "share-index__heart")
          image.setAttribute("data-id", `${shareId}`)

          likes[i].insertAdjacentElement("afterend", image)
          likes[i].remove()

          counts[i].setAttribute("class", "share-index__like-count--colored")
          counts[i].textContent = XHR.response.post

          if (XHR.status != 200) {
            alert(`Error ${XHR.status}: ${XHR.statusText}`);
          } else {
            return null;
          }
        }
        XHR.onerror = function () {
          alert("Request failed");
        };
        
      })
    }
  }
})