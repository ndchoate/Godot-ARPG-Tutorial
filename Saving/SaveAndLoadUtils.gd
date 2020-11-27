extends Node2D


# Based mostly off of Godot's docs on saving games:
#   https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
func save_game():
    print(OS.get_user_data_dir())
    
    var save_file = File.new()
    save_file.open("user://savegame.save", File.WRITE)
    var save_nodes = get_tree().get_nodes_in_group("Persist")
    for node in save_nodes:    
        # Check the node is an instanced scene so it can be instanced again during load.
        if node.filename.empty():
            print("Persistent node '%s' is not an instanced scene, skipped" % node.name)
            continue
        
        # Check the node has a save function.
        if !node.has_method("save"):
            print("persistent node '%s' is missing a save() function, skipped" % node.name)
            continue

        # Why can't you just do node.save() here?
        var node_data = node.call("save")
        print(node_data)
        
        # Store the node's data as a new line in the save game file
        save_file.store_line(to_json(node_data))
        
    save_file.close()


# Load game based off of example from Godot docs:
#   https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
func load_game():
    # TODO: Figure out how to properly reuse this button
    var save_game = File.new()
    if not save_game.file_exists("user://savegame.save"):
        # Print an error message for now. Ideally, you'll want the button
        # to be greyed out
        print("No savegame.save file found. Game will not be loaded.")
        return
    
    # IMPORTANT!! We need to revert the game state so we're not cloning objects
    # during loading. This will vary wildly depending on the needs of a
    # project, so take care with this step.
    # For our example, we will accomplish this by deleting saveable objects.
    var save_nodes = get_tree().get_nodes_in_group("Persist")
    for i in save_nodes:
        i.queue_free()

    # Load the file line by line and process that dictionary to restore
    # the object it represents.
    save_game.open("user://savegame.save", File.READ)
    while save_game.get_position() < save_game.get_len():
        print("In while loop of load_game")
        
        var node_data = parse_json(save_game.get_line())
        
        # Firstly, we need to create the object and add it to the tree and set 
        # its position.
        var new_object = load(node_data["filename"]).instance()
        var is_inside_tree = is_inside_tree()
        
        print(get_node(node_data["parent"]))
        get_node(node_data["parent"]).add_child(new_object)
        new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
        
        # Now we set the remaining variables.
        for i in node_data.keys():
            if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
                continue
            new_object.set(i, node_data[i])

    save_game.close()
    
    # Load the game
    # get_tree().change_scene("res://TitleScreen.tscn")
