require 'rails_helper'

RSpec.describe '楽曲の検索機能', type: :feature do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'ログイン'
  end

  describe '楽曲を検索する' do
    context '有効な検索クエリを使用する' do
      it '期待される楽曲が表示される' do
        visit songs_path
        fill_in 'search-field-id', with: '検索クエリ'
        click_button '検索'
        expect(page).to have_content('期待される楽曲名')
      end
    end

    context '無効な検索クエリを使用する' do
      it '楽曲が見つからない旨が表示される' do
        visit songs_path
        fill_in 'search-field-id', with: '存在しない楽曲名'
        click_button '検索'
        expect(page).to have_content('楽曲が見つかりませんでした')
      end
    end
  end
end
