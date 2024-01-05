FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    salt { "as8s8df8sd" }
    crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("password", salt) }
  end
end