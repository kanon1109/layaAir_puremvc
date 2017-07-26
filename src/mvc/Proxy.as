package mvc 
{
/**
 * ...数据代理
 * @author Kanon
 */
public class Proxy 
{
	public var proxyName:String;
	protected var facade:Facade;
	public function Proxy() 
	{
		this.facade = Facade.getInstance();
	}
	
	protected function retrieveMediator(name:String):Mediator
	{
		return this.facade.retrieveMediator(name);
	}
	
	protected function retrieveProxy(name:String):Proxy
	{
		return this.facade.retrieveProxy(name);
	}
	
	protected function sendNotification(notificationName:String, body:Object):void
	{
		this.facade.sendNotification(notificationName, body);
	}
	
	/**
	 * 初始化数据 子类实现
	 */
	public function initData():void
	{
		
	}
}
}