package AS.gems
{
	/**
	 * Truly, truly, truly outrageous.
	 **/
	public interface Gem
	{	
		
		function get type(): int;
		
		function get name(): String;
		
		function get description(): String;
		
		function get owned(): Boolean;
		
		function set owned(value: Boolean): void;
		
		function get active(): Boolean;
		
		function set active(value: Boolean): void;
		
	}
}