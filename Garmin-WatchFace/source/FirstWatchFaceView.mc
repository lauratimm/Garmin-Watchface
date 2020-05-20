using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang;

using Toybox.Time.Gregorian as Date;
using Toybox.Application as App;
using Toybox.ActivityMonitor as Mon;

class FirstWatchFaceView extends Ui.WatchFace {

        var HRimage;
		function initialize() {
		WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	HRimage = Ui.loadResource(Rez.Drawables.HRicon);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
	    setClockDisplay();
	    setMonthDayDisplay();
	    setBatteryDisplay();
	    setStepCountDisplay();
	    setHeartrateDisplay();
	    setCalorieDisplay();
	    dc.drawBitmap( 100, 143, HRimage);
	
		var battery = System.getSystemStats().battery;	
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        // Change to percentage width
		var batteryBar = (dc.getWidth()/150)*battery;  
		// draw in exchange with battery status
		if (battery<=10)
		{ 
				dc.setColor(Gfx.COLOR_DK_RED,Gfx.COLOR_WHITE);
				dc.drawRectangle(80, 35, batteryBar,3);
				dc.fillRectangle(80, 35, batteryBar,3);
		}
		else if (battery <=20)
		{ 
				dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_WHITE);
				dc.drawRectangle(80, 35, batteryBar,3);
				dc.fillRectangle(80, 35, batteryBar,3);
		}
		else if (battery <=30)
		{ 
				dc.setColor(Gfx.COLOR_ORANGE,Gfx.COLOR_WHITE);
				dc.drawRectangle(80, 35, batteryBar,3);
				dc.fillRectangle(80, 35, batteryBar,3);
		}
		else if (battery <=40)
		{ 
				dc.setColor(Gfx.COLOR_YELLOW,Gfx.COLOR_WHITE);
				dc.drawRectangle(80, 35, batteryBar,3);
				dc.fillRectangle(80, 35, batteryBar,3);
		}
		else if (battery <=50)
		{ 
				dc.setColor(Gfx.COLOR_GREEN,Gfx.COLOR_WHITE);
				dc.drawRectangle(80, 35, batteryBar,3);
				dc.fillRectangle(80, 35, batteryBar,3);
		}
		else
		{
    			dc.setColor(Gfx.COLOR_DK_GREEN,Gfx.COLOR_WHITE);
				dc.drawRectangle(80, 35, batteryBar,3);
				dc.fillRectangle(80, 35, batteryBar,3);
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    private function setClockDisplay() {
    	var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeDisplay");
        view.setText(timeString);
    }
    
    private function setMonthDayDisplay() {        
    	var now = Time.now();
		var date = Date.info(now, Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [date.month, date.day]);
		var dateDisplay = View.findDrawableById("MonthDayDisplay");      
		dateDisplay.setText(dateString);	    	
    }
    
    private function setBatteryDisplay() {
    	var battery = System.getSystemStats().battery;				
		var batteryDisplay = View.findDrawableById("BatteryDisplay");      
		batteryDisplay.setText(battery.format("%d")+"%");
		
    }
    
    private function setStepCountDisplay() {
    	var stepCount = Mon.getInfo().steps.toString();		
		var stepCountDisplay = View.findDrawableById("StepCountDisplay");      
		stepCountDisplay.setText(stepCount);		
    }
    
     private function setHeartrateDisplay() {
    	var heartRate = "";
    	
    	if(Mon has :INVALID_HR_SAMPLE) {
    		heartRate = retrieveHeartrateText();
    	}
    	else {
    		heartRate = "";
    	}
    	
	var heartrateDisplay = View.findDrawableById("HeartrateDisplay");      
	heartrateDisplay.setText(heartRate);
    }
       
    private function retrieveHeartrateText() {
    	var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
	var currentHeartrate = heartrateIterator.next().heartRate;

	if(currentHeartrate == Mon.INVALID_HR_SAMPLE) {
		return "";
	}		

	return currentHeartrate.format("%d");
    }    
    
    private function setCalorieDisplay() {
    	var calories = 	Mon.getInfo().calories.toString();	
		var kcalCalorieDisplay = View.findDrawableById("CalorieDisplay");      
		kcalCalorieDisplay.setText(calories);	
    }

}
