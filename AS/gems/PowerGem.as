package AS.gems
{
	public class PowerGem implements Gem
	{
		import AS.objects.Model;
		import AS.objects.StatusEffect;
		
		/**
		 * A number representing the type of gem. To be compared to static constants.
		 **/
		private var _type: int;
		/** Gem of the Rogue Mage - Casting a Spell or Shape reduces the cooldown of all Shapes by 1 second. **/
		public static const POWER_RYZE: int = 0; // #Shameless
		/** Safeguard Gem - When your health drops below 20%, all spell cooldowns reset. 2 minute cooldown.* */
		public static const POWER_SAFEGUARD: int = 1;
		/**
		 * Gem of Ripples - Casting a Healing spell reduces the cooldown of Defense spells by 10 seconds.
		 * 					Casting an Offensive spell resets the cooldown of Movement spells.
		 **/
		public static const POWER_RIPPLES: int = 2;
		/**
		 * Gem of Elemental Destruction - While all shapes are on cooldown, your auto attacks have a 35% chance
		 * 								  to fire off twice in a row.
		 **/
		public static const POWER_ELEMENTS: int = 3;
		/**
		 * Glyph of Dominance - Killing an enemy grants 3% attack speed per kill, up to a cap of 60%.
		 * 						Resets upon being hit.
		 **/
		public static const POWER_DOMINANCE: int = 4;
		
		private var _owned: Boolean = false, _active: Boolean = false;
		private var _name: String, _description: String;
		private static var _vector: Vector.<PowerGem> = new Vector.<PowerGem>();
		
		/**
		 * PRIVATE CONSTRUCTOR. Cannot and should not be externally instantiated.
		 **/
		public function PowerGem(type: int, name: String, description: String, doNotInstantiate: Lock)
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
				_vector = Vector.<PowerGem>([
					new PowerGem(0, "Gem of Rogue Magic",
						"Casting a Spell or Shape reduces the cooldown of all Shapes by 1 second.", key),
					new PowerGem(1, "Safeguard Gem",
						"When your health drops below 20%, all spell cooldowns reset. 2 minute cooldown.", key),
					new PowerGem(2, "Gem of Ripples", "" +
						"Casting a Healing spell reduces the cooldown of Defense spells by 10 seconds. " +
						"Casting an Offensive spell resets the cooldown of Movement spells.", key),
					new PowerGem(3, "Gem of Elements",
						"While all shapes are on cooldown, your auto attacks have a 35% chance to fire off twice in a row.", key),
					 new PowerGem(4, "Glyph of Dominance", 
						"Killing an enemy grants 3% attack speed per kill, up to a cap of 60%. Resets upon being hit.", key)]);
			}

		// Property Accessors
		public function get type(): int							{ return _type; }	
		public function get name(): String						{ return _name; }
		public function get owned(): Boolean					{ return _owned; }		
		public function set owned(value: Boolean): void			{ _owned = value; }		
		public function get active(): Boolean					{ return _active; }
		public function get description(): String				{ return _description }
		public function set active(value:Boolean):void 			{ _active = value; }
		public static function get(num: int): PowerGem			{ return _vector[num]; }
		
		//Static Accessors
		/** Gem of the Rogue Mage - Casting a Spell or Shape reduces the cooldown of all Shapes by 1 second. **/
		public static function get RYZE(): PowerGem { return _vector[POWER_RYZE]; } // #Shameless
		/** Safeguard Gem - When your health drops below 20%, all spell cooldowns reset. 2 minute cooldown.* */
		public static function get SAFEGUARD(): PowerGem { return _vector[POWER_SAFEGUARD]; }
		/**
		 * Gem of Ripples - Casting a Healing spell reduces the cooldown of Defense spells by 10 seconds.
		 * 					Casting an Offensive spell resets the cooldown of Movement spells.
		 **/
		public static function get RIPPLES(): PowerGem { return _vector[POWER_RIPPLES]; }
		/**
		 * Gem of Elemental Destruction - While all shapes are on cooldown, your auto attacks have a 35% chance
		 * 								  to fire off twice in a row.
		 **/
		public static function get ELEMENTS(): PowerGem { return _vector[POWER_ELEMENTS]; }
		/**
		 * Glyph of Dominance - Killing an enemy grants 3% attack speed per kill, up to a cap of 60%.
		 * 						Resets upon being hit.
		 **/
		public static function get DOMINANCE(): PowerGem { return _vector[POWER_DOMINANCE]; }
	}
}

class Lock{}