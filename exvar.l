%option noyywrap
%{
	#include "exvar.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%
\t							;
\/\/.* 						;
\/\*(.*\n)*.*\*\/ 			;
"+"				{ colNo++; return TOK_PLUS; }
"-"				{ colNo++; return TOK_MINUS; }
">"				{colNo++; return TOK_GREATER;}
"<"				{colNo++; return TOK_LESSER;}
">=" 			{colNo++; return TOK_GREQ;}
"<="			{colNo++; return TOK_LSEQ;}
"=="			{colNo++; return TOK_EQUAL;}
"*"				{ colNo++; return TOK_MULTIPLY; }
"/"				{ colNo++; return TOK_DIVIDE; }
"{"				{ colNo++; return TOK_BRACKETLEFT; }
"}"				{ colNo++; return TOK_BRACKETRIGHT; }
"("				{ colNo++; return TOK_LEFT; }
")"				{ colNo++; return TOK_RIGHT; }
";"				{ colNo++; return ';'; }
"="				{ colNo++; return '='; }
"exit();"			{ colNo+=7; return TOK_EXIT;}


-?[0-9]+\.[0-9]+"f"	{ 	yylloc.first_line = lineNo; 
					yylloc.first_column = colNo; 
					colNo+=strlen(yytext); 
					yytext[strlen(yytext)-1]='\0';
					yylval.val = atof(yytext); 
					return TOK_FLOAT; }

-?[0-9]+\.[0-9]+	{ 	yylloc.first_line = lineNo; 
					yylloc.first_column = colNo; 
					colNo+=strlen(yytext); 
					yylval.val = strtod(yytext,NULL); 
					return TOK_DOUBLE; }



-?0|[1-9][0-9]*	{ 	yylloc.first_line = lineNo; 
					yylloc.first_column = colNo; 
					colNo+=strlen(yytext); 
					yylval.val = atoi(yytext); 
					return TOK_INT; }



"if" 			{colNo+=2; return TOK_IF;}
"else"			{colNo+=4; return TOK_ELSE;}

"int"			{ colNo+=3; return TOK_INTD; }
"float"			{ colNo+=5; return TOK_FLOATD; }
"double"			{ colNo+=6; return TOK_DOUBLED; }
"print"			{ colNo+=5; return TOK_PRINT; }
[a-zA-Z][a-zA-Z0-9]* { 	yylloc.first_line = lineNo; 
						yylloc.first_column = colNo; 
						colNo+=strlen(yytext); 
						yylval.sir = new char[strlen(yytext)+1]; 
						strcpy(yylval.sir,yytext); 
						return TOK_VARIABLE;}

"printf(\""[a-zA-Z0-9!@#$^:*() ]*		{
										colNo+=strlen(yytext);
										strcpy(yytext,yytext+8);
										yylval.sir = strdup(yytext);
										return TOK_STARTPRINT;
										}

"\")"				{colNo+=2; return TOK_ENDIO;}

"%d\"\,"				{colNo+=4; return TOK_RETINT;}
"%f\"\,"				{colNo+=4; return TOK_RETFLOAT;}

"scanf(\""				{colNo+=7; return TOK_STARTSCAN;}
"&"						{colNo++; return TOK_AMPERSANT;}

[ ]				{ colNo++; }
\r\n			{ lineNo++; colNo=1;}
\n				{ lineNo++; colNo=1;}
.				{ colNo++; return TOK_ERROR; }
%%
