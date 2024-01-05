require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  before do
    visit new_user_path
  end

  describe '新規登録' do
    context '有効な情報を入力した場合' do
      it '新規登録が成功する' do
        fill_in 'ユーザー名', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'

        click_button '登録'

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content('登録が完了しました')
      end
    end

    context '無効な情報を入力した場合' do
      it '新規登録が失敗する' do
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: 'user@invalid'
        fill_in 'パスワード', with: 'foo'
        fill_in '確認用パスワード', with: 'bar'

        click_button '登録'

        expect(page).to have_current_path(users_path)
        expect(page).to have_content('登録に失敗しました')
      end
    end
  end
end