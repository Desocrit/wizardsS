package AS.objects
{
	
	import flash.display.MovieClip;
	import AS.gems.BasicGem;

	public class StatusEffect implements Notifiable
	{
		/** 0-9 buffs, 10-19 debuffs **/
		private var _type:int;
		/**
		 * Movement Speed is increased from the Haste spell @see Spell#SPELL_HASTE
		 **/
		public static const BUFF_HASTE: int = 0;
		/**
		 * Movement Speed is increased by the Teleport spell @see Spell#SPELL_TELEPORT
		 **/
		public static const BUFF_TELEPORT: int = 1;
		/**
		 * Caster knocks foes back while charging. @see Spell#SPELL_RUSH
		 **/
		public static const BUFF_BULL_RUSH: int = 2;
		/**
		 * Caster is shielded. @see Spell#SPELL_SHIELD
		 **/
		public static const BUFF_SHIELD: int = 3;
		/**
		 * Caster reflects the next hit. @see Spell#SPELL_REFLECT
		 **/
		public static const BUFF_REFLECT: int = 4;
		/**
		 * Caster attacks significantly faster. @see Spell#SPELL_BURST
		 **/
		public static const BUFF_BURST: int = 5;
		/**
		 * Regenerates health. @see Spell#SPELL_BURST
		 **/
		public static const BUFF_REGENERATE: int = 6;
		/**
		 * Increases all damage done by 50%. @see Spell#SPELL_TIME_STOP
		 **/
		public static const BUFF_TIME_STOP: int = 7;
		/**
		 * Increases movement speed by 2.5% per second up to 25%
		 **/
		public static const BUFF_STRUT: int = 8;
		/**
		 * Increases attack speed by 4% per 1% of health lost.
		 **/
		public static const BUFF_DESPERATION: int = 9;
		/**
		 * Grants 2% damage per kill, up to 40%.
		 **/
		public static const BUFF_SNOWBALL:int = 10;
		/**
		 * Grants 30% increased damage for 4 seconds.
		 **/
		public static const BUFF_CONSISTENCY: int = 11;
		/**
		 * Grants 30% damage reduction for 10 seconds.
		 **/
		public static const BUFF_PROTECTION: int = 12;
		/**
		 * Grants 5% increased damage per shape on cooldown.
		 **/
		public static const BUFF_BLOWOUT: int = 13;
		/**
		 * Grants 3% damage per kill, up to 60%.
		 **/
		public static const BUFF_DOMINANCE:int = 14;
		/**
		 * Burns the target for damage every 1 second for 3 seconds. @see Element#TYPE_FIRE
		 **/
		public static const DEBUFF_BURN: int = 100;
		/**
		 * Roots the target in place. @see Element#TYPE_EARTH
		 **/
		public static const DEBUFF_ROOT: int = 101;
		/**
		 * Slows the target's  movement speed. @see Element#TYPE_FROST
		 **/
		public static const DEBUFF_SLOW: int = 102;
		/**
		 * Stuns the target for half a second. @see Element#TYPE_ELECTRIC
		 **/
		public static const DEBUFF_STAGGER: int = 103;
		/**
		 * Causes the target to explode when killed. @see Element#TYPE_SHADOW
		 **/
		public static const DEBUFF_BOMB: int = 104;
		/**
		 * Increases damage taken by the target. @see Element#TYPE_ARCANE
		 **/
		public static const DEBUFF_GLYPH: int = 105;
		/**
		 * Poisons the target. Stacks damage, but refeshes duration. @see Element#TYPE_POISON
		 **/
		public static const DEBUFF_POISON: int = 106;
		/**
		 * Player is not moving. May grant 30% damage, @see BasicGem#BASIC_NOT_MOVING
		 **/
		public static const STATE_NOT_MOVING: int = 200;
		/**
		 * Player is moving. May grant 25% attack speed. @see BasicGem#BASIC_NOT_MOVING
		 **/
		public static const STATE_MOVING: int = 201;
		
		/**
		 * Debuff ran out naturally. Used for .remove().
		 * Triggers ending effects.
		 **/
		public static const REMOVE_END: int = 0;
		/**
		 * Debuff was removed by dispelling.
		 * Triggers dispel effects.
		 **/
		public static const REMOVE_DISPEL: int = 1;
		/**
		 * Debuff was removed by the target's death. Used for .remove().
		 * Triggers death effects.
		 **/
		public static const REMOVE_DEATH: int = 2;

		/**
		 * Debuff was internally removed for modify. Used for .remove(). 
		 * Does not affect notifiers or splice.
		 **/
		private static const REMOVE_MODIFY: int = 3;
		/**
		 * Debuff was internally removed for refresh. Used for .remove(). 
		 * Does not splice.
		 **/
		private static const REMOVE_REFRESH: int = 4;		
		
		/** The notifier.time() when this buff was applied. **/
		private var _timeApplied: int;
		/** Which object is affected by the status effect **/
		private var _affectedObject: Actor;
		/** Which object caused the status effect **/
		private var _caster : Actor;
		/** Use real time, so increments of 40.  **/
		private var _duration : int;
		/** Animation flag to set/unset for this effect. Sets to frame 2, resets frame 1 **/
		private var _animation : MovieClip;
		private var _magnitude : Number;
		/** Probably unused. For use in some functions. **/
		private var _calculation : Number;
			
		//TODO: Drastically change this. Implement Spell
		public function StatusEffect(type: int, affectedObject: Actor, caster: Actor,
									 animation:MovieClip = null, damage: Number = 0)
		{
			_type = type;
			_affectedObject = affectedObject;
			_duration = getDuration();
			_animation = animation;
			_magnitude = damage;
			_caster = caster;
			applyEffect();
		}
		
		private function applyEffect(updateNotifiers: Boolean = true): void
		{
			if(updateNotifiers)
			{
				if(_animation != null)
				{
					_animation.gotoAndStop(2);
				}
				_timeApplied = Model.notifier.time;
				Model.notifier.requestNotification(this,_duration,0);
			}
			switch(type)
			{
				case BUFF_HASTE:
					_magnitude = Spell.HASTE.hasUpgrade(1) ? 1.8 : 1.5;
					_affectedObject.movementSpeed *= _magnitude;
					break;
				case BUFF_TELEPORT:
					_magnitude = 1.5;
					_affectedObject.movementSpeed *= _magnitude;
					break;
				case BUFF_BULL_RUSH:
					Model.notifier.requestNotification(this, 40, 1, 10, 40);
					break;
				case BUFF_SHIELD:
					_affectedObject.invulnerable = true;
					if(updateNotifiers && Spell.SHIELD.hasUpgrade(2))
						Model.notifier.requestNotification(this,500,1, _duration/1000,1000);
					break;
				case BUFF_REFLECT:
					_affectedObject.reflecting = true;
					break;
				case BUFF_BURST:
					_magnitude = Spell.BURST.hasUpgrade(1) ? 3: 1;
					_calculation = Spell.BURST.hasUpgrade(2) ? 1: 0;
					if(_calculation == 0)
						_affectedObject.attackSpeed += _magnitude;
					else
						_affectedObject.damageDealtModifier += _magnitude;
					break;
				case BUFF_REGENERATE:
					if(updateNotifiers)
						Model.notifier.requestNotification(this, 500, 1, _duration/1000, 1000);
					break;
				case BUFF_TIME_STOP:
					_affectedObject.damageDealtModifier += 0.5;
					break;
				case BUFF_STRUT:
					_magnitude = 1;
				case BUFF_BLOWOUT:
				case BUFF_DESPERATION:
					Model.notifier.requestNotification(this, 1000, 1, 999999);
					break;
				case BUFF_CONSISTENCY:
					_affectedObject.damageDealtModifier += 0.3;
					break;
				case BUFF_SNOWBALL:
					_affectedObject.damageDealtModifier += _magnitude;
					break;
				case BUFF_DOMINANCE:
					_affectedObject.attackSpeed += _magnitude;
					break;
				case BUFF_PROTECTION:
					_affectedObject.damageTakenModifier -= 0.3;
					break;
				case DEBUFF_BURN:
					if(updateNotifiers)
						Model.notifier.requestNotification(this, 500, 1, _duration/1000, 1000);
					break;
				case DEBUFF_ROOT:
					if(Element.EARTH.hasUpgrade(2))
					{
						_magnitude = 1;
						_affectedObject.stunned = true;
					} else 
						_affectedObject.rooted = true;
					break;
				case DEBUFF_SLOW:
					_magnitude = Element.FROST.hasUpgrade(1) ? 0.2 : 0.4;
					_affectedObject.movementSpeed *= _magnitude;
					_calculation = Element.FROST.hasUpgrade(3) ? 0.4 : 0;
					_affectedObject.damageTakenModifier += _calculation;
					break;
				case DEBUFF_STAGGER:
					_affectedObject.stunned = true;
					break;
				case DEBUFF_GLYPH:
					_affectedObject.damageTakenModifier += _magnitude;
					break;
				case DEBUFF_POISON:
					Model.notifier.requestNotification(this,  500, 1, _duration/1000, 1000);
					_calculation = Element.POISON.hasUpgrade(3) ? 1 : 0;
					if(_calculation)
						_affectedObject.movementSpeed *= 0.7;
					break;
				case STATE_MOVING:
					if(BasicGem.ATS_WHILE_MOVING.active)
						_magnitude = 0.25;
					_affectedObject.attackSpeed += _magnitude;
					_affectedObject.removeStatusType(StatusEffect.STATE_NOT_MOVING); //To prevent paradoxes.
					break;
				case STATE_NOT_MOVING:
					if(BasicGem.NOT_MOVING.active)
						_magnitude = 0.4;
					_affectedObject.damageDealtModifier += _magnitude;
					break;
				default:
					break;
			}
		}
		
		/**
		 * removeType should be 0 for ending duration, 1 for dispel, 2 for target death, 3 for reset.
		 */
		public function removeEffect(removeType:int = 0):void 
		{
			if(removeType != REMOVE_END)
				Model.notifier.stopRequest(this, 0);
			if(removeType != REMOVE_MODIFY)
			{
				if(_animation!=null)
					_animation.gotoAndStop(1);
				if(removeType!=0)
					Model.notifier.stopRequest(this, 1);
				if(removeType != REMOVE_REFRESH)
				_affectedObject.spliceStatusEffect(this);
			}
			switch(type)
			{
				case BUFF_HASTE:
					_affectedObject.movementSpeed /= _magnitude;
					break;
				case BUFF_TELEPORT:
					_affectedObject.movementSpeed /= _magnitude;
					break;
				case BUFF_SHIELD:
					_affectedObject.invulnerable = false;
					break;
				case BUFF_REFLECT:
					_affectedObject.reflecting = false;
					break;
				case BUFF_BURST:
					if(_calculation == 0)
						_affectedObject.attackSpeed -= _magnitude;
					else
						_affectedObject.damageDealtModifier -= _magnitude;
					break;
				case BUFF_TIME_STOP:
					_affectedObject.damageDealtModifier -= 0.5;
					break;
				case BUFF_STRUT:
					_affectedObject.movementSpeed /= _magnitude;
					break;
				case BUFF_DESPERATION:
					_affectedObject.attackSpeed -= _magnitude;
					break;
				case BUFF_BLOWOUT:
					_affectedObject.damageDealtModifier -= _magnitude;
					break;
				case BUFF_CONSISTENCY:
					_affectedObject.damageDealtModifier -= 0.3;
					break;
				case BUFF_SNOWBALL:
					_affectedObject.damageDealtModifier -= _magnitude;
					break;
				case BUFF_PROTECTION:
					_affectedObject.damageTakenModifier += 0.3;
					break;
				case BUFF_DOMINANCE:
					_affectedObject.attackSpeed -= _magnitude;
					break;
				case DEBUFF_ROOT:
					if(_magnitude == 1)
						_affectedObject.stunned = false;
					else
						_affectedObject.rooted = false;
					break;
				case DEBUFF_SLOW:
					_affectedObject.movementSpeed /= _magnitude;
					_affectedObject.damageTakenModifier -= _calculation;
					break;
				case DEBUFF_STAGGER:
					_affectedObject.stunned = false;
					break;
				case DEBUFF_BOMB:
					if(removeType == REMOVE_DEATH)
					{   //Overflow - no more than 4 explosions can occur at once.
						var explosionCount: int = 0;
						for each (var d: Dummy in Model.dummyVector)
							if(d.type == Dummy.TYPE_SHADOW_EXPLOSION)
								explosionCount ++;
						if(explosionCount <= 3)
						new Dummy(Dummy.TYPE_SHADOW_EXPLOSION, _caster, 320,_magnitude,_affectedObject);
					}
					break;
				case DEBUFF_GLYPH:
					_affectedObject.damageTakenModifier -= _magnitude;
					break;
				case DEBUFF_POISON:
					if(_calculation)
						_affectedObject.movementSpeed /= 0.7;
					break;
				case STATE_MOVING:
					_affectedObject.addStatusEffect(StatusEffect.STATE_NOT_MOVING, _affectedObject);
					_affectedObject.attackSpeed -= _magnitude;
					break;
				case STATE_NOT_MOVING:
					_affectedObject.damageDealtModifier -= _magnitude;
					break;
				default:
					break;					
			}
		}
		
		public function tick()
		{
			switch(type)
			{
				case BUFF_BULL_RUSH:
					new Dummy(Dummy.TYPE_SHOCKWAVE, _affectedObject, 160,0,_affectedObject);
					break;
				case BUFF_REGENERATE:
					if(Math.random() < 0.05 && Spell.REGENERATE.hasUpgrade(2))
						Model.shapes[int(Math.random() * 4)].resetCooldown();
				case BUFF_SHIELD:
					_affectedObject.healPercent(0.05,_caster);
					break;
				case BUFF_STRUT:
					if(_magnitude < 1.25){
						_affectedObject.movementSpeed /= _magnitude;
						_magnitude += 0.025;
						_affectedObject.movementSpeed *= _magnitude;
					}
					break;
				case BUFF_DESPERATION:
					_affectedObject.attackSpeed -= _magnitude;
					_magnitude = (1 - _affectedObject.percentageHP) * 0.4;
					_affectedObject.attackSpeed += _magnitude;
					break;
				case BUFF_BLOWOUT:
					_affectedObject.damageDealtModifier -= _magnitude;
					_magnitude = 0.06 * (4 -Model.numShapesReady());
					_affectedObject.damageDealtModifier += _magnitude;
					break;
				case DEBUFF_BURN:
					Element.FIRE.dealDamage(_affectedObject, _caster, false, _magnitude, false);
					break;
				case DEBUFF_POISON:
					Element.POISON.dealDamage(_affectedObject, _caster, false, _magnitude, false);
					break;
				default:
					break;
			}
		}
		
		private function getDuration(): int
		{
			switch(type)
			{
				case BUFF_TELEPORT:
					return 3000;
				case BUFF_BULL_RUSH:
					return 400;
				case BUFF_REFLECT:
					return (Spell.REFLECT.hasUpgrade(1) ? 1000 : 3000);
				case BUFF_TIME_STOP:
					return 2000; //Time stop duration is automatically added.
				case BUFF_SHIELD:
				case BUFF_TELEPORT:
				case DEBUFF_BURN:
					return 3000;
				case BUFF_BURST:
					return (Spell.BURST.hasUpgrade(1) ? 3000 : 5000);
				case BUFF_REGENERATE:
					return (Spell.REGENERATE.hasUpgrade(1) ? 20000 : 12000);
				case BUFF_CONSISTENCY:
					return 4000;
				case DEBUFF_ROOT:
					return(Element.EARTH.hasUpgrade(1) ? 1000 : 600);
				case DEBUFF_SLOW:
					return 1200;
				case DEBUFF_STAGGER:
					return 500;
				case DEBUFF_BOMB:
				case BUFF_PROTECTION:
				case BUFF_SNOWBALL:
				case BUFF_HASTE:
					return 10000;
				case DEBUFF_GLYPH:
				case DEBUFF_BOMB:
					return 5000;
				case DEBUFF_POISON:
					return (Element.POISON.hasUpgrade(1) ? 100000000 : 10000);
				case STATE_MOVING:
					return 1000;
				case BUFF_STRUT:
				case BUFF_BLOWOUT:
				case BUFF_DESPERATION:
				case STATE_NOT_MOVING:
					return 99999999;
				default:
					return 9999999;
			}
		}
		
		public function set effectRunning(value: Boolean): void
		{
			if(_animation == null)
				return;
			if(value)
				_animation.effect.play();
			else
				_animation.effect.stop();
		}
		
		public function notify(reference: int): void 
		{
			if(reference==0)
				removeEffect(REMOVE_END);
			if(reference==1)
				tick();
		}
		
		public function dispel(): void 
		{
			_affectedObject.removeStatusEffect(this, REMOVE_DISPEL); 	
		}
		
		public function refresh(magnitudeIncrease: Number = 0): void
		{
			removeEffect(REMOVE_REFRESH);
			if(_type == DEBUFF_POISON && !Element.POISON.hasUpgrade(1))	
				_magnitude = magnitudeIncrease + 
					(_magnitude * (( _timeApplied - Model.notifier.time + _duration) / _duration));	
			else
				_magnitude += magnitudeIncrease;
			_duration =  (_type < DEBUFF_BURN) ? getDuration() + _duration - Model.notifier.time + _timeApplied :
												  getDuration();
			applyEffect(true);
		}
		
		public function set strength(value:Number):void 
		{
			removeEffect(REMOVE_MODIFY);
			Model.notifier.stopRequest(this,1);
			_magnitude = value;
			applyEffect(false);	
		}
		
		public function get type():int 					{ return _type;			}
		public function get strength():Number 			{ return _magnitude; 	} 
		
	}
}