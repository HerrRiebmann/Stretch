using Toybox.Application as App;
using Toybox.WatchUi as Ui;

var GlobalSetup;
var StretchTimer;
var ActivityRecorder;

class StretchingApp extends App.AppBase
{		
    function initialize()
    {
        AppBase.initialize();
        GlobalSetup = new Setup();
        StretchTimer = new StretchingTimer();
        ActivityRecorder = new Recorder(); 
    }

    //! onStart() is called on application start up
    function onStart(state)
    {
    }

    //! onStop() is called when your application is exiting
    function onStop(state)
    {    
    	GlobalSetup.StoreSetup();
    	ActivityRecorder.SaveRecording();
    }

    //! Return the initial view of your application here
    function getInitialView()
    {
        return [ new StretchingView(), new StretchingDelegate() ];
    }
    
	function onSettingsChanged()
    {    	
		GlobalSetup.LoadSetup();		
	}
}