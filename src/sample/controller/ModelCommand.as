package sample.controller 
{
import mvc.Command;
import mvc.Notification;
import sample.model.proxy.TestProxy;

/**
 * ...初始化数据代理
 * @author Kanon
 */
public class ModelCommand extends Command 
{
	override public function execute(notification:Notification):void 
	{
		this.facade.registerProxy(new TestProxy());
	}
}
}