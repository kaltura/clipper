package model.clipperTimeline
{
	// TODO: When proper refactoring is due, move everything you can that is dependent on states to this interfcae instead.
	public interface IClipperBehaviour
	{
		function get addButtonToolTip():String;
		function get removeButtonToolTip():String;
	}
}