if (window.location.pathname === '/' || '/groups') {
  // グループ作成フォームを画面上に出現させたり画面上から隠したりする関数
  function appearOrHideCreateForm(){
    const createGroup = document.querySelector(".js-create-group");
    const createGroupForm = document.querySelector(".create-group-form");
    // クリックするとフォームが現れる
    createGroup.addEventListener("click", (e) => {
      createGroup.setAttribute("style", "display: none;");
      createGroupForm.setAttribute("style", "display: flex;");
      const closeCreateForm = document.querySelector(".close-create-form");
      // クリックするとフォームが隠れる
      closeCreateForm.addEventListener("click", (e) => {
        createGroup.removeAttribute("style");
        createGroupForm.removeAttribute("style");
      })
    })
  }

  // グループ編集フォームを画面上に出現させたり画面上から隠したりする関数
  function appearOrHideEditForm(){
    // i=0: 問題復習、i=1: 問題作成、i=2: 問題管理
    for(let i = 0; i < 3; i++) {
      const editGroups = document.querySelectorAll(`.js-edit-group-${i}`);
      const groupPanels= document.querySelectorAll(`.js-group-panel-${i}`)
      const editGroupForms = document.querySelectorAll(`.edit-group-form-${i}`);
      const closeEditForms = document.querySelectorAll(`.close-edit-form-${i}`);
      for(let j = 0; j < editGroups.length; j++){
        // クリックするとフォームが現れる
        editGroups[j].addEventListener("click", (e) => {
          groupPanels[j].setAttribute("style", "display: none;");
          editGroupForms[j].setAttribute("style", "display: flex;");
          // クリックするとフォームが隠れる
          closeEditForms[j].addEventListener("click", (e) => {
            groupPanels[j].removeAttribute("style");
            editGroupForms[j].removeAttribute("style");
          })
        })
      }
    }
  }

  window.addEventListener("load", appearOrHideCreateForm);
  window.addEventListener("load", appearOrHideEditForm);
}
