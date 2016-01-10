package AS.objects
{
	import flash.display.MovieClip;

	public class Actor extends MovingObject implements Notifiable
	{
		private var _hp: Number, _maxHP:Number;
		private var _movementSpeed: Number = 1;
		private var _element: Element;
		private var _missileDamageModifier: Number = 1, _shapeDamageModifier: Number = 1;
		private var _damageDealtModifier: Number = 1, _damageTakenModifier: Number = 1;
		private var _attackSpeed: Number = 1, _vampirism: Number = 0;
		private var _stuns: int = 0, _roots: int = 0, _invulnerability: int = 0;
        protected var _reflecting: Boolean = false, _attackReady = true;
		private var _statusEffects: Vector.<StatusEffect> = new Vector.<StatusEffect>();
		//Buff MovieClips
		public var Berserk: MovieClip; //TEMP until I do the glyph.
		public var haste: MovieClip, regen: MovieClip, shield: MovieClip;
		//Debuff MovieClipsdw
		public var glyph: MovieClip, burn: MovieClip, roots: MovieClip, burst: MovieClip;
		public var freeze: MovieClip, bomb: MovieClip, poison: MovieClip, shock: MovieClip;
		//Model itself
		public var body: MovieClip, weapon: MovieClip
		
		
		
		public function Actor(maxHP: int, movementSpeed: Number, element: Element,
							  friction:Number = 0.2, velocity:Number = 0, velocityDirection: Number = 0) 
		{
			super(friction, velocity, velocityDirection);
			for(var i: int = 0; i < numChildren; i++)
				(getChildAt(i) as MovieClip).stop();
			_maxHP = maxHP;
			_hp = maxHP;
			_movementSpeed = movementSpeed;
			_element = element;
			Model.stage.addChildAt(this, 4);
			Model.notifier.requestUpdates(this, 1);
		}
		
		public function notify(ref: int): void
		{
			switch(ref)
			{
				case 0:
					_attackReady = true;
					break;
				case 1:
					if(alpha<1)
						alpha+=0.1;
					if(!stunned && !rooted){
						move();
						super.update();
					}
					if(!stunned)
						handleAttack();
					break;
			}
		}
		
		//Attack and move handling (Should be overridden as required)
		
		public function handleAttack(): void
		{
			if(_attackReady)
				attack();
		}
		
		public function attack(): void 
		{ 
			_attackReady = false;
			Model.notifier.requestNotification(this, 1000/attackSpeed,0);			
		}
		
		public function move(): void {} //To be overridden
		
		override public function addForce(strength:Number, direction:Number, slowable: Boolean = false): void 
		{
			if(!slowable && !rooted)
			{
				super.addForce(strength, direction);
				return;
			}
			if(!stunned && !rooted)
			{
				super.addForce(strength * movementSpeed, direction);
			}
		}
		
		//Damage handling
		/**
		 * Can be overridden.
		 */
		public function takeDamage(damage: Number, source: MovieClip, damageSource: Actor,
								   type: Element) : void 
		{
			if(!invulnerable)
			{
				damage *= damageTakenModifier * damageSource.damageDealtModifier;
				if(damageSource.vampirism != 0)
					damageSource.heal(vampirism * damage, damageSource);
				//trace("Taken " + damage + " damage from " + damageSource + "'s " + source);
				_hp -= damage;
				if(_hp <= 0)
					die(damageSource);
			}
		}
		
		/**
		 * SHOULD be overridden!
		 */
		public function die(killer: Actor = null): void
		{
			for (var i:int=0; i<_statusEffects.length; i++)
				_statusEffects[i--].removeEffect(StatusEffect.REMOVE_DEATH);
			Model.stage.removeChild(this);
			Model.notifier.stopRequest(this, 1);
			if(killer == Model.player)
				Model.player.addKill(this);
		}
		
		public function heal(healing: int, healingSource: Actor): void 
		{
			_hp += healing;
			if(_hp >=_maxHP)
				_hp = _maxHP;
		}
		
		public function healPercent(healing: Number, healingSource: Actor) : void 
		{
			_hp += healing * _maxHP;
			if(_hp >=_maxHP)
				_hp = _maxHP;
		}
		
		// StatusEffect handling
		
		public function addStatusEffect(type: int, caster: Actor, animation:MovieClip = null, damage: Number = 0):void 
		{
			if(hp <= 0) //Cannot add status effects to dead things. This should never be called, but just being safe.
				return;
			var previousEffect: StatusEffect = getStatusEffect(type);
			if(previousEffect)
			{	//IncreaseDuration defaults true for buffs, false for debuffs.
				var magnitudeIncrease: Number = 0;
				if(type == StatusEffect.DEBUFF_GLYPH && previousEffect.strength < 1.7)
					magnitudeIncrease = Element.ARCANE.hasUpgrade(1) ? 0.3 : 0.2;
				if(type == StatusEffect.BUFF_SNOWBALL && previousEffect.strength < 0.4)
					magnitudeIncrease = 0.02;
				if(type == StatusEffect.BUFF_DOMINANCE && previousEffect.strength < 0.6)
					magnitudeIncrease = 0.03;
				if(type == StatusEffect.DEBUFF_POISON)
					magnitudeIncrease = damage;
				previousEffect.refresh(magnitudeIncrease);
			} else 
				_statusEffects.push(new StatusEffect(type, this, caster, animation, damage)); 
		}
		
		public function hasStatusEffect(effectType: int): Boolean
		{
			for each (var effect: StatusEffect in _statusEffects)
				if(effect.type == effectType)
					return true;
			return false;
		}
		
		public function getStatusEffect(effectType: int): StatusEffect 
		{
			for each (var effect: StatusEffect in _statusEffects)
				if(effect.type == effectType)
					return effect;
			return null;
		}

		/**
		 * removeType should be 0 for ending duration, 1 for dispel, 2 for target death, 3 for other.
		 */
		public function removeStatusEffect(effect:StatusEffect, removeType: int):void 
		{
			effect.removeEffect(removeType);
		}
		
		/**
		 * removeType should be 0 for ending duration, 1 for dispel, 2 for target death, 3 for other.
		 */
		public function removeStatusType(removeType: int):void 
		{
			for each (var effect: StatusEffect in _statusEffects)
				if(effect.type == removeType)
					effect.removeEffect(removeType);
		}
		
		public function spliceStatusEffect(effect: StatusEffect)
		{
			_statusEffects.splice(_statusEffects.indexOf(effect),1); 
		}
		
		// Accessors
		//Basic Stats
		public function get percentageHP():Number 					{ return _hp/_maxHP; 			}
		public function get hp():int 								{ return _hp; 					}
		public function get maxHP():int 							{ return _maxHP; 				}
		public function set maxHP(value:int):void 					{ _maxHP = value; 				}	
		public function get element():Element						{ return _element;				}
		public function set element(value:Element):void				{ _element = value;				}
		public function get attackReady()							{ return _attackReady; 			}
		public function get attackSpeed():Number 					{ return _attackSpeed;			}			
		public function set attackSpeed(value:Number):void 			{ _attackSpeed = value; 		}		
		public function get movementSpeed():Number 					{ return _movementSpeed; 		}		
		public function set movementSpeed(value:Number):void 		{ _movementSpeed = value; 		}
		public function get vampirism():Number						{ return _vampirism; }
		public function set vampirism(value:Number):void			{ _vampirism = value; }
		//Modifiers
		public function get damageTakenModifier():Number 			{ return _damageTakenModifier; 	}
		public function set damageTakenModifier(value:Number):void 	{ _damageTakenModifier = value; }
		public function get missileDamageModifier():Number 			{ return _missileDamageModifier;}
		public function set missileDamageModifier(value:Number):void{ _missileDamageModifier = value;}	
		public function get shapeDamageModifier():Number 			{ return _shapeDamageModifier; 	}
		public function set shapeDamageModifier(value:Number):void 	{ _shapeDamageModifier = value; }	
		public function get damageDealtModifier():Number			{ return _damageDealtModifier; 	}
		public function set damageDealtModifier(value:Number):void 	{ _damageDealtModifier = value; }
		//Status Effects
		public function get statusEffects():Vector.<StatusEffect>	{ return _statusEffects;		}
		public function get stunned():Boolean 						{ return (_stuns > 0);  		}
		public function set stunned(value:Boolean):void 			{ _stuns += value ? 1 : -1; 	}
		public function removeAllStuns() : void 					{ _stuns = 0; 					}
		public function get rooted():Boolean 						{ return (_roots > 0) 			}
		public function set rooted(value:Boolean):void 				{ _roots += value ? 1 : -1; 	}
		public function removeAllRoots() : void 					{ _roots = 0; 					}
		public function get invulnerable():Boolean 					{ return (_invulnerability > 0) }
		public function set invulnerable(value:Boolean):void 		{ _invulnerability+=value?1:-1; }
		public function makeVulnerable() : void 					{ _invulnerability = 0; 		}
		public function get reflecting():Boolean 					{ return _reflecting; 			}
		public function set reflecting(value:Boolean):void 			{ _reflecting = value; 			}		


	}
}