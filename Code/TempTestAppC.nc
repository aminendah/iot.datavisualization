configuration TempTestAppC
{
}

implementation
{
	//General components
	components TempTestC as App;
	components MainC, LedsC;
	components new TimerMilliC();

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer -> TimerMilliC;
	
	//for writing into serial port
	components SerialPrintfC;
	
	//Temperature components
	components new SensirionSht11C() as TempSensor;

	App.TempRead -> TempSensor.Temperature;

	//Light components
	components new HamamatsuS10871TsrC() as LightSensor;

	App.LightRead -> LightSensor;
	
	//Humidity components
	components new SensirionSht11C() as HumSensor;

	App.HumRead -> HumSensor.Humidity;
}
