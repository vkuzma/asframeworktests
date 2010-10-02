package ch.allink.micrositeframework.cmsview
{
	import ch.allink.micrositeframework.cmsmodel.Image;
	
	import flashx.textLayout.debug.assert;
	
	import flexunit.framework.Assert;
	

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
		//imageView.build()		
		Assert.assertEquals("./cached/1_200.jpg", imageView.fileURL)
	}
	
	[Test]
	public function testImageOptionsBlackAndWhite():void
	{	
		imageView.model = image
		imageView.imageOptions.blackAndWhite = true
	//	imageView.build()
		Assert.assertEquals("./cached/1_200_gray.jpg", imageView.fileURL)
	}
}
}