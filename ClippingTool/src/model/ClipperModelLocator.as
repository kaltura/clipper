package model
{
	import com.kaltura.KalturaClient;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaPlayableEntry;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	/**
	 * Singleton class, will hold all data 
	 * @author Michal
	 * 
	 */	
	public class ClipperModelLocator extends EventDispatcher
	{
		/**
		 * defines the value of the type property of the loadingFlagChanged event 
		 */		
		public static const LOADING_FLAG_CHANGED:String = "loadingFlagChanged";
		//////////////////////////////////
		// Singleton implementations
		//////////////////////////////////
		
		private static var _instance:ClipperModelLocator;
		
		public function ClipperModelLocator(enforcer:Enforcer) {
			
		}
		
		public static function getInstance():ClipperModelLocator {
			if (_instance == null) {
				_instance = new ClipperModelLocator(new Enforcer());
				
			}
			return _instance;
		}
	
			
		/**
		 * the kaltura client 
		 */		
		public var kc:KalturaClient;
		
		/**
		 * the entry that is currently being edited 
		 */		
		public var currentEntry:KalturaBaseEntry;

		private var _loadingCounter:int = 0;
		
		[Bindable(event="loadingFlagChanged")]
		/**
		 * indicates if we are waiting for data from the server
		 * */
		public function get loadingFlag():Boolean {
			return (_loadingCounter!=0);
		}
		
		
		public function set loadingFlag(value:Boolean):void {
			//to enable binding
		}

		public function increaseLoadingCounter():void {
			_loadingCounter++;
			dispatchEvent(new Event(LOADING_FLAG_CHANGED));
		}
		
		public function decreaseLoadingCounter():void {
			_loadingCounter--;
			dispatchEvent(new Event(LOADING_FLAG_CHANGED));
		}
		///////////////////////////////////
		//configurations
		///////////////////////////////////
		/**
		 * uiconf xml
		 * */
		public var uiconfXML:XML;	
		public var maxAllowedRows:int;
		public var showControlBar:Boolean = true;
		public var showAddDeleteButtons:Boolean = true;
		public var showMsgBox:Boolean = true;
		/**
		 * array of zoomBoxValue objects
		 * */
		public var zoomBoxValues:Array;
		
		/**
		 * flag indicates if uiconf xml was successfully loaded
		 * */
		public var uiconfLoaded:Boolean;
	
		/**
		 * message to display 
		 */		
		public var message:MessageVO;
		/**
		 * ArrayCollection of assets related to current entry and current state (cue points/clips)
		 * */
		public var itemsAC:ArrayCollection = new ArrayCollection();
		
		public var saveComplete:Boolean = false;
		public var saveFailed:Boolean = false;

	}
}

class Enforcer {
	
}