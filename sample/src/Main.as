/* an example implementation of Fuzzy State Machine (FuSM)
 * in this example, I build three vehicle or spaceship that have three states:
	 * Wander, if they doesn't have any target or threat
	 * Approach, if they have any target in range
	 * Attack, if the target is in attack range
	 * Evade, if they have threat and the threat is in evade range
*/
package
{
	import flash.display.*;
	import flash.events.*;
	
	import com.pzuh.*;
	import com.pzuh.motion.*;
	
	import vehicle.*;
	
	[SWF(width = "640", height = "480", frameRate="60")]
	
	public class Main extends Sprite 
	{
		private var vehicleArray:Array = new Array();
		private var vehicleNum:int = 3;
		
		private var bulletArray:Array = new Array();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			for (var i:int = 0; i < vehicleNum; i++) 
			{			
				var rand:int = Math.ceil(Math.random() * 3);
				var color:uint;
				
				if (rand == 1)
				{
					color = BaseVehicle.RED;
				}
				else if (rand == 2)
				{
					color = BaseVehicle.BLUE;
				}
				else
				{
					color = BaseVehicle.GREEN;
				}
				
				var myVehicle:BaseVehicle = new BaseVehicle("Ship_"+String(i), color, this);
				myVehicle.maxSpeed = 5;
				myVehicle.mass = 1;
				myVehicle.maxForce = .1;
				myVehicle.x = Math.random() * 640;
				myVehicle.y = Math.random() * 480;
				addChild(myVehicle);
				
				vehicleArray.push(myVehicle);
			}
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}		
		
		private function update(event:Event):void
		{
			for (var i:int = 0; i < vehicleNum; i++)
			{
				vehicleArray[i].update();
			}
			
			for (var j:int = 0; j < bulletArray.length; j++)
			{
				if (bulletArray[j] != null) 
				{
					bulletArray[j].update();
					
					if (Bound.isOutOfStage(bulletArray[j], stage))
					{
						bulletArray[j].removeSelf();
						bulletArray.splice(j, 1);
					}
				}
			}
			
			checkCollision();
		}
		
		private function checkCollision():void
		{
			for (var i:int = 0; i < vehicleArray.length; i++)
			{
				for (var j:int = 0; j < vehicleArray.length; j++)
				{
					if (vehicleArray[i] != vehicleArray[j]) 
					{
						var ship:BaseVehicle = vehicleArray[i];
						
						if (Collision.isOnRadius(vehicleArray[i], vehicleArray[j], BaseVehicle.APPROACH_RADIUS))
						{
							ship.addTarget(vehicleArray[j]);
						}						
						
						if (Collision.isOnRadius(vehicleArray[i], vehicleArray[j], BaseVehicle.EVADE_RADIUS))
						{
							ship.addThreat(vehicleArray[j]);
						}
					}
				}
			}
		}
		
		public function getStage():Stage
		{
			return stage;
		}
		
		public function getBulletArray():Array
		{
			return bulletArray;
		}
	}	
}