extends BaseTroop

func _init():
	self.troopType = "Wizard"
	$AttackSpeed.wait_time = self.attackSpeedWaitTime
	self.food = 250
	self.mana = 10
