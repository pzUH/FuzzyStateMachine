package com.pzuh.motion
{
	import com.pzuh.Vector2D;
	import com.pzuh.*;
	
	public class Steering
	{
		private var myObject:Object;
		
		private var wanderAngle:Number = 0;
		private var pathIndex:int = 0;
		
		public function Steering(object:Object)
		{
			myObject = object;
		}	
		
		public function seek(target:Object):void
		{
			seekToPoint(target.getPosition().x, target.getPosition().y);
		}
		
		public function seekToPoint(targetX:int, targetY:int):void
		{
			var desiredVel:Vector2D;
			var force:Vector2D;
			var target:Vector2D;
			
			target = new Vector2D(targetX, targetY);
			
			desiredVel = target.subtract(myObject.getPosition());
			desiredVel.normalize();
			desiredVel = desiredVel.multiply(myObject.getMaxSpeed());
			
			force = desiredVel.subtract(myObject.getVelocity());
			myObject.steeringForce = myObject.steeringForce.add(force);
		}
		
		public function flee(target:Object):void
		{
			fleeToPoint(target.getPosition().x, target.getPosition().y);
		}
		
		public function fleeToPoint(targetX:int, targetY:int):void
		{
			var desiredVel:Vector2D;
			var force:Vector2D;
			var target:Vector2D;
			
			target = new Vector2D(targetX, targetY);
			
			desiredVel = target.subtract(myObject.getPosition());
			desiredVel.normalize();
			desiredVel = desiredVel.multiply(myObject.getMaxSpeed());
			
			force = desiredVel.subtract(myObject.getVelocity());
			myObject.steeringForce = myObject.steeringForce.subtract(force);
		}
		
		public function arrive(target:Object, radius:Number = 10):void
		{
			arriveToPoint(target.getPosition().x, target.getPosition().y, radius);
		}
		
		public function arriveToPoint(targetX:int, targetY:int, radius:Number = 10):void
		{
			var desiredVel:Vector2D;
			var force:Vector2D;
			var dist:Number;
			var target:Vector2D;
			
			target = new Vector2D(targetX, targetY);
			
			desiredVel = target.subtract(myObject.getPosition());
			desiredVel.normalize();
			
			dist = myObject.getPosition().getDistance(target);
			
			if (dist <= radius)
			{				
				desiredVel = desiredVel.multiply(myObject.getMaxSpeed() * myObject.getFriction());
			}
			else
			{
				desiredVel = desiredVel.multiply(myObject.getMaxSpeed());
			}
			
			force = desiredVel.subtract(myObject.getVelocity());
			myObject.steeringForce = myObject.steeringForce.add(force);
		}
		
		public function pursue(target:Object):void
		{
			var lookAheadTime:Number;
			var predictedTarget:Vector2D;
			
			lookAheadTime = myObject.getPosition().getDistance(target.getPosition()) / myObject.getMaxSpeed();
			predictedTarget = target.getPosition().add(target.getVelocity().multiply(lookAheadTime));
			
			seek(predictedTarget);
		}
		
		public function evade(target:Object):void
		{
			var lookAheadTime:Number;
			var predictedTarget:Vector2D;
			
			lookAheadTime = myObject.getPosition().getDistance(target.getPosition()) / myObject.getMaxSpeed();
			predictedTarget = target.getPosition().add(target.getVelocity().multiply(lookAheadTime));
			
			fleeToPoint(predictedTarget.x, predictedTarget.y);
		}
		
		public function wander(distance:Number = 10, radius:Number = 100, range:Number = 1):void
		{
			var center:Vector2D; 
			var offset:Vector2D;
			var force:Vector2D;
			
			center = myObject.getVelocity().clone().normalize().multiply(distance);
			
			offset = new Vector2D();			
			offset.setLength(radius);
			offset.setAngle(wanderAngle);
			
			wanderAngle += Math.random() * range - range * .5;
			
			force = center.add(offset);
			myObject.steeringForce = myObject.steeringForce.add(force);
		}
		
		public function interpose(target1:Object, target2:Object, radius:Number = 10):void
		{
			var midPoint:Vector2D;
			var lookAheadTime:Number;
			var aPos:Vector2D;			
			var bPos:Vector2D;	
			
			midPoint = (target1.getPosition().add(target2.getPosition())).divide(2);
			
			lookAheadTime = myObject.getPosition().getDistance(midPoint) / myObject.getMaxSpeed();
			
			aPos = target1.getPosition().add((target1.getVelocity()).multiply(lookAheadTime));
			bPos = target2.getPosition().add((target2.getVelocity()).multiply(lookAheadTime));
			
			midPoint = (aPos.add(bPos)).divide(2);
			
			arriveToPoint(midPoint.x, midPoint.y, radius);
		}
		
		public function avoid(obstacle:Object, avoidRadius:Number, avoidBuffer:Number):void
		{
			var heading:Vector2D;
			var diff:Vector2D;
			var dotProd:Number;
			
			heading = myObject.getVelocity().clone().normalize();
			diff = obstacle.getPosition().subtract(myObject.getPosition());
			dotProd = diff.dotProduct(heading);
			
			if (dotProd > 0)
			{
				var feeler:Vector2D;
				var projection:Vector2D;
				var dist:Number;
				var desiredVel:Vector2D;
					
				desiredVel = obstacle.getPosition().subtract(myObject.getPosition());
				desiredVel.normalize();
				
				feeler = heading.multiply(avoidRadius);
				projection = heading.multiply(dotProd);
				dist = projection.subtract(diff).getLength();
				
				if ((dist < obstacle.getRadius() + avoidBuffer) && (projection.getLength() < feeler.getLength()))
				{
					var force:Vector2D;					
					
					desiredVel = desiredVel.multiply(myObject.getMaxSpeed() * myObject.getFriction());
					
					force = desiredVel.subtract(myObject.getVelocity());
					
					force = heading.multiply(myObject.getMaxSpeed());
					force.setAngle(force.getAngle() + diff.sign(myObject.getVelocity()) * Math.PI / 2);
					
					force = force.multiply(1.0 - projection.getLength() / feeler.getLength());						
					
					myObject.steeringForce = myObject.steeringForce.add(force);					
				}
			}
		}
		
		public function followPath(pathArray:Array, loop:Boolean = false,  pathThreshold:Number = 5):void
		{
			var waypoint:Vector2D;
			
			waypoint = pathArray[pathIndex];
			
			if (waypoint == null)
			{
				return;
			}
			
			if (Basic.getObjectDistance(myObject, waypoint) > pathThreshold)
			{
				if (loop)
				{
					seekToPoint(waypoint.x, waypoint.y);
				}
				else
				{
					arriveToPoint(waypoint.x, waypoint.y);
				}
			}
			else
			{
				if (pathIndex >= pathArray.length - 1)
				{
					if (loop)
					{
						pathIndex = 0;
					}
				}
				else
				{
					pathIndex++;
				}
			}
		}
		
		public function flock(objectArray:Array, inSightDist:Number, tooCloseDist:Number):void
		{
			var averageVelocity:Vector2D;
			var averagePosition:Vector2D;
			var inSightCount:int;
			
			averageVelocity = myObject.getVelocity().clone();
			averagePosition = new Vector2D();
			
			inSightCount = 0;
			
			for (var i:int = 0; i < objectArray.length; i++)
			{
				if ((objectArray[i] != myObject) && (isInSight(objectArray[i], inSightDist)))
				{
					averageVelocity = averageVelocity.add(objectArray[i].getVelocity());
					averagePosition = averagePosition.add(objectArray[i].getPosition());
					
					if (isTooClose(objectArray[i], tooCloseDist))
					{
						flee(objectArray[i]);
					}
					
					inSightCount++;
				}
			}
			
			if (inSightCount > 0)
			{
				averageVelocity = averageVelocity.divide(inSightCount);
				averagePosition = averagePosition.divide(inSightCount);
				
				seekToPoint(averagePosition.x, averagePosition.y);
				
				myObject.steeringForce.add(averageVelocity.subtract(myObject.getVelocity()));
			}
		}
		
		private function isInSight(target:Object, radius:Number):Boolean
		{
			var temp:Boolean;
			
			if (myObject.getPosition().getDistance(target.getPosition()) > radius)
			{
				temp = false;
			}
			else
			{
				var heading:Vector2D;
				var difference:Vector2D;
				var dotProd:Number;
				
				heading = myObject.getVelocity().clone().normalize();
				difference = target.getPosition().subtract(myObject.getPosition());
				dotProd = difference.dotProduct(difference);
				
				if (dotProd < 0)
				{
					temp = false;
				}
				else
				{
					temp = true;
				}
			}
			
			return temp;
		}
		
		private function isTooClose(target:Object, radius:Number):Boolean
		{
			return myObject.getPosition().getDistance(target.getPosition()) < radius;
		}
				
		//getter setter
		public function setWanderAngle(value:Number):void
		{
			wanderAngle = value;
		}
	}
}