package AS.objects
{
	public class UpgradableStatic
	{
		/**
		 * A number representing the elemental type of this element.
		 * Comparisons should almost always use the static constants.
		 **/
		private var _type: int;
		/** Add 1 for upgrade 1, 2 for upgrade 2, 4 for upgrade 3. **/
		private var _upgrades: int = 0, _name: String, _description: String;
				
		/**
		 * PRIVATE CONSTRUCTOR. Cannot and should not be externally instantiated.
		 **/
		public function UpgradableStatic(type: int, name: String, description: String, key: Lock) 
		{
			_type = type;
			_name = name;
			_description  = description;
		}
		
		//To allow instantiation by subclasses.
		protected static function get key(): Lock 
		{
			return new Lock();
		}
		
		/**
		 * Should be overridden, and the overridden version called.
		 **/
		public function init(): void {
			throw new Error("Type is an abstract class, and should not be initialized");
		}
		
		/**
		 * Adds a specific upgrade to this element. If the upgrade is already unlocked, this method will do nothing.
		 *  
		 * @param upgrade An int representing upgrade number to be added.
		 * 
		 **/
		public function addUpgrade(upgrade: int): void 
		{
			if(!hasUpgrade(upgrade))
				_upgrades += Math.pow(2, upgrade);				
		}
		
		/**
		 * Removes a specific upgrade from this element, if it has that upgrade. Does nothing if not.
		 *  
		 * @param upgrade An int representing the upgrade number to be removed.
		 * 
		 **/
		public function removeUpgrade(upgrade: int): void 
		{
			if(hasUpgrade(upgrade))
				_upgrades -= Math.pow(2, upgrade);	
		}
		
		/**
		 * Tests if the element has a specific upgrade level active.
		 *  
		 * @param query The upgrade to be tested for.
		 * @return Whether the specified element has that upgrade active.
		 * 
		 **/
		public function hasUpgrade(query: int): Boolean 
		{
			if(query <= 0)
				return false;
			return ((_upgrades >> query) % 2 == 1);	
		}
		
		/**
		 * Returns the static constant representing the element. This can be useful for comparisons to
		 * similarly formatted arrays, however generally comparisons to specific elements or static constants
		 * should be used.
		 *  
		 * @return An integer representing the elemental type of this element. Can be compared to the static constants.
		 * 
		 **/
		public function get type():int 				{ return _type; }
		public function get name():String			{ return _name; }
		public function get description():String	{ return _description; }
	}
}

class Lock {}