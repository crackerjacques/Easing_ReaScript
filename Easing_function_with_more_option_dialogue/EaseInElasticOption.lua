local function easeInElastic(t, amplitude, period, offset)
    if t == 0 then
        return offset
    end
    
    return -amplitude * (2^(10 * (t - 1))) * math.sin((t - 1 - period / 4) * (2 * math.pi) / period) + offset
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, amplitude, period, offset)
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    for i = 0, num_points do
        local t = i / num_points
        local point_time = start_time + (end_time - start_time) * t
        local y = easeInElastic(t, amplitude, period, offset)
        y = lower_limit + (upper_limit - lower_limit) * y

        reaper.InsertEnvelopePoint(env, point_time, y, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(env)
end

local retval, userInput = reaper.GetUserInputs("EaseInElastic", 6, "Number of points,Lower limit,Upper limit,Amplitude,Period,Offset", "100,0.2,0.8,0.6,0.3,0.4")

if retval then
    local num_points, lower_limit, upper_limit, amplitude, period, offset = userInput:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)
    amplitude = tonumber(amplitude)
    period = tonumber(period)
    offset = tonumber(offset)

    if num_points and lower_limit and upper_limit and amplitude and period and offset then
        reaper.Undo_BeginBlock()
        local env = reaper.GetSelectedTrackEnvelope(0)
        if env then
            local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
            processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, amplitude, period, offset)
            reaper.Undo_EndBlock("Create EaseInElastic Envelope Points", -1)
        end
    else
        reaper.MB("Invalid input. Please enter valid numbers.", "Error", 0)
    end
end

