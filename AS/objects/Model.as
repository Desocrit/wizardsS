package AS.objects
{
	import AS.gems.*;
	import AS.main.Notifier;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class Model
	{
		private static var _shapeCooldown: int = 15000;
		private static var _spellCooldownMod: Number = 1, _shapeRange: Number = 1;
		private static var _player: Wizard;
		private static var _stage: MovieClip;
		private static var _notifier: Notifier;
		private static var _paused: Boolean, _timeStopped: Boolean; // Time
		private static var _enemyVector: Vector.<Enemy>, _friendlyVector: Vector.<Friendly>;
		private static var _missileVector: Vector.<Missile>, _dummyVector: Vector.<Dummy>;
		private static var _spells: Vector.<Spell> = new Vector.<Spell>(4, true);
		private static var _shapes: Vector.<Shape> = new Vector.<Shape>(4, true);
		private static var _basicGems: Vector.<BasicGem>, _focusGems: Vector.<FocusGem>;
		private static var _elementalGems: Vector.<ElementalGem>, _powerGems: Vector.<PowerGem>;
		
		//Useful maths functions.
		public static function toDegrees(rads: Number): Number
		{
			return rads * 180 / Math.PI;
		}
		
		public static function toRads(degrees: Number): Number
		{
			return degrees * Math.PI / 180;
		}
		
		public static function distBetween(a: DisplayObject,
										   b: DisplayObject): Number 
		{
			return Math.pow(Math.pow(Math.abs(a.x - b.x),2) +
				Math.pow(Math.abs(a.y - b.y),2) , 0.5);
		}
		
		public static function distBetweenPts(x1: int, x2: int,
											  y1: int, y2: int) : Number
		{
			return Math.pow(Math.pow(Math.abs(x1 - x2),2) +
				Math.pow(Math.abs(y1 - y2),2) , 0.5);
		}
		
		public static function angleBetween(a: DisplayObject,
											b: DisplayObject): Number 
		{
			return angleBetweenPts(a.x, b.x, a.y, b.y);
		}
		
		public static function angleBetweenPts(x1: int, x2: int, y1: int, y2: int): Number 
		{
			var angle: Number = Math.atan2(x1 - x2, -y1 + y2);
			if(angle > Math.PI)
				angle -= Math.PI * 2;
			if(angle < -Math.PI)
				angle += Math.PI;	
			return angle;
		}
		
		public static function getTargetArray(caster: Actor): Vector.<Actor>
		{
			var targetArray: Vector.<Actor> = new Vector.<Actor>();
			if(friendlyVector.indexOf(caster)==-1)
				targetArray = targetArray.concat(friendlyVector);
			if(enemyVector.indexOf(caster)==-1) //May cat both, for neutral targets.
				targetArray = targetArray.concat(enemyVector);
			return targetArray;
		}
		
		public static function getFriendlyArray(caster: Actor): Vector.<Actor>
		{
			var targetArray: Vector.<Actor> = new Vector.<Actor>();
			if(friendlyVector.indexOf(caster)!=-1)
				targetArray = targetArray.concat(friendlyVector);
			if(enemyVector.indexOf(caster)!=-1) //May cat both, for neutral targets.
				targetArray = targetArray.concat(enemyVector);
			return targetArray;
		}
		
		public static function getClosestActor(targetX: int, targetY: int,
										 caster: Actor, excluded: Actor = null): Actor
		{			
			var dist: int = 9001, delta: int;
			var possibleTargets: Vector.<Actor> = Model.getTargetArray(caster);
			var closestTarget: Actor;
			if(possibleTargets.length == 0)
				return null
			for each (var target: Actor in possibleTargets)
			{
				if(target==excluded)
					continue;
				delta = Model.distBetweenPts(target.x,targetX,target.y,targetY);
				if(delta < dist) 
				{
					closestTarget=target;
					dist=delta;
				}
			}
			return closestTarget;
		}
		
		public static function numShapesReady(): int
		{
			var value = 0;
			for each(var shape: Shape in shapes)
				if(shape.isReady)
					value++;
			return value;
		}
		
		public static function reduceShapeCooldowns(time: int): void
		{
			for(var i: int = 0; i < 4; i++)
				shapes[i].reduceCooldown(time);
		}
		
		public static function initArrays(stage: MovieClip): void {
			Element.init();
			Spell.init();
			BasicGem.init();
			FocusGem.init();
			ElementalGem.init();
			PowerGem.init();
			_stage = stage;
			_notifier = new Notifier();
			_enemyVector = new Vector.<Enemy>();
			_friendlyVector = new Vector.<Friendly>();
			_dummyVector = new Vector.<Dummy>();
			_missileVector = new Vector.<Missile>();
			
		}
		
		// Initialising common variables
		public static function initObjects(element: Element, spells: Array, shapes: Array, elements: Array,
											basicGems: Array, elementGems: Array, focusGems: Array, powerGems: Array): void 
		{
			_player = new Wizard(element);
			for(var i: int = 0; i < 4; i++)
			{
				_spells[i] = spells[i];
				_shapes[i] = new Shape(shapes[i], elements[i], _player);
			}
			_basicGems = Vector.<BasicGem>(basicGems);
			_focusGems = Vector.<FocusGem>(focusGems);
			_elementalGems = Vector.<ElementalGem>(elementGems);
			_powerGems = Vector.<PowerGem>(powerGems);
			for each(var gem: Gem in gems)
			if(gem != null)
				gem.active = true;
		}
		
		public static function set animationsRunning(value: Boolean): void
		{
			for each(var actor: Actor in actorVector)
				for each(var status: StatusEffect in actor.statusEffects)
					status.effectRunning = value;
		}
		
		//Gem handling
		
		public static function get gems(): Vector.<Gem>
		{
			return Vector.<Gem>(_basicGems).concat(Vector.<Gem>(_elementalGems)).concat(
				Vector.<Gem>(_focusGems)).concat(Vector.<Gem>(_powerGems));
		}
		
		public static function setBasicGem(index: int, gem: BasicGem)
		{
			if(_basicGems[index] != null)
				_basicGems[index].active = false;
			_basicGems[index] = gem;
			_basicGems[index].active = true;
		}
		
		public static function setFocusGem(index: int, gem: FocusGem)
		{
			if(_focusGems[index] != null)
				_focusGems[index].active = false;
			_focusGems[index] = gem;
			_focusGems[index].active = true;
		}
		
		public static function setElementalGem(index: int, gem: ElementalGem)
		{
			if(_elementalGems[index] != null)
				_elementalGems[index].active = false;
			_elementalGems[index] = gem;
			_elementalGems[index].active = true;
		}
		
		public static function setPowerGem(index: int, gem: PowerGem)
		{
			if(_powerGems[index] != null)
				_powerGems[index].active = false;
			_powerGems[index] = gem;
			_powerGems[index].active = true;
		}
		
		// Accessors for common variables
		public static function get actorVector(): Vector.<Actor>		
		{ 
			return Vector.<Actor>(_enemyVector).concat(Vector.<Actor>(_friendlyVector));
		}
		//Objects
		public static function get player():Wizard 						{ return _player; 			}
		public static function get stage():MovieClip					{ return _stage;			}
		public static function get notifier():Notifier					{ return _notifier;			}
		//Stats
		public static function get shapeCooldown(): int					{ return _shapeCooldown; 	}
		public static function set shapeCooldown(value:int):void		{ _shapeCooldown = value; 	}
		public static function get spellCooldownMod():Number			{ return _spellCooldownMod; }
		public static function set spellCooldownMod(value:Number):void	{ _spellCooldownMod = value;}
		public static function get shapeRange():Number					{ return _shapeRange;		}
		public static function set shapeRange(value:Number):void		{ _shapeRange = value;		}
		//Vectors
		public static function get enemyVector(): Vector.<Enemy>		{ return _enemyVector;		}
		public static function get friendlyVector(): Vector.<Friendly>	{ return _friendlyVector;	}
		public static function get dummyVector(): Vector.<Dummy>		{ return _dummyVector;		}
		public static function get missileVector(): Vector.<Missile>	{ return _missileVector;	}
		public static function get spells():Vector.<Spell>				{ return _spells; 			}
		public static function get shapes():Vector.<Shape>				{ return _shapes; 			}
		//Gems
		public static function get basicGems():Vector.<BasicGem>		{ return _basicGems;		}
		public static function get elementalGems():Vector.<ElementalGem>{ return _elementalGems;	}
		public static function get focusGems():Vector.<FocusGem>		{ return _focusGems;		}
		public static function get powerGems():Vector.<PowerGem>		{ return _powerGems;		}

	}
}