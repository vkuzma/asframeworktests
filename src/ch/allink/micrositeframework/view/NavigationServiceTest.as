package ch.allink.micrositeframework.view
{
import ch.allink.micrositeframework.cmsmodel.Navigation;
import ch.allink.micrositeframework.cmsmodel.NavigationService;
import ch.allink.micrositeframework.model.ModelEvent;

import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import flexunit.framework.Assert;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.flexunit.async.Async;
import org.osmf.events.TimeEvent;

/** 
 *  Testet die Klasse NavigationService
 * @author Vladimir Kuzma
 */

public class NavigationServiceTest
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	private var tweeningTime:Number
	private var navigationService:NavigationService 
	private var defaultColor:uint
	private var activeColor:uint
	private var rollOverColor:uint
	private var testNavigationView_1:NavigationView
	private var testNavigationView_2:NavigationView
	private var testNavigationView_3:NavigationView

	//-------------------------------------------------------------------------
	//
	//	Test methods
	//
	//-------------------------------------------------------------------------
	
	[Test]
	public function mouseInputClickRollOverRollOut():void
	{
		testNavigationView_1 = navigationService.navigationViews[0]
		testNavigationView_1.addEventListener(MouseEvent.CLICK,
											testNavigationView_1_clickHandler)
		
		testNavigationView_2 = navigationService.navigationViews[1]
		testNavigationView_2.addEventListener(MouseEvent.CLICK,
											  testNavigationView_2_clickHandler)
		testNavigationView_2.addEventListener(MouseEvent.ROLL_OVER,
										  testNavigationView_4_rollOverHandlerr)
		testNavigationView_2.addEventListener(MouseEvent.ROLL_OUT,
											testNavigationView_4_rollOutHandler)
			
		testNavigationView_3 = navigationService.navigationViews[2]
		testNavigationView_3.addEventListener(MouseEvent.ROLL_OVER,
										   testNavigationView_3_rollOverHandler)
		testNavigationView_3.addEventListener(MouseEvent.ROLL_OUT,
										   testNavigationView_3_rollOutHandler)
			
		testNavigationView_1.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	
	//-------------------------------------------------------------------------
	//
	//	Event handlers 
	//
	//-------------------------------------------------------------------------
	
	private function testNavigationView_1_clickHandler(event:MouseEvent):void
	{
		executeDelay(timerClicked_1_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_2_clickHandler(event:MouseEvent):void
	{
		executeDelay(timerClicked_2_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_3_rollOverHandler(event:MouseEvent):void
	{
		executeDelay(timerRollOver_3_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_3_rollOutHandler(event:MouseEvent):void
	{
		executeDelay(timerRollOut_3_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_4_rollOverHandlerr(event:MouseEvent):void
	{
		executeDelay(timerRollOver_4_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_4_rollOutHandler(event:MouseEvent):void
	{
		executeDelay(timerRollOut_4_completeHandler, tweeningTime * 1000)
	}
	
	//---------------------------------
	// Timer handlers
	//---------------------------------
	
	private function timerClicked_1_completeHandler(event:TimerEvent):void
	{
		//Die erste NavigationView wurde angeklickt
		assertEquals(activeColor, testNavigationView_1.textField.textColor)
		assertTrue(testNavigationView_1.active)
		assertFalse(testNavigationView_2.active)
		
		testNavigationView_2.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	
	private function timerClicked_2_completeHandler(event:TimerEvent):void
	{
		//Die zweite NavigationView wurde angeklickt
		//Die erste NavigationView sollte wieder auf defaultColor gesetzt werden
		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
		assertEquals(activeColor, testNavigationView_2.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		
		testNavigationView_3.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER))
	}
	
	private function timerRollOver_3_completeHandler(event:TimerEvent):void
	{
		//ROLL_OVER über die dritte NavigationView
		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
		assertEquals(activeColor, testNavigationView_2.textField.textColor)
		assertEquals(rollOverColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
		
		testNavigationView_3.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT))
	}
	
	private function timerRollOut_3_completeHandler(event:TimerEvent):void
	{
		//ROLL_OUT über die dritte NavigationView
		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
		assertEquals(activeColor, testNavigationView_2.textField.textColor)
		assertEquals(defaultColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
		
		testNavigationView_2.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER))
	}
	
	private function timerRollOver_4_completeHandler(event:TimerEvent):void
	{
		//ROLL_OVER über die zweite NavigationView (acitve)
		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
		assertEquals(rollOverColor, testNavigationView_2.textField.textColor)
		assertEquals(defaultColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
		
		testNavigationView_2.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT))
	}
	
	private function timerRollOut_4_completeHandler(event:TimerEvent):void
	{
		//ROLL_OUT über die zweite NavigationView (active)
		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
		assertEquals(activeColor, testNavigationView_2.textField.textColor)
		assertEquals(defaultColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
	}
	
	//-------------------------------------------------------------------------
	//
	//	private methods
	//
	//-------------------------------------------------------------------------
	
	private function executeDelay(funktion:Function, delay:Number):void
	{
		var timerClicked:Timer = new Timer(delay, 1)
		timerClicked.addEventListener(TimerEvent.TIMER_COMPLETE, funktion)
		timerClicked.start()
	}
	
	//-------------------------------------------------------------------------
	//
	//	Before methods
	//
	//-------------------------------------------------------------------------
	
	[Before]
	public function setUp():void
	{
		tweeningTime = 0.1
		defaultColor = 0x0000FF
		activeColor = 0x00FF00
		rollOverColor = 0xFF0000
		navigationService = new NavigationService()
			
		var collection:Vector.<NavigationView> = new Vector.<NavigationView>
		for(var i:int; i < 3; i++)
		{
			var navigation:Navigation = new Navigation()
			var navigationView:NavigationView = new NavigationView(navigation)
			navigationView.activeColor = activeColor
			navigationView.defaultColor = defaultColor
			navigationView.rollOverColor = rollOverColor
			navigationView.tweeningTime = tweeningTime
			collection.push(navigationView)
		}
		
		navigationService.navigationViews = collection
	}
}
}