class VideoInfoFetcher
  def self.get_video_info(url)
    if url.include?("youtube.com") || url.include?("youtu.be")
      YoutubeService.get_video_info(UrlConverter.to_full_youtube_url(url))
    elsif url.include?("nicovideo.jp")
      NiconicoService.get_video_info(url)
    end
  end
end