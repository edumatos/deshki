package entities
{
	public class User
	{
		private var _id:int;
		private var _name:String;
		
		public function User(id:int, name:String)
		{
			_id = id;
			_name = name;
		}

		public function get id():int
		{
			return _id;
		}

		public function get name():String
		{
			return _name;
		}


	}
}