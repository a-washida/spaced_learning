window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // question_answersコントローラーの、indexアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "question_answers" && action === "index"){ 

    const categoryFirsts = document.querySelectorAll(".share-form__category-first")
    const pleaseSelects = document.querySelectorAll(".share-form__please-select")
    const categorySeconds = document.querySelectorAll(".share-form__category-second")
    const inserts = document.querySelectorAll(".share-form__insert")
    for(let i = 0; i < categoryFirsts.length; i++){
      categoryFirsts[i].addEventListener("change", (e) => {
        pleaseSelects[i].setAttribute("style", "display: none;")
        categorySeconds[i].setAttribute("style", "display: block;")
        // 以下の非同期通信で、選択したカテゴリー1に属するカテゴリー2の一覧を取得して変数resultsに代入する
        const value = categoryFirsts[i].value
        const XHR = new XMLHttpRequest();
        XHR.open("GET", `question_answers/${i+1}/search_category/?category_first=${value}`, true);
        XHR.responseType = "json";
        XHR.send();
        XHR.onload = () => {
          const results = XHR.response.result
          inserts[i].innerHTML = ''
          results.forEach( function(result){
            const childElement = document.createElement('div')
            childElement.setAttribute('class', `share-form__search-result`)
            childElement.textContent = result.name
            inserts[i].insertAdjacentElement("beforeend", childElement)
            childElement.addEventListener("click", (e) => {
              categorySeconds[i].value = childElement.textContent
            })
          })
          if (XHR.status != 200) {
            alert(`Error ${XHR.status}: ${XHR.statusText}`);
          } else {
            return null;
          }
        }
        XHR.onerror = () => {
          alert("Request failed");
        }
      })
    }
  }
})