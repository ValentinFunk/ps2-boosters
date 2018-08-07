local function GetTraitorCount(ply_count)
	-- get number of traitors: pct of players rounded down
	local traitor_count = math.floor(ply_count * GetConVar("ttt_traitor_pct"):GetFloat())
	-- make sure there is at least 1 traitor
	traitor_count = math.Clamp(traitor_count, 1, GetConVar("ttt_traitor_max"):GetInt())
	return traitor_count
end

local function GetDetectiveCount(ply_count)
	if ply_count < GetConVar("ttt_detective_min_players"):GetInt() then return 0 end
	local det_count = math.floor(ply_count * GetConVar("ttt_detective_pct"):GetFloat())
	-- limit to a max
	det_count = math.Clamp(det_count, 1, GetConVar("ttt_detective_max"):GetInt())
	return det_count
end

local function pickRandomElement( weightedMap )
	--Generate cumulative sum table
	local sumTbl = {}
	local sum = 0
	for ply, weight in pairs( weightedMap ) do
		sum = sum + weight
		table.insert( sumTbl, {sum = sum, ply = ply })
	end

	--Pick element
	local r = math.random() * sum
	local ply
	for _, info in ipairs( sumTbl ) do
		if info.sum > r then
			ply = info.ply
			break
		end
	end
	return ply
end

local function pickRole( weightedMap, role, amount )
	local amountSelected = 0
	while amountSelected < amount do
		local ply = pickRandomElement( weightedMap )
		if not ply then
			--No more left in list
			return amountSelected
		end
		
		ply:SetRole( role )
		weightedMap[ply] = nil --remove from weighted map
		amountSelected = amountSelected + 1
	end
	return amountSelected
end

local function getChanceBoost( ply, role )
	local booster = ply:PS2_GetItemInSlot( "Booster" )
	if booster then 
		if booster.boostType == "TTT: Role Chance" then
			if role == booster.boostParams["BasicSettings.Role"] then
				return 1 + booster.boostParams["BasicSettings.ChanceIncrease"] / 100
			end
		end
	end
	
	return 1
end

local function NewSelectRoles()
	local choices = {}
	local prev_roles = {
		[ROLE_INNOCENT] = {},
		[ROLE_TRAITOR] = {},
		[ROLE_DETECTIVE] = {}
	};

	if not GAMEMODE.LastRole then GAMEMODE.LastRole = {} end

	for k,v in pairs(player.GetAll()) do
		-- everyone on the spec team is in specmode
		if IsValid( v ) and ( not v:IsSpec( ) ) then
			-- save previous role and sign up as possible traitor/detective
			local r = GAMEMODE.LastRole[v:UniqueID( )] or v:GetRole( ) or ROLE_INNOCENT
			table.insert( prev_roles[r], v )
			table.insert( choices, v )
		end

		v:SetRole(ROLE_INNOCENT)
	end

	-- determine how many of each role we want
	local choice_count = #choices
	if choice_count == 0 then return end
	
	local traitor_count = GetTraitorCount(choice_count)
	local det_count = GetDetectiveCount(choice_count)
	
	-- Pick Traitors first
	local weightedMap = {}
	for k, v in pairs( choices ) do
		if table.HasValue( prev_roles[role], v ) then
			weightedMap[v] = 0.3
		else
			weightedMap[v] = 1
		end
		weightedMap[v] = weightedMap[v] * getChanceBoost( v, "Traitor" )
	end
	pickRole( weightedMap, ROLE_TRAITOR, traitor_count )
	for k, v in pairs( choices ) do
		if v:GetRole( ) == ROLE_TRAITOR then
			choices[k] = nil
		end
	end

	weightedMap = {}
	-- Pick Detectives
	local min_karma = GetConVarNumber("ttt_detective_min_karma") or 0
	for k, v in pairs( choices ) do
		-- Don't add a player if they have selected not to be a detective
		if v:GetAvoidDetective( ) then
			continue
		end
		
		-- Innos have a better chance than those who had a role last game
		if table.HasValue( prev_roles[ROLE_INNOCENT], v ) then
			weightedMap[v] = 1 
		else
			weightedMap[v] = 0.3
		end
		
		-- Bad Karma = worse chance of becoming traitor
		if v:GetBaseKarma() < min_karma then
			weightedMap[v] = 0.3
		end
		
		weightedMap[v] = weightedMap[v] * getChanceBoost( v, "Detective" )
	end
	local amountSelected = pickRole( weightedMap, ROLE_DETECTIVE, det_count )
	
	-- sometimes we need all remaining choices to be detective to fill the
	-- roles up, this happens more often with a lot of detective-deniers
	if amountSelected < det_count then
		for k, v in pairs( choices ) do
			if IsValid( v ) and v:GetRole( ) != ROLE_TRAITOR and v:GetRole( ) != ROLE_DETECTIVE then
				v:SetRole( ROLE_DETECTIVE )
			end
		end
	end

	
	GAMEMODE.LastRole = {}

	for _, ply in pairs(player.GetAll()) do
		-- initialize credit count for everyone based on their role
		ply:SetDefaultCredits()

		-- store a uid -> role map
		GAMEMODE.LastRole[ply:UniqueID()] = ply:GetRole()
	end
end

local OldSelectInitializedPromise = LibK.InitPostEntityPromise:Then(function()
	OldSelectRoles = OldSelectRoles or SelectRoles
end)

local function ReplaceSelectMethod( )
	if Pointshop2.GetSetting( "Pointshop 2 DLC", "BoosterSettings.UseCustomChancePicker" ) then
		SelectRoles = NewSelectRoles
		KLogf( 4, "[PS2-Boosters] Replaced TTT Rolepicking" )
	else
		SelectRoles = OldSelectRoles
	end
end

hook.Add( "PS2_OnSettingsUpdate", "ChangeKeyHook", function( )
	OldSelectInitializedPromise:Done(function()
		ReplaceSelectMethod( )
	end)
end )
Pointshop2.SettingsLoadedPromise:Then( function( )
	return OldSelectInitializedPromise
end ):Done(function()
		ReplaceSelectMethod( )
end )
