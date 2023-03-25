with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Tokens is
    type Token_Kind is (
        -- Single-character tokens
        TOK_LEFT_PAREN, TOK_RIGHT_PAREN, TOK_LEFT_BRACE, TOK_RIGHT_BRACE,
        TOK_COMMA, TOK_DOT, TOK_MINUS, TOK_PLUS, TOK_SEMICOLON, TOK_SLASH,
        TOK_STAR,

        -- One or two character tokens
        TOK_BANG, TOK_BANG_EQUAL, TOK_EQUAL, TOK_EQUAL_EQUAL,
        TOK_GREATER, TOK_GREATER_EQUAL, TOK_LESS, TOK_LESS_EQUAL,

        -- Literals
        TOK_IDENTIFIER, TOK_STRING, TOK_NUMBER,

        -- Keywords
        TOK_AND, TOK_CLASS, TOK_ELSE, TOK_FALSE, TOK_FUN, TOK_FOR,
        TOK_IF, TOK_NIL, TOK_OR, TOK_PRINT, TOK_RETURN, TOK_SUPER,
        TOK_THIS, TOK_TRUE, TOK_VAR, TOK_WHILE,

        -- Error and end of file
        TOK_ERROR, TOK_EOF
    );

    type Token is record
        Kind            : Token_Kind;
        Lexeme          : Unbounded_String  := Null_Unbounded_String;
        Float_Literal   : Long_Float        := 0.0;
        String_Literal  : Unbounded_String  := Null_Unbounded_String;
        Line            : Positive          := 1;
    end record;

    function "=" (Left, Right : Token) return Boolean;

    function To_String (t : Token) return String;

    function Is_Keyword (Lexeme : String) return Boolean;

    function Get_Keyword (Lexeme : String) return Token_Kind;
end Tokens;