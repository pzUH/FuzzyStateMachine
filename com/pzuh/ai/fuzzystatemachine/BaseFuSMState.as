package com.pzuh.ai.fuzzystatemachine
{
	public class BaseFuSMState
	{
		protected var entity:Object;
		
		protected var name:String;
		
		protected var action:Object;
		
		protected var DOAcalculator:Function;
		
		public function BaseFuSMState(entity:Object, name:String)
		{
			this.entity = entity;
			this.name = name;
			
			action = new Object();
		}
		
		public function addAction(update:Function, enter:Function = null, exit:Function = null):void
		{
			action.update = update;
			action.enter = enter;
			action.exit = exit;
		}
		
		public function addDOACalculator(calculator:Function):void
		{
			DOAcalculator = calculator;
		}
		
		public function removeSelf():void
		{
			DOAcalculator = null;
			
			entity = null;
			
			action = null;
		}
		
		public function getName():String
		{
			return name;
		}
		
		public function getDOA():Number
		{
			if (DOAcalculator != null)
			{
				return DOAcalculator.apply();
			}
			else
			{
				throw new Error("ERROR: No DOA calculator defined");
			}
		}
		
		public function enter():void
		{
			if (action.enter != null)
			{
				action.enter.apply();
			}
		}
		
		public function update():void
		{
			if (action.update != null)
			{
				action.update.apply();
			}
		}
		
		public function exit():void
		{
			if (action.exit != null)
			{
				action.exit.apply();
			}
		}
	}
}