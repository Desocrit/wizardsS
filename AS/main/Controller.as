package AS.main
{
	import AS.objects.Element;
	import AS.objects.Model;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class Controller
	{
		private static var _isClicked: Boolean = false;
		//LMB, 1234, WASD, QERF.
		private static var _wasd: Vector.<Boolean>;
		
		public static function init(stage: Stage, overlay: MovieClip)
		{
			wasd = Vector.<Boolean>([false, false, false, false]);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);
			overlay.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			overlay.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
		}
		
		private static function mouseDown(e: MouseEvent)
		{
			isClicked = true;
		}
		
		private static function mouseUp(e: MouseEvent)
		{
			isClicked = false;
		}
		
		private static function keyDown(e: KeyboardEvent)
		{
			trace(e.keyCode);
			switch(e.keyCode)
			{
				case 87:
					wasd[0] = 1;
					break;
				case 65:
					wasd[1] = 1;
					break;
				case 83:
					wasd[2] = 1;
					break;
				case 68:
					wasd[3] = 1;
					break;	
				case 81:
					if(Model.spells[0].isReady)
						Model.spells[0].cast(Model.player,Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 69: 
					if(Model.spells[1].isReady)
						Model.spells[1].cast(Model.player,Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 82: 
					if(Model.spells[2].isReady)
						Model.spells[2].cast(Model.player,Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 70: 
					if(Model.spells[3].isReady)
						Model.spells[3].cast(Model.player,Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 49:
					if(Model.shapes[0].isReady)
						Model.shapes[0].cast(Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 50:
					if(Model.shapes[1].isReady)
						Model.shapes[1].cast(Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 51:
					if(Model.shapes[2].isReady)
						Model.shapes[2].cast(Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 52:
					if(Model.shapes[3].isReady)
						Model.shapes[3].cast(Model.stage.mouseX, Model.stage.mouseY);
					break;
				case 187:
				case 107:
					Model.stage.changeEnemies(true);
					break;
				case 189:
				case 109:
					Model.stage.changeEnemies(false);
					break;
				case 16:
					Model.notifier.paused = true;
					Model.stage.hintsShown = true;
					break;
			}
		}
		
		private static function keyUp(e: KeyboardEvent)
		{
			switch(e.keyCode)
			{
				case 87:
					wasd[0] = 0;
					break;
				case 65:
					wasd[1] = 0;
					break;
				case 83:
					wasd[2] = 0;
					break;
				case 68:
					wasd[3] = 0;
					break;
				case 16:
					Model.notifier.paused = false;
					Model.stage.hintsShown = false;
					break;
			}
		}
		
		public static function get isClicked():Boolean
		{
			return _isClicked;
		}
		
		public static function set isClicked(value:Boolean):void
		{
			_isClicked = value;
		}		
		
		public static function get wasd():Vector.<Boolean>
		{
			return _wasd;
		}
		
		public static function set wasd(value:Vector.<Boolean>):void
		{
			_wasd = value;
		}
		
	}
}


