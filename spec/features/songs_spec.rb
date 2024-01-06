require 'rails_helper'

RSpec.describe '楽曲の投稿機能', type: :feature do
  let(:user) { create(:user) }
  let(:focus_point) { create(:focus_point) }

  before do
    focus_point
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'ログイン'
    visit new_song_path
  end

  describe '新規楽曲の投稿' do
    context '有効な入力で楽曲を投稿する' do
      it '楽曲が正常に投稿される' do
        fill_in '動画URL(YouTubeもしくはニコニコ動画)', with: 'https://www.youtube.com/watch?v=example'
        fill_in 'タイトル', with: 'テスト楽曲'
        fill_in 'アーティスト', with: 'テストアーティスト'
        fill_in '楽曲に使用した音声合成ソフト名', with: 'Vocaloid'
        fill_in 'ジャンル', with: 'ポップ'
        select 'メロディ', from: 'focus_point_id'
        fill_in '楽曲概要', with: 'これはテスト楽曲です。'
        click_button '投稿する'

        expect(page).to have_content('投稿が完了しました')
        expect(page).to have_current_path(songs_path)
        expect(Song.last.title).to eq('テスト楽曲')
      end
    end

    context '無効な入力でエラーを表示する' do
      it 'エラーメッセージが表示される' do
        fill_in 'タイトル', with: ''
        fill_in 'アーティスト', with: ''
        fill_in '動画URL(YouTubeもしくはニコニコ動画)', with: ''
        click_button '投稿する'

        expect(page).to have_css('#error_explanation')
        expect(page).to have_current_path(new_song_path)
      end
    end
  end
end
