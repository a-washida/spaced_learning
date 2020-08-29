if (window.location.pathname === '/' || window.location.pathname === '/groups') {
  // @media (max-width: 599px)の際に有効で、3つあるタブの内1つをクリックするとタブが切り替わる。
  function changeTab(){
    const topTabs = document.querySelectorAll(".top-tab__item");
    for(let i = 0; i < topTabs.length; i++){
      topTabs[i].addEventListener("click", (e) => {
        // クリックしたタブが太字になり、他2つのタブは太字解除
        topTabs.forEach(function(topTab){
          if (topTab.getAttribute("id") == `top-page-tab-${i}`) {
            topTab.setAttribute("style", "font-weight: bold;")
          } else {
            topTab.setAttribute("style", "font-weight: normal;")
          }
        })
        // 問題(作成or復習or管理)タブを押すと問題(作成or復習or管理)エリアが表示され、他2つのエリアは非表示。
        const questionAreas = document.querySelectorAll(".top-question-area");
        questionAreas.forEach(function(questionArea){
          if (questionArea.getAttribute("id") == `question-area-${i}`){
            questionArea.setAttribute("style", "display: block;")
          } else {
            questionArea.setAttribute("style", "display: none;")
            
          }
        })
      })
    }
  }

  // 画面幅が599px(ブレイクポイント)を通過した際に、JavaScriptで付与されたインラインスタイルを削除して初期状態のレイアウトに戻す関数
  const checkBreakPoint = (mql) => {
    const questionAreas = document.querySelectorAll(".top-question-area");
    const topTabs = document.querySelectorAll(".top-tab__item");
    for(let i = 0; i < questionAreas.length; i++) {
      questionAreas[i].removeAttribute("style")
      topTabs[i].removeAttribute("style")
    }
  }

  // MediaQueryListオブジェクトを変数mqlに代入
  const mql = window.matchMedia('(max-width: 599px)');
  // ブレイクポイントの瞬間に発火
  mql.addListener(checkBreakPoint);

  // 初回チェック必要なさそうなので、とりあえずコメントアウト
  // checkBreakPoint(mql);

  window.addEventListener("load", changeTab);
}