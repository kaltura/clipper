package view.TimeBasedAssets
{
	public class NullTimeBasedAsset implements ITimeBasedAsset
	{
		public function NullTimeBasedAsset()
		{
		}
		
		public function get timeInMS():Number
		{
			return 0;
		}
		
		public function set timeInMS(value:Number):void
		{
		}
		
		public function get startX():Number
		{
			return 0;
		}
		
		public function set startX(value:Number):void
		{
		}
		
		public function get assetWidth():Number
		{
			return 0;
		}
		
		public function set assetWidth(value:Number):void
		{
		}
		
		public function get selectionState():Boolean
		{
			return false;
		}
		
		public function set selectionState(value:Boolean):void
		{
		}
		
		public function get assetVo():Object
		{
			return false;
		}
		
		public function set assetVo(value:Object):void
		{
		}
		
		public function setErrorState(value:Boolean):void
		{
		}
	}
}