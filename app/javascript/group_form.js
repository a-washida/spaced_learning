function apperForm(){
  const create_group = document.querySelector(".create-group");
  create_group.addEventListener("click", (e) => {
    create_group.setAttribute("style", "display: none")
    const create_group_form = document.querySelector(".create-group-form");
    create_group_form.setAttribute("style", "display: flex");
  })

}

window.addEventListener("load", apperForm);