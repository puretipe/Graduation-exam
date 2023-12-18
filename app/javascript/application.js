import "@hotwired/turbo-rails"
import "bootstrap"
import './video_preview'
import "./image_preview"
import Rails from "@rails/ujs";
Rails.start();

document.addEventListener('turbo:load', () => {
  $('#search-field-id').autocomplete({
    source: '/autocompletes/songs',
    minLength: 2,
    select: function(event, ui) {
      // オプション: 選択された項目に基づくアクション
      console.log("Selected: " + ui.item.label);
    }
  });
});