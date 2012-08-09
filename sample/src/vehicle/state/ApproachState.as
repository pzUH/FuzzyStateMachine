package vehicle.state 
{
	import com.pzuh.ai.fuzzystatemachine.BaseFuSMState;
	import vehicle.BaseVehicle;
	
	public class ApproachState extends BaseFuSMState
	{
		public function ApproachState(ship:BaseVehicle, name:String) 
		{
			super(ship, name);
		}
		
		override public function update():void 
		{
			trace(entity.getName() + " approaching target");
			
			entity.approach();
			
			if (!entity.isInApproachRadius())
			{
				entity.removeTarget();
			}
		}
		
		override public function getDOA():Number 
		{
			if (entity.hasTarget())
			{
				return 1;
			}
			
			return 0;
		}	
	}
}