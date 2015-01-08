Pointshop2.BoosterTypes = {}

function Pointshop2.AddBoosterType( tbl )
	Pointshop2.BoosterTypes[tbl.Name] = tbl
end

function Pointshop2.GetBoosterByName( name )
	return Pointshop2.BoosterTypes[name]
end

function Pointshop2.BoostDrainWhenAlive( item, ply )
	return ply:Alive( ) and not (ply.IsSpec and ply:IsSpec())
end