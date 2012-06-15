package vehicle.state 
{
	import com.pzuh.ai.fuzzystatemachine.IFuzzyState;
	import com.pzuh.Basic;
	import vehicle.BaseVehicle;
	
	public class EvadeState implements IFuzzyState 
	{
		private var myShip:BaseVehicle;
		
		public function EvadeState(ship:BaseVehicle) 
		{
			myShip = ship;
		}
		
		/* INTERFACE com.pzuh.ai.fuzzystatemachine.IFuzzyState */
		
		public function enter():void 
		{
			
		}
		
		public function update():void 
		{
			trace(myShip.getName() + " evading threat");
			
			myShip.evade();
			
			if (!myShip.isInEvadeRadius())
			{
				myShip.removeThreat();
			}
		}
		
		public function exit():void 
		{
			
		}
		
		public function getDOM():Number 
		{
			if (myShip.hasThreat())
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