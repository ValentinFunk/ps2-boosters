local SpeedBooster = {}

SpeedBooster.Name = "TTT: Speed"

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
		
		if booster.boostType == "TTT: Speed" then
			return 1 + booster.boostParams["BasicSettings.SpeedIncrease"] / 100
		end
	end )
 end