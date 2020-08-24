function repetition_algorithm() {
  for(let i = 0; i < 4; i++) {
    const clicks = document.querySelectorAll(`.review-option__btn.js-${i}`);
    console.log(clicks);
    clicks.forEach( function(click) {
      const interval = click.getAttribute("data-interval");
      const easinessFactor = click.getAttribute("data-ef");
      const questionAnswerId = click.getAttribute("data-qa-id");
      const repeatCount = click.getAttribute("data-rc");
      const memoryLevel = click.innerHTML
      click.addEventListener("click", (e) => {
        console.log(interval);
        const XHR = new XMLHttpRequest();
        XHR.open("POST", `/repetition_algorithms`, true);
        XHR.responseType = "json";
        XHR.setRequestHeader( 'content-type', 'application/x-www-form-urlencoded;charset=UTF-8' );
        XHR.send(`interval=${interval}&easiness_factor=${easinessFactor}&question_answer_id=${questionAnswerId}&repeat_count=${repeatCount}&memory_level=${memoryLevel}`);
        XHR.onload = () => {
          const item = XHR.response.post;
          console.log(item)
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
    });
  }
};

window.addEventListener("load", repetition_algorithm);