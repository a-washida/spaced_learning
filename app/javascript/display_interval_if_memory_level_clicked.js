if (window.location.pathname.includes("question_answers/review")){
  // 記憶度の評価ボタンをクリックすると、非同期通信が行われ、サーバー内で計算されたインターバルを表示する関数
  function display_interval_if_memory_level_clicked() {
    const noticeDisplayDates = document.querySelectorAll(".review-option__notice-display-date")
    for(let i = 0; i < 4; i++) {
      const clicks = document.querySelectorAll(`.review-option__btn.js-${i}`);
      for(let j = 0; j < clicks.length; j++ ){
        // 以下4行はHTMLタグに付与したカスタムデータ属性の値を取得
        const interval = clicks[j].getAttribute("data-interval");
        const easinessFactor = clicks[j].getAttribute("data-ef");
        const questionAnswerId = clicks[j].getAttribute("data-qa-id");
        const repeatCount = clicks[j].getAttribute("data-rc");
        const memoryLevel = clicks[j].innerHTML
        clicks[j].addEventListener("click", (e) => {
          const XHR = new XMLHttpRequest();
          XHR.open("POST", `/repetition_algorithms`, true);
          XHR.responseType = "json";
          XHR.setRequestHeader( 'content-type', 'application/x-www-form-urlencoded;charset=UTF-8' );
          // 5つのデータをparamsに格納してサーバーへ送る
          XHR.send(`interval=${interval}&easiness_factor=${easinessFactor}&question_answer_id=${questionAnswerId}&repeat_count=${repeatCount}&memory_level=${memoryLevel}`);
          XHR.onload = () => {
            const item = XHR.response.post;
            noticeDisplayDates[j].innerHTML = item
            noticeDisplayDates[j].setAttribute("class", `review-option__notice-display-date js-${i}`)
            if (XHR.status != 200) {
              alert(`Error ${XHR.status}: ${XHR.statusText}`);
            } else {
              return null;
            }
          }
          XHR.onerror = () => {
            alert("Request failed");
          };
        });
      }
    };
  };

  window.addEventListener("load", display_interval_if_memory_level_clicked);
}