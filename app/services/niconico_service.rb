class NiconicoService
  def self.get_thumbnail_url(embed_url)
    video_id = extract_video_id(embed_url)
    return nil if video_id.blank?
    
    url = URI("http://ext.nicovideo.jp/api/getthumbinfo/#{video_id}")
    response = Net::HTTP.get(url)
    doc = REXML::Document.new(response)
    
    if doc.elements['nicovideo_thumb_response/thumb/thumbnail_url']
      doc.elements['nicovideo_thumb_response/thumb/thumbnail_url'].text
    else
      nil
    end
  end

  def self.extract_video_id(url)
    uri = URI(url)
    uri.path.split('/').last
  rescue
    nil
  end
end
