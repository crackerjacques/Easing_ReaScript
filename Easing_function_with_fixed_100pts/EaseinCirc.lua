local reaper = reaper

function easeInCirc(t)
    return -(math.sqrt(1 - t * t) - 1)
end

local function main()
    local envelope = reaper.GetSelectedTrackEnvelope(0)
    if not envelope then return end

    local _, env_name = reaper.GetEnvelopeName(envelope, "")
    local is_track_vol = env_name == "Volume" or env_name == "Trim Volume" or env_name == "Volume (Pre-FX)"

    local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    local num_points = 100

    reaper.DeleteEnvelopePointRange(envelope, start_time, end_time)

    for i = 0, num_points do
        local t = i / num_points
        local point_time = start_time + t * (end_time - start_time)
        local value = easeInCirc(t)

        if is_track_vol then
            value = value * 700
        end

        reaper.InsertEnvelopePoint(envelope, point_time, value, 0, 0, false, true)
    end

    reaper.Envelope_SortPoints(envelope)
    reaper.UpdateArrange()
end

reaper.defer(main)

