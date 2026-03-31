class_name EnemySpawner
extends Marker2D

var uid : String
var defeated : bool:
	set(value):
		defeated = value
		Data.enemy_data[uid]['defeated'] = value

@export var type : Data.Enemy

func _enter_tree() -> void:
	uid = get_uid()
	if uid not in Data.enemy_data:
		Data.enemy_data[uid] = {'defeated': defeated}
	else:
		defeated = Data.enemy_data[uid]['defeated']
	
func get_uid() -> String:
	var scene_name = get_owner().scene_file_path.get_file().get_basename()
	return str(scene_name) + "_" + str(name)
