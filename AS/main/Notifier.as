package AS.main
{
	import AS.objects.Model;
	import AS.objects.Notifiable;
	
	public class Notifier
	{
		private var _time: int = 0, _timeStop: int = 0;
		private var _paused: Boolean = false;
		
		private var _priorityQueue: Array = new Array();
		private var _updateRequests: Vector.<UpdateRequest> = new Vector.<UpdateRequest>();
		
		public function requestNotification(object: Notifiable, time: int, 
											reference: int = 0, repeats = 1, repeatTime = -1): void
		{
			if(_timeStop > 0)
				for each(var notification: Notification in _priorityQueue)
					if(notification.object == object && notification.reference == reference)
						return;
			if(repeatTime == -1)
				repeatTime = time;
			addElement(new Notification(reference, time + _time, object, repeats, repeatTime));
		}
		
		public function requestUpdates(object: Notifiable, reference: int = 0)
		{
			_updateRequests.push(new UpdateRequest(reference, object));
		}
		
		public function stopRequest(object: Notifiable, ref: int)
		{
			for each(var updateRequest: UpdateRequest in _updateRequests)
				if(updateRequest.object == object && updateRequest.reference == ref)
					_updateRequests.splice(_updateRequests.indexOf(updateRequest),1);
			for each(var notification: Notification in _priorityQueue)
				if(notification.object == object && notification.reference == ref)
					_priorityQueue.splice(_priorityQueue.indexOf(notification),1);
					
		}
		
		public function pauseRequest(object: Notifiable, ref: int)
		{
			for each(var request: UpdateRequest in _updateRequests)
				if(request.object == object && request.reference == ref)
					request.paused = true;
		}
		
		public function resumeRequest(object: Notifiable, ref: int)
		{
			for each(var request: UpdateRequest in _updateRequests)
				if(request.object == object && request.reference == ref)
					request.paused = false;
		}
		
		public function timeStop(duration: int): void
		{
			_timeStop = duration;
			Model.animationsRunning = false;
		}
		
		public function set paused(value: Boolean)
		{
			_paused = value;
		}
		
		public function tick(time: int): void
		{
			if(_paused)
				return;
			if(_timeStop > 0)
			{
				Model.player.notify(1);
				_timeStop -= time;
				//Sepia reset:
				if(_timeStop < 160 && _timeStop + time >= 160)
					Model.stage.sepia = false;
				if(_timeStop < time)
					Model.animationsRunning = true;
				//Handle missiles
				if(_timeStop % (1000 / Model.player.attackSpeed) > 
					(_timeStop + time) % (1000 / Model.player.attackSpeed))
					Model.player.notify(0);
				//Handle shapes
				for(var i: int = 0; i < 4; i++)
					if(Model.shapes[i].timeCast == _time && Model.shapes[i].shape < 4)
					{
						Model.shapes[i].x = Model.player.x;
						Model.shapes[i].y = Model.player.y;
					}
				return;
			}
			for each(var request: UpdateRequest in _updateRequests)
				if(!request.paused)
					request.object.notify(request.reference);
			if(_paused)
				return;
			_time += time;
			if(_priorityQueue.length != 0)
			{
				while(_priorityQueue[_priorityQueue.length - 1].time <= _time)
				{
					var notification: Notification = _priorityQueue.pop();
					if(notification.repeats !=1){
						notification.repeats --;
						notification.time = _time + notification.repeatDelay;
						addElement(notification);
					}
					notification.object.notify(notification.reference);
					if(_priorityQueue.length == 0)
						return;
				}
			}
		}
		
		// Adds values using a Priority Queue system.
		private function addElement(element: Notification): void
		{
			if(_priorityQueue.length == 0)
				_priorityQueue.push(element);
			else
			{
				for(var i: int = _priorityQueue.length - 1; i >= 0; i--){
					if(element.time > _priorityQueue[i].time)
						_priorityQueue[i+1] = _priorityQueue[i];
					else
						break;
				}
				_priorityQueue[i + 1] = element;
			}
		}
			
		//Accessors
		public function get time(): int 			{ return _time; 			}
		public function get paused(): Boolean 		{ return _paused; 			}
		public function get timeStopped(): Boolean 	{ return (_timeStop > 0);	}
		
	}
}