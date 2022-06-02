with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Numerics.Discrete_Random;

package body AutoCar with SPARK_Mode 
is

   procedure UnlockCar 
   is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (IsCarLocked) then
         fiat.key := Present;
         Put_Line("Unlocking the car");
      elsif
        (IsCarUnlocked) then
         Put_Line("Car must be locked before you unlock it");
      end if;
   end UnlockCar;
   
   procedure LockCar is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (IsCarUnlocked and fiat.power = Off) then
         fiat.key := Absent;
         Put_Line("Locking the car");
      else
         Put_Line("Car must be off and unlocked before it can be locked");
      end if;
   end LockCar;
   
   procedure TurnOnCar is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.diagnostics = On) then
         Put_Line("Car in diagnostic mode so cannot be used till its turned off");
      elsif (IsCarUnlocked and fiat.power = Off and fiat.gear = Parked) then
         fiat.power := On;
         Put_Line("Starting the car");
      else
         Put_Line("Car must be off and the key present to turn on.");
      end if;
   end turnOnCar;
   
   procedure TurnOffCar is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.power = On AND fiat.gear = Parked) then
         fiat.power := Off;
         Put_Line("Turning the car off");
      else
         Put_Line("Car must be on and in parked to turn it off.");
      end if;
   end turnOffCar;
   
   procedure GearReverse is
   begin
      if (fiat.gear = Parked) then
           fiat.gear := Backward;
      elsif (fiat.gear = Forward or fiat.gear = Backward) then
         Put_Line("Car must be in parked before gear can be changed to reverse");
      end if;
      end GearReverse;

   procedure GearForward is
   begin
      if (fiat.gear = Parked) then
         fiat.gear := Forward;
      elsif (fiat.gear = Forward or fiat.gear = Backward) then
         Put_Line("Car must be in parked before gear can be changed to forward");
      end if;
   end GearForward;
   
   procedure GearPark is
   begin
      if (fiat.gear = Forward or fiat.gear = Backward) then
         fiat.gear := Parked;
      elsif (fiat.gear = Parked) then
         Put_Line("You are already Parked");
      end if;
   end GearPark;
   
   procedure ChangeGear is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.diagnostics = On) then
         Put_Line("Car in diagnostic mode so cannot be used till its turned off");
      elsif (fiat.power = Off) then
         Put_Line("Car cannot change gear while off");
      else
         Put_Line("  ");
         Put_Line("Car gear is:");
         Put_Line(fiat.gear'Image);
         Put_Line("What gear would you like to change to?");
         Get_Line(Str,Last);
         case Str(1) is
         when '1' => GearReverse;
         when '2' => GearPark;
         when '3' => GearForward;
         when others => Put_Line("No gear selected");
         end case;
      end if;
   end ChangeGear;
   
   procedure MoveCar is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.charge >= LOWESTCHARGELEVEL AND fiat.moving = No AND fiat.doors = Unlocked AND (fiat.gear = Forward or fiat.gear = Backward)) then
         fiat.moving := Yes;
         fiat.doors := Locked;
         Put_Line("-----------------");
         Put_Line("Car is now moving");
         Put("Doors are ");Put(fiat.doors'Image);New_Line;
         Put_Line("-----------------");         
         loop
            Put_Line("1: Travel 10 city miles.");
            Put_Line("2: Travel 10 motorway miles.");
            Put_Line("3: Detect an object to avoid.");
            Put_Line("4: Detect an object that needs help");
            Put_Line("5: Breakdown.");
            Put_Line("Press any other value to exit");            
         Get_Line(Str,Last);
         Case Str(1) is
            when '1' =>
               if (fiat.charge >= LOWESTCHARGELEVEL AND fiat.charge <= charge1'Last AND fiat.moving = Yes AND fiat.speed <= speed1'Last) then
                  fiat.speed := fiat.speed + 10; fiat.charge := fiat.charge - 5;
                  delay 0.1;
                  if (fiat.speed >= SPEEDCITY) then
                     Put_Line("Now maintaining speed level at limit");
                     fiat.speed := SPEEDCITY;
                  end if;
                  if (fiat.charge < 30) then
                     Put_Line("!!!WARNING!!!");
                     Put_Line("You are running out of battery, go to charge NOW");
                     fiat.battery := Orange;
                  end if;
                  Put_Line("-----------------"); 
                  Put("Driving speed:");Put(fiat.speed'Image);Put(" Battery Level");Put(fiat.charge'Image);New_Line;
                  Put_Line("-----------------"); 
               elsif (fiat.charge < 10) then
                  Put_Line("!!!WARNING!!!");
                  Put_Line("You have ran out of battery, call a portable charger");
                  fiat.battery := Red;
                  fiat.moving := No;
                  fiat.doors := Unlocked;
                  fiat.speed := speed1'First;
                  return;
               end if;
            when '2' =>
               if (fiat.charge >= LOWESTCHARGELEVEL AND fiat.charge <= charge1'Last AND fiat.moving = Yes AND fiat.speed <= speed1'Last) then
                  fiat.speed := fiat.speed + 10; fiat.charge := fiat.charge - 5;
                  delay 0.1;
                  Put("Driving speed:");Put(fiat.speed'Image);Put(" Battery Level");Put(fiat.charge'Image);New_Line;
                  if (fiat.speed >= SPEEDMOTORWAY) then
                     Put_Line("Now maintaining speed level at limit");
                     fiat.speed := SPEEDMOTORWAY;
                  end if;
                  if (fiat.charge < 30) then
                     Put_Line("!!!WARNING!!!");
                     Put_Line("You are running out of battery, go to charge NOW");
                     fiat.battery := Orange;
                  end if;
               elsif (fiat.charge < 10) then
                  Put_Line("!!!WARNING!!!");
                  Put_Line("You have ran out of battery, call a portable charger");
                  fiat.battery := Red;
                  fiat.moving := No;
                  fiat.doors := Unlocked;
                  fiat.speed := 0;
                  return;
               end if;
               when '3' => 
                  if (fiat.moving = Yes) then
                     fiat.sensors := NotClear;
                     fiat.moving := No;
                     fiat.speed := 0;
                     Put_Line("!!!WARNING!!!");
                     Put_Line("Object Detected and Car stopped, now maneuvering");
                     Maneuver;
                     fiat.sensors := Clear;
                     fiat.moving := No;
                     return;
                  end if;
               when '4' => 
                  if (fiat.moving = Yes) then
                     fiat.sensors := NotClear;
                     fiat.moving := No;
                     fiat.speed := 0;
                     Put_Line("!!!WARNING!!!");
                     Put_Line("Object Detected and Car stopped, turning off engine, opening doors and locking the car when key is not present");
                     AssistObjectDetection;
                     fiat.sensors := Clear;
                     fiat.moving := No;
                     return;
                  end if;
               when '5' =>
                  fiat.breakdown := Yes;
                  fiat.power := Off;
                  fiat.moving := No;
                  fiat.doors := Unlocked;
                  fiat.speed := 0;
                  fiat.gear := Parked;
                  Put_Line("Oh dear, you broke down! Might want to get a new car.");
                  return;
               when others => exit;
            end case;
         end loop;
         delay 0.5;
         fiat.moving := No;
         fiat.speed := 0;
         fiat.doors := Unlocked;
      end if;
   end MoveCar;
   
   procedure ChargeCar is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.diagnostics = On) then
         Put_Line("Car in diagnostic mode so cannot be used till its turned off");
      elsif (fiat.charge < charge1'Last) then
         fiat.charge := charge1'Last;
         fiat.battery := Green;
         Put_Line("Car is now charged");
      else
         Put_Line("Car is already charged");
      end if;
   end ChargeCar;
   
   procedure TurnOnDiagnostics is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.diagnostics = Off AND fiat.gear = Parked and IsCarUnlocked) then
         fiat.diagnostics := On;
         Put_Line("Diagnostic mode on");
      else
         Put_Line ("Diagnostics cant be turned on - car must be parked and car unlocked");
      end if;
   end TurnOnDiagnostics;
   
   procedure TurnOffDiagnostics is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.diagnostics = On AND fiat.gear = Parked AND IsCarUnlocked) then
         fiat.diagnostics := Off;
         Put_Line("Diagnostic mode off");
      else
         Put_Line ("Diagnostics cant be turned off - car must be parked and car unlocked");
      end if;
   end TurnOffDiagnostics;
   
   Procedure Maneuver is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.sensors = NotClear AND fiat.charge > 1 AND fiat.moving = No AND fiat.doors = Locked) then
         fiat.speed := 0;
         fiat.gear := Backward;
         Put("Sensor is ");Put(fiat.sensors'Image);New_Line;
         Put("Car is now ");Put(fiat.speed'Image);Put(" speed and in gear: ");Put(fiat.gear'Image);New_Line;
         Put_Line("Reversing...");
         Put("Charge: ");Put(fiat.charge'Image);New_Line;
         fiat.charge := fiat.charge -1;
         Put("Charge: ");Put(fiat.charge'Image);New_Line;
         Put_Line("Stopped");
         fiat.gear := Parked;
         fiat.doors := Unlocked;
         fiat.sensors := Clear;
         Put("Sensor is ");Put(fiat.sensors'Image);New_Line;
         Put("Car is now ");Put(fiat.speed'Image);Put(" speed and in gear: ");Put(fiat.gear'Image);New_Line;
      end if;     
   end Maneuver;
   
   Procedure AssistObjectDetection is
   begin
      if (IsBrokenDown) then
         Put_Line("Sorry, your car is broken.");
      elsif (fiat.sensors = NotClear AND fiat.moving = No AND fiat.doors = Locked) then
         fiat.speed := 0;
         fiat.doors := Unlocked;
         fiat.gear := Parked;
         fiat.power := Off;
         Put("Sensor is ");Put(fiat.sensors'Image);New_Line;
         Put("Car is now ");Put(fiat.speed'Image);Put(" speed and in gear: ");Put(fiat.gear'Image);New_Line;
         Put_Line("Getting out to help...");
         fiat.key := Absent;
         Put("Power is ");Put(fiat.power'Image);Put(". Key is ");Put(fiat.key'Image);Put(". Car is locked");New_Line;
         Put_Line("Getting back in the car...");         
         fiat.power := On;
         fiat.key := Present;
         Put("Power is ");Put(fiat.power'Image);Put(". Key is ");Put(fiat.key'Image);Put(". Car is unlocked");New_Line;
         fiat.sensors := Clear;
         Put("Sensor is ");Put(fiat.sensors'Image);New_Line;
         Put("Car is now ");Put(fiat.speed'Image);Put(" speed and in gear: ");Put(fiat.gear'Image);New_Line;
      end if;     
   end AssistObjectDetection;
   
end AutoCar;
