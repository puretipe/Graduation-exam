class YoutubeService
  def self.get_thumbnail_url(embed_url)
    youtube_id = extract_youtube_id(embed_url)
    return nil if youtube_id.blank?
    
    url = URI("https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=#{ENV['YOUTUBE_API_KEY']}&part=snippet")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    
    if data['items'].any?
      data['items'].first['snippet']['thumbnails']['high']['url']
    else
      nil
    end
  end

  def self.get_video_info(embed_url)
    youtube_id = extract_youtube_id(embed_url)
    return nil if youtube_id.blank?

    begin
      url = URI("https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=#{ENV['YOUTUBE_API_KEY']}&part=snippet")
      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      if data['items'].any?
        snippet = data['items'].first['snippet']
        {
          title: snippet['title'],
          description: snippet['description'],
          tags: snippet['tags']
        }
      else
        nil
      end
    rescue => e
      Rails.logger.error "Error fetching video info from YouTube: #{e.message}"
      nil
    end
  end

  def self.extract_youtube_id(url)
    uri = URI(url)
    CGI.parse(uri.query)['v'].first
  rescue
    nil
  end
end