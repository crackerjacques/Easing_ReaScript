local reaper = reaper

function easeInOutElastic(t, amplitude, period, offset)
    if t == 0 then
        return offset
    elseif t == 1 then
        return amplitude + offset
    else
        t = t * 2
        if t < 1 then
            return -0.5 * (amplitude * 2^(10 * (t - 1)) * math.sin((t - 1.1) * (2 * math.pi) / period)) + offset
        else
            t = t - 1
            return amplitude * 2^(-10 * t) * math.sin((t - 1.1) * (2 * math.pi) / period) * 0.5 + amplitude + offset
        end
    end
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, amplitude, period, offset)
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    for i = 0, num_points - 1 do
        local t = i / (num_points - 1)
        local x = start_time + (end_time - start_time) * t
        local y = easeInOutElastic(t, amplitude, period, offset) * (upper_limit - lower_limit) + lower_limit
        reaper.InsertEnvelopePoint(env, x, y, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(env)
end

local function main()
    local env = reaper.GetSelectedTrackEnvelope(0)
    if not env then
        reaper.ShowMessageBox("Please select an envelope before running the script.", "Error", 0)
        return
    end

    local retval, userInput = reaper.GetUserInputs("Envelope Settings", 6, "Number of Points,Lower Limit,Upper Limit,Amplitude,Period,Offset", "100,0,1,0.6,0.3,0.2")
    if not retval then return end

    local num_points, lower_limit, upper_limit, amplitude, period, offset = userInput:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)
    amplitude = tonumber(amplitude)
    period = tonumber(period)
    offset = tonumber(offset)

    if num_points and lower_limit and upper_limit and amplitude and period and offset then
        reaper.Undo_BeginBlock()
        local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, amplitude, period, offset)
        reaper.UpdateArrange()
        reaper.Undo_EndBlock("Draw easeInOutElastic envelope", -1)
    else
        reaper.ShowMessageBox("Invalid input values. Please enter valid numbers.", "Error", 0)
    end
end

reaper.defer(main)

