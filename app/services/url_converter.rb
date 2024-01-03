class UrlConverter
  def self.to_embed_url(url)
    if url =~ %r{\Ahttps?://www\.youtube\.com/watch\?v=([^&]+)}
      "https://www.youtube.com/embed/#{$1}"
    elsif url =~ %r{\Ahttps?://youtu\.be/([^/?]+)}
      "https://www.youtube.com/embed/#{$1}"
    elsif url =~ %r{\Ahttps?://www\.nicovideo\.jp/watch/([^/?]+)}
      "https://embed.nicovideo.jp/watch/#{$1}"
    else
      url
    end
  end

  def self.to_full_youtube_url(url)
    if url =~ %r{\Ahttps?://youtu\.be/([^/?]+)}
      "https://www.youtube.com/watch?v=#{$1}"
    else
      url
    end
  end
end