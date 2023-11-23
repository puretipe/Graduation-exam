import $ from 'jquery';
window.jQuery = $;
window.$ = $;
import "@hotwired/turbo-rails"
import "bootstrap"
import 'jquery-ui/ui/widgets/autocomplete'
import './video_preview'

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