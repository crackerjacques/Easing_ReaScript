local reaper = reaper

function easeInOutBack(t)
    local c1 = 1.70158
    local c2 = c1 * 1.525

    t = t * 2
    if t < 1 then
        return (t * t * ((c2 + 1) * t - c2)) / 2
    else
        t = t - 2
        return (t * t * ((c2 + 1) * t + c2) + 2) / 2
    end
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, offset)
    -- Remove existing points in the range
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    -- Add new points
    for i = 0, num_points do
        local t = i / num_points
        local x = start_time + (end_time - start_time) * t
        local y = easeInOutBack(t) * (upper_limit - lower_limit) + lower_limit + offset
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

    local retval, num_points_str = reaper.GetUserInputs("Envelope Settings", 4, "Number of Points,Lower Limit,Upper Limit,Offset", "100,0.2,0.8,0")
    if not retval then return end

    local num_points, lower_limit, upper_limit, offset = num_points_str:match("([^,]+),([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)
    offset = tonumber(offset)

    if num_points and lower_limit and upper_limit and offset then
        reaper.Undo_BeginBlock()
        local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit, offset)
        reaper.UpdateArrange()
        reaper.Undo_EndBlock("Draw easeInOutBack envelope", -1)
    else
        reaper.ShowMessageBox("Invalid input values. Please enter valid numbers.", "Error", 0)
    end
end

reaper.defer(main)

