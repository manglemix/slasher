  
extends Node


func _enter_tree():
    GlobalStuff.enemies.append(get_parent())


func _exit_tree():
    GlobalStuff.enemies.erase(get_parent())
