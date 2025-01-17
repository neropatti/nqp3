class_name BaseAction extends Node
## base class for a combat action for actors


########### CONFIG #############

@export_group("config")
@export var friendly_name: String
@export var tags: Array[Constants.ActionTag] = []
@export var valid_target_types: Array[Constants.TargetType] = []
@export var _base_cooldown: float
@export var _base_damage: int

@export_group("", "")  # end grouping

######### ATTRIBUTES ##########

var _cooldown_timer: Timer
var _creator: Actor
var _target: Actor
## length of cooldown of action
var cooldown: float:
	get:
		# TODO: mod by creator stats
		return _base_cooldown
	set(value):
		push_warning("Tried to set cooldown directly. Not allowed.")
## check if action is ready to use
var is_ready: bool = true:
	get:
		return _cooldown_timer.is_stopped()
	set(value):
		push_warning("Tried to set is_ready directly. Not allowed.")
## amount of time left on cooldown
var cooldown_remaining: float:
	get:
		return _cooldown_timer.time_left
	set(value):
		push_warning("Tried to set cooldown_remaining directly. Not allowed.")

var is_targeting_self := false
var is_targeting_all := false

######### UI ##############

var icon: Texture

########### SETUP  ###########

func _init(creator: Actor) -> void:
	_creator = creator

	_cooldown_timer = Timer.new()
	_cooldown_timer.set_one_shot(true)

	_configure()
	_setup()

## configure the action's base data
func _configure() -> void:
	assert(false, "Virtual method not overriden.")
	pass

## last step of setup, post config
func _setup() -> void:
	set_cooldown(cooldown)

########### FUNCTIONALITY ###########

## use action on a target
## must call super in subclass
func use(initial_target: Actor) -> void:
	_target = initial_target

func set_cooldown(cooldown_time: float) -> void:
	# ignore if wait time == 0
	if cooldown > 0:
		_cooldown_timer.wait_time = cooldown_time
		_cooldown_timer.start()


func reset_cooldown() -> void:
	set_cooldown(cooldown)

########### ATTIBUTE GETTERS ###############

## @tag: virtual method
func get_description() -> String:
	assert(false, "Virtual method not overriden.")
	return "No description set"

########## EFFECTS ##############

## get new target
func _effect_new_target(preference: Constants.TargetPreference = Constants.TargetPreference.ANY) -> void:
	pass

## apply amount of damage to current target
func _effect_damage(amount: int, damage_type: Constants.DamageType) -> void:
	Combat.deal_damage(_creator, _target, amount, damage_type)

## apply a status effect to current target
func _effect_status(status_effect: BaseStatusEffect) -> void:
	pass

## create a projectile. returns created projectile
func _effect_projectile() -> NonCollidingProjectile:
	return Factory.create_projectile(_creator, _target)

## create a summon
func _effect_summon(summon) -> void:
	pass

## create terrain
func _effect_terrain(terrain) -> void:
	pass

## visual, such as animation
func _effect_visual(visual) -> void:
	pass
