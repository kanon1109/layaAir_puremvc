package sample.view.mediator 
{
import mvc.Mediator;
import mvc.Notification;
/**
 * ...
 * @author Kanon
 */
public class TestMediator extends Mediator 
{
	
	public function TestMediator() 
	{
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
				trace("test1");
				break;
			case "testMsg2":
				trace("test2");
				break;
			default:
				break;
		}
	}
}
}