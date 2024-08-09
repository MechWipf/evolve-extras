--[[-------------------------------------------------------------------------------------------------------------------------
	Restricts PAC3 to specific ranks
-------------------------------------------------------------------------------------------------------------------------]]--

local PLUGIN = {}
PLUGIN.Title = "PAC3"
PLUGIN.Description = "Restricts PAC3."
PLUGIN.Author = "MechWipf"
PLUGIN.Privileges = { "PAC3", "PAC3_Editor" }

function PLUGIN:Initialize()
	hook.Add( "PrePACConfigApply", "EV_PAC3_Restriction", function ( ply )
		if not ply:EV_HasPrivilege( "PAC3" ) then
			evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
			return false, "[EV] Insufficiant rank to use PAC3."
		end
	end )

	hook.Add( "PrePACEditorOpen", "EV_PAC3_Restriction", function ( ply )
		if not ply:EV_HasPrivilege( "PAC3_Editor" ) then
			evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
			return false, "[EV] Insufficiant rank to use PAC3."
		end
	end )
end

PLUGIN:Initialize()
evolve:RegisterPlugin( PLUGIN )
