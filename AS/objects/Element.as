package AS.objects
{
	import flash.display.MovieClip;
	import flash.events.StatusEvent;

	/**
	 * The Element class stores upgrade levels for each Element.
	 * It should be initialised using the init() method as soon as possible, then each
	 * element can be accessed using either get(TYPE_ELEMENTNAME), using the static constants
	 * for each element, or simple Element.ELEMENTNAME. Upgrades can be tested using hasUpgrade(),
	 * added using addUpgrade() and removed using removeUpgrade().
	 * Central to class operations is the dealDamage() class. Every time elemental damage is dealt by
	 * the wizard to enemy units, dealDamage should be called. This will automatically cause any
	 * elemental effects, including buffs, debuffs and dummy effects, then call the target.takeDamage()
	 * method. This keeps implementation details simple and easy to modify.
	 * 
	 * Version 1.0
	 * 
	 * @author Deso
	 * 
	 **/
	public class Element extends UpgradableStatic
	{
		/**
		 * Fire deals 50% more damage than other elemental types' base damage. 		<br/><br/>
		 * 
		 * Upgrade 1 - Burns for 60% bonus damage over 3 seconds. 					<br/>
		 * Upgrade 2 - Creates a lava pool dealing 60% extra damage over 3 seconds. <br/>
		 * Upgrade 3 - Explodes, damaging everything that it hits.					<br/>
		 **/
		public static const TYPE_FIRE: int = 0;
		/**
		 * Earth roots targets to the ground for 0.6 seconds. 						<br/><br/>
		 * 
		 * Upgrade 1 - Root duration increased to 1 second. 						<br/>
		 * Upgrade 2 - Paralyses instead of rooting. 								<br/>
		 * Upgrade 3 - 30%/100% chance to make an earthquake up in here. 			<br/>
		 **/ 
		public static const TYPE_EARTH: int = 1;
		/**
		 * Air knocks enemies back on hit. 											<br/><br/>
		 * 
		 * Upgrade 1 - Doubles the knockback effect. 								<br/>
		 * Upgrade 2 - AoE knockback effect upon landing. 							<br/>
		 * Upgrade 3 - 30%/100% chance to cause a tornado. 							<br/>
		 **/
		public static const TYPE_AIR: int = 2;
		/**
		 * Frost slows enemies by 60% for 1 second. 								<br/><br/>
		 * 
		 * Upgrade 1 - Slow amount increased to 80%. 								<br/>
		 * Upgrade 2 - AoE slow effect on hit. 										<br/>
		 * Upgrade 3 - 100% damage from next attack within 2 seconds.				<br/>
		 **/
		public static const TYPE_FROST: int = 3;
		/**
		 * Thunder bounces to a nearby target on hit, dealing 60% damage.			<br/><br/>
		 * 
		 * Upgrade 1 - Staggers targers for 0.5 seconds. THUNDERSTRUUCK.			<br/>
		 * Upgrade 2 - Jumps 3 times instead of 2.									<br/>
		 * Upgrade 3 - 30/100% chance to create stormy clouds.						<br/>
		 **/
		public static const TYPE_THUNDER: int = 4;
		/**
		 * Shadow leaves a bomb on the target that explodes upon target death.		<br/><br/>
		 * 
		 * Upgrade 1 - Explosion radius increased by 80%.							<br/>
		 * Upgrade 2 - Setting us up the bomb on anything hit.						<br/>
		 * Upgrade 3 - 30/100% chance to cause a Super Massive Black Hole.			<br/>
		 **/
		public static const TYPE_SHADOW: int = 5;
		/**
		 * Arcane leaves a glyph that increases damage taken by target by 20%		<br/><br/>
		 * 
		 * Upgrade 1 - Increases the damage buff to 30%, but max 3 stacks.			<br/>
		 * Upgrade 2 - Leaves mines, which can duplicate the effect.				<br/>
		 * Upgrade 3 - Any arcane hits create arcane shockwaves.					<br/>
		 **/
		public static const TYPE_ARCANE: int = 6;
		/**
		 * Poison deals double the usual damge over a period of ten seconds.		<br/><br/>
		 * 
		 * Upgrade 1 - Lasts forever, with the same amount of DPS.					<br/>
		 * Upgrade 2 - Poison has an AoE effect, poisoning nearby targets for 4s.	<br/>
		 * Upgrade 3 - Poison also slows the target by 30%.							<br/>
		 **/
		public static const TYPE_POISON: int = 7;
		/**
		 * Deals standard damage. Used by enemies.
		 **/
		public static const TYPE_DARKNESS: int = 8;
		
		/** A vector containing each element in order. Elements are externally accessed accessors **/
		private static var _vector:Vector.<Element> =  new Vector.<Element>();
		
		/**
		 * PRIVATE CONSTRUCTOR. Cannot and should not be externally instantiated.
		 **/
		public function Element(type: int, name: String, description: String, doNotInstantiate: Lock) {
			super(type, name, description, UpgradableStatic.key);
		}
		
		/**
		 * Instantiates the class, allowing elemental accessors to be used. 
		 * This should be called as early as possible, and must be called before any accessors are used.
		 **/
		public static function init(): void{
			var key: Lock = new Lock();
			_vector = Vector.<Element>([
				new Element(0, "Fire", "Fire attacks deal 50% more damage than other types.", key),
				new Element(1, "Earth", "Earth attacks root the target to the ground for 0.6 seconds.", key),
				new Element(2, "Air", "Air attacks knock enemies back on hit.", key),
				new Element(3, "Frost", "Frost attacks slow movement speed by 60%.", key),
				new Element(4, "Thunder", "Thunder attacks bounce to a nearby target, dealing 60% extra damage.", key),
				new Element(5, "Shadow", "Shadow attacks leave a bomb, which explodes for 50% damage when the target dies.", key),
				new Element(6, "Arcane", "Arcane attacks increase the target's damage taken by 20% for 5 seconds, up to 80%.", key),
				new Element(7, "Poison", "Poison attacks deal double the normal damage over 10 seconds.", key),
				new Element(8, "Dark", "Dark attacks have no special effects.", key)]);
		}
		
		/**
		 * NOT TEMP.
		 **/
		public static function get(element: int):Element { return _vector[element]; }
		
		//TODO
		public function dealDamage(target: Actor, caster: Actor, isShape: Boolean, damage: Number,
								   triggersEffects: Boolean, source: MovieClip = null): void {
			switch (type)
			{	
				case TYPE_FIRE:
					damage *= 1.5;
					if(hasUpgrade(1) && source != null)
						target.addStatusEffect(StatusEffect.DEBUFF_BURN, caster, target.burn,damage * 0.2);
					if(hasUpgrade(2) && triggersEffects && !isShape)
						new Dummy(Dummy.TYPE_LAVA_PIT, caster, 1500, damage * 0.15, target);
					if(!(source is Dummy && (source as Dummy).type == Dummy.TYPE_FIRE_EXPLOSION) &&
							hasUpgrade(3) && source != null && !isShape)
						new Dummy(Dummy.TYPE_FIRE_EXPLOSION, caster, 200, damage, target);
					break;
				
				case TYPE_EARTH:
					target.addStatusEffect(StatusEffect.DEBUFF_ROOT,caster,target.roots, 0);
					if(hasUpgrade(3) && !isShape && triggersEffects &&((Math.random() < 0.3 && !(source is Shape)) ||
																	   (Math.random() < 0.9 && source is Shape)))
						new Dummy(Dummy.TYPE_EARTHQUAKE, caster, 1500, damage, target);
					break;
				
				case TYPE_AIR:
					if(!(caster is Dummy))
						target.addForce(hasUpgrade(1) ? 20 : 14, Model.toDegrees(Model.angleBetween(target, source)));
					if(caster is Shape)
						target.addForce(hasUpgrade(1) ? 20 : 15, Model.toDegrees(Model.angleBetween(target, source)));
					if(hasUpgrade(2) && !isShape && triggersEffects)
						new Dummy(Dummy.TYPE_SHOCKWAVE,caster, 200, 0, target);
					if(hasUpgrade(3) && !isShape && triggersEffects &&((Math.random() < 0.2 && !(source is Shape)) ||
																	   (Math.random() < 0.5 && source is Shape)))
						new Dummy(Dummy.TYPE_TORNADO, caster, 1000, 0,  (source is Shape) ? target : source);
					break;
				
				case TYPE_FROST:
					target.addStatusEffect(StatusEffect.DEBUFF_SLOW, caster, target.freeze, 0);
					if(hasUpgrade(2) && triggersEffects)
					new Dummy(Dummy.TYPE_ICE_EXPLOSION,caster, 320, damage / 2, target);
					break;
				
				case TYPE_THUNDER:
					if(triggersEffects)
						for(var i: int = 0; i < (hasUpgrade(2) ? 3 : 1); i++)
							new Missile(this, caster, Math.random() * 640, Math.random() * 480,
									damage * (hasUpgrade(2) ? 0.3 : 0.9), false, target, false);
					if(hasUpgrade(1))
						target.addStatusEffect(StatusEffect.DEBUFF_STAGGER, caster, target.shock,0);
					if(hasUpgrade(3) && !isShape && triggersEffects &&((Math.random() < 0.3 && !(source is Shape)) ||
																	   (Math.random() < 0.9 && source is Shape)))
						new Dummy(Dummy.TYPE_THUNDERSTORM, caster, 1000, 0,  (source is Shape) ? target : source);
					break;
						
				case TYPE_SHADOW:
					if(triggersEffects)
						target.addStatusEffect(StatusEffect.DEBUFF_BOMB,caster,target.bomb, damage);
					else if (hasUpgrade(2))
						target.addStatusEffect(StatusEffect.DEBUFF_BOMB,caster,target.bomb, damage / 2);
					if(hasUpgrade(3) && !isShape && triggersEffects &&((Math.random() < 0.2 && !(source is Shape)) ||
																	   (Math.random() < 0.5 && source is Shape)))
						new Dummy(Dummy.TYPE_BLACK_HOLE, caster, 1000, 0,  (source is Shape) ? target : source);
					break;
				
				case TYPE_ARCANE:
					target.addStatusEffect(StatusEffect.DEBUFF_GLYPH,caster,target.glyph,hasUpgrade(1) ? 0.3 : 0.2);
					if(hasUpgrade(2) && triggersEffects)
						new Dummy(Dummy.TYPE_MINE, caster, 2000, damage / 2, target);
					if(hasUpgrade(3) && !(source is Dummy))
						new Dummy(Dummy.TYPE_ARCANE_EXPLOSION, caster, 200, 0, target);
					break;
				
				case TYPE_POISON:
					if(triggersEffects)
						target.addStatusEffect(StatusEffect.DEBUFF_POISON, caster, target.poison,
							damage / (hasUpgrade(1) ? 10 : 5));
					if(hasUpgrade(2) && triggersEffects && !isShape)
						new Dummy(Dummy.TYPE_POISON_EXPLOSION, caster, 200, damage / 10, target);
					break;
				case TYPE_DARKNESS:
					break;
			}
			if(!(this == Element.POISON && triggersEffects))
				target.takeDamage(damage,source,caster,this);
		}
		
		//Special accessors
		/** Returns the Fire Element. Array must be initialised. @see Element#TYPE_FIRE **/
		public static function get FIRE(): Element 		{ return _vector[TYPE_FIRE] 	}
		/** Returns the Earth Element. Array must be initialised. @see Element#TYPE_EARTH **/
		public static function get EARTH(): Element 	{ return _vector[TYPE_EARTH] 	}
		/** Returns the Air Element. Array must be initialised. @see Element#TYPE_AIR **/
		public static function get AIR(): Element 		{ return _vector[TYPE_AIR] 		}
		/** Returns the Frost Element. Array must be initialised. @see Element#TYPE_FROST **/
		public static function get FROST(): Element 	{ return _vector[TYPE_FROST] 	}
		/** Returns the Thunder Element. Array must be initialised. @see Element#TYPE_THUNDER **/
		public static function get THUNDER(): Element 	{ return _vector[TYPE_THUNDER] 	}
		/** Returns the Shadow Element. Array must be initialised. @see Element#TYPE_SHADOW **/
		public static function get SHADOW(): Element 	{ return _vector[TYPE_SHADOW] 	}
		/** Returns the Arcane Element. Array must be initialised. @see Element#TYPE_ARCANE **/
		public static function get ARCANE(): Element 	{ return _vector[TYPE_ARCANE] 	}
		/** Returns the Poison Element. Array must be initialised. @see Element#TYPE_POISON **/
		public static function get POISON(): Element 	{ return _vector[TYPE_POISON] 	}
		/** Returns any of the first 8 elements at random. **/
		public static function get CHAOS(): Element 	{ return _vector[int(Math.random()*8)];}
		/** Returns the Darkness Element. Array must be initialised. @see Element#TYPE_DARKNESS **/
		public static function get DARKNESS(): Element 	{ return _vector[TYPE_DARKNESS] 	}
	}
}

class Lock{}