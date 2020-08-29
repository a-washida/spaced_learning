if (window.location.pathname === '/' || window.location.pathname === '/groups') {
  // 編集ボタンを押すとgroupsテーブルのnameを更新し、問題復習・作成・管理エリアのグループ名も更新後の名前に置き換える関数
  function updateGroupName(){
    for(let i = 0; i < 3; i++){
      const submits = document.querySelectorAll(`.top-form-edit__sumbit-btn.js-${i}`);
      const editGroupForms= document.querySelectorAll(`.top-form-edit.js-${i}`);
      const groupPanels = document.querySelectorAll(`.group-panel.js-${i}`)
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
            // グループ名を空白で更新しようとした場合にalertを出す
            if (item.name == ""){
              alert("グループ名を入力して下さい")
            } else {
              // グループ編集フォームを隠す
              editGroupForms[j].removeAttribute("style", "display: flex;");
              // グループのパネルを表示させる
              groupPanels[j].removeAttribute("style", "display: none;");
              // 問題復習・作成・管理の3つのエリアのグループ名を更新後の名前に変更
              for(let k = 0; k < 3; k++){
                const groupNames = document.querySelectorAll(`.group-panel__name-${k}`);
                groupNames[j].innerHTML = item.name
              }
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

          e.preventDefault();
          
        })
      }
    }
  }

  window.addEventListener("load", updateGroupName);
}