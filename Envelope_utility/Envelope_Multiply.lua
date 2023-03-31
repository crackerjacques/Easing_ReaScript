function promptForMultiplier()
    local retval, user_input = reaper.GetUserInputs("Velocity Multiplier", 1, "Enter multiplier value:", "")
    
    if not retval or not tonumber(user_input) then
        return nil
    end
    
    return tonumber(user_input)
end

function multiplyEnvelopePoints(multiplier)
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
                        new_value = point_value * multiplier
                        reaper.SetEnvelopePoint(env, i, point_time, new_value, 0, 0, 0, true)
                    end
                end
                
                reaper.Envelope_SortPoints(env)
            end
        end
    end
end

multiplier = promptForMultiplier()

if multiplier then
    multiplyEnvelopePoints(multiplier)
end

