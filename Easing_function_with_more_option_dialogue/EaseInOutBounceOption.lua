local reaper = reaper

function easeInOutBounce(t)
  local function easeOutBounce(t)
    local n1 = 7.5625
    local d1 = 2.75

    if t < 1 / d1 then
      return n1 * t * t
    elseif t < 2 / d1 then
      t = t - 1.5 / d1
      return n1 * t * t + 0.75
    elseif t < 2.5 / d1 then
      t = t - 2.25 / d1
      return n1 * t * t + 0.9375
    else
      t = t - 2.625 / d1
      return n1 * t * t + 0.984375
    end
  end

  if t < 0.5 then
    return (1 - easeOutBounce(1 - 2 * t)) / 2
  else
    return (1 + easeOutBounce(2 * t - 1)) / 2
  end
end

local function processEnvelope(env, start_time, end_time, num_points, lower_limit, upper_limit)
    -- Remove existing points in the range
    reaper.DeleteEnvelopePointRange(env, start_time, end_time)

    -- Add new points
    for i = 0, num_points do
        local t = i / num_points
        local x = start_time + (end_time - start_time) * t
        local y = easeInOutBounce(t) * (upper_limit - lower_limit) + lower_limit
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
        reaper.Undo_EndBlock("Draw easeInOutBounce envelope", -1)
    else
        reaper.ShowMessageBox("Invalid input values. Please enter valid numbers.", "Error", 0)
    end
end

reaper.defer(main)

