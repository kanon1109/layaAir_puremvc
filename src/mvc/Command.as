package mvc 
{
/**
 * ...用于初始化 view和proxy
 * @author Kanon
 */
public class Command 
{
	protected var facade:Facade;
	public function Command() 
	{
		facade = Facade.getInstance();
	}
	
	//执行
	public function execute(notification:Notification):void
	{
		//子类继承
	}
}
}