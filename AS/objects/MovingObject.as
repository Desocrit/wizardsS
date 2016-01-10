package AS.objects {
	import flash.display.MovieClip;
	
	public class MovingObject extends MovieClip {
		
		private var _friction:Number = 0.2;
		private var _velocityDirection: Number = 0;
		private var _velocity: Number = 0;
		
		public function MovingObject(friction:Number, velocity:Number, velocityDirection: Number)
		{
			_friction = friction;
			_velocity = velocity;
			_velocityDirection = velocityDirection;
			super();
		}
		
		public function update(): void
		{
			_velocity -= _velocity * _friction;
			this.y-=_velocity*(Math.cos(Model.toRads(_velocityDirection)));
			this.x+=_velocity*(Math.sin(Model.toRads(_velocityDirection)));
			this.rotation = _velocityDirection;
			if(this.x < 10)
				this.x = 12;
			if(this.y < 10)
				this.y = 12;
			if(this.x > 590)
				this.x = 588;
			if(this.y > 390)
				this.y = 388;
		}
		
		public function stopMoving(): void 
		{
			_velocity = 0;
		}
		
		public function addForce(strength:Number, direction:Number, slowable: Boolean = false): void 
		{
			var resolvedForces: Array = resolveForces(_velocity, _velocityDirection, strength, direction);
			_velocity = resolvedForces[0];
			_velocityDirection = resolvedForces[1];
		}
		
		public function isMoving():Boolean{
			return (_velocity < 0.0001);
		}
		
		public static function resolveForces(force1Str:Number, force1Dir:Number, force2Str:Number, force2Dir:Number): Array
		{
			var horisontalComponent:Number = force1Str * Math.cos(force1Dir / (180/Math.PI))+ force2Str * Math.cos(force2Dir / (180/Math.PI));
			var verticalComponent:Number = force1Str * Math.sin(force1Dir / (180/Math.PI))+ force2Str * Math.sin(force2Dir / (180/Math.PI));
			var result:Array = new Array(0,0);
			result[0] = Math.pow((Math.pow(verticalComponent,2) + Math.pow(horisontalComponent,2)),0.5);
			result[1] = Model.toDegrees(Math.atan(verticalComponent/horisontalComponent));
			if(horisontalComponent==0)
				if(verticalComponent>0)
					result[1]=270;
				else
					result[1]=90;
			else
				result[1] = Math.atan(verticalComponent/horisontalComponent)/(Math.PI/180);
			if (horisontalComponent<0)
				result[1] += 180;
			if (horisontalComponent>0 && verticalComponent<0)
				result[1] += 360;
			return result;
		}		
	}
}