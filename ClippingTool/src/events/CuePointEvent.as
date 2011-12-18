package events
{
	import flash.events.Event;
	
	public class CuePointEvent extends Event
	{
		public static const LIST_CUE_POINTS:String = "listCuePoint";
		
		public var entryId:String;
		public var cuePointType:String;
		
		public function CuePointEvent(type:String, entry_id:String, cue_point_type:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			entryId = entry_id;
			cuePointType = cue_point_type;
			super(type, bubbles, cancelable);
		}
	}
}