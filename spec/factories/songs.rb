FactoryBot.define do
  factory :song do
    title { "テストの曲" }
    artist { "テストアーティスト" }
    embed_url { "https://www.youtube.com/watch?v=example" }
    software_name { "Vocaloid" }
    description { "これはテスト楽曲です。" }
    thumbnail_url { "http://example.com/thumbnail.jpg" }
    user
    genre
    focus_point
  end
end