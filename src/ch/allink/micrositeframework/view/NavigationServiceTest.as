package ch.allink.micrositeframework.view
{
import ch.allink.micrositeframework.cmsmodel.Navigation;
import ch.allink.micrositeframework.cmsmodel.NavigationViewService;
import ch.allink.micrositeframework.net.NavigationViewEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import flexunit.framework.Assert;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.flexunit.async.Async;
import org.flexunit.internals.namespaces.classInternal;
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

	private var navigationService:NavigationViewService 
	private var tweeningTime:Number = 0.1
	private var defaultColor:uint = 0x0000FF
	private var activeColor:uint = 0x00FF00
	private var rollOverColor:uint = 0xFF0000
	private var testNavigationView_1:NavigationView
	private var testNavigationView_2:NavigationView
	private var testNavigationView_3:NavigationView
	private var testNavigationView_11:NavigationView
	private var testNavigationView_12:NavigationView
	private var testNavigationView_111:NavigationView
	private var testNavigationView_112:NavigationView
	private var testNavigationView_21:NavigationView
	private var testNavigationView_22:NavigationView

	//-------------------------------------------------------------------------
	//
	//	Test methods
	//
	//-------------------------------------------------------------------------
	
//	[Test]
//	public function mouseInputClickRollOverRollOut():void
//	{
//		testNavigationView_1.addEventListener(MouseEvent.CLICK,
//											testNavigationView_1_clickHandler)
//		
//		testNavigationView_2.addEventListener(MouseEvent.CLICK,
//											  testNavigationView_2_clickHandler)
//		testNavigationView_2.addEventListener(MouseEvent.ROLL_OVER,
//										  testNavigationView_4_rollOverHandlerr)
//		testNavigationView_2.addEventListener(MouseEvent.ROLL_OUT,
//											testNavigationView_4_rollOutHandler)
//			
//
//		testNavigationView_3.addEventListener(MouseEvent.ROLL_OVER,
//										   testNavigationView_3_rollOverHandler)
//		testNavigationView_3.addEventListener(MouseEvent.ROLL_OUT,
//										   testNavigationView_3_rollOutHandler)
//			
//		testNavigationView_1.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
//	}
	
	[Test]
	public function mouseInputClickSubMenus():void
	{
		testNavigationView_11.addEventListener(MouseEvent.CLICK,
											testNavigationView_11_clickHandler)
		testNavigationView_21.addEventListener(MouseEvent.CLICK,
											testNavigationView_21_clickHandler)
		testNavigationView_112.addEventListener(MouseEvent.CLICK,
											testNavigationView_112_clickHandler)
		testNavigationView_3.addEventListener(MouseEvent.CLICK,
											testNavigationView_3_2_clickHandler)
		
		testNavigationView_11.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
			
	}
	
	[Test]
	public function compareTargetActualID():void
	{
		assertEquals(navigationService.navigationByPageID(2).navigationid,
					 Navigation(testNavigationView_3.model).navigationid)
//		assertEquals(navigationService.navigationForID(10).id,
//					 testNavigationView_11.navigation.id)
		
//		trace(navigationService.navigationForID(10).id)
	}
	
	//-------------------------------------------------------------------------
	//
	//	Event handlers 
	//
	//-------------------------------------------------------------------------
	
	//---------------------------------
	// mouseInputClickRollOverRollOut
	//---------------------------------
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
	
	private function navigationService_navigationClickedHandler(event:MouseEvent):void
	{
		//var navigationViewService:NavigationViewService = event.currentTarget as NavigationViewService
		//trace("pageID "+navigationViewService.pageID)
	}
	
	//---------------------------------
	// mouseInputClickSubMenus
	//---------------------------------
	
	private function testNavigationView_11_clickHandler(event:MouseEvent):void
	{
		executeDelay(timerClicked_11_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_21_clickHandler(event:MouseEvent):void
	{
		executeDelay(timerClicked_21_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_112_clickHandler(event:MouseEvent):void
	{
		executeDelay(timerClicked_112_completeHandler, tweeningTime * 1000)
	}
	
	private function testNavigationView_3_2_clickHandler(event:MouseEvent):void
	{
		executeDelay(timerClicked_3_2_completeHandler, tweeningTime * 1000)
	}
	
	//---------------------------------
	// Timer handlers
	//---------------------------------
	
	private function timerClicked_1_completeHandler(event:TimerEvent):void
	{
		//Die erste NavigationView wurde angeklickt
//		assertEquals(activeColor, testNavigationView_1.textField.textColor)
		assertTrue(testNavigationView_1.active)
		assertFalse(testNavigationView_2.active)
			
		testNavigationView_2.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	
	private function timerClicked_2_completeHandler(event:TimerEvent):void
	{
		//Die zweite NavigationView wurde angeklickt
		//Die erste NavigationView sollte wieder auf defaultColor gesetzt werden
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(activeColor, testNavigationView_2.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		
		testNavigationView_3.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER))
	}
	
	private function timerRollOver_3_completeHandler(event:TimerEvent):void
	{
		//ROLL_OVER über die dritte NavigationView
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(activeColor, testNavigationView_2.textField.textColor)
//		assertEquals(rollOverColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
		
		testNavigationView_3.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT))
	}
	
	private function timerRollOut_3_completeHandler(event:TimerEvent):void
	{
		//ROLL_OUT über die dritte NavigationView
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(activeColor, testNavigationView_2.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
		
		testNavigationView_2.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER))
	}
	
	private function timerRollOver_4_completeHandler(event:TimerEvent):void
	{
		//ROLL_OVER über die zweite NavigationView (acitve)
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(rollOverColor, testNavigationView_2.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
		
		testNavigationView_2.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT))
	}
	
	private function timerRollOut_4_completeHandler(event:TimerEvent):void
	{
		//ROLL_OUT über die zweite NavigationView (active)
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(activeColor, testNavigationView_2.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertTrue(testNavigationView_2.active)
		assertFalse(testNavigationView_3.active)
	}
	
	//---------------------------------
	//	Verhalten Unternavigation
	//---------------------------------
	
	private function timerClicked_11_completeHandler(event:TimerEvent):void
	{
		//Klick auf NavigationView 11
//		assertEquals(activeColor, testNavigationView_1.textField.textColor)
//		assertEquals(activeColor, testNavigationView_11.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_2.textField.textColor)
		assertTrue(testNavigationView_11.active)
		assertTrue(testNavigationView_1.active)
		assertFalse(testNavigationView_2.active)
		
		testNavigationView_21.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	
	private function timerClicked_21_completeHandler(event:TimerEvent):void
	{
		//Klick auf NavigationView 21
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_11.textField.textColor)
//		assertEquals(activeColor, testNavigationView_2.textField.textColor)
//		assertEquals(activeColor, testNavigationView_21.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertFalse(testNavigationView_11.active)
		assertTrue(testNavigationView_2.active)
		assertTrue(testNavigationView_21.active)
		
		testNavigationView_112.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
//		testNavigationView_3.dispatchEvent(new MouseEvent(MouseEvent.CLICK))

	}
	
	private function timerClicked_112_completeHandler(event:TimerEvent):void
	{
		//Klick auf NavigationView 112
//		assertEquals(activeColor, testNavigationView_1.textField.textColor)
//		assertEquals(activeColor, testNavigationView_11.textField.textColor)
//		assertEquals(activeColor, testNavigationView_112.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_2.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_21.textField.textColor)
//		assertTrue(testNavigationView_1.active)
		assertTrue(testNavigationView_11.active)
		assertTrue(testNavigationView_112.active)
		assertFalse(testNavigationView_2.active)
		assertFalse(testNavigationView_21.active)
		
		testNavigationView_3.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	
	private function timerClicked_3_2_completeHandler(event:TimerEvent):void
	{
		//Klick auf NavigationView 3
//		assertEquals(defaultColor, testNavigationView_1.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_11.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_112.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_2.textField.textColor)
//		assertEquals(defaultColor, testNavigationView_21.textField.textColor)
//		assertEquals(activeColor, testNavigationView_3.textField.textColor)
		assertFalse(testNavigationView_1.active)
		assertFalse(testNavigationView_11.active)
		assertFalse(testNavigationView_112.active)
		assertFalse(testNavigationView_2.active)
		assertFalse(testNavigationView_21.active)
		assertTrue(testNavigationView_3.active)
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
	
	private function buildCollection(numCollection:Number, 
									 idPrefix:Number):Vector.<NavigationView>
	{
		var collection:Vector.<NavigationView> = new Vector.<NavigationView>
		
		for(var i:int = 0; i < numCollection; i++)
		{
			var navigation:Navigation = new Navigation()
			navigation.navigationid = idPrefix + i
			var navigationView:NavigationView = new NavigationView(navigation)
			navigationView.activeColor = activeColor
			navigationView.defaultColor = defaultColor
			navigationView.rollOverColor = rollOverColor
			navigationView.tweeningTime = tweeningTime
			collection.push(navigationView)
		}
		
		return collection
	}
	
	//-------------------------------------------------------------------------
	//
	//	Before methods
	//
	//-------------------------------------------------------------------------
	
	[Before]
	public function setUp():void
	{
		navigationService = new NavigationViewService()
		navigationService.addEventListener(MouseEvent.CLICK,
			navigationService_navigationClickedHandler)
			
		var collection:Vector.<NavigationView> = buildCollection(3, 0)
		var collection_0:Vector.<NavigationView> = buildCollection(2, 10)
		var collection_00:Vector.<NavigationView> = buildCollection(2, 100)
		var collection_1:Vector.<NavigationView> = buildCollection(2, 20)
		
		//Hauptnavigation
		navigationService.navigationViews = collection
		//Unternavigation 0
		collection[0].navigationService = new NavigationViewService()
		collection[0].navigationService.navigationViews = collection_0
		//Unternavigation 1
		collection[1].navigationService = new NavigationViewService()
		collection[1].navigationService.navigationViews = collection_1
		//Unternavigation 00
		collection[0].navigationService.navigationViews[0].
			navigationService = new NavigationViewService()
		collection[0].navigationService.navigationViews[0].
			navigationService.navigationViews = collection_00
			
		testNavigationView_1 = navigationService.navigationViews[0]
		testNavigationView_2 = navigationService.navigationViews[1]
		testNavigationView_3 = navigationService.navigationViews[2]
			
		testNavigationView_11 = testNavigationView_1.navigationService.navigationViews[0]
		testNavigationView_12 = testNavigationView_1.navigationService.navigationViews[1]
		testNavigationView_21 = testNavigationView_2.navigationService.navigationViews[0]
		testNavigationView_22 = testNavigationView_2.navigationService.navigationViews[1]
			
		testNavigationView_111 = testNavigationView_11.navigationService.navigationViews[0]
		testNavigationView_112 = testNavigationView_11.navigationService.navigationViews[1]
	}
	
//	[Before]
//	public function setUp():void
//	{
//		var navigationViewService:NavigationViewService = new NavigationViewService()
//		navigationViewService.navigations = navigations
//			
//		//Oder
//		navigationViewService.navigationViews = navigationViews
//	}
}
}