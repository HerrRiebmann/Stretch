using Toybox.Activity as Act;
using Toybox.ActivityRecording as ARec;
using Toybox.System as Sys;
using Toybox.FitContributor as Fit; 
using Toybox.WatchUi as Ui;

class Recorder
{
	var session = null;
	var supportsRecording = null;
	
	var repetitionField = null;
	var durationField = null;
	var restingField = null;
	//StockFields	
	var timeInPowerZone = null; //num 68 unit32 s *1000
	var timeStanding = null; //num 112 unint32 s *1000
	
	var customField = null;
	
	function initialize()
	{
		if(supportsRecording == null)
    	{
    		supportsRecording = Toybox has :ActivityRecording;    		
    		Sys.println("Supports recording");
    		if(supportsRecording)
    		{
    			//Position.enableLocationEvents(Position.LOCATION_DISABLE, null);
    		}    	    		
    	}
	}
	
    function ToggleRecording()
    {	
    	if(GlobalSetup.Recording && supportsRecording)
        {
            if(session == null )
            {            	            	
            	var str = Ui.loadResource(Rez.Strings.main_label_Stretch);
            	if(GlobalSetup.ActivityName != null)
            	{
            		str = GlobalSetup.ActivityName;
            	}
            	session = ARec.createSession({:name=>str,  :sport=>ARec.SPORT_TRAINING , :subSport=>ARec.SUB_SPORT_FLEXIBILITY_TRAINING });          	
            	
            }
            if(session.isRecording())
            {                                                
               	session.stop();
               	Sys.println("Stop recording");                	                
            }
            else
            {
             	session.start();
             	Sys.println("Start recording");
             	//Create fields !!after!! starting session
             	CreateCustomFields();             	                                               
            }
        }
    }
    function CreateCustomFields()
    {	       
    	if(customField != null)
    	{
    		return;
    	}     
    	if(Toybox has :FitContributor)
    	{    	
    		customField = new CustomField();	
    		//Repetitions Field ID 0			
		    repetitionField = customField.createField(Ui.loadResource(Rez.Strings.menu_label_Rep), 0, Fit.DATA_TYPE_UINT16,		     
			    {
				:mesgType => Fit.MESG_TYPE_SESSION,			
				:nativeNum=>113, //stand_count Uint16
				:units => Ui.loadResource(Rez.Strings.unit_Rep)
				});
		    repetitionField.setData(0);
		    
		    //Stretch Duration Field ID 1		    
		    durationField = customField.createField(Ui.loadResource(Rez.Strings.menu_label_Timer), 1, Fit.DATA_TYPE_UINT32,	    
		    
			    {
				:mesgType => Fit.MESG_TYPE_SESSION,			
				//:nativeNum=>112, //time_standing Uint32 s
				:units => Ui.loadResource(Rez.Strings.unit_Duration)
				});
		    durationField.setData(StretchTimer.GlobalSetup.StretchDuration.value());
		    
		    //Rest Interval Field ID 2
			restingField = customField.createField(Ui.loadResource(Rez.Strings.menu_label_Rest), 2, Fit.DATA_TYPE_UINT16,	 
				{
				:mesgType => Fit.MESG_TYPE_SESSION,
				:units => Ui.loadResource(Rez.Strings.unit_Duration)
				});
			restingField.setData(StretchTimer.GlobalSetup.RestDuration.value());
			
			//Stock Fields			
			timeInPowerZone = customField.createField(Ui.loadResource(Rez.Strings.TimeInPowerZone), 3, Fit.DATA_TYPE_UINT32,	 
				{
				:mesgType => Fit.MESG_TYPE_SESSION,
				:nativeNum=>68,
				:units => Ui.loadResource(Rez.Strings.unit_Duration)
				});			
			
			timeStanding = customField.createField(Ui.loadResource(Rez.Strings.TimeStanding), 4, Fit.DATA_TYPE_UINT32,	 
				{
				:mesgType => Fit.MESG_TYPE_SESSION,
				:nativeNum=>112,
				:units => Ui.loadResource(Rez.Strings.unit_Duration)
				});	
    	}
    	else
    	{
    		Sys.println("Custom Fields not supported!");
    	}
	    
    }
    
    function StoreFields()
    {
    	var completedReps = StretchTimer.reputation -1;
		if(repetitionField != null)
        {
        	repetitionField.setData(completedReps);
        	Sys.print("Repetition: ");
        	Sys.println(completedReps);
    	}
    	if(restingField != null)
        {            	
        	restingField.setData(StretchTimer.GlobalSetup.RestDuration.value());
        	Sys.print("Rest: ");
        	Sys.println(StretchTimer.GlobalSetup.RestDuration.value());
    	}
    	if(durationField != null)
        {               	
        	durationField.setData(StretchTimer.GlobalSetup.StretchDuration.value());
        	Sys.print("Duration: ");
        	Sys.println(StretchTimer.GlobalSetup.StretchDuration.value());
    	}
    	//Stock Fields:    	
    	if(timeInPowerZone != null)
    	{    	
    		//timeInPowerZone.setData(StretchTimer.GlobalSetup.StretchDuration.value() * completedReps * 1000);
    		timeInPowerZone.setData(StretchTimer.GlobalSetup.StretchDuration.value() * completedReps);
    	}
    	if(timeStanding != null)
    	{
    		//timeStanding.setData(StretchTimer.GlobalSetup.RestDuration.value() * completedReps * 1000);
    		timeStanding.setData(StretchTimer.GlobalSetup.RestDuration.value() * completedReps);
    	}
    }
    
    function SaveRecording()
    {	    	
    	if(GlobalSetup.Recording && supportsRecording && session != null)    	
        {	
        	if(session.isRecording())
            {                                                
               	session.stop();               	              	                
            }
        	StoreFields();      	        	      
            session.save();
            Sys.println("Store recording");        
        }
        else
        {
        	//deactivated recording during an activity => Remove
        	if(supportsRecording && session != null)
        	{
	        	if(session.isRecording())
	            {                                                
	               	session.stop();               	              	                
	            }
        		AbortRecording();
        	}
        }
    }
    
    function AddLap()
    {
    	if(IsRecording())
    	{    	
    		session.addLap();    		
    		Sys.println("Add Lap");    		
    	}        
    }
    
    function AbortRecording()
    {
    	if(supportsRecording && (session != null))
    	{
    		if(session.isRecording())
            {                                                
               	session.stop();               	              	                
            }
            session.discard();
            session = null;
            Sys.println("Discard Recording");
    	}
    }
    
    function IsRecording()
    {
    	return (GlobalSetup.Recording && supportsRecording && session != null && session.isRecording());
    }
}

class CustomField extends Ui.DataField 
{
    function initialize() {
		Ui.DataField.initialize();
    }
}