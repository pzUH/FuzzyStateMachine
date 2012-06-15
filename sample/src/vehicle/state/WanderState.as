package vehicle.state 
{
	import com.pzuh.ai.fuzzystatemachine.IFuzzyState;
	import vehicle.BaseVehicle;
	
	public class WanderState implements IFuzzyState 
	{
		private var myShip:BaseVehicle;
		
		public function WanderState(ship:BaseVehicle) 
		{
			myShip = ship;
		}
		
		/* INTERFACE com.pzuh.ai.fuzzystatemachine.IFuzzyState */
		
		public function enter():void 
		{
			
		}
		
		public function update():void 
		{
			trace(myShip.getName() + " wandering");
			
			myShip.wander();
		}
		
		public function exit():void 
		{
			
		}
		
		public function getDOM():Number 
		{
			if (!myShip.hasTarget() && !myShip.hasThreat())
			{
				return 1;
			}
			
			return 0;
		}
		
		public function removeSelf():void 
		{
			
		}		
	}
}