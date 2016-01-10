package AS.gems
{
	import AS.objects.Element;
	
	public class ElementalGem implements Gem
	{
		/**
		 * A number representing the type of gem. To be compared to static constants.
		 * As elements have three upgrades, %3==0 should be first upgrade, %3==1 second, etc.
		 **/
		private var _type: int;
		/** Burning Gem - Fire attacks burn for 60% bonus damage over 3 seconds. **/
		public static const ELEMENTAL_FIRE_ONE: int = 0;
		/** Engulfing Gem - Fire attacks create a lava pool dealing 60% extra damage over 3 seconds. **/
		public static const ELEMENTAL_FIRE_TWO: int = 1;
		/** Detonation Gem - Fire attacks explode, damaging everything that it hits. **/
		public static const ELEMENTAL_FIRE_THREE: int = 2;
		/** Tendrilling Gem - Earth attacks root targets for 1 second. **/
		public static const ELEMENTAL_EARTH_ONE: int = 3;
		/** Gem of Paralysis - Earth attacks paralyze the targets, stunning them. **/
		public static const ELEMENTAL_EARTH_TWO: int = 4;
		/** Gem of Quakes - 30% chance that earth missiles cause an earthquake (90% for Shapes). **/
		public static const ELEMENTAL_EARTH_THREE: int = 5;
		/** Buffetting Gem - Air attacks knock enemies back much further. **/
		public static const ELEMENTAL_AIR_ONE: int = 6;
		/** Forceful Gem - Air attacks now knock nearby foes back as well. **/
		public static const ELEMENTAL_AIR_TWO: int = 7;
		/** Tornado Gem - 20% chance that air missiles cause a tornado (50% for Shapes). **/
		public static const ELEMENTAL_AIR_THREE: int = 8;
		/** Gem of Endless Frost - Frost attacks slow targets by 80%. **/
		public static const ELEMENTAL_ICE_ONE: int = 9;
		/** Gem of the Frozen Cloud - Frost attacks slow enemies near the target. **/
		public static const ELEMENTAL_ICE_TWO: int = 10;
		/** Gem of Shattering - Damage against frozen enemies is increased by 50%. **/
		public static const ELEMENTAL_ICE_THREE: int = 11;
		/** Gem of Staggering - Thunder attacks stagger the target for half a second. **/
		public static const ELEMENTAL_THUNDER_ONE: int = 12;
		/** Gem of Leaping - Thunder attacks now bounce to three targets, dealing 30% damage to each. **/
		public static const ELEMENTAL_THUNDER_TWO: int = 13;
		/** Thunderstorm Gem - 30% chance that thunder missiles cause a thunderstorm (90% for Shapes). **/
		public static const ELEMENTAL_THUNDER_THREE: int = 14;
		/** Gem of Desecration - The shadow bomb explosion is 80% larger. **/
		public static const ELEMENTAL_SHADOW_ONE: int = 15;
		/** Reactive Gem - Shadow explosions now spread the shadow bomb to targets hit, for 50% of the initial damage. **/
		public static const ELEMENTAL_SHADOW_TWO: int = 16;
		/** Black Hole Gem - 30% chance that shadow missiles cause a black hole (90% for Shapes). **/
		public static const ELEMENTAL_SHADOW_THREE: int = 17;
		/** Gem of Rapid Increment - The Arcane glyph now increases damage by 30%, stacking up to 3 times. **/
		public static const ELEMENTAL_ARCANE_ONE: int = 18;
		/** Gem of Residual Energy - Arcane attacks leave Glyph Mines on the ground, dealing 50% of the initial damage. **/
		public static const ELEMENTAL_ARCANE_TWO: int = 19;
		/** Glyph of Shockwaves - Arcane attacks cause a shockwave, passing the glyph to nearby targets.  **/
		public static const ELEMENTAL_ARCANE_THREE: int = 20;
		/** Limit Breaker Gem - Poison attacks do half the damage per second, but last forever. **/
		public static const ELEMENTAL_POISON_ONE: int = 21;
		/** Smog Gem - Poison attacks also poison nearby targets. **/
		public static const ELEMENTAL_POISON_TWO: int = 22;
		/** Gem of Debilitating Poison - Poisoned targets are slowed by 30% **/
		public static const ELEMENTAL_POISON_THREE: int = 23;
		
		private var _owned: Boolean = false, _active: Boolean = false;
		private var _name: String, _description: String;
		private static var _vector: Vector.<ElementalGem> = new Vector.<ElementalGem>();
		
		/**
		 * PRIVATE CONSTRUCTOR. Cannot and should not be externally instantiated.
		 **/
		public function ElementalGem(type: int, name: String, description: String, doNotInstantiate: Lock)
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
			_vector = Vector.<ElementalGem>([
				new ElementalGem(0,"Burning Gem",
					"Fire attacks burn for 60% bonus damage over 3 seconds.", key),
				new ElementalGem(1,"Engulfing Gem",
					"Fire attacks create a lava pool dealing 60% extra damage over 3 seconds.", key),
				new ElementalGem(2,"Detonation Gem",
					"Fire attacks explode, damaging everything that it hits.", key),
				new ElementalGem(3,"Tendrilling Gem",
					"Earth attacks root targets for 1 second.", key),
				new ElementalGem(4,"Gem of Paralysis",
					"Earth attacks paralyze the targets, stunning them.", key),
				new ElementalGem(5,"Gem of Quakes",
					"30% chance that earth missiles cause an earthquake (90% for Shapes).", key),
				new ElementalGem(6,"Buffetting Gem",
					"Air attacks knock enemies back much further.", key),
				new ElementalGem(7,"Forceful Gem",
					"Air attacks now knock nearby foes back as well.", key),
				new ElementalGem(8,"Tornado Gem",
					"20% chance that air missiles cause a tornado (50% for Shapes).", key),
				new ElementalGem(9,"Gem of Frost",
					"Frost attacks slow targets by 80%.", key),
				new ElementalGem(10,"Gem of the Cloud",
					"Frost attacks slow enemies near the target.", key),
				new ElementalGem(11,"Gem of Shattering",
					"Damage against frozen enemies is increased by 50%.", key),
				new ElementalGem(12,"Gem of Staggering",
					"Thunder attacks stagger the target for half a second.", key),
				new ElementalGem(13,"Gem of Leaping",
					"Thunder attacks now bounce to three targets, dealing 30% damage to each.", key),
				new ElementalGem(14,"Thunderstorm Gem", 
					"30% chance that thunder missiles cause a thunderstorm (90% for Shapes).", key),
				new ElementalGem(15,"Gem of Desecration",
					"The shadow bomb explosion is 80% larger.", key),
				new ElementalGem(16,"Reactive Gem",
					"Shadow explosions now spread the shadow bomb to targets hit, for 50% of the initial damage.", key),
				new ElementalGem(17,"Black Hole Gem",
					"30% chance that shadow missiles cause a black hole (90% for Shapes).", key),
				new ElementalGem(18,"Gem of Increment",
					"The Arcane glyph now increases damage by 30%, stacking up to 3 times.", key),
				new ElementalGem(19,"Gem of Mines",
					"Arcane attacks leave Glyph Mines on the ground, dealing 50% of the initial damage.", key),
				new ElementalGem(20,"Glyph of Waves",
					"Arcane attacks cause a shockwave, passing the glyph to nearby targets. ", key),
				new ElementalGem(21,"Limit Breaker Gem",
					"Poison attacks do half the damage per second, but last forever.", key),
				new ElementalGem(22,"Smog Gem",
					"Poison attacks also poison nearby targets.", key),
				new ElementalGem(23,"Gem of Debilitation",
					"Poisoned targets are slowed by 30%", key)]);
				
		}		
		
		public function set active(value: Boolean): void
		{
			_active = value;
			if(value)
				relatedElement.addUpgrade((_type % 3) + 1);
			else
				relatedElement.removeUpgrade((_type % 3) + 1);
		}
		
		private function get relatedElement(): Element
		{
			switch(int(_type / 3))
			{
				case 0:
					return Element.FIRE;
				case 1: 
					return Element.EARTH;
				case 2: 
					return Element.AIR;
				case 3: 
					return Element.FROST;
				case 4:
					return Element.THUNDER;
				case 5: 
					return Element.SHADOW;
				case 6:
					return Element.ARCANE;
				case 7:
					return Element.POISON;
				default:
					return null;
			}
		}

		// Property Accessors
		public function get type(): int							{ return _type; }	
		public function get name(): String						{ return _name; }
		public function get owned(): Boolean					{ return _owned; }		
		public function set owned(value: Boolean): void			{ _owned = value; }		
		public function get active(): Boolean					{ return _active; }
		public function get description(): String				{ return _description }
		public static function get(num: int): ElementalGem		{ return _vector[num]; }
		
		// Static Accessors
		/** Burning Gem - Fire attacks burn for 60% bonus damage over 3 seconds. **/
		public static function get FIRE_ONE(): ElementalGem 	{ return _vector[ELEMENTAL_FIRE_ONE]; }
		/** Engulfing Gem - Fire attacks create a lava pool dealing 60% extra damage over 3 seconds. **/
		public static function get FIRE_TWO(): ElementalGem 	{ return _vector[ELEMENTAL_FIRE_TWO]; }
		/** Detonation Gem - Fire attacks explode, damaging everything that it hits. **/
		public static function get FIRE_THREE(): ElementalGem 	{ return _vector[ELEMENTAL_FIRE_THREE]; }
		/** Tendrilling Gem - Earth attacks root targets for 1 second. **/
		public static function get EARTH_ONE(): ElementalGem 	{ return _vector[ELEMENTAL_EARTH_ONE]; }
		/** Gem of Paralysis - Earth attacks paralyze the targets, stunning them. **/
		public static function get EARTH_TWO(): ElementalGem 	{ return _vector[ELEMENTAL_EARTH_TWO]; }
		/** Gem of Quakes - 30% chance that earth missiles cause an earthquake (90% for Shapes). **/
		public static function get EARTH_THREE(): ElementalGem 	{ return _vector[ELEMENTAL_EARTH_THREE]; }
		/** Buffetting Gem - Air attacks knock enemies back much further. **/
		public static function get AIR_ONE(): ElementalGem 		{ return _vector[ELEMENTAL_AIR_ONE]; }
		/** Forceful Gem - Air attacks now knock nearby foes back as well. **/
		public static function get AIR_TWO(): ElementalGem 		{ return _vector[ELEMENTAL_AIR_TWO]; }
		/** Tornado Gem - 20% chance that air missiles cause a tornado (50% for Shapes). **/
		public static function get AIR_THREE(): ElementalGem 	{ return _vector[ELEMENTAL_AIR_THREE]; }
		/** Gem of Endless Frost - Frost attacks slow targets by 80%. **/
		public static function get ICE_ONE(): ElementalGem 		{ return _vector[ELEMENTAL_ICE_ONE]; }
		/** Gem of the Frozen Cloud - Frost attacks slow enemies near the target. **/
		public static function get ICE_TWO(): ElementalGem 		{ return _vector[ELEMENTAL_ICE_TWO]; }
		/** Gem of Shattering - Damage against frozen enemies is increased by 50%. **/
		public static function get ICE_THREE(): ElementalGem 	{ return _vector[ELEMENTAL_ICE_THREE]; }
		/** Gem of Staggering - Thunder attacks stagger the target for half a second. **/
		public static function get THUNDER_ONE(): ElementalGem 	{ return _vector[ELEMENTAL_THUNDER_ONE]; }
		/** Gem of Leaping - Thunder attacks now bounce to three targets, dealing 30% damage to each. **/
		public static function get THUNDER_TWO(): ElementalGem 	{ return _vector[ELEMENTAL_THUNDER_TWO]; }
		/** Thunderstorm Gem - 30% chance that thunder missiles cause a thunderstorm (90% for Shapes). **/
		public static function get THUNDER_THREE(): ElementalGem{ return _vector[ELEMENTAL_THUNDER_THREE]; }
		/** Gem of Desecration - The shadow bomb explosion is 80% larger. **/
		public static function get SHADOW_ONE(): ElementalGem 	{ return _vector[ELEMENTAL_SHADOW_ONE]; }
		/** Reactive Gem - Shadow explosions now spread the shadow bomb to targets hit, for 50% of the initial damage. **/
		public static function get SHADOW_TWO(): ElementalGem 	{ return _vector[ELEMENTAL_SHADOW_TWO]; }
		/** Black Hole Gem - 30% chance that shadow missiles cause a black hole (90% for Shapes). **/
		public static function get SHADOW_THREE(): ElementalGem { return _vector[ELEMENTAL_SHADOW_THREE]; }
		/** Gem of Rapid Increment - The Arcane glyph now increases damage by 30%, stacking up to 3 times. **/
		public static function get ARCANE_ONE(): ElementalGem 	{ return _vector[ELEMENTAL_ARCANE_ONE]; }
		/** Gem of Residual Energy - Arcane attacks leave Glyph Mines on the ground, dealing 50% of the initial damage. **/
		public static function get ARCANE_TWO(): ElementalGem 	{ return _vector[ELEMENTAL_ARCANE_TWO]; }
		/** Glyph of Shockwaves - Arcane attacks cause a shockwave, passing the glyph to nearby targets.  **/
		public static function get ARCANE_THREE(): ElementalGem { return _vector[ELEMENTAL_ARCANE_THREE]; }
		/** Limit Breaker Gem - Poison attacks do half the damage per second, but last forever. **/
		public static function get POISON_ONE(): ElementalGem 	{ return _vector[ELEMENTAL_POISON_ONE]; }
		/** Smog Gem - Poison attacks also poison nearby targets. **/
		public static function get POISON_TWO(): ElementalGem { return _vector[ELEMENTAL_POISON_TWO]; }
		/** Gem of Debilitating Poison - Poisoned targets are slowed by 30% **/
		public static function get POISON_THREE(): ElementalGem { return _vector[ELEMENTAL_POISON_THREE]; }
	}
}

class Lock {}