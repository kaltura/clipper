package commands
{
	import events.JSEvent;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;

	public class JSCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			if (ExternalInterface.available) {
				if ((event as JSEvent).args)
					ExternalInterface.call((event as JSEvent).funcName, (event as JSEvent).args, ExternalInterface.objectID);
				else
					ExternalInterface.call((event as JSEvent).funcName, ExternalInterface.objectID);
			}
		}
	}
}