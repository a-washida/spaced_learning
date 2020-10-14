window.addEventListener("load", (e) => {
  const categoryFirst = document.getElementById("category_second_category_first_id")
  categoryFirst.addEventListener("change", (e) => {
    const pleaseSelect = document.querySelector(".share-form__please-select")
    const categorySecond = document.querySelector(".share-form__category-second")
    pleaseSelect.setAttribute("style", "display: none;")
    categorySecond.setAttribute("style", "display: block;")
  })
})