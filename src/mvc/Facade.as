package mvc
{
import laya.utils.Dictionary;
/**
 * ...
 * @author Kanon
 */
public class Facade
{
	private var mediatorDict:Dictionary;
	private var proxyDict:Dictionary;
	private static var instance:Facade;
	public function Facade(singletoner:Singletoner)
	{
		if (!singletoner) 
            throw new Error("只能用getInstance()来获取实例");  
			
		this.mediatorDict = new Dictionary();
		this.proxyDict = new Dictionary();
	}
	
	public static function getInstance():Facade
	{
		if (!instance) instance = new Facade(new Singletoner());
		return instance;
	}
	
	public function sendNotification(notificationName:String, body:Object):void
	{
		var notification:Notification = new Notification();
		notification.notificationName = notificationName;
		notification.body = body;
		
	}
	
	/**
	 * 注册mediator
	 * @param	mediator
	 */
	public function registerMediator(mediator:Mediator):void
	{
		this.mediatorDict.set(mediator.mediatorName, mediator);
	}
	
	/**
	 * 注册proxy
	 * @param	proxy
	 */
	public function registerProxy(proxy:Proxy):void
	{
		this.proxyDict.set(proxy.proxyName, proxy);
	}
	
	/**
	 * 获取proxy
	 * @param	name	
	 * @return
	 */
	public function retrieveProxy(name:String):Proxy
	{
		return this.proxyDict.get(name);
	}
	
	/**
	 * 获取proxy
	 * @param	name	
	 * @return
	 */
	public function retrieveMediator(name:String):Mediator
	{
		return this.mediatorDict.get(name);
	}
	
	/**
	 * 删除mediator
	 * @param	name
	 */
	public function removeMediator(name:String):void
	{
		this.mediatorDict.remove(name);
	}
	
	/**
	 * 删除proxy
	 * @param	name
	 */
	public function removeProxy(name:String):void
	{
		this.proxyDict.remove(name);
	}
}
internal class Singletoner {  
} 