using Toybox.WatchUi as Ui;
using Toybox.Attention as Att;
using Toybox.System as Sys;

class StretchingDelegate extends Ui.BehaviorDelegate
{		
    function initialize()
    {
        BehaviorDelegate.initialize();
    }

    function onMenu()
    {
    	StretchTimer.running = false;
    	var menu = new Rez.Menus.MainMenu();
    	AddSupport(menu);
        Ui.pushView(menu, new StretchingMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

	function AddSupport(menu)
    {   
		if(Att has :vibrate)
		{						
			menu.addItem(Rez.Strings.menu_label_Vibrate, :item_4);
		}
		
		if(Att has :playTone)
		{			
			menu.addItem(Rez.Strings.menu_label_Sound, :item_5);
		}
    }
    
    function onKey(evt)    
    {
    	var key = evt.getKey();		  	      
    	//Action
		if(key == Ui.KEY_ENTER)
	    {
	    	Sys.println("Start/Stop Activity");
	    	StretchTimer.ToggleStart();
	    }
	    //Light/Power
	    else if(key == Ui.KEY_POWER)
	    {    
        	Sys.println("Power/Light-Key");        	
    	}
    	//Back
    	else if(key == Ui.KEY_ESC)
	    {	    	   
        	Sys.println("ESC-Key: Rollback");          	
    	}
    	//Menu
		else if(key == Ui.KEY_MENU)
	    {   
	    	Sys.println("Menu");
    	}
    	else if(key == 23 || key == 13 || key == 8)
    	{
    		onMenu();
    		return true;
    	}
    	else
    	{
    		Sys.println("Key" + key.toString());
		}
		return false;
    }
}