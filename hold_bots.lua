local bit = require "bit"
local band = bit.band
local get_prop = entity.get_prop
local get_all_players = entity.get_players
local is_enemy = entity.is_enemy
local console_cmd = client.exec

-- tell bots to hold their position when freezetime ends
local function on_round_freeze_end(e)
	local players = get_all_players()
	if players == nil then
		return
	end

	for i=1, #players do
		local entindex = players[i]
		if not is_enemy(entindex) then
			local flags = get_prop(entindex, "m_fFlags")
			if flags and band(flags, 0x200) == 0x200 then -- FL_FAKECLIENT
				console_cmd("holdpos")
				-- we can exit the function, no need to check other players
				return
			end
		end
	end
end

client.set_event_callback("round_freeze_end", on_round_freeze_end)