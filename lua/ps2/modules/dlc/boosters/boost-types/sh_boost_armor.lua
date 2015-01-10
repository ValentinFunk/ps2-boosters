local ArmorBooster = {}

ArmorBooster.Name = "Armor"

--Same format as for module settings
ArmorBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Armor Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		BonusAP = {
			label = "Extra Armor",
			tooltip = "The amount of armor that is added to the player on spawn",
			value = 50
		}
	}
}

ArmorBooster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( ArmorBooster )

if SERVER then
	local function ApplyBooster( ply )
		local booster = ply:PS2_GetItemInSlot( "Booster" )
		if not booster then 
			return 
		end
		
		if booster.boostType == "Armor" then
			ply:SetArmor( ply:Armor( ) + booster.boostParams["BasicSettings.BonusAP"] )
		end
	end
	hook.Add( "PlayerSpawn", "BoostAP", function( ply )
		timer.Simple( 0, function( )
			ApplyBooster( ply )
		end )
	end )
 end