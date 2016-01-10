package AS.main 
{
	
	import AS.gems.*;
	import AS.objects.Element;
	import AS.objects.Enemy;
	import AS.objects.Model;
	import AS.objects.Shape;
	import AS.objects.Spell;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	public class View extends MovieClip 
	{
		private var _icons = new Array();
		private var _numEnemies:uint = 0;
		private var _unusedSkillPoints = 0;
		private var _changedItem: MovieClip, _changedItemIndex: int = 0;
		//Skill Icons
		public var shapeIcon0: MovieClip, shapeIcon1: MovieClip, shapeIcon2: MovieClip, shapeIcon3: MovieClip;
		public var healIcon: MovieClip, utilityIcon0: MovieClip, utilityIcon1: MovieClip, utilityIcon2: MovieClip;
		//Basic MovieClips.
		public var menu: MovieClip, menuPopup: MovieClip, overlay: MovieClip, healthBar: MovieClip
		
		public function View() 
		{
			trace(4 * Math.tan(Model.toRads(30)));
			gotoAndStop(1);
			stage.addEventListener(Event.ENTER_FRAME,Preloaded);
		}
		
		private function Preloaded(e:Event): void
		{
			if(this.stage.loaderInfo.bytesTotal==this.stage.loaderInfo.bytesLoaded)
			{
				stage.removeEventListener(Event.ENTER_FRAME,Preloaded);
				gotoAndStop(20);
				CombatStart(2);
			}
		}
		
		private function CombatStart(Difficulty:int): void
		{
			//Initiate Model
			Model.initArrays(this);
			Model.initObjects(Element.FIRE,
				[Spell.HASTE, Spell.TIME_STOP, Spell.TURRET, Spell.HOLY_GROUND], //Spells
				[Shape.SHORT_CONE, Shape.WALL, Shape.ZONE, Shape.RING], //Shapes
				[Element.FIRE, Element.AIR, Element.SHADOW, Element.POISON], //Shape elements
				[null, null, null, null, null], [null, null, null, null], //Starting Gems
				[null, null, null, null], [null, null]);			
			//Initiate View
			overlay.gotoAndStop(1);
			_icons = [shapeIcon0,shapeIcon1,shapeIcon2,shapeIcon3,healIcon,utilityIcon0,utilityIcon1,utilityIcon2];
			for(var a:int = 0;a<4;a++)
			{
				_icons[a].Outline.gotoAndStop(2);
				_icons[a+4].Outline.gotoAndStop(1);
			}
			updateIcons();
			//Initiate Controller
			Controller.init(stage, overlay);
			addMainListeners();
		}
		
		private function openMenu(e:MouseEvent): void
		{
			if(Model.player.level == 0)
				return;
			Model.animationsRunning = false;
			removeMainListeners();
			menuPopup.gotoAndStop(12);
			menu.gotoAndStop(2);
			menu.selector.gotoAndStop(1);
			menu.xpbar.gotoAndStop(int(Model.player.percentXP * 100));
			menu.xpbar.text.text = "Level " + Model.player.level;
			menu.tooltip.gotoAndStop(1);
			sortMenuIcons();
			addMenuListeners();
		}
		
		private function sortMenuIcons(): void
		{
			setupUpgradeIcon(Model.powerGems[0], menu.power.icon0);
			setupUpgradeIcon(Model.powerGems[1], menu.power.icon1);
			menu.element.gotoAndStop(Model.player.element.type + 1);
			if(Model.powerGems[0] == null)
			{
				menu.basicIcons.getChildByName("icon" + i).gotoAndStop(1);
				menu.basicIcons.getChildByName("icon" + i).overlay.gotoAndStop(2);
			}
			for(var i: int = 0; i < 5; i++)
			{
				setupUpgradeIcon(Model.basicGems[i], menu.basicIcons.getChildByName("icon" + i));
				if(i==4)
					break;
				setupUpgradeIcon(Model.focusGems[i], menu.focusIcons.getChildByName("icon" + i));
				setupUpgradeIcon(Model.elementalGems[i], menu.elementIcons.getChildByName("icon" + i));
				menu.spells.getChildByName("icon" + i).gotoAndStop(Model.spells[i].type + 2);
				menu.shapes.getChildByName("icon" + i).gotoAndStop(1);
				menu.shapes.getChildByName("icon" + i).shape.gotoAndStop(Model.shapes[i].shape + 1);
				menu.shapes.getChildByName("icon" + i).shape.colour.gotoAndStop(Model.shapes[i].element.type + 1);
			}
		}
		
		private function setupUpgradeIcon(upgrade: Gem, icon): void
		{
			if(upgrade == null)
			{
				icon.gotoAndStop(1);
				icon.overlay.gotoAndStop(2);
			}
			else
			{
				icon.gotoAndStop(upgrade.type + 2);
				icon.overlay.gotoAndStop(1);
			}
		}
		
		private function closeMenu(e: MouseEvent): void
		{
			Model.animationsRunning = true;
			removeMenuListeners();
			menu.gotoAndStop(1);
			menuPopup.gotoAndStop(6);
			addMainListeners();
		}
		
		//Redo-able.
		private function addMenuListeners(): void
		{
			menuPopup.addEventListener(MouseEvent.CLICK,closeMenu);
			menu.addEventListener(MouseEvent.MOUSE_MOVE, trailTooltip);
			toggleIcon(menu.element, true, false);
			for(var i: int = 0; i < 5; i++)
			{
				toggleIcon(menu.basicIcons.getChildByName("icon" + i), true, false);
				if(i == 4)
					break;
				toggleIcon(menu.spells.getChildByName("icon" + i), true, false);
				toggleIcon(menu.shapes.getChildByName("icon" + i), true, false);
				toggleIcon(menu.elementIcons.getChildByName("icon" + i), true, false);
				toggleIcon(menu.focusIcons.getChildByName("icon" + i), true, false);
				if(i > 1)
					continue;
				toggleIcon(menu.power.getChildByName("icon" + i), true, false);
			}
		}
		
		private function removeMenuListeners(): void
		{
			menuPopup.removeEventListener(MouseEvent.CLICK,closeMenu);
			menu.removeEventListener(MouseEvent.MOUSE_MOVE, trailTooltip);
			toggleIcon(menu.element, false, false);
			for(var i: int = 0; i < 5; i++)
			{
				toggleIcon(menu.basicIcons.getChildByName("icon" + i), false, false);
				if(i == 4)
					break;
				toggleIcon(menu.spells.getChildByName("icon" + i), false, false);
				toggleIcon(menu.shapes.getChildByName("icon" + i), false, false);
				toggleIcon(menu.elementIcons.getChildByName("icon" + i), false, false);
				toggleIcon(menu.focusIcons.getChildByName("icon" + i), false, false);
				if(i > 1)
					continue;
				toggleIcon(menu.power.getChildByName("icon" + i), false, false);
			}
		}
		
		
		private function toggleIcon(icon: MovieClip, active: Boolean, selectorUp: Boolean)
		{
			if(active)
			{
				if(selectorUp)
					icon.addEventListener(MouseEvent.CLICK, select);
				else
					icon.addEventListener(MouseEvent.CLICK, selectorFrame);
				icon.addEventListener(MouseEvent.MOUSE_OVER, showTooltip);
				icon.addEventListener(MouseEvent.MOUSE_OUT, hideTooltip);
			}
			else
			{
				if(selectorUp)
					icon.removeEventListener(MouseEvent.CLICK, selectorFrame);
				else
					icon.removeEventListener(MouseEvent.MOUSE_OVER, select);
				icon.removeEventListener(MouseEvent.MOUSE_OVER, showTooltip);
				icon.removeEventListener(MouseEvent.MOUSE_OUT, hideTooltip);
			}
		}
		
		private function addMainListeners():void
		{
			menuPopup.addEventListener(MouseEvent.CLICK,openMenu);
			menuPopup.addEventListener(MouseEvent.MOUSE_OVER,slideOut);
			menuPopup.addEventListener(MouseEvent.MOUSE_OUT,slideIn);
			this.addEventListener(Event.ENTER_FRAME,EnterFrame);
		}
		
		private function removeMainListeners(): void
		{
			menuPopup.removeEventListener(MouseEvent.CLICK,openMenu);
			menuPopup.removeEventListener(MouseEvent.MOUSE_OVER,slideOut);
			menuPopup.removeEventListener(MouseEvent.MOUSE_OUT,slideIn);
			this.removeEventListener(Event.ENTER_FRAME,EnterFrame);
		}
		
		//Might make static consts here. 0 = element.
		private function selectorFrame(e: MouseEvent): void
		{
			menu.tooltip.gotoAndStop(1);
			removeMenuListeners();
			menuPopup.addEventListener(MouseEvent.CLICK, exitSelector);
			_changedItem = (e.currentTarget as MovieClip);
			if(e.currentTarget == menu.element)
			{
				menu.selector.gotoAndStop(2);
				for(i = 0; i < 8; i++)
				{
					menu.selector.getChildByName("item" + i).gotoAndStop(i + 1);
					toggleIcon(menu.selector.getChildByName("item" + i), true, true)
				}
				return;
			}
			var i:int, j:int;
			switch(e.currentTarget.parent)
			{
				case menu.shapes:
					menu.selector.gotoAndStop(3);
					for(i = 0; i < 8; i++)
						for(j = 0; j < 8; j++)
						{
							menu.selector.getChildByName("item" + i + "" + j).gotoAndStop(j + 1);
							menu.selector.getChildByName("item" + i + "" + j).colour.gotoAndStop(i + 1);
							toggleIcon(menu.selector.getChildByName("item" + i + "" + j), true, true);
						}
					return;
				case menu.spells:
					var num: int = int(e.currentTarget.name.substr(4));
					menu.selector.gotoAndStop(4);
					menu.selector.text.gotoAndStop(num + 1);
					for(i = 0; i < 3; i++)
					{
						toggleIcon(menu.selector.getChildByName("item" + i), true, true)
						menu.selector.getChildByName("item" + i).gotoAndStop((num * 3) + i + 1);
					}
					return;
				case menu.basicIcons:
					menu.selector.gotoAndStop(5);
					break;
				case menu.focusIcons:
					menu.selector.gotoAndStop(6);
					break;
				case menu.elementIcons:
					menu.selector.gotoAndStop(7);
					break;
				case menu.power:
					menu.selector.gotoAndStop(8);
					break;
				default:
					break;
			}
			for(i = 0; i < menu.selector.numChildren - 3; i++)
			{
				menu.selector.getChildByName("item" + i).gotoAndStop(i + 2);
				menu.selector.getChildByName("item" + i).overlay.gotoAndStop(1);
				toggleIcon(menu.selector.getChildByName("item" + i), true, true);
			}
		}
		
		private function select(e: MouseEvent): void
		{
			var num: int = int(_changedItem.name.substr(4)), tar: int = int(e.currentTarget.name.substr(4));
			if(_changedItem == menu.element)
			{
				Model.player.element = Element.get(tar);
				exitSelector(null);
				return;
			}
			switch(_changedItem.parent)
			{
				case menu.shapes:
					Model.shapes[num].element = Element.get(int(tar / 10));
					Model.shapes[num].shape = tar % 10;
					updateIcons();
					break;
				case menu.spells:
					Model.spells[num] = Spell.get(tar + (num * 3));
					updateIcons();
					break;
				case menu.basicIcons:
					Model.setBasicGem(num, BasicGem.get(tar));
					break;
				case menu.focusIcons:
					Model.setFocusGem(num, FocusGem.get(tar));
					break;
				case menu.elementIcons:
					Model.setElementalGem(num, ElementalGem.get(tar));
					break;
				case menu.power:
					Model.setPowerGem(num, PowerGem.get(tar));
					break;
			}
			exitSelector(null);
		}
		
		private function exitSelector(e: MouseEvent): void
		{
			//This needs improving. TODO
			var i: int;
			if(menu.selector.currentFrame != 3)
			{
				var itemsOnPage: int = new Array(8, 8, 3, 20, 24, 24, 5)[menu.selector.currentFrame - 2];
				for(i = 0; i < itemsOnPage; i++)
					toggleIcon(menu.selector.getChildByName("item" + i), false, true);
			} 
			else
				for(i = 0; i < 8; i++)
					for(var j = 0; j < 8; j++)
						toggleIcon(menu.selector.getChildByName("item" + i + "" + j), false, true);
			menuPopup.removeEventListener(MouseEvent.CLICK, exitSelector);
			menu.selector.gotoAndStop(1);
			addMenuListeners();
			sortMenuIcons();
			menu.tooltip.gotoAndStop(1);
		}
		
		private function showTooltip(e: MouseEvent): void
		{
			if(menu.tooltip.currentFrame == 2)
				return;
			menu.tooltip.gotoAndStop(2);
			menu.tooltip.x = menu.mouseX + 2;
			menu.tooltip.y = menu.mouseY + 2;
			menu.tooltip.title.autoSize = TextFieldAutoSize.CENTER;
			menu.tooltip.description.wordWrap = true;
			menu.tooltip.description.width = 160;
			menu.tooltip.description.autoSize = TextFieldAutoSize.CENTER;
			if(e.currentTarget == menu.element || menu.selector.currentFrame == 2)
				setTooltipText(Element.get(e.currentTarget.currentFrame - 1));
			if(e.currentTarget.parent == menu.shapes)
			{
				menu.tooltip.title.text = Shape.getName(e.currentTarget.shape.currentFrame - 1);
				menu.tooltip.description.text = Shape.getDescription(e.currentTarget.shape.currentFrame - 1);
				return;
			}
			if(menu.selector.currentFrame == 3)
			{
				menu.tooltip.title.text = Element.get(e.currentTarget.colour.currentFrame - 1).name +
					" " + Shape.getName(e.currentTarget.currentFrame - 1);
				menu.tooltip.description.text = Shape.getDescription(e.currentTarget.currentFrame - 1);
				return;
			}
			if(e.currentTarget.parent == menu.spells)
			{
				setTooltipText(Spell.get(e.currentTarget.currentFrame - 2));
			}
			if(menu.selector.currentFrame == 4)
				setTooltipText(Spell.get(e.currentTarget.currentFrame - 1));
			if(e.currentTarget.parent == menu.basicIcons || menu.selector.currentFrame == 5)
				if(e.currentTarget.currentFrame == 1)
					setTooltipText(null);
				else
					setTooltipText(BasicGem.get(e.currentTarget.currentFrame - 2));
			if(e.currentTarget.parent == menu.focusIcons || menu.selector.currentFrame == 6)
				if(e.currentTarget.currentFrame == 1)
					setTooltipText(null);
				else
					setTooltipText(FocusGem.get(e.currentTarget.currentFrame - 2));
			if(e.currentTarget.parent == menu.elementIcons || menu.selector.currentFrame == 7)
				if(e.currentTarget.currentFrame == 1)
					setTooltipText(null);
				else
					setTooltipText(ElementalGem.get(e.currentTarget.currentFrame - 2));
			if(e.currentTarget.parent == menu.power || menu.selector.currentFrame == 8)
				if(e.currentTarget.currentFrame == 1)
					setTooltipText(null);
				else
					setTooltipText(PowerGem.get(e.currentTarget.currentFrame - 2));
			//switch(e.currentTarget.parent)
		}
		
		private function setTooltipText(targetObject = null)
		{
			if(targetObject == null)
			{
				menu.tooltip.title.text = "Unused";
				menu.tooltip.description.text = "Click here to select an upgrade for this slot."
			}
			else
			{
				menu.tooltip.title.text = targetObject.name;
				menu.tooltip.description.text = targetObject.description;
			}
		}
		
		private function trailTooltip(e: MouseEvent): void
		{
			menu.tooltip.x = menu.mouseX + 2;
			menu.tooltip.y = menu.mouseY + 2;
		}
		
		private function hideTooltip(e: MouseEvent): void
		{
			menu.tooltip.gotoAndStop(1);
		}
		
		private function slideOut(e: MouseEvent)
		{
			if(menuPopup.currentFrame == 1 && Model.player.level != 0)
				menuPopup.play();
		}
		
		private function slideIn(e: MouseEvent)
		{
			if(menuPopup.currentFrame != 1 && menuPopup.currentFrame <= 10 && Model.player.level != 0)
				menuPopup.gotoAndPlay(6);
		}
		
		private function updateIcons(): void
		{
			for(var i = 0; i < 4; i++)
			{
				_icons[i].graphic.gotoAndStop(1);
				_icons[i].graphic.shape.gotoAndStop(Model.shapes[i].shape + 1);
				_icons[i].graphic.shape.colour.gotoAndStop(Model.shapes[i].element.type + 1);
				_icons[i + 4].graphic.gotoAndStop(Model.spells[i].type + 2);
			}
		}
		
		public function set hintsShown(isTrue: Boolean): void
		{
			for(var i = 0; i < 8; i++)
			{
				_icons[i].gotoAndStop(isTrue ? 2 : 1);
				if(isTrue)
					_icons[i].Graphic.gotoAndStop(i + 1);
			}
			if(!isTrue)
				updateIcons();
		}
		
		public function EnterFrame(e:Event)
		{
			Model.notifier.tick(40);
			healthBar.gotoAndStop(int((Model.player.hp/Model.player.maxHP)*100));
			for(var a: int = 0; a < 4; a++)
			{   //Update icon cooldowns.
				if(Model.shapes[a].isReady)
					_icons[a].Cooldown.gotoAndStop(73);
				else
					_icons[a].Cooldown.gotoAndStop(0 + int(((Model.notifier.time - Model.shapes[a].timeCast)
						/Model.shapeCooldown)*72));
				if(Model.spells[a].isReady)
					_icons[a + 4].Cooldown.gotoAndStop(73);
				else
					_icons[a + 4].Cooldown.gotoAndStop(0 + int(((Model.notifier.time - Model.spells[a].timeCast)
						/Model.spells[a].cooldown)*72));
			}
			//Enemy spawner. Temp.
			if(Model.enemyVector.length < _numEnemies)
			{ 
				var newEnemy: Enemy = new Enemy(int(Math.random()+0.2));
				newEnemy.y = (Math.random()*300)+50;
				newEnemy.x = (Math.random()*540)+50;
			}
		}
		
		public function flash() : void
		{
			if(overlay.currentFrame == 1)
				overlay.gotoAndPlay(10);
		}
		
		public function levelUp(): void
		{
			menuPopup.gotoAndPlay(13);
			_unusedSkillPoints++;
		}
		
		public function changeEnemies(isIncrease: Boolean)
		{
			if(isIncrease)
				_numEnemies++;
			else
				if(_numEnemies != 0)
					_numEnemies--;
		}
		
		public function get sepia() : Boolean			{ return overlay.currentFrame == 2; }
		public function set sepia(value: Boolean): void	{ overlay.gotoAndPlay(value? 2 : 6);}
		
	}
}
