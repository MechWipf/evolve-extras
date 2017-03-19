--[[-------------------------------------------------------------------------------------------------------------------------
Works as relay between discord and gmod server
-------------------------------------------------------------------------------------------------------------------------]]
--
local PLUGIN = {}
PLUGIN.Title = "DiscordRelay_cl"
PLUGIN.Description = "Sends and receives messages from discord"
PLUGIN.Author = "MechWipf"
PLUGIN.Privileges = {}

local function PlayerChat( name, rank, txt )
	if ( table.Count( evolve.ranks ) > 0 and GAMEMODE.IsSandboxDerived ) then
		local tab = {}

    table.insert( tab, Color(55, 153, 255) )
    table.insert( tab, "(DISCORD) " )

		if ( LocalPlayer():EV_HasPrivilege( "See chat tags" ) and rank != "guest" ) then
			table.insert( tab, color_white )
			table.insert( tab, "(" .. evolve.ranks[ rank ].Title .. ") " )
		end

    table.insert( tab, evolve.ranks[ rank ].Color )
    table.insert( tab, name )

		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, ": " .. txt )

		chat.AddText( unpack( tab ) )

		return true
	end
end

usermessage.Hook( "EV_Discord", function( um )
	PlayerChat( um:ReadString(), um:ReadString(), um:ReadString() )
end )

evolve:RegisterPlugin( PLUGIN )
