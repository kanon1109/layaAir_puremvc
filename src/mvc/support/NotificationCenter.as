package mvc.support 
{
import laya.utils.Dictionary;
/**
 * ...消息中心
 * @author Kanon
 */
public class NotificationCenter 
{
	private var callBackDict:Dictionary = new Dictionary();
	private var thisObjDict:Dictionary = new Dictionary();
	private static var instance:NotificationCenter;
	public function NotificationCenter(singletoner:Singletoner) 
	{
		if (!singletoner)
			throw new Error("只能用getInstance()来获取实例");
	}
	
	public static function getInstance():NotificationCenter
	{
		if (!instance) instance = new NotificationCenter(new Singletoner())
		return instance;
	}

	/**
	 * 添加观察者
	 * @param	name		消息名称
	 * @param	callBack	回调
	 */
	public function addObserver(name:String, callBack:Function, thisObj:*):void
	{
		var callBackVect:Vector.<Function>;
		var thisObjVect:Array;
		if (!this.callBackDict.get(name)) 
		{
			callBackVect = new Vector.<Function>();
			thisObjVect = [];
			this.callBackDict.set(name, callBackVect);
			this.thisObjDict.set(name, thisObjVect);
		}
		else 
		{
			callBackVect = this.callBackDict.get(name);
			thisObjVect = this.thisObjDict.get(name);
		}
		thisObjVect.push(thisObj);
		callBackVect.push(callBack);
	}
	
	/**
	 * 发送消息
	 * @param	name	消息名称
	 * @param	params	消息参数
	 */
	public function postNotification(name:String, ...rest):void
	{
		var callBackVect:Vector.<Function> = this.callBackDict.get(name);
		var thisObjVect:Array = this.thisObjDict.get(name);
		if (callBackVect)
		{
			var count:uint = callBackVect.length;
			for (var i:int = 0; i < count; i++) 
			{
				callBackVect[i].apply(thisObjVect[i], rest);
			}
		}
	}
	
	/**
	 * 删除消息侦查者
	 * @param	name	消息名称
	 */
	public function removeObserver(name:String):void
	{
		this.callBackDict.remove(name);
	}
	
	/**
	 * 删除所有消息侦查者
	 */
	public function removeObservers():void
	{
		this.callBackDict.clear();
	}
}
}

internal class Singletoner {  
} 