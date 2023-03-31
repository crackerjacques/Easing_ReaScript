-- ダイアログボックスの作成
retval, input_string = reaper.GetUserInputs("トラック名検索", 1, "トラック名を入力してください:, ", "")

if retval then
  -- トラックの数を取得
  num_tracks = reaper.CountTracks(0)

  -- 各トラックについて処理する
  for i = 0, num_tracks - 1 do
    track = reaper.GetTrack(0, i)
    
    -- トラック名が入力した文字列を含む場合は選択状態にする
    _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    if string.match(track_name, input_string) then
      reaper.SetTrackSelected(track, true)
    else
      reaper.SetTrackSelected(track, false)
    end
  end
end

