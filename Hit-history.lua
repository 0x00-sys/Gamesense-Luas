local ui_get, ui_set, ui_new_checkbox, ui_new_slider, ui_set_visible, ui_new_slider, ui_new_color_picker = ui.get, ui.set, ui.new_checkbox, ui.new_slider, ui.set_visible, ui.new_slider, ui.new_color_picker

local draw_hitbox = client.draw_hitboxes
local draw_text = client.draw_text
local draw_rectangle = client.draw_rectangle
local cl_log = client.log
local get_cvar = client.get_cvar

local get_player_name = entity.get_player_name
local entity_is_enemy = entity.is_enemy
local get_local_player = entity.get_local_player

local userid_to_entindex = client.userid_to_entindex
local floor = math.floor

local dmg_dealth_ref = ui.reference("misc", "miscellaneous", "Log damage dealt")
local aimbot_logging =  ui_new_checkbox("rage", "other", "Aimbot history")

local logging_x = ui_new_slider("rage", "other", "Position (X)", 1, 1920)
local logging_y = ui_new_slider("rage", "other", "Position (Y)", 1, 1080)
local c_hit = ui_new_checkbox("rage", "other", "Draw hitbox of hit shots")
local c_hit_cp = ui_new_color_picker("rage", "other", "colors for hit", 0, 255, 0, 255)
local c_miss = ui_new_checkbox("rage", "other", "Draw hitbox of missed shots")
local c_miss_cp = ui_new_color_picker("rage", "other", "colors for miss", 255, 0, 0, 255)
local duration_slider = ui_new_slider("rage", "other", "Draw hitbox duration", 0, 10, 3, true)

local hitgroup_names = { "head", "chest", "stomach", "left arm",
    "right arm",  "left leg", "right leg" }

local columns = {"PLAYER", "HITGROUP", "DAMAGE", "REMAINING HP", "REMAINING ARMOR"}
	
local group_to_hitboxes = { { 0 }, { 4, 5, 6 }, { 2, 3 }, { 15, 16 }, { 17, 18 }, { 7, 9, 11 }, { 8, 10, 12 }, { 1 } }

local history = {}

for i = 1, 5, 1 do
	history[i] = {" ", " ", " ", " ", " "}
end

local base_x = 20
local base_y = 400
do
	ui_set(logging_x, base_x)
	ui_set(logging_y, base_y)
end

local function visibility(this)
	local k = ui_get(this)
	ui_set_visible(logging_x, k)
	ui_set_visible(logging_y, k)
	ui_set_visible(duration_slider, k)
	ui_set_visible(c_hit, k)
	ui_set_visible(c_hit_cp, k)
	ui_set_visible(c_miss, k)
	ui_set_visible(c_miss_cp, k)
end
ui.set_callback(aimbot_logging, visibility)

local function on_paint(ctx)
	if not ui_get(aimbot_logging) then
	return end
	
		base_x = ui_get(logging_x)
		base_y = ui_get(logging_y)
		
		--Only for hit shots
		draw_text(ctx, base_x+220, base_y-13, 193, 255, 107, 255, nil, 0, "Aimbot history")
		draw_rectangle(ctx, base_x, base_y, 500, 120, 29, 31, 38, 170)
        draw_rectangle(ctx, base_x, base_y, 500, 20, 29, 31, 38, 100)
		
		
		for i = 0,4,1 do
            draw_text(ctx, (base_x + 70) + (i * 95), base_y + 11, 193, 255, 107, 255, "-c", 70, columns[i+1])
            draw_text(ctx, (base_x + 70) + (i * 95), base_y + 29, 255, 255, 255, 255, "c", 70, history[1][i+1])
            draw_text(ctx, (base_x + 70) + (i * 95), base_y + 49, 255, 255, 255, 200, "c", 70, history[2][i+1])
            draw_text(ctx, (base_x + 70) + (i * 95), base_y + 69, 255, 255, 255, 150, "c", 70, history[3][i+1])
            draw_text(ctx, (base_x + 70) + (i * 95), base_y + 89, 255, 255, 255, 100, "c", 70, history[4][i+1])
            draw_text(ctx, (base_x + 70) + (i * 95), base_y + 109, 255, 255, 255, 50, "c", 70, history[5][i+1])
        end

end


local function on_player_hurt(e)
	if not ui_get(aimbot_logging) then
	return end
	
	local userid, attacker, hp_remaining, armor_remaining, dmg_hp, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.dmg_health, e.dmg_armor, e.hitgroup
	local entindex = userid_to_entindex(userid)
	local name = get_player_name(entindex)
	local group = hitgroup_names[e.hitgroup] or "?"
	local attacker_entindex = userid_to_entindex(attacker)
	local localplayer_entindex = get_local_player()
	
	
		
	for i = 5, 2, -1 do
		if attacker_entindex ~= localplayer_entindex then
		return end
		history[i] = history[i-1]
	end
		history[1] = {name, group, dmg_hp, hp_remaining, armor_remaining}
	
	
	-- Logs shots to the console (if you want to disable this, delete everything between this comment and the line below).
	if ui_get(dmg_dealth_ref) then return
	else
	cl_log("[gamesense] Hit ", name, " in ", group, " for ", dmg_hp, " damage", " (", hp_remaining, " health remaining)")
	end
	-------------------------------------------------------------------------------------------
	
end



local function on_aim_hit(e)
	local hitchance, hitgroup, target = e.hit_chance, e.hitgroup, e.target
	local duration = ui_get(duration_slider)
	
	if not ui_get(c_hit) then
	local h_r, h_g, h_b, h_a = 0, 255, 0, 255
		else
			h_r, h_g, h_b, h_a = ui_get(c_hit_cp)
	draw_hitbox(target, duration, group_to_hitboxes[e.hitgroup], h_r, h_g, h_b)
	end
end

local function on_aim_miss(e)
	local hitchance, hitgroup, target = e.hit_chance, e.hitgroup, e.target
	local duration = ui_get(duration_slider)
	
	if not ui_get(c_miss) then
	local m_r, m_g, m_b, m_a = 255, 0, 0, 255
		else
			m_r, m_g, m_b, m_a = ui_get(c_miss_cp)
	draw_hitbox(target, duration, group_to_hitboxes[e.hitgroup], m_r, m_g, m_b)
	end
end

client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("paint", on_paint)
client.set_event_callback("aim_hit", on_aim_hit)
client.set_event_callback("aim_miss", on_aim_miss)