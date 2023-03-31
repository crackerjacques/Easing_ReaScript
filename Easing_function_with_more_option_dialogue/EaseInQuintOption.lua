local reaper = reaper

function easeInQuint(t)
    return t * t * t * t * t
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit)
    -- Remove existing points in the range
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    -- Add new points
    for i = 0, num_points do
        local t = i / num_points
        local x = start_time + (end_time - start_time) * t
        local y = easeInQuint(t) * (upper_limit - lower_limit) + lower_limit
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

    local retval, num_points_str = reaper.GetUserInputs("Envelope Settings", 3, "Number of Points,Lower Limit,Upper Limit", "100,0,1")
    if not retval then return end

    local num_points, lower_limit, upper_limit = num_points_str:match("([^,]+),([^,]+),([^,]+)")
    num_points = tonumber(num_points)
    lower_limit = tonumber(lower_limit)
    upper_limit = tonumber(upper_limit)

    if num_points and lower_limit and upper_limit then
        reaper.Undo_BeginBlock()
        local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
        processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit)
        reaper.UpdateArrange()
        reaper.Undo_EndBlock("Draw easeInQuint envelope", -1)
    else
        reaper.ShowMessageBox("Invalid input values. Please enter valid numbers.", "Error", 0)
    end
end

reaper.defer(main)

