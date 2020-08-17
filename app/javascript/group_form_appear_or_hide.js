// フォームを画面上に出現させたり画面上から隠したりする関数
function appearOrHideForm(){
  const create_group = document.querySelector(".js-create-group");
  const create_group_form = document.querySelector(".create-group-form");
  // クリックするとフォームが現れる
  create_group.addEventListener("click", (e) => {
    create_group.setAttribute("style", "display: none;");
    create_group_form.setAttribute("style", "display: flex;");
    const close_group_form = document.querySelector(".close-group-form");
    // クリックするとフォームが隠れる
    close_group_form.addEventListener("click", (e) => {
      create_group.removeAttribute("style", "display: none;");
      create_group_form.removeAttribute("style", "display: flex;");
    })
  })
}
window.addEventListener("load", appearOrHideForm);