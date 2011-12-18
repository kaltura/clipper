package view.layers.utils
{
	import mx.controls.HScrollBar;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	public class KScrollBar extends HScrollBar
	{
		
		private var _stepSize:Number = 0.1;
		
		public function KScrollBar(){
			super();
		}
		
		override public function set scrollPosition(value:Number):void{
			var roundedValue:Number = Math.round(value / _stepSize) * _stepSize;
			super.scrollPosition = roundedValue;
		}
		
		public function set stepSize(value:Number):void{
			_stepSize = value;
		}
	}
}