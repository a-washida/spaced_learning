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
require("../preview_if_text_or_image_input")
require("../change_font_or_image_size_by_pulldown.js")
require("../preview_when_page_loaded.js")
require("../answer_appear.js")
require("../display_interval_if_memory_level_clicked.js")
require("../zoom_image.js")
require("../share.js")
require("../select_category.js")
// 挙動確認用。アプリリリース時には削除
require("../change_date")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
