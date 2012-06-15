package com.pzuh.motion
{
	import com.pzuh.Vector2D;
	import flash.display.*;
	
	public class Bound
	{
		public function Bound()
		{
			
		}
		
		public static function wrapStage(object:Object, stage:Stage):void
		{
			if (stage != null) 
			{
				var top:Number;
				var bottom:Number;
				var left:Number;
				var right:Number;
				
				top = 0;
				bottom = stage.stageHeight;
				left = 0;
				right = stage.stageWidth;
			
				wrap(object, top, bottom, left, right);
			}
		}
		
		public static function wrapArea(object:Object, area:DisplayObjectContainer):void
		{
			if (area != null) 
			{
				var top:Number;
				var bottom:Number;
				var left:Number;
				var right:Number;
						
				top = 0;
				bottom = area.height;
				left = 0;
				right = area.width;		
				
				wrap(object, top, bottom, left, right);
			}
		}
		
		public static function wrap(object:Object, top:Number, bottom:Number, left:Number, right:Number):void
		{
			var objectRadius:Number;
			
			objectRadius = object.width / 2;
				
			if (object.x - objectRadius > right)
			{
				object.x = left - objectRadius;
			}
			else if (object.x + objectRadius < left)
			{
				object.x = right + objectRadius;
			}
				
			if (object.y - objectRadius > bottom)
			{
				object.y = top - objectRadius;
			}
			else if (object.y + objectRadius < top)
			{
				object.y = bottom + objectRadius;
			}
		}
		
		public static function bounceStage(object:Object, stage:Stage):void
		{
			if (stage != null) 
			{
				var top:Number;
				var bottom:Number;
				var left:Number;
				var right:Number;
				
				var vx:Number;
				var vy:Number;
			
				top = 0;
				bottom = stage.stageHeight;
				left = 0;
				right = stage.stageWidth;
			
				bounce(object, top, bottom, left, right);
			}
		}
		
		public static function bounceArea(object:Object, area:DisplayObjectContainer):void
		{
			if (area != null) 
			{
				var top:Number;
				var bottom:Number;
				var left:Number;
				var right:Number;
				
				var vx:Number;
				var vy:Number;
			
				top = 0;
				bottom = area.height;
				left = 0;
				right = area.width;
			
				bounce(object, top, bottom, left, right);
			}
		}
		
		public static function bounce(object:Object, top:Number, bottom:Number, left:Number, right:Number):void
		{			
			var objectRadius:Number;
			
			objectRadius = object.width / 2;
				
			if (object.x + objectRadius >= right)
			{
				object.x = right - objectRadius;
				object.setVelocity(new Vector2D(object.getVelocity().x * -1, object.getVelocity().y));
			}
			else if (object.x - objectRadius <= left)
			{
				object.x = left + objectRadius;
				object.setVelocity(new Vector2D(object.getVelocity().x * -1, object.getVelocity().y));
			}
				
			if (object.y + objectRadius >= bottom)
			{
				object.y = bottom - objectRadius;
				object.setVelocity(new Vector2D(object.getVelocity().x, object.getVelocity().y * -1));
			}
			else if (object.y - objectRadius <= top)
			{
				object.y = top + objectRadius;
				object.setVelocity(new Vector2D(object.getVelocity().x, object.getVelocity().y * -1));
			}
		}
		
		public static function isOutOfStage(object:Object, stage:Stage):Boolean
		{
			var value:Boolean;
			
			if (stage != null) 
			{
				var width:Number = stage.stageWidth;
				var height:Number = stage.stageHeight;				
				
				value = isOutBounds(object, width, height);
			}
			
			return value;
		}
		
		public static function isOutOfArea(object:Object, area:DisplayObjectContainer):Boolean
		{
			var value:Boolean;
			
			if (area != null) 
			{
				var width:Number = area.width;
				var height:Number = area.height;				
				
				value = isOutBounds(object, width, height);
			}
			
			return value;
		}
		
		private static function isOutBounds(object:Object, width:Number, height:Number):Boolean
		{
			if ((object.x + object.width / 2 < 0) ||
			(object.x - object.width / 2 > width) ||
			(object.y + object.height / 2 < 0)    || 
			(object.y - object.height / 2 > height))
			{
				return true;
			}
			
			return false;
		}
		
		public static function isAtEdgeOfStage(object:Object, stage:Stage):Boolean
		{
			var value:Boolean;
			
			if (stage != null)
			{
				var width:Number = stage.stageWidth;
				var height:Number = stage.stageHeight;
				
				value = isAtEdge(object, width, height);
			}
			
			return value;
		}
		
		public static function isAtEdgeOfArea(object:Object, area:DisplayObjectContainer):Boolean
		{
			var value:Boolean;
			
			if (area != null)
			{
				var width:Number = area.width;
				var height:Number = area.height;
				
				value = isAtEdge(object, width, height);
			}
			
			return value;
		}
		
		private static function isAtEdge(object:Object, width:Number, height:Number):Boolean
		{
			if ((object.x - object.width / 2 <= 0)     ||
			    (object.x + object.width / 2 >= width) ||
			    (object.y - object.height / 2 <= 0)    || 
			    (object.y + object.height / 2 >= height))
			{
				return true;
			}
			
			return false;
		}
	}
}