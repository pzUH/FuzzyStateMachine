package vehicle.state 
{
	import com.pzuh.ai.fuzzystatemachine.BaseFuSMState;
	import com.pzuh.Basic;
	import vehicle.BaseVehicle;
	
	public class AttackState extends BaseFuSMState
	{
		public function AttackState(ship:BaseVehicle, name:String) 
		{
			super(ship, name);
		}		
		
		override public function update():void 
		{
			trace(entity.getName() + " shooting target");
			
			entity.shoot();
		}
		
		override public function getDOA():Number 
		{
			if (entity.hasTarget())
			{
				return 1 - (Basic.getObjectDistance(entity, entity.getTarget()) / BaseVehicle.APPROACH_RADIUS);
			}
			
			return 0;
		}		
	}
}