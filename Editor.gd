extends Control

@onready var tilemap = $TileMap
var current_tile_id = 0

func _ready():
    # タイル選択ボタンにシグナルを接続
    for button in $Panel/VBoxContainer/GridContainer.get_children():
        button.connect("pressed", Callable(self, "_on_tile_selected").bind(button))

func _on_tile_selected(button):
    current_tile_id = int(button.get_meta("tile_id"))

func _unhandled_input(event):
    if event is InputEventMouseButton and event.pressed:
        var mouse_pos = tilemap.get_local_mouse_position()
        var cell = tilemap.local_to_map(mouse_pos)
        if event.button_index == MOUSE_BUTTON_LEFT:
            tilemap.set_cell(0, cell, current_tile_id)
        elif event.button_index == MOUSE_BUTTON_RIGHT:
            tilemap.set_cell(0, cell, -1) # -1で削除

func _on_save_pressed():
    var data = {
        "width": 30,
        "height": 19,
        "tiles": []
    }
    for y in range(19):
        var row = []
        for x in range(30):
            row.append(tilemap.get_cell_source_id(0, Vector2i(x, y)))
        data["tiles"].append(row)
    var file = FileAccess.open("res://stages/stage1.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(data))
    file.close()

func _on_load_pressed():
    var file = FileAccess.open("res://stages/stage1.json", FileAccess.READ)
    var data = JSON.parse_string(file.get_as_text())
    file.close()
    for y in range(data["height"]):
        for x in range(data["width"]):
            var id = data["tiles"][y][x]
            tilemap.set_cell(0, Vector2i(x, y), id)



func _on_load_button_pressed() -> void:
    print("Loadボタンが押された！")


func _on_save_button_pressed() -> void:
    print("保存ボタンが押された！")