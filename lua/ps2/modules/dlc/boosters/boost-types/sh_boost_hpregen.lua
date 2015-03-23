local HealthRestoreBooster = {}

HealthRestoreBooster.Name = "Health Regen"

--Same format as for module settings
HealthRestoreBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Health Regeneration Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		HpPerSec = {
			label = "Health restored / second",
			tooltip = "The amount of HP that is restored per second",
			value = 2
		},
		KickinDelay = {
			label = "Activation delay in seconds",
			tooltip = "How long until the regeneration kicks in after taking damage in seconds",
			value = 5
		}
	}
}

HealthRestoreBooster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( HealthRestoreBooster )

if SERVER then
	local function restoreHealthTick( ply, booster )
		ply.lastDamage = ply.lastDamage or 0
		
		local delay = booster.boostParams["BasicSettings.KickinDelay"]
		if CurTime( ) > ply.lastDamage + delay then
			local newHp = math.Clamp( ply:Health( ) + booster.boostParams["BasicSettings.HpPerSec"], 0, ply:GetMaxHealth( ) )
			ply:SetHealth( newHp )
		end
	end
	
	timer.Create( "RestoreHealthBooster", 1, 0, function( )
		for k, v in pairs( player.GetAll( ) ) do
			local booster = v:PS2_GetItemInSlot( "Booster" )
			if not booster then 
				continue 
			end

			if booster.boostType != HealthRestoreBooster.Name then
				continue
			end

			restoreHealthTick( v, booster )
		end
	end )
	
	hook.Add( "EntityTakeDamage", "RestoreHealthBoosterTAKEDMG", function( target, dmg )
		if not IsValid( target ) or not target:IsPlayer( ) then
			return
		end
		
		target.lastDamage = CurTime( )
	end )
 end