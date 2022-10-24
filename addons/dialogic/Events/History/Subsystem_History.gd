extends DialogicSubsystem

var enabled:bool = true

var full_history_enabled:bool = true
var full_history_length:int = 50

var text_read_history_enabled:bool = true

var full_history:Array = []

var text_read_history:Dictionary = {}

signal history_text_already_read()

####################################################################################################
##					STATE
####################################################################################################

func clear_game_state() -> void:
	pass

func load_game_state() -> void:
	pass

####################################################################################################
##					MAIN METHODS
####################################################################################################

func add_event_to_history(current_timeline:String, current_index:int, current_event:DialogicEvent) -> void:
	if full_history_enabled:
		var event_dict:Dictionary = {}
		event_dict['timeline'] = current_timeline
		event_dict['index'] = current_index
		event_dict['event_object'] = current_event
		event_dict['event_type'] = current_event.event_name
		
		#A few more specific types of checks need to happen here to capture previous values
		
		full_history.push_front(event_dict)
		if full_history.size() > full_history_length:
			var dropped = full_history.pop_back()
		
	if text_read_history_enabled:
		if current_event.event_name == "Text" || current_event.event_name == "Choice":
			var line = str(current_index)+ "**" + current_timeline
			if line in text_read_history:
				emit_signal("history_text_already_read")
			else:	
				text_read_history[line] = true
				

func strip_events_from_full_history() -> void:
	for i in full_history.size():
		full_history[i].erase('event_object')
		
func rebuild_all_history_events() -> void:
	var temp_timelines:Dictionary = {} 
	for i in full_history.size():
		if full_history[i]['timeline'] in temp_timelines:
			full_history[i]['event_object'] = temp_timelines[full_history[i]['timeline']].events[full_history[i]['index']]
		else:
			var loaded_timeline = Dialogic.preload_timeline(full_history[i]['timeline'])
			temp_timelines[full_history[i]['timeline']] = loaded_timeline
			full_history[i]['event_object'] = loaded_timeline.events[full_history[i]['index']]
			

	
