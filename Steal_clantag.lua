local ui_set_visible, globals_absoluteframetime, globals_frametime, globals_tickinterval, get_prop, ui_get, sqrt, sin, cos, get_local_player, get_all_players, get_player_name, get_screen_size, draw_text, client_console_cmd, client_delay_call, get_player_name, get_classname, globals_realtime, globals_tickcount = ui.set_visible, globals.absoluteframetime, globals.frametime, globals.tickinterval, entity.get_prop, ui.get, math.sqrt, math.sin, math.cos, entity.get_local_player, entity.get_players, entity.get_player_name, client.screen_size, client.draw_text, client.exec, client.delay_call, entity.get_player_name, entity.get_classname, globals.realtime, globals.tickcount
local table_insert, table_remove, math_floor, math_sqrt, math_min, math_abs  = table.insert, table.remove, math.floor, math.sqrt, math.min, math.abs
local entity_is_enemy, entity_is_alive, entity_is_dormant = entity.is_enemy, entity.is_alive, entity.is_dormant
local ui_new_checkbox, ui_new_slider, ui_new_combobox, ui_new_multiselect = ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_multiselect
local getvar, setvar = client.get_cvar, client.set_cvar
local ui_ref, c_event_cb, ui_cb,ui_new_button = ui.reference, client.set_event_callback, ui.set_callback, ui.new_button
local oldTick = globals.tickcount()

local names = {};
local old_size = #names 


local ct_target = ui.new_combobox("LUA", "B", "Target", "-", unpack(names))
local ct_check = ui.new_checkbox("LUA", "B", "Steal Target Clantag")
local ct_lock = ui.new_checkbox("LUA", "B", "Lock updates")

local function updateNames()
    local ret = {}
    local lp = get_local_player();
    for i = globals.maxplayers(), 1, -1 do
        i = math.floor(i);
        local name = get_player_name(i)
        if (name ~= 'unknown' and i ~= lp) then
            local lpTeam = get_prop(lp, "m_iTeamNum");
            local otherTeam = get_prop(i, "m_iTeamNum");
            table.insert(ret, name);
        end
    end
    names = ret
end

local function get_entindex_for_name(name)
    for player=1, globals.maxplayers() do 
        local tmp_name = get_player_name(player)
        if tmp_name == name then 
            return player 
        end
    end
end

local function update_menu_item()
    if old_size ~= #names then 
        ui.set_visible(ct_target, false)
		ui.set_visible(ct_check, false)
		ui.set_visible(ct_lock, false)
        ct_target = ui.new_combobox("LUA", "B", "Target", "-", unpack(names))
		ct_check = ui.new_checkbox("LUA", "B", "Steal Target Clantag")
		ct_lock = ui.new_checkbox("LUA", "B", "Lock updates")
        old_size = #names
        return
    else
        return
    end
end
local chokedcmds = 0
c_event_cb("run_command", function(c)
	chokedcmds = c.chokedcommands 
end)
c_event_cb("paint", function(c)
	if (ui_get(ct_check)) then
		local target = get_entindex_for_name(ui_get(ct_target))
		if target ~= nil then 
			local clantag = get_prop(entity.get_player_resource(), "m_szClan", target)
			if (clantag ~= nil) then
				if (clantag ~= entity.get_prop(entity.get_player_resource(), "m_szClan", get_local_player())) then
					if (chokedcmds == 0) or not (entity.is_alive(get_local_player())) then
						client.set_clan_tag(clantag)
					end
				end
			end
		end
	end
end)
local rfrsh = ui_new_button("LUA", "B", "Refresh List", function()
    updateNames()
    update_menu_item()
end)
c_event_cb("player_connect_full", function()
	if (ui_get(ct_lock)) then
	return
	end
    updateNames()
    update_menu_item()
    return
end)

c_event_cb("player_connect_full", function(e)
    oldTick = globals.tickcount()
end)