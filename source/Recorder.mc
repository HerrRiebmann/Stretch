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
    		Sys.println("Supports recording");    	    		
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
            	
				//CreateCustomFields();
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
    	}
    	else
    	{
    		Sys.println("Custom Fields not supported!");
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
            //CreateCustomFields();
            
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
    	if(IsRecording())
    	{    	
    		session.addLap();    		
    		Sys.println("Add Lap");
    		/*
    		if(repetitionField != null)
            {
            	repetitionField.setData(StretchTimer.reputation -1);            
        	}
        	*/
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
		//Ui.DataField.initialize();
    }
}