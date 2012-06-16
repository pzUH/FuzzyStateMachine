package com.pzuh.ai.fuzzystatemachine
{
	import com.pzuh.Basic;
	
	public class FuzzyStateMachine 
	{
		private var activeStates:Array = new Array();
		private var stateArray:Array = new Array();
		
		public function FuzzyStateMachine() 
		{
			
		}		
		
		public function addState(state:IFuzzyState):void
		{
			if (Basic.isElementOfArray(stateArray, state))
			{
				return;
			}
			
			stateArray.push(state);
		}
		
		public function isActive(state:IFuzzyState):Boolean
		{
			if (state.getDOA() > 0)
			{
				return true;
			}
			
			return false;
		}
		
		/* calculate the average of Degree of Activation (DOA) for each states
		 * make sure the value is always between 0.0 and 1.0
		 * */		
		private function getAverageDOA():Number
		{
			var stateCount:int = stateArray.length;
			var DOA:Number = 0;
			var totalDOA:Number = 0;
			
			for (var i:int = 0; i < stateCount; i++)
			{
				DOA = stateArray[i].getDOA();
				
				if (DOA < 0)
				{
					DOA = 0;
				}
				else if (DOA > 1)
				{
					DOA = 1;
				}
				
				totalDOA += DOA;
			}
			
			return totalDOA / stateCount;
		}
		
		public function update():void
		{
			if (stateArray.length <= 0)
			{
				return;
			}
			
			var nonActiveStates:Array = new Array();
			
			/* check each state's DOA
			 * if it greater than average DOA, add it to active states gtoup
			 * also check whether it's already in active states group or not, 
			 * so we can call the enter() method for newly added state
			 * */
			var length:int = stateArray.length;
			for (var i:int = 0; i < length; i++)
			{
				if (stateArray[i].getDOA() > getAverageDOA())
				{
					if (!Basic.isElementOfArray(activeStates, stateArray[i])) 
					{
						activeStates.push(stateArray[i]);
						stateArray[i].enter();
					}
				}
				else
				{
					if (Basic.isElementOfArray(activeStates, stateArray[i]))
					{
						activeStates.splice(activeStates.indexOf(stateArray[i]), 1);
						nonActiveStates.push(stateArray[i]);
					}
				}
			}
			
			var nonActiveLength:int = nonActiveStates.length;
			for (var j:int = 0; j < nonActiveLength; j++)
			{
				nonActiveStates[j].exit();
			}
			
			var activeLength:int = activeStates.length;
			for (var k:int = 0; k < activeLength; k++)
			{
				activeStates[k].update();
			}
		}
		
		public function removeSelf():void
		{
			activeStates.length = 0;
			activeStates = null;
			
			for (var i:int = stateArray.length - 1; i >= 0; i--)
			{
				stateArray[i].removeSelf();
				stateArray.splice(i, 1);
			}
			
			stateArray.length = 0;
			stateArray = null;
		}
	}
}