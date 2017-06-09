#include<Timer.h>
#include<stdio.h>
#include<string.h>

module TempTestC
{
	uses
	{
		//General interfaces
		interface Boot;
		interface Timer<TMilli>;
		interface Leds;

		//Read temp
		interface Read<uint16_t> as TempRead;
		
		//Read luminosity
		interface Read<uint16_t> as LightRead;

		//Read humidity
		interface Read<uint16_t> as HumRead;
	}
}

implementation
{
	uint16_t centiGrade;
	uint16_t luminance;
	uint16_t humidity;

	event void Boot.booted()
	{
		call Timer.startPeriodic(60000);
		call Leds.led1On();
	}

	event void Timer.fired()
	{
		if(call TempRead.read() == SUCCESS && call LightRead.read() == SUCCESS && call HumRead.read() == SUCCESS)
		{
			call Leds.led2Toggle();
		}
		else
		{
			call Leds.led0Toggle();
		}
	}

	event void TempRead.readDone(error_t result, uint16_t val)
	{
		if(result == SUCCESS)
		{
			centiGrade = (-40.1 + 0.01 *val);
			printf("Temp;%d;\r\n", centiGrade);
		}
		else
		{	
			printf("Error \r\n");
		}
	}
	
	event void LightRead.readDone(error_t result, uint16_t val)
	{
		if(result == SUCCESS)
		{
			luminance = 2.5 * (val/4096.0)*6250.0;
			printf("Light;%d;\r\n", luminance);
		}
		else
		{	
			printf("Error \r\n");
		}
	}
	event void HumRead.readDone(error_t result, uint16_t val)
	{
		if(result == SUCCESS)
		{
			
			humidity = -4 + 0.0405 * val - 2.8/1000000 * val;
			humidity = (centiGrade-25)*(0.01+0.00008*val)+humidity;
			printf("Hum;%d;\r\n", humidity);			
		}
		else
		{	
			printf("Error \r\n");
					
		}
	}
}
