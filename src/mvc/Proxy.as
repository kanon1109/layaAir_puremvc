package mvc 
{
/**
 * ...数据代理
 * @author Kanon
 */
public class Proxy 
{
	public var proxyName:String;
	public function Proxy() 
	{
		
	}
	
	protected function retrieveMediator(name:String):Mediator
	{
		return Facade.getInstance().retrieveMediator(name);
	}
	
	protected function retrieveProxy(name:String):Proxy
	{
		return Facade.getInstance().retrieveProxy(name);
	}
}
}