--region setup/config
-- Set this to either "a" or "b", depending on where you want the menu for the lua to be.
local script_menu_location = "b"
--endregion

--region gs_api
--region Client
local client = {
	latency = client.latency,
	log = client.log,
	userid_to_entindex = client.userid_to_entindex,
	set_event_callback = client.set_event_callback,
	screen_size = client.screen_size,
	eye_position = client.eye_position,
	color_log = client.color_log,
	delay_call = client.delay_call,
	visible = client.visible,
	exec = client.exec,
	trace_line = client.trace_line,
	draw_hitboxes = client.draw_hitboxes,
	camera_angles = client.camera_angles,
	draw_debug_text = client.draw_debug_text,
	random_int = client.random_int,
	random_float = client.random_float,
	trace_bullet = client.trace_bullet,
	scale_damage = client.scale_damage,
	timestamp = client.timestamp,
	set_clantag = client.set_clantag,
	system_time = client.system_time,
	reload_active_scripts = client.reload_active_scripts
}
--endregion

--region Entity
local entity = {
	get_local_player = entity.get_local_player,
	is_enemy = entity.is_enemy,
	hitbox_position = entity.hitbox_position,
	get_player_name = entity.get_player_name,
	get_steam64 = entity.get_steam64,
	get_bounding_box = entity.get_bounding_box,
	get_all = entity.get_all,
	set_prop = entity.set_prop,
	is_alive = entity.is_alive,
	get_player_weapon = entity.get_player_weapon,
	get_prop = entity.get_prop,
	get_players = entity.get_players,
	get_classname = entity.get_classname,
	get_game_rules = entity.get_game_rules,
	get_player_resource = entity.get_prop,
	is_dormant = entity.is_dormant,
}
--endregion

--region Globals
local globals = {
	realtime = globals.realtime,
	absoluteframetime = globals.absoluteframetime,
	tickcount = globals.tickcount,
	curtime = globals.curtime,
	mapname = globals.mapname,
	tickinterval = globals.tickinterval,
	framecount = globals.framecount,
	frametime = globals.frametime,
	maxplayers = globals.maxplayers,
	lastoutgoingcommand = globals.lastoutgoingcommand,
}
--endregion

--region Ui
local ui = {
	new_slider = ui.new_slider,
	new_combobox = ui.new_combobox,
	reference = ui.reference,
	set_visible = ui.set_visible,
	is_menu_open = ui.is_menu_open,
	new_color_picker = ui.new_color_picker,
	set_callback = ui.set_callback,
	set = ui.set,
	new_checkbox = ui.new_checkbox,
	new_hotkey = ui.new_hotkey,
	new_button = ui.new_button,
	new_multiselect = ui.new_multiselect,
	get = ui.get,
	new_textbox = ui.new_textbox,
	mouse_position = ui.mouse_position
}
--endregion

--region Renderer
local renderer = {
	text = renderer.text,
	measure_text = renderer.measure_text,
	rectangle = renderer.rectangle,
	line = renderer.line,
	gradient = renderer.gradient,
	circle = renderer.circle,
	circle_outline = renderer.circle_outline,
	triangle = renderer.triangle,
	world_to_screen = renderer.world_to_screen,
	indicator = renderer.indicator,
	texture = renderer.texture,
	load_svg = renderer.load_svg
}
--endregion
--endregion

--region dependencies
--region dependency: havoc_color
-- version 1.2.0

--region helpers
--- Convert HSL to RGB.
---
--- Original function by EmmanuelOga:
--- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
---
--- @param color Color
local function update_rgb_space(color)
	local r, g, b

	if (color.s == 0) then
		r, g, b = color.l, color.l, color.l
	else
		function hue_to_rgb(p, q, t)
			if t < 0   then t = t + 1 end
			if t > 1   then t = t - 1 end
			if t < 1/6 then return p + (q - p) * 6 * t end
			if t < 1/2 then return q end
			if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end

			return p
		end

		local q = 0

		if (color.l < 0.5) then
			q = color.l * (1 + color.s)
		else
			q = color.l + color.s - color.l * color.s
		end

		local p = 2 * color.l - q

		r = hue_to_rgb(p, q, color.h + 1/3)
		g = hue_to_rgb(p, q, color.h)
		b = hue_to_rgb(p, q, color.h - 1/3)
	end

	color.r = r * 255
	color.g = g * 255
	color.b = b * 255
end

--- Convert RGB to HSL.
---
--- Original function by EmmanuelOga:
--- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
---
--- @param color Color
local function update_hsl_space(color)
	local r, g, b = color.r / 255, color.g / 255, color.b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l

	l = (max + min) / 2

	if (max == min) then
		h, s = 0, 0
	else
		local d = max - min

		if (l > 0.5) then
			s = d / (2 - max - min)
		else
			s = d / (max + min)
		end

		if (max == r) then
			h = (g - b) / d

			if (g < b) then
				h = h + 6
			end
		elseif (max == g) then
			h = (b - r) / d + 2
		elseif (max == b) then
			h = (r - g) / d + 4
		end

		h = h / 6
	end

	color.h, color.s, color.l = h, s, l or 255
end

--- Validate the RGB+A space and clamp errors.
---
--- @param color Color
local function validate_rgba(color)
	color.r = math.min(255, math.max(0, color.r))
	color.g = math.min(255, math.max(0, color.g))
	color.b = math.min(255, math.max(0, color.b))
	color.a = math.min(255, math.max(0, color.a))
end

--- Validate the HSL+A space and clamp errors.
---
--- @param color Color
local function validate_hsla(color)
	color.h = math.min(1, math.max(0, color.h))
	color.s = math.min(1, math.max(0, color.s))
	color.l = math.min(1, math.max(0, color.l))

	color.a = math.min(1, math.max(0, color.a))
end
--endregion

--region class.color
local Color = {}

--- Color metatable.
local color_mt = {
	__index = Color,
	__call = function(tbl, ...) return Color.new_rgba(...) end
}

--- Create new color object in using the RGB+A space.
---
--- @param r int
--- @param g int
--- @param b int
--- @param a int
--- @return Color
function Color.new_rgba(r, g, b, a)
	if (a == nil) then
		a = 255
	end

	local object = setmetatable({r = r, g = g, b = b, a = a, h = 0, s = 0, l = 0}, color_mt)

	validate_rgba(object)
	update_hsl_space(object)

	return object
end

--- Create new color object in using the HSL+A space.
---
--- @param self Color
--- @param h int
--- @param s int
--- @param l int
--- @param a int
--- @return Color
function Color.new_hsla(h, s, l, a)
	if (a == nil) then
		a = 255
	end

	h = h % 1

	local object = setmetatable({r = 0, g = 0, b = 0, a = a, h = h, s = s, l = l}, color_mt)

	validate_hsla(object)
	update_rgb_space(object)

	return object
end

--- Create a color from a UI reference.
---
--- @param ui_reference ui_reference
--- @return Color
--- @since 1.1.0-release
function Color.new_from_ui_color_picker(ui_reference)
	local r, g, b, a = ui.get(ui_reference)

	return Color.new_rgba(r, g, b, a)
end

--- Create a color from another color.
---
--- @param color Color
--- @return Color
--- @since 1.2.0-release
function Color.new_from_other_color(color)
	local r, g, b, a = color:unpack_rgba()

	return Color.new_rgba(r, g, b, a)
end

--- Overwrite current color using RGB+A space.
---
--- @param self Color
--- @param r int
--- @param g int
--- @param b int
--- @param a int
function Color.set_rgba(self, r, g, b, a)
	if (a == nil) then
		a = 255
	end

	self.r, self.g, self.b, self.a = r, g, b, a

	validate_rgba(self)
	update_hsl_space(self)
end

--- Overwrite current color using HSL+A space.
---
--- @param self Color
--- @param h int
--- @param s int
--- @param l int
--- @param a int
function Color.set_hsla(self, h, s, l, a)
	if (a == nil) then
		a = 255
	end

	h = h % 1

	self.h, self.s, self.l, self.a = h, s, l, a

	validate_hsla(self)
	update_rgb_space(self)
end

--- Overwrite current color using a UI reference.
---
--- @param self Color
--- @param ui_reference ui_reference
--- @since 1.1.0-release
function Color.set_from_ui_color_picker(self, ui_reference)
	local r, g, b, a = ui.get(ui_reference)

	self:set_rgba(r, g, b, a)
end

--- Overwrite current color using another color.
---
--- @param self Color
--- @param color Color
--- @since 1.2.0-release
function Color.set_from_other_color(self, color)
	local r, g, b, a = color:unpack_rgba()

	self:set_rgba(r, g, b, a)
end

--- Unpack RGB+A space.
---
--- @param self Color
function Color.unpack_rgba(self)
	return self.r, self.g, self.b, self.a
end

--- Unpack HSL+A space.
---
--- @param self Color
function Color.unpack_hsla(self)
	return self.h, self.s, self.l, self.a
end

--- Unpack RGB, HSL, and A space.
---
--- @param self Color
--- @since 1.1.0-release
function Color.unpack_all(self)
	return self.r, self.g, self.b, self.h, self.s, self.l, self.a
end

--- Selects a color contrast.
---
--- Determines whether a colour is most visible against white or black, and returns white for 0, and 1 for black.
---
--- @param self Color
--- @return int
function Color.select_contrast(self, tolerance)
	tolerance = tolerance or 150

	local contrast = self.r * 0.213 + self.g * 0.715 + self.b * 0.072

	if (contrast < tolerance) then
		return 0
	end

	return 1
end

--- Generates a color contrast.
---
--- Determines whether a colour is most visible against white or black, and returns a new color object for the one chosen.
---
--- @param self Color
--- @return Color
function Color.generate_contrast(self, tolerance)
	local contrast = self:select_contrast(tolerance)

	if (contrast == 0) then
		return Color.new_rgba(255, 255, 255)
	end

	return Color.new_rgba(0, 0, 0)
end

--- Set the red channel value of the color.
---
--- @param self Color
--- @param r int
--- @since 1.2.0-release
function Color.set_red(self, r)
	self.r = math.min(255, math.max(0, r))

	update_hsl_space(self)
end

--- Set the green channel value of the color.
---
--- @param self Color
--- @param g int
--- @since 1.2.0-release
function Color.set_green(self, g)
	self.g = math.min(255, math.max(0, g))

	update_hsl_space(self)
end

--- Set the blue channel value of the color.
---
--- @param self Color
--- @param b int
--- @since 1.2.0-release
function Color.set_blue(self, b)
	self.b = math.min(255, math.max(0, b))

	update_hsl_space(self)
end

--- Set the hue of the color.
---
--- @param self Color
--- @param h float
function Color.set_hue(self, h)
	self.h = h % 1

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
function Color.shift_hue(self, amount)
	self.h = (self.h + amount) % 1

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount, but do not loop the spectrum.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
function Color.shift_hue_clamped(self, amount)
	self.h = math.min(1, math.max(0, self.h + amount))

	update_rgb_space(self)
end

--- Shift the hue of the color by a given amount, but keep within an upper and lower hue bound.
---
--- Use negative numbers go to down the spectrum.
---
--- @param self Color
--- @param amount float
--- @param lower_bound float
--- @param upper_bound float
function Color.shift_hue_within(self, amount, lower_bound, upper_bound)
	self.h = math.min(upper_bound, math.max(lower_bound, self.h + amount))

	update_rgb_space(self)
end

--- Returns true if hue is below or equal to a given hue.
---
--- @param self Color
--- @param h float
function Color.hue_is_below(self, h)
	return self.h <= h
end

--- Returns true if hue is above or equal to a given hue.
---
--- @param self Color
--- @param h float
function Color.hue_is_above(self, h)
	return self.h >= h
end

--- Returns true if hue is betwen two given hues.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function Color.hue_is_between(self, lower_bound, upper_bound)
	return self.h >= lower_bound and self.h <= upper_bound
end

--- Returns true if the hue is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param h float
--- @param tolerance float
--- @since 1.2.0-release
function Color.hue_is_within_tolerance(self, h, tolerance)
	return h <= self.h + tolerance and h >= self.h - tolerance
end

--- Set the saturation of the color.
---
--- @param self Color
--- @param s float
function Color.set_saturation(self, s)
	self.s = math.min(1, math.max(0, s))

	update_rgb_space(self)
end

--- Shift the saturation of the color by a given amount.
---
--- Use negative numbers to decrease saturation.
---
--- @param self Color
--- @param amount float
function Color.shift_saturation(self, amount)
	self.s = math.min(1, math.max(0, self.s + amount))

	update_rgb_space(self)
end

--- Shift the saturation of the color by a given amount, but keep within an upper and lower saturation bound.
---
--- Use negative numbers to decrease saturation.
---
--- @param self Color
--- @param amount float
function Color.shift_saturation_within(self, amount, lower_bound, upper_bound)
	self.s = math.min(upper_bound, math.max(lower_bound, self.s + amount))

	update_rgb_space(self)
end

--- Returns true if saturation is below or equal to a given saturation.
---
--- @param self Color
--- @param s float
function Color.saturation_is_below(self, s)
	return self.s <= s
end

--- Returns true if saturation is above or equal to a given saturation.
---
--- @param self Color
--- @param s float
function Color.saturation_is_above(self, s)
	return self.s >= s
end

--- Returns true if saturation is betwen two given saturations.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function Color.saturation_is_between(self, lower_bound, upper_bound)
	return self.s >= lower_bound and self.s <= upper_bound
end

--- Returns true if the saturation is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param s float
--- @param tolerance float
--- @since 1.2.0-release
function Color.saturation_is_within_tolerance(self, s, tolerance)
	return s <= self.s + tolerance and s >= self.s - tolerance
end

--- Set the lightness of the color.
---
--- @param self Color
--- @param l float
function Color.set_lightness(self, l)
	self.l = math.min(1, math.max(0, l))

	update_rgb_space(self)
end

--- Shift the lightness of the color within a given amount.
---
--- Use negative numbers to decrease lightness.
---
--- @param self Color
--- @param amount float
function Color.shift_lightness(self, amount)
	self.l = math.min(1, math.max(0, self.l + amount))

	update_rgb_space(self)
end

--- Shift the lightness of the color by a given amount, but keep within an upper and lower lightness bound.
-----
----- Use negative numbers to decrease lightness.
---
--- @param self Color
--- @param amount float
function Color.shift_lightness_within(self, amount, lower_bound, upper_bound)
	self.l = math.min(upper_bound, math.max(lower_bound, self.l + amount))

	update_rgb_space(self)
end

--- Returns true if lightness is below or equal to a given lightness.
---
--- @param self Color
--- @param l float
function Color.lightness_is_below(self, l)
	return self.l <= l
end

--- Returns true if lightness is above or equal to a given lightness.
---
--- @param self Color
--- @param l float
function Color.lightness_is_above(self, l)
	return self.l >= l
end

--- Returns true if lightness is betwen two given lightnesses.
---
--- @param self Color
--- @param lower_bound float
--- @param upper_bound float
function Color.lightness_is_between(self, lower_bound, upper_bound)
	return self.l >= lower_bound and self.l <= upper_bound
end

--- Returns true if the lightness is within a given tolerance at a specific hue value. False if not.
---
--- @param self Color
--- @param l float
--- @param tolerance float
--- @since 1.2.0-release
function Color.lightness_is_within_tolerance(self, l, tolerance)
	return l <= self.l + tolerance and l >= self.l - tolerance
end

--- Sets the alpha of the color.
---
--- @param self Color
--- @param alpha int
--- @since 1.1.0-release
function Color.set_alpha(self, alpha)
	self.a = alpha

	validate_rgba(self)
end

--- Returns true if the color is truely invisible (0 alpha).
---
--- @param self Color
function Color.is_invisible(self)
	return self.a == 0
end

--- Returns true if the color is invisible to within a given tolerance (0-255 alpha).
---
--- @param self Color
--- @param tolerance int
function Color.is_invisible_within(self, tolerance)
	return self.a <= 0 + tolerance
end

--- Returns true if the color is truely visible (255 alpha).
---
--- @param self Color
function Color.is_visible(self)
	return self.a == 255
end

--- Returns true if the color is visible to within a given tolerance (0-255 alpha).
---
--- @param self Color
--- @param tolerance int
function Color.is_visible_within(self, tolerance)
	return self.a >= 255 - tolerance
end

--- Increase the alpha of the color by a given amount.
---
--- @param self Color
--- @param amount int
function Color.fade_in(self, amount)
	if (self.a == 255) then
		return
	end

	self.a = self.a + amount

	if (self.a > 255) then
		self.a = 255
	end
end

--- Decrease the alpha of the color by a given amount.
---
--- @param self Color
--- @param amount int
function Color.fade_out(self, amount)
	if (self.a == 0) then
		return
	end

	self.a = self.a - amount

	if (self.a < 0) then
		self.a = 0
	end
end
--endregion
--endregion
--endregion

--region globals
-- Screen width.
local screen_width, screen_height = client.screen_size()
local color = Color.new_rgba(0, 85, 101, 12)
--endregion

--region ui
if (script_menu_location ~= "a" and script_menu_location ~= "b") then
	script_menu_location = "a"
end

local enable_plugin = ui.new_checkbox(
	"lua",
	script_menu_location,
	"Enable Havoc Color Correction"
)

local ui_color = ui.new_color_picker(
	"lua",
	script_menu_location,
	"|   Color",
	color.r,
	color.g,
	color.b,
	color.a
)

ui.set_visible(ui_color, false)

local function handle_enable_plugin()
	local menu_visible = ui.get(enable_plugin) == true

	ui.set_visible(ui_color, menu_visible)
end
--endregion

--region on_paint
local function on_paint()
	if (ui.get(enable_plugin) == false) then
		return
	end

	renderer.gradient(
		0,
		0,

		screen_width,
		screen_height,

		color.r,
		color.g,
		color.b,
		color.a,

		color.r,
		color.g,
		color.b,
		color.a,

		false
	)
end
--endregion

--region hooks
client.set_event_callback('paint', on_paint)

ui.set_callback(enable_plugin, handle_enable_plugin)
ui.set_callback(ui_color, function()
	color:set_from_ui_color_picker(ui_color)
end)
--endregion
