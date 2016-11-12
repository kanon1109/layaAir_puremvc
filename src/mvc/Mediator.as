package mvc 
{
/**
 * ...中介
 * @author Kanon
 */
public class Mediator 
{
	protected var notificationList:Vector.<String>;
	public var mediatorName:String;
	public function Mediator() 
	{
		
	}
	
	protected function sendNotification(notificationName:String, body:Object):void
	{
		Facade.getInstance().sendNotification(notificationName, body);
	}
	
	protected function retrieveMediator(name:String):Mediator
	{
		return Facade.getInstance().retrieveMediator(name);
	}
	
	protected function retrieveProxy(name:String):Proxy
	{
		return Facade.getInstance().retrieveProxy(name);
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
}
}