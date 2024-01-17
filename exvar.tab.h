/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_EXVAR_TAB_H_INCLUDED
# define YY_YY_EXVAR_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TOK_AMPERSANT = 258,           /* TOK_AMPERSANT  */
    TOK_STARTSCAN = 259,           /* TOK_STARTSCAN  */
    TOK_EXIT = 260,                /* TOK_EXIT  */
    TOK_ENDIO = 261,               /* TOK_ENDIO  */
    TOK_RETINT = 262,              /* TOK_RETINT  */
    TOK_RETFLOAT = 263,            /* TOK_RETFLOAT  */
    TOK_GREATER = 264,             /* TOK_GREATER  */
    TOK_LESSER = 265,              /* TOK_LESSER  */
    TOK_GREQ = 266,                /* TOK_GREQ  */
    TOK_LSEQ = 267,                /* TOK_LSEQ  */
    TOK_EQUAL = 268,               /* TOK_EQUAL  */
    TOK_IF = 269,                  /* TOK_IF  */
    TOK_ELSE = 270,                /* TOK_ELSE  */
    TOK_BRACKETLEFT = 271,         /* TOK_BRACKETLEFT  */
    TOK_BRACKETRIGHT = 272,        /* TOK_BRACKETRIGHT  */
    TOK_PLUS = 273,                /* TOK_PLUS  */
    TOK_MINUS = 274,               /* TOK_MINUS  */
    TOK_MULTIPLY = 275,            /* TOK_MULTIPLY  */
    TOK_DIVIDE = 276,              /* TOK_DIVIDE  */
    TOK_LEFT = 277,                /* TOK_LEFT  */
    TOK_RIGHT = 278,               /* TOK_RIGHT  */
    TOK_PRINT = 279,               /* TOK_PRINT  */
    TOK_ERROR = 280,               /* TOK_ERROR  */
    TOK_INTD = 281,                /* TOK_INTD  */
    TOK_FLOATD = 282,              /* TOK_FLOATD  */
    TOK_DOUBLED = 283,             /* TOK_DOUBLED  */
    TOK_INT = 284,                 /* TOK_INT  */
    TOK_FLOAT = 285,               /* TOK_FLOAT  */
    TOK_DOUBLE = 286,              /* TOK_DOUBLE  */
    TOK_VARIABLE = 287,            /* TOK_VARIABLE  */
    TOK_STARTPRINT = 288           /* TOK_STARTPRINT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 227 "exvar.y"
 char* sir; double val; 

#line 100 "exvar.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;

int yyparse (void);


#endif /* !YY_YY_EXVAR_TAB_H_INCLUDED  */
