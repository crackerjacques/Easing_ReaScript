
local function moveEnvelopePointsRandomly(envelope, time_start, time_end, time_min, time_max, value_min, value_max)
    local num_points = reaper.CountEnvelopePoints(envelope)

    for i = 0, num_points - 1 do
        local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(envelope, i)

        if selected and time >= time_start and time <= time_end then
            local new_time = time + math.random(time_min, time_max) * 0.001
            local new_value = value_min + math.random() * (value_max - value_min)

            local retval, envelope_name = reaper.GetEnvelopeName(envelope, "")
            if envelope_name:find("Volume") or envelope_name:find("Volume PreFX") or envelope_name:find("Trim Volume") then
                new_value = new_value * 700
            end

            reaper.SetEnvelopePoint(envelope, i, new_time, new_value, shape, tension, selected, true)
        end
    end

    reaper.Envelope_SortPoints(envelope)
end

local function main()
    local ok, retvals_csv = reaper.GetUserInputs("Randomly move envelope points", 4, "Time minimum (ms),Time maximum (ms),Value minimum,Value maximum", "-100,10,0.5,1")
    if not ok then return end

    local time_min, time_max, value_min, value_max = retvals_csv:match("([^,]+),([^,]+),([^,]+),([^,]+)")

    time_min = tonumber(time_min)
    time_max = tonumber(time_max)
    value_min = tonumber(value_min)
    value_max = tonumber(value_max)

    if not time_min or not time_max or not value_min or not value_max then
        reaper.MB("Invalid input values. Please try again.", "Error", 0)
        return
    end

    local time_start, time_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    if time_start == time_end then
        reaper.MB("Please select a time range.", "Error", 0)
        return
    end

    local envelope = reaper.GetSelectedTrackEnvelope(0)

    if not envelope then
        reaper.MB("Please select an envelope.", "Error", 0)
        return
    end

    reaper.Undo_BeginBlock()

    moveEnvelopePointsRandomly(envelope, time_start, time_end, time_min, time_max, value_min, value_max)

    reaper.Undo_EndBlock("Randomly move envelope points in selected area", -1)
    reaper.UpdateArrange()
end

reaper.defer(main)

