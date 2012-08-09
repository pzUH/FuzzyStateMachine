package vehicle 
{
	import bullet.BaseBullet;
	import com.pzuh.ai.fuzzystatemachine.BaseFuSMState;
	import com.pzuh.ai.fuzzystatemachine.FuzzyStateMachine;
	import com.pzuh.ai.fuzzystatemachine.IFuzzyState;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	import vehicle.state.ApproachState;
	import vehicle.state.AttackState;
	import vehicle.state.EvadeState;
	import vehicle.state.WanderState;
	
	import com.pzuh.*;
	import com.pzuh.motion.*;
	import com.carlcalderon.arthropod.Debug;
	
	public class BaseVehicle extends Sprite
	{
		public var mass:Number = 1;
		public var maxSpeed:Number = 2;
		private var friction:Number = .97;
		
		public var accel:Number = 0;
		
		public var maxForce:Number = 1;
		public var steeringForce:Vector2D;
		
		private var mySteering:Steering;
		
		private var position:Vector2D;
		public var velocity:Vector2D;
		
		public static const RED:uint = 0xff0000;
		public static const GREEN:uint = 0x00ff00;
		public static const BLUE:uint = 0x0000ff;
		
		private var color:uint;
		
		private var target:Object = null;
		private var threat:Object = null;
		
		public static const APPROACH_RADIUS:int = 400;
		public static const EVADE_RADIUS:int = 100;
		
		private var canFire:Boolean = true;
		private var fireTimer:Timer;
		
		private var myFuSM:FuzzyStateMachine;
		
		private var myMainClass:Main;
		
		public static const APPROACH_STATE:String = "approach_state";
		public static const WANDER_STATE:String = "wander_state";
		public static const EVADE_STATE:String = "evade_state";
		public static const ATTACK_STATE:String = "attack_state";
		
		public function BaseVehicle(name:String, color:uint, mainClass:Main) 
		{
			position = new Vector2D();
			velocity = new Vector2D();
			steeringForce = new Vector2D();
			mySteering = new Steering(this);
			
			myMainClass = mainClass;
			
			this.color = color;
			
			this.name = name;
			
			draw();
			
			myFuSM = new FuzzyStateMachine();
			
			//with concrete states
			var approachState:BaseFuSMState = new ApproachState(this, APPROACH_STATE);
			var attackState:BaseFuSMState = new AttackState(this, ATTACK_STATE);
			var evadeState:BaseFuSMState = new EvadeState(this, EVADE_STATE);
			
			//without concrete states
			var wanderState:BaseFuSMState = new BaseFuSMState(this, WANDER_STATE);
			wanderState.addAction(wander);
			wanderState.addDOACalculator(calculateWanderDOA);
			
			myFuSM.addState(approachState, evadeState, attackState, wanderState);
			
			fireTimer = new Timer(500, 0);
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler, false, 0, true);
		}	
		
		public function update():void
		{
			steeringForce.truncate(maxForce);
			steeringForce=steeringForce.divide(mass);
			
			velocity=velocity.add(steeringForce);				
			
			steeringForce.zero();
			
			velocity.truncate(maxSpeed);
			position = position.add(velocity);
			
			Bound.wrapStage(this, myMainClass.getStage());
			
			this.x = position.x;
			this.y = position.y;
			this.rotation = Basic.radianToDegree(velocity.getAngle());
			
			myFuSM.update();
		}		
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.lineStyle(0);
			graphics.moveTo(10, 0);
			graphics.lineTo( -10, 5);
			graphics.lineTo(-10, -5);
			graphics.lineTo(10, 0);
		}
		
		private function fireTimerHandler(event:TimerEvent):void
		{
			canFire = true;
		}
		
		//wander
		private function wander():void
		{
			trace(getName() + " wandering");
			
			mySteering.wander();
		}
		
		private function calculateWanderDOA():Number
		{
			if (!hasTarget() && !hasThreat())
			{
				return 1;
			}
			
			return 0;
		}
		
		//approach
		public function addTarget(target:Object):void
		{
			this.target = target;
		}
		
		public function hasTarget():Boolean
		{
			if (target != null)
			{
				return true;
			}
			
			return false;
		}
		
		public function removeTarget():void
		{
			target = null;
		}
		
		public function isInApproachRadius():Boolean
		{
			if (hasTarget() && Collision.isOnRadius(this, target, APPROACH_RADIUS))
			{
				return true;
			}
			
			return false;
		}
		
		public function approach():void
		{
			if (hasTarget())
			{
				mySteering.arrive(target);
			}
		}	
		
		//attack
		public function shoot():void
		{
			if (canFire)
			{
				canFire = false;
				fireTimer.start();
				
				var dx:Number;
				var dy:Number;
				
				dx = Math.cos(Basic.degreeToRadian(this.rotation));
				dy = Math.sin(Basic.degreeToRadian(this.rotation));
				
				var myBullet:BaseBullet = new BaseBullet(myMainClass.getStage());
				myBullet.x = this.x + dx * 10;
				myBullet.y = this.y + dy * 10;
				myBullet.getVelocity().setAngle(Math.atan2(dy, dx));
				myMainClass.addChild(myBullet);
				
				myMainClass.getBulletArray().push(myBullet);
			}
		}
		
		//evade
		public function addThreat(threat:Object):void
		{
			this.threat = threat;
		}
		
		public function hasThreat():Boolean
		{
			if (threat != null)
			{
				return true;
			}
			
			return false;
		}
		
		public function removeThreat():void
		{
			threat = null;
		}
		
		public function isInEvadeRadius():Boolean
		{
			if (hasThreat() && Collision.isOnRadius(this, threat, EVADE_RADIUS))
			{
				return true;
			}
			
			return false;
		}
		
		public function evade():void
		{
			if (hasThreat())
			{
				mySteering.evade(threat);
			}
		}
		
		//getter setter
		override public function set x(value:Number):void
		{
			super.x = value;
			position.x = x;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			position.y = y;
		}
		
		public function getPosition():Vector2D
		{
			return position;
		}
		
		public function getVelocity():Vector2D
		{
			return velocity;
		}
		
		public function setVelocity(value:Vector2D):void
		{
			velocity = value;
		}
		
		public function getSteering():Steering
		{
			return mySteering;
		}
		
		public function getMaxSpeed():Number
		{
			return maxSpeed;
		}
		
		public function getFriction():Number
		{
			return friction;
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function getTarget():Object
		{
			return target;
		}
		
		public function getThreat():Object
		{
			return threat;
		}
	}
}