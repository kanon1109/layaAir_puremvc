package sample.view.mediator 
{
import mvc.Mediator;
import mvc.Notification;
import mvc.Proxy;
import sample.model.proxy.TestProxy;
/**
 * ...
 * @author Kanon
 */
public class TestMediator extends Mediator 
{
	public function TestMediator() 
	{
		this.mediatorName = "TestMediator";
		super();
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push("testMsg1");
		vect.push("testMsg2");
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case "testMsg1":
				var testProxy:TestProxy = this.retrieveProxy("TestProxy") as TestProxy;
				testProxy.add();
				trace("int TestMediator notificationName is " + notification.notificationName + " count is " + testProxy.count);
				break;
			case "testMsg2":
				trace("int TestMediator notificationName is " + notification.notificationName);
				break;
			default:
				break;
		}
	}
}
}