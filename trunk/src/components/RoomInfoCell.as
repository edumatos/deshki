package components
{
	import playerio.RoomInfo;
	
	import razor.controls.grid.SelectableCell;
	
	public class RoomInfoCell extends SelectableCell
	{
		override public function get label():String
		{
			var roomInfo:RoomInfo = dP as RoomInfo;
			return roomInfo.id + " (" + roomInfo.onlineUsers + ")";
		}
	}
}