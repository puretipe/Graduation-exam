require 'rails_helper'

RSpec.describe 'User authentication', type: :feature do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  before do
    user
    visit root_path
  end

  describe 'ログイン' do
    it '有効な情報でログイン' do
      click_link 'ログイン'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'ログイン'

      expect(page).to have_content('ログアウト')
      expect(page).to have_current_path(root_path)
    end

    it '無効な情報でログイン' do
      click_link 'ログイン'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'wrongpassword'
      click_button 'ログイン'

      expect(page).to have_content('ログイン')
      expect(page).to have_current_path(user_session_path)
      expect(page).to have_content('ログインに失敗しました')
    end
  end

  describe 'ログアウト' do
    it 'ログアウトする' do
      # ユーザーをログイン状態にする
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'ログイン'

      click_link 'ログアウト'
      expect(page).to have_content('ログイン')
      expect(page).to have_current_path(root_path)
    end
  end
end
