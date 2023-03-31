-- User settings
local num_points = 100

-- Calculate easeInOutBack
local function easeInOutBack(t)
  local c1 = 1.70158
  local c2 = c1 * 1.525

  t = t * 2
  if t < 1 then
    return (t * t * ((c2 + 1) * t - c2)) / 2
  else
    t = t - 2
    return (t * t * ((c2 + 1) * t + c2) + 2) / 2
  end
end

-- Main script
reaper.Undo_BeginBlock()

local envelope = reaper.GetSelectedTrackEnvelope(0)

if envelope then
  local retval, env_name = reaper.GetEnvelopeName(envelope, "")

  local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  local is_volume = (env_name == "Volume" or env_name == "Volume (Pre-FX)" or env_name == "Trim Volume")

  reaper.DeleteEnvelopePointRange(envelope, start_time, end_time)

  for i = 0, num_points do
    local t = i / num_points
    local value = easeInOutBack(t)
    local point_time = start_time + (end_time - start_time) * t

    if is_volume then
      value = value * 700
    end

    reaper.InsertEnvelopePoint(envelope, point_time, value, 0, 0, true, true)
  end

  reaper.Envelope_SortPoints(envelope)
  reaper.UpdateArrange()
  reaper.Undo_EndBlock("Apply easeInOutBack to selected envelope", -1)
else
  reaper.ShowMessageBox("Please select an envelope before running the script.", "Error", 0)
end

