
with Ada.Text_IO; use Ada.Text_IO;

package body Errors is

   Had_Error : Boolean := False;

   procedure Report (Line : Positive; Where : String; Msg : String) is
   begin
      Put_Line ("[line " & Line'Image & "] Error " & Where & ": " & Msg);
      Had_Error := True;
   end Report;

   procedure Error (Line : Positive; Msg : String) is
   begin
      Report (Line, "", Msg);
   end Error;

end Errors;