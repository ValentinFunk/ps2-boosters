local SpeedBooster = {}

SpeedBooster.Name = "TTT/DR: Speed"
SpeedBooster.AltName = "TTT: Speed"
local function isSpeedBoost( name )
	return name == SpeedBooster.Name or name == SpeedBooster.AltName
end

--Same format as for module settings
SpeedBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Speed Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		SpeedIncrease = {
			label = "Speed Increase in percent",
			tooltip = "The increase of speed in percent.",
			value = 20
		}
	}
}

SpeedBooster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( SpeedBooster )

if SERVER then
	hook.Add( "TTTPlayerSpeed", "BoostSpeed", function( ply, slowed )
		local booster = ply:PS2_GetItemInSlot( "Booster" )
		if not booster then 
			return 
		end
		
		if slowed then return end
		
		if isSpeedBoost( booster.boostType ) then
			return 1 + booster.boostParams["BasicSettings.SpeedIncrease"] / 100
		end
	end )
	
	-- MrGash/Deathrun
	hook.Add( "PlayerSpawn", "BoostSpeedDR", function( ply )
		if not GAMEMODE.Deathrun_Func then
			return
		end
		
		--Execute next frame to avoid overwriting
		timer.Simple( 0, function( )
			local booster = ply:PS2_GetItemInSlot( "Booster" )
			if not booster then 
				return 
			end

			if isSpeedBoost( booster.boostType ) then
				local mul = 1 + booster.boostParams["BasicSettings.SpeedIncrease"] / 100
				
				if GAMEMODE.Deathrun_Func then
					-- MrGash/Deathrun
					ply:SetWalkSpeed(260 * mul)
					ply:SetRunSpeed(300 * mul)
				end
				if GAMEMODE.GameState then
					local class = baseclass.Get( player_manager.GetPlayerClass( ply ) )
					-- Blackvoid/Deathrun
					ply:SetWalkSpeed( class.WalkSpeed * mul )
					ply:SetRunSpeed( class.RunSpeed * mul )
				end
			end
		end )
	end )
 end