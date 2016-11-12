package sample 
{
import mvc.Facade;
import sample.controller.InitDataCommand;
import sample.controller.ModelCommand;
import sample.controller.ViewCommand;
/**
 * ...mvc 测试
 * @author Kanon
 */
public class MvcTest 
{
	public function MvcTest() 
	{
		var m:ModelCommand = new ModelCommand();
		var v:ViewCommand = new ViewCommand();
		var initDataCommand:InitDataCommand = new InitDataCommand();
		m.execute(null);
		v.execute(null);
		initDataCommand.execute(null);
		
		Facade.getInstance().sendNotification("testMsg1");
		Facade.getInstance().sendNotification("testMsg2", { "aaa":1, "bbb":"in MvcTest params" } );
	}
	
}
}