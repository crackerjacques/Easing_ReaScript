local function easeInOutBack(t, offset)
    local c1 = 1.70158
    local c2 = c1 * 1.525

    t = t * 2
    if t < 1 then
        return (t * t * ((c2 + 1) * t - c2)) / 2 + offset
    else
        t = t - 2
        return (t * t * ((c2 + 1) * t + c2) + 2) / 2 + offset
    end
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, offset)
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    for i = 0, num_points do
        local t = i / num_points
        local point_time = start_time + (end_time - start_time) * t
        local y = easeInOutBack(t, offset)
        y = lower_limit + (upper_limit - lower_limit) * y

        reaper.InsertEnvelopePoint(env, point_time, y, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(env)
end

local retval, userInput = reaper.GetUserInputs("EaseInOutBack", 4, "Number of points,Lower limit,Upper limit,Offset", "100,0.2,0.8,0.1")

if retval then
    local num_points, lower_limit, upper_limit, offset = userInput:match("([^,]+),([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)
    offset = tonumber(offset)

    if num_points and lower_limit and upper_limit and offset then
        reaper.Undo_BeginBlock()
        local env = reaper.GetSelectedTrackEnvelope(0)
        if env then
            local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
            processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, offset)
            reaper.Undo_EndBlock("Create EaseInOutBack Envelope Points", -1)
        end
    else
        reaper.MB("Invalid input. Please enter valid numbers.", "Error", 0)
    end
end

