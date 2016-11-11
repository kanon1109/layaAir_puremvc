package sample.controller 
{
import mvc.Command;
import mvc.Notification;

/**
 * ...
 * @author Kanon
 */
public class InitDataCommand extends Command 
{
	override public function execute(notification:Notification):void 
	{
		this.facade.initData();
	}
}
}