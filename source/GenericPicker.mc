using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;

enum
{
	GENERIC_PICKER_Number,
	GENERIC_PICKER_Time,
	GENERIC_PICKER_Bool
}
	
class NumberFactory extends Ui.PickerFactory
{
	hidden var _maxSize;
	function initialize(maxSize)
	{
		PickerFactory.initialize();
		_maxSize = maxSize;
	}
	function getDrawable(item, isSelected)
	{
	    return new Ui.Text({:text=>item.toString(),
	                        :color=>Gfx.COLOR_WHITE,
	                        :font=>Gfx.FONT_NUMBER_THAI_HOT,
	                        :justification=>Gfx.TEXT_JUSTIFY_LEFT});
	}
	function getSize()
	{
		return _maxSize;
	}
	function getValue(item)
	{
		return item;
	}
}

class BoolFactory extends Ui.PickerFactory
{
	function initialize()
	{
		PickerFactory.initialize();
	}
	function getDrawable(item, isSelected)
	{
	    return new Ui.Text({:text=>item.toString(),
	                        :color=>Gfx.COLOR_WHITE,
	                        :font=>Gfx.FONT_NUMBER_THAI_HOT,
	                        :justification=>Gfx.TEXT_JUSTIFY_LEFT});
	}
	function getSize()
	{
		return 2;
	}
	function getValue(item)
	{
		return item;
	}
}

class MyPickerDelegate extends Ui.PickerDelegate
{
	hidden var _mode;
	hidden var _object;
    hidden var _symbol;    
    
    function initialize(mode, object, symbol)
	{
		PickerDelegate.initialize();
		_mode = mode;
		_object = object;
        _symbol = symbol;
	}
	
  function onAccept( values )
  {   
   //Single Value 
   if(values.size() == 1)
   {   				
        _object[_symbol] = values[0]; 
   }
   else
   if(_mode == GENERIC_PICKER_Time && values.size() == 2)
   {	   	    	
   		_object[_symbol] = Calendar.duration( {:hours=>0, :minutes=>values[0], :seconds=>values[1]} );	   
   }
   Ui.popView(Ui.SLIDE_DOWN);
   return true;
  }
  function onCancel( )
  {
  	Ui.popView(Ui.SLIDE_DOWN);
  	return true;
  }
}

class GenericPickerDialog
{	
	function initialize(mode, title, object, symbol)
    {	    	    
		var value = object[symbol];
		if(mode == GENERIC_PICKER_Number && value instanceof Toybox.Lang.Number)
		{			
			Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>title}),
                               :pattern=>[new NumberFactory(99)],
                               :defaults=>[value]}),
                new MyPickerDelegate(mode, object, symbol),
                Ui.SLIDE_UP );
		}
		    
		if(mode == GENERIC_PICKER_Bool && value instanceof Toybox.Lang.Boolean)
		{			
			Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>title}),
                               :pattern=>[new BoolFactory()],
                               :defaults=>[value]}),
                new MyPickerDelegate(mode, object, symbol),
                Ui.SLIDE_UP );
		}
		
		if(mode == GENERIC_PICKER_Time)
		{			
			//Duration Object
			if(!(value instanceof Toybox.Lang.Number))
			{				
				value = value.value();
			}			
			var value1 = 0;
			var value2 = 0;
			if(value >= 60)
			{
				value1 = value / 60;
            }
            value2 = value % 60;            
            Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>title}),
                               :pattern=>[new NumberFactory(9), new NumberFactory(59)],
                               :defaults=>[value1,value2]}),
                new MyPickerDelegate(mode, object, symbol),
                Ui.SLIDE_UP );
		}        
    }
}