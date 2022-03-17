const Gpio = require('pigpio').Gpio;

//const spi = require('spi-device');

const motor1 = new Gpio(4, {mode: Gpio.OUTPUT});
const motor2 = new Gpio(10, {mode: Gpio.OUTPUT});
const motor3 = new Gpio(26, {mode: Gpio.OUTPUT});


let angle=0;
let increment=1;
let pulseWidth_0 = 1000; //for 0 degree
let pulseWidth_180 = 2000;// for 180 degrees


function moveServo1To(angle){
  let microseconds=pulseWidth_0+angle/180*(pulseWidth_180-pulseWidth_0);
  motor1.servoWrite(Math.round(microseconds));
  motor2.servoWrite(Math.round(microseconds));
  motor3.servoWrite(Math.round(microseconds));}

  var inter=setInterval(()=>{

   moveServo1To(angle);
    angle+=increment;
    if (angle>=180)
    {increment=-1;}

    else if (angle<=0){
      increment=1;
    }
    if(increment>=5 || increment<=-5)
   {clearInterval(inter);}
  },);
 // clearInterval(inter);

function moveServo1To(angle){
  let microseconds=pulseWidth_0+angle/180*(pulseWidth_180-pulseWidth_0);
  motor1.servoWrite(Math.round(microseconds));}



  setInterval(()=>{

    moveServo1To(angle);
    angle+=increment;
    if (angle>=180)
    {increment=-1;}

    else if (angle<=0){
      increment=1;
    }
    //process.exit(1);
  });
 // break;
  function moveServo2To(angle){
    let microseconds=pulseWidth_0+angle/180*(pulseWidth_180-pulseWidth_0);
    motor2.servoWrite(Math.round(microseconds));}



    setInterval(()=>{

      moveServo2To(angle);
      angle+=increment;
      if (angle>=180)
      {increment=-1;}

      else if (angle<=0){
        increment=1;
      }
    });
   // break;
    function moveServo3To(angle){
      let microseconds=pulseWidth_0+angle/180*(pulseWidth_180-pulseWidth_0);
      motor3.servoWrite(Math.round(microseconds));}



      setInterval(()=>{

        moveServo3To(angle);
        angle+=increment;
        if (angle>=180)
        {increment=-1;}

        else if (angle<=0){
          increment=1;
        }
      });





      const mcpadc = require('mcp-spi-adc');

      const tempSensor = mcpadc.open(0, {speedHz: 20000}, err => {
        if (err) throw err;

        setInterval(_ => {
          tempSensor.read((err, reading) => {
            if (err) throw err;
            console.log('0');
      console.log(reading);
            console.log((reading.value * 3.3 - 0.5) * 100);
          });
        }, 5000);
      });


      //const mcpadc = require('mcp-spi-adc');

      const temp = mcpadc.open(1, {speedHz: 20000}, err => {
        if (err) throw err;

        setInterval(_ => {
          temp.read((err, reading) => {
            if (err) throw err;
            console.log('1')
      console.log(reading);
            console.log((reading.value * 3.3 - 0.5) * 100);
          });
        }, 5000);
      });


      const tem = mcpadc.open(2, {speedHz: 20000}, err => {
        if (err) throw err;

        setInterval(_ => {
          tem.read((err, reading) => {
            if (err) throw err;
            console.log('2')
      console.log(reading);
            console.log((reading.value * 3.3 - 0.5) * 100);
          });
        }, 5000);
      });
