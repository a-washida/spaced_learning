// グループ作成フォームを画面上に出現させたり画面上から隠したりする関数
function appearOrHideCreateForm(){
  const create_group = document.querySelector(".js-create-group");
  const create_group_form = document.querySelector(".create-group-form");
  // クリックするとフォームが現れる
  create_group.addEventListener("click", (e) => {
    create_group.setAttribute("style", "display: none;");
    create_group_form.setAttribute("style", "display: flex;");
    const close_create_form = document.querySelector(".close-create-form");
    // クリックするとフォームが隠れる
    close_create_form.addEventListener("click", (e) => {
      create_group.removeAttribute("style");
      create_group_form.removeAttribute("style");
    })
  })
}

// グループ編集フォームを画面上に出現させたり画面上から隠したりする関数
function appearOrHideEditForm(){
  // i=0: 問題復習、i=1: 問題作成、i=2: 問題管理
  for(let i = 0; i < 3; i++) {
    const edit_group_i = document.querySelectorAll(`.js-edit-group-${i}`);
    const group_panel_i= document.querySelectorAll(`.js-group-panel-${i}`)
    const edit_group_form_i = document.querySelectorAll(`.edit-group-form-${i}`);
    const close_edit_form_i = document.querySelectorAll(`.close-edit-form-${i}`);
    for(let j = 0; j < edit_group_i.length; j++){
      // クリックするとフォームが現れる
      edit_group_i[j].addEventListener("click", (e) => {
        group_panel_i[j].setAttribute("style", "display: none;");
        edit_group_form_i[j].setAttribute("style", "display: flex;");
        // クリックするとフォームが隠れる
        close_edit_form_i[j].addEventListener("click", (e) => {
          group_panel_i[j].removeAttribute("style");
          edit_group_form_i[j].removeAttribute("style");
        })
      })
    }
  }
}

window.addEventListener("load", appearOrHideCreateForm);
window.addEventListener("load", appearOrHideEditForm);