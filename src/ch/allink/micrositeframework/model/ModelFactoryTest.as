package ch.allink.micrositeframework.model
{
	import ch.allink.micrositeframework.cmsmodel.Image;
	import ch.allink.micrositeframework.cmsmodel.Navigation;
	import ch.allink.micrositeframework.cmsmodel.Page;
	import ch.allink.micrositeframework.cmsmodel.Section;
	import ch.allink.micrositeframework.net.ModelFactory;
	import ch.allink.micrositeframework.net.ModelRequest;
	import ch.allink.micrositeframework.net.ResultEvent;
	
	import flash.net.URLLoader;
	
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.flexunit.internals.namespaces.classInternal;
	
	
	public class ModelFactoryTest
	{
		private var modelFactory:ModelFactory
		
		[Before(order=1)]
		public function before():void
		{   
			modelFactory = new ModelFactory()  
		}   
		
		[After]  
		public function runAfterEveryTest():void
		{   
			modelFactory = null 
		} 
		
		[Test]  
		public function createImageModel():void
		{  
			var xml:XML =	
										<file uniqueid="42" width="1920" height="1280">
											<description>desc</description>
											<mimetype>image/pjpeg</mimetype>
											<imglink>link</imglink>
											<extraFields/>
										</file>
			var image:Image = Image(modelFactory.create(Image, xml))
			Assert.assertEquals(42, image.uniqueid)
			Assert.assertEquals(1920, image.width)
			Assert.assertEquals(1280, image.height)
			Assert.assertEquals('image/pjpeg', image.mimetype)
			Assert.	assertEquals('link', image.imglink)
		}
		
		[Test]
		public function createPageModel():void
		{
			var xml:XML = <page fileid="" uniqueid="8" languageid="1" visiblecontent="1">
								<title>Landscape</title>
								<format></format>
								<extraFields/>
								<sections>
								<section uniqueid="4" pageid="8">
								<title></title>
								<date>0000-00-00</date>
								<content></content>
								<type>gallery</type>
								<format></format>
								<files>
								<file uniqueid="42" width="1920" height="1280">
								<description></description>
								<mimetype>image/pjpeg</mimetype>
								<imglink></imglink>
								<extraFields/>
								</file>
								<file uniqueid="43" width="1920" height="1280">
								<description></description>
								<mimetype>image/pjpeg</mimetype>
								<imglink></imglink>
								<extraFields/>
								</file>
								<file uniqueid="44" width="1920" height="1280">
								<description></description>
								<mimetype>image/pjpeg</mimetype>
								<imglink></imglink>
								<extraFields/>
								</file>
								<file uniqueid="45" width="1920" height="1280">
								<description></description>
								<mimetype>image/pjpeg</mimetype>
								<imglink></imglink>
								<extraFields/>
								</file>
								</files>
								<extraFields/>
								</section>
								</sections>
						</page>	
			
			var p:Page = Page(modelFactory.create(Page, xml))
			Assert.assertEquals('', p.fileid)
			Assert.assertEquals(8, p.uniqueid)
			Assert.assertEquals(1, p.languageid)
			Assert.assertEquals(true, p.visiblecontent)
			Assert.assertEquals('Landscape', p.title)
			Assert.assertEquals(1, p.sections.length)
			var s:Section = p.sections[0]
			Assert.assertEquals(4, s.files.length)		
		}
		
		[Test(async,timeout='3000')]
		public function testLoadOfPageXML():void
		{
			modelFactory = new ModelFactory
			var request:ModelRequest = modelFactory.load(Page, "./testdata/page.xml", ModelFactory.TYPE_MODEL)
			Async.handleEvent(this, request, ResultEvent.DATA_LOADED, onXMLLoaded)
		//	request.addEventListener(ResultEvent.COLLECTION_LOADED, modelFactory_modelLoadedHandler)
		//	Async.handleEvent(this, mf, ResultEvent.MODEL_LOADED, onXMLLoaded)
		}
		
		private function onXMLLoaded(event:ResultEvent, param2:*):void
		{
			var p:Page = Page(event.model)
			Assert.assertEquals('Landscape', p.title)
			Assert.assertEquals(Page, event.request.klass)
		}
		
		[Test]
		public function testBuildNavigation():void
		{
			var xml:XML = <rubrics>
							<rubric navigationid="1" languageid="1" parentid="0" sortorder="0" visiblecontent="0" indexpagefileid="">
							<indexpageformats></indexpageformats>
							<indexpagetitle>Test</indexpagetitle>
							<title>Test</title>
							<pages>1,</pages>
							</rubric>
							</rubrics>
			var collection:Vector.<AbstractModel> = modelFactory.createCollection(Navigation, xml);
			var navigation:Navigation = Navigation(collection[0])
			Assert.assertEquals(1, collection.length)
			Assert.assertEquals('Test', navigation.title)
		}
		
	}
}