using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;

class NP extends Ui.NumberPickerDelegate
{
	hidden var _object;
    hidden var _symbol;
    
    function initialize(object, symbol)
	{
		NumberPickerDelegate.initialize();
		_object = object;
        _symbol = symbol;
	}
	
    function onNumberPicked(value)
    {
        // this is a little-known trick to access a member		
        _object[_symbol] = value; 
    }
}
class NumberPickerDialog
{
	function initialize(type, object, symbol)
    {	    
		var value = object[symbol];
        var np = new Ui.NumberPicker( type, value );
        Ui.pushView( np, new NP(object, symbol), Ui.SLIDE_IMMEDIATE );
    }
}