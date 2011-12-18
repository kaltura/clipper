package events
{
	import flash.events.Event;
	
	public class JSEvent extends Event
	{
		public static const CALL_JS:String = "callJS";
		
		public var funcName:String;
		public var args:Object;
		
		public function JSEvent(type:String, func_name:String, args:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.funcName = func_name;
			this.args = args;
			super(type, bubbles, cancelable);
		}
	}
}