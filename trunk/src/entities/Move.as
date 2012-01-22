package entities
{
	/**
	 * Ход в игре.
	 */
	public class Move
	{
		/**
		 * Координата ячейки по горизонтали, начиная с нуля.
		 */
		public var x:int;
		/**
		 * Координата ячейки по вертикали, начиная с нуля.
		 */
		public var y:int;
		
		public function Move(x:int = 0, y:int = 0)
		{
			this.x = x;
			this.y = y;
		}
	}
}