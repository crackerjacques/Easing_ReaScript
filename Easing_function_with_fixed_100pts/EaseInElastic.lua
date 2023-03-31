-- Set up
local function easeInElastic(t)
    local amplitude = 0.6
    local period = 0.3
    local offset = 0.4

    if t == 0 then
        return offset
    end
    
    return -amplitude * (2^(10 * (t - 1))) * math.sin((t - 1 - period / 4) * (2 * math.pi) / period) + offset
end

local function insertEnvelopePoints(ease_func, num_points)
    local envelope = reaper.GetSelectedTrackEnvelope(0)
    if not envelope then return end

    local retval, envelope_name = reaper.GetEnvelopeName(envelope, "")
    local is_volume = envelope_name:find("Volume") ~= nil
    local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    reaper.DeleteEnvelopePointRange(envelope, time_start, time_end)

    for i = 0, num_points - 1 do
        local t = time_start + (time_end - time_start) * (i / (num_points - 1))
        local value = ease_func(i / (num_points - 1))

        if is_volume then
            value = value * 700
        end

        reaper.InsertEnvelopePoint(envelope, t, value, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(envelope)
end

local num_points = 100
reaper.Undo_BeginBlock()
insertEnvelopePoints(easeInElastic, num_points)
reaper.Undo_EndBlock("EaseInElastic Envelope Points", -1)

