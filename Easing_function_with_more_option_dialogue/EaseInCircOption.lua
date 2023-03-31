function easeInCirc(t)
    return -(math.sqrt(1 - t * t) - 1)
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit)
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    for i = 0, num_points do
        local t = i / num_points
        local point_time = start_time + (end_time - start_time) * t
        local y = easeInCirc(t)
        y = lower_limit + (upper_limit - lower_limit) * y

        reaper.InsertEnvelopePoint(env, point_time, y, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(env)
end

local retval, userInput = reaper.GetUserInputs("EaseInCirc", 3, "Number of points,Lower limit,Upper limit", "100,0.2,0.8")

if retval then
    local num_points, lower_limit, upper_limit = userInput:match("([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)

    if num_points and lower_limit and upper_limit then
        reaper.Undo_BeginBlock()
        local env = reaper.GetSelectedTrackEnvelope(0)
        if env then
            local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
            processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit)
            reaper.Undo_EndBlock("Create EaseInCirc Envelope Points", -1)
        end
    else
        reaper.MB("Invalid input. Please enter valid numbers.", "Error", 0)
    end
end
