extends Node
@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene : PackedScene
@export var playtime = 30
@export var enemy_scene : PackedScene
@export var debuff_scene : PackedScene
var visability = true
var game_over1 = false
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
func new_game():
	$Controls.hide()
	visability = false
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	$EnemyTimer.start()
	spawn_coins()
	Input.action_release("Continue")
	$Controls.can_start_game = false
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	get_tree().call_group("enemies", "queue_free")
	
	
	
func spawn_cactus():
	for i in level - 2:
		var c = cactus_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func spawn_tumbleweed():
	if not game_over1:
		for i in level - 2:
			var t = enemy_scene.instantiate()
			add_child(t)
			t.screensize = screensize
			t.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		
func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func _process(delta):
	if Input.is_action_pressed("Continue") and not playing:
		get_tree().call_group("coins", "queue_free")
		new_game()
		$Controls.hide()
		$HUD/Message.hide()
	if playing:
		$Controls.can_start_game = false
		if get_tree().get_nodes_in_group("coins").size() == 0:
			level += 1
			time_left += 5
			spawn_coins()
			_on_powerup_timer_timeout()
			get_tree().call_group("debuff", "queue_free")
			_on_debuff_timer_timeout()
			get_tree().call_group("obstacles", "queue_free")
			get_tree().call_group("enemies", "queue_free")
			spawn_cactus()
			spawn_tumbleweed()
			$EnemyTimer.start(randf_range(5, 10))
		
func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
		"debuff":
			$DebuffSound.play()
			time_left -= 3
			$HUD.update_timer(time_left)
	
func game_over():
	playing = false
	$GameTimer.stop()
	$EnemyTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()
	$Controls.can_start_game = true
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("debuff", "queue_free")
	game_over1 = true


func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func _on_hud_start_game():
	$Controls.show()
	
func _on_enemy_timer_timeout():
	if not playing:
		return
	var e = enemy_scene.instantiate()
	add_child(e)
	e.target = $Player
	$EnemyTimer.start(randf_range(5, 10))

func _on_debuff_timer_timeout():
	var d = debuff_scene.instantiate()
	add_child(d)
	d.screensize = screensize
	d.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
