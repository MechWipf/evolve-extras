/* ----------------------------------------------------------------------------
						Physic Settings
------------------------------------------------------------------------------- */

local PLUGIN = {}
PLUGIN.Title = "Physic Settings"
PLUGIN.Description = "Adds a cmd to manage the Physics limits,"
PLUGIN.Author = "MechWipf"
PLUGIN.ChatCommand = "physlimit"
PLUGIN.Privileges = { "physlimits" }

function PLUGIN:Call(ply,args)
	if ( ply:EV_HasPrivilege( "physlimits" ) ) then
		local maxvel, maxangvel = tonumber(args[#args-1]) or 4000, tonumber(args[#args]) or 3500
		local phys = {}
		PrintTable(args)
		phys.MaxVelocity = maxvel
		phys.MaxAngularVelocity = maxangvel
		
		physenv.SetPerformanceSettings(phys)
		
		evolve:Notify( evolve.colors.white, "New Physicslimits: ", evolve.colors.blue, "\nMaxVelocity", evolve.colors.white, " = ", evolve.colors.red, tostring(maxvel), evolve.colors.blue, "\nMaxAngularVelocity", evolve.colors.white, " = ", evolve.colors.red, tostring(maxangvel))
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )