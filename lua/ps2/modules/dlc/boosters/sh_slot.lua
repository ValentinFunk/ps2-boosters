Pointshop2.AddEquipmentSlot( "Booster", function( item )
	--Check if the item is a Booster
	return instanceOf( Pointshop2.GetItemClassByName( "base_booster" ), item )
end )