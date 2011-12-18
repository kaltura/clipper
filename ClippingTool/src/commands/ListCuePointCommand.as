package commands
{
	import com.kaltura.commands.cuePoint.CuePointList;
	import com.kaltura.events.KClipErrorCodes;
	import com.kaltura.events.KClipEventTypes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaCuePoint;
	import com.kaltura.vo.KalturaCuePointFilter;
	import com.kaltura.vo.KalturaCuePointListResponse;
	
	import events.CuePointEvent;
	
	import flash.events.Event;
	
	import model.MessageVO;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	
	import utils.ListCuePointsUtil;

	public class ListCuePointCommand extends BaseClipperCommand
	{
		override public function execute(event:Event):void {
			_model.increaseLoadingCounter();
			
			_model.itemsAC = new ArrayCollection();
			var filter:KalturaCuePointFilter = new KalturaCuePointFilter();
			filter.entryIdEqual = (event as CuePointEvent).entryId;
			filter.cuePointTypeEqual = (event as CuePointEvent).cuePointType
			var listCP:CuePointList = new CuePointList(filter);
			listCP.addEventListener(KalturaEvent.COMPLETE, result);
			listCP.addEventListener(KalturaEvent.FAILED, fault);
			_model.kc.post(listCP);
		}
		
		public function result(data:KalturaEvent):void {
			if (data.data is KalturaCuePointListResponse) {
				ListCuePointsUtil.handleResponse((data.data as KalturaCuePointListResponse).objects);
			}			
			
			_model.decreaseLoadingCounter();
		}
		
		public function fault(event:KalturaEvent):void {
			var messageVo:MessageVO = new MessageVO();
			messageVo.messageText = ResourceManager.getInstance().getString('clipper','cuePointsError');
			messageVo.messageCode = KClipErrorCodes.CUEPOINT_LOAD_FAILED;
			_model.message = messageVo;
			_model.decreaseLoadingCounter();
		}
	}
}