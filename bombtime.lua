local function get_bomb_time(bomb)
    local bomb_time = entity.get_prop(bomb, "m_flC4Blow") - globals.curtime()
    if bomb_time == nil then return 0 end
    if bomb_time > 0 then
        return bomb_time
    end
    return 0
end

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function on_paint(c)
    local bomb = entity.get_all("CPlantedC4")[1]
    if bomb == nil then
		return
	end
	local blowtime = round(get_bomb_time(bomb),3)
	local width = renderer.measure_text("",blowtime)
	local x,y,z = entity.get_prop(bomb, "m_vecOrigin")
	local w2x,w2y = renderer.world_to_screen(x,y,z)
	if w2x ~= nil and w2y ~= nil then
		renderer.rectangle(w2x - 14,w2y + 6, width + 4,12,30,30,30,180)
		renderer.text(w2x - 12,w2y + 5,255,255,255,255,"",0,blowtime)
	end
end

client.set_event_callback("paint", on_paint)