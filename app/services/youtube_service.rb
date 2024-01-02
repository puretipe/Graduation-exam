require 'net/http'
require 'json'
require 'cgi'
require 'uri'

class YoutubeService
  YOUTUBE_API_BASE_URL = "https://www.googleapis.com/youtube/v3/videos".freeze

  def self.get_thumbnail_url(embed_url)
    data = fetch_youtube_data(embed_url)
    data.dig('items', 0, 'snippet', 'thumbnails', 'high', 'url')
  end

  def self.get_video_info(embed_url)
    data = fetch_youtube_data(embed_url)
    return unless data && data['items'].any?

    snippet = data['items'].first['snippet']
    {
      title: snippet['title'],
      description: snippet['description'],
      tags: snippet['tags']
    }
  rescue => e
    Rails.logger.error "Error fetching video info from YouTube: #{e.message}"
    nil
  end

  def self.extract_youtube_id(url)
    CGI.parse(URI(url).query)['v'].first
  rescue
    nil
  end

  private

  def self.fetch_youtube_data(embed_url)
    youtube_id = extract_youtube_id(embed_url)
    return if youtube_id.blank?

    uri = URI(YOUTUBE_API_BASE_URL)
    params = {
      id: youtube_id,
      key: ENV['YOUTUBE_API_KEY'],
      part: 'snippet'
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
