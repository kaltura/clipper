package model
{
	import com.kaltura.vo.KalturaClipAttributes;
	import com.kaltura.vo.KalturaMediaEntry;

	public class MediaClipVO
	{
		public var id:String;
		
		public var entry:KalturaMediaEntry;
		
		public var clipAttributes:KalturaClipAttributes;
		
		public function MediaClipVO(entry:KalturaMediaEntry, attributes:KalturaClipAttributes) {
			this.entry = entry;
			this.clipAttributes = attributes ;
		}

	}
}