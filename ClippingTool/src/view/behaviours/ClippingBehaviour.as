package view.behaviours
{
	import model.clipperTimeline.IClipperBehaviour;
	
	import mx.resources.IResourceManager;
	
	public class ClippingBehaviour implements IClipperBehaviour
	{
		private var _rm:IResourceManager;
		
		public function ClippingBehaviour(rm:IResourceManager){
			_rm = rm;
		}
		
		public function get addButtonToolTip():String{
			return _rm.getString('clipper','add_clip');
		}
		
		public function get removeButtonToolTip():String{
			return _rm.getString('clipper','remove_clip');
		}
	}
}