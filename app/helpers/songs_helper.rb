module SongsHelper
  def evaluation_type_options
    [
      ['メロディー', 'melody_evaluations_count desc'],
      ['歌詞', 'lyrics_evaluations_count desc'],
      ['コード', 'chord_evaluations_count desc'],
      ['ビート', 'beat_evaluations_count desc'],
      ['サウンド', 'sound_evaluations_count desc'],
      ['雰囲気', 'atmosphere_evaluations_count desc']
    ]
  end
end
