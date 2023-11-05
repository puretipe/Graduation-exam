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

  def self.extract_youtube_id(url)
    uri = URI(url)
    CGI.parse(uri.query)['v'].first
  rescue
    nil
  end
end