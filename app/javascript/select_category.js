window.addEventListener("load", (e) => {
  const controller = document.querySelector("body").getAttribute("data-controller")
  const action = document.querySelector("body").getAttribute("data-action")
  // category_secondsコントローラーの、indexアクションによって遷移してきたページのみで以下のコードを実行
  if (controller === "category_seconds" && action === "index"){

    const categoryFirst = document.getElementById("select_category_first_id")
    const categorySeconds = document.querySelectorAll(".cs-index__category-second")
    const links = document.querySelectorAll(".cs-index__link")
    categoryFirst.addEventListener("change", (e) => {
      // style属性を削除する関数式
      const removeStyle = (elements) => {
        elements.forEach( function(element){
          if(element.hasAttribute("style")){
            element.removeAttribute("style")
          }
        })
      }
      removeStyle(categorySeconds)
      removeStyle(links)
      const value = categoryFirst.value
      const pleaseSelect = document.querySelector(".cs-index__please-select")
      // カテゴリー1のプルダウンで「選択してください」が選択された場合、次のif文を実行
      if (value === ""){
        pleaseSelect.removeAttribute("style")
      }
      // カテゴリー1のプルダウンで「選択してください」以外が選択された場合、次のif文内のコードを実行
      if (value > 0){
        pleaseSelect.setAttribute("style", "display: none;")
        // categorySeconds[value - 1]は、カテゴリー1で選択したoption要素に属するカテゴリー2のプルダウン要素
        categorySeconds[value - 1].setAttribute("style", "display: block;")

        // カテゴリー2で選択しているoption要素に対応したリンクを画面上に表示させる関数式
        const appearLink = () => {
          // カテゴリー2のプルダウンで「選択してください」以外が選択されている場合、次のif文内のコードを実行
          if(categorySeconds[value - 1].value > 0){
            // カテゴリー2のoption要素を全て取得
            const categorySecondOptions = document.querySelectorAll(`.cs-index__category-second.num-${value - 1} option`)
            // カテゴリー2で選択されているoption要素を変数selectedOptionに代入
            const selectedOption = categorySecondOptions[categorySeconds[value - 1].value]
            // option要素にdata-id属性としてcategory_secondsテーブルのidの値が割り当てられているので取得
            const dataId = selectedOption.getAttribute("data-id")
            const link = document.querySelector(`.cs-index__link.num-${dataId}`)
            link.setAttribute("style", "display: block;")
          }
        }
        
        appearLink()
        
        categorySeconds[value - 1].addEventListener("change", (e) => {
          removeStyle(links)
          appearLink()
        })
      }
    })
  }
})