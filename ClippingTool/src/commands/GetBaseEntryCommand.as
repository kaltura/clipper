package commands
{
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.events.KClipErrorCodes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.types.KalturaEntryStatus;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import events.BaseEntryEvent;
	
	import flash.events.Event;
	
	import model.MessageVO;
	
	import mx.resources.ResourceManager;

	public class GetBaseEntryCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			//workaround - to make the client know the kalturaMediaEntry
			var dummyEntry:KalturaMediaEntry;

			var baseEntryGet:BaseEntryGet = new BaseEntryGet((event as BaseEntryEvent).entryId);
			baseEntryGet.addEventListener(KalturaEvent.COMPLETE, result);
			baseEntryGet.addEventListener(KalturaEvent.FAILED, fault);
			_model.increaseLoadingCounter();
			_model.kc.post (baseEntryGet);
		}
		
		public function result(event:KalturaEvent):void {
			var resultEntry:KalturaBaseEntry = event.data as KalturaBaseEntry;
			var messageVo:MessageVO = new MessageVO();
			if (resultEntry.status!=KalturaEntryStatus.READY) {
				messageVo.messageText = ResourceManager.getInstance().getString('clipper','entryNotReadyError');
				messageVo.messageCode = KClipErrorCodes.ENTRY_PROCESSING;
			}
			else {
				messageVo.messageText = messageVo.messageCode = '';
				_model.currentEntry = resultEntry;
			} 
			_model.message = messageVo;
			_model.decreaseLoadingCounter();
		}
		
		public function fault(event:KalturaEvent):void {
			trace ("failed to load entry");
			var messageVo:MessageVO = new MessageVO();
			messageVo.messageText = ResourceManager.getInstance().getString('clipper','entryNotReadyError');
			messageVo.messageCode = KClipErrorCodes.ENTRY_PROCESSING;
			_model.message = messageVo;
			_model.decreaseLoadingCounter();
		}
	}
}