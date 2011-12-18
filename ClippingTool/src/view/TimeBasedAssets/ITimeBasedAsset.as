package view.TimeBasedAssets
{
	/**
	 * An asset that can be displayed on the timeline 
	 * @author Michal
	 * 
	 */	
	public interface ITimeBasedAsset
	{		
		/**
		 * start time of the asset, in milliseconds
		 * */
		 function get timeInMS():Number;
		
		 function set timeInMS(value:Number):void;
		 
		 /**
		 * start x position
		 * */
		 function get startX():Number;
		 
		 function set startX(value:Number):void;
		
		 /**
		 * width of the asset in pixels
		 * */
		 function get assetWidth():Number;
		 
		 function set assetWidth(value:Number):void;
		 
		 /**
		 * whether the asset is selected
		 * */
		 function get selectionState():Boolean;
		 
		 function set selectionState(value:Boolean):void;
		 
		 /**
		 * The id of the VO asset related to this visual asset
		 * */
		 function get assetVo():Object;
		 
		 function set assetVo(value:Object):void;
		 
		 /**
		  * Set the error state of the asset 
		  * @param value
		  * 
		  */		 
		 function setErrorState(value:Boolean):void;
		
	}
}