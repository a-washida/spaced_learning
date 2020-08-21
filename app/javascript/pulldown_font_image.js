function pulldownFontOrImageSize(){
  
  const pulldownFontFunction = (questionOrAnswer) => {
    const pulldownElement = document.getElementById(`question_answer_with_option_${questionOrAnswer}_font_size_id`)
    pulldownElement.addEventListener("change", (e) => {
      const value = pulldownElement.value
      const pulldownOptions = document.querySelectorAll(`#question_answer_with_option_${questionOrAnswer}_font_size_id option`);
      const chosenDropdownList = pulldownOptions[value - 1];
      const previewTextarea = document.getElementById(`insert-preview-${questionOrAnswer}-textarea`)
      previewTextarea.setAttribute("style", `font-size: ${chosenDropdownList.innerHTML}px;`)
    })
  }
  pulldownFontFunction("question")
  pulldownFontFunction("answer")

  const pulldownImageFunction = (questionOrAnswer) => {
    const pulldownElement = document.getElementById(`question_answer_with_option_${questionOrAnswer}_image_size_id`)
    pulldownElement.addEventListener("change", (e) => {
      const value = pulldownElement.value
      const pulldownOptions = document.querySelectorAll(`#question_answer_with_option_${questionOrAnswer}_image_size_id option`);
      const chosenDropdownList = pulldownOptions[value - 1];
      const previewImage = document.querySelector(`.img-preview-${questionOrAnswer}`)
      const imageWidth = 200 * chosenDropdownList.innerHTML
      previewImage.setAttribute("style", `width: ${imageWidth}px;`)
    })
  }
  pulldownImageFunction("question")
  pulldownImageFunction("answer")

  
}

window.addEventListener("load", pulldownFontOrImageSize);