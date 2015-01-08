local PointsBooster = {}

PointsBooster.Name = "Points"

--Same format as for module settings
PointsBooster.Settings = {
	BasicSettings = {
		info = {
			label = "Points Settings",
		},
		Duration = {
			label = "Duration in seconds",
			tooltip = "Duration over which the points bonus is given in seconds. Use 0 for never expiring boosters",
			value = 3600
		},
		Increment = {
			label = "Boost Amount in percent",
			tooltip = "The amount of bonus points awarded as percentage. 50 means that a player gets a 50% bonus every time he earns pointshop 2 points",
			value = 50
		}
	}
}

PointsBooster.ShouldDrainTime = Pointshop2.BoostDrainWhenAlive

Pointshop2.AddBoosterType( PointsBooster )

if SERVER then
	hook.Add( "PS2_PointsAwarded", "BoostPts", function( ply, points, currency )
		if currency == "premiumPoints" then return end
		local booster = ply:PS2_GetItemInSlot( "Booster" )
		if not booster then 
			return 
		end
		
		if booster.boostType == "Points" then
			local extraPoints = math.floor( points * ( booster.boostParams["BasicSettings.Increment"] / 100 ) )
			ply:PS2_AddStandardPoints( extraPoints, "Booster Bonus", true, true )
		end
	end )
 end