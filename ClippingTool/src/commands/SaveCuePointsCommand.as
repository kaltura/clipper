package commands
{
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.cuePoint.CuePointAdd;
	import com.kaltura.commands.cuePoint.CuePointDelete;
	import com.kaltura.commands.cuePoint.CuePointList;
	import com.kaltura.commands.cuePoint.CuePointUpdate;
	import com.kaltura.events.KClipErrorCodes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaCuePoint;
	import com.kaltura.vo.KalturaCuePointFilter;
	import com.kaltura.vo.KalturaCuePointListResponse;
	
	import events.SaveEvent;
	
	import flash.events.Event;
	
	import model.MessageVO;
	
	import mx.resources.ResourceManager;
	
	import utils.ListCuePointsUtil;

	public class SaveCuePointsCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {

			var evt:SaveEvent = event as SaveEvent;
			var mr:MultiRequest = new MultiRequest();
			var requestNum:int = 0;
			for each (var cp:KalturaCuePoint in evt.addedAc) {
				cp.id = null;
				var add:CuePointAdd = new CuePointAdd(cp);
				mr.addAction(add);
				requestNum++;
			}
			for each (var updateCp:KalturaCuePoint in evt.updatedAc) {
				updateCp.setUpdatedFieldsOnly(true);
				var update:CuePointUpdate = new CuePointUpdate(updateCp.id, updateCp);
				mr.addAction(update);
				requestNum++;
			}
			for each (var deleteCp:KalturaCuePoint in evt.deletedAc) {
				var deleteRequest:CuePointDelete = new CuePointDelete(deleteCp.id);
				mr.addAction(deleteRequest);
				requestNum++;
			}
		/*	var filter:KalturaCuePointFilter = new KalturaCuePointFilter();
			filter.entryIdEqual = (event as SaveEvent).entryId;
			var listCP:CuePointList = new CuePointList(filter);
			mr.addAction(listCP);*/
			if (requestNum > 0) {
				_model.increaseLoadingCounter();
				mr.addEventListener(KalturaEvent.COMPLETE, result);
				mr.addEventListener(KalturaEvent.FAILED, fault);
				
				_model.saveComplete = _model.saveFailed = false;
				_model.kc.post(mr);
			}
		}
	
		public function result(data:KalturaEvent):void {
		/*	var response:Array = data.data as Array;
			if (response) {
				if (response[response.length - 1] is KalturaCuePointListResponse)
					ListCuePointsUtil.handleResponse((response[response.length - 1] as KalturaCuePointListResponse).objects);
			}
			*/
			var resArray:Array = data.data as Array;
			for (var i:int = 0; i<resArray.length; i++) {
				if (resArray[i].error) {
					var messageVo:MessageVO = new MessageVO;
					messageVo.messageText = resArray[i].error.message;
					messageVo.messageCode = KClipErrorCodes.SAVE_FAILED;
					_model.message = messageVo;
					_model.saveFailed = true;
					_model.decreaseLoadingCounter();
					return;
				}
			}
			_model.saveComplete = true;
			_model.decreaseLoadingCounter();
		}
		
		public function fault(event:KalturaEvent):void {
			var messageVo:MessageVO = new MessageVO;
			messageVo.messageText = ResourceManager.getInstance().getString('clipper','saveFailed');
			messageVo.messageCode = KClipErrorCodes.SAVE_FAILED;
			_model.message = messageVo;
			_model.saveFailed = true;
			_model.decreaseLoadingCounter();
		}
	}
	

}