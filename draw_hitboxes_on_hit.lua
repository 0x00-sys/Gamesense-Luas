--[[

Description
Draws the target hitboxes when the aimbot fires.

Purpose
Use to debug aimbot misses. Create a local server, turn on
'sv_showlagcompensation 1', and load this script. Server hitboxes will only
be drawn for the person that created the local server.

Notes
The drawn hitboxes may not reflect the hitboxes the aimbot used if you are
using 'Refine shot', 'Extended backtrack', or 'Predict'.

]]--

local draw_hitboxes, print = client.draw_hitboxes, print
local r,g,b = 190,190,190
local duration = 0.20

local function aim_fire(e)
    
    if e.interpolated then
      --  print('Skipping draw_hitboxes due to "extended backtrack"')
    elseif e.extrapolated then
       -- print('Skipping draw_hitboxes due to "predict"')
    else
        draw_hitboxes(e.target, duration, 19, r, g, b, 30, e.tick)
    end
end

client.set_event_callback('aim_fire', aim_fire)