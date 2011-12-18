package commands
{
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.media.MediaAdd;
	import com.kaltura.commands.media.MediaAddContent;
	import com.kaltura.events.KClipErrorCodes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaEntryResource;
	import com.kaltura.vo.KalturaOperationResource;
	import com.kaltura.vo.KalturaResource;
	
	import events.SaveEvent;
	
	import flash.events.Event;
	
	import model.MediaClipVO;
	import model.MessageVO;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class SaveClipsCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			var evt:SaveEvent = event as SaveEvent;
			if (!evt.addedAc || evt.addedAc.length==0)
				return;
			
			_model.increaseLoadingCounter();
			var mr:MultiRequest = new MultiRequest();
			var requestIndex:int = 1;
			for each (var cp:MediaClipVO in evt.addedAc) {
				var resource:KalturaOperationResource = new KalturaOperationResource();
				resource.resource = new KalturaEntryResource();
				resource.resource.entryId = evt.entryId;
				resource.operationAttributes = new Array(cp.clipAttributes);
				var mediaAdd:MediaAdd = new MediaAdd(cp.entry);
				mr.addAction(mediaAdd);
				requestIndex++;
				var addContent:MediaAddContent = new MediaAddContent('', resource);
				mr.addAction(addContent);
				mr.mapMultiRequestParam(requestIndex-1, "id", requestIndex, "entryId");
				requestIndex++;
			}

			mr.addEventListener(KalturaEvent.COMPLETE, result);
			mr.addEventListener(KalturaEvent.FAILED, fault);
			_model.saveComplete = _model.saveFailed = false;
			_model.kc.post(mr);
		}
		
		public function result(data:KalturaEvent): void {
			_model.decreaseLoadingCounter();
			var res:Array = data.data as Array;
			for (var i:int = 0; i<res.length; i++) {
				if (res[i]["error"]) {
					_model.saveFailed = true;
					var messageVo:MessageVO = new MessageVO();
					messageVo.messageText = res[i].error.message;
					messageVo.messageCode = KClipErrorCodes.SAVE_FAILED;
					_model.message = messageVo;
					return;
				}
			}
			//reset viewed data
			_model.itemsAC = new ArrayCollection();
			_model.saveComplete = true;
		}
		
		public function fault (event:KalturaEvent):void {
			_model.saveFailed = true;
			var messageVo:MessageVO = new MessageVO();
			messageVo.messageText = ResourceManager.getInstance().getString('clipper','saveFailed');
			messageVo.messageCode = KClipErrorCodes.SAVE_FAILED;
			_model.message = messageVo;
			_model.decreaseLoadingCounter();
		}
	}
}