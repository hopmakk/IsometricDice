extends Camera2D
class_name Camera

@export var SmothSpeed: float = 10

var _targetPosition: Vector2 = Vector2.ZERO
var _middleButtonClickPos: Vector2 = Vector2.ZERO
const KEYS_MOVEMENT_SPEED : float = 5

var _currentZoom: float = 3
const ZOOM_SPEED: float = 0.2
const MAX_ZOOM: float = 7
const MIN_ZOOM: float = 3.0



func _ready():
	SetCurrentZoom()
	pass



func _physics_process(delta):
	var currentPosition = position
	
	# передвижение мышью (через сдвиг объектива)
	if Input.is_action_just_pressed("grab_camera"):
		_middleButtonClickPos = get_global_mouse_position()
	if Input.is_action_pressed("grab_camera"):
		offset += _middleButtonClickPos - get_global_mouse_position()
	
	# передвижение клавишами (через перемещения объекта камеры в дальнейшем)
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	if directionX:
		_targetPosition.x += directionX * KEYS_MOVEMENT_SPEED
	if directionY:
		_targetPosition.y += directionY * KEYS_MOVEMENT_SPEED
		
	# плавно двигаемся в заданную точку
	if _targetPosition - currentPosition != Vector2.ZERO:
		var newPosition = currentPosition.lerp(_targetPosition, SmothSpeed * delta)
		position = newPosition
	pass



func _unhandled_input(event):
	if !(event is InputEventMouseButton):
		return
	
	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		if _currentZoom < MAX_ZOOM:
			_currentZoom += ZOOM_SPEED
			SetCurrentZoom()
			
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if _currentZoom > MIN_ZOOM:
			_currentZoom -= ZOOM_SPEED
			SetCurrentZoom()
	pass



func SetCurrentZoom():
	zoom = Vector2(_currentZoom, _currentZoom)
	pass
