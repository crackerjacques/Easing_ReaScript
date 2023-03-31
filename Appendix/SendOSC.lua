local function sendOSC(ip, port, address, osc_type, value)
    local command = string.format('/usr/local/bin/sendosc %s %d %s %s %s', ip, port, address, osc_type, value)
    os.execute(command)
end

local retval, inputs = reaper.GetUserInputs("Send OSC", 5, "IP Address,Port,Address,Type (i/f/s),Value", "127.0.0.1,8000,/test,f,0.5")

if retval then
    local ip, port, address, osc_type, value = inputs:match("([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")

    port = tonumber(port)

    if ip and port and address and osc_type and value then
        if osc_type == "i" or osc_type == "f" or osc_type == "s" then
            sendOSC(ip, port, address, osc_type, value)
        else
            reaper.ShowMessageBox("Invalid OSC type. Please enter a valid type (i, f, or s).", "Error", 0)
        end
    else
        reaper.ShowMessageBox("Invalid input values. Please enter valid values.", "Error", 0)
    end
end

