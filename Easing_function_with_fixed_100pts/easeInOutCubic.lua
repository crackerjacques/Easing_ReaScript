function easeInOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    else
        local f = (2 * t) - 2
        return 0.5 * f * f * f + 1
    end
end

reaper.Undo_BeginBlock()

local sel_env = reaper.GetSelectedEnvelope(0)
if sel_env then
    local track = reaper.Envelope_GetParentTrack(sel_env)
    local env_name_retval, env_name = reaper.GetEnvelopeName(sel_env, "")

    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    local num_points = 100

    -- Remove all points in the selected range
    reaper.DeleteEnvelopePointRange(sel_env, start_time, end_time)

    -- Insert new points with EaseInOutCubic shape
    for i = 0, num_points do
        local t = i / num_points
        local point_time = start_time + (end_time - start_time) * t
        local value = easeInOutCubic(t)

        -- If envelope is track volume, multiply value by 800
        if env_name == "Volume" or env_name == "Volume (Pre-FX)" or env_name == "Trim Volume" then
            value = value * 700
        end

        reaper.InsertEnvelopePoint(sel_env, point_time, value, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(sel_env)
end

reaper.Undo_EndBlock("Apply EaseInOutCubic to Selected Envelope", -1)

