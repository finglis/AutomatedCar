with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

package AutoCar with SPARK_mode
is
   
   type key1 is (Present,Absent);
   type power1 is (On,Off);
   type gear1 is (Backward,Parked,Forward);
   type moving1 is (No,Yes);
   type doors1 is (Locked,Unlocked);
   type battery1 is (Red, Orange, Green);
   type batterywarning1 is (On, Off);
   type sensors1 is (Clear, TBC, NotClear);
   type charging1 is (On,Off);
   type daignostics1 is (On,Off);
   type breakdown1 is (Yes, No);
   type charge1 is range 0..100;
   type speed1 is range 0 .. 75; --its a Fiat after all
   
   --Global Variables
   LOWESTCHARGELEVEL : charge1 := 10;
   SPEEDCITY : speed1 := 30;
   SPEEDMOTORWAY : speed1 := 70;

   --Input Variables
   Str : String (1..2);
   Last : Natural;
     
   
   type car is record
      key : key1;
      power : power1;
      gear : gear1;
      moving : moving1;
      doors : doors1;
      speed: speed1;
      sensors : sensors1;
      charge : charge1;
      battery : battery1;
      batterywarning : batterywarning1;
      charging : charging1;
      diagnostics : daignostics1;
      breakdown : breakdown1;
   end record;
   
   fiat : car :=(key => Absent, power => Off, gear => Parked, moving => No, doors => Unlocked, speed => speed1'First, Sensors => TBC, charge => 99, battery => Green, batterywarning => Off, charging => Off, diagnostics => Off, breakdown => No);

   function IsCarLocked return Boolean is
     (fiat.key = Absent);
   
   function IsCarUnlocked return Boolean is
     (fiat.key = Present);
   
   function IsCarOn return Boolean is
     (fiat.power = On);
   
   function IsCarParked return Boolean is
     (fiat.gear = Parked);
   
   function IsSensorsClear return Boolean is
     (fiat.sensors = Clear);
   
   function IsSensorsNotClear return Boolean is
     (fiat.sensors = NotClear);
   
   function IsSensorsTBC return Boolean is
     (fiat.sensors = TBC);
   
   function IsBatteryFull return Boolean is
     (fiat.charge = charge1'Last);
   
   function IsBatteryChargeable return Boolean is
     (fiat.charge /= charge1'Last);
   
   function IsBrokenDown return Boolean is
      (fiat.breakdown = yes);
   
   procedure UnlockCar with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.key = Absent AND fiat.breakdown = no,
     Post => fiat.key = Present;
      
   procedure LockCar with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.key = Present AND fiat.power = Off AND fiat.breakdown = no,
     Post => fiat.key = Absent;
   
   procedure TurnOnCar with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.diagnostics = Off AND fiat.power = Off AND fiat.key = Present AND fiat.breakdown = no AND fiat.gear = Parked,
     Post => fiat.power = On;
   
   procedure TurnOffCar with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.power = On AND fiat.gear = Parked AND fiat.breakdown = no,
     Post => fiat.power = Off;
   
   procedure ChangeGear with
     Global => (In_Out => (Ada.Text_IO.File_System, fiat,Str,Last)),
     Pre => fiat.gear = Backward OR fiat.gear = Parked OR fiat.gear = Forward,
     Post => fiat.gear = Backward OR fiat.gear = Parked OR fiat.gear = Forward;

   procedure MoveCar with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat,Str,Last), Input => (LOWESTCHARGELEVEL, Ada.Real_Time.Clock_Time,SPEEDCITY,SPEEDMOTORWAY)),
     Pre => fiat.charge >= LOWESTCHARGELEVEL AND fiat.charge <= charge1'Last AND fiat.moving = Yes AND fiat.speed <= speed1'First,
     Post => fiat.charge < LOWESTCHARGELEVEL OR fiat.charge <= charge1'Last OR fiat.moving = No OR fiat.speed = speed1'First;
   
   procedure ChargeCar with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.charge < charge1'Last AND fiat.diagnostics = Off AND fiat.breakdown = no,
     Post => fiat.charge = charge1'Last; 
   
   procedure TurnOnDiagnostics with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.diagnostics = Off AND fiat.gear = Parked AND fiat.key = Present AND fiat.breakdown = no,
     Post => fiat.diagnostics = On; 
   
   procedure TurnOffDiagnostics with
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.diagnostics = On AND fiat.gear = Parked AND fiat.key = Present AND fiat.breakdown = no,
     Post => fiat.diagnostics = Off;  
   
   procedure Maneuver with 
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.sensors = NotClear AND fiat.charge > 1 AND fiat.moving = No AND fiat.breakdown = no AND fiat.doors = Locked,
     Post => fiat.sensors = Clear AND fiat.doors = Unlocked;
   
   procedure AssistObjectDetection with 
     Global => (In_Out => (Ada.Text_IO.File_System,fiat)),
     Pre => fiat.sensors = NotClear AND fiat.moving = No AND fiat.breakdown = no AND fiat.doors = Locked,
     Post => fiat.sensors = Clear AND fiat.doors = Unlocked;
   
end AutoCar;
