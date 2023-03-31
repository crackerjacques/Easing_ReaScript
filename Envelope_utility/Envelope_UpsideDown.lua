local function reverse_envelope_points(envelope, start_time, end_time)
    local point_count = reaper.CountEnvelopePoints(envelope)

    for i = 0, point_count - 1 do
        local retval, point_time, point_value, shape, tension, selected = reaper.GetEnvelopePoint(envelope, i)

        if point_time >= start_time and point_time <= end_time then
            local reversed_value = 1 - point_value
            reaper.SetEnvelopePoint(envelope, i, point_time, reversed_value, shape, tension, selected, true)
        end
    end

    reaper.Envelope_SortPoints(envelope)
end

local track = reaper.GetSelectedTrack(0, 0)
if track then
    local envelope = reaper.GetSelectedEnvelope(0)
    if envelope then
        local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        reverse_envelope_points(envelope, start_time, end_time)
    end
end

reaper.UpdateArrange()

