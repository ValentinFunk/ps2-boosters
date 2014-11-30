local HealthBooster = {}

HealthBooster.Name = "Health"

--Same format as for module settings
HealthBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Health Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		BonusHP = {
			label = "Extra Health",
			tooltip = "The amount of HP that is added to the player on spawn",
			value = 50
		}
	}
}

function HealthBooster.ShouldDrainTime( item, ply )
	return ply:Alive( ) and ( ply.IsSpec and not ply:IsSpec( ) )
end

Pointshop2.AddBoosterType( HealthBooster )

if SERVER then
	hook.Add( "PlayerSpawn", "BoostHP", function( ply )
		local booster = ply:PS2_GetItemInSlot( "Booster" )
		if not booster then 
			return 
		end
		
		if booster.boostType == "Health" then
			ply:SetHealth( ply:Health( ) + booster.boostParams["BasicSettings.BonusHP"] )
		end
	end )
 end