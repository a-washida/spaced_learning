// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("../top_page_tab.js")
require("../group_form_appear_or_hide.js")
require("../update_group_name.js")
require("../preview")
require("../pulldown_font_image.js")
require("../preview_when_edit_page_loaded.js")
require("../answer_appear.js")
require("../display_interval_if_memory_level_clicked.js")
// 挙動確認用。アプリリリース時には削除
require("../change_date")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
