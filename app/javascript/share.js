window.addEventListener("load", (e) => {
  const categoryFirsts = document.querySelectorAll(".share-form__category-first")
  const pleaseSelects = document.querySelectorAll(".share-form__please-select")
  const categorySeconds = document.querySelectorAll(".share-form__category-second")
  for(let i = 0; i < categoryFirsts.length; i++){
    categoryFirsts[i].addEventListener("change", (e) => {
      pleaseSelects[i].setAttribute("style", "display: none;")
      categorySeconds[i].setAttribute("style", "display: block;")
    })
  }
})