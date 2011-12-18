package events
{
	import flash.events.Event;
	
	public class BaseEntryEvent extends Event
	{
		public static const GET:String = "get";
		
		public var entryId:String;
		
		public function BaseEntryEvent(type:String, entry_id:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			entryId = entry_id;
			super(type, bubbles, cancelable);
		}
	}
}