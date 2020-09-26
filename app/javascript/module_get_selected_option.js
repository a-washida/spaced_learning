// プルダウンのoption要素の中でselectedされている要素を返り値として返す関数式
const getSelectedOptionInPulldown = (questionOrAnswer, fontOrImage) => {
  const pulldownElement = document.getElementById(`question_answer_${questionOrAnswer}_option_attributes_${fontOrImage}_size_id`)
  // 現在選択されているブルダウンの項目が、上から何番目の項目なのかを取得
  const value = pulldownElement.value
  // プルダウン内のoption要素を全て取得
  const pulldownOptions = document.querySelectorAll(`#question_answer_${questionOrAnswer}_option_attributes_${fontOrImage}_size_id option`);
  // 現在選択されているプルダウンの項目の要素(<option>)を取得
  const selectedOption = pulldownOptions[value - 1];
  return selectedOption
}

module.exports = getSelectedOptionInPulldown;