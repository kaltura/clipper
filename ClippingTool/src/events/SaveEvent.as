package events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class SaveEvent extends Event
	{
		public static const SAVE_CUE_POINTS:String = "saveCuePoints";
		public static const SAVE_CLIPS:String = "saveClips";
		public static const SAVE_TRIM:String = "saveTrim";
		/**
		 * current entry
		 * */
		public var entryId:String;
		/**
		 * array collection of added assets 
		 */		
		public var addedAc:ArrayCollection;
		/**
		 *array collection of updated assets 
		 */		
		public var updatedAc:ArrayCollection;
		/**
		 * array collection of deleted assets 
		 */		
		public var deletedAc:ArrayCollection;
		
		public function SaveEvent(type:String, entry_id:String, added:ArrayCollection, updated:ArrayCollection, deleted:ArrayCollection, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			entryId = entry_id;
			addedAc = added;
			updatedAc = updated;
			deletedAc = deleted;
			super(type, bubbles, cancelable);
		}
	}
}