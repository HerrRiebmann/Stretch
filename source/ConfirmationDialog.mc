using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class CD extends Ui.ConfirmationDelegate
{
	hidden var _object;
    hidden var _symbol;
	function initialize(object, symbol)
	{
		ConfirmationDelegate.initialize();
		_object = object;
        _symbol = symbol;
	}
		
    function onResponse(value)
    {
        // this is a little-known trick to access a member		
        _object[_symbol] = value == 1;        
    }    
}

class ConfirmationDialog
{		
	function initialize(ConfCaption, object, symbol)
    {	
        var cd = new Ui.Confirmation( ConfCaption );        
        Ui.pushView( cd, new CD(object, symbol), Ui.SLIDE_IMMEDIATE );        
    }
}