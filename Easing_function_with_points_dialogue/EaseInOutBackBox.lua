reaper.Undo_BeginBlock()

function easeInOutBack(t)
    local s = 1.70158 * 1.525
    t = t * 2
    if t < 1 then
        return (0.9 * ((t * t * ((s + 1) * t - s)) / 2)) + 0.1
    else
        t = t - 2
        return (0.9 * ((t * t * ((s + 1) * t + s)) / 2 + 1)) + 0.1
    end
end

local retval, num_points = reaper.GetUserInputs("Ease In/Out Back", 1, "Number of points:", "100")

if retval then
    num_points = tonumber(num_points)
    
    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    local time_range = end_time - start_time
    local envelope = reaper.GetSelectedTrackEnvelope(0)
    
    if envelope and time_range > 0 then
        local _, env_name = reaper.GetEnvelopeName(envelope, "")
        local is_track_volume = env_name:find("Volume") and not env_name:find("Pre-FX")
        local scale = is_track_volume and 700 or 1
        
        reaper.DeleteEnvelopePointRange(envelope, start_time, end_time)
        
        for i = 0, num_points do
            local t = i / num_points
            local eased_value = easeInOutBack(t) * scale
            local time = start_time + t * time_range
            reaper.InsertEnvelopePoint(envelope, time, eased_value, 0, 0, true, true)
        end
        
        reaper.Envelope_SortPoints(envelope)
        reaper.UpdateArrange()
        reaper.Undo_EndBlock("Ease In/Out Back Envelope Points", -1)
    end
end

