package
{
import mvc.support.NotificationCenter;
import sample.MvcTest;
import sample.NotificationCenterTest;
public class LayaSample 
{	
	public function LayaSample()
	{
		//初始化引擎
		Laya.init(1136, 640);
		
		new MvcTest();
		new NotificationCenterTest();
		
		NotificationCenter.getInstance().postNotification("test");
		NotificationCenter.getInstance().postNotification("test2", 123);
		NotificationCenter.getInstance().postNotification("test3", "aaa");
	}		
}
}