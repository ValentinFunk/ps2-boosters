Pointshop2.BoosterTypes = {}
Pointshop2.BoosterAlt = {}

function Pointshop2.AddBoosterType( tbl )
	Pointshop2.BoosterTypes[tbl.Name] = tbl
	if tbl.AltName then
		Pointshop2.BoosterAlt[tbl.AltName] = tbl
	end
end

function Pointshop2.GetBoosterByName( name )
	return Pointshop2.BoosterTypes[name] or Pointshop2.BoosterAlt[name]
end

function Pointshop2.BoostDrainWhenAlive( item, ply )
	return ply:Alive( ) and not (ply.IsSpec and ply:IsSpec())
end