local function insertEnvelopePoints(num_points, lower_limit, upper_limit, random_time)
    local envelope = reaper.GetSelectedTrackEnvelope(0)
    if not envelope then return end

    local retval, envelope_name = reaper.GetEnvelopeName(envelope, "")
    local is_volume = envelope_name:find("Volume") ~= nil
    local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    reaper.DeleteEnvelopePointRange(envelope, time_start, time_end)

    for i = 0, num_points - 1 do
        local t = time_start + (time_end - time_start) * (i / (num_points - 1))
        if random_time > 0 then
            t = t + math.random(-random_time, random_time) * 0.001
        end
        
        local value = math.random() * (upper_limit - lower_limit) + lower_limit

        if is_volume then
            value = value * 700
        end

        reaper.InsertEnvelopePoint(envelope, t, value, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(envelope)
end

local retval, userInput = reaper.GetUserInputs("Random Envelope Points", 4, "Upper limit,Lower limit,Randomization time (0 for none),Number of points", "1,0.5,0,40")

if retval then
    local upper_limit, lower_limit, random_time, num_points = userInput:match("([^,]+),([^,]+),([^,]+),([^,]+)")
    upper_limit = tonumber(upper_limit)
    lower_limit = tonumber(lower_limit)
    random_time = tonumber(random_time)
    num_points = tonumber(num_points)
    
    if upper_limit and lower_limit and random_time and num_points then
        reaper.Undo_BeginBlock()
        insertEnvelopePoints(num_points, lower_limit, upper_limit, random_time)
        reaper.Undo_EndBlock("Random Envelope Points", -1)
    else
        reaper.MB("Invalid input. Please enter valid numbers.", "Error", 0)
    end
end

