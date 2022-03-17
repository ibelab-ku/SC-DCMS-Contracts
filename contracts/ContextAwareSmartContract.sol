pragma solidity^0.5.0;

/*Receiving the context attributes from the sensors
such as the temperature, humidity, current and power sensors
using Celcius and power values 
*/

contract ContextManager

{    
    uint public temperature;
    uint public humidity;
    uint public totalMeterSignal;
    uint public totalDevicesPowerValue; //initialize according to your devices power use
    uint public ac1Power;
    uint public ac2Power;
    uint public ac3Power;
    uint public carBatteryPowerStatus;
    uint hour;
 
    function setContextData (uint _temperature, uint _humidity,
        uint _totalMeterSignal,
        uint _totalDevicesPowerValue,
        uint _hour,
        uint _ac1Power,
        uint _ac2Power,
        uint _ac3Power,
        uint _carBatteryPowerStatus) public 
    { 
        temperature = _temperature;
        humidity = _humidity;   
        hour = _hour;
        totalMeterSignal = _totalMeterSignal;
        ac1Power = _ac1Power;
        ac2Power = _ac2Power;
        ac3Power = _ac3Power;
        carBatteryPowerStatus= _carBatteryPowerStatus;
        totalDevicesPowerValue= _totalDevicesPowerValue;
    }
    
    function getContextData() public view returns (uint, uint,uint,
    uint, uint, uint,uint, uint)
    {        
        return (temperature, humidity,
        hour,
        totalMeterSignal,
        ac1Power,
        ac2Power,
        ac3Power,
        carBatteryPowerStatus);
    }
    
}

/*Making  a plan and analyse of the context
and for what kind of change and result of the context for the system*/

contract Reasoner is ContextManager
{    
    bool public stateOfDevices;
    bool public stateHumidity;
    bool public stateTemperature;
   
    enum DeviceStatusForAc1 { 
        ON, OFF  // ON is 0 and OFF is 1
        }
      
    enum DeviceStatusForAc2{       
       ON, OFF // ON is 0 and OFF is 1
        } 
   
     enum DeviceStatusForAc3 {        
       ON, OFF  // On is 0 and OFF is 1
        }
   
    enum DeviceStatusForBatteryCharging { 
          ON, OFF // On is 0 and OFF is 1
        }
   
   DeviceStatusForAc1 changeAc1Status;
   DeviceStatusForAc2 changeAc2Status;
   DeviceStatusForAc3 changeAc3Status;
   DeviceStatusForBatteryCharging changeBatteryStatus;
            
    function setAppliancesContextState() public     
        {
            //stateTemperature= _stateTemperature;
            // Watts = AmpsRMS * AC_VOLT;
        totalDevicesPowerValue = ac1Power+ac2Power+ac3Power;
            
        if (totalDevicesPowerValue > totalMeterSignal ) //off devices        
        { 
            stateOfDevices= false ;
            changeAc1Status = DeviceStatusForAc1.OFF;
            changeAc2Status = DeviceStatusForAc2.OFF;
            changeAc3Status = DeviceStatusForAc3.OFF;
            changeBatteryStatus = DeviceStatusForBatteryCharging.OFF;
        }        
        else if (totalDevicesPowerValue < totalMeterSignal) 
            {
            //check weather                    
                if (temperature > 28 && humidity > 30 )
                   { 
                       changeAc1Status = DeviceStatusForAc1.ON;
                       changeAc2Status =DeviceStatusForAc2.OFF;            
                    }
                    else if (temperature < 28 && humidity < 30 ) //on fan
                         { 
                            changeAc1Status = DeviceStatusForAc1.OFF;
                            changeAc2Status = DeviceStatusForAc2.ON;
                        }
                    else
                        {
                            changeAc1Status = DeviceStatusForAc1.ON;
                            changeAc2Status = DeviceStatusForAc2.ON;
                        }                    
            //check priority
            
            //check time
                setAc3ContextState();
                setCarBatteryContextState();
            }
    }
    
     function setAc3ContextState( ) public 
    {
        if (hour >= 10 && hour <= 18) //duration
        
         {changeAc3Status = DeviceStatusForAc3.ON;}
             
         else if (hour <= 10 && hour >= 18) //time

         {changeAc3Status= DeviceStatusForAc3.OFF;}
    }
    
    function setCarBatteryContextState( ) public 
    {         
        if (hour >= 21 && hour <= 8 && carBatteryPowerStatus <=20) //time
        
         {changeBatteryStatus =DeviceStatusForBatteryCharging.ON;}
         
         else if
         
         (hour < 21 && hour > 8 && carBatteryPowerStatus >=80)
         
         {changeBatteryStatus= DeviceStatusForBatteryCharging.OFF;}
    }
}

/* Result of the desired action attributes to be sent for actuation to take place
situation and actions to take place
*/
     
contract OperationsManager is Reasoner { 
        
        //event fanEvent (uint data1);
        //event windowEvent (uint data2);
   
    function getAcActionAttributes() public  returns (DeviceStatusForAc1)
    {
        setAppliancesContextState();
       
        //return enableF;
        // emit fanEvent(enableF);
   
        // function getStatus() public view returns (DeviceStatus) {
        return changeAc1Status;
    
    }
  
     
     
    function getAc2ActionAttributes() public  returns (DeviceStatusForAc2)
    { 
        setAppliancesContextState();
        //return enableW;
        // emit windowEvent(enableW);
        
        // function getStatus() public view returns (DeviceStatus) {
        return changeAc2Status;
        
        
    }
    
    
    function getAc3ActionAttributes() public  returns (DeviceStatusForAc3)
    { 
        setAc3ContextState();
        
        //return enableW;
        // emit windowEvent(enableW);
        
        // function getStatus() public view returns (DeviceStatus) {
        return changeAc3Status;
    }
    
    function getBatteryActionAttributes() public  returns (DeviceStatusForBatteryCharging)
    { 
        setCarBatteryContextState();
        
        //return enableW;
        // emit windowEvent(enableW);
        
        // function getStatus() public view returns (DeviceStatus) {
        return changeBatteryStatus;
        
    }
}






