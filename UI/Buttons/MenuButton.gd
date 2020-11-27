extends Button

export(String) var scene_to_load


#func _on_Continue_pressed():
#    # TODO: Load game based off of example from Godot docs:
#    #   https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
#    var save_game = File.new()
#    if not save_game.file_exists("user://savegame.save"):
#        # Print an error message for now. Ideally, you'll want the button
#        # to be greyed out
#        print("No savegame.save file found. Game will not be loaded.")
#        return
#
#    # IMPORTANT!! We need to revert the game state so we're not cloning objects
#    # during loading. This will vary wildly depending on the needs of a
#    # project, so take care with this step.
#    # For our example, we will accomplish this by deleting saveable objects.
#    var save_nodes = get_tree().get_nodes_in_group("Persist")
#    for i in save_nodes:
#        i.queue_free()
#
#    # Load the file line by line and process that dictionary to restore
#    # the object it represents.
#    save_game.open("user://savegame.save", File.READ)
#    while save_game.get_position() < save_game.get_len():
#        var node_data = parse_json(save_game.get_line())
#
#        # Firstly, we need to create the object and add it to the tree and set 
#        # its position.
#        var new_object = load(node_data["filename"]).instance()
#        var is_inside_tree = is_inside_tree()
#
#        print(get_node(node_data["parent"]))
#        get_node(node_data["parent"]).add_child(new_object)
#        new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
#        # Now we set the remaining variables.
#        for i in node_data.keys():
#            if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#                continue
#            new_object.set(i, node_data[i])
#
#    save_game.close()
#
#    # Load the game
#    get_tree().change_scene("res://TitleScreen.tscn")
#
## Load game based off of example from Godot docs:
##   https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
#func _on_MenuButton_pressed():
#    # TODO: Figure out how to properly reuse this button
#    var save_game = File.new()
#    if not save_game.file_exists("user://savegame.save"):
#        # Print an error message for now. Ideally, you'll want the button
#        # to be greyed out
#        print("No savegame.save file found. Game will not be loaded.")
#        return
#
#    # IMPORTANT!! We need to revert the game state so we're not cloning objects
#    # during loading. This will vary wildly depending on the needs of a
#    # project, so take care with this step.
#    # For our example, we will accomplish this by deleting saveable objects.
#    var save_nodes = get_tree().get_nodes_in_group("Persist")
#    for i in save_nodes:
#        i.queue_free()
#
#    # Load the file line by line and process that dictionary to restore
#    # the object it represents.
#    save_game.open("user://savegame.save", File.READ)
#    while save_game.get_position() < save_game.get_len():
#        var node_data = parse_json(save_game.get_line())
#
#        # Firstly, we need to create the object and add it to the tree and set 
#        # its position.
#        var new_object = load(node_data["filename"]).instance()
#        var is_inside_tree = is_inside_tree()
#
#        print(get_node(node_data["parent"]))
#        get_node(node_data["parent"]).add_child(new_object)
#        new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
#        # Now we set the remaining variables.
#        for i in node_data.keys():
#            if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#                continue
#            new_object.set(i, node_data[i])
#
#    save_game.close()
#
#    # Load the game
#    get_tree().change_scene("res://TitleScreen.tscn")
