window.addEventListener("load", (e) => {
  const categoryFirst = document.getElementById("select_category_first_id")
  const categorySeconds = document.querySelectorAll(".cs-index__category-second")
  const links = document.querySelectorAll(".cs-index__link")
  categoryFirst.addEventListener("change", (e) => {
    // style属性を削除する関数式
    const removeStyle = (styles) => {
      styles.forEach( function(style){
        if(style.hasAttribute("style")){
          style.removeAttribute("style")
        }
      })
    }
    removeStyle(categorySeconds)
    removeStyle(links)
    const value = categoryFirst.value
    const pleaseSelect = document.querySelector(".cs-index__please-select")
    pleaseSelect.setAttribute("style", "display: none;")
    categorySeconds[value - 1].setAttribute("style", "display: block;")
    categorySeconds[value - 1].addEventListener("change", (e) => {
      removeStyle(links)
      const valueSecond = categorySeconds[value - 1].value
      const hoges = document.querySelectorAll(".cs-index__category-second option")
      const hogehoge = hoges[valueSecond]
      dataId = hogehoge.getAttribute("data-id")
      const link = document.querySelector(`.cs-index__link.num-${dataId}`)
      link.setAttribute("style", "display: block;")
    })
  })
})