package model.clipperTimeline.extensions
{
	import flash.events.MouseEvent;
	
	import flexlib.controls.sliderClasses.SliderThumb;
	
	import model.clipperTimeline.ClipperSlider;
	
	public class ClipperSliderThumb extends SliderThumb
	{
		public function ClipperSliderThumb()
		{
			super();
			addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
		}
		
		protected function mouseRollOutHandler(event:MouseEvent):void{
			if (enabled){
				ClipperSlider(owner).onThumbOut(this);
			}
		}
		
		protected function mouseRollOverHandler(event:MouseEvent):void{
			if (enabled){
				ClipperSlider(owner).onThumbOver(this);
			}
		}
	}
}