local OldChoke = 0
local toDraw4 = 0
local toDraw3 = 0
local toDraw2 = 0
local toDraw1 = 0
local toDraw0 = 0

local function on_paint(ctx)
	client.draw_indicator(ctx ,220,220,220,255, string.format('%i-%i-%i-%i-%i',toDraw4,toDraw3,toDraw2,toDraw1,toDraw0))
end

local function setup_command(cmd)

	if cmd.chokedcommands < OldChoke then --sent
		toDraw0 = toDraw1
		toDraw1 = toDraw2
		toDraw2 = toDraw3
		toDraw3 = toDraw4
		toDraw4 = OldChoke
	end
	
	OldChoke = cmd.chokedcommands

end


client.set_event_callback('paint', on_paint)
client.set_event_callback('setup_command', setup_command)