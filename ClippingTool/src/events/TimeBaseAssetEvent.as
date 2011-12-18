package events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import view.TimeBasedAssets.ITimeBasedAsset;
	
	public class TimeBaseAssetEvent extends Event
	{
		public static const ASSET_CLICK:String = "assetClick";
		public static const ASSET_DRAG:String = "assetDrag";
		public static const ASSET_START_CHANGED:String = "assetStartChanged";
		public static const ASSET_END_CHANGED:String = "assetEndChanged";
		public static const ASSET_SELECTED:String = "assetSelected";
		
		public var timeBasedAsset:ITimeBasedAsset;
		/**
		 * Indicates whether an update of the asset.timeInMS is neccessary 
		 */		
		public var updateTime:Boolean;
		
		public function TimeBaseAssetEvent(type:String, time_based_asset:ITimeBasedAsset = null, update_time:Boolean = true, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			timeBasedAsset = time_based_asset;
			updateTime = update_time;
			super(type, bubbles, cancelable);
		}
	}
}