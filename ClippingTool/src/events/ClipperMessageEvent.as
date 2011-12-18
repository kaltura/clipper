package events
{
	import flash.events.Event;
	
	import model.MessageVO;
	
	public class ClipperMessageEvent extends Event
	{
		public static const DISPLAY_MESSAGE:String = "displayMessage";
		
		public var messageVo:MessageVO;
		
		public function ClipperMessageEvent(type:String, message:String, code:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			messageVo = new MessageVO();
			messageVo.messageText = message;
			messageVo.messageCode = code;
			super(type, bubbles, cancelable);
		}
	}
}