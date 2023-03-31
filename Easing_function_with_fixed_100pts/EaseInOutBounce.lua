-- User settings
local num_points = 100

-- Calculate easeInOutBounce
local function easeInOutBounce(t)
  local function easeOutBounce(t)
    local n1 = 7.5625
    local d1 = 2.75

    if t < 1 / d1 then
      return n1 * t * t
    elseif t < 2 / d1 then
      t = t - 1.5 / d1
      return n1 * t * t + 0.75
    elseif t < 2.5 / d1 then
      t = t - 2.25 / d1
      return n1 * t * t + 0.9375
    else
      t = t - 2.625 / d1
      return n1 * t * t + 0.984375
    end
  end

  if t < 0.5 then
    return (1 - easeOutBounce(1 - 2 * t)) / 2
  else
    return (1 + easeOutBounce(2 * t - 1)) / 2
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
    local value = easeInOutBounce(t)
    local point_time = start_time + (end_time - start_time) * t

    if is_volume then
      value = value * 700
    end

    reaper.InsertEnvelopePoint(envelope, point_time, value, 0, 0, true, true)
  end

  reaper.Envelope_SortPoints(envelope)
  reaper.UpdateArrange()
  reaper.Undo_EndBlock("Apply easeInOutBounce to selected envelope", -1)
else
  reaper.ShowMessageBox("Please select an envelope before running the script.", "Error", 0)
end

