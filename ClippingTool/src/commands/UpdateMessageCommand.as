package commands
{
	import events.ClipperMessageEvent;
	
	import flash.events.Event;

	public class UpdateMessageCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			_model.message = (event as ClipperMessageEvent).messageVo;
		}
	}
}