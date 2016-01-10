package AS.objects {
	
	import AS.gems.BasicGem;
	import AS.gems.PowerGem;
	import AS.main.Controller;
	
	import flash.display.MovieClip;
	
	//TODO: Singleton
	public class Wizard extends Friendly implements Notifiable {
		
		private static const XP_CURVE: Array = [100,230,410,640,940,1340,1870,2570,3490,4690,6290,8390,11190,14890,19890];
		private var _safeguardReady: Boolean = true;
		//Levelling and stats
		private var _killVamp:Number = 0;
		private var _kills: int = 0, _xp: int = 110, _level:int = 1;
		
		public function Wizard(element: Element) 
		{
			gotoAndStop(1);
			x = 300;
			y = 200;
			super(100,0.6, element);
			this.addStatusEffect(StatusEffect.STATE_NOT_MOVING, this); //Get the ball rolling.
		}
		
		override public function attack(): void 
		{
			if(Controller.isClicked)
			{
				_attackReady = false;
				new Missile(element, this, Model.stage.mouseX, Model.stage.mouseY, 10, true, this, true);
				if(PowerGem.ELEMENTS.active)
				{
					for(var i = 0; i < 4; i++)
					{
						if(Model.shapes[i].isReady)
							break;
						if(i == 3 && Math.random() < 0.35)
						{
							Model.notifier.requestNotification(this, 100,0);
							return;
						}	
					}
				}
				Model.notifier.requestNotification(this, 1000/attackSpeed,0);
			}
		}
		
		override public function move(): void 
		{ 
			var up = 0; var right = 0;
			if(Controller.wasd[0] == true)
				up ++;
			if(Controller.wasd[1] == true)
				right --;
			if(Controller.wasd[2] == true)
				up --;
			if(Controller.wasd[3] == true)
				right ++;
			if(up==0 && right == 0)
				return;
			if(this.hasStatusEffect(StatusEffect.STATE_NOT_MOVING))
				this.addStatusEffect(StatusEffect.STATE_MOVING, this);
			//Credit to Milosz Gaczkowski for the compact logic in the next line
			addForce(1, (up==0)? right * 90 : ((up - 1) * 90 + (45 * right * up)), true)
			//addForce(1, (up==-1)? 180 - right * 45 : right * 45 * (2 - up), true);
			//PS: My version (^) works just as well >:-D
		}
		
		override public function takeDamage(damage: Number, source: MovieClip, damageSource: Actor,
								   type: Element) : void 
		{
			super.takeDamage(damage, source, damageSource, type);
			if(Spell.HASTE.hasUpgrade(2) && this.hasStatusEffect(StatusEffect.BUFF_HASTE))
				new Dummy(Dummy.TYPE_SHOCKWAVE, this, 200, 0, this);
			if(PowerGem.SAFEGUARD.active)
				if(this.percentageHP <= 0.2 && ((this.hp + damage) / maxHP) > 0.2)
					safeguardReset();
			this.removeStatusType(StatusEffect.BUFF_DOMINANCE);
			var strut: StatusEffect = this.getStatusEffect(StatusEffect.BUFF_STRUT);
			if(strut != null)
				strut.strength = 0;
		}
		
		private function safeguardReset():void
		{
			if(!_safeguardReady)
				return;
			_safeguardReady = false;
			Model.notifier.requestNotification(this, 120000, 10);
			for(var i: int = 0; i < 4; i++)
			{
				Model.spells[i].resetCooldown();
				Model.shapes[i].resetCooldown();
			}
		}
		
		override public function notify(ref: int): void
		{
			//trace(attackSpeed);
			if(ref == 10)
				_safeguardReady = true;
			else
				super.notify(ref);
		}
		
		override public function die(killer: Actor = null): void
		{
			healPercent(100, this);
		}
		
		public function addKill(foe: Actor): void
		{
			this.healPercent(killVamp, this);
			if(BasicGem.SNOWBALL_DAMAGE.active)
				this.addStatusEffect(StatusEffect.BUFF_SNOWBALL,this, null, 0.02);
			if(PowerGem.DOMINANCE.active)
				this.addStatusEffect(StatusEffect.BUFF_DOMINANCE,this, null, 0.03);
			_kills++;
			//trace("Killed an " + foe + ". Kill count: " + _kills);
			if(_kills == 100)
				trace("Okay, you're probably done testing. Back to work.");
			if(_kills == 200)
				trace("Enough killing stuff! Get back to coding!");
			if(_kills == 500)
				trace("This is getting silly now. You don't need to test for this long.");
			if(_kills == 1000)
				trace("STOP PLAYING, START CODING, ALREADY. JESUS.");
			//XP tracking
			if(foe is Enemy)
				switch((foe as Enemy).type)
				{
					case Enemy.ENEMY_GOBLIN:
						addXP(10);
						break;
					case Enemy.ENEMY_SHIELDER:
						addXP(15);
						break;
				}
		}
		
		public function addXP(amount: int): void
		{
			_xp += amount;
			//Check for level up.
			if(level==15)
				return;
			for(var i = 0; i< 15; i++)
				if(i + 1 > level && XP_CURVE[i] <= _xp)
					levelUp();
		}
		
		public function levelUp(): void
		{
			trace("LEVEL UP");
			_level += 1;
			Model.stage.levelUp();
		}
		
		public function get percentXP(): Number
		{
			if(level == 15)
				return 1;
			if(level == 0)
				return _xp / 100;
			for(var i = 0; i< 15; i++)
				if(i + 1 > level && XP_CURVE[i] > _xp)
					return (_xp - XP_CURVE[i-1])/(XP_CURVE[i] - XP_CURVE[i-1]);
			return 0;			
		}

		public function get killVamp():Number			{ return _killVamp;	}
		public function set killVamp(value:Number):void	{ _killVamp = value;}
		public function get level():int					{ return _level; }


	}
}
