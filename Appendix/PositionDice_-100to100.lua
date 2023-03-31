function RandomizeItemPosition()
  local selItems = reaper.CountSelectedMediaItems(0)
  if selItems == 0 then
    return
  end
  
  reaper.PreventUIRefresh(1)
  reaper.Undo_BeginBlock()
  
  for i = 0, selItems - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    if item ~= nil then
      local randOffset = (math.random(-100, 100) / 1000.0)
      local itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      reaper.SetMediaItemInfo_Value(item, "D_POSITION", itemPos + randOffset)
    end
  end
  
  reaper.Undo_EndBlock("Randomize Item Position", 0)
  reaper.UpdateArrange()
end

RandomizeItemPosition()

