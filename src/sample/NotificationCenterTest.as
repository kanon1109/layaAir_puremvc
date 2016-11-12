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
		NotificationCenter.getInstance().addObserver("test", callBackHandler, this);
		NotificationCenter.getInstance().addObserver("test2", callBack2Handler, this);
		NotificationCenter.getInstance().addObserver("test2", callBack4Handler, this);
		NotificationCenter.getInstance().addObserver("test3", callBack3Handler, this);
		NotificationCenter.getInstance().addObserver("test4", callBack5Handler, this);
		NotificationCenter.getInstance().addObserver("test5", callBack6Handler, this);
	}
	
	private function callBack6Handler(obj:Object):void 
	{
		trace("obj", obj.obj);
	}
	
	private function callBack5Handler(str:String, a:int, b:int):void 
	{
		trace(this);
		trace(str);
		trace(a);
		trace(b);
	}
	
	private function callBack4Handler():void 
	{
		trace("callBack4Handler");
	}
	
	private function callBack3Handler(params:Object):void 
	{
		trace("callBack3Handler", params);
	}
	
	private function callBack2Handler(params:Object):void 
	{
		trace("callBack2Handler", params);
	}
	
	private function callBackHandler():void 
	{
		trace("callBackHandler");
	}
	
}
}