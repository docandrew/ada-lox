
package Errors is

   procedure Report (Line : Positive; Where : String; Msg : String);
   procedure Error (Line : Positive; Msg : String);

end Errors;
