package sample 
{
import mvc.support.NotificationCenter;
/**
 * ... 消息中心测试
 * @author Kanon
 */
public class NotificationCenterTest 
{
	
	public function NotificationCenterTest() 
	{
		NotificationCenter.getInstance().addObserver("test", callBackHandler);
		NotificationCenter.getInstance().addObserver("test2", callBack2Handler);
		NotificationCenter.getInstance().addObserver("test2", callBack4Handler);
		NotificationCenter.getInstance().addObserver("test3", callBack3Handler);
	}
	
	private function callBack4Handler():void 
	{
		trace("callBack4Handler");
	}
	
	private function callBack3Handler(params:Object):void 
	{
		trace(params);
	}
	
	private function callBack2Handler(params:Object):void 
	{
		trace(params);
	}
	
	private function callBackHandler():void 
	{
		trace("callBackHandler");
	}
	
}
}