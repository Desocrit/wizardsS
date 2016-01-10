package AS.gems
{
	
	import AS.objects.Model;
	import AS.objects.StatusEffect;
	
	//Taric quote goes here.
	public class BasicGem implements Gem
	{
		/**
		 * A number representing the type of gem. To be compared to static constants.
		 **/
		private var _type: int;
		/** Gem of Dashing - Increases the damage dealt by missiles by 20%. **/
		public static const BASIC_MISSILE_DAMAGE: int = 0;
		/** Berserk Gem - Increases autoattack speed by 20%. **/
		public static const BASIC_ATTACK_SPEED: int = 1;
		/** Gem of Elemental Fury - Increases damage dealt by Shapes by 20%. **/
		public static const BASIC_SHAPE_DAMAGE: int = 2;
		/** Gem of Extension - Increases the range of all Shapes by 20%. **/
		public static const BASIC_SHAPE_SIZE: int = 3;
		/** Gem of Speed - Increases base movement speed by 15%. **/
		public static const BASIC_MOVEMENT_SPEED: int = 4;
		/** Gem of Health - Increases maximum health by 20. **/
		public static const BASIC_HEALTH: int = 5;
		/** Gem of Defense - Reduces damage taken by 15%. **/
		public static const BASIC_DEFENSE: int = 6;
		/** Gem of Refreshment - Reduces the cooldown of all Shapes by 15%. **/
		public static const BASIC_SHAPE_COOLDOWN: int = 7;
		/** Gem of Casting - Reduces the cooldown of all Spells by 15%. **/
		public static const BASIC_SPELL_COOLDOWN: int = 8;
		/** Gem of Vampirism - Restores 2.5% of the the wizard's health per kill. **/
		public static const BASIC_VAMPIRISM: int = 9;
		/** Daredevil Gem - Grants 40% damage increase when you have not moved for at least 1 second. **/
		public static const BASIC_NOT_MOVING: int = 10;
		/** Desperate Gem - Grants 4% attack speed per 1% health lost. **/
		public static const BASIC_DESPERATE_ATTACK_SPEED: int = 11;
		/** Gem of Consistency - Increases the duration of Wall and Ring effects by 50%. **/
		public static const BASIC_SHAPE_DURATION: int = 12;
		/** Gem of Relentlessness - Dealing damage grants 2% increased damage for 10 seconds, up to 40%. **/
		public static const BASIC_SNOWBALL_DAMAGE: int = 13;
		/** Consistent Gem - Casting a Shape grants 30% damage for 4 seconds. **/
		public static const BASIC_DAMAGE_AFTER_SHAPE: int = 14;
		/** Protective Gem - Reduces damage taken by 30% for 10 seconds after casting Heal. **/
		public static const BASIC_DEFENSE_AFTER_HEAL: int = 15;
		/** Evasive Gem - Increases movement speed by 2.5% per second up to 25%, resets when hit. **/
		public static const BASIC_STRUT: int = 16;
		/** Gem of Flowing - Increases attack speed by 25% while moving. **/
		public static const BASIC_ATS_WHILE_MOVING: int = 17;
		/** Blowout Gem - Increases damage dealt by 6% per Shape on cooldown. **/
		public static const BASIC_BLOWOUT: int = 18;
		/** Gem of Fear - Casting a defensive skill reduces the cooldown of healing spells by 25%. **/
		public static const BASIC_HEAL_CD: int = 19;
		
		private var _owned: Boolean = false, _active: Boolean = false;
		private var _name: String, _description: String;
		private static var _vector: Vector.<BasicGem>;
		
		/**
		 * PRIVATE CONSTRUCTOR. Cannot and should not be externally instantiated.
		 **/
		public function BasicGem(type: int, name: String, description: String, doNotInstantiate: Lock)
		{
			_type = type;
			_name = name;
			_description = description;
		}
		
		/**
		 * Instantiates the class, allowing elemental accessors to be used. 
		 * This should be called as early as possible, and must be called before any accessors are used.
		 **/
		public static function init(): void
		{
			var key: Lock = new Lock();
			_vector = Vector.<BasicGem>([
				new BasicGem(0, "Gem of Dashing",
					"Increases the damage dealt by missiles by 20%.", key),
				new BasicGem(1, "Berserk Gem",
					"Increases autoattack speed by 20%.", key),
				new BasicGem(2, "Gem of Elemental Fury",
					"Increases damage dealt by Shapes by 20%.", key),
				new BasicGem(3, "Gem of Extension",
					"Increases the range of all Shapes by 20%.", key),
				new BasicGem(4, "Gem of Speed",
					"Increases base movement speed by 15%.", key),
				new BasicGem(5, "Gem of Health",
					"Increases maximum health by 20.", key),
				new BasicGem(6, "Gem of Defense",
					"Reduces damage taken by 15%.", key),
				new BasicGem(7, "Gem of Refreshment",
					"Reduces the cooldown of all Shapes by 15%.", key),
				new BasicGem(8, "Gem of Casting",
					"Reduces the cooldown of all Spells by 15%.", key),
				new BasicGem(9, "Gem of Vampirism",
					"Restores 2.5% of the the wizard's health per kill.", key),
				new BasicGem(10, "Daredevil Gem",
					"Grants 40% damage increase when you have not moved for at least 1 second.", key),
				new BasicGem(11, "Desperate Gem",
					"Grants 4% attack speed per 1% health lost.", key),
				new BasicGem(12, "Gem of Consistency",
					"Increases the duration of Wall and Ring effects by 50%.", key),
				new BasicGem(13, "Gem of Relentlessness",
					"Dealing damage grants 2% increased damage for 10 seconds, up to 40%.", key),
				new BasicGem(14, "Consistent Gem",
					"Casting a Shape grants 30% damage for 4 seconds.", key),
				new BasicGem(15, "Protective Gem",
					"Reduces damage taken by 30% for 10 seconds after casting Heal.", key),
				new BasicGem(16, "Evasive Gem",
					"Increases movement speed by 2.5% per second up to 25%, resets when hit.", key),
				new BasicGem(17, "Gem of Flowing",
					"Increases attack speed by 25% while moving.", key),
				new BasicGem(18, "Blowout Gem",
					"Increases damage dealt by 6% per Shape on cooldown.", key),
				new BasicGem(19, "Gem of Fear",
					"Casting a defensive skill reduces the cooldown of healing spells by 25%.", key)])
		}
		
		
		public function set active(value:Boolean):void
		{
			_active = value;
			switch(_type)
			{
				case BASIC_MISSILE_DAMAGE:
					if(value)
						Model.player.missileDamageModifier += 0.2;
					else
						Model.player.missileDamageModifier -= 0.2;
					break;
				case BASIC_ATTACK_SPEED: 
					if(value)
						Model.player.attackSpeed += 0.2;
					else
						Model.player.attackSpeed -= 0.2;
					break;
				case BASIC_SHAPE_DAMAGE: 
					if(value)
						Model.player.shapeDamageModifier += 0.2;
					else
						Model.player.shapeDamageModifier -= 0.2;
					break;
				case BASIC_SHAPE_SIZE: 
					if(value)
						Model.shapeRange += 0.2;
					else
						Model.shapeRange -= 0.2;
					break;
				case BASIC_MOVEMENT_SPEED: 
					if(value)
						Model.player.movementSpeed *= 1.15;
					else
						Model.player.movementSpeed  /= 1.15;
					break;
				case BASIC_HEALTH: 
					if(value)
						Model.player.maxHP += 20;
					else
						Model.player.maxHP -= 20;
					break;
				case BASIC_DEFENSE: 
					if(value)
						Model.player.damageTakenModifier -= 0.15;
					else
						Model.player.damageTakenModifier += 0.15;
					break;
				case BASIC_SHAPE_COOLDOWN: 
					if(value)
						Model.shapeCooldown -= 0.15;
					else
						Model.shapeCooldown += 0.15;
					break;
				case BASIC_SPELL_COOLDOWN: 
					if(value)
						Model.spellCooldownMod -= 0.15;
					else
						Model.spellCooldownMod += 0.15;
					break;
				case BASIC_VAMPIRISM: 
					if(value)
						Model.player.killVamp += 0.025;
					else
						Model.player.killVamp -= 0.025;
					break;
				case BASIC_DESPERATE_ATTACK_SPEED: 
					if(value)
						Model.player.addStatusEffect(StatusEffect.BUFF_DESPERATION, Model.player);
					else
						Model.player.removeStatusType(StatusEffect.BUFF_DESPERATION);
					break;
				case BASIC_STRUT: 
					if(value)
						Model.player.addStatusEffect(StatusEffect.BUFF_STRUT, Model.player);
					else
						Model.player.removeStatusType(StatusEffect.BUFF_STRUT);
					break;
				case BASIC_BLOWOUT: 
					if(value)
						Model.player.addStatusEffect(StatusEffect.BUFF_BLOWOUT, Model.player);
					else
						Model.player.removeStatusType(StatusEffect.BUFF_BLOWOUT);
					break;
			}
		}
		
		// Property Accessors
		public function get type(): int							{ return _type; }	
		public function get name(): String						{ return _name; }
		public function get owned(): Boolean					{ return _owned; }		
		public function set owned(value: Boolean): void			{ _owned = value; }		
		public function get active(): Boolean					{ return _active; }
		public function get description(): String				{ return _description }
		public static function get(num: int): BasicGem			{ return _vector[num]; }
		
		// Static Accessors	
		/** Gem of Dashing - Increases the damage dealt by missiles by 20%. **/
		public static function get MISSILE_DAMAGE(): BasicGem { return _vector[BASIC_MISSILE_DAMAGE]; }
		/** Berserk Gem - Increases autoattack speed by 20%. **/
		public static function get ATTACK_SPEED(): BasicGem { return _vector[BASIC_ATTACK_SPEED]; }
		/** Gem of Elemental Fury - Increases damage dealt by Shapes by 20%. **/
		public static function get SHAPE_DAMAGE(): BasicGem { return _vector[BASIC_SHAPE_DAMAGE]; }
		/** Gem of Extension - Increases the range of all Shapes by 20%. **/
		public static function get SHAPE_SIZE(): BasicGem { return _vector[BASIC_SHAPE_SIZE]; }
		/** Gem of Speed - Increases base movement speed by 15%. **/
		public static function get MOVEMENT_SPEED(): BasicGem { return _vector[BASIC_MOVEMENT_SPEED]; }
		/** Gem of Health - Increases maximum health by 20. **/
		public static function get HEALTH(): BasicGem { return _vector[BASIC_HEALTH]; }
		/** Gem of Defense - Reduces damage taken by 15%. **/
		public static function get DEFENSE(): BasicGem { return _vector[BASIC_DEFENSE]; }
		/** Gem of Refreshment - Reduces the cooldown of all Shapes by 15%. **/
		public static function get SHAPE_COOLDOWN(): BasicGem { return _vector[BASIC_SHAPE_COOLDOWN]; }
		/** Gem of Casting - Reduces the cooldown of all Spells by 15%. **/
		public static function get SPELL_COOLDOWN(): BasicGem { return _vector[BASIC_SPELL_COOLDOWN]; }
		/** Gem of Vampirism - Restores 2.5% of the the wizard's health per kill. **/
		public static function get VAMPIRISM(): BasicGem { return _vector[BASIC_VAMPIRISM]; }
		/** Daredevil Gem - Grants 40% damage increase when you have not moved for at least 1 second. **/
		public static function get NOT_MOVING(): BasicGem { return _vector[BASIC_NOT_MOVING]; }
		/** Desperate Gem - Grants 4% attack speed per 1% health lost. **/
		public static function get DESPERATE_ATTACK_SPEED(): BasicGem { return _vector[BASIC_DESPERATE_ATTACK_SPEED]; }
		/** Gem of Consistency - Increases the duration of Wall and Ring effects by 50%. **/
		public static function get SHAPE_DURATION(): BasicGem { return _vector[BASIC_SHAPE_DURATION]; }
		/** Gem of Relentlessness - Dealing damage grants 2% increased damage for 10 seconds, up to 40%. **/
		public static function get SNOWBALL_DAMAGE(): BasicGem { return _vector[BASIC_SNOWBALL_DAMAGE]; }
		/** Consistent Gem - Casting a Shape grants 30% damage for 4 seconds. **/
		public static function get DAMAGE_AFTER_SHAPE(): BasicGem { return _vector[BASIC_DAMAGE_AFTER_SHAPE]; }
		/** Protective Gem - Reduces damage taken by 30% for 10 seconds after casting Heal. **/
		public static function get DEFENSE_AFTER_HEAL(): BasicGem { return _vector[BASIC_DEFENSE_AFTER_HEAL]; }
		/** Evasive Gem - Increases movement speed by 2.5% per second up to 25%, resets when hit. **/
		public static function get STRUT(): BasicGem { return _vector[BASIC_STRUT]; }
		/** Gem of Flowing - Increases attack speed by 25% while moving. **/
		public static function get ATS_WHILE_MOVING(): BasicGem { return _vector[BASIC_ATS_WHILE_MOVING]; }
		/** Blowout Gem - Increases damage dealt by 6% per Shape on cooldown. **/
		public static function get BLOWOUT(): BasicGem { return _vector[BASIC_BLOWOUT]; }
		/** Gem of Fear - Casting a defensive skill reduces the cooldown of healing spells by 25%. **/
		public static function get HEAL_CD(): BasicGem { return _vector[BASIC_HEAL_CD]; }
		
	}
}

class Lock{}