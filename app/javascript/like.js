window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // sharesコントローラーの、indexアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "shares" && action === "index"){ 

    const hollowHearts = document.querySelectorAll(".share-index__hollow-heart")
    const hearts = document.querySelectorAll(".share-index__heart")
    const counts = document.querySelectorAll(".share-index__like-count")
    // head内のCSRFトークンを取得。この情報を送らないとActionController::InvalidAuthenticityTokenが出るため。
    const token = document.getElementsByName('csrf-token').item(0).content;

    // 次のfor文は、いいねをつける機能に関するコード
    for(let i = 0; i < hollowHearts.length; i++){
      hollowHearts[i].addEventListener("click", (e) => {
        const shareId = hollowHearts[i].getAttribute("data-share-id")
        const XHR = new XMLHttpRequest();
        XHR.open("POST", `/shares/${shareId}/likes`, true);
        XHR.responseType = "json";
        XHR.setRequestHeader( 'X-CSRF-Token', token );
        XHR.send();
        XHR.onload = () => {
          const create = XHR.response.create
          if (create == 'true'){
            hollowHearts[i].setAttribute("class", "share-index__hollow-heart hidden")
            hearts[i].setAttribute("class", "share-index__heart")
            hearts[i].setAttribute("data-like-id", `${XHR.response.like_id}`)

            counts[i].setAttribute("class", "share-index__like-count colored")
            counts[i].textContent = XHR.response.count
          } else {
            // createに失敗した場合はエラーメッセージを表示
            window.alert(XHR.response.message)
          }

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

    // 次のfor文は、いいねを取り消す機能に関するコード
    for(let i = 0; i < hearts.length; i++){
      hearts[i].addEventListener("click", (e) => {
        const likeId = hearts[i].getAttribute("data-like-id")
        const XHR = new XMLHttpRequest();
        XHR.open("DELETE", `/likes/${likeId}`, true);
        XHR.responseType = "json";
        XHR.setRequestHeader( 'X-CSRF-Token', token );
        XHR.send();
        XHR.onload = () => {
          hearts[i].setAttribute("class", "share-index__heart hidden")
          hollowHearts[i].setAttribute("class", "share-index__hollow-heart")
          
          counts[i].setAttribute("class", "share-index__like-count")
          counts[i].textContent = XHR.response.count

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