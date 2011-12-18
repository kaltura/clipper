package events
{
	import flash.events.Event;
	
	public class ExternalInterfaceEvent extends Event
	{
		public static const ADD_LISTENER:String = "addListener";
		public static const REMOVE_LISTENER:String = "removeListener";
		
		/**
		 * the clipper event name, that relates to this event
		 * */
		public var listenerString:String;
		/**
		 * the function that relates to the clipper event
		 * */
		public var extFuncName:String;
		
		public function ExternalInterfaceEvent(type:String, listener_string:String, ext_func_name:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			listenerString = listener_string;
			extFuncName = ext_func_name;
			
			super(type, bubbles, cancelable);
		}
	}
}