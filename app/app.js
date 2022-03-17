
//Interaction with gpio
const Gpio = require('pigpio').Gpio; 
//var Gpio = require('onoff').Gpio; //include onoff to interact with the GPIO

var Web3 = require('web3')
var web3 = new Web3()

	// Web3 provider setting
	web3 = new Web3(new Web3.providers.HttpProvider("http://192.168.0.38:22000"));


	web3.eth.defaultAccount = web3.eth.accounts[0];


//contract abi update as deployed
        var deviceControl = web3.eth.contract(

        [{
		"constant": false,
		"inputs": [
			{
				"name": "_temperature",
				"type": "uint256"
			},
			{
				"name": "_humidity",
				"type": "uint256"
			},
			{
				"name": "_totalMeterSignal",
				"type": "uint256"
			},
			{
				"name": "_totalDevicesPowerValue",
				"type": "uint256"
			},
			{
				"name": "_hour",
				"type": "uint256"
			},
			{
				"name": "_ac1Power",
				"type": "uint256"
			},
			{
				"name": "_ac2Power",
				"type": "uint256"
			},
			{
				"name": "_ac3Power",
				"type": "uint256"
			},
			{
				"name": "_carBatteryPowerStatus",
				"type": "uint256"
			}
		],
		"name": "setContextData",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getContextData",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "ac2Power",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "carBatteryPowerStatus",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "ac1Power",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "totalDevicesPowerValue",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "humidity",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "temperature",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "totalMeterSignal",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "ac3Power",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]

		);

var device = deviceControl.at("0xa2c66ff8392b35742ecc82532f9069463c675c8e"); // smart contract addres, update as deployed

// Interaction with GPIO

const servoAc1 = new Gpio(4, {mode: Gpio.OUTPUT});//0
const servoAc2 = new Gpio(18, {mode: Gpio.OUTPUT});//1
const servoAc3 = new Gpio(26, {mode: Gpio.OUTPUT});//2
const carBattery = new Gpio(19, {mode: Gpio.OUTPUT});//3

//var LED = new Gpio(4, 'out'); //use GPIO pin 4, and specify that it is output

let pulseWidth = 1000; //for 0 degree
let increment = 100;


  var ac1Power = 0; //ac1;
  var ac2Power  = 0; //ac2;
  var ac3Power  = 0; // ac3;
  var bVoltage = 0;




var sensor = require("node-dht-sensor");
//var sensor2 = require("node-dht-sensor");


var sensorType=11;
var sensorPin=16;
if (!sensor.initialize(11,16))
{
	console.warn('failed to initialize sensor');
Process.exit(1);
}


setInterval(function() {
 var readout=sensor.read();



 const mcpadc = require('mcp-spi-adc');

 const ac = mcpadc.open(0, {speedHz: 1350000}, err => {
   if (err) throw err;



   setInterval(_ => {
	 ac.read((err, reading) => {
	   if (err) throw err;
 var accPower= 0;
	   console.log('Bit value for AC',reading);
	   var acbitvalue= reading.rawValue;
	   var acvoltage = (acbitvalue*5)/(1023);
	   var accurrent = (acvoltage-2.5)*0.185;
	   console.log('volatge AC is', acvoltage);
	   console.log('current  AC is', accurrent);
	   console.log('bitvalue is', reading.rawValue);
	  accPower = (5*accurrent).toFixed(1);
	  ac1Power=accPower;

	   console.log('Power for Ac is', 5*accurrent.toFixed(1), '\n');
	   //console.log(device.setContextAttributesData( acPower));
	 });




   },5000);
 });



 const heater = mcpadc.open(1, {speedHz: 1350000}, err => {
	 if (err) throw err;



	 setInterval(_ => {
	   heater.read((err, reading) => {
		 if (err) throw err;
   var hhPower=0;
		 console.log('Bit value for Heater', reading);
		 var hbitvalue= reading.rawValue;
		 var hvoltage = (hbitvalue*5)/(1023);
		 var hcurrent = (hvoltage-2.5)*0.185;
		 console.log('volatge for heater is', hvoltage);
		 console.log('current for heater is', hcurrent);
		 console.log('bitvalue is', reading.rawValue);
		 hhPower = (5*hcurrent).toFixed(1)
		 ac2Power=hhPower;
		 console.log('Power for Heater is', 5*hcurrent.toFixed(1) , '\n');
		 //console.log(device.setContextAttributesData(hPower));

	   });




	 }, 5000);
   });


   const washing = mcpadc.open(2, {speedHz: 1350000}, err => {
	 if (err) throw err;



	 setInterval(_ => {
	   washing.read((err, reading) => {
		 if (err) throw err;
   var wwPower=0;
		 console.log('Bit value for Washing',reading);
		 var wbitvalue= reading.rawValue;
		 var wvoltage = (wbitvalue*5)/(1023);
		 var wcurrent = (wvoltage-2.5)*0.185;
		 console.log('volatge  w is', wvoltage);
		 console.log('current w is', wcurrent);
		 console.log('bitvalue is', reading.rawValue);
		 wwPower = (5*wcurrent).toFixed(1);
		 ac3Power=wwPower;
		console.log('Power for washing is', 5*wcurrent.toFixed(1) , '\n');
		//console.log(device.setContextAttributesData( wPower));

	   });




	 }, 5000);
   });


   const carBattery = mcpadc.open(3, {speedHz: 1350000}, err => {
	if (err) throw err;



	setInterval(_ => {
	  carBattery.read((err, reading) => {
		if (err) throw err;
  var bbVoltage=0;
		console.log('Bit value for battery',reading);
		var bbitvalue= reading.rawValue;
		var bCarvoltage = (bbitvalue*5)/(1023);
		var bcurrent = (bCarvoltage-2.5)*0.185;  //subtracting the zero current voltage and multiplying by the sensitivity (0.185, 0.1, 0.066) along the lines
		console.log('volatge  w is', bCarvoltage);
		console.log('current w is', bcurrent);
		console.log('bitvalue for bvattery is', reading.rawValue);
		bbVoltage = (11.1*bbitvalue).toFixed(1);
		bVoltage= bbVoltage;
	   console.log('Battery Level in % is ', bbVoltage);
	   //console.log(device.setContextAttributesData( wPower));

	  });




	}, 5000);
  });






//sending data and time to blckchain

var now = new Date();
var minutes = now.getMinutes();
var hour = now.getHours();

console.log('Weather Conditions::'+'temperature: ' + readout.temperature.toFixed(1) + '°C,   ' + 'humidity: ' + readout.humidity.toFixed(1) + '%');
console.log(device.setContextAttributesData(readout.temperature.toFixed(1) ,readout.humidity.toFixed(1), ac1Power, ac2Power, ac3Power, hour, bVoltage));  // ac1. ac2, ac3, carBattery
console.log('those we want to send', acPower, hPower, wPower, bVoltage); // ac1. ac2, ac3, carBattery
console.log('the time is', hour. minutes);

var a = 0;





//let headers = ["Ac","Heater","Washing","Hour"].join("\t");
const fs = require('fs');

const array = [

  {Device: "AC",
  usage:ac1Power},
  {Device:"Heater",
  usage: ac2Power},
  {Device: "Washing", usage: ac3Power},
  {Time: "time",
	H:hour},
	{M:minutes}
];

const dataToSave = array.map(item => {
    return JSON.stringify(item)
      .replace(/\"/gi, '""');
  })
  .map(item => `"${item}"`)
  .join('\n');

fs.appendFile('js/export1.csv',  dataToSave, (err) => { //////fs.writeFile('js/export1.csv', dataToSave, (err) => {
    if (err) throw err;
    console.log('The file has been saved!');
});

}, 12000);
		// Automatically update sensor value every 12 seconds

//output data and devices

setInterval(function(){

	//let angle=0;
	//let increment=1;
	var result1 = device.getAcActionAttributes.call();
	var result2= device.getAc2ActionAttributes.call();
	var result3= device.getAc3ActionAttributes.call();
	var result4= device.getBatteryActionAttributes.call();

    var a=result1.toNumber(); //Ac1
	var b=result2.toNumber(); //Ac2
	var c=result3.toNumber(); //Ac3
	var d=result4.toNumber(); //battery

	console.log('ac1 result is',a);
	console.log('ac2 result is',b);
	console.log('ac3 result is',c);
	console.log('battery result is', d);

if (a== 0) {
setInterval(() => {
	servoAc1.servoWrite(pulseWidth);

	pulseWidth += increment;
	if (pulseWidth >= 2000) {
	  increment = -100;
	} else if (pulseWidth <= 1000) {
	  increment = 100;
	}
  }, 1000);
  }


  if (b== 0) {
  setInterval(() => {
	servoac2.servoWrite(pulseWidth);

	pulseWidth += increment;
	if (pulseWidth >= 2000) {
	  increment = -100;
	} else if (pulseWidth <= 1000) {
	  increment = 100;
	}
  }, 1000);

  }

  if (c== 0) {

  setInterval(() => {
	  servoAc3.servoWrite(pulseWidth);

	  pulseWidth += increment;
	  if (pulseWidth >= 2000) {
		increment = -100;
	  } else if (pulseWidth <= 1000) {
		increment = 100;
	  }
	}, 1000);
}

if (c== 0) {

function chargeBattery() { //function to start
	if (carBattery.readSync() === 0) { //check the pin state, if the state is 0 (or off)
	  carBattery.writeSync(1); //set pin state to 1 (turn on)
	} else {
	  carBattery.writeSync(0); //set pin state to 0 (turn off)
	}
  }
}


	 // calling the function every 20 seconds

	},20000);
