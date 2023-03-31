local reaper = reaper

function easeInExpo(x)
    if x == 0 then
        return 0
    else
        return 2 ^ (10 * (x - 1))
    end
end

local function main()
    local envelope = reaper.GetSelectedTrackEnvelope(0)
    if not envelope then return end

    local is_vol_env = false
    local _, env_name = reaper.GetEnvelopeName(envelope, "")
    if env_name == "Volume" or env_name == "Volume (Pre-FX)"or env_name == "Trim Volume" then
        is_vol_env = true
    end

    local num_points = 100
    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    local time_range = end_time - start_time

    if time_range <= 0 then return end

    reaper.DeleteEnvelopePointRange(envelope, start_time, end_time)

    for i = 0, num_points do
        local point_time = start_time + (time_range * (i / num_points))
        local x = i / num_points
        local y = easeInExpo(x)

        if is_vol_env then
            y = y * 700
        end

        reaper.InsertEnvelopePoint(envelope, point_time, y, 0, 0, false, false)
    end

    reaper.Envelope_SortPoints(envelope)
end

reaper.defer(main)

