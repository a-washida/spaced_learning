// @media (max-width: 599px)の際に有効で、3つあるタブの内1つをクリックするとタブが切り替わる。
function changeTab(){
  const top_page_tabs = document.querySelectorAll(".top-page-tab");
  for(let i = 0; i < top_page_tabs.length; i++){
    top_page_tabs[i].addEventListener("click", (e) => {
      // クリックしたタブが太字になり、他2つのタブは太字解除
      top_page_tabs.forEach(function(top_page_tab){
        if (top_page_tab.getAttribute("id") == `top-page-tab-${i}`) {
          top_page_tab.setAttribute("style", "font-weight: bold;")
        } else {
          top_page_tab.setAttribute("style", "font-weight: normal;")
        }
      })
      // 問題(作成or復習or管理)タブを押すと問題(作成or復習or管理)エリアが表示され、他2つのエリアは非表示。
      const question_areas = document.querySelectorAll(".question-area");
      question_areas.forEach(function(question_area){
        if (question_area.getAttribute("id") == `question-area-${i}`){
          question_area.setAttribute("style", "display: block;")
        } else {
          question_area.setAttribute("style", "display: none;")
          
        }
      })
    })
  }
}

window.addEventListener("load", changeTab);
// window.addEventListener("load", meronmaron);