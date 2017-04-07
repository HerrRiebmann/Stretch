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
	
	var customField = null;
	function initialize()
	{
		if(supportsRecording == null)
    	{
    		supportsRecording = Toybox has :ActivityRecording;
    		customField = new CustomField();
    		Sys.println("Supports recording");    	    		
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
    		//DATA_TYPE_UINT8 = 2
			//DATA_TYPE_INT32 = 5
			//DATA_TYPE_STRING = 7
			
    		//Repetitions    		    		
	    	var options = {
			:msgType => Fit.MESG_TYPE_SESSION,
			//:count => 1, // assuming the longest string you need to support is 9 characters long
			:nativeNum=>113, //stand_count
			:units => Ui.loadResource(Rez.Strings.unit_Rep)
			};			
			//0 Field ID						
		    //repetitionField = session.createField(Ui.loadResource(Rez.Strings.menu_label_Rep), 0, Fit.DATA_TYPE_UINT8, options);
		    repetitionField = customField.createField(Ui.loadResource(Rez.Strings.menu_label_Rep), 0, Fit.DATA_TYPE_UINT16, options);
		    repetitionField.setData(0);
		    
		    //Stretch Duration    
		    options = {
			:msgType => Fit.MESG_TYPE_SESSION,
			//:count => 1, // assuming the longest string you need to support is 9 characters long
			:nativeNum=>112, //time_standing
			:units => Ui.loadResource(Rez.Strings.unit_Duration)
			};
			//1 Field ID
		    //durationField = session.createField(Ui.loadResource(Rez.Strings.menu_label_Timer), 1, Fit.DATA_TYPE_UINT16, options);
		    durationField = customField.createField(Ui.loadResource(Rez.Strings.menu_label_Timer), 1, Fit.DATA_TYPE_UINT32, options);
		    durationField.setData(StretchTimer.GlobalSetup.StretchDuration.value());
		    
		    //Rest Interval
			restingField = customField.createField(Ui.loadResource(Rez.Strings.menu_label_Rest), 2, Fit.DATA_TYPE_UINT16, 
		    {
			:msgType => Fit.MESG_TYPE_SESSION,			
			:units => Ui.loadResource(Rez.Strings.unit_Duration)
			});
			restingField.setData(StretchTimer.GlobalSetup.RestDuration.value());
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
            	Sys.print("Repetition: ");
            	Sys.println(StretchTimer.reputation -1);
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
    	if(GlobalSetup.Recording && supportsRecording && (session != null) && session.isRecording())
    	{    	
    		session.addLap();    		
    		Sys.println("Add Lap");
    		if(repetitionField != null)
            {
            	repetitionField.setData(StretchTimer.reputation -1);            
        	}
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
    // Label Variables
    // Fit Contributor


    // Constructor
    function initialize() {


    }
}