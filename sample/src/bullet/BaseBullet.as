package bullet 
{
	import flash.display.*;
	
	import com.pzuh.*;
	import com.pzuh.motion.*;
	
	public class BaseBullet extends MovieClip
	{
		protected var myStage:Stage;
		
		protected var position:Vector2D;
		protected var velocity:Vector2D;
		
		protected var maxSpeed:Number = 10;
		
		protected var radius:Number = 3;
		
		public function BaseBullet(stage:Stage) 
		{
			myStage = stage;
			
			init();
		}
		
		public function update():void
		{
			moveBullet();
		}
		
		protected function moveBullet():void
		{
			velocity.truncate(maxSpeed);
			position = position.add(velocity);
			
			this.x = position.x;
			this.y = position.y;
			this.rotation = Basic.getRotation(velocity.getAngle());
		}
		
		protected function init():void
		{
			position = new Vector2D();
			velocity = new Vector2D();
			
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			
			velocity.setLength(maxSpeed);
		}
		
		public function removeSelf():void
		{
			parent.removeChild(this);
		}
		
		//getter setter
		public function getPosition():Vector2D
		{
			return position;
		}
		
		public function getVelocity():Vector2D
		{
			return velocity;
		}
		
		public function getRadius():Number
		{
			return radius;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			position.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			position.y = value;
		}
	}
}