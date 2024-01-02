class NiconicoService
  require 'net/http'
  require 'rexml/document'
  require 'uri'

  API_ENDPOINT = 'https://ext.nicovideo.jp/api/getthumbinfo/'.freeze

  def self.get_thumbnail_url(embed_url)
    thumb_info = fetch_thumb_info(embed_url)
    thumb_info[:thumbnail_url] if thumb_info
  end

  def self.get_video_info(embed_url)
    thumb_info = fetch_thumb_info(embed_url)
    return unless thumb_info

    {
      title: thumb_info[:title],
      description: thumb_info[:description],
      tags: thumb_info[:tags]
    }
  end

  private

  def self.fetch_thumb_info(embed_url)
    video_id = extract_video_id(embed_url)
    return if video_id.blank?

    url = URI("#{API_ENDPOINT}#{video_id}")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      doc = REXML::Document.new(response.body)
      thumb = doc.elements['nicovideo_thumb_response/thumb']
      return nil unless thumb

      {
        title: thumb.elements['title']&.text,
        description: thumb.elements['description']&.text,
        tags: thumb.elements['tags']&.text&.split(' '),
        thumbnail_url: thumb.elements['thumbnail_url']&.text
      }
    else
      Rails.logger.error "Error fetching video info from Niconico: #{response.message}"
      nil
    end
  rescue => e
    Rails.logger.error "Error parsing video info from Niconico: #{e.message}"
    nil
  end

  def self.extract_video_id(url)
    URI(url).path.split('/').last
  rescue URI::InvalidURIError
    nil
  end
end
