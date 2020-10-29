if (window.location.pathname.includes("question_answers/review")){
  // 記憶度の評価ボタンをクリックすると、非同期通信が行われ、サーバー内で計算されたインターバルを表示する関数
  function display_interval_if_memory_level_clicked() {
    // head内のCSRFトークンを取得。この情報を送らないとActionController::InvalidAuthenticityTokenが出るため。
    const token = document.getElementsByName('csrf-token').item(0).content;

    const noticeDisplayDates = document.querySelectorAll(".review-option__notice-display-date")
    for(let i = 0; i < 4; i++) {
      const buttons = document.querySelectorAll(`.review-option__btn.js-${i}`);
      for(let j = 0; j < buttons.length; j++ ){
        // 以下5行はHTMLタグに付与したカスタムデータ属性の値を取得
        const dataId = buttons[j].getAttribute("data-id");
        const interval = buttons[j].getAttribute("data-interval");
        const easinessFactor = buttons[j].getAttribute("data-easiness-factor");
        const repeatCount = buttons[j].getAttribute("data-repeat-count");
        const reviewCount = buttons[j].getAttribute("data-review-count")
        const memoryLevel = buttons[j].innerHTML
        buttons[j].addEventListener("click", (e) => {
          // イベント発火した段階で記憶度ボタンのdata-review-countの値が0に変化していた場合、reviewCountを0にする
          if (buttons[j].getAttribute("data-review-count") == 0){
            reviewCount = 0
          }
          const XHR = new XMLHttpRequest();
          XHR.open("PATCH", `/repetition_algorithms/${dataId}`, true);
          XHR.responseType = "json";
          XHR.setRequestHeader( 'content-type', 'application/x-www-form-urlencoded' );
          XHR.setRequestHeader( 'X-CSRF-Token', token );
          // 5つのデータをparamsに格納してサーバーへ送る
          XHR.send(`interval=${interval}&easiness_factor=${easinessFactor}&repeat_count=${repeatCount}&memory_level=${memoryLevel}&review_count=${reviewCount}`);
          XHR.onload = () => {
            const item = XHR.response.post;
            noticeDisplayDates[j].innerHTML = item
            noticeDisplayDates[j].setAttribute("class", "review-option__notice-display-date")
            // 記憶度ボタンを1回押したら、その問題の押していない他の3つのボタンも含め、4つのボタン全てdata-review-countを0にする。加えてインラインスタイルをリセット。
            for(let k = 0; k < 4; k++){
              const fourButtons = document.querySelectorAll(`.review-option__btn.js-${k}`)[j]
              fourButtons.setAttribute("data-review-count", "0")
              fourButtons.removeAttribute("style")
            }
            // クリックしたボタンにスタイルを適用して見た目を変更
            buttons[j].setAttribute("style", "color: #ffffff; font-weight: bold; background-color: #282c2f;")

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