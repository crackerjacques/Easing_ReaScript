-- Set up
local function easeInOutQuint(t)
    t = t * 2
    if t < 1 then
        return 0.5 * t * t * t * t * t
    else
        t = t - 2
        return 0.5 * (t * t * t * t * t + 2)
    end
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

local retval, num_points = reaper.GetUserInputs("Number of Points", 1, "Number of Points:", "100")
num_points = tonumber(num_points)

if retval and num_points then
    reaper.Undo_BeginBlock()
    insertEnvelopePoints(easeInOutQuint, num_points)
    reaper.Undo_EndBlock("EaseInOutQuint Envelope Points", -1)
end

