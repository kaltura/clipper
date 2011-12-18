package commands
{
	import com.kaltura.commands.uiConf.UiConfGet;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaUiConf;
	
	import events.UIConfEvent;
	
	import flash.events.Event;
	
	import model.ZoomBoxValue;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class GetUiconfCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			var uiconfGet:UiConfGet = new UiConfGet(parseInt((event as UIConfEvent).uiconfId));
			uiconfGet.addEventListener(KalturaEvent.COMPLETE, result);
			uiconfGet.addEventListener(KalturaEvent.FAILED, fault);
			_model.increaseLoadingCounter();
			_model.uiconfLoaded = false;
			_model.kc.post (uiconfGet);
		}
		
		public function result(event:KalturaEvent):void {
			try {
				_model.uiconfXML = new XML((event.data as KalturaUiConf).confFile);
				parseUiconf(_model.uiconfXML);
				_model.uiconfLoaded = true;
			}
			catch (e:Error) {
				Alert.show(ResourceManager.getInstance().getString('clipper','uiconfError'), ResourceManager.getInstance().getString('clipper','error'));
			}
			_model.decreaseLoadingCounter();
		}
		
		public function fault(event:KalturaEvent):void {
			Alert.show(ResourceManager.getInstance().getString('clipper','uiconfError'), ResourceManager.getInstance().getString('clipper','error'));
			_model.decreaseLoadingCounter();
		}
		
		private function parseUiconf(uiconf:XML):void {
			if (_model.uiconfXML.components) {
				if (_model.uiconfXML.components.maxAllowedRows.toString()) 
					_model.maxAllowedRows = parseInt(_model.uiconfXML.components.maxAllowedRows.toString());
				if (_model.uiconfXML.components.showControlBar.toString())
					_model.showControlBar = (_model.uiconfXML.components.showControlBar.toString() == "true");
				if (_model.uiconfXML.components.showMessageBox.toString())
					_model.showMsgBox = (_model.uiconfXML.components.showMessageBox.toString() == "true");
				if (_model.uiconfXML.components.zoomBoxValues) {
					_model.zoomBoxValues = new Array();
					for each (var value:XML in (_model.uiconfXML.components.zoomBoxValues as XMLList).children()) {
						var newValue:ZoomBoxValue = new ZoomBoxValue();
						if (value.valueLocaleKey.toString())
							newValue.label = ResourceManager.getInstance().getString('clipper', value.valueLocaleKey.toString());
						if (!newValue.label)
							newValue.label = value.valueLabel.toString();
						newValue.valueInMS = value.valueInMS.toString();
						_model.zoomBoxValues.push(newValue);
					}
				}
			}
		}
	}
}