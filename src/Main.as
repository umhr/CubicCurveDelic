package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	//import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(width=465,height=465,backgroundColor=0x000000,frameRate=60)]
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			addChild(new Canvas());
			//addChild(new Stats());
		}
		
	}
	
}