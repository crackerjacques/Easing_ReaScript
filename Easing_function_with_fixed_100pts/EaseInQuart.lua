local reaper = reaper

function easeInQuart(t)
    return t * t * t * t
end

local function processEnvelope(env, start_time, end_time, multiplier)
    -- Remove existing points in the range
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    -- Add new points
    local num_points = 100
    local interval = (end_time - start_time) / num_points
    for i = 0, num_points do
        local t = i / num_points
        local x = start_time + (end_time - start_time) * t
        local y = easeInQuart(t)
        if multiplier then
            y = y * multiplier
        end
        reaper.InsertEnvelopePoint(env, x, y, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(env)
end

reaper.Undo_BeginBlock()

local env = reaper.GetSelectedTrackEnvelope(0)
if env then
    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    local track = reaper.Envelope_GetParentTrack(env)
    local _, env_name = reaper.GetEnvelopeName(env, "")

    local multiplier
    if env_name == "Volume" then
        multiplier = 700
    elseif  env_name == "Volume (Pre-FX)" then
        multiplier = 700
   elseif  env_name == "Trim Volume" then
            multiplier = 700
    else
        multiplier = 1
    end

    processEnvelope(env, start_time, end_time, multiplier)
    reaper.UpdateArrange()
    reaper.Undo_EndBlock("Draw easeInQuart envelope", -1)
end

