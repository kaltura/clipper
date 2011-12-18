package com.kaltura.applications.kClipInterface
{
	public interface IClippingAPI extends IClipperAPI
	{
		/**
		 * Add a new clip 
		 * @param clipLengthInMS the length of the clip in milliseconds
		 * 
		 */		
		function addClip(clipLengthInMS:Number):void;

	
		/**
		 * Add a new clip at the given time stamp
		 * @param startTimeInMS the start time of the clip, in milliseconds
		 * @param clipLengthInMS the length of the clip, in milliseconds
		 * 
		 */		
		function addClipAt(startTimeInMS:Number, clipLengthInMS:Number):void ;
		
		/**
		 * Update the selcted clip with the given attributes object
		 * @param attributes should contain "duration" and "offset"
		 * 
		 */		
		 function updateClipAttributes(attributes:Object):void ;
		
	}
}