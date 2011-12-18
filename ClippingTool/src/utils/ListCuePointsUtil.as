package utils
{
	import com.kaltura.vo.KalturaCuePoint;
	
	import model.ClipperModelLocator;
	
	import mx.collections.ArrayCollection;

	public class ListCuePointsUtil
	{
		private static var _model:ClipperModelLocator = ClipperModelLocator.getInstance();
		
		public static function handleResponse(response:Array):void {
			var tempAc:ArrayCollection = new ArrayCollection();
			for each (var cp:KalturaCuePoint in response) {
				tempAc.addItem(cp);
			}
			_model.itemsAC = tempAc;
		}
	}
}