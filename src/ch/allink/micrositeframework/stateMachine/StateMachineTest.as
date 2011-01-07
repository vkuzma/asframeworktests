package ch.allink.micrositeframework.stateMachine
{
import ch.allink.jobservice.Job;
import ch.allink.jobservice.JobEvent;
import ch.allink.jobservice.JobService;
import ch.allink.jobservice.State;
import ch.allink.jobservice.StateMachine;

import org.flexunit.asserts.assertEquals;

/**
 * @author vkuzma
 * @date Jan 3, 2011
 **/
public class StateMachineTest
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	private var counter:int
	
	private var galleryState:State
	private var pageState:State
	private var homeState:State
	private var headLineState:State
	private var stateMachine:StateMachine
	
	//-------------------------------------------------------------------------
	//
	//	Test methods
	//
	//-------------------------------------------------------------------------
	
	/**
	 * The statemachine tries to move from state homeState to galleryState.
	 * The transition ist just one job. The count result should be 1.
	 **/
	[Test]
	public function moveToState_01():void
	{
		stateMachine.currentState = homeState
		counter = 0
		stateMachine.addEventListener(JobEvent.COMPLETE_ALL, 
									  moveTo_01_completeAllHandler)
		stateMachine.moveToState(galleryState)
	}
	
	[Test]
	public function moveToState_02():void
	{
		stateMachine.currentState = galleryState
		counter = 0
		stateMachine.addEventListener(JobEvent.COMPLETE,
									  moveTo_02_completeHandler)
		stateMachine.addEventListener(JobEvent.COMPLETE_ALL,
									  moveTo_02_completeAllHandler)
		stateMachine.moveToState(homeState)
		
		
	}
	
	[Before]
	public function initialize():void
	{
		counter = 0
		
		homeState = new State()
		homeState.name = "homeState"
		galleryState = new State()
		galleryState.name = "galleryState"
		pageState = new State()
		headLineState = new State()
			
			
		//gallery
		var homeGalleryTransition:JobService = new JobService()
		homeGalleryTransition.name = "homeGallery"
		homeGalleryTransition.addJob(new Job(jobFunction, 
									 {params: [1, homeGalleryTransition]}))
			
		homeGalleryTransition.beginning = homeState
		homeGalleryTransition.destination = galleryState
			
		//home
		var galleryHomeTransition:JobService = new JobService()
		galleryHomeTransition.name = "galleryHome"
		galleryHomeTransition.addJob(new Job(jobFunction, 
									 {params: [1, galleryHomeTransition]}))
		galleryHomeTransition.addJob(new Job(jobFunction, 
									 {params: [2, galleryHomeTransition]}))
			
		galleryHomeTransition.beginning = galleryState
		galleryHomeTransition.destination = homeState
		
		//page
		var pageJobService:JobService = new JobService()
		pageJobService.addJob(new Job(jobFunction, 
									 {params: [pageJobService]}))
		pageJobService.addJob(new Job(jobFunction, 
									 {params: [pageJobService]}))
			
		//headline
			
			
		stateMachine = new StateMachine()
		stateMachine.addState(galleryState)
		stateMachine.addState(homeState)
		stateMachine.addState(pageState)
		stateMachine.addState(headLineState)
	}
	
	//-------------------------------------------------------------------------
	//
	//	Private methods
	//
	//-------------------------------------------------------------------------
	
	private function jobFunction(addToCounter:int,
								 jobServiceInLead:JobService = null):void
	{
		counter += addToCounter
		jobServiceInLead.doNextJob()
	}
	
	//-------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//-------------------------------------------------------------------------
	
	private function moveTo_01_completeAllHandler(event:JobEvent):void
	{
		var stateMachine:StateMachine = event.target as StateMachine
		stateMachine.removeEventListener(JobEvent.COMPLETE_ALL, 
										 moveTo_01_completeAllHandler)
		assertEquals(galleryState, stateMachine.currentState)	
		assertEquals(counter, 1)
	}
	
	private function moveTo_02_completeHandler(event:JobEvent):void
	{
	}
	
	private function moveTo_02_completeAllHandler(event:JobEvent):void
	{
		var stateMachine:StateMachine = event.target as StateMachine
		stateMachine.removeEventListener(JobEvent.COMPLETE, 
										 moveTo_02_completeHandler)
		stateMachine.removeEventListener(JobEvent.COMPLETE_ALL, 
										 moveTo_02_completeAllHandler)
		assertEquals(homeState, stateMachine.currentState)
		assertEquals(counter, 3)
	}
	
	//-------------------------------------------------------------------------
	//
	//	Properties
	//
	//-------------------------------------------------------------------------
	
	
}
}