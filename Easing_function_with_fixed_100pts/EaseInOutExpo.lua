-- User settings
local num_points = 100

-- Calculate easeInOutExpo
local function easeInOutExpo(t)
  if t == 0 then
    return 0
  elseif t == 1 then
    return 1
  elseif t < 0.5 then
    return 0.5 * (2 ^ (20 * t - 10))
  else
    return 1 - 0.5 * (2 ^ (-20 * t + 10))
  end
end

-- Main script
reaper.Undo_BeginBlock()

local envelope = reaper.GetSelectedTrackEnvelope(0)
local retval, env_name = reaper.GetEnvelopeName(envelope, "")

local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
local is_volume = (env_name == "Volume" or env_name == "Volume (Pre-FX)" or env_name == "Trim Volume")

reaper.DeleteEnvelopePointRange(envelope, start_time, end_time)

for i = 0, num_points do
  local t = i / num_points
  local value = easeInOutExpo(t)
  local point_time = start_time + (end_time - start_time) * t

  if is_volume then
    value = value * 700
  end

  reaper.InsertEnvelopePoint(envelope, point_time, value, 0, 0, true, true)
end

reaper.Envelope_SortPoints(envelope)
reaper.UpdateArrange()
reaper.Undo_EndBlock("Apply easeInOutExpo to selected envelope", -1)

