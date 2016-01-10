package AS.gems
{
	import AS.objects.Spell;
	
	public class FocusGem implements Gem
	{
		/**
		 * A number representing the type of gem. To be compared to static constants.
		 * As spells have two upgrades, EVEN numbers should be upgrade 1, ODD should be upgrade 2.
		 **/
		private var _type: int;
		/** Gem of Dashing - Increases the Movement Speed bonus granted by the Haste spell to 80%. **/
		public static const FOCUS_HASTE_ONE: int = 0;
		/** Gem of Unstoppable Force - If the wizard gets attacked while hasted, nearby enemies are knocked back. **/
		public static const FOCUS_HASTE_TWO: int = 1;
		/** Gem of Rapid Transport - Reduces the cooldown of teleport to 8 seconds. **/
		public static const FOCUS_TELEPORT_ONE: int = 2;
		/** Gem of Travel - Grants 50% increased movement speed for 3 seconds after casting teleport. **/
		public static const FOCUS_TELEPORT_TWO: int = 3;
		/** Double-Up Gem - Allows Rush to be used twice in a row, but increases the cooldown to 12 seconds. **/
		public static const FOCUS_RUSH_ONE: int = 4;
		/** Bull Rush Gem - Causes enemies to be knocked back while Rush is active.  **/
		public static const FOCUS_RUSH_TWO: int = 5;
		/** Gem of Reliability - Reduces the cooldown of Shield to 20 seconds. **/
		public static const FOCUS_SHIELD_ONE: int = 6;
		/** Gem of Protection - Heals for 5% per second while Shield is active. **/
		public static const FOCUS_SHIELD_TWO: int = 7;
		/** Gem of Perfection - Reflect lasts just 1 second, but heals for 20% per spell reflected. **/
		public static const FOCUS_REFLECT_ONE: int = 8;
		/** Gem of Revenge - Reflected spells deal 50% increased damage. **/
		public static const FOCUS_REFLECT_TWO: int = 9;
		/** Gem of Clarity - Time Stop lasts for 3 seconds. **/
		public static const FOCUS_TIME_STOP_ONE: int = 10;
		/** Manipulation Gem - Increases damage dealt while time is stopped by 50%. **/
		public static const FOCUS_TIME_STOP_TWO: int = 11;
		/** Gem of Chaos - Increases turret damage by 30%, but it fires random elemental attacks. **/
		public static const FOCUS_TURRET_ONE: int = 12;
		/** Gem of Robustness - Turret lasts for 12 seconds. **/
		public static const FOCUS_TURRET_TWO: int = 13;
		/** Gem of Pure Power - Doubles the benefit of Burst, however it now lasts only 3 seconds. **/
		public static const FOCUS_BURST_ONE: int = 14;
		/** Gem of Destruction - Burst increases attack damage instead of attack speed. **/
		public static const FOCUS_BURST_TWO: int = 15;
		/** Gem of Shared Burden - Relapse cooldown is equal to the amount of shape cooldown reduced.**/
		public static const FOCUS_RELAPSE_ONE: int = 16;
		/** Gem of Empowered Mimicry - The Shape that is reset by Relapse deals 50% increased damage. **/
		public static const FOCUS_RELAPSE_TWO: int = 17;
		/** Gem of Healing - Increases the percentage healed by Heal by 60%. **/
		public static const FOCUS_HEAL_ONE: int = 18;
		/** Gem of Evasion - Nearby enemies are knocked back after casting Heal. **/
		public static const FOCUS_HEAL_TWO: int = 19;
		/** Gem of Slow Regeneration - Regenerate now restores 100% of the wizard's health over 24 seconds. **/
		public static const FOCUS_REGENERATE_ONE: int = 20;
		/** Gem of Recuperation - Each time Regenerate heals, there is a 5% chance to reset a random Shape cooldown. **/
		public static const FOCUS_REGENERATE_TWO: int = 21;
		/** Gem of Holy Scars - Holy Ground knocks nearby enemies back when it heals. **/
		public static const FOCUS_HOLY_GROUND_ONE: int = 22;
		/** Gem of Angelicism - Holy Ground now lasts for 6 seconds. **/
		public static const FOCUS_HOLY_GROUND_TWO: int = 23;
		
		private var _owned: Boolean = false, _active: Boolean = false;
		private var _name: String, _description: String;
		private static var _vector: Vector.<FocusGem> = new Vector.<FocusGem>();
		
		/**
		 * PRIVATE CONSTRUCTOR. Cannot and should not be externally instantiated.
		 **/
		public function FocusGem(type: int, name: String, description: String, doNotInstantiate: Lock)
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
				_vector = Vector.<FocusGem>([
					new FocusGem(0, "Gem of Dashing",
						"Increases the Movement Speed bonus granted by the Haste spell to 80%.", key),
					new FocusGem(1, "Gem of Force",
						"If the wizard gets attacked while hasted, nearby enemies are knocked back.", key),
					new FocusGem(2, "Gem of Transport",
						"Reduces the cooldown of teleport to 8 seconds.", key),
					new FocusGem(3, "Gem of Travel",
						"Grants 50% increased movement speed for 3 seconds after casting teleport.", key),
					new FocusGem(4, "Double-Up Gem",
						"Allows Rush to be used twice in a row, but increases the cooldown to 12 seconds.", key),
					new FocusGem(5, "Bull Rush Gem",
						"Causes enemies to be knocked back while Rush is active. ", key),
					new FocusGem(6, "Gem of Reliability",
						"Reduces the cooldown of Shield to 20 seconds.", key),
					new FocusGem(7, "Gem of Protection",
						"Heals for 5% per second while Shield is active.", key),
					new FocusGem(8, "Gem of Perfection",
						"Reflect lasts just 1 second, but heals for 20% per spell reflected.", key),
					new FocusGem(9, "Gem of Revenge",
						"Reflected spells deal 50% increased damage.", key),
					new FocusGem(10, "Gem of Clarity",
						"Time Stop lasts for 3 seconds.", key),
					new FocusGem(11, "Manipulation Gem",
						"Increases damage dealt while time is stopped by 50%.", key),
					new FocusGem(12, "Gem of Chaos",
						"Increases turret damage by 30%, but it fires random elemental attacks.", key),
					new FocusGem(13, "Gem of Robustness",
						"Turret lasts for 12 seconds.", key),
					new FocusGem(14, "Gem of Pure Power",
						"Doubles the benefit of Burst, however it now lasts only 3 seconds.", key),
					new FocusGem(15, "Gem of Destruction",
						"Burst increases attack damage instead of attack speed.", key),
					new FocusGem(16, "Gem of Shared Burden",
						"Relapse cooldown is equal to the amount of shape cooldown reduced.", key),
					new FocusGem(17, "Gem of Empowerment",
						"The Shape that is reset by Relapse deals 50% increased damage.", key),
					new FocusGem(18, "Gem of Healing",
						"Increases the percentage healed by Heal by 60%.", key),
					new FocusGem(19, "Gem of Evasion",
						"Nearby enemies are knocked back after casting Heal.", key),
					new FocusGem(20, "Gem of Sloth",
						"Regenerate now restores 100% of the wizard's health over 24 seconds.", key),
					new FocusGem(21, "Gem of Recuperation",
						"Each time Regenerate heals, there is a 5% chance to reset a random Shape cooldown.", key),
					new FocusGem(22, "Gem of Holy Scars",
						"Holy Ground knocks nearby enemies back when it heals.", key),
					new FocusGem(23, "Gem of Angelicism",
						"Holy Ground now lasts for 6 seconds.", key)]);
			}
		
		public function set active(value: Boolean): void
		{
			_active = value;
			if(value)
				relatedSpell.addUpgrade((_type % 2) + 1);
			else
				relatedSpell.removeUpgrade((_type % 2) + 1);
		}
		
		private function get relatedSpell(): Spell
		{
			switch(int(_type / 2))
			{
				case 0:
					return Spell.HASTE;
				case 1: 
					return Spell.TELEPORT;
				case 2: 
					return Spell.RUSH;
				case 3: 
					return Spell.SHIELD;
				case 4:
					return Spell.REFLECT;
				case 5: 
					return Spell.TIME_STOP;
				case 6:
					return Spell.TURRET;
				case 7:
					return Spell.BURST;
				case 8:
					return Spell.RELAPSE;
				case 9:
					return Spell.HEAL;
				case 10:
					return Spell.REGENERATE;
				case 11:
					return Spell.HOLY_GROUND;
			}
			return null;
		}
		
		// Property Accessors
		public function get type(): int							{ return _type; }	
		public function get name(): String						{ return _name; }
		public function get owned(): Boolean					{ return _owned; }		
		public function set owned(value: Boolean): void			{ _owned = value; }		
		public function get active(): Boolean					{ return _active; }
		public function get description(): String				{ return _description }
		public static function get(num: int): FocusGem			{ return _vector[num]; }
		
		// Static Accessors
		/** Gem of Dashing - Increases the Movement Speed bonus granted by the Haste spell to 80%. **/
		public static function get HASTE_ONE(): FocusGem 		{ return _vector[FOCUS_HASTE_ONE]; }
		/** Gem of Unstoppable Force - If the wizard gets attacked while hasted, nearby enemies are knocked back. **/
		public static function get HASTE_TWO(): FocusGem 		{ return _vector[FOCUS_HASTE_TWO]; }
		/** Gem of Rapid Transport - Reduces the cooldown of teleport to 8 seconds. **/
		public static function get TELEPORT_ONE(): FocusGem 	{ return _vector[FOCUS_TELEPORT_ONE]; }
		/** Gem of Travel - Grants 50% increased movement speed for 3 seconds after casting teleport. **/
		public static function get TELEPORT_TWO(): FocusGem 	{ return _vector[FOCUS_TELEPORT_TWO]; }
		/** Double-Up Gem - Allows Rush to be used twice in a row, but increases the cooldown to 12 seconds. **/
		public static function get RUSH_ONE(): FocusGem 		{ return _vector[FOCUS_RUSH_ONE]; }
		/** Bull Rush Gem - Causes enemies to be knocked back while Rush is active.  **/
		public static function get RUSH_TWO(): FocusGem 		{ return _vector[FOCUS_RUSH_TWO]; }
		/** Gem of Reliability - Reduces the cooldown of Shield to 20 seconds. **/
		public static function get SHIELD_ONE(): FocusGem 		{ return _vector[FOCUS_SHIELD_ONE]; }
		/** Gem of Protection - Heals for 5% per second while Shield is active. **/
		public static function get SHIELD_TWO(): FocusGem 		{ return _vector[FOCUS_SHIELD_TWO]; }
		/** Gem of Perfection - Reflect lasts just 1 second, but heals for 20% per spell reflected. **/
		public static function get REFLECT_ONE(): FocusGem 		{ return _vector[FOCUS_REFLECT_ONE]; }
		/** Gem of Revenge - Reflected spells deal 50% increased damage. **/
		public static function get REFLECT_TWO(): FocusGem 		{ return _vector[FOCUS_REFLECT_TWO]; }
		/** Gem of Clarity - Time Stop lasts for 3 seconds. **/
		public static function get TIME_STOP_ONE(): FocusGem	{ return _vector[FOCUS_TIME_STOP_ONE]; }
		/** Manipulation Gem - Increases damage dealt while time is stopped by 50%. **/
		public static function get TIME_STOP_TWO(): FocusGem	{ return _vector[FOCUS_TIME_STOP_TWO]; }
		/** Gem of Chaos - Increases turret damage by 30%, but it fires random elemental attacks. **/
		public static function get TURRET_ONE(): FocusGem 		{ return _vector[FOCUS_TURRET_ONE]; }
		/** Gem of Robustness - Turret lasts for 12 seconds. **/
		public static function get TURRET_TWO(): FocusGem 		{ return _vector[FOCUS_TURRET_TWO]; }
		/** Gem of Pure Power - Doubles the benefit of Burst, however it now lasts only 3 seconds. **/
		public static function get BURST_ONE(): FocusGem 		{ return _vector[FOCUS_BURST_ONE]; }
		/** Gem of Destruction - Burst increases attack damage instead of attack speed. **/
		public static function get BURST_TWO(): FocusGem 		{ return _vector[FOCUS_BURST_TWO]; }
		/** Gem of Shared Burden - Relapse cooldown is equal to the amount of shape cooldown reduced.**/
		public static function get RELAPSE_ONE(): FocusGem 		{ return _vector[FOCUS_RELAPSE_ONE]; }
		/** Gem of Empowered Mimicry - The Shape that is reset by Relapse deals 50% increased damage. **/
		public static function get RELAPSE_TWO(): FocusGem 		{ return _vector[FOCUS_RELAPSE_TWO]; }
		/** Gem of Healing - Increases the percentage healed by Heal by 60%. **/
		public static function get HEAL_ONE(): FocusGem 		{ return _vector[FOCUS_HEAL_ONE]; }
		/** Gem of Evasion - Nearby enemies are knocked back after casting Heal. **/
		public static function get HEAL_TWO(): FocusGem 		{ return _vector[FOCUS_HEAL_TWO]; }
		/** Gem of Slow Regeneration - Regenerate now restores 100% of the wizard's health over 24 seconds. **/
		public static function get REGENERATE_ONE(): FocusGem 	{ return _vector[FOCUS_REGENERATE_ONE]; }
		/** Gem of Recuperation - Each time Regenerate heals, there is a 5% chance to reset a random Shape cooldown. **/
		public static function get REGENERATE_TWO(): FocusGem 	{ return _vector[FOCUS_REGENERATE_TWO]; }
		/** Gem of Holy Scars - Holy Ground knocks nearby enemies back when it heals. **/
		public static function get HOLY_GROUND_ONE(): FocusGem 	{ return _vector[FOCUS_HOLY_GROUND_ONE]; }
		/** Gem of Angelicism - Holy Ground now lasts for 6 seconds. **/
		public static function get HOLY_GROUND_TWO(): FocusGem 	{ return _vector[FOCUS_HOLY_GROUND_TWO]; }
	}
}

class Lock {}