package model.clipperTimeline
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.geom.Point;
	
	import flexlib.controls.HSlider;
	
	import model.clipperTimeline.extensions.ClipperSliderThumb;
	
	import mx.controls.ToolTip;
	import mx.controls.sliderClasses.Slider;
	import mx.controls.sliderClasses.SliderDataTip;
	import mx.controls.sliderClasses.SliderDirection;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.SliderEvent;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	
	use namespace mx_internal;
	/**
	 *  The length in pixels of the  first tick mark in tickGroup
	 */
	[Style(name="bigTickLength", type="Number", format="Length", inherit="no")]
	/**
	 *  The length in pixels of the tick marks inside tickGroup
	 */
	[Style(name="smallTickLength", type="Number", format="Length", inherit="no")]
	/**
	 *  The color of the tick marks inside tickGroup
	 */
	[Style(name="smallTickColor", type="Number", format="Length", inherit="no")]
	/**
	 *  The color of the  first tick mark in tickGroup
	 */
	[Style(name="bigTickColor", type="Number", format="Length", inherit="no")]
	/**
	 *  The length in pixels of the label
	 */
	[Style(name="minLabelLength", type="Number", format="Length", inherit="no")]
	/**
	 *  The width of the thumb
	 */
	[Style(name="thumbWidth", type="Number", format="Length", inherit="no")]
	
	public class ClipperSlider extends HSlider
	{
		public static const LAYOUT_TICKS_COMPLETED:String = "layoutTicksComplete";
		
		private var _tickGroupCount:int = 5;
		private var _labelsHeight:int = 15;

		/**
		 * last label will appear on the first tick of the last tick group
		 * */
		private var _lastLabelX:int;
		
		private var ticks:UIComponent;
		/**
		 * Scroll position of the container of this slider.
		 * Will be used for displaying the tooltip 
		 */		
		public var scrollPos:Number;
		private var dataTips:Array;
		private var _rollOver:Boolean;
		private var _pressed:Boolean;
		
		public function ClipperSlider()
		{
			super();
			dataTips = new Array;
		}
			
		public function getTrackY():Number {
			return track.y;
		}

		public function getTrackX():Number {
			return track.x;
		}
		
		public function getTrackWidth():Number {
			return track.width;
		}
		
		/**
		 * number of ticks per group, the first tick in the group will get bigTickLength, and the others - smallTickLength
		 * */
		public function get tickGroupCount():int
		{
			return _tickGroupCount;
		}
		
		/**
		 * @private
		 */
		public function set tickGroupCount(value:int):void
		{
			_tickGroupCount = value;
		}
		
		override protected function createChildren():void {
			scrollPos = 0;
			super.createChildren();
			
			super.addEventListener(SliderEvent.THUMB_PRESS, setDataTip);
			super.addEventListener(SliderEvent.THUMB_DRAG, setDataTip);
			
			sliderThumbClass = ClipperSliderThumb;
			
			getTrackHitArea().visible = false;
			ticks = new UIComponent();
			this.mx_internal::innerSlider.addChild(ticks);
		}
		
		
		override public function get value():Number {
			//TODO check how this affects performance
			return Math.round(super.value);
		}
		
		private function setDataTip(event:SliderEvent):void {
			if (showDataTip) {		
				var point:Point = localToGlobal(new Point(this.x,this.y));
				for (var i:int = 0; i<systemManager.toolTipChildren.numChildren; i++ ) {
					var child:DisplayObject = systemManager.toolTipChildren.getChildAt(i);
					if (child is SliderDataTip) {				
						child.x = child.x - point.x - scrollPos;
						child.y -= point.y;
					}
				}
			}
		}
		
		

		
		override protected function commitProperties():void {
			super.commitProperties();

			getThumbAt(0).height = this.height;
			getThumbAt(0).width = getStyle("thumbWidth");
			getThumbAt(0).buttonMode = true;
			getThumbAt(0).useHandCursor = true;
			track.visible = false;
		}

		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{	
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			track.y = this.y - getStyle("labelOffset")+_labelsHeight;
			layoutTicks();
			layoutLabels();
			
		}
		
		/**
		 * draws the ticks. Was taken from original Slider class, with a few adjusmetns
		 * */
		private function layoutTicks():void
		{
			if (ticks)
			{
				var g:Graphics = ticks.graphics;
				var smallTickLength:Number = getStyle("smallTickLength");
				var bigTickLength:Number = getStyle("bigTickLength");
				var tOffset:Number = getStyle("tickOffset");
				var tickWidth:Number = getStyle("tickThickness");
				var xPos:Number;
				//var tColor:Number = getStyle("tickColor");
				var smallTickColor:Number = getStyle("smallTickColor");
				var bigTickColor:Number = getStyle("bigTickColor");
				
				var usePositions:Boolean = tickValues && tickValues.length > 0 ? true : false;
				var positionIndex:int = 0;
				var val:Number = usePositions ? tickValues[positionIndex++] : minimum;
				
				g.clear();
				
				if (tickInterval > 0 || usePositions)
				{
					g.lineStyle(tickWidth,tColor,100);
					
					var tickCounter:int = 0;
					
					do
					{
						xPos = Math.round(this.mx_internal::getXFromValue(val));
						var tLength:int = smallTickLength;
						var tColor:String = smallTickColor;
						if (tickCounter%tickGroupCount ==0) {
							tLength = bigTickLength;
							tColor = bigTickColor;
							_lastLabelX = xPos;
						}
						g.lineStyle(tickWidth,tColor,100);
						
						//var tLength:int = (tickCounter%tickGroupCount == 0) ? bigTickLength : smallTickLength;
						g.moveTo(xPos, bigTickLength);
						g.lineTo(xPos, bigTickLength - tLength);
						val = usePositions ? (positionIndex < tickValues.length ? tickValues[positionIndex++] : NaN) : tickInterval + val;
						tickCounter++;
					} while (val < maximum || (usePositions && positionIndex < tickValues.length))
					
					_lastLabelX = (tickCounter < tickGroupCount) ? xPos : _lastLabelX;
					// draw the last tick
					if (!usePositions || val == maximum)
					{
						xPos = track.x + track.width - 1;
						g.moveTo(xPos, tLength);
						g.lineTo(xPos, 0);
					}
					
					ticks.y = Math.round(track.y + tOffset - tLength);
					
					dispatchEvent(new Event(LAYOUT_TICKS_COMPLETED));
				}
			}
		}
		
		/**
		 * creates the labels. was taken from original Slider, with adjusments to the clipper
		 * */
		private function layoutLabels():void
		{
			var numLabels:Number = labelObjects ? labelObjects.numChildren : 0;
			var availSpace:Number;
			
			if (numLabels > 0)
			{
				var labelInterval:Number = (_lastLabelX - track.x) / (numLabels - 1);
				// The amount of space we have available for the labels to hang past the track
				availSpace = unscaledWidth;
				
				var labelPos:Number;
				var left:Number = track.x;
				var curLabel:Object;
				
				for (var i:int = 0; i < numLabels; i++)
				{
					curLabel = labelObjects.getChildAt(i);
					curLabel.setActualSize(curLabel.getExplicitOrMeasuredWidth(), curLabel.getExplicitOrMeasuredHeight());
					
					var yPos:Number = 0;
					
					labelPos = curLabel.getExplicitOrMeasuredWidth() / 2;
					
					if (i == 0)
						labelPos = Math.min(labelPos, availSpace / (numLabels > Number(1) ? Number(2) : Number(1)));
					else if (i == (numLabels - 1))
						labelPos = Math.max(labelPos, curLabel.getExplicitOrMeasuredWidth() - availSpace / 2);
					
					curLabel.move(left - labelPos,yPos);
			
					left += labelInterval;
				}
			}
		}
		
		public function onThumbOver(thumb:Object): void{
			_rollOver = true;
			if (! _pressed){
				checkAndPresentDataTip(thumb);
			}
		}
		
		public function onThumbOut(thumb:Object): void{
			_rollOver = false
			destroyDataTip(thumb);
		}
		
		override mx_internal function onThumbPress(thumb:Object):void{
			_pressed = true;
			destroyDataTip(thumb);
			super.onThumbPress(thumb);
		}
		
		override mx_internal function onThumbRelease(thumb:Object):void{
			_pressed = false;
			if (_rollOver){
				checkAndPresentDataTip(thumb);
			}
			super.onThumbRelease(thumb);
		}
		
		// Taken from ExtendedSlider
		private function destroyDataTip(thumb:Object):void
		{
			var localDataTip:SliderDataTip = dataTips[thumb.thumbIndex];
			if (localDataTip)
			{
				systemManager.toolTipChildren.removeChild(localDataTip);
				
				localDataTip = null;
				dataTips[thumb.thumbIndex] = null;
			}
		}
		
		
		// The code for this method is taken from ExtendedSlider::onThumbPressed.
		private function checkAndPresentDataTip(thumb:Object):void{
			if (showDataTip)
			{
				var dataTip:SliderDataTip = dataTips[thumb.thumbIndex];
				
				if (!dataTip)
				{
					dataTip = SliderDataTip(new sliderDataTipClass());
					dataTips[thumb.thumbIndex] = dataTip;
					
					systemManager.toolTipChildren.addChild(dataTip);
					
					var dataTipStyleName:String = getStyle("dataTipStyleName");
					if (dataTipStyleName)
					{
						dataTip.styleName = dataTipStyleName;
					}
				}
				
				
				var formattedVal:String;
				if (_dataTipFormatFunction != null)
					formattedVal = this._dataTipFormatFunction(getValueFromX(thumb.xPosition));
				else
					formattedVal = dataFormatter.formatPrecision(String(getValueFromX(thumb.xPosition)),
						getStyle("dataTipPrecision"));
				
				dataTip.text = formattedVal;
				
				//dataTip.text = String(getValueFromX(thumb.xPosition));
				
				// Tool tip has been freshly created and new text assigned to it.
				// Hence force a validation so that we can set the
				// size required to show the text completely.
				dataTip.validateNow();
				dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(),dataTip.getExplicitOrMeasuredHeight());
				positionDataTip(thumb);
				
				setDataTip(null);
			}
		}
		
		override protected function positionDataTip(thumb:Object):void
		{
			if (! _pressed){
				var dataTip:SliderDataTip = dataTips[thumb.thumbIndex];
				
				var relX:Number;
				var relY:Number;
				
				var tX:Number = thumb.x;
				var tY:Number = thumb.y;
				
				var tPlacement:String =  getStyle("dataTipPlacement");
				var tOffset:Number = getStyle("dataTipOffset");
				
				// Need to special case tooltip position because the tooltip movieclip
				// resides in the root movie clip, instead of the Slider movieclip
				if (_direction == SliderDirection.HORIZONTAL)
				{
					relX = tX;
					relY = tY;
					
					if (tPlacement == "left")
					{
						relX -= tOffset + dataTip.width;
						relY += (thumb.height - dataTip.height) / 2;
					}
					else if (tPlacement == "right")
					{
						relX += tOffset + thumb.width;
						relY += (thumb.height - dataTip.height) / 2;
					}
					else if (tPlacement == "top")
					{
						relY -= tOffset + dataTip.height;
						relX -= (dataTip.width - thumb.width) / 2;
					}
					else if (tPlacement == "bottom")
					{
						relY += tOffset + thumb.height;
						relX -= (dataTip.width - thumb.width) / 2;
					}
				}
				else
				{
					relX = tY;
					relY = unscaledHeight - tX - (dataTip.height + thumb.width) / 2;
					
					if (tPlacement == "left")
					{
						relX -= tOffset + dataTip.width;
					}
					else if (tPlacement == "right")
					{
						relX += tOffset + thumb.height;
					}
					else if (tPlacement == "top")
					{
						relY -= tOffset + (dataTip.height + thumb.width) / 2;
						relX -= (dataTip.width - thumb.height) / 2;
					}
					else if (tPlacement == "bottom")
					{
						relY += tOffset + (dataTip.height + thumb.width) / 2;
						relX -= (dataTip.width - thumb.height) / 2;
					}
				}
				
				var o:Point = new Point(relX, relY);
				var r:Point = localToGlobal(o);
				
				dataTip.x = r.x < 0 ? 0 : r.x;
				dataTip.y = r.y < 0 ? 0 : r.y;
			} else {
				super.positionDataTip(thumb);
			}
		}
	
	}
}