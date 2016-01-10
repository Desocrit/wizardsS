package AS.objects {
	
	import AS.main.View;
	
	import flash.display.MovieClip;
	import flash.events.Event;	
	
	public class Missile extends MovingObject implements Notifiable 
	{
		
		private var _damage:Number;
		private var _target: Actor;
		private var _element: Element;
		private var _caster: Actor;
		private var _triggerEffects: Boolean;
		private var _origin: Actor;
		private var _curves: Boolean;
		private var _duration: int;
		private var _moving: Boolean = true;
		
		public var explosion: MovieClip;
		
		public function Missile(element: Element, caster: Actor, targetX: int, targetY: int, damage: int, 
								triggerEffects: Boolean, origin: MovieClip, curves: Boolean = true, duration: int = -1) 
		{	
			Model.missileVector.push(this);
			_damage=damage;
			x = origin.x;
			y = origin.y;
			this.rotation = Model.toDegrees(Model.angleBetweenPts(targetX, this.x, targetY, this.y));
			_element = element;
			_caster = caster;
			_triggerEffects = triggerEffects;
			_curves = curves;
			_duration = duration;
			if(origin is Actor)
				_origin = (origin as Actor);
			super((curves) ? 0.2 : 0.3,(curves) ? 20 : 0,
				Model.toDegrees(Model.angleBetweenPts(targetX, this.x, targetY, this.y)));
			Model.stage.addChildAt(this, Model.stage.numChildren-3);
			gotoAndStop(element.type + 1);
			findTarget(targetX, targetY);
			Model.notifier.requestUpdates(this, 1);
		}
		
		private function findTarget(targetX: int, targetY: int): void 
		{			
			var dist: int = 9001, delta: int;
			var possibleTargets: Vector.<Actor> = Model.getTargetArray(_caster);
			if(possibleTargets.length == 0)
			{
				explosion.gotoAndStop(2);
				return;
			}
			for each (var target: Actor in possibleTargets)
			{
				if(target==_origin)
					continue;
				delta = Model.distBetweenPts(target.x,targetX,target.y,targetY);
				if(delta < dist) 
				{
					_target=target;
					dist=delta;
				}
			}
		}
		
		public function notify(ref: int): void
		{
			var dist: int = 9001;
			//Check duration
			if(_duration != -1)
				if((_duration -= 40) <= 0)
					if((this.alpha -= 0.2) == 0)
					{
						Model.notifier.stopRequest(this, 1);
						this.parent.removeChild(this);
						Model.missileVector.splice(Model.missileVector.indexOf(this),1);
					}
			//Check for collisions
			if(explosion.currentFrame == 1) 
			{
				// If target is dead, pick closest.
				if(_target != null && _target.hp <= 0)
					findTarget(this.x, this.y);
				for each(var target: Actor in Model.getTargetArray(_caster))
				{
					if(Model.distBetween(target, this) < 15 && target != _origin)
					{ //If target is in range, gogogo
						_target = target;
						if(_target.reflecting)
						{
							if(Spell.REFLECT.hasUpgrade(1))
								_target.healPercent(20,_target);
							if(Spell.REFLECT.hasUpgrade(2))
								_damage *= 1.5;
							super.stopMoving();
							_caster = _target;
							_origin = _target;
							findTarget(this.x, this.y);
							return;
						} else 
							_element.dealDamage(_target, _caster, false,
								_damage * _caster.missileDamageModifier, _triggerEffects, this);
						stopMoving();
						if(_element == Element.ARCANE)
						{
							this.x = target.x;
							this.y = target.y;
						}
						this.explosion.gotoAndStop(2);
						return
					}
				}
			} else
			{
				if(_target != null)
					if(Model.distBetween(_target, this) < 8)
						stopMoving();
				this.explosion.nextFrame();
			}
			//Movement starts here
			if(_moving && _target != null)
				addForce( _curves ? 1.4 : 6, Model.toDegrees(Model.angleBetween(_target, this)));
			update();
			if(this.explosion.currentFrame>=5) //After the explosion, remove.
			{
				Model.notifier.stopRequest(this, 1);
				this.parent.removeChild(this);
				Model.missileVector.splice(Model.missileVector.indexOf(this),1);
			}
		}
		
		override public function stopMoving(): void {
			super.stopMoving();
			_moving = false;
		}
		
	}
	
}
