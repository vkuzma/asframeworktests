package ch.allink.micrositeframework.stateMachine
{
import ch.allink.jobservice.Job;
import ch.allink.jobservice.JobEvent;
import ch.allink.jobservice.JobService;
import ch.allink.jobservice.State;
import ch.allink.jobservice.StateMachine;
import ch.allink.microsite.util.ReportService;

import org.flexunit.asserts.assertEquals;
import org.flexunit.async.Async;

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
	
	private var string:String
	
	private var galleryState:State
	private var pageState:State
	private var homeState:State
	private var subPageState:State
	private var headLine:State
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
	[Test(order=1, async, timeout="100")]
	public function moveToState_01():void
	{
		stateMachine.currentState = homeState
			
		var asyncCompleteHandler:Function = Async.asyncHandler(
			this, moveTo_01_completeAllHandler, 100)
			
		stateMachine.addEventListener(JobEvent.COMPLETE_ALL, 
			asyncCompleteHandler, false, 0, true)
		stateMachine.moveToState(galleryState)
	}
	
	[Test(order=2)]
	public function moveToStateAndMoveBack():void
	{
		stateMachine.currentState = homeState
		stateMachine.moveToState(galleryState)
		assertEquals("a", string)
		stateMachine.moveToState(homeState)
		assertEquals("abc", string)
	}
	
	[Test(order=3)]
	public function moveToStateOverStates_01():void
	{
		stateMachine.currentState = galleryState
		stateMachine.moveToState(pageState)
		assertEquals("bcdef", string)
	}
	
	[Test(order=4)]
	public function moveToStateOverStates_02():void
	{
		stateMachine.currentState = galleryState
		stateMachine.moveToState(subPageState)
		assertEquals("bcdefgh", string)
	}
	
	[Test(order=5)]
	public function moveToStateOverStates_03():void
	{
		stateMachine.currentState = galleryState
		stateMachine.moveToState(subPageState)
		stateMachine.moveToState(homeState)
		assertEquals("bcdefghklij", string)
	}
	
	[Test(order=5)]
	public function moveToStateOverStates_04():void
	{
		stateMachine.currentState = subPageState
		stateMachine.moveToState(headLine)
		assertEquals("klijm", string)
	}
	
	[Before]
	public function initialize():void
	{
		string = ""
		
		homeState = new State()
		homeState.name = "homeState"
		galleryState = new State()
		galleryState.name = "galleryState"
		pageState = new State()
		pageState.name = "pageState"
		subPageState = new State()
		subPageState.name = "subPageState"
		headLine = new State()
		headLine.name = "headLine"
			
		//gallery
		var galleryHomeTransition:JobService = new JobService()
		galleryHomeTransition.name = "galleryHome"
		galleryHomeTransition.addJob(new Job(jobFunction, 
									 {params: ["b", galleryHomeTransition]}))
		galleryHomeTransition.addJob(new Job(jobFunction, 
									 {params: ["c", galleryHomeTransition]}))
			
		galleryHomeTransition.beginning = galleryState
		galleryHomeTransition.destination = homeState
			
		//home
		var homeGalleryTransition:JobService = new JobService()
		homeGalleryTransition.name = "homeGallery"
		homeGalleryTransition.addJob(new Job(jobFunction, 
									 {params: ["a", homeGalleryTransition]}))
			
		homeGalleryTransition.beginning = homeState
		homeGalleryTransition.destination = galleryState
		
		var homePageTransition:JobService = new JobService()
		homePageTransition.name = "homePage"
		homePageTransition.addJob(new Job(jobFunction, 
									 	  {params: ["d", homePageTransition]}))
		homePageTransition.addJob(new Job(jobFunction, 
									   	  {params: ["e", homePageTransition]}))
		homePageTransition.addJob(new Job(jobFunction, 
									 	  {params: ["f", homePageTransition]}))
			
		homePageTransition.beginning = homeState
		homePageTransition.destination = pageState
			
		var homeHeadLineTransition:JobService = new JobService()
		homeHeadLineTransition.name = "homeHeadLine"
		homeHeadLineTransition.addJob(new Job(jobFunction, 
									 {params: ["m", homeHeadLineTransition]}))
			
		homeHeadLineTransition.beginning = homeState
		homeHeadLineTransition.destination = headLine
			
		homePageTransition.beginning = homeState
		homePageTransition.destination = pageState
			
		//page
		var pageSubPageTransition:JobService = new JobService()
		pageSubPageTransition.name = "pageSubpage"
		pageSubPageTransition.addJob(new Job(jobFunction,
										{params: ["g", pageSubPageTransition]}))
		pageSubPageTransition.addJob(new Job(jobFunction,
										{params: ["h", pageSubPageTransition]}))
		
		pageSubPageTransition.beginning = pageState
		pageSubPageTransition.destination = subPageState
		
		var pageHomeTransition:JobService = new JobService()
		pageHomeTransition.name = "pageHome"
		pageHomeTransition.addJob(new Job(jobFunction,
										{params: ["i", pageHomeTransition]}))
		pageHomeTransition.addJob(new Job(jobFunction,
										{params: ["j", pageHomeTransition]}))
		
		pageHomeTransition.beginning = pageState
		pageHomeTransition.destination = homeState
			
		//subpage
		var subPagePageTransition:JobService = new JobService()
		subPagePageTransition.name = "subpagePage"
		subPagePageTransition.addJob(new Job(jobFunction,
									 {params: ["k", subPagePageTransition]}))
		subPagePageTransition.addJob(new Job(jobFunction,
									 {params: ["l", subPagePageTransition]}))
		
		subPagePageTransition.beginning = subPageState
		subPagePageTransition.destination = pageState
			
		stateMachine = new StateMachine()
		stateMachine.addState(galleryState)
		stateMachine.addState(homeState)
		stateMachine.addState(pageState)
		stateMachine.addState(subPageState)
		stateMachine.addState(headLine)
			
//		ReportService.enableReportByObject(stateMachine)
	}
	
	//-------------------------------------------------------------------------
	//
	//	Private methods
	//
	//-------------------------------------------------------------------------
	
	private function jobFunction(sign:String,
								 jobServiceInLead:JobService = null):void
	{
		string += sign
		jobServiceInLead.doNextJob()
	}
	
	//-------------------------------------------------------------------------
	//
	//	Event handlers
	//
	//-------------------------------------------------------------------------
	
	private function moveTo_01_completeAllHandler(event:JobEvent,
												  passThroughData:Object):void
	{
		var stateMachine:StateMachine = event.target as StateMachine
		assertEquals(galleryState, stateMachine.currentState)	
		assertEquals("a", string)
	}
}
}