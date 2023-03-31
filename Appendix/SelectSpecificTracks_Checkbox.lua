function stringContains(str, searchStr, caseSensitive)
  if not caseSensitive then
    str = str:lower()
    searchStr = searchStr:lower()
  end
  return str:find(searchStr, 1, true) ~= nil
end

retval, user_input = reaper.GetUserInputs("Select tracks by name", 2, "Search string:,When sensitive input 1,extrawidth=100", "")
if retval then
  search_string = user_input:match("^([^,]+)")
  case_sensitive = tonumber(user_input:match("^.*,([^,]+)"))
  
  for i=0, reaper.CountTracks(0)-1 do
    local track = reaper.GetTrack(0, i)
    local _, track_name = reaper.GetTrackName(track)
    if stringContains(track_name, search_string, case_sensitive) then
      reaper.SetTrackSelected(track, true)
    end
  end
end

