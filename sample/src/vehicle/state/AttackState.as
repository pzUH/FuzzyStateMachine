package vehicle.state 
{
	import com.pzuh.Basic;
	import vehicle.BaseVehicle;
	import com.pzuh.ai.fuzzystatemachine.IFuzzyState
	
	public class AttackState implements IFuzzyState 
	{
		private var myShip:BaseVehicle
		
		public function AttackState(ship:BaseVehicle) 
		{
			myShip = ship;
		}		
		
		/* INTERFACE com.pzuh.ai.fuzzystatemachine.IFuzzyState */
		
		public function enter():void 
		{
			
		}
		
		public function update():void 
		{
			trace(myShip.getName() + " shooting target");
			
			myShip.shoot();
		}
		
		public function exit():void 
		{
			
		}
		
		public function getDOM():Number 
		{
			if (myShip.hasTarget())
			{
				return 1 - (Basic.getObjectDistance(myShip, myShip.getTarget()) / BaseVehicle.APPROACH_RADIUS);
			}
			
			return 0;
		}
		
		public function removeSelf():void 
		{
			
		}		
	}
}