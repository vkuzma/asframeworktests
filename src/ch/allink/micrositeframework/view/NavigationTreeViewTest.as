package ch.allink.micrositeframework.view
{
import ch.allink.microsite.events.remake.NavigationViewEvent;
import ch.allink.microsite.navigationElement.Navigation;
import ch.allink.microsite.navigationElement.remake.NavigationTreeView;
import ch.allink.microsite.navigationElement.remake.NavigationView;
import ch.allink.microsite.util.ReportService;

import flash.events.MouseEvent;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;
import org.flexunit.async.Async;

/**
 * @author vkuzma
 * @date Jan 11, 2011
 **/
public class NavigationTreeViewTest
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	private var navigationTreeView:NavigationTreeView
	private var navigationView_01:NavigationView
	private var navigationView_02:NavigationView
	private var navigationView_03:NavigationView
	private var navigationView_04:NavigationView
	
	//-------------------------------------------------------------------------
	//
	//	Private methods
	//
	//-------------------------------------------------------------------------
	
	private function enableReports():void
	{
		ReportService.enableReportByObject(navigationView_01)
		ReportService.enableReportByObject(navigationView_01.navigationTreeView)
		ReportService.enableReportByObject(navigationView_02)
		ReportService.enableReportByObject(navigationView_02.navigationTreeView)
		ReportService.enableReportByObject(navigationView_03)
		ReportService.enableReportByObject(navigationView_04)
		ReportService.enableReportByObject(navigationTreeView)
	}
	
	//-------------------------------------------------------------------------
	//
	//	Public methods
	//
	//-------------------------------------------------------------------------
	
	[Before]
	public function initialize():void
	{
		navigationTreeView = new NavigationTreeView()
		navigationTreeView.name = "mainLevel"
			
		var navigation_01:Navigation = new Navigation()
		var navigation_02:Navigation = new Navigation()
		var navigation_03:Navigation = new Navigation()
		var navigation_04:Navigation = new Navigation()
			
		navigation_01.addChild(navigation_02)
		navigation_02.addChild(navigation_03)
			
		navigation_02.parentNavigation = navigation_01
		navigation_03.parentNavigation = navigation_02
			
		navigationView_01 = new NavigationView(navigation_01)
		navigationView_01.name = "01"
		navigationView_02 = new NavigationView(navigation_02)
		navigationView_02.name = "02"
		navigationView_03 = new NavigationView(navigation_03)
		navigationView_03.name = "03"
		navigationView_04 = new NavigationView(navigation_04)
		navigationView_04.name = "04"
			
		navigationView_01.addChildNavigationView(navigationView_02)
		navigationView_01.navigationTreeView.name = "level 01_1"
		navigationView_02.addChildNavigationView(navigationView_03)
		navigationView_02.navigationTreeView.name = "level 01_2"
			
		var navigationViews:Vector.<NavigationView> = 
			new Vector.<NavigationView>()
			
		navigationViews.push(navigationView_01)
		navigationViews.push(navigationView_04)
			
		navigationTreeView.navigationViews = navigationViews
	}
	
	//-------------------------------------------------------------------------
	//
	//	Test methods
	//
	//-------------------------------------------------------------------------
	
	[Test(order=1)]
	public function initialCheck():void
	{
		assertFalse(navigationView_01.active)
		assertFalse(navigationView_02.active)
		assertFalse(navigationView_02.active)
		assertFalse(navigationView_02.active)
	}
	
	[Test(order=2)]
	public function clickOnNavigationView_01():void
	{
		navigationView_01.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		assertTrue(navigationView_01.active)
		assertFalse(navigationView_02.active)
		assertFalse(navigationView_03.active)
		assertFalse(navigationView_04.active)
	}
	
	[Test(order=3)]
	public function takeTurnsByClicking_01_to_04():void
	{
		navigationView_01.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		navigationView_04.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		assertFalse(navigationView_01.active)
		assertFalse(navigationView_02.active)
		assertFalse(navigationView_03.active)
		assertTrue(navigationView_04.active)
	}
	
	[Test(order=4)]
	public function clickOnNavigatonView_03():void
	{
		navigationView_02.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		assertTrue(navigationView_01.active)
		assertTrue(navigationView_02.active)
		assertFalse(navigationView_03.active)
		assertFalse(navigationView_04.active)
	}
	
	[Test(order=5)]
	public function takeTurnsByClicking_02_to_04_to_03():void
	{
		navigationView_02.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		navigationView_04.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		assertFalse(navigationView_01.active)
		assertFalse(navigationView_02.active)
		assertFalse(navigationView_03.active)
		assertTrue(navigationView_04.active)
		
		navigationView_03.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
		assertTrue(navigationView_01.active)
		assertTrue(navigationView_02.active)
		assertTrue(navigationView_03.active)
		assertFalse(navigationView_04.active)
	}
	
	[Test(order=6)]
	public function requestActivateOnNavigationView_04():void
	{
		navigationView_04.requestActivate()
		assertFalse(navigationView_01.active)
		assertFalse(navigationView_02.active)
		assertFalse(navigationView_03.active)
		assertTrue(navigationView_04.active)
	}
	
	[Test(order=7)]
	public function requestActivateOnNavigatonView_03():void
	{
		navigationView_03.requestActivate()
		assertTrue(navigationView_01.active)
		assertTrue(navigationView_02.active)
		assertTrue(navigationView_03.active)
		assertFalse(navigationView_04.active)
	}
	
	[Test(order=8, async, timeout="100")]
	public function checkActivatedEventFromBubblingEvent():void
	{
		var asyncEvent:Function = Async.asyncHandler(this, 
			navigationView_03_activatedHandler, 100)
		navigationView_03.addEventListener(NavigationViewEvent.ACTIVATED,
										   asyncEvent)
		navigationView_03.requestActivate()
	}
	
	//-------------------------------------------------------------------------
	//
	//	Event listener	
	//
	//-------------------------------------------------------------------------
	
	private function navigationView_03_activatedHandler(
		event:NavigationViewEvent, passThroughData:Object):void
	{
		assertEquals(navigationView_03, event.navigationView)
	}
}
}