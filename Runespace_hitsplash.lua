-- xboxlivegold
local bit_bor, client_eye_position, client_find_signature, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_hitbox_position, entity_is_enemy, globals_tickcount, math_sqrt, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_label, ui_new_slider, ui_set, error, pairs = bit.bor, client.eye_position, client.find_signature, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.hitbox_position, entity.is_enemy, globals.tickcount, math.sqrt, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_label, ui.new_slider, ui.set, error, pairs
local render_loadpng, render_drawtexture, render_text, renderer_world_to_screen, globals_realtime = renderer.load_png, renderer.texture, renderer.text, renderer.world_to_screen, globals.realtime

local enabled_ref = ui_new_checkbox( "LUA", "B", "Runescape Hitsplats" )

local blue_tex = render_loadpng( readfile( "runescape_hitsplats/blue.png" ), 24, 22 )
local red_tex = render_loadpng( readfile( "runescape_hitsplats/red.png" ), 24, 22 )

local da_splatz = { }

local function draw_splat( damage, x, y, alpha )
	if damage == 0 then
		render_drawtexture( blue_tex, x - 12, y - 11, 24, 22, 255, 255, 255, alpha, "f" )
		render_text( x, y, 255, 255, 255, alpha, "c", 0, "0")
	else
		render_drawtexture( red_tex, x - 12, y - 11, 24, 22, 255, 255, 255, alpha, "f" )
		render_text( x, y, 255, 255, 255, alpha, "c", 0, damage)
	end
end

local function draw_splats( )
	local enabled = ui_get(enabled_ref)
	if not enabled then
		return
	end

	if #da_splatz > 0 then
		local realtime = globals_realtime()
		for i = 1, #da_splatz do
			local splat = da_splatz[i]
			if splat[1] + 3 > realtime then
				local screen_x, screen_y = renderer_world_to_screen(splat[2], splat[3], splat[4])
				if screen_x ~= nil and screen_x ~= nil then 
					draw_splat(splat[6], screen_x, screen_y, 255)
				end
			end
		end
	end
end

client.set_event_callback("paint_ui", 
    function()
        draw_splats()
    end
)

local hgroup_to_hbox = {
	[1] = {0, 1},
	[2] = {4, 5, 6},
	[3] = {2, 3},
	[4] = {13, 15, 16},
	[5] = {14, 17, 18},
	[6] = {7, 9, 11},
	[7] = {8, 10, 12}
}

client.set_event_callback("aim_hit", 
	function(e)
		local target = e.target 
		local realtime = globals_realtime()
		local x, y, z = entity_hitbox_position(target, hgroup_to_hbox[e.hitgroup][1])
		table.insert(da_splatz, {realtime, x, y, z, target, e.damage})
	end
)

client.set_event_callback("aim_miss", 
	function(e)
		local target = e.target
		local realtime = globals_realtime()
		local x, y, z = entity_hitbox_position(target, hgroup_to_hbox[e.hitgroup][1])
		table.insert(da_splatz, {realtime, x, y, z, target, 0})
	end
)

client.set_event_callback("round_start", 
	function(e)
		da_splatz = { }
	end
)

client.set_event_callback("player_death", --wont eat mem on DM servers LULW
	function(e)
		local me = entity_get_local_player()
		if client_userid_to_entindex(e.userid) == me then
			da_splatz = { }
		end
	end
)