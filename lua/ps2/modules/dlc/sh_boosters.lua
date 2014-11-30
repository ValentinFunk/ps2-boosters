hook.Add( "PS2_ModulesLoaded", "DLC_Boosters", function( )
	local MODULE = Pointshop2.GetModule( "Pointshop 2 DLC" )
	table.insert( MODULE.Blueprints, {
		label = "Booster",
		base = "base_booster",
		icon = "pointshop2/vip2.png",
		creator = "DBoosterCreator"
	} )
end )