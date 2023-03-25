with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Errors;
with Tokens; use Tokens;

package body Scanner is

    Start   : Natural  := 1;    -- Index for start of next lexeme
    Current : Natural  := 1;    -- Index into source file
    Line    : Positive := 1;    -- Current line number
    Length  : Natural;

    -- Scan_Tokens is the main entry point for the scanner.  It returns a vector
    -- of tokens that can be used by the parser.
    function Scan_Tokens (Source : String) return Token_Vectors.Vector is
        
        Token_Vec : Token_Vectors.Vector;

        -- Is_At_End returns True if the scanner has reached the end of the
        -- source file.
        function Is_At_End return Boolean is
        begin
            return Current > Length;
        end Is_At_End;

        -- Advance returns the current character and advances the scanner to the
        -- next character.
        function Advance return Character is
            ret : Character := Source(Current);
        begin
            Current := Current + 1;
            return ret;
        end Advance;

        -- Advance advances the scanner to the next character.
        procedure Advance is
        begin
            Current := Current + 1;
        end Advance;

        -- Add_Token adds a String literal token to the token vector.
        procedure Add_Token (Literal : String) is
        begin
            Token_Vec.Append (Token'(
                Kind            => TOK_STRING,
                Lexeme          => To_Unbounded_String (Source (Start .. Current - 1)),
                Float_Literal   => 0.0,
                String_Literal  => To_Unbounded_String (Literal),
                Line            => Line));
        end Add_Token;

        -- Add_Token adds a FLoat literal token to the token vector.
        procedure Add_Token (Literal : Long_Float) is
        begin
            Token_Vec.Append (Token'(
                Kind            => TOK_NUMBER,
                Lexeme          => To_Unbounded_String (Source (Start .. Current - 1)),
                Float_Literal   => Literal,
                String_Literal  => Null_Unbounded_String,
                Line            => Line));
        end Add_Token;

        -- Add_Token adds a token of the specified kind to the token vector.
        procedure Add_Token (TKind : Token_Kind) is
        begin
            Token_Vec.Append (Token'(
                Kind            => TKind,
                Lexeme          => To_Unbounded_String (Source (Start .. Current - 1)),
                String_Literal  => Null_Unbounded_String,
                Float_Literal   => 0.0,
                Line            => Line));
        end Add_Token;

        -- Match consumes the next character if it matches the expected character.
        -- It returns True if the character was consumed, False otherwise.
        function Match (Expected : Character) return Boolean is
        begin
            if Is_At_End then
                return False;
            end if;
            
            if Source(Current) /= Expected then
                return False;
            end if;

            Current := Current + 1;
            return True;
        end Match;

        -- Peek returns the next character in the source file without consuming it.
        function Peek return Character is
        begin
            if Is_At_End then
                return ASCII.NUL;
            else
                return Source(Current);
            end if;
        end Peek;

        -- Peek_Next returns the character after the next character in the source.
        function Peek_Next return Character is
        begin
            if Current + 1 > Source'Length then
                return ASCII.NUL;
            else
                return Source(Current + 1);
            end if;
        end Peek_Next;

        -- Do_String scans a string literal.
        procedure Do_String is
            Dummy : Character;
        begin
            while Peek /= '"' and not Is_At_End loop
                if Peek = ASCII.LF then
                    Line := Line + 1;
                end if;
                Advance;
            end loop;

            if Is_At_End then
                Errors.Error (Line, "Unterminated String");
                return;
            end if;

            Advance;    -- eat closing "

            -- Trim surrounding quotes
            Add_Token (Source (Start + 1 .. Current - 1));
        end Do_String;

        -- Is_Digit returns True if the character is a digit.
        function Is_Digit (c : Character) return Boolean is
        begin
            return (c in '0'..'9');
        end Is_Digit;

        -- Is_Alpha returns True if the character is a letter or underscore.
        function Is_Alpha (c : Character) return Boolean is
        begin
            return (c in 'a'..'z') or (c in 'A'..'Z') or (c = '_');
        end Is_Alpha;

        -- Is_Alphanumeric returns True if the character is a digit, letter, or
        -- underscore.
        function Is_Alphanumeric (c : Character) return Boolean is
        begin
            return Is_Digit (c) or Is_Alpha (c);
        end Is_Alphanumeric;

        -- Number scans a number literal.
        procedure Number is
        begin
            while Is_Digit (Peek) loop
                Advance;
            end loop;

            if Peek = '.' and Is_Digit (Peek_Next) then
                -- consume the "."
                Advance;

                while Is_Digit (Peek) loop
                    Advance;
                end loop;
            end if;

            Add_Token (Long_Float'Value (Source (Start .. Current - 1)));
        end Number;

        -- Identifier scans an identifier.
        procedure Identifier is
        begin
            while Is_Alphanumeric (Peek) loop
                Advance;
            end loop;

            if Tokens.Is_Keyword (Source (Start .. Current - 1)) then
                Add_Token (Tokens.Get_Keyword (Source (Start .. Current - 1)));
            else
                Add_Token (TOK_IDENTIFIER);
            end if;

        end Identifier;

        -- Scan_Token scans a single token.
        procedure Scan_Token is
            c : Character := Advance;
            dummy : Character;
        begin
            case c is
                when '(' => Add_Token (TOK_LEFT_PAREN);
                when ')' => Add_Token (TOK_RIGHT_PAREN);
                when '{' => Add_Token (TOK_LEFT_BRACE);
                when '}' => Add_Token (TOK_RIGHT_BRACE);
                when ',' => Add_Token (TOK_COMMA);
                when '.' => Add_Token (TOK_DOT);
                when '-' => Add_Token (TOK_MINUS);
                when '+' => Add_Token (TOK_PLUS);
                when ';' => Add_Token (TOK_SEMICOLON);
                when '*' => Add_Token (TOK_STAR);
                when '!' => Add_Token (if Match ('=') then TOK_BANG_EQUAL else TOK_BANG);
                when '=' => Add_Token (if Match ('=') then TOK_EQUAL_EQUAL else TOK_EQUAL);
                when '<' => Add_Token (if Match ('=') then TOK_LESS_EQUAL else TOK_LESS);
                when '>' => Add_Token (if Match ('=') then TOK_GREATER_EQUAL else TOK_GREATER);
                when '/' =>
                    if Match ('/') then
                        while Peek /= ASCII.LF and not Is_At_End loop
                            dummy := Advance;
                        end loop;
                    else
                        Add_Token (TOK_SLASH);
                    end if;
                when ' ' | ASCII.HT => null;  -- ignore whitespace
                when ASCII.LF | ASCII.CR => Line := Line + 1;
                when '"' => Do_String;
                when others =>
                    if Is_Digit (c) then
                        Number;
                    elsif Is_Alpha (c) then
                        Identifier;
                    else
                        Errors.Error (Line, "Unexpected character");
                    end if;
            end case;

        end Scan_Token;

    begin
        Length := Source'Length;

        Start   := 1;
        Current := 1;
        Line    := 1;

        while not Is_At_End loop
            Start := Current;
            Scan_Token;
        end loop;

        Token_Vec.Append (Token'(
            Kind            => TOK_EOF,
            Float_Literal   => 0.0,
            String_Literal  => Null_Unbounded_String,
            Lexeme          => Null_Unbounded_String,
            Line            => Line));

        return Token_Vec;
    end Scan_Tokens;

end Scanner;
