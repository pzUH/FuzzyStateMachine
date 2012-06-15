package com.pzuh.ai.fuzzystatemachine
{
	public interface IFuzzyState 
	{
		function enter():void
		function update():void
		function exit():void
		function getDOM():Number
		function removeSelf():void
	}	
}