package control
{
	import com.kaltura.events.KClipEventTypes;
	
	import commands.GetBaseEntryCommand;
	import commands.GetUiconfCommand;
	import commands.JSCommand;
	import commands.ListCuePointCommand;
	import commands.SaveClipsCommand;
	import commands.SaveCuePointsCommand;
	import commands.TrimClipCommand;
	import commands.UpdateMessageCommand;
	
	import events.BaseEntryEvent;
	import events.ClipperExternalEvent;
	import events.ClipperMessageEvent;
	import events.CuePointEvent;
	import events.ExternalInterfaceEvent;
	import events.JSEvent;
	import events.SaveEvent;
	import events.UIConfEvent;
	
	import model.clipperAPI.ExternalInterfaceProxy;
	
	import view.Clipper;

	public class ClipperController
	{
		private var _extInterfaceProxy:ExternalInterfaceProxy;
		
		public function ClipperController(clippingTool:KClip)
		{
			initializeCommands(clippingTool);
			_extInterfaceProxy = new ExternalInterfaceProxy();
		}
		
		public function initializeCommands(clippingTool:KClip):void {
			//get entry
			clippingTool.addEventListener(BaseEntryEvent.GET, callBaseEntryGet);
			//get uiconf
			clippingTool.addEventListener(UIConfEvent.GET_UICONF, callUiconfGet);
			//external interface
			clippingTool.addEventListener(ExternalInterfaceEvent.ADD_LISTENER, registerListener);
			clippingTool.addEventListener(ExternalInterfaceEvent.REMOVE_LISTENER, removeListener);
			clippingTool.addEventListener(KClipEventTypes.CLIP_ADDED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.CLIP_END_CHANGED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.CLIP_START_CHANGED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.CUE_POINT_ADDED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.CUE_POINT_CHANGED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.PLAYHEAD_UPDATED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.PLAYHEAD_DRAG_START, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.PLAYHEAD_DRAG_DROP, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.SAVED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.ZOOM_CHANGED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.ENTRY_READY, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.ALL_ASSETS_REMOVED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.SELECTED_ASSET_REMOVED, callExtInterface);
		//	clippingTool.addEventListener(ClipperExternalEvent.TIME_BASED_ASSET_UPDATED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.SELECTED_ASSET_CHANGED, callExtInterface);
			clippingTool.addEventListener(KClipEventTypes.CLIPPER_ERROR, callExtInterface);
			clippingTool.addEventListener(JSEvent.CALL_JS, callJSCommand);
			//text message
			clippingTool.addEventListener(ClipperMessageEvent.DISPLAY_MESSAGE, setMessage);
			//cue points
			clippingTool.addEventListener(CuePointEvent.LIST_CUE_POINTS, callListCuePoints);
			//save
			clippingTool.addEventListener(SaveEvent.SAVE_CLIPS, callSaveClips);
			clippingTool.addEventListener(SaveEvent.SAVE_CUE_POINTS, callSaveCuePoints);
			clippingTool.addEventListener(SaveEvent.SAVE_TRIM, callSaveTrim);
		}
		
		private function callBaseEntryGet(event:BaseEntryEvent):void {
			var baseEntryCommand:GetBaseEntryCommand = new GetBaseEntryCommand();
			baseEntryCommand.execute(event);
		}
		private function callUiconfGet(event:UIConfEvent):void {
			var uiconfCommand:GetUiconfCommand = new GetUiconfCommand();
			uiconfCommand.execute(event);
		}
		
		private function registerListener(event:ExternalInterfaceEvent):void {
			_extInterfaceProxy.addListener(event.listenerString, event.extFuncName);
		}
		
		private function removeListener(event:ExternalInterfaceEvent):void {
			_extInterfaceProxy.removeListener(event.listenerString, event.extFuncName);
		}
		
		private function callExtInterface(event:ClipperExternalEvent):void {
			_extInterfaceProxy.notifyExtInterface(event.type, event.data);
		}
		
		private function callJSCommand(event:JSEvent):void {
			var jsCommand:JSCommand = new JSCommand();
			jsCommand.execute(event);
		}
		
		private function setMessage(event:ClipperMessageEvent):void {
			var setMessage:UpdateMessageCommand = new UpdateMessageCommand();
			setMessage.execute(event);
		}

		private function callListCuePoints(event:CuePointEvent):void {
			var listCuePoints:ListCuePointCommand = new ListCuePointCommand();
			listCuePoints.execute(event);
		}
		
		private function callSaveCuePoints(event:SaveEvent):void {
			var saveCommand:SaveCuePointsCommand = new SaveCuePointsCommand();
			saveCommand.execute(event);
		}
		
		private function callSaveClips(event:SaveEvent):void {
			var saveCommand:SaveClipsCommand = new SaveClipsCommand();
			saveCommand.execute(event);
		}

		private function callSaveTrim(event:SaveEvent):void {
			var saveCommand:TrimClipCommand = new TrimClipCommand();
			saveCommand.execute(event);
		}
	}
}