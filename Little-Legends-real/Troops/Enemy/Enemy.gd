extends BaseTroop

func _init():
	self.troopType = "Soldier"
	self.team = 2
	$AttackSpeed.wait_time = self.attackSpeedWaitTime
