package commands
{
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.commands.media.MediaUpdate;
	import com.kaltura.commands.media.MediaUpdateContent;
	import com.kaltura.errors.KalturaError;
	import com.kaltura.events.KClipErrorCodes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.types.KalturaEntryStatus;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaEntryResource;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaOperationResource;
	
	import events.SaveEvent;
	
	import flash.events.Event;
	
	import model.MediaClipVO;
	import model.MessageVO;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class TrimClipCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			var evt:SaveEvent = event as SaveEvent;
			if (evt.addedAc && evt.addedAc.length > 0) {
				_model.increaseLoadingCounter();
				var mr:MultiRequest = new MultiRequest();
				var mediaClip:MediaClipVO = evt.addedAc.getItemAt(0) as MediaClipVO;
				var mediaUpdate:MediaUpdate = new MediaUpdate(evt.entryId, mediaClip.entry);
				mr.addAction(mediaUpdate);
				var resource:KalturaOperationResource = new KalturaOperationResource();
				resource.resource = new KalturaEntryResource();
				resource.resource.entryId = evt.entryId;
				resource.operationAttributes = new Array(mediaClip.clipAttributes);
				var updateContent:MediaUpdateContent = new MediaUpdateContent(evt.entryId, resource);
				mr.addAction(updateContent);
				//to get the updated entry
			//	var baseEntryGet:BaseEntryGet = new BaseEntryGet(evt.entryId);
			//	mr.addAction(baseEntryGet);
				
				mr.addEventListener(KalturaEvent.COMPLETE, result);
				mr.addEventListener(KalturaEvent .FAILED, fault);
				
				_model.kc.post(mr);
			}
		}
		
		public function result(data:KalturaEvent) : void {
			_model.decreaseLoadingCounter();
			var res:Array = data.data as Array;
			var messageVo:MessageVO = new MessageVO();
			for (var i:int = 0; i<res.length; i++) {
				if (res[i]["error"]) {
					_model.saveFailed = true;	
					messageVo.messageText = res[i].error.message;
					messageVo.messageCode = KClipErrorCodes.SAVE_FAILED;
					_model.message = messageVo;
					return;
				}
			}
			
			messageVo.messageText = ResourceManager.getInstance().getString('clipper','entryReplaced');
			messageVo.messageCode = KClipErrorCodes.ENTRY_REPLACED;
			_model.message = messageVo;
			//reset viewed data
			_model.itemsAC = new ArrayCollection();
			_model.saveComplete = true;
		}
		
		public function fault(event:KalturaError) : void {
			_model.saveFailed = true;
			var messageVo:MessageVO = new MessageVO();
			messageVo.messageText = ResourceManager.getInstance().getString('clipper','saveFailed');
			messageVo.messageCode = KClipErrorCodes.SAVE_FAILED;
			_model.message = messageVo;
			_model.decreaseLoadingCounter();
		}
	}
}