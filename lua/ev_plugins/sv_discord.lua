--[[-------------------------------------------------------------------------------------------------------------------------
Works as relay between discord and gmod server
-------------------------------------------------------------------------------------------------------------------------]]
--
local PLUGIN = {}
PLUGIN.Title = "DiscordRelay"
PLUGIN.Description = "Sends and receives messages from discord"
PLUGIN.Author = "MechWipf"
PLUGIN.ChatCommand = "discord"
PLUGIN.Usage = "<enable=0|1>"
PLUGIN.Privileges = {"Discord (enable/disable)"}

---- Config for external stuff, enter your settings here ----
local config = {
	messagesUrl = "",
	apiKey = "",
	enabled = true
}
-------------------------------------------------------------

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "Discord (enable/disable)" ) then
		
		if args[1] == "1" then
			config.enabled = true
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " enabled Discord." )
		elseif args[1] == "0" then
			config.enabled = false
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " disabled Discord." )
		else
			if config.enabled then
				evolve:Notify( ply, evolve.colors.white, "Discord is currently enabled." )
			else
				evolve:Notify( ply, evolve.colors.white, "Discord is currently disabled." )
			end
		end

	end
end

function PLUGIN:Initialize ()
	hook.Add( "PlayerSay", "ev_discord", function( ply, strText, private )
		if private or not config.enabled then return end

		http.Post( config.messagesUrl .. "?key=" .. config.apiKey, { userSteamId = ply:SteamID(), userName = "test", content = strText }, function (result)
		end, function ( failed )
			config.enabled = false
		end )
	end)

	timer.Create( "ev_discord_fetch", 3, 0, function ()
		local function success ( body, _, _, code )
			if code == 200 then
				local jsonData = util.JSONToTable( body )
				for k, v in pairs( jsonData ) do
					pcall(function ()
						local uid = evolve:UniqueIDByProperty( "SteamID", v.steamId )
						local pl = player.GetByUniqueID( uid )

						umsg.Start( "EV_Discord" )
							umsg.String( evolve:GetProperty( uid, "Nick" ) )
							umsg.String( evolve:GetProperty( uid, "Rank" ) )
							umsg.String( v.content )
						umsg.End()
					end)
				end
			end
		end

		if config.enabled then
			http.Fetch( config.messagesUrl .. "?key=" .. config.apiKey, success, function ()
				config.enabled = false
			end)
		end
	end )
end

PLUGIN:Initialize()
evolve:RegisterPlugin( PLUGIN )
