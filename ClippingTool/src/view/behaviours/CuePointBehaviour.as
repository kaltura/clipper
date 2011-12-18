package view.behaviours
{
	import model.clipperTimeline.IClipperBehaviour;
	
	import mx.resources.IResourceManager;

	public class CuePointBehaviour implements IClipperBehaviour
	{
		private var _rm:IResourceManager; 
		
		public function CuePointBehaviour(rm:IResourceManager)
		{
			_rm = rm;
		}
		
		public function get addButtonToolTip():String{
			return _rm.getString('clipper','add_cuepoint');
		}
		
		public function get removeButtonToolTip():String{
			return _rm.getString('clipper','remove_cuepoint');
		}
	}
}