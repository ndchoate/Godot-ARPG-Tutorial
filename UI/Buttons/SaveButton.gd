extends Button


#func _on_SaveButton_pressed():
#    save()


# Based mostly off of Godot's docs on saving games:
#   https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
#func save():
#    print(OS.get_user_data_dir())
#
#    var save_file = File.new()
#    save_file.open("user://savegame.save", File.WRITE)
#    var save_nodes = get_tree().get_nodes_in_group("Persist")
#    for node in save_nodes:    
#        # Check the node is an instanced scene so it can be instanced again during load.
#        if node.filename.empty():
#            print("Persistent node '%s' is not an instanced scene, skipped" % node.name)
#            continue
#
#        # Check the node has a save function.
#        if !node.has_method("save"):
#            print("persistent node '%s' is missing a save() function, skipped" % node.name)
#            continue
#
#        # Why can't you just do node.save() here?
#        var node_data = node.call("save")
#        print(node_data)
#
#        # Store the node's data as a new line in the save game file
#        save_file.store_line(to_json(node_data))
#
#    save_file.close()
