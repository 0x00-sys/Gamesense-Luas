
local svg_data = ([[<svg id="svg" version="1.1" width="608" height="689" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ><g id="svgg"><path id="path0" d="M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 " stroke="none" fill="#fff200" fill-rule="evenodd"></path></g></svg>]])
local svg_data2 = ([[<svg id="svg" version="1.1" width="608" height="689" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" ><g id="svgg"><path id="path0" d="M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 " stroke="none" fill="#ff081d" fill-rule="evenodd"></path></g></svg>]])
local textureid = renderer.load_svg(svg_data,25,25)
local textureid2 = renderer.load_svg(svg_data2,25,25)

local ref_enabled = ui.new_checkbox("VISUALS", "Player ESP", "Zeus warning")

local function get_weapons(player) -- @sapphyrus
  local weapons = {}
  for i=0, 64 do
    local weapon = entity.get_prop(player, "m_hMyWeapons", i)
    if weapon ~= nil then
      table.insert(weapons, weapon)
    end
  end

  return weapons
end

local function on_paint(c)
	if ui.get(ref_enabled) then
		local local_player = entity.get_local_player()
		if local_player ~= nil then
			if entity.get_prop(local_player, "m_lifeState") == 0 then
			   local players = entity.get_players(true)
			   for i=1,#players do
					if entity.get_prop(players[i], "m_lifeState") == 0 then
						local active_weapon = entity.get_prop(players[i], "m_hActiveWeapon")
						if active_weapon ~= nil then
							local active_idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
							if active_idx ~= nil then 
								if active_idx == 31 then
									local x1, y1, x2 , y2 , mult = entity.get_bounding_box(players[i])
									if x1 ~= nil and mult > 0 then
										x1 = x1 - 24
											
										if x1 ~= nil and y1 ~= nil then
											renderer.texture(textureid2,x1,y1,25,25,255,255,255,255)
										end
									end
								else
									local weapons = get_weapons(players[i])
									for t=1 , #weapons do
										local idx = entity.get_prop(weapons[t], "m_iItemDefinitionIndex")
										if idx ~= nil then 
											if idx == 31 then -- if they have a zeus on their belt
												local x1, y1, x2 , y2 , mult = entity.get_bounding_box(players[i])
												if x1 ~= nil and mult > 0 then
													x1 = x1 - 24
														
													if x1 ~= nil and y1 ~= nil then
														renderer.texture(textureid,x1,y1,25,25,255,255,255,255)
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

client.set_event_callback("paint", on_paint)