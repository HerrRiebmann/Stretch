using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Sensor as Snsr;

/*//Ideas
Optimize Timer (real second)
Multiple Timers
Naming Timers (via Smartphone)
*/

class StretchingView extends Ui.View
{
	var timer;
	//Timer-Test
	var callbackTime = 1000;//1 Sec	
	var btAvailable = null;
	var notiAvailable = null;
	
    function initialize()
    {
        View.initialize();        
        onTimer();
        timer = new Timer.Timer();        
        //timer.start(method(:onTimer), callbackTime, true);
        Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
        Snsr.enableSensorEvents( method(:onSnsr));
        StretchTimer.running = GlobalSetup.Autostart;
        if(GlobalSetup.Autostart)
        {
        	ActivityRecorder.ToggleRecording();
        }
    }

    //! Load your resources here
    function onLayout(dc)
    {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow()
    {
    	//Call once to avoid waiting one second
    	onTimer();    	   
        timer.start(method(:onTimer), callbackTime, true);        
    }

    //! Update the view
    function onUpdate(dc)
    {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);        
        setTime();
        setPhoneStatus();
        setRecordingStatus();
        UpdateTimer(dc);
    }
    
	function UpdateTimer(dc)
	{		
        var view = View.findDrawableById("lblElapse");
	  	setTimePretty(view, StretchTimer.timeToElapse);
	  	if(StretchTimer.StretchActive(null))
	  	{    	  	
	  		view.setColor(Gfx.COLOR_GREEN);
	  	}   
	  	else
	  	{
	  		view.setColor(Gfx.COLOR_RED);
	  	}     
        view = View.findDrawableById("lblRep");
        if(GlobalSetup.Reputation > 0)
        {
        	view.setText(StretchTimer.reputation + "/" + GlobalSetup.Reputation);
        }   
        else
        {        
        	view.setText(StretchTimer.reputation.toString());
        }     
        view = View.findDrawableById("lblTypeNext");
        if(StretchTimer.StretchActive(null))
        {
        	view.setText(Rez.Strings.main_label_Rest);
        	view = View.findDrawableById("lblTypeActive");
        	view.setText(Rez.Strings.main_label_Stretch);
        	view = View.findDrawableById("lblNext");
        	setTimePretty(view, GlobalSetup.RestDuration.value());        	
        }   
        else
        {
        	view.setText(Rez.Strings.main_label_Stretch);
        	view = View.findDrawableById("lblTypeActive");
        	view.setText(Rez.Strings.main_label_Rest);
        	view = View.findDrawableById("lblNext");
        	setTimePretty(view, GlobalSetup.StretchDuration.value());
        }
	}

	function setTimePretty(view, duration)
	{		
	  	var minutes = duration / 60;
	  	var seconds = duration % 60;
	  	if(minutes <= 9)
        {
        	minutes = "0" + minutes.toString();
    	}	    	 
        if(seconds <= 9)
        {
        	seconds = "0" + seconds.toString();
    	}
    	view.setText(minutes + ":" + seconds);
	}

	function setTime()
    {
    	var clockTime = Sys.getClockTime();
        var hour;
        var min;
        
        if(clockTime.hour <= 9)
        {
        	hour = "0" + clockTime.hour.toString();
    	}
    	else
    	{
    		hour = clockTime.hour.toString();
    	} 
        if(clockTime.min <= 9)
        {
        	min = "0" + clockTime.min.toString();
    	}
    	else
    	{
    		min = clockTime.min.toString();
    	}
        var view = View.findDrawableById("time");
        view.setText(hour + ":" + min);
    }

	function setPhoneStatus()
	{
		var settings = null;
		if(btAvailable == null)
		{
			settings = Sys.getDeviceSettings();
			btAvailable = settings has :phoneConnected;
		}
		
		if(notiAvailable == null)
		{
			if(settings == null)
			{
				settings = Sys.getDeviceSettings();
			}
			notiAvailable = settings has :notificationCount;
		}
		if(btAvailable)
		{
			if(settings == null)
			{
				settings = Sys.getDeviceSettings();
			}				
			var view = View.findDrawableById("Bluetooth");		
			if (settings.phoneConnected)
			{			
	            if(view.locX < 0)
	            {
	            	view.locX *= -1;
	            } 			        	
			}
			else
			{		
	            if(view.locX > 0)
	            {
	            	view.locX *= -1;
	            } 
	        }	
		}
		
		if(notiAvailable)
		{
			if(settings == null)
			{
				settings = Sys.getDeviceSettings();
			}				
			var view = View.findDrawableById("Messages");		
			if (settings.notificationCount > 0)
			{	
	            if(view.locX < 0)
	            {
	            	view.locX *= -1;
	            } 
	            view = View.findDrawableById("MessageCounter");
	            view.setText(settings.notificationCount.toString());			        	
			}
			else
			{		
	            if(view.locX > 0)
	            {
	            	view.locX *= -1;
	            } 
	            view = View.findDrawableById("MessageCounter");
	            view.setText("");
	        }	
		}		
		return true;
	}

	function setRecordingStatus()
	{
		var view = View.findDrawableById("bmpRecording");
		if(ActivityRecorder.IsRecording())
		{
			if(view.locX < 0)
	        {
	        	view.locX *= -1;
	        }
        }else
        {
        	if(view.locX > 0)
            {
            	view.locX *= -1;
            } 
        }
	}

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide()
    {    
    	/*
    	if(StretchTimer.running)
        {        	        	
			StretchTimer.running = false;
			ActivityRecorder.ToggleRecording();
        }   
        timer.stop();
        */        
    }
    
    function onTimer()
    {
    	StretchTimer.Tick();
        //Kick the display update
        Ui.requestUpdate();
    }
    
    function onSnsr(sensor_info)
    {
    	var view = View.findDrawableById("heartrate");
        var HR = sensor_info.heartRate;        
        if(sensor_info.heartRate != null)
        {        	
            view.setText(HR.toString());
            view = View.findDrawableById("Heart");
            if(view.locX < 0)
            {
            	view.locX *= -1;
            }
        }
        else
        {
        	view.setText("");        	
        	view = View.findDrawableById("Heart");        	
            if(view.locX > 0)
            {
            	view.locX *= -1;
            }            
        }        
    }
}
