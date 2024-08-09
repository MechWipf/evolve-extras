/*-------------------------------------------------------------------------------------------------------------------------
	Team Manager
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Team Manager"
PLUGIN.Description = "Creates and autojoins Players to Teams."
PLUGIN.Author = "Mr.Faul"
PLUGIN.ChatCommand = "teamreinit"
PLUGIN.Privileges = { "TeamColors" }

------------ Color Backup -------------
-- Fauls Color Color(66,4,255,255)
local function ColorBackup()
evolve.ranks.owner.Color = Color( 78, 255, 0, 255 )
evolve.ranks.superadmin.Color = Color( 198, 0, 0, 255 )
evolve.ranks.admin.Color = Color( 255, 170, 0, 255)
evolve.ranks.respected.Color = Color( 0, 190, 255, 255 )
evolve.ranks.guest.Color = Color( 128, 128, 128, 255 )
end
concommand.Add("ev_resetColors", ColorBackup )
---------------------------------------------------------

------------- This Colors getting used if no colors are definined ---------------------------
------------- Only edit colors !!!!!!!!!
local SColors={}
SColors.guest = Color( 128, 128, 128, 255 )
SColors.admin = Color( 255, 170, 0, 255)
SColors.superadmin = Color( 198, 0, 0, 255 )
------------------------------------------------------------------------------------------------------

local TeamManager = {}

function TeamManager:Init()
	util.AddNetworkString( "SetUpTeams" )
	local idPointer = 0
	for name,data in pairs(evolve.ranks) do
		idPointer = idPointer + 1
		TeamManager[name] = {}
		TeamManager[name].id = idPointer
		local col
		if data.Color then
			col = data.Color
		else 
			col = SColors[data.UserGroup]
		end
		team.SetUp(idPointer,data.Title,col)
	end
end

if SERVER then
	TeamManager:Init()
end

local function SendTeams(ply)
	for name , data in pairs(team.GetAllTeams()) do
		local col = team.GetColor(name)
		if name != 0 and name != 1001 and name != 1002 then
			net.Start( "SetUpTeams" )
				net.WriteInt( name, 16 )
				net.WriteString( team.GetName(name) )
				net.WriteInt( col.r, 16 )
				net.WriteInt( col.g, 16 )
				net.WriteInt( col.b, 16 )
			net.Send(ply)
		end
	end
end

net.Receive( "SetUpTeams", function( len )
	local id = net.ReadInt(16)
	local title = net.ReadString()
	local col = Color( net.ReadInt(16), net.ReadInt(16), net.ReadInt(16) )
	team.SetUp(id,title,col)
end )

function TeamManager:checkTeam( ply )
	if !ply then return end
	if !ply:IsPlayer() then return end
	if !ply:EV_GetRank() then return end
	ply:SetTeam(TeamManager[ply:EV_GetRank()].id)
end

local function autorun()
	for k, v in pairs( player.GetAll() ) do
		TeamManager:checkTeam(v)
	end
	timer.Simple(10, autorun)
end

function PLUGIN:Call()
	evolve:SyncRanks()
	TeamManager:Init()
	
	timer.Simple(5,function()
		for k,v in pairs(player.GetAll()) do
			SendTeams(v)
		end
	end)
end

function PLUGIN:PlayerInitialSpawn( ply )
	timer.Simple(5,function()
		SendTeams(ply)
	end)
end

if SERVER then

function PLUGIN:PlayerSpawn( ply )
	TeamManager.checkTeam(ply)
end

autorun()
end

evolve:RegisterPlugin( PLUGIN )