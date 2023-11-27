import $ from 'jquery';
window.$ = $;
window.jQuery = $;
import 'jquery-ui/ui/widgets/autocomplete'
import "@hotwired/turbo-rails"
import "bootstrap"
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