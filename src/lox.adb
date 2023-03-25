with Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

with GNAT.OS_Lib;

with Errors;
with Scanner;
with Tokens;

procedure Lox is

   -- Run a source loaded from a string
   procedure Run (Source : String) is
      Token_Vec : Scanner.Token_Vectors.Vector;
   begin
      Put_Line (Source);
      Token_Vec := Scanner.Scan_Tokens (Source);

      for T of Token_Vec loop
         Put_Line (Tokens.To_String (T));
      end loop;
   end Run;

   -- Run_File - Run a source file
   procedure Run_File (Path : String) is
      Source_File : File_Type;
      Source : Unbounded_String;
   begin
      Put_Line ("Run_File " & Path & ASCII.LF);
      Open(Source_File, In_File, Path);
      
      while not End_Of_File (Source_File) loop
         Source.Append (Get_Line (Source_File) & ASCII.LF);
      end loop;

      Run (Source.To_String);
   end Run_File;

   -- Run_Prompt runs a REPL
   procedure Run_Prompt is
   begin
      Ada.Text_IO.Put_Line ("REPL");

      repl: loop
         Ada.Text_IO.Put ("> ");
         declare
            line : String := Ada.Text_IO.Get_Line;
         begin
            if line'Length = 0 then
               exit repl;
            else
               Run (line);
            end if;
         end;
      end loop repl;
   end Run_Prompt;

   argc : Natural := Ada.Command_Line.Argument_Count;
begin

   if argc > 1 then
      Ada.Text_IO.Put_Line ("Usage: alox [script]");
      GNAT.OS_Lib.OS_Exit (64);
   elsif argc = 1 then
      Run_File (Ada.Command_Line.Argument (1));
   else
      Run_Prompt;
   end if;

end Lox;
