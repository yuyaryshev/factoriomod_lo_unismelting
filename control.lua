-- control.lua
script.on_event(defines.events.on_player_selected_area, function(event)
    if event.item == "unismelting-planner" then
        local player = game.players[event.player_index]
        local shift = player.mod_settings["unismelting-shift-toggle"].value

        for _, ent in pairs(event.entities) do
            local newname = nil
            if string.sub(ent.name, 1, 4) == "uni-" then
                newname = string.sub(ent.name, 5)
            else
                newname = "uni-" .. ent.name
            end

            local surface = ent.surface
            local position = ent.position
            local force = ent.force
            local direction = ent.direction
            local quality = ent.quality
            local modules = ent.get_inventory(defines.inventory.assembling_machine_modules)
            local module_contents = modules.get_contents()

            ent.destroy()
            local newent = surface.create_entity{
                name = newname,
                position = position,
                force = force,
                direction = direction,
                raise_built = true,
                quality = quality,
                fast_replace = true
            }

            for name, count in pairs(module_contents) do
                newent.insert{name=name, count=count}
            end
        end
    end
end)
