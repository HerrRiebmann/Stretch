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
	
	function initialize()
	{
		if(supportsRecording == null)
    	{
    		supportsRecording = Toybox has :ActivityRecording;    		    		
    	}
	}
	
    function ToggleRecording()
    {	
    	if(GlobalSetup.Recording && supportsRecording)
        {
            if(session == null )
            {
            	//SPORT_GENERIC
            	//ToDo: Type?!?
            	var str = Ui.loadResource(Rez.Strings.main_label_Stretch);	
            	session = ARec.createSession({:name=>str,  :sport=>ARec.SPORT_TRAINING , :subSport=>ARec.SUB_SPORT_FLEXIBILITY_TRAINING });           	
            	
				CreateCustomFields();
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
            }
        }
    }
    function CreateCustomFields()
    {	            
    	if(Toybox has :FitContributor)
    	{
    		// Messages Written once per session at the end of recording
    		var str = Ui.loadResource(Rez.Strings.unit_Rep);
	    	var options = {
			:msgType => Fit.MESG_TYPE_SESSION,
			:count => 1, // assuming the longest string you need to support is 9 characters long
			:units => str,
			:nativeNum => 1
			};			
			//DATA_TYPE_UINT8 = 2
		    repetitionField = session.createField((Rez.Strings.menu_label_Rep).toString(), 0, 2, options);
		    
		    //Info on each Lap
		    str = Ui.loadResource(Rez.Strings.unit_Duration);
		    options = {
			:msgType => Fit.MESG_TYPE_LAP,
			//:count => 1, // assuming the longest string you need to support is 9 characters long
			:units => str,
			:nativeNum => 1
			};
			//DATA_TYPE_STRING = 7
			//DATA_TYPE_INT32 = 5
			//ToDo: Test description
		    durationField = session.createField((Rez.Strings.menu_label_Timer).toString(), 1, 5, options);
		    //durationField = session.createField("Intervall", 2, 5, options);    		
    	}
    	else
    	{
    		Sys.println("Custom Fields not supported");
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
            if(repetitionField != null)
            {
            	repetitionField.setData(StretchTimer.reputation -1);
        	}            
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
    	if(GlobalSetup.Recording && supportsRecording && session != null && session.isRecording())
    	{
    		session.addLap();
    		if(durationField != null)
            {
            	//ToDo: Field and/or AddLap
            	durationField.setData(GlobalSetup.StretchDuration.value());
        	}
    		Sys.println("Add Lap");
    	}        
    }
    
    function AbortRecording()
    {
    	if(supportsRecording && session != null)
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