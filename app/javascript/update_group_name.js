// 編集ボタンを押すとgroupsテーブルのnameを更新し、問題復習・作成・管理エリアのグループ名も更新後の名前に置き換える関数
function updateGroupName(){
  for(let i = 0; i < 3; i++){
    const submits = document.querySelectorAll(`.group-submit-button-${i}`);
    const editGroupForms= document.querySelectorAll(`.edit-group-form-${i}`);
    const groupPanels = document.querySelectorAll(`.js-group-panel-${i}`)
    for(let j = 0; j < submits.length; j++){
      submits[j].addEventListener("click", (e) => {
        e.preventDefault();
        const formData = new FormData(editGroupForms[j]);
        const XHR = new XMLHttpRequest();
        const groupId = groupPanels[j].getAttribute("group-id");
        XHR.open("POST", `/groups/${groupId}`, true);
        XHR.responseType = "json";
        XHR.send(formData);
        XHR.onload = () => {
          const item = XHR.response.post;
          // グループ編集フォームを隠す
          editGroupForms[j].removeAttribute("style", "display: flex;");
          // グループのパネルを表示させる
          groupPanels[j].removeAttribute("style", "display: none;");
           // 問題復習・作成・管理の3つのエリアのグループ名を更新後の名前に変更
          for(let k = 0; k < 3; k++){
            const groupNames = document.querySelectorAll(`.group-name-${k}`);
            groupNames[j].innerHTML = item.name
          }

          if (XHR.status != 200) {
            alert(`Error ${XHR.status}: ${XHR.statusText}`);
          } else {
            return null;
          }
        }
        XHR.onerror = function () {
          alert("Request failed");
        };
      })
    }
  }
}

window.addEventListener("load", updateGroupName);