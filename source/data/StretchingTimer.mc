using Toybox.Attention as Att;

class StretchingTimer
{
	enum
	{
		Short,
		Long,
		Double
	}

	var running = false;
	hidden var stretchActive = false;
	hidden var restActive = true;
	var reputation = 0;
	var timeToElapse = 0;
	
	function initialize()
	{
		Init();
	}
	
	function Init()
	{
		running = false;
		stretchActive = false;
		restActive = true;
		reputation = 1;		
		timeToElapse = GlobalSetup.RestDuration.value();
	}
	
	function StretchActive(active)
	{
		if(active != null)
		{
			stretchActive = active;
			restActive = !active;
		}
		return stretchActive;
	}
	
	function RestActive(active)
	{
		if(active != null)
		{
			stretchActive = !active;
			restActive = active;
		}
		return restActive;
	}
	
	function ToggleStart()
	{
		Notify(Short);
		if(!running)
		{
			if(timeToElapse <= 0)
			{
				if(stretchActive)
				{
					timeToElapse = GlobalSetup.StretchDuration.value();
				}	
				if(restActive)
				{
					timeToElapse = GlobalSetup.RestDuration.value();
				}
			}
			running = true;			
		}
		else
		{
			running = false;
		}
	}
		
	
	function Tick()
	{
		if(!running)
		{
			return;
		}
		
		timeToElapse -= 1;
		
		if(timeToElapse < 0)
		{
			//Stretching finished:
			if(stretchActive)
			{
				reputation += 1;
				if(GlobalSetup.RestDuration.value() > 0)
				{
					Notify(Double);
				}
			}
			else
			{
				//Rest finished
				Notify(Long);
			}
			StretchActive(!stretchActive);
			if(stretchActive)
			{
				timeToElapse = GlobalSetup.StretchDuration.value();
			}	
			if(restActive)
			{
				timeToElapse = GlobalSetup.RestDuration.value();
			}
		}
		if(GlobalSetup.Reputation > 0)
		{			
			if(reputation > GlobalSetup.Reputation)
			{
				//Finish!
				Notify(Long);
				Notify(Short);
				Notify(Double);
				Init();			
			}
		}
	}
	
	function Notify(mode)
	{
		
		var	hasTone = Att has :playTone;
		if(hasTone)
		{
			hasTone = GlobalSetup.Sound;
		}
		var hasVibrate = Att has :vibrate;
		if(hasVibrate)
		{
			hasVibrate = GlobalSetup.Vibrate;
		}
		
		if(mode == Short)
		{
			if(hasVibrate)
			{
				var vibrateData = [new Att.VibeProfile( 50, 150 )];				
				Att.vibrate(vibrateData);
			}
			if(hasTone)
			{
				Att.playTone(Att.TONE_KEY);
			}
		}
		if(mode == Long)
		{
			if(hasVibrate)
			{
				var vibrateData = [new Att.VibeProfile(  50, 150 ),                                     
                    new Att.VibeProfile( 100, 200 ),                    
                    new Att.VibeProfile(  50, 100 )];
                Att.vibrate(vibrateData);
			}
			if(hasTone)
			{
				Att.playTone(Att.TONE_TIME_ALERT);
			}
		}
		if(mode == Double)
		{
			if(hasVibrate)
			{
				var vibrateData = [new Att.VibeProfile(  25, 150 ),                                     
                    new Att.VibeProfile( 100, 200 ),                    
                    new Att.VibeProfile(  25, 100 ),
                    new Att.VibeProfile(  0, 200 ),
                    new Att.VibeProfile( 100, 200 ),                    
                    new Att.VibeProfile(  25, 100 )];
                Att.vibrate(vibrateData);
			}
			if(hasTone)
			{
				Att.playTone(Att.TONE_ALERT_HI);
				Att.playTone(Att.TONE_ALERT_LO);
			 	Att.playTone(Att.TONE_ALERT_HI);
				Att.playTone(Att.TONE_ALERT_LO);
			}
		}
	}	
}