package model.clipperAPI
{
	import flash.external.ExternalInterface;

	/**
	 * This class will call registered external interface functions 
	 * when suitable event is sent 
	 * @author Michal
	 * 
	 */	
	public class ExternalInterfaceProxy
	{
		private var _extInterfaceEvents:Object = new Object();
		
		public function ExternalInterfaceProxy()
		{
		}
		
		/**
		 * Will add an external listener to the event 
		 * @param listenerString the event name string
		 * @param extFuncName the external function name
		 * 
		 */		
		public function addListener(listenerString:String, extFuncName:String):void
		{
			var funcs:Array = _extInterfaceEvents[listenerString];
			if (funcs)
			{
				if (funcs.indexOf(extFuncName) != -1)
					return; // listener already registered				
			}
			else
				_extInterfaceEvents[listenerString] = funcs = new Array();
			
			funcs.push(extFuncName);	
		}
		
		/**
		 * Remove given listener from the event 
		 * @param listenerString the event name string
		 * @param extFuncName the external function name
		 * 
		 */		
		public function removeListener(listenerString:String, extFuncName:String):void
		{
			var funcs:Array = _extInterfaceEvents[listenerString];
			if (!funcs)
				return;
			
			var i:int = funcs.indexOf(extFuncName);
			if (i != -1)
				funcs.splice(i, 1);			
		}
		
		/**
		 * Calls all registered external interface functions 
		 * @param notificationName 
		 * @param body
		 * 
		 */		
		public function notifyExtInterface(notificationName:String, body:Object):void
		{
			var funcs:Array = _extInterfaceEvents[notificationName];
			if (ExternalInterface.available) {
				for each(var extFunctionName:String in funcs){
					if (body!=null)
						ExternalInterface.call(extFunctionName, body, ExternalInterface.objectID);
					else
						ExternalInterface.call(extFunctionName, ExternalInterface.objectID);
				}
				
			}
		}
		
	}
}