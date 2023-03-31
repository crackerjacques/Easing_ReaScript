-- Calculate easeInCubic
local function easeInCubic(t)
  return t * t * t
end

-- Main script
local retval, num_points = reaper.GetUserInputs("EaseInCubic", 1, "Number of points:", "100")

if retval then
  num_points = tonumber(num_points)

  if num_points then
    reaper.Undo_BeginBlock()

    local envelope = reaper.GetSelectedTrackEnvelope(0)

    if envelope then
      local retval, env_name = reaper.GetEnvelopeName(envelope, "")

      local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
      local is_volume = (env_name == "Volume" or env_name == "Volume (Pre-FX)")

      reaper.DeleteEnvelopePointRange(envelope, start_time, end_time)

      for i = 0, num_points do
        local t = i / num_points
        local value = easeInCubic(t)
        local point_time = start_time + (end_time - start_time) * t

        if is_volume then
          value = value * 700
        end

        reaper.InsertEnvelopePoint(envelope, point_time, value, 0, 0, true, true)
      end

      reaper.Envelope_SortPoints(envelope)
      reaper.UpdateArrange()
      reaper.Undo_EndBlock("Apply easeInCubic to selected envelope", -1)
    else
      reaper.ShowMessageBox("Please select an envelope before running the script.", "Error", 0)
    end
  else
    reaper.ShowMessageBox("Invalid number of points. Please enter a valid number.", "Error", 0)
  end
end

