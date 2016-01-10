package AS.objects
{

	import AS.gems.BasicGem;
	import AS.gems.PowerGem;
	
	public class Spell extends UpgradableStatic implements Notifiable
	{
		
		/**
		 * Increases the Movement speed of the caster by 50% for 10 seconds. 30s cooldown.		<br/><br/>
		 * 
		 * Upgrade 1 - Increases movement speed bonus to 80%. 									<br/>
		 * Upgrade 2 - Creates a lava pool dealing 60% extra damage over 3 seconds. 			<br/>
		 **/
		public static const SPELL_HASTE: int = 0;
		/**
		 * Teleports to the mouse cursor's location. 12s cooldown.								<br/><br/>
		 * 
		 * Upgrade 1 - Reduces the cooldown to 8 seconds.	 									<br/>
		 * Upgrade 2 - Grants 50% movement speed for 3 seconds after teleporting.	 			<br/>
		 **/
		public static const SPELL_TELEPORT: int = 1;
		/**
		 * Rapidly charges to the mouse cursor's location. 10s cooldown.						<br/><br/>
		 * 
		 * Upgrade 1 - Allows a second use of this spell within 2 seconds. Adds 2s to cooldown.	<br/>
		 * Upgrade 2 - Knocks targets back while charging.	 									<br/>
		 **/
		public static const SPELL_RUSH: int = 2;
		/**
		 * Shields the caster, granting full damage immunity for 3 seconds. 30s cooldown.		<br/><br/>
		 * 
		 * Upgrade 1 - Reduces cooldown to 20 seconds. 30s cooldown.							<br/>
		 * Upgrade 2 - Grants 5% healing per second while this spell is active.					<br/>
		 **/
		public static const SPELL_SHIELD: int = 3;
		/**
		 * Shields the caster, reflecting the next projectile attack within 3 seconds. 30s CD	<br/><br/>
		 * 
		 * Upgrade 1 - Heals for 20% if it reflects a spell, but only lasts 1 second.			<br/>
		 * Upgrade 2 - Reflected spells deal 50% increased damage.								<br/>
		 **/
		public static const SPELL_REFLECT: int = 4;
		/**
		 * Stops time for 2 seconds, freezing enemies, buffs and debuffs. 30s cooldown.			<br/><br/>
		 * 
		 * Upgrade 1 - Time Stop now lasts 3 seconds.											<br/>
		 * Upgrade 2 - While frozen, all enemies take 50% increased damage.						<br/>
		 **/
		public static const SPELL_TIME_STOP: int = 5;
		/**
		 * Spawns a turret at the mouse location, which shoots nearby enemies for 8s. 30s CD	<br/><br/>
		 * 
		 * Upgrade 1 - Turret occasionally fires the Fire Cone shape.							<br/>
		 * Upgrade 2 - Turret lasts for 12 seconds												<br/>
		 **/
		public static const SPELL_TURRET: int = 6;
		/**
		 * Doubles the caster's attack speed for 5 seconds. 20s cooldown.						<br/><br/>
		 * 
		 * Upgrade 1 - Attack speed is quadrupled, but only lasts 3 seconds.					<br/>
		 * Upgrade 2 - Affects damage instead of Attack Speed.									<br/>
		 **/
		public static const SPELL_BURST: int = 7;
		/**
		 * Resets the cooldown of the most recently cast Shape spell. 12s cooldown.				<br/><br/>
		 * 
		 * Upgrade 1 - This spell's cooldown is equal to the amount of cooldown time reduced.	<br/>
		 * Upgrade 2 - The next Shape after casting this spell deals 50% increased damage.		<br/>
		 **/
		public static const SPELL_RELAPSE: int = 8;
		/**
		 * Heals the target for 40% of their maximum HP. 30s cooldown.							<br/><br/>
		 * 
		 * Upgrade 1 - Increases the healing amount to 60% of maximum HP.						<br/>
		 * Upgrade 2 - Knocks back nearby enemies on casting.									<br/>
		 **/
		public static const SPELL_HEAL: int = 9;
		/**
		 * Restores 60% of the caster's maximum HP over 12 seconds. 30s CD.						<br/><br/>
		 * 
		 * Upgrade 1 - Regenerates 100% of the caster's maximum HP over 24 seconds.				<br/>
		 * Upgrade 2 - While active, 5% chance per second to reset a random Shape's cooldown.	<br/>
		 **/
		public static const SPELL_REGENERATE: int = 10;
		/**
		 * Creates an area of Holy Ground at the cursor, healing anything within for 20%/s
		 * for 4 seconds. 30s CD.																<br/><br/>
		 * 
		 * Upgrade 1 - The Holy Ground knocks foes away every second.							<br/>
		 * Upgrade 2 - Lasts for 6 seconds, healing the same amount per second.					<br/>
		 **/
		public static const SPELL_HOLY_GROUND: int = 11;
		
		
		/** Time, according to Notifier, that this spell was cast. Used to track cooldown **/
		private var _timeCast: int = -15000;
		private var _cooldown: int;
		private var _ready: Boolean = true;
		/** A vector containing each spell in order. Elements are externally accessed accessors **/
		private static var _vector:Vector.<Spell> =  new Vector.<Spell>();
		
		public function Spell(type: int, name: String, description: String, doNotInstantiate: Lock)
		{
			super(type, name, description, UpgradableStatic.key);
			_cooldown = getCooldown();
		} 
		
		/**
		 * Instantiates the class, allowing spellal accessors to be used. 
		 * This should be called as early as possible, and must be called before any accessors are used.
		 **/
		public static function init(): void 
		{
			var key: Lock = new Lock();
			_vector = Vector.<Spell>([
				new Spell(0, "Haste", "Increases caster's Movement speed by 50% for 10 seconds. 30 second cooldown.", key),
				new Spell(1, "Teleport", "Teleports to the target location. 12 second cooldown.", key),
				new Spell(2, "Propel", "Launches the caster rapidly toward the cursor. 10 second cooldown.", key),
				new Spell(3, "Shield", "Protects the caster from all damage for 3 seconds. 30 second cooldown.", key),
				new Spell(4, "Reflect", "Reflects missiles that hit the caster for 3 seconds. 30 second cooldown.", key),
				new Spell(5, "Time Stop", "Stops time entirely for 2 seconds. 20 second cooldown.", key),
				new Spell(6, "Turret", "Creates a turret for 8 seconds. 30 second cooldown.", key),
				new Spell(7, "Burst", "Doubles attack speed for 5 seconds. 20 second cooldown.", key),
				new Spell(8, "Relapse", "Resets your most recently cast shapes. 12 second cooldown.", key),
				new Spell(9, "Heal", "Restores 40% of the caster's health. 30 second cooldown.", key),
				new Spell(10, "Regenerate", "Restores 60% of the wizard's HP over 12 seconds. 30 second cooldown.", key),
				new Spell(11, "Holy Ground", "Creates an area on the ground for 4 seconds. healing 20% per second." +
					" 30 second cooldown.", key)]);
		}
		
		public function cast(caster: Actor, targetX: int = -1, targetY: int = -1): void 
		{
			if(type != SPELL_RUSH && type != SPELL_RELAPSE)
				startCooldown(getCooldown());	
			switch(type){
				case SPELL_HASTE:
					caster.addStatusEffect(StatusEffect.BUFF_HASTE, caster, caster.haste);
					break;
				case SPELL_TELEPORT:
					new Dummy(Dummy.TYPE_BLINK_EFFECT, caster, 400, 0, caster);
					if(Model.distBetweenPts(caster.x, targetX, caster.y, targetY) < 150)
					{
						caster.x = targetX;
						caster.y = targetY;
					} else {
						var angle: Number = Model.angleBetweenPts(targetX, caster.x,
																  targetY, caster.y);
						caster.x+=100*Math.sin(angle);
						caster.y-=100*Math.cos(angle);
					}
					if(hasUpgrade(2))
						caster.addStatusEffect(StatusEffect.BUFF_TELEPORT, caster)
					break;
				case SPELL_RUSH:
					caster.addForce(30,Model.toDegrees(
						Model.angleBetweenPts(targetX, caster.x,targetY, caster.y)));
					if(hasUpgrade(1))
						if(Model.notifier.time - _timeCast < 12000)
							startCooldown(12000);
						else
							startCooldown(500);
					else
						startCooldown(10000);
					if(hasUpgrade(2))
						caster.addStatusEffect(StatusEffect.BUFF_BULL_RUSH, caster);
					break;
				case SPELL_SHIELD:
					caster.addStatusEffect(StatusEffect.BUFF_SHIELD, caster,caster.shield);
					break;
				case SPELL_REFLECT:
					caster.addStatusEffect(StatusEffect.BUFF_REFLECT, caster, caster.shield);
					break;
				case SPELL_TIME_STOP:
					Model.notifier.timeStop(hasUpgrade(1)? 3000: 2000);
					Model.stage.sepia = true;
					if(hasUpgrade(2))
						caster.addStatusEffect(StatusEffect.BUFF_TIME_STOP, caster);
					break;
				case SPELL_BURST:
					caster.addStatusEffect(StatusEffect.BUFF_BURST, caster, caster.burst);
					break;
				case SPELL_RELAPSE:
					var longestCD: int = 0, relapsedShape: Shape = null;
					for each (var shape: Shape in Model.shapes)
					{
						if(shape.isReady)
							continue;
						if(Model.shapeCooldown - Model.notifier.time + shape.timeCast > longestCD)
						{
							longestCD = Model.shapeCooldown - Model.notifier.time + shape.timeCast;
							relapsedShape = shape;
						}
					}
					if(relapsedShape != null)
					{
						relapsedShape.resetCooldown();
						if(hasUpgrade(2))
							relapsedShape.empower(1.5);
						if(hasUpgrade(1))
							startCooldown(longestCD);
						else
							startCooldown(12000);
					} else 
						startCooldown(500);
					Model.stage.flash();
					break;
				case SPELL_HEAL:
					caster.healPercent(hasUpgrade(1)?0.6:0.4,caster);
					new Dummy(Dummy.TYPE_HEAL_EFFECT, caster, 400,0, caster);
					if(hasUpgrade(2))
						new Dummy(Dummy.TYPE_SHOCKWAVE, caster, 400, 0, caster);
					break;
				case SPELL_REGENERATE:
					caster.addStatusEffect(StatusEffect.BUFF_REGENERATE, caster, caster.regen);
					break;
				case SPELL_HOLY_GROUND:
					new Dummy(Dummy.TYPE_HOLY_GROUND, caster, hasUpgrade(2) ? 6000 : 4000, 0, null, targetX, targetY);
					break;
				case SPELL_TURRET:
					new Dummy(Dummy.TYPE_TURRET, caster, hasUpgrade(2) ? 12000 : 8000, 10, null, targetX, targetY);
					break;
				default:
					break;
			}
			_ready = false;
			_timeCast = Model.notifier.time;
			if(type >= SPELL_HEAL && type <= SPELL_HOLY_GROUND)
			{
				if(BasicGem.DEFENSE_AFTER_HEAL.active)
					caster.addStatusEffect(StatusEffect.BUFF_CONSISTENCY, caster);
				if(PowerGem.RIPPLES.active)
					Model.spells[1].reduceCooldown(10000);
			}
			if(type >= SPELL_SHIELD && type <= SPELL_TIME_STOP)
				if(BasicGem.HEAL_CD.active)
					Model.spells[3].reduceCooldown(8000);
			if(type >= SPELL_TURRET && type <= SPELL_RELAPSE)
				if(PowerGem.RIPPLES.active)
					Model.spells[0].resetCooldown();
			if(PowerGem.RYZE.active)
				Model.reduceShapeCooldowns(1000);
		}
		
		private function startCooldown(duration: int): void 
		{
			_cooldown = duration;
			Model.notifier.requestNotification(this, duration, 0);	
		}
		
		private function getCooldown(): int 
		{  
			return basicCooldown * Model.spellCooldownMod;
		}
		
		private function get basicCooldown(): int 
		{
			switch(type)
			{
				case SPELL_HASTE:
					return 30000 * Model.spellCooldownMod;
					break;
				case SPELL_TELEPORT:
					return (hasUpgrade(1) ? 8000 : 12000);
					break;
				case SPELL_RUSH:
					return (hasUpgrade(1) ? 12000 : 10000);
				case SPELL_SHIELD:
					return (hasUpgrade(1) ? 20000 : 30000);
				case SPELL_REFLECT:
						return 20000;
				case SPELL_TIME_STOP:
					return 20000;
				case SPELL_TURRET:
					return 300;
				case SPELL_BURST:
					return 20000;
				case SPELL_RELAPSE:
					return 12000;
				case SPELL_HEAL:
				case SPELL_REGENERATE:
					return 30000;
				case SPELL_HOLY_GROUND:
					return 30000
				default:
					return 9999999;
			}
		}
		
		public function notify(ref: int): void
		{
			if(ref==0)
				_ready = true;
		}
		
		public static function get(spell: int): Spell { return _vector[spell]; }
		
		public function reduceCooldown(amount: int): void
		{
			Model.notifier.stopRequest(this, 0);
			if(cooldown - Model.notifier.time + _timeCast - amount < 0)
			{
				notify(0);
				return;
			}
			Model.notifier.requestNotification(this, cooldown - 
				Model.notifier.time + _timeCast - amount, 0);
			_timeCast -= amount;
			
		}
		
		public function resetCooldown(): void 
		{
			Model.notifier.stopRequest(this, 0);
			_ready = true;
		}
		
		/** Returns the Haste Spell. Array must be initialised. @see Spell#SPELL_HASTE **/
		public static function get HASTE(): Spell { return _vector[SPELL_HASTE] }
		/** Returns the Teleport Spell. Array must be initialised. @see Spell#SPELL_TELEPORT **/
		public static function get TELEPORT(): Spell { return _vector[SPELL_TELEPORT] }
		/** Returns the Rush Spell. Array must be initialised. @see Spell#SPELL_RUSH **/
		public static function get RUSH(): Spell { return _vector[SPELL_RUSH] }
		/** Returns the Shield Spell. Array must be initialised. @see Spell#SPELL_SHIELD **/
		public static function get SHIELD(): Spell { return _vector[SPELL_SHIELD] }
		/** Returns the Reflect Spell. Array must be initialised. @see Spell#SPELL_REFLECT **/
		public static function get REFLECT(): Spell { return _vector[SPELL_REFLECT] }
		/** Returns the Time Stop Spell. Array must be initialised. @see Spell#SPELL_TIME_STOP **/
		public static function get TIME_STOP(): Spell { return _vector[SPELL_TIME_STOP] }
		/** Returns the Turret Spell. Array must be initialised. @see Spell#SPELL_TURRET **/
		public static function get TURRET(): Spell { return _vector[SPELL_TURRET] }
		/** Returns the Burst Spell. Array must be initialised. @see Spell#SPELL_BURST **/
		public static function get BURST(): Spell { return _vector[SPELL_BURST] }
		/** Returns the Relapse Spell. Array must be initialised. @see Spell#SPELL_RELAPSE **/
		public static function get RELAPSE(): Spell { return _vector[SPELL_RELAPSE] }
		/** Returns the Heal Spell. Array must be initialised. @see Spell#SPELL_HEAL **/
		public static function get HEAL(): Spell { return _vector[SPELL_HEAL] }
		/** Returns the Regenerate Spell. Array must be initialised. @see Spell#SPELL_REGENERATE **/
		public static function get REGENERATE(): Spell { return _vector[SPELL_REGENERATE] }
		/** Returns the Holy Ground Spell. Array must be initialised. @see Spell#SPELL_HOLY_GROUND **/
		public static function get HOLY_GROUND(): Spell { return _vector[SPELL_HOLY_GROUND] }

		public function get timeCast():int				{ return _timeCast; 	}
		public function get isReady():Boolean 			{ return _ready; 		}
		public function get cooldown(): int 			{ return _cooldown 		}

		
	}
}

class Lock {}