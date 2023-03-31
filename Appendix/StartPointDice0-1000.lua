function RandomizeStartInSource()
  local selItems = reaper.CountSelectedMediaItems(0)
  if selItems == 0 then
    return
  end
  
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  for i = 0, selItems - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    if item ~= nil then
      local take = reaper.GetActiveTake(item)
      if take ~= nil then
        local randStart = math.random(0, 1000) / 1000.0
        reaper.SetMediaItemTakeInfo_Value(take, "D_STARTOFFS", randStart)
      end
    end
  end
  
  reaper.Undo_EndBlock("Randomize Start In Source", 0)
  reaper.UpdateArrange()
end

RandomizeStartInSource()

