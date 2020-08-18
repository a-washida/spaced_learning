// このファイルは保留、余裕があった場合に追加実装する

// 作成ボタンをクリックするとグループが作成し、問題復習・作成・管理エリアに作成したグループを追加する関数
function createGroup(){
  const submit = document.querySelector(".group-submit-button");
  submit.addEventListener("click", (e) => {
    e.preventDefault();
    const createGroupForm = document.querySelector(".create-group-form");
    const formData = new FormData(createGroupForm);
    const XHR = new XMLHttpRequest();
    XHR.open("POST", "/groups/", true);
    XHR.responseType = "json";
    XHR.send(formData);
    XHR.onload = () => {
      const item = XHR.response.post;
      const inserts = document.querySelectorAll(".insert-group-panel");
      // i=0: 問題復習、i=1: 問題作成、 i=2: 問題管理エリアにHTMLを追加
      for(let i = 0; i < 3; i++){
        const HTML = `
        <div class='group-panel js-group-panel-${i}' group-id=${item.id}>
          <div class="group-name-${i}">
            ${item.name}
          </div>
          <div class="js-edit-group-${i}">
            ?
          </div>
        </div>
        `
        inserts[i].insertAdjacentHTML("afterbegin", HTML);
      }
      createGroupForm.removeAttribute("style");
      const create_group = document.querySelector(".js-create-group");
      create_group.removeAttribute("style");
    }
  })
}

window.addEventListener("load", createGroup);