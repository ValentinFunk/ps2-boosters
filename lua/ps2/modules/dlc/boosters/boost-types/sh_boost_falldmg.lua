local FallDmgBooster = {}

FallDmgBooster.Name = "Fall Damage Reduction"

--Same format as for module settings
FallDmgBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Fall Damage Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration after which the booster item expires. Use 0 for unlimited.",
			value = 3600
		},
		DamagePercent = {
			label = "Damage Reduction in percent",
			tooltip = "Amount of damage that is taken away in percent. Use 100% for no fall damage, 50% for half fall damage etc.",
			value = 50
		},
		PunchView = {
			label = "Puch View", 
			tooltip = "Wether or not to punch the view on a high fall to indicat that damage was reduced",
			value = true
		}
	}
}

FallDmgBooster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( FallDmgBooster )

if SERVER then
	local function removeFallDamage( target, dmginfo )
		if not target:IsPlayer() or not dmginfo:IsFallDamage() then
			return
		end
		
		local booster = target:PS2_GetItemInSlot( "Booster" )
		if not booster then 
			return 
		end
		
		if booster.boostType != FallDmgBooster.Name then
			return
		end
		
		
		local scale = math.Clamp( 1 - booster.boostParams["BasicSettings.DamagePercent"] / 100, 0, 1 )
		dmginfo:ScaleDamage( scale )
		if booster.boostParams["BasicSettings.PunchView"] then
			target:ViewPunch( Angle( 30, 0, 0 ) )
		end
		return false
	end
	hook.Add( 'EntityTakeDamage', 'TTTBoostScaleFallDmg', removeFallDamage )
 end