package sample.controller 
{
import mvc.Command;
import mvc.Notification;
import sample.view.mediator.TestMediator;

/**
 * ...
 * @author Kanon
 */
public class ViewCommand extends Command 
{
	override public function execute(notification:Notification):void 
	{
		this.facade.registerMediator(new TestMediator());
	}
}
}