addon.name    = 'healbell';
addon.author  = 'Vetoniemi Jari Juhani';
addon.version = '1.0';
addon.desc    = 'Play a ding sound when HP/MP become full while resting';
addon.link    = 'https://github.com/Cloudef/healbell';

local has_dinged = false;
local ding_path = string.format('%s\\sounds\\ding.wav', addon.path);

-- dumb event type to use but packet_in has HP values before they were applied by the packet
ashita.events.register('d3d_present', 'healbell', function()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local party = AshitaCore:GetMemoryManager():GetParty();
    local entity = GetPlayerEntity();
    if not player or not party or not entity then return false end

    -- check if the player is currently resting (/heal)
    if entity.Status == 33 then
        if party:GetMemberHP(0) == player:GetHPMax() and party:GetMemberMP(0) == player:GetMPMax() then
            if not has_dinged then
                ashita.misc.play_sound(ding_path);
                has_dinged = true;
            end
        else
            has_dinged = false;
        end
    end
end)
