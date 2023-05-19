extends BaseTroop


func _init():
	self.troopType = "Archer"
	$AttackSpeed.wait_time = self.attackSpeedWaitTime
	self.food = 100
