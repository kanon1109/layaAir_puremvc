package sample 
{
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
	}
	
}
}