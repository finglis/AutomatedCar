with autocar; use autocar;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

procedure Main is

   Str : String (1..2);
   Last : Natural;

   task Start;

   task body Start is

   begin

      loop
         Put_Line("***");
         Put("Key is: ");Put(fiat.key'Image);New_Line;
         Put("Car is: ");Put(fiat.power'Image);New_Line;
         Put("Car gear: ");Put(fiat.gear'Image);New_Line;
         Put("Car moving: ");Put(fiat.moving'Image);New_Line;
         Put("Battery Level: ");Put(fiat.battery'Image);New_Line;
         Put("Speed is: ");Put(fiat.speed'Image);New_Line;
         Put_Line("***");
         Put_Line("What would you like to do?");
         Put_Line("1. Unlock car");
         Put_Line("2. Lock car");
         Put_Line("3. Turn on car");
         Put_Line("4. Turn off car");
         Put_Line("5. Change gear");
         Put_Line("6. Move car");
         Put_Line("7. Charge car");
         Put_Line("D. Diagnostic mode on");
         Put_Line("S. Diagnostic mode off");
         Get_Line(Str,Last);
         Case Str(1) is
            when '1' => UnlockCar;
            when '2' => LockCar;
            when '3' => TurnOnCar;
            when '4' => TurnOffCar;
            when '5' => ChangeGear;
            when '6' => MoveCar;
            when '7' => ChargeCar;
            when 'D' => TurnOnDiagnostics;
            when 'S' => TurnOffDiagnostics;
            when others => exit;
         end case;
      end loop;
      delay 0.2;
   end Start;
begin
   Null;
end Main;
