package model
{
	[Bindable]
	/**
	 * MessageVO class will hold a message and suitable error code 
	 * @author Michal
	 * 
	 */	
	public class MessageVO
	{
		/**
		 * The displayed message 
		 */		
		public var messageText:String;
		
		/**
		 * Suitable code from KClipErrorCodes 
		 */		
		public var messageCode:String;
	}
}