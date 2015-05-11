/*
	PS2 Boosters r2342-{{ user_id }}
*/

hook.Add( "PS2_ModulesLoaded", "DLC_Boosters", function( )
	local MODULE = Pointshop2.GetModule( "Pointshop 2 DLC" )
	table.insert( MODULE.Blueprints, {
		label = "Booster",
		base = "base_booster",
		icon = "pointshop2/vip2.png",
		creator = "DBoosterCreator"
	} )
	
	MODULE.Settings.Shared.BoosterSettings = {
		info = {
			label = "Booster Settings"
		},
		UseCustomChancePicker = {
			value = true,
			label = "Use PS2 Role Picker",
			tooltip = "Overrides the TTT role picking system to use a custom version using weighted random maps. Required for using the TTT: Role Chance booster."
		},
	}
	
	table.insert( MODULE.SettingButtons, {
		label = "Booster Settings",
		icon = "pointshop2/small43.png",
		control = "DPointshop2BoostersConfigurator"
	} )
end )

hook.Add( "PS2_PopulateCredits", "AddBoostersCredit", function( panel )
	panel:AddCreditSection( "Pointshop 2 Boosters", [[
Pointshop 2 Boosters by Kamshak
	]] )
end )