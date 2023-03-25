with Ada.Containers.Vectors;
with Tokens;

package Scanner is

    package Token_Vectors is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Tokens.Token, "=" => Tokens."=");

    function Scan_Tokens (Source : String) return Token_Vectors.Vector;

end Scanner;
