package AS.objects {
	
	import flash.display.MovieClip;
	import AS.gems.BasicGem;
	import AS.gems.PowerGem;
	
	public class Shape extends MovieClip implements Notifiable 
	{
		
		public static const SHORT_CONE: int = 0;
		public static const LONG_CONE: int = 1;
		public static const AURA: int = 2;
		public static const BEAM: int = 3;
		public static const BOMB: int = 4;
		public static const ZONE: int = 5;
		public static const WALL: int= 6;
		public static const RING: int = 7;
		
		private var _shape:Number;
		private var _caster: Actor;
		private var _range:Number;
		private var _damage: int;
		private var _element: Element;
		private var _targetsHit: Vector.<Enemy>;
		private var _repeats: int;
		private var _boost: Number = 1;
		private var _timeCast: int;
		private var _ready: Boolean = true;
		private var _hitSomething: Boolean = false;
		
		public var ele: MovieClip
		
		public function Shape(shape:Number, element: Element, caster: Actor,
							  damage: int = 10)
		{
			_caster = caster;
			_element = element;
			_shape=shape;
			_damage = damage;
			_range = Model.shapeRange;
		}
		
		public function cast(targetX:int, targetY:int): void 
		{
			//Set variables.
			_targetsHit = new Vector.<Enemy>();
			_repeats = 0;
			_hitSomething = false;
			//Set up subvariables.
			gotoAndStop(_shape + 1);
			ele.gotoAndStop(_element.type + 1);
			ele.fx.gotoAndStop(1);
			//Place and scale.
			Model.stage.addChildAt(this,2);
			if(_shape < 4)
				move(_caster.x, _caster.y);
			else
				move(targetX, targetY);
			this.rotation=Model.toDegrees(Model.angleBetweenPts(targetX, _caster.x, targetY, _caster.y));
			this.scaleX = this.scaleY = _range;
			if(shape == BEAM)
				rescaleBeam();
			//Find targets hit, and damage them
			damageTargets();
			//Get updated for frames and cooldowns.
			_timeCast = Model.notifier.time;
			_ready = false;
			Model.notifier.requestNotification(this, Model.shapeCooldown,0);
			Model.notifier.requestUpdates(this, 1);
			if(PowerGem.RYZE.active)
				Model.reduceShapeCooldowns(1000);
		}
		
		private function rescaleBeam()
		{
			var dist = Model.distBetweenPts(x, (this.rotation > 0) ? 600 : 0,
					y , (this.rotation > -90 && this.rotation < 90) ? 0 : 480);
			if(dist > 250)
				scaleY = dist / 200;
		}
		
		private function getTargets(): Vector.<Actor> 
		{
			var targets: Vector.<Actor> = new Vector.<Actor>();
			var angle: Number, dist: Number, maxRange: Number;
			maxRange = new Array(8 * ele.fx.currentFrame, 11.5 * ele.fx.currentFrame,
				4.5 * ele.fx.currentFrame, 9999, 47, 42, 9999, 45)[_shape] * _range;
			for each(var target: Actor in Model.getTargetArray(_caster))
			{
				if(_targetsHit.indexOf(target) == -1)
				{   
					angle = Model.toDegrees(Model.angleBetween(target, this)) - this.rotation;
					dist = Model.distBetween(target, this);
					if(dist>maxRange)
						continue;
					if(_shape == AURA || _shape == ZONE || _shape == BOMB)
					{
						targets.push(target);
						continue;	
					}
					if(_shape < BOMB)
					{
						var bounds: Number;
						if(_shape <= LONG_CONE)
							bounds = (_shape == SHORT_CONE) ? //Cones
								Model.toDegrees(Math.atan(0.57735/_range) + Math.asin(10/dist)): //Short
								Model.toDegrees(Math.atan(0.267949/_range) + Math.asin(10/dist)); //Long
						else
							bounds = Model.toDegrees(Math.atan((10 + (4.5 * _range))/dist)); //Beam
						if(angle < bounds && angle > -bounds)
							targets.push(target);
						continue;
					}
					if(_shape == WALL)
						if(Math.abs(dist * Math.cos(Model.toRads(angle))) < 12.5 &&
							Math.abs(dist * Math.sin(Model.toRads(angle))) < 10 + (_range * 50))
							targets.push(target);
					if(_shape == RING)
						if(dist > 18 * _range)
							targets.push(target);
				}		
			}
			_targetsHit = _targetsHit.concat(targets);	
			return targets;
		}
		
		private function damageTargets(): void
		{
			for each(var enemy: Enemy in getTargets())
			{
				_element.dealDamage(enemy, _caster, _hitSomething, _damage * _boost * _caster.shapeDamageModifier, true, this);
				if(!_hitSomething)
					_hitSomething = true;
				if(_boost != 1)
					_boost = 1;
				if(BasicGem.DAMAGE_AFTER_SHAPE.active)
					_caster.addStatusEffect(StatusEffect.BUFF_CONSISTENCY, _caster);
			}
		}
		
		public function notify(ref: int): void 
		{
			switch(ref)
			{
				case 0:
					_ready = true;
					break;
				case 1:
					update();
					break;
				default:
					break;
			}
		}
		
		public function update(){
			//Destroy if the final frame.
			if(ele.fx.currentFrame == ele.fx.totalFrames)
			{
				if((_shape != BEAM || _repeats == 3) && ((_shape != WALL && _shape != RING) || 
					(_repeats == 2 && ! BasicGem.SHAPE_DURATION) || _repeats == 3 ))
				{
					Model.stage.removeChild(this);
					Model.notifier.stopRequest(this, 1);
					return;
				}
				_repeats++;
				ele.fx.gotoAndStop(1);
			} else
				this.ele.fx.nextFrame();
			damageTargets();
			if(_shape < BOMB)
				move(_caster.x, _caster.y);
		}
		
		public function reduceCooldown(amount: int): void
		{
			Model.notifier.stopRequest(this, 0);
			if(Model.shapeCooldown - Model.notifier.time + _timeCast - amount < 0)
			{
				notify(0);
				return;
			}
			Model.notifier.requestNotification(this, Model.shapeCooldown - 
				Model.notifier.time + _timeCast - amount, 0);
			_timeCast -= amount;
			
		}
		
		public function resetCooldown(): void {
			Model.notifier.stopRequest(this, 0);
			_ready = true;
		}
		
		public static function getName(shape: int): String
		{
			switch(shape)
			{
				case SHORT_CONE:
					return "Nova";
				case LONG_CONE:
					return "Blast";
				case AURA:
					return "Explosion";
				case BEAM:
					return "Beam";
				case BOMB:
					return "Bomb";
				case ZONE:
					return "Zone";
				case WALL:
					return "Wall";
				case RING:
					return "Ring";
				default:
					return "Unknown";
			}
		}
		
		public static function getDescription(shape: int): String
		{
			switch(shape)
			{
				case SHORT_CONE:
					return "Fires out a short but wide cone, dealing elemental damage. Good in a pinch.";
				case LONG_CONE:
					return "Fires out a long but thin cone, dealing elemental damag. Useful for clustered foes.";
				case AURA:
					return "Attacks all enemies nearby, dealing elemental damage. Helpful when surrounded.";
				case BEAM:
					return "Attacks enemies in a beam, dealing elemental damage. Strong at long range.";
				case BOMB:
					return "Explodes outward, then implodes, dealing elemental damge. Good against immobile foes.";
				case ZONE:
					return "Creates a damaging circle, dealing elemental damage. Strong against clustered foes.";
				case WALL:
					return "Creates a wall, dealing elemental damage to anything it touches. A strong defense.";
				case RING:
					return "Creates a ring, dealing elemental damage to anything it touches. Attacks a large area.";
				default:
					return "Unknown shape.";
			}
		}
		
		private function move(newX: int, newY: int)		{ x = newX; y = newY; 	}
		public function empower(amount: Number)			{ _boost *= amount; 	}
		
		public function get shape():Number				{ return _shape; 		}
		public function set shape(value:Number):void	{ _shape = value; 		}
		public function get range():Number				{ return _range;		}
		public function set range(value:Number):void	{ _range = value;		}
		public function get damage():int				{ return _damage;		}
		public function set damage(value:int):void		{ _damage = value;		}
		public function get element():Element			{ return _element;		}
		public function set element(value:Element):void	{ _element = value;		}
		public function get timeCast():int				{ return _timeCast; 	}
		public function get isReady():Boolean 			{ return _ready; 		}
	}
}
