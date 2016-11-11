package sample.model.proxy 
{
import mvc.Proxy;
/**
 * ...
 * @author Kanon
 */
public class TestProxy extends Proxy 
{
	public var count:int = 0;
	public function TestProxy() 
	{
		this.proxyName = "testProxy";
	}
	
	override public function initData():void 
	{
		count = 100;
	}
	
	public function add():void
	{
		this.count++;
	}
}
}