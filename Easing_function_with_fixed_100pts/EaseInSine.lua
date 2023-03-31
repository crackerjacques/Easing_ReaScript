function easeInSine(t)
    return 1 - math.cos(t * (math.pi / 2))
end

reaper.Undo_BeginBlock()

local track = reaper.GetSelectedTrack(0, 0)
if not track then return end

local env_name_retval, env_name = "", ""
local env = reaper.GetSelectedTrackEnvelope(0)
if not env then return end

env_name_retval, env_name = reaper.GetEnvelopeName(env, env_name)

local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
local num_points = 100
local delta = (end_time - start_time) / num_points

reaper.DeleteEnvelopePointRange(env, start_time, end_time)

for i = 0, num_points do
    local point_time = start_time + delta * i
    local t = i / num_points
    local y = easeInSine(t)

    local value = reaper.ScaleToEnvelopeMode(reaper.GetEnvelopeScalingMode(env), y)
    reaper.InsertEnvelopePoint(env, point_time, value, 0, 0, false, true)
end

reaper.Envelope_SortPoints(env)
reaper.Undo_EndBlock("Create EaseInSine Envelope Points", -1)

