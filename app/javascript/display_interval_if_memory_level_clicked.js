if (window.location.pathname.includes("question_answers/review")){
  // 記憶度の評価ボタンをクリックすると、非同期通信が行われ、サーバー内で計算されたインターバルを表示する関数
  function display_interval_if_memory_level_clicked() {
    const noticeDisplayDates = document.querySelectorAll(".review-option__notice-display-date")
    for(let i = 0; i < 4; i++) {
      const buttons = document.querySelectorAll(`.review-option__btn.js-${i}`);
      for(let j = 0; j < buttons.length; j++ ){
        // 以下5行はHTMLタグに付与したカスタムデータ属性の値を取得
        const interval = buttons[j].getAttribute("data-interval");
        const easinessFactor = buttons[j].getAttribute("data-easiness-factor");
        const questionAnswerId = buttons[j].getAttribute("data-qa-id");
        const repeatCount = buttons[j].getAttribute("data-repeat-count");
        const reviewCount = buttons[j].getAttribute("data-review-count")
        const memoryLevel = buttons[j].innerHTML
        buttons[j].addEventListener("click", (e) => {
          // イベント発火した段階で記憶度ボタンのdata-review-countの値が0に変化していた場合、reviewCountを0にする
          if (buttons[j].getAttribute("data-review-count") == 0){
            reviewCount = 0
          }
          const XHR = new XMLHttpRequest();
          XHR.open("POST", `/repetition_algorithms`, true);
          XHR.responseType = "json";
          XHR.setRequestHeader( 'content-type', 'application/x-www-form-urlencoded;charset=UTF-8' );
          // 6つのデータをparamsに格納してサーバーへ送る
          XHR.send(`interval=${interval}&easiness_factor=${easinessFactor}&question_answer_id=${questionAnswerId}&repeat_count=${repeatCount}&memory_level=${memoryLevel}&review_count=${reviewCount}`);
          XHR.onload = () => {
            const item = XHR.response.post;
            noticeDisplayDates[j].innerHTML = item
            noticeDisplayDates[j].setAttribute("class", `review-option__notice-display-date js-${i}`)
            // 記憶度ボタンを1回押したら、その問題の押していない他の3つのボタンも含め、4つのボタン全てdata-review-countを0にする
            for(let k = 0; k < 4; k++){
              const fourButtons = document.querySelectorAll(`.review-option__btn.js-${k}`)[j]
              fourButtons.setAttribute("data-review-count", "0")
            }
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