package com.pzuh
{
	import flash.display.*;
	import flash.geom.*;
	
	import com.pzuh.Basic;
	
	public class Collision
	{
		public function Collision()
		{
			
		}
		
		public static function isHitDist(object1:Object, object2:Object):Boolean
		{
			var dist:Number;			
			var radius:Number;
			
			dist = Basic.getObjectDistance(object1, object2);
			
			radius = object1.getRadius() + object2.getRadius();
			
			return (dist <= radius);
		}
		
		public static function isHitBasic(object1:Object, object2:Object):Boolean
		{
			return (object1.hitTestObject(object2));			
		}
		
		public static function isOnRadius(object1:Object, object2:Object, hitRadius:Number):Boolean
		{
			var dist:Number;
			var radius:Number;
						
			dist = Basic.getObjectDistance(object1, object2);
			
			radius = hitRadius + object2.width / 2;
			
			return (dist <= radius);			
		}
		
		public static function isHitPixel(object1:DisplayObject, object2:DisplayObject, stage:Stage):Boolean
		{
			var temp:Boolean;
			
			if (isHitBasic(object1, object2)) 
			{
				var object1Rect:Rectangle;
				var object1Matrix:Matrix;
				var object1Point:Point;
				var object1BitmapData:BitmapData;
				
				var object2Rect:Rectangle;
				var object2Matrix:Matrix;
				var object2Point:Point;
				var object2BitmapData:BitmapData;
				
				object1Rect = object1.getBounds(stage);
				object1Matrix = object1.transform.matrix;
				object1Matrix.tx = object1.x - object1Rect.x;
				object1Matrix.ty = object1.y - object1Rect.y;
				object1BitmapData = new BitmapData(object1Rect.width, object1Rect.height, true, 0);
				object1BitmapData.draw(object1, object1Matrix);
				object1Point = new Point(object1Rect.x, object1Rect.y);
				
				object2Rect = object2.getBounds(stage);
				object2Matrix = object2.transform.matrix;
				object2Matrix.tx = object2.x - object2Rect.x;
				object2Matrix.ty = object2.y - object2Rect.y;
				object2BitmapData = new BitmapData(object2Rect.width, object2Rect.height, true, 0);
				object2BitmapData.draw(object2, object2Matrix);
				object2Point = new Point(object2Rect.x, object2Rect.y);
				
				if (object1BitmapData.hitTest(object1Point, 255, object2BitmapData, object2Point, 255))
				{
					temp = true;
				}
				else
				{
					temp = false;
				}
				
				object1BitmapData.dispose();
				object2BitmapData.dispose();
			}
			else
			{
				temp = false;
			}
			
			return temp;
		}
		
		public static function targetHitLOS(object:Object, target:Object, LOSRadius:Number, area:DisplayObjectContainer, accuracyLevel:int = 10):Boolean
		{
			if ((object != null) && (target != null))
			{
				for (var i:int = 0; i <= LOSRadius; i += accuracyLevel)
				{
					var dx:Number;
					var dy:Number;
					var point:Point = new Point();
					
					dx = Math.cos(Basic.degreeToRadian(object.rotation));
					dy = Math.sin(Basic.degreeToRadian(object.rotation));
					
					point.x = object.x + i * dx;
					point.y = object.y + i * dy;
					
					point = area.localToGlobal(point);
					
					if (target.hitTestPoint(point.x, point.y, true))
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}
}