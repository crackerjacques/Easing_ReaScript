reaper.Undo_BeginBlock()

-- ダイアログでタイムストレッチのパーセントを取得
retval, stretch_percent = reaper.GetUserInputs("Envelope Time Strech", 1, "Time Strech (%):", "")

if retval then
  -- 入力された％を数値に変換
  stretch_percent = tonumber(stretch_percent) / 100

  if stretch_percent > 0 then
    -- 選択範囲を取得
    sel_start, sel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    if sel_start ~= sel_end then
      -- 選択範囲内のエンベロープを取得
      track_count = reaper.CountTracks(0)

      for i = 0, track_count - 1 do
        track = reaper.GetTrack(0, i)
        envelope_count = reaper.CountTrackEnvelopes(track)

        for j = 0, envelope_count - 1 do
          envelope = reaper.GetTrackEnvelope(track, j)

          if reaper.Envelope_SortPoints(envelope) then
            point_count = reaper.CountEnvelopePoints(envelope)
            new_points = {}

            -- エンベロープポイントを編集して新しいポイント配列を作成
            for k = 0, point_count - 1 do
              retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(envelope, k)

              if time >= sel_start and time <= sel_end then
                new_time = sel_start + (time - sel_start) * stretch_percent
                table.insert(new_points, {index = k, time = new_time})
              end
            end

            -- 新しいポイント配列を適用
            for _, point in ipairs(new_points) do
              reaper.SetEnvelopePoint(envelope, point.index, point.time, nil, nil, nil, nil, true)
            end

            reaper.Envelope_SortPoints(envelope)
          end
        end
      end
    end
  end
end

reaper.Undo_EndBlock("エンベロープポイントタイムストレッチ", -1)
reaper.UpdateArrange()

