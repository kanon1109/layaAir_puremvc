package mvc 
{
import adobe.utils.CustomActions;
import mvc.support.NotificationCenter;
/**
 * ...中介
 * @author Kanon
 */
public class Mediator 
{
	protected var notificationList:Vector.<String>;
	protected var facade:Facade;
	public var mediatorName:String;
	public function Mediator() 
	{
		this.notificationList = this.listNotificationInterests();
		this.facade = Facade.getInstance();
		NotificationCenter.getInstance().addObserver(Facade.MVC_MSG, getNotificationHandler, this);
	}
	
	protected function sendNotification(notificationName:String, body:Object):void
	{
		this.facade.sendNotification(notificationName, body);
	}
	
	protected function retrieveMediator(name:String):Mediator
	{
		return this.facade.retrieveMediator(name);
	}
	
	protected function retrieveProxy(name:String):Proxy
	{
		return this.facade.retrieveProxy(name);
	}
	
	/**
	 * 列出感兴趣的事件列表	子类继承
	 * @return	事件列表
	 */
	protected function listNotificationInterests():Vector.<String>
	{
		var notificationList:Vector.<String> = new Vector.<String>();
		return notificationList;
	}
	
	/**
	 * mvc消息回调
	 * @param	notification	消息体
	 */
	protected function handleNotification(notification:Notification):void
	{
		//子类继承
	}
	
	
	private function getNotificationHandler(notification:Notification):void 
	{
		var count:int = this.notificationList.length;
		var notificationName:String = notification.notificationName;
		for (var i:int = 0; i < count; i++) 
		{
			var name:String = this.notificationList[i];
			if (name == notificationName)
			{
				handleNotification(notification);
				break;
			}
		}
	}
}
}