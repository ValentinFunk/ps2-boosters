local Booster = {}

Booster.Name = "Jump Power"

--Same format as for module settings
Booster.Settings = {
	BasicSettings = {
		info = {
			label = "Jump Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		JumpIncrease = {
			label = "Jump Height Boost (in %)",
			tooltip = "The amount of jump power added to a player on spawn.",
			value = 50
		}
	}
}

Booster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( Booster )

if SERVER then
	local function GetDefaultJumpPower( ply )
		if GAMEMODE.Deathrun_Func then
			-- MrGash/Deathrun
			return 190
		end
		if engine.ActiveGamemode( ) == "terrortown" then
			-- TTT
			return 160
		end

		local playerClass = player_manager.GetPlayerClass( ply )

		-- Default or Blackvoid/Deathrun
		local class = playerClass and baseclass.Get( playerClass ) or { JumpPower = 160 }
		return class.JumpPower
	end

	local function ApplyBooster( ply )
		local booster = ply:PS2_GetItemInSlot( "Booster" )
		if not booster then
			return
		end

		if booster.boostType == Booster.Name then
			local mul = 1 + booster.boostParams["BasicSettings.JumpIncrease"] / 100
			ply:SetJumpPower( GetDefaultJumpPower( ply ) * mul )
		end
	end

	local function ResetBooster( ply )
		ply:SetJumpPower( GetDefaultJumpPower( ply ) )
	end

	hook.Add( "PlayerSpawn", "Jump", function( ply )
		timer.Simple( 0, function( )
			ApplyBooster( ply )
		end )
	end )

	hook.Add( "PlayerDeath", "JumpoostTTTres", function( ply )
		ResetBooster( ply )
	end )

 end
