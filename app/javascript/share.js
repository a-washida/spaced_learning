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

        categorySeconds[i].addEventListener("click", (e) => {
          // 以下の非同期通信で、選択したカテゴリー1に属するカテゴリー2の一覧を取得して変数resultsに代入する
          const value = categoryFirsts[i].value
          const XHR = new XMLHttpRequest();
          XHR.open("GET", `/search_category/?category_first=${value}`, true);
          XHR.responseType = "json";
          XHR.send();
          XHR.onload = () => {
            const results = XHR.response.result
            // inserts[i]に挿入した子要素を全て削除する関数式を定義
            const deleteChild = () => {
              while(inserts[i].firstChild){
                inserts[i].removeChild(inserts[i].firstChild)
              }
            }
            deleteChild()
            // inserts[i].innerHTML = ''
            results.forEach( function(result){
              const childElement = document.createElement('div')
              childElement.setAttribute('class', `share-form__search-result`)
              childElement.textContent = result.name
              inserts[i].insertAdjacentElement("beforeend", childElement)
              
              // マウスカーソルが要素に乗っている場合のみ、その要素のtextContentがカテゴリー2の入力欄に入力された状態として表示する
              childElement.addEventListener("mouseover", (e) => {
                const valueCategorySecond = categorySeconds[i].value
                categorySeconds[i].value = childElement.textContent
                categorySeconds[i].setAttribute("style", "display: block; background-color: rgba(0,128,255,.1);")
                childElement.addEventListener("mouseout", (e) => {
                  categorySeconds[i].value = valueCategorySecond
                  categorySeconds[i].setAttribute("style", "display: block;")
                })
              })
              // クリックすると、その要素のtextContentをカテゴリー2の入力欄に入力し、検索結果のリスト(inserts[i]の子要素)を削除
              childElement.addEventListener("click", (e) => {
                categorySeconds[i].value = childElement.textContent
                categorySeconds[i].focus()
                categorySeconds[i].setAttribute("style", "display: block;")
                // while(inserts[i].firstChild){
                //   inserts[i].removeChild(inserts[i].firstChild)
                // }
                deleteChild()
              })

              categorySeconds[i].addEventListener("blur", (e) => {

                // childElementのclickイベントよりもcategorySeconds[i]のblurイベントが先に実行されてしまうので10ミリ秒のディレイを設定
                setTimeout(deleteChild, 10)
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


      })
    }
  }
})