class ThumbnailFetcher
  def self.fetch(url)
    if url.include?('youtube.com')
      YoutubeService.get_thumbnail_url(url)
    elsif url.include?('nicovideo.jp')
      NiconicoService.get_thumbnail_url(url)
    end
  end
end