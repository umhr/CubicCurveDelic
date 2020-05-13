package  
{
	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * ...
	 * @author umhr
	 */
	// 3次ベジェ曲線
	public class CubicBezierCurve {
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
}