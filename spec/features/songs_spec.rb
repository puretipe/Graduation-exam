require 'rails_helper'

RSpec.describe '楽曲の投稿機能', type: :feature do
  let(:user) { create(:user) }
  let!(:focus_point) { create(:focus_point, name: 'メロディー') }

  before do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'ログイン'
    visit new_song_path
    expect(page).to have_selector('select#focus_point_id')
  end

  describe '新規楽曲の投稿' do
    context '有効な入力で楽曲を投稿する' do
      it '楽曲が正常に投稿される' do
        fill_in '動画URL(YouTubeもしくはニコニコ動画)', with: 'https://www.youtube.com/watch?v=example'
        fill_in 'タイトル', with: 'テスト楽曲'
        fill_in 'アーティスト', with: 'テストアーティスト'
        fill_in '楽曲に使用した音声合成ソフト名', with: 'Vocaloid'
        fill_in 'ジャンル', with: 'ポップ'
        select 'メロディー', from: 'focus_point_id'
        fill_in '楽曲概要', with: 'これはテスト楽曲です。'
        click_button '投稿する'

        expect(page).to have_content('投稿が完了しました')
        expect(page).to have_current_path(songs_path)
        expect(Song.last.title).to eq('テスト楽曲')
      end
    end

    context '無効な入力でエラーを表示する' do
      it 'エラーメッセージが表示される' do
        click_button '投稿する'
        expect(page).to have_css('#error_explanation')
        expect(page).to have_content('ジャンルを入力してください')
        expect(page).to have_content('こだわりポイントを入力してください')
        expect(page).to have_content('動画URLに入力した楽曲は音声合成ソフトウェアを使用している必要があります。動画のタイトル、概要欄、タグ等に音声合成ソフト関連のワードが含まれているか確認して下さい。')
        expect(page).to have_content('タイトルを入力してください')
        expect(page).to have_content('アーティストを入力してください')
        expect(page).to have_content('動画URLを入力してください')
        expect(page).to have_content('使用したソフト名を入力してください')
        expect(page).to have_current_path(songs_path)
      end
    end
  end
end
