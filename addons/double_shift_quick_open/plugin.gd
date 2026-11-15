@tool
extends EditorPlugin

## Maximum time between the two Shift taps, in milliseconds.
const DOUBLE_TAP_WINDOW_MS := 300

var _last_shift_release_ms := -DOUBLE_TAP_WINDOW_MS
var _shift_down_clean := false


func _input(event: InputEvent) -> void:
    if not event is InputEventKey:
        return
    var key := event as InputEventKey
    if key.echo:
        return

    if key.keycode != KEY_SHIFT:
        # Any other key (e.g. Shift+A while typing) breaks the sequence.
        _shift_down_clean = false
        _last_shift_release_ms = -DOUBLE_TAP_WINDOW_MS
        return

    if key.pressed:
        _shift_down_clean = true
        return

    # Shift released without another key in between: counts as a tap.
    if not _shift_down_clean:
        return
    _shift_down_clean = false

    var now := Time.get_ticks_msec()
    if now - _last_shift_release_ms <= DOUBLE_TAP_WINDOW_MS:
        _last_shift_release_ms = -DOUBLE_TAP_WINDOW_MS
        _open_quick_open()
    else:
        _last_shift_release_ms = now


func _open_quick_open() -> void:
    EditorInterface.popup_quick_open(_on_file_chosen, [&"Resource"])


func _on_file_chosen(path: String) -> void:
    if path.is_empty():
        return
    # The dialog may hand back a uid:// reference rather than a res:// path.
    if path.begins_with("uid://"):
        var id := ResourceUID.text_to_id(path)
        if ResourceUID.has_id(id):
            path = ResourceUID.get_id_path(id)

    if path.get_extension() in ["tscn", "scn"]:
        EditorInterface.open_scene_from_path(path)
        return

    var res := load(path)
    if res == null:
        push_warning("Double Shift Quick Open: could not load '%s'" % path)
        return
    if res is Script:
        EditorInterface.set_main_screen_editor("Script")
        EditorInterface.edit_script(res)
    else:
        EditorInterface.edit_resource(res)
