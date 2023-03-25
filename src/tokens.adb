package body Tokens is

    -- To_String returns a string representation of the given token.
    function To_String (t : Token) return String is
    begin
        case t.Kind is
            when TOK_STRING =>
                return t.Kind'Image & " " & t.Lexeme.To_String & " " & t.String_Literal.To_String;
            when TOK_NUMBER =>
                return t.Kind'Image & " " & t.Lexeme.To_String & " " & t.Float_Literal'Image;
            when others =>
                return t.Kind'Image & " " & t.Lexeme.To_String;
        end case;
    end To_String;

    function "=" (Left, Right : Token) return Boolean is
    begin
        return False;
    end "=";

    -- Is_Keyword returns True if the given lexeme is a keyword, False otherwise.
    function Is_Keyword (Lexeme : String) return Boolean is
    begin
        if Lexeme = "and" or 
           Lexeme = "class" or
           Lexeme = "else" or
           Lexeme = "false" or 
           Lexeme = "for" or 
           Lexeme = "fun" or 
           Lexeme = "if" or 
           Lexeme = "nil" or 
           Lexeme = "or" or 
           Lexeme = "print" or 
           Lexeme = "return" or 
           Lexeme = "super" or 
           Lexeme = "this" or 
           Lexeme = "true" or 
           Lexeme = "var" or 
           Lexeme = "while" then
            return True;
        else
            return False;
        end if;
    end Is_Keyword;

    -- Get_Keyword returns the token kind for the given keyword lexeme.
    function Get_Keyword (Lexeme : String) return Token_Kind is
    begin
        if Lexeme = "and" then
            return TOK_AND;
        elsif Lexeme = "class" then
            return TOK_CLASS;
        elsif Lexeme = "else" then
            return TOK_ELSE;
        elsif Lexeme = "false" then
            return TOK_FALSE;
        elsif Lexeme = "for" then
            return TOK_FOR;
        elsif Lexeme = "fun" then
            return TOK_FUN;
        elsif Lexeme = "if" then
            return TOK_IF;
        elsif Lexeme = "nil" then
            return TOK_NIL;
        elsif Lexeme = "or" then
            return TOK_OR;
        elsif Lexeme = "print" then
            return TOK_PRINT;
        elsif Lexeme = "return" then
            return TOK_RETURN;
        elsif Lexeme = "super" then
            return TOK_SUPER;
        elsif Lexeme = "this" then
            return TOK_THIS;
        elsif Lexeme = "true" then
            return TOK_TRUE;
        elsif Lexeme = "var" then
            return TOK_VAR;
        elsif Lexeme = "while" then
            return TOK_WHILE;
        else
            return TOK_ERROR;
        end if;
    end Get_Keyword;

end Tokens;