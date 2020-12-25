--ui funcs
local ui_ref, ui_cb, ui_set_vis, ui_set, ui_get = ui.reference, ui.set_callback, ui.set_visible, ui.set, ui.get
local ui_checkbox, ui_combobox, ui_slider, ui_multiselect, ui_colorpicker, ui_hotkey = ui.new_checkbox, ui.new_combobox, ui.new_slider, ui.new_multiselect, ui.new_color_picker, ui.new_hotkey


--client funcs
local c_event_cb, c_screensize, c_exec, uid2ent, trace_line, set_clantag = client.set_event_callback, client.screen_size, client.exec, client.userid_to_entindex, client.trace_line, client.set_clan_tag

--entity funcs
local hitbox_pos, localplayer, is_enemy, is_alive, is_dormant, get_prop, get_name, get_all_players, get_all = entity.hitbox_positon, entity.get_local_player, entity.is_enemy, entity.is_alive, entity.is_dormant, entity.get_prop, entity.get_player_name, entity.get_players, entity.get_all
local get_classname = entity.get_classname

local e_get_gamerules, e_get_player_resource = entity.get_game_rules, entity.get_player_resource

--material funcs
local find_mats, find_mat = materialsystem.find_materials, materialsystem.find_material


--misc renamed funcs
local delay_call, getvar, setvar = client.delay_call, client.get_cvar, client.set_cvar

--math funcs

local table_insert, table_remove, math_floor, math_sqrt, math_min, math_abs  = table.insert, table.remove, math.floor, math.sqrt, math.min, math.abs
--globals 
local curtime, realtime, frametime, absoluteframetime, maxplayers, tickcount, framecount, mapname = globals.curtime, globals.realtime, globals.frametime, globals.absoluteframetime, globals.maxplayers, globals.tickcount, globals.framecount, globals.mapname

local get_bbox = entity.get_bounding_box

local rect, gradient, circle_outline,text = renderer.rectangle, renderer.gradient, renderer.circle_outline, renderer.text

local function multi_container(x, y, w, h, header,header2, content, content2)
	--local r,g,b,a = 47,50,64, 255
	local r,g,b,a = 44,48,54, 255
	
	local y2 = y + h + 4
	--begin container
	--rect(x - 2, y2 - 2, w + 4, h * #content + 4, 0,0,0, 50) -- Draw our container's shader
	rect(x, y2, w, h * #content, r, g, b, a) -- Draw our container's rectangle
	--rect(x, y2, w, h * #content, r, g, b, a) -- Draw our container's rectangle
	for i=1, #content do
		y_text = y + 10 + (h*i)
		x_text = x + 8
        text(x_text,y_text, 255,255,255,255, nil, 0, content[i])
        text(x + w/2,y_text, 255,255,255,255, nil, 0, content2[i])
	end

	rect(x, y, w, h, r, g, b, a) -- Draw our header's rectangle
    text(x + 8,y + 4, 255,255,255,255, nil, 0, header)
    text(x + w/2,y + 4, 255,255,255,255, nil, 0, header2)
end

local open = ui_hotkey("LUA", "A", "Show competive wins")

local FL_FAKECLIENT = 0x200
local function flag_set(flag, player)
    player = player or localplayer()
    local flags = get_prop(player, "m_fFlags")

    return flags ~= nil and bit.band(flags, flag) == flag
end
local sx,sy = client.screen_size()
local slider1 = ui.new_slider("LUA", "A", "Wins X", 1, sx, sx / 7)
local slider2 = ui.new_slider("LUA", "A", "Wins Y", 1, sy, sy / 2)
local score = cvar.score
c_event_cb("paint", function(c) 
    local PlayerResource = entity.get_player_resource()
    local container = {}
    local container2 = {}
    local w, h = 200, 25
    for i=1, globals.maxplayers() do
        
        if get_classname(i) == "CCSPlayer" then
            
            local name = get_name(i)
            if (name:len() >= 10) then
                name = string.sub(name, 1, 10)
            end
            local wins = get_prop(PlayerResource, "m_iCompetitiveWins", i)
            local flags = get_prop(i, "m_fFlags")
            if not flag_set(FL_FAKECLIENT, i) and get_prop(PlayerResource, "m_iPing", i) ~= 0 then
                container[#container+1] = name
                container2[#container2+1] = wins
            end
        end
    end
    if (#container > 1 and ui_get(open)) then
        multi_container(ui_get(slider1),ui_get(slider2), 200,25, "name", "wins", container, container2)
    end
end)