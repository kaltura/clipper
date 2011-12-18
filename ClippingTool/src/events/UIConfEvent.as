package events
{
	import flash.events.Event;
	
	public class UIConfEvent extends Event
	{
		public static const GET_UICONF:String = "getUiconf";
		
		public var uiconfId:String;
		
		public function UIConfEvent(type:String, uiconf_id:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			uiconfId = uiconf_id;
			super(type, bubbles, cancelable);
		}
	}
}