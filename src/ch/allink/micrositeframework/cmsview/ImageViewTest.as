package ch.allink.micrositeframework.cmsview
{
	
	import ch.allink.microsite.imageElement.Image;
	import ch.allink.microsite.imageElement.ImageView;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import flashx.textLayout.debug.assert;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.flexunit.internals.namespaces.classInternal;
	

public class ImageViewTest
{
	private var imageView:ImageView
	private var image:Image
	
	public function ImageViewTest():void
	{
		
	}
	
	[Before]
	public function setup():void
	{
		imageView = new ImageView
		image = new Image()
		image.uniqueid = 1
		image.width = 200
		image.height = 200
		imageView.model = image
	}
	
	[Test]
	public function testImageOptionsSimple():void
	{	
		Assert.assertEquals("./cached/1_200.jpg", imageView.fileURL)
	}
	
	[Test]
	public function testImageOptionsBlackAndWhite():void
	{	
		imageView.imageOptions.blackAndWhite = true
		Assert.assertEquals("./cached/1_200_gray.jpg", imageView.fileURL)
	}
	
	[Test(async,timeout='3000')]
	public function testLoadImageFromFile():void
	{
		imageView.imageOptions.basePath = "./testdata/cached/"
		Async.handleEvent(this, imageView, Event.COMPLETE, 
			imageView_completeHandler)
		imageView.build()
	}
	
	public function imageView_completeHandler(event:Event, param2:*):void	
	{
		Assert.assertTrue(imageView.loadedBitmap is Bitmap)
		Assert.assertTrue(imageView.contains(imageView.loadedBitmap))
		Assert.assertTrue(imageView.loadedBitmap == imageView.currentBitmap)
	}
	
	[Test (async,timeout='3000')]
	public function resizeLoadedBitmap():void
	{
		imageView.imageOptions.basePath = "./testdata/cached/"
		Async.handleEvent(this, imageView, Event.COMPLETE, 
			imageView_resizeHandler)
		imageView.build()
	}
	
	public function imageView_resizeHandler(event:Event, param2:*):void	
	{
		imageView.resizeBitmapTo(100, 100)
		Assert.assertTrue(imageView.loadedBitmap != imageView.currentBitmap)
		Assert.assertEquals(100, imageView.width)
		Assert.assertEquals(100, imageView.height)
		Assert.assertTrue(imageView.contains(imageView.currentBitmap))
		Assert.assertFalse(imageView.contains(imageView.loadedBitmap))
	}
}
}