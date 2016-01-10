package AS.main
{
	
	import AS.objects.Notifiable;
	
	public class UpdateRequest
	{
		
		private var _reference: int;
		private var _object: Notifiable;
		private var _paused: Boolean  =  false;
		
		public function UpdateRequest(reference: int, object: Notifiable){
			_reference = reference;
			_object = object;
		}
		
		//Accessors
		public function get reference(): int			{ return _reference;}
		public function get object(): Notifiable		{ return _object; 	}
		public function get paused():Boolean			{ return _paused; 	}
		public function set paused(value:Boolean):void 	{ _paused = value; 	}
		
		
	}
}