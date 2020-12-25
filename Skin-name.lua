-- Thanks alot to nmchris, aviarita and w7rus
local function table_contains(tbl, item)
    for i=1, #tbl do
        if tbl[i] == item then
            return true
        end
    end
    return false
end

local function setName(name)
    client.set_cvar("name", name)
end

local knives = {
    "Bayonet", "Bowie Knife", "Butterfly Knife", 
    "Falchion Knife", "Flip Knife", "GutKnife", 
    "Huntsman Knife", "Karambit", "M9 Bayonet", "Navaja", 
    "Shadow Daggers", "Stiletto", "Talon", "Ursus"
}

local weaponsTable = {
    "Bayonet", "Bowie Knife", "Butterfly Knife", "Falchion Knife", 
    "Flip Knife", "GutKnife", "Huntsman Knife", "Karambit", 
    "M9 Bayonet", "Navaja", "Shadow Daggers", "Stiletto", 
    "Talon", "Ursus", "AWP", "AK-47", "Desert Eagle", 
    "Glock-18", "M4A4", "M4A1-S", "USP-S"
}

local team_colors = {
    [1] = "\x01",
    [2] = "\x09",
    [3] = "\x0B"
}

local rarity_colors = {
    ["Industrial (LightBlue)"]     = "\x0B",
    ["Mil spec (DarkBlue)"]        = "\x0C",
    ["Restricted (Pruple)"]        = "\x03",
    ["Classified (PinkishPurple)"] = "\x0E",
    ["Covert (Red)"]               = "\x07",
    ["Contraband (Orangeish)"]     = "\x10"
}

local type_messages = {
    ["Trade Message"] = " received in a trade:",
    ["Unbox Message"] = " has opened a container and found:"
}

local origName  = cvar.name:get_string()
local namesteal = ui.reference("MISC", "Miscellaneous", "Steal player name")

local enabled   = ui.new_checkbox    ("LUA", "A", "Enable Skin-Name")
local box1      = ui.new_checkbox    ("LUA", "A", "Box1")
local box2      = ui.new_checkbox    ("LUA", "A", "Box2")
local box3      = ui.new_checkbox    ("LUA", "A", "Box3")
local box4      = ui.new_checkbox    ("LUA", "A", "Box4")
local box5      = ui.new_checkbox    ("LUA", "A", "Box5")
local multi     = ui.new_multiselect ("LUA", "A", "Modifiers", "Auto-Disconnect", "Auto-Revert Name", "StatTrak Weapon", "White Name Color", "Custom Gap Value")
local text      = ui.new_combobox    ("LUA", "A", "Message Type", "Trade Message", "Unbox Message")
local weapon    = ui.new_combobox    ("LUA", "A", "Weapon Type", weaponsTable)
local rarity    = ui.new_combobox    ("LUA", "A", "Drop Rarity/Color", "Industrial (LightBlue)", "Mil spec (DarkBlue)", "Restricted (Pruple)", "Classified (PinkishPurple)", "Covert (Red)", "Contraband (Orangeish)")
local skin      = ui.new_textbox     ("LUA", "A", "skin")
local slider    = ui.new_slider      ("LUA", "A", "Gap Value", 1, 35, 1, true)

ui.set_visible(box1, false)
ui.set_visible(box2, false)
ui.set_visible(box3, false)
ui.set_visible(box4, false)
ui.set_visible(box5, false)

local function sync1()
    local Selected = ui.get(multi)
    for i=1, #Selected do
    if Selected[i] == "Auto-Disconnect"  then ui.set(box1, true) end
    if Selected[i] == "Auto-Revert Name" then ui.set(box2, true) end
    if Selected[i] == "StatTrak Weapon"  then ui.set(box3, true) end
    if Selected[i] == "White Name Color" then ui.set(box4, true) end
    if Selected[i] == "Custom Gap Value" then ui.set(box5, true) end    
    end
    if next(ui.get(multi)) == nil then
        ui.set(box1, false)
        ui.set(box2, false)
        ui.set(box3, false)
        ui.set(box4, false)
        ui.set(box5, false)
    end
end

local function sync2()
    local Selected = ui.get(multi)
    for i=1, #Selected do
    if Selected[i] ~= "Auto-Disconnect"  then ui.set(box1, false) end
    if Selected[i] ~= "Auto-Revert Name" then ui.set(box2, false) end
    if Selected[i] ~= "StatTrak Weapon"  then ui.set(box3, false) end
    if Selected[i] ~= "White Name Color" then ui.set(box4, false) end
    if Selected[i] ~= "Custom Gap Value" then ui.set(box5, false) end   
    end
    sync1()
end

local function test()
    client.delay_call(0.1, test)
    if not ui.get(enabled) then return end
    sync2()
    if ui.get(box5) then ui.set_visible(slider, true) else ui.set_visible(slider, false) end
end 
test()

local button = ui.new_button("LUA", "A", "Set Name", function()
    local local_player  = entity.get_local_player()
    local item          = ui.get(weapon)
    local weapon_name   = table_contains(knives, item) and "★ " or ""
    weapon_name         = ui.get(box3) and weapon_name .. "StatTrak™ " .. item or weapon_name .. item
    local team_color    = nil
    local rarity_color  = rarity_colors[ui.get(rarity)]
    local message       = type_messages[ui.get(text)]
    local skinname      = ui.get(skin)
    if ui.get(box4) then team_color = "\x01" else team_color = team_colors[entity.get_prop(local_player, "m_iTeamNum")] end
    local char = ""
    local char2 = ""
    local number = ui.get(slider)
    local name = string.len("" .. origName .. "" .. message .. "" .. weapon_name .. "" .. skinname .. "")
    print(name)

        if name == 25 then char = "" for _ = 1, 19 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 26 then char = "" for _ = 1, 19 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 27 then char = "" for _ = 1, 19 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 28 then char = "" for _ = 1, 18 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 29 then char = "" for _ = 1, 18 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 30 then char = "" for _ = 1, 18 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 31 then char = "" for _ = 1, 17 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 32 then char = "" for _ = 1, 17 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 33 then char = "" for _ = 1, 16 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 34 then char = "" for _ = 1, 16 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 35 then char = "" for _ = 1, 15 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 36 then char = "" for _ = 1, 15 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 37 then char = "" for _ = 1, 14 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 38 then char = "" for _ = 1, 14 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 39 then char = "" for _ = 1, 13 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 40 then char = "" for _ = 1, 12 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 41 then char = "" for _ = 1, 12 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 👌 "
    elseif name == 42 then char = "" for _ = 1, 11 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 43 then char = "" for _ = 1, 10 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 44 then char = "" for _ = 1,  9 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 45 then char = "" for _ = 1,  9 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 46 then char = "" for _ = 1,  8 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 47 then char = "" for _ = 1,  8 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 48 then char = "" for _ = 1,  7 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 49 then char = "" for _ = 1,  6 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 50 then char = "" for _ = 1,  5 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 51 then char = "" for _ = 1,  5 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 52 then char = "" for _ = 1,  4 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 53 then char = "" for _ = 1,  4 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 54 then char = "" for _ = 1,  3 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 55 then char = "" for _ = 1,  3 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 👌 "
    elseif name == 56 then char = "" for _ = 1,  2 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 "
    elseif name == 57 then char = "" for _ = 1,  1 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 "
    elseif name == 58 then char = "" for _ = 1,  1 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 "
    elseif name == 59 then char = "" for _ = 1,  1 do char = char .. "ᅠ" end char2 = "" char2 = " 👌 👌 👌 "
    elseif name == 60 then char = "" char2 = "" char2 = " 👌 👌 "
    elseif name == 61 then char = "" char2 = "" char2 = " 👌 👌 "
    elseif name == 62 then char = "" char2 = "" char2 = " 👌 👌 "
    elseif name == 63 then char = "" char2 = "" char2 = " 👌 👌 "
    elseif name == 64 then char = "" char2 = "" char2 = " 👌 👌 "
    elseif name == 65 then char = "" char2 = "" char2 = " "
    elseif name == 66 then char = "" char2 = "" char2 = " "
    elseif name  > 66 then char = "" char2 = "" print("Values above 66 Don't work properly.")
    end
        
    if table_contains(knives, ui.get(weapon)) then state = 1 else state = nil end
    if state == 1 then for _ = 1, 2 do char = char .. "ᅠ" end end
        
    if ui.get(box1) then state = 2 end
    if state == 2 then char2 = "" for _ = 1, 6 do char = char .. "ᅠ" end end  

    if ui.get(box3) then state = 3 end
    if state == 3 then for _ = 1, 3 do char = char .. "ᅠ" end end

    if ui.get(box5) then state = 4 end
    if state == 4 then char = "" for _ = 1, number do char = char .. "ᅠ" end end

        if ui.get(box1) then
            setName("👌" .. team_color .. "" .. origName .. "\x01" .. message .. "" .. rarity_color .. " " .. weapon_name .. " | " .. skinname .. "\n" .. char ..  "👌 \x01")
            client.delay_call(0.8, client.exec, "disconnect")
            client.delay_call(2.8, setName, (origName))
            client.delay_call(5.2, print("Automatically disconnected from the server after setting trade name."))
        else
            setName("👌" .. team_color .. "" .. origName .. "\x01" .. message .. "" .. rarity_color .. " " .. weapon_name .. " | " .. skinname .. "\n" .. char ..  "" .. char2 .. "\x01You")
    end
end)

local function handleMenu()
    local state = ui.get(enabled)
    ui.set_visible(multi, state)
    ui.set_visible(text, state)
    ui.set_visible(weapon, state)
    ui.set_visible(rarity, state)
    ui.set_visible(skin, state)
    ui.set_visible(slider, state)
    ui.set_visible(button, state)
    if state then
        origName  = cvar.name:get_string()
        ui.set(namesteal, true)
        setName("\n\xAD\xAD\xAD\xAD")
    else
        setName(origName)
        ui.set(box1, false)
        ui.set(box2, false)
        ui.set(box3, false)
        ui.set(box4, false)
        ui.set(box5, false)
    end
end

handleMenu()
ui.set_callback(enabled, handleMenu)

client.set_event_callback("player_hurt", function(e) -- thx 2 w7rus
    local localEntPlayer            = entity.get_local_player()
    local localEntPlayer_iTeamNum   = entity.get_prop(localEntPlayer, "m_iTeamNum")
    local victimIsTeammate = entity.get_prop(client.userid_to_entindex(e.userid), "m_iTeamNum") == localEntPlayer_iTeamNum
    local attackerIsLocalPlayer = client.userid_to_entindex(e.attacker) == localEntPlayer
    if not ui.get(box2) then return end

    if victimIsTeammate and attackerIsLocalPlayer then
        ui.set(enabled, false) handleMenu() print("Reverted name back to normal and disabled the main checkbox for the script.")
    end
end)
