package AS.objects
{

	public class Friendly extends Actor {
		
		public function Friendly(maxHP:int, movementSpeed:Number, element: Element)
		{
			super(maxHP, movementSpeed, element);
			Model.friendlyVector.push(this);
		}
		
		override public function die(killer: Actor = null): void
		{
			super.die(killer);
			Model.friendlyVector.splice(Model.friendlyVector.indexOf(this),1);
		} 
	}
}