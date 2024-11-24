%{
#include "parser.tab.h"  // Include Bison's token definitions
%}

%option noyywrap
%option yylineno
%option case-insensitive
%option debug

%%
"module"          { return MODULE; }
"endmodule"       { return ENDMODULE; }
"input"           { return INPUT; }
"output"          { return OUTPUT; }
"wire"            { return WIRE; }
"dff"             { return DFF; }
"not"             { return NOT; }
"and"             { return AND; }
"or"              { return OR; }
"nor"             { return NOR; }
"nand"            { return NAND; }
","               { return COMMA; }
"("               { return LPAREN; }
")"               { return RPAREN; }
";"               { return SEMICOLON; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.strval = strdup(yytext); return IDENTIFIER; } // Identifiers
[ \t\n]+          ;  // Ignore whitespace
.                 { return *yytext; }  // Catch any unexpected characters
%%