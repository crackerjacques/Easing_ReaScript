function promptForAddition()
    local retval, user_input = reaper.GetUserInputs("Velocity Addition", 1, "Enter addition value (-1.0 to 1.0):", "")
    
    if not retval or not tonumber(user_input) or tonumber(user_input) < -100 or tonumber(user_input) > 100 then
        return nil
    end
    
    return tonumber(user_input)
end

function addEnvelopePoints(addition)
    start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

    if start_time ~= end_time then
        selected_track = reaper.GetSelectedTrack(0, 0)
        
        if selected_track ~= nil then
            env = reaper.GetSelectedTrackEnvelope(0)
            
            if env ~= nil then
                num_points = reaper.CountEnvelopePoints(env)
                
                for i = 0, num_points - 1 do
                    retval, point_time, point_value, _, _, _ = reaper.GetEnvelopePoint(env, i)
                    
                    if point_time >= start_time and point_time <= end_time then
                        new_value = point_value + addition
                        new_value = math.max(0, math.min(new_value, 1)) -- Clamp the value between 0 and 1
                        reaper.SetEnvelopePoint(env, i, point_time, new_value, 0, 0, 0, true)
                    end
                end
                
                reaper.Envelope_SortPoints(env)
            end
        end
    end
end

addition = promptForAddition()

if addition then
    addEnvelopePoints(addition)
end

