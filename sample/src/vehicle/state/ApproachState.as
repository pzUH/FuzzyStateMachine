package vehicle.state 
{
	import com.pzuh.ai.fuzzystatemachine.IFuzzyState;
	import vehicle.BaseVehicle;
	
	public class ApproachState implements IFuzzyState 
	{
		private var myShip:BaseVehicle;
		
		public function ApproachState(ship:BaseVehicle) 
		{
			myShip = ship;
		}
		
		/* INTERFACE com.pzuh.ai.fuzzystatemachine.IFuzzyState */
		
		public function enter():void 
		{
			
		}
		
		public function update():void 
		{
			trace(myShip.getName() + " approaching target");
			
			myShip.approach();
			
			if (!myShip.isInApproachRadius())
			{
				myShip.removeTarget();
			}
		}
		
		public function exit():void 
		{
			
		}
		
		public function getDOM():Number 
		{
			if (myShip.hasTarget())
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