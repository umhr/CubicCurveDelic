package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
	{
		
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
            if (stage) onInit();
            else addEventListener(Event.ADDED_TO_STAGE, onInit);
        }
        
		private var _bitmap:Bitmap;
		private var _shape:Shape = new Shape();
		private var _pointList:Array/*Point*/ = [];
		private var _count:int;
		private const FADE:ColorTransform = new ColorTransform(1, 1, 1, 1, 0x1, 0x2, 0x1);
		
        private function onInit(event:Event = null):void 
        {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000));
			addChild(_bitmap);
			
			addChild(_shape);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			//draw(new Point(100, 200), new Point(200, 200), 0.8);
			//draw2(new Point(460, 460), new Point(230, 230));
		}
		
		private function enterFrame(e:Event):void 
		{
			_count ++;
			//_count = 100;
			_bitmap.bitmapData.colorTransform(_bitmap.bitmapData.rect, FADE);
			draw(new Point(465, 465), new Point(230, 230));
			
		}
		
		private function draw(p0:Point, p1:Point):void 
		{
			
			plot(p0, p1, Math.PI * 2 * (0 / 3), 0xFFFFFF*Math.random());
			plot(p0, p1, Math.PI * 2 * (1 / 3), 0xFFFFFF*Math.random());
			plot(p0, p1, Math.PI * 2 * (2 / 3), 0xFFFFFF*Math.random());
		}
		
		private function plot(p0:Point, p1:Point, d:Number, rgb:int):void 
		{
			_shape.graphics.clear();
			
			var cubicBezierCurve:CubicBezierCurve = new CubicBezierCurve(_shape.graphics);
			
			_pointList.length = 0;
			
			var dPt:Point = p0.subtract(p1);
			
			var dr:Number = Math.atan2(dPt.y, dPt.x) - _count * 0.003;
			
			var length:Number = p0.subtract(p1).length;
			var n:int = 50;
			for (var i:int = 0; i < n; i++) 
			{
				var pt:Point = new Point();
				pt.x = Math.cos((i / 3) * Math.PI + dr + d) * length + p1.x;
				pt.y = Math.sin((i / 3) * Math.PI + dr + d) * length + p1.y;
				_pointList.push(pt);
				//length /= 1.31;
				length /= Math.sin(_count * 0.007)*0.5+1.6;
				if (length < 1) {
					break;
				}
			}
			cubicBezierCurve.draw(_pointList, Math.sin(_count * 0.03) * 5, rgb);
			//cubicBezierCurve.draw(_pointList, 0.35, rgb);
			
			_bitmap.bitmapData.draw(_shape);
		}
		
		
		
	}
	
}