package vehicle.state 
{
	import com.pzuh.ai.fuzzystatemachine.BaseFuSMState;
	import com.pzuh.Basic;
	import vehicle.BaseVehicle;
	
	public class EvadeState extends BaseFuSMState
	{
		public function EvadeState(ship:BaseVehicle, name:String) 
		{
			super(ship, name);
		}
		
		override public function update():void 
		{
			trace(entity.getName() + " evading threat");
			
			entity.evade();
			
			if (!entity.isInEvadeRadius())
			{
				entity.removeThreat();
			}
		}
		
		override public function getDOA():Number 
		{
			if (entity.hasThreat())
			{
				return 1;
			}
			
			return 0;
		}	
	}
}