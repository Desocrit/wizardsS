package AS.objects
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Dummy extends MovieClip implements Notifiable
	{
		/**
		 * The number of the static constant representing this dummy.
		 **/
		private var _type:Number;
		// AoE that tracks targets
		/**
		 * Explosion that damages everything affected, possible also burning it.
		 * @see Element#TYPE_FIRE
		 **/
		public static const TYPE_FIRE_EXPLOSION = 0;
		/**
		 * Lava pit that damages, and possibly burns foes within.
		 * @see Element#TYPE_FIRE
		 **/
		public static const TYPE_LAVA_PIT = 1;
		/**
		 * Shockwave that knocks back anything that hits it.
		 * @see Element#TYPE_AIR, Spell#SPELL_HEAL
		 **/
		public static const TYPE_SHOCKWAVE = 2;
		/**
		 * Ice explosion that slows everything it hits.
		 * @see Element#TYPE_ICE
		 **/
		public static const TYPE_ICE_EXPLOSION = 3
		/**
		 * Explosion after a target dies with a bomb on them. May spread the bomb.
		 * @see Element#TYPE_SHADOW
		 **/
		public static const TYPE_SHADOW_EXPLOSION = 4;
		/**
		 * Arcane explosion that deals no damage, but passes the glyph.
		 * @see Element#TYPE_ARCANE
		 **/
		public static const TYPE_ARCANE_EXPLOSION = 5;
		/**
		 * Poison explosion that poisons anything that it hits.
		 * @see Element#TYPE_POISON
		 **/
		public static const TYPE_POISON_EXPLOSION = 6;
		//None-tracking AoE		
		/**
		 * Tornado that sucks nearby targets in, then fires them out.
		 * @see Element#TYPE_AIR
		 **/
		public static const TYPE_TORNADO = 10;
		/**
		 * Thunderstorm that randomly shocks targets within it.
		 * @see Element#TYPE_THUNDER
		 **/
		public static const TYPE_THUNDERSTORM = 11;
		/**
		 * Black hole that sucks in nearby targets.
		 * @see Element#TYPE_SHADOW
		 **/
		public static const TYPE_BLACK_HOLE = 12;
		
		/**
		 * Earthquake that damages and roots targets within.
		 * @see Element#TYPE_EARTH
		 **/
		public static const TYPE_EARTHQUAKE = 13;
		/**
		 * Holy ground that heals anything within it.
		 * @see Spell#SPELL_HOLY_GROUND
		 **/
		public static const TYPE_HOLY_GROUND = 14;
		//None-AoE
		/**
		 * Mine that damages and applies the glyph debuff to targets that touch it.
		 * @see Element#TYPE_ARCANE
		 **/
		public static const TYPE_MINE = 20;
		/**
		 * Small heal animation that triggers after healing.
		 * @see Spell#SPELL_HEAL
		 **/
		public static const TYPE_HEAL_EFFECT = 21;
		/**
		 * Dummy actor that fades out after teleport is cast.
		 * @see Spell#SPELL_TELEPORT
		 **/
		public static const TYPE_BLINK_EFFECT = 22;
		/**
		 * Turret that fires at nearby enemies using the player's active attack and upgrades.
		 * @see Spell#SPELL_TURRET
		 **/
		public static const TYPE_TURRET = 23;
		
		/**
		 * Dummy is removed after this duration.
		 **/
		private var _duration:Number;
		/**
		 * Not always relevant
		 **/
		private var _damage:Number;
		/**
		 * Original creater of the effect.
		 **/
		private var _caster: Actor;
		/**
		 * The sub-MovieClip that controls the graphics of this object.
		 **/
		public var graphic:MovieClip;
		/**
		 * Enemies already hit by this effect. Used for persistent AoE effects.
		 **/
		private var _targetsHit:Vector.<Actor>;
		
		public function Dummy(type: Number, caster: Actor, duration: Number, damage: Number = 0,
							  origin: MovieClip = null, x : int = 999, y: int = 999) 
		{
			super();
			_type = type;
			_damage = damage;
			_caster = caster;
			_duration = duration;
			if((_duration % 40) != 0)
				_duration += 40 - (duration % 40);
			if(_type<=5)
				alpha = 0.6;
			if(_type<=3)
				alpha = 0.1;
			if(_type<= TYPE_POISON_EXPLOSION)
				_targetsHit = new Vector.<Actor>();
			if(origin!=null)
			{
				this.x = origin.x;
				this.y = origin.y;
				if(_targetsHit != null && origin is Actor)
					_targetsHit.push(origin);
			} else
			{
				if(x!=999)
					this.x = x;
				if(y!=999)
					this.y = y;
			}
			if(_type == TYPE_SHADOW_EXPLOSION && Element.SHADOW.hasUpgrade(1)){
				this.scaleX *= 1.8;
				this.scaleY *= 1.8;
			}
			if([TYPE_LAVA_PIT,TYPE_EARTHQUAKE,TYPE_MINE,TYPE_HOLY_GROUND].indexOf(type)!=-1)
				Model.stage.addChildAt(this, 3);
			else
				Model.stage.addChildAt(this,Model.stage.numChildren - 1);
			if(_type == TYPE_TURRET && Model.getTargetArray(_caster).length != 0)
				this.rotation = Model.toDegrees(Model.angleBetween(
					Model.getClosestActor(this.x, this.y, _caster), this));
			Model.dummyVector.push(this);
			gotoAndStop(_type + 1);
			if(_type != TYPE_TURRET)
				graphic.stop();
			else
				if(Spell.TURRET.hasUpgrade(1))
					graphic.gotoAndStop(9);
				else
					graphic.gotoAndStop(Model.player.element.type + 1);
			Model.notifier.requestUpdates(this, 1);
		}
		
		//TODO: Use nextFrame, change all enemy movements to use force
		public function notify(ref: int): void
		{
			_duration-=40;
			if(_type != TYPE_TURRET)
				if(graphic.currentFrame == graphic.totalFrames)
					graphic.gotoAndStop(1);
				else
					graphic.nextFrame();
			if(this.alpha < 1 && _duration > 120)
				this.alpha += 0.1; //Fade in
			if(_duration <= 120)
				this.alpha -= 0.3; //And out
			//Types
			if(_type <= TYPE_HOLY_GROUND && (_type!=TYPE_LAVA_PIT || _duration % 480 == 0)  &&
											(_type!=TYPE_HOLY_GROUND || _duration % 1000 == 0)) //AoE effects
			{ 
				for each(var target: Actor in ((_type != TYPE_HOLY_GROUND) ? Model.getTargetArray(_caster) :
																			 Model.getFriendlyArray(_caster)))
				{
					var dist: int = Model.distBetween(this, target);
					switch(_type)
					{
						case TYPE_TORNADO:
							if(dist > 5 && dist < 43)
								target.addForce(4, Model.toDegrees(Model.angleBetween(this, target)));
							if(_duration==0 && dist < 43)
								Element.AIR.dealDamage(target, _caster, false,_damage, false, this);
							break;
						case TYPE_THUNDERSTORM:
							if(dist<40&&Math.random()<0.02)
								new Missile(Element.THUNDER, _caster, target.x,target.y,_damage,true, this);
							break;
						case TYPE_BLACK_HOLE:
							if(dist > 8 && dist < 60)
							{
								target.stopMoving();
								target.addForce(5, Model.toDegrees(Model.angleBetween(this, target)));
							}
							break;
						case TYPE_LAVA_PIT:
							if(dist < 35)
							{
								if(Element.FIRE.hasUpgrade(3) && _targetsHit.length == 0)
									new Dummy(Dummy.TYPE_FIRE_EXPLOSION, _caster, 200, _damage, target);
								Element.FIRE.dealDamage(target, _caster, true, _damage, false, this);
								_targetsHit.push(target);
							}
							break;
						case TYPE_EARTHQUAKE:
							if(dist < 40 && Math.random() < 0.025)
								Element.EARTH.dealDamage(target, _caster, false, _damage, false, this);
							break;
						case TYPE_FIRE_EXPLOSION:
							if(dist < 25 && _targetsHit.indexOf(target) == -1)
							{
								Element.FIRE.dealDamage(target, _caster, false, _damage, false, this);
								_targetsHit.push(target);
							}
							break;
						case TYPE_SHOCKWAVE:
							if(dist<47.5 && _targetsHit.indexOf(target) == -1)
							{
								target.addForce(Element.AIR.hasUpgrade(1)? 16 : 10,
									Model.toDegrees(Model.angleBetween(target, this)));
								_targetsHit.push(target);
							}
							break
						case TYPE_ICE_EXPLOSION:
							if(dist < 45)
							{
								target.addStatusEffect(StatusEffect.DEBUFF_SLOW, _caster, target.freeze, 0);
							}
							break;
						case TYPE_SHADOW_EXPLOSION:
							if(Element.SHADOW.hasUpgrade(1))
								dist*=0.56;
							if(dist < 45)
								if(_targetsHit.indexOf(target) == -1)
								{
									Element.SHADOW.dealDamage(target, _caster, false, _damage, false, this);
									_targetsHit.push(target);
								}
							break;
						case TYPE_ARCANE_EXPLOSION:
							if(dist < 40 && _targetsHit.indexOf(target) == -1)
							{
								_targetsHit.push(target);
								target.addStatusEffect(StatusEffect.DEBUFF_GLYPH,_caster,target.glyph,
									Element.ARCANE.hasUpgrade(1) ? 1.3 : 1.2);
							}
							break;
						case TYPE_POISON_EXPLOSION:
							if(dist < 34 && _targetsHit.indexOf(target) == -1)
							{
								_targetsHit.push(target);
								target.addStatusEffect(StatusEffect.DEBUFF_POISON, _caster, target.poison, _damage);
							}
							break;
						case TYPE_HOLY_GROUND:
							if(dist < 35)
								target.healPercent(0.2, _caster);
							break;
						default:
							break;
					}
				}
			} else
			{
				switch(_type)
				{
					case TYPE_MINE:
						if(graphic.currentFrame==20)
						{
							new Missile(Element.ARCANE, _caster, this.x, this.y, _damage,
								false, this, false, 5000).stopMoving();
							_duration = 0;
						}
						break;
					case TYPE_HEAL_EFFECT:
						if(graphic.currentFrame < 10){
							Model.stage.addChild(this);
							this.x = _caster.x;
							this.y = _caster.y;
						}
						break;
					case TYPE_TURRET:
						if(Model.getTargetArray(_caster).length == 0)
							return;
						//TODO: Turn
						var intendedAngle: int = Model.toDegrees(Model.angleBetween(
							Model.getClosestActor(this.x, this.y, _caster), this));
						if(Math.abs(this.rotation - intendedAngle) < 20)
							this.rotation = intendedAngle;
						else
							if((intendedAngle > this.rotation && Math.abs(intendedAngle - this.rotation) < 180) ||
							   (intendedAngle < this.rotation && Math.abs(intendedAngle - this.rotation) > 180)) 
								this.rotation += 20;
							else
								this.rotation -= 20;
						//Fire
						if(_duration % (1000 / Model.player.attackSpeed) < 40)
							if(Spell.TURRET.hasUpgrade(1))
							{
								var firingElement: Element = Element.CHAOS;
								graphic.head.gotoAndStop(firingElement.type + 1);
								new Missile(firingElement, Model.player,
									this.x + 5 * Math.sin(Model.toRads(this.rotation)),
									this.y - 5 * Math.cos(Model.toRads(this.rotation)), 13, true, this);
							}
							else
								new Missile(Model.player.element, Model.player,
									this.x + 5 * Math.sin(Model.toRads(this.rotation)),
									this.y - 5 * Math.cos(Model.toRads(this.rotation)), 10, true, this);
						//TODO: Cast shapes
						
						break;
				}
			}
			//Splice and Remove
			if(_duration<=0)
			{
				Model.dummyVector.splice(Model.dummyVector.indexOf(this),1);
				this.parent.removeChild(this);
				Model.notifier.stopRequest(this, 1);
			}
			if(_type == TYPE_HOLY_GROUND && Spell.HOLY_GROUND.hasUpgrade(1) && _duration % 1000 == 0)
				new Dummy(Dummy.TYPE_SHOCKWAVE, _caster, 600, 0, this);
		}//End of EnterFrame

		public function get type():Number 	{	return _type;	}

	}
}