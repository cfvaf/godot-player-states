extends KinematicBody2D

#variables
var motion = Vector2()
var direction = 1

#constants
const TYPE := "Enemy"
const SPEED := 50
const GRAVITY := 600
const JUMP_POWER := 100
const DAMAGE := 1

#exported variable
export (PackedScene) var enemyDeath
export (PackedScene) var damageNumber

#onready variables
onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var HealthManager = $HealthManager

func _physics_process(delta):
	$StateMachine.stateMachine(delta)
	motion = move_and_slide(motion, Vector2(0, -1))

func ShowDamage(dmg : int):
	var number = damageNumber.instance()
	number.setNumber(dmg)
	number.set_global_position(get_global_position())
	owner.get_parent().add_child(number)

func VerifyDirection(target):
	if target != null:
		var value = get_global_position().x - target.get_global_position().x
		if value > 0:
			setDirection(-1)
		else: 
			setDirection(1)

func setDirection(newDirection : int):
	if (direction != newDirection):
		direction = newDirection
		var scale = Vector2(-1,1)
		apply_scale(scale)

func Die():
	var explosion = enemyDeath.instance()
	explosion.set_global_position(get_global_position())
	owner.get_parent().add_child(explosion)
	queue_free()

#
# signal functions
#

func _on_HealthManager_healthChanged(health, maxHealth, damage, heal):
	if damage != null:
		ShowDamage(damage)
		$StateMachine.receiveDamage(10)
		
		if health == 0:
			Die()
