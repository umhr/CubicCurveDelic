package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	//import net.hires.debug.Stats;
	
	/**
	 * FITC聞きながら作ってたやつ
	 * @author umhr
	 */
	[SWF(width=465,height=465,backgroundColor=0x000000,frameRate=60)]
	public class WonderflMain extends Sprite 
	{
		
		public function WonderflMain() 
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
	class Canvas extends Sprite 
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
		private var fade:ColorTransform = new ColorTransform(1, 1, 1, 1, 0x1, 0x2, 0x1);
		private var _isBack:Boolean;
		
        private function onInit(event:Event = null):void 
        {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000));
			addChild(_bitmap);
			
			addChild(_shape);
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
		}
		
		private function enterFrame(e:Event):void 
		{
			if (Math.random() < 0.002) {
				_isBack = !_isBack;
			}
			if (_isBack) {
				_count --;
			}else {
				_count ++;
			}
			_bitmap.bitmapData.colorTransform(_bitmap.bitmapData.rect, fade);
			draw(new Point(465, 465), new Point(230, 230));
			
			if (_count % 100 == 0 && Math.random() < 0.2) {
				if (Math.abs(fade.redOffset) > 3) {
					fade.redOffset = 0;
				}
				if (Math.abs(fade.greenOffset) > 3) {
					fade.greenOffset = 0;
				}
				if (Math.abs(fade.blueOffset) > 3) {
					fade.blueOffset = 0;
				}
				fade.redOffset += (Math.random() > 0.5)?1: -1;
				fade.greenOffset += (Math.random() > 0.5)?1: -1;
				fade.blueOffset += (Math.random() > 0.5)?1: -1;
				
			}
			
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
	
	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * ...
	 * @author umhr
	 */
	// 3次ベジェ曲線
	class CubicBezierCurve {
		private var _graphics:Graphics;
		private var _tangentialLineLength:Number;
		private var _rgb:int;
		public function CubicBezierCurve(graphics:Graphics) {
			_graphics = graphics;
		}
		public function draw(pointList:Array/*Point*/, tangentialLineLength:Number, rgb:int = 0x00FF00):void 
		{
			_tangentialLineLength = tangentialLineLength;
			_rgb = rgb;
			var n:int = pointList.length;
			if (n > 3) {
				var m:int = n - 3;
				for (var i:int = 0; i < m; i++) 
				{
					drawLine(pointList[i], pointList[i + 1], pointList[i + 2], pointList[i + 3], i == 0, i == (m - 1));
				}
			}
		}
		
		private function drawLine(pt0:Point, pt1:Point, pt2:Point, pt3:Point, isIn:Boolean, isOut:Boolean):void 
		{
			var p1:Point = Calc.tangentialLine(pt0, pt1, pt2);
			var p2:Point = Calc.tangentialLine(pt3, pt2, pt1);
			
			var clossPoint:Point = Calc.getClossPoint(pt1, pt2, pt1.add(p1), pt2.add(p2));
			var cpt1:Point = clossPoint.subtract(pt1);
			var cpt2:Point = clossPoint.subtract(pt2);
			
			// 接線
			var length:Number = pt1.subtract(pt2).length * _tangentialLineLength;
			p1.normalize(length);
			p2.normalize(length);
			_graphics.lineStyle(0, 0xFFFFFF, 0.3);
			_graphics.moveTo(pt1.x, pt1.y);
			_graphics.lineTo(pt1.x + p1.x, pt1.y + p1.y);
			_graphics.lineStyle(0, 0xFFFFFF, 0.3);
			_graphics.moveTo(pt2.x, pt2.y);
			_graphics.lineTo(pt2.x + p2.x, pt2.y + p2.y);
			
			_graphics.lineStyle(0, _rgb, 0.6);
			_graphics.moveTo(pt1.x, pt1.y);
			_graphics.cubicCurveTo(pt1.x + p1.x, pt1.y + p1.y, pt2.x + p2.x, pt2.y + p2.y, pt2.x, pt2.y);
			
			if(isIn){
				length = pt0.subtract(pt1).length * _tangentialLineLength;
				p1.normalize(length);
				_graphics.lineStyle(0, _rgb, 0.6);
				_graphics.moveTo(pt0.x, pt0.y);
				_graphics.cubicCurveTo(pt0.x + (pt1.x - pt0.x) * _tangentialLineLength, pt0.y + (pt1.y - pt0.y) * _tangentialLineLength, pt1.x - p1.x, pt1.y - p1.y, pt1.x, pt1.y);
				_graphics.lineStyle(0, 0xFFFFFF, 0.3);
				_graphics.lineTo(pt1.x - p1.x, pt1.y - p1.y);
				_graphics.moveTo(pt0.x, pt0.y);
				_graphics.lineTo(pt0.x + (pt1.x - pt0.x) * _tangentialLineLength, pt0.y + (pt1.y - pt0.y) * _tangentialLineLength);
			}
			if (isOut) {
				length = pt2.subtract(pt3).length * _tangentialLineLength;
				p2.normalize(length);
				_graphics.lineStyle(0, _rgb, 0.6);
				_graphics.moveTo(pt2.x, pt2.y);
				_graphics.cubicCurveTo(pt2.x - p2.x, pt2.y - p2.y, pt3.x + (pt2.x - pt3.x) * _tangentialLineLength, pt3.y + (pt2.y - pt3.y) * _tangentialLineLength, pt3.x, pt3.y);
				_graphics.lineStyle(0, 0xFFFFFF, 0.3);
				_graphics.lineTo(pt3.x + (pt2.x - pt3.x) * _tangentialLineLength, pt3.y + (pt2.y - pt3.y) * _tangentialLineLength);
				_graphics.moveTo(pt2.x, pt2.y);
				_graphics.lineTo(pt2.x - p2.x, pt2.y - p2.y);
			}
		}
		
		private function drawCurve(pt0:Point, clossPoint:Point, pt1:Point):void 
		{
			_graphics.moveTo(pt0.x, pt0.y);
			_graphics.curveTo(clossPoint.x, clossPoint.y, pt1.x, pt1.y);
		}	
		
		
	}

	import flash.geom.Point;
	/**
	 * ...
	 * @author umhr
	 */
	class Calc {
		public function Calc() {
			
		}
		
		static public function angleBetween(a:Point,b:Point):Number {
			return Math.acos((a.x * b.x + a.y * b.y) / (Math.sqrt(a.x * a.x + a.y * a.y) * Math.sqrt(b.x * b.x + b.y * b.y)));
		}

		// 折れた直線の接線のベクトルを求める
		static public function tangentialLine(point0:Point, point1:Point, point2:Point):Point 
		{
			var pt0:Point = point1.subtract(point0);
			var pt1:Point = point1.subtract(point2);
			
			pt0.normalize(1);
			pt1.normalize(1);
			
			return pt0.subtract(pt1);
		}
		
		// ４点からなる交点
		static public function getClossPoint(pa0:Point, pa1:Point, pb0:Point, pb1:Point):Point {
			var result:Point = new Point();
			var s0:Number = ((pb1.x - pa1.x) * (pa0.y - pa1.y) - (pb1.y - pa1.y) * (pa0.x - pa1.x)) * 0.5;
			var s1:Number = ((pb1.x - pa1.x) * (pa1.y - pb0.y) - (pb1.y - pa1.y) * (pa1.x - pb0.x)) * 0.5;
			result.x = pa0.x + (pb0.x - pa0.x) * (s0 / (s0 + s1));
			result.y = pa0.y + (pb0.y - pa0.y) * (s0 / (s0 + s1));
			return result;
		}
	}

