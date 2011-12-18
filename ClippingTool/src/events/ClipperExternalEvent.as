package events
{
	import flash.events.Event;
	
	/**
	 * The ClipperExternalEvent represents events that will be available from outside the widget (JS and Flash) 
	 * @author Michal
	 * 
	 */	
	public class ClipperExternalEvent extends Event
	{
	
		public var data:Object;
		
		public function ClipperExternalEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}