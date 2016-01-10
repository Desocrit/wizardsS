package AS.objects {
	
	import fl.motion.Color;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Enemy extends Actor {
		
		public static const ENEMY_GOBLIN: int = 0;
		public static const ENEMY_SHIELDER: int = 1;
		
		private var _type:Number;
		public var _range: int = 0;
		//Strafe - set all besides StrafeTime for invididual enemy types.
		public var StrafeFrequency: Number = 0.1, targetAngle: Number;
		public var StrafeAngle: int = 45, StrafeMaxTime: int = 28, StrafeTime:int = 0;
		//Recolouration
		private var _color: Color;
		
		public function Enemy(type:Number = 0) 
		{
			_type = type;
			var maxHP: int, ms: Number = 0.6, element = Element.DARKNESS;
			var red: int = 0, green: int = 0, blue: int = 0;
			switch(type){
				case ENEMY_GOBLIN:
					red = 102;
					green = 153;
					maxHP = 40;
					ms = 0.5;
					_range = 30;
					break;
				case ENEMY_SHIELDER:
					red = 102;
					green = 102;
					maxHP = 150;
					_range = 31;
					break;
				default:
					break;
			}
			super(maxHP, ms, element);
			Model.enemyVector.push(this);
			gotoAndStop(type + 2);
			body.gotoAndStop(type + 1);
			_color = new Color();
			targetAngle = Math.random() * 360;
			if(hp != maxHP)
				_color.brightness = (this.hp / this.maxHP) - 1;
			body.transform.colorTransform = _color;
		}
		
		override public function move(): void 
		{
			var targetX: Number = Model.player.x; + (10 * Math.cos(Model.toRads(targetAngle)));;
			var targetY: Number = Model.player.y; + (10 * Math.sin(Model.toRads(targetAngle)));;
			var dir = Model.toDegrees(Model.angleBetweenPts(targetX, this.x, targetY, this.y));
			if(Math.random()<StrafeFrequency)
				if(Math.random()<0.5)
					StrafeTime = int(Math.random()*StrafeMaxTime);
				else
					StrafeTime = -int(Math.random()*StrafeMaxTime);
			if(StrafeTime<0)
			{
				StrafeTime++;
				if(Model.distBetween(Model.player, this) < _range - 3)
					dir-=90;
				else
					dir-=StrafeAngle;
			}
			if(StrafeTime>0)
			{
				StrafeTime--;
				if(Model.distBetween(Model.player, this) < _range - 3)
					dir+=90;
				else
					dir+=StrafeAngle;
			}
			addForce(1,dir, true);
		}
		
		override public function takeDamage(damage: Number, source: MovieClip,
											damageSource: Actor, type: Element): void 
		{
			
			if(_type == Enemy.ENEMY_SHIELDER && (source == null || source is Shape ||
				Math.abs(Model.toDegrees(Model.angleBetween(source, this)) - rotation) > 90))
				damage *= 3;
			super.takeDamage(damage, source, damageSource, type);
			_color.brightness = (hp / maxHP) - 1;
			body.transform.colorTransform = _color;
		}
		
		override public function die(killer: Actor = null): void
		{
			Model.enemyVector.splice(Model.enemyVector.indexOf(this),1)
			super.die(killer);
		}
		
		override public function attack(): void 
		{
			if(_type!=3)
				physAttack();
			else
				missileAttack();
		}
		
		public function missileAttack() : void
		{
			weapon.nextFrame();
			if(weapon.currentFrame == weapon.totalFrames)
			{
				weapon.gotoAndStop(1);
				new Missile(element, this, Model.player.x, Model.player.y, 5, true, this, true);
				super.attack();
			}
		}
		
		public function physAttack(): void
		{
			if(Model.distBetween(Model.player, this) < _range)
				weapon.nextFrame();
			else
				weapon.gotoAndStop(1);
			if(weapon.currentFrame == weapon.totalFrames)
			{
				weapon.gotoAndStop(1);
				element.dealDamage(Model.player, this, false, 10, true, this);
				super.attack();
			}
		}

		public function get type():Number
		{
			return _type;
		}

		
	}
	
}
