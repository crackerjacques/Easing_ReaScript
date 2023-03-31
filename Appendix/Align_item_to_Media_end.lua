function main()
  reaper.Undo_BeginBlock()
  local item_cnt = reaper.CountSelectedMediaItems()
  if item_cnt > 1 then
    local longest_item = nil
    local longest_length = 0
    for i=0, item_cnt-1 do
      local item = reaper.GetSelectedMediaItem(0, i)
      local take = reaper.GetActiveTake(item)
      local source = reaper.GetMediaItemTake_Source(take)
      local length = reaper.GetMediaSourceLength(source)
      if length > longest_length then
        longest_item = item
        longest_length = length
      end
    end
    for i=0, item_cnt-1 do
      local item = reaper.GetSelectedMediaItem(0, i)
      if item ~= longest_item then
        local take = reaper.GetActiveTake(item)
        local source = reaper.GetMediaItemTake_Source(take)
        local length = reaper.GetMediaSourceLength(source)
        local diff = longest_length - length
        reaper.ApplyNudge(0, 0, 5, 1, diff, false, 0)
        reaper.SetMediaItemLength(item, longest_length, true)
      end
    end
  end
  reaper.Undo_EndBlock("Resize item to longest item", -1)
end

main()
