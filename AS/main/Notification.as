package AS.main
{
	import AS.objects.Notifiable;
	
	public class Notification
	{
		
		private var _reference: int;
		private var _time: int;
		private var _object: Notifiable;
		private var _repeats: int;
		private var _repeatDelay: int;
		
		public function Notification(reference: int, time: int, object: Notifiable, repeats: int, repeatDelay: int){
			_reference = reference;
			_time = time;
			_object = object;
			_repeats = repeats;
			_repeatDelay = repeatDelay;
		}
		
		//Accessors
		public function get reference() 	{ return _reference; }
		public function get object() 		{ return _object; }
		public function get time(): int		{ return _time; }
		public function set time(time: int) { _time = time }
		public function get repeats(): int 	{ return _repeats; }
		public function set repeats(r: int) { _repeats = r; }
		public function get repeatDelay() 	{ return _repeatDelay; }	
		
	}
}