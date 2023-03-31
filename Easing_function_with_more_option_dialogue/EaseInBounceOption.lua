local function easeOutBounce(t)
    if t < 1 / 2.75 then
        return 7.5625 * t * t
    elseif t < 2 / 2.75 then
        t = t - 1.5 / 2.75
        return 7.5625 * t * t + 0.75
    elseif t < 2.5 / 2.75 then
        t = t - 2.25 / 2.75
        return 7.5625 * t * t + 0.9375
    else
        t = t - 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    end
end

-- Calculate easeInBounce
local function easeInBounce(t)
    return 1 - easeOutBounce(1 - t)
end

local function insertEnvelopePoints(ease_func, num_points, lower_limit, upper_limit)
    local envelope = reaper.GetSelectedTrackEnvelope(0)
    if not envelope then return end

    local retval, envelope_name = reaper.GetEnvelopeName(envelope, "")
    local is_volume = envelope_name:find("Volume") ~= nil
    local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    reaper.DeleteEnvelopePointRange(envelope, time_start, time_end)

    for i = 0, num_points - 1 do
        local t = time_start + (time_end - time_start) * (i / (num_points - 1))
        local value = ease_func(i / (num_points - 1))

        -- Map value to the specified range
        value = lower_limit + (upper_limit - lower_limit) * value

        if is_volume then
            value = value * 700
        end

        reaper.InsertEnvelopePoint(envelope, t, value, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(envelope)
end

local retval, userInput = reaper.GetUserInputs("EaseInBounce", 3, "Number of points,Lower limit,Upper limit", "100,0.2,0.8")

if retval then
    local num_points, lower_limit, upper_limit = userInput:match("([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)
    
    if num_points and lower_limit and upper_limit then
        reaper.Undo_BeginBlock()
        insertEnvelopePoints(easeInBounce, num_points, lower_limit, upper_limit)
        reaper.Undo_EndBlock("EaseInBounce Envelope Points", -1)
    else
        reaper.MB("Invalid input. Please enter valid numbers.", "Error", 0)
    end
end
