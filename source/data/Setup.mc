using Toybox.Time.Gregorian as Calendar;
using Toybox.Application as App;

using Toybox.System as Sys;

class Setup
{
	enum
	{
	    Timer_KEY,	    
	    Rest_KEY,	    
	    Reputation_KEY,
	    Vibrate_KEY,
	    Sound_KEY,
	    Light_KEY,
	    Autostart_KEY
	}

	var StretchDuration = Calendar.duration( {:hours=>0, :minutes=>0, :seconds=>45} );
	var RestDuration = Calendar.duration( {:hours=>0, :minutes=>0, :seconds=>5} );
	var Reputation = 0;
	var Vibrate = true;
	var Sound = false;
	var Light = false;
	var Modified = false;
	var Autostart = false;
	
	function initialize()
    {
    	LoadSetup();
    }
    
    function LoadSetup()
    {
    	var app = App.getApp();
    	//app.clearProperties();
    	var value = app.getProperty(Timer_KEY);
    	if(value != null)
    	{    		
			StretchDuration = Calendar.duration( {:seconds=>value} );
    	}
    	value = app.getProperty(Rest_KEY);
    	if(value != null)
    	{
    		RestDuration = Calendar.duration( {:seconds=>value} );
    	}
    	value = app.getProperty(Reputation_KEY);
    	if(value != null)
    	{
    		Reputation = value;
    	}
    	value = app.getProperty(Vibrate_KEY);
    	if(value != null)
    	{
    		Vibrate = value;
    	}
    	value = app.getProperty(Sound_KEY);
    	if(value != null)
    	{
    		Sound = value;
    	}
    	value = app.getProperty(Light_KEY);
    	if(value != null)
    	{
    		Light = value;
    	}
    	value = app.getProperty(Autostart_KEY);
    	if(value != null)
    	{
    		Autostart = value;
    	}
    }
    
    function StoreSetup()
    {
    	var app = App.getApp();
    	app.setProperty(Timer_KEY, StretchDuration.value());    	
    	app.setProperty(Rest_KEY, RestDuration.value());    	    	
    	app.setProperty(Reputation_KEY, Reputation);
    	app.setProperty(Vibrate_KEY, Vibrate);
    	app.setProperty(Sound_KEY, Sound);
    	app.setProperty(Light_KEY, Light);
    	app.setProperty(Autostart_KEY, Autostart);
    }
}