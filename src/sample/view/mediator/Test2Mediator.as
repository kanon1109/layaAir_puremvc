package sample.view.mediator 
{
import mvc.Mediator;
import mvc.Notification;

/**
 * ...
 * @author Kanon
 */
public class Test2Mediator extends Mediator 
{
	public function Test2Mediator() 
	{
		this.mediatorName = "Test2Mediator";
		super();
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push("testMsg2");
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case "testMsg2":
				trace("int Test2Mediator notificationName is " + notification.notificationName);
				trace("params is :", notification.body["aaa"], notification.body["bbb"]);
			break;
			default:
		}
	}
}
}