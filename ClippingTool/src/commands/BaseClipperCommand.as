package commands
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import model.ClipperModelLocator;

	/**
	 * Base clipper command, holds an instance of ClipperModelLocator 
	 * @author Michal
	 * 
	 */	
	public class BaseClipperCommand extends EventDispatcher
	{
		protected var _model:ClipperModelLocator = ClipperModelLocator.getInstance();
		
		public function execute(event:Event):void {
			
		}
	}
}