package
{
import ch.allink.micrositeframework.stateMachine.StateMachineTest;

import flash.display.Sprite;

import org.flexunit.internals.TraceListener;
import org.flexunit.runner.FlexUnitCore;

public class TestRunner extends Sprite
{
	//-------------------------------------------------------------------------
	//
	//	Variables
	//
	//-------------------------------------------------------------------------
	
	private var core:FlexUnitCore
	
	//-------------------------------------------------------------------------
	//
	//	Constructor
	//
	//-------------------------------------------------------------------------
	
	public function TestRunner()
	{
		super()
		
		core = new FlexUnitCore()
		core.addListener(new TraceListener())
		core.run(StateMachineTest)
//			core.run(ModelFactoryTest)
//			core.run(ImageViewTest)
//			core.run(NavigationServiceTest)
	}
}
}
