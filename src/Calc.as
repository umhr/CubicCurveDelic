package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author umhr
	 */
	public class Calc {
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

}