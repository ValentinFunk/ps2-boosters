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

HealthBooster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( HealthBooster )

if SERVER then
	local function ApplyBooster( ply )
		local booster = ply:PS2_GetItemInSlot( "Booster" )
		if not booster then 
			return 
		end

		if booster.boostType == "Health" then
			ply:SetHealth( ply:Health( ) + booster.boostParams["BasicSettings.BonusHP"] )
			if ply:GetMaxHealth( ) < ply:Health( ) then
				ply:SetMaxHealth( ply:Health( ) )
			end
		end
	end
	
	hook.Add( "PlayerSpawn", "BoostHP", function( ply )
		timer.Simple( 0, function( )
			ApplyBooster( ply )
		end )
	end )
	
	hook.Add( "TTTBeginRound", "BoostHP", function( ) 
		for k, v in pairs( player.GetAll( ) ) do
			timer.Simple( 0, function( )
				ApplyBooster( v )
			end )
		end
	end )
 end