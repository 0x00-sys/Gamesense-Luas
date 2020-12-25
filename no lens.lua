local get, get_lp, add_event, find_materials, uidtoentindex, checkbox = ui.get, entity.get_local_player, client.set_event_callback, materialsystem.find_materials, client.userid_to_entindex, ui.new_checkbox
local enabled = checkbox("visuals", "effects", "Remove scope lens")
add_event("paint", function(ctx)
	if (enabled) then
		local sleeve = find_materials("overlays/scope_lens")
		for i=#sleeve, 1, -1 do
			sleeve[i]:set_material_var_flag(2, get(enabled))
		end
	end
end)