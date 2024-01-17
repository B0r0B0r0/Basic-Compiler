%{
//flags:
#define __IN_IF 1
#define __TRUE_CONDITION 2
#define __FALSE_CONDITION 4


	using namespace std;
	#include<iostream>
	#include <stdio.h>
	#include <string.h>

	extern FILE *yyin;

	int yylex();
	int yyerror(const char *msg);

    int EsteCorecta = 1;
	char msg[500];

	class TVAR
	{
	     char* nume;
		 char* type;
	     double valoare;
		 bool local;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

		 static bool inBlock;
		 static int ifFlags;
		 static char* toPrint;

	     TVAR(char* n, double v = -1);
	     TVAR();
	     int exists(char* n);
         void add(char* n, double v = -1, bool l = false);
         double getValue(char* n);
	     void setValue(char* n, double v);
		 char* getType(char* n);
		 void setType(char* n, const char* t);
		 void printVars();
		 bool getLocal(char* n);
		 void removeLocals();
		 void makeLocal(char* n);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;
	int TVAR::ifFlags=0;
	char* TVAR::toPrint;
	bool TVAR::inBlock =false;

	TVAR::TVAR(char* n, double v)
	{
		this->nume = new char[strlen(n)+1];
		strcpy(this->nume,n);
		this->valoare = v;
		this->next = NULL;
		
	}

	TVAR::TVAR()
	{
		TVAR::head = NULL;
		TVAR::tail = NULL;
	}

	bool TVAR::getLocal(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			if(strcmp(tmp->nume,n) == 0)
				return tmp->local;
	     	tmp = tmp->next;
	    }
		return NULL;
	}

	void TVAR::removeLocals()
	{
		TVAR* tmp = TVAR::head;
	    while(tmp != NULL )
	    {
			if(tmp->local)
			{
				TVAR::head = tmp->next;
				tmp = TVAR::head;
			}
			else
				break;
	    }
		if(tmp!=NULL)
		{
			while(tmp != NULL && tmp->next != NULL)
			{
				if((tmp->next)->local)
				{
					TVAR* aux = tmp->next;
					tmp->next = (tmp->next)->next;
				}
				TVAR::tail = tmp;
				tmp = tmp->next;
				
			}
		}
		if(tmp!=NULL)
			if(tmp->local)
			{
				tmp=NULL;
			}
			else
			{
				TVAR::tail = tmp;
			}

	}

	void TVAR::makeLocal(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			if(strcmp(tmp->nume,n) == 0)
				tmp->local = true;
	     	tmp = tmp->next;
	    }
	}

	void TVAR::setType(char* n, const char* t)
	{
		TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
			if(strcmp(tmp->nume,n) == 0)
			{
				tmp->type = strdup(t);
			}
			tmp = tmp->next;
	    }
	}

	char* TVAR::getType(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			if(strcmp(tmp->nume,n) == 0)
				return tmp->type;
	     	tmp = tmp->next;
	    }
		return NULL;
	}

	int TVAR::exists(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL) 
		{ 
			if(strcmp(tmp->nume,n) == 0)
	      		return 1;
        	tmp = tmp->next;
	  	}
	  	return 0;
	}

    void TVAR::add(char* n, double v, bool l)
	{
		TVAR* elem = new TVAR(n, v);
		elem->local = l;
		if(head == NULL)
		{ 
			TVAR::head = TVAR::tail = elem;
		}
		else 
		{
			TVAR::tail->next = elem;
			TVAR::tail = elem;
		}
	}

    double TVAR::getValue(char* n)
	{
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			if(strcmp(tmp->nume,n) == 0)
				return tmp->valoare;
	     	tmp = tmp->next;
	    }
		return -1;
	}

	void TVAR::setValue(char* n, double v)
	{
		TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
			if(strcmp(tmp->nume,n) == 0)
			{
				tmp->valoare = v;
			}
			tmp = tmp->next;
	    }
	}

	void TVAR::printVars()
	{
		cout<<"\nPrinting table of variables...\n";
		TVAR* tmp = TVAR::head;
		while(tmp != NULL)
		{
			cout<<tmp->nume<<"="<<tmp->valoare<<"\n";
			tmp = tmp->next;
		}	  
	}

	TVAR* ts = NULL;
%}



%union { char* sir; double val; }

%token TOK_AMPERSANT TOK_STARTSCAN TOK_EXIT TOK_ENDIO TOK_RETINT TOK_RETFLOAT TOK_GREATER TOK_LESSER TOK_GREQ TOK_LSEQ TOK_EQUAL TOK_IF TOK_ELSE TOK_BRACKETLEFT TOK_BRACKETRIGHT TOK_PLUS TOK_MINUS TOK_MULTIPLY TOK_DIVIDE TOK_LEFT TOK_RIGHT TOK_PRINT TOK_ERROR TOK_INTD TOK_FLOATD TOK_DOUBLED
%token <val> TOK_INT TOK_FLOAT TOK_DOUBLE
%token <sir> TOK_VARIABLE TOK_STARTPRINT

%type <val> E

%start S

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE



%%
S : 
    | I ';' S
	| TOK_ERROR { EsteCorecta = 0; }
	| TOK_EXIT { exit(0); }
    ;

BLOCK:
	| TOK_BRACKETLEFT { 
						if(TVAR::ifFlags==3 || TVAR::ifFlags==8 || TVAR::ifFlags ==0)
							TVAR::inBlock = true; 			
							
						} BLOCK
	| I ';' BLOCK
	| TOK_BRACKETRIGHT { 
						TVAR::inBlock = false;
						 ts->removeLocals();
						 if(TVAR::ifFlags==3 || TVAR::ifFlags == 9)
							TVAR::ifFlags=0;
						 if(TVAR::ifFlags==5)
						 	TVAR::ifFlags=6;
						 
						 } S
	;

IF_STATEMENT:
	
	 TOK_IF TOK_LEFT E TOK_RIGHT 
					{
						TVAR::ifFlags=__IN_IF;
						if ($3) {
							TVAR::ifFlags+=__TRUE_CONDITION;
						} else {
							TVAR::ifFlags+=__FALSE_CONDITION;
						}
					} BLOCK ELSE_STATEMENT
	;

ELSE_STATEMENT:
	| TOK_ELSE {	
				if(TVAR::ifFlags==6)
					TVAR::ifFlags=8;
				if(TVAR::ifFlags==0)
					TVAR::ifFlags=9;
				} BLOCK

	
	;

PRINT_STATEMENT:
	| TOK_STARTPRINT 
		{if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
			TVAR::toPrint = strdup($1);
		} PRINT_STATEMENT

	| TOK_RETINT TOK_VARIABLE TOK_RIGHT ';'
		{
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			cout<<TVAR::toPrint<<ts->getValue($2)<<endl;
			free(TVAR::toPrint);
		}
		} 

	| TOK_RETFLOAT TOK_VARIABLE TOK_RIGHT ';'
		{if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			cout<<TVAR::toPrint<<ts->getValue($2)<<endl;
			free(TVAR::toPrint);	
		}
		} 

	| TOK_ENDIO ';'
		{if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{	
			cout<<TVAR::toPrint<<endl;
			free(TVAR::toPrint);
		}
		} 
	;

SCAN_STATEMENT:
	| TOK_STARTSCAN SCAN_STATEMENT
	| TOK_RETINT TOK_AMPERSANT TOK_VARIABLE TOK_RIGHT { 
														if(TVAR::ifFlags==6)
															TVAR::ifFlags=0;
														if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
														{int aux; scanf("%d",&aux); ts->setValue($3,aux);}
														} 
	| TOK_RETFLOAT TOK_AMPERSANT TOK_VARIABLE TOK_RIGHT { 
														if(TVAR::ifFlags==6)
															TVAR::ifFlags=0;
														if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
														{float aux; scanf("%f",&aux); ts->setValue($3,aux);}
														} 
	;
I : 
	IF_STATEMENT 

	| TOK_EXIT

	| SCAN_STATEMENT S

	| BLOCK

	| PRINT_STATEMENT S

	| TOK_VARIABLE '=' E
    {
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($1) == 1 )
				{
					if(strcmp(ts->getType($1),"int")==0)
						ts->setValue($1,(int)$3);
					else
						ts->setValue($1, $3);
				}
				else 
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
				yyerror(msg);
				YYERROR;
			}
		}
    }

	| TOK_INTD TOK_VARIABLE '=' E
	{

		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2)==0)
				{
					
					ts->add($2,$4);
					ts->setType($2,"int");
					if(TVAR::inBlock)
						ts->makeLocal($2);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($2,$4);

				if(TVAR::inBlock)
					ts->makeLocal($2);

				ts->setType($2,"int");
			}
		}
	}

	| TOK_INTD TOK_VARIABLE
	{
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2)==0)
				{
					ts->add($2);
					ts->setType($2,"int");
					if(TVAR::inBlock==true)
						{ts->makeLocal($2);}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($2);
				ts->setType($2,"int");
				if(TVAR::inBlock==true)
					{ts->makeLocal($2);}
			}
		}
	}

	| TOK_FLOATD TOK_VARIABLE '=' E
	{
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2)==0)
				{
					ts->add($2,$4);
					ts->setType($2,"float");

					if(TVAR::inBlock)
						ts->makeLocal($2);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($2,$4);
				ts->setType($2,"float");

				if(TVAR::inBlock)
					ts->makeLocal($2);
			}
		}
	}

	| TOK_FLOATD TOK_VARIABLE
	{
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2)==0)
				{
					ts->add($2);
					ts->setType($2,"float");
					if(TVAR::inBlock)
						ts->makeLocal($2);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($2);
				ts->setType($2,"float");
				if(TVAR::inBlock)
					ts->makeLocal($2);
			}
		}
	}

	| TOK_DOUBLED TOK_VARIABLE '=' E
	{
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2)==0)
				{
					ts->add($2,$4);
					ts->setType($2,"double");
					if(TVAR::inBlock)
						ts->makeLocal($2);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($2,$4);
				ts->setType($2,"double");
				if(TVAR::inBlock)
					ts->makeLocal($2);
			}
		}
	}

	| TOK_DOUBLED TOK_VARIABLE
	{
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2)==0)
				{
					ts->add($2);
					ts->setType($2,"double");
					if(TVAR::inBlock)
						ts->makeLocal($2);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($2);
				ts->setType($2,"double");
				if(TVAR::inBlock)
					ts->makeLocal($2);
			}
		}
	}

	
	 

    | TOK_PRINT TOK_VARIABLE
    {
		if(TVAR::ifFlags==6)
			TVAR::ifFlags=0;
		if(TVAR::ifFlags==0 || TVAR::ifFlags==3 || TVAR::ifFlags==8)
		{
			if(ts != NULL)
			{
				if(ts->exists($2) == 1)
				{
					if(ts->getValue($2) == -1)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $2);
						yyerror(msg);
						YYERROR;
					}
					else if (strcmp(ts->getType($2),"int")==0)
					{
						printf("%d\n",(int)ts->getValue($2));
					}
					else
					{
						printf("%f\n", ts->getValue($2));
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $2);
				yyerror(msg);
				YYERROR;
			}
		}
    }

    ;
E : E TOK_PLUS E { $$ = $1 + $3; }
    | E TOK_MINUS E { $$ = $1 - $3; }
    | E TOK_MULTIPLY E { $$ = $1 * $3; }
    | E TOK_DIVIDE E 
	{
		if($3 == 0)
		{
			sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
			yyerror(msg);
			YYERROR;
		} 
		else 
		{ 
			$$ = $1 / $3; 
		}	
	}
    | TOK_LEFT E TOK_RIGHT { $$ = $2; }
    | TOK_INT { $$ = (int)$1; }
	| TOK_FLOAT { $$ = $1; }
	| TOK_DOUBLE { $$ = $1; }
	| TOK_VARIABLE {
						if(ts->exists($1))					
							$$ = ts->getValue($1);
						else
						{
							sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $1);
							yyerror(msg);
							YYERROR;
						}
					}
	| TOK_LEFT TOK_INTD TOK_RIGHT E { $$ = (int)$4;}
	| TOK_LEFT TOK_FLOATD TOK_RIGHT E { $$ = (float)$4;}
	| TOK_LEFT TOK_DOUBLED TOK_RIGHT E { $$ = (double)$4;}
	| E TOK_GREATER E { if ($1 > $3) $$ = 1; else $$ = 0;}
	| E TOK_LESSER E { if ($1 < $3) $$ = 1; else $$ = 0;}
	| E TOK_GREQ E { if ($1 >= $3) $$ = 1; else $$ = 0;}
	| E TOK_LSEQ E { if ($1 <= $3) $$ = 1; else $$ = 0;}
	| E TOK_EQUAL E { if ($1 == $3) $$ = 1; else $$ = 0;}

    ;
%%

int main(int argc, char** argv)
{
    if(argc > 1){
        yyin = fopen(argv[1],"r");
    }
    else{
        yyin = stdin;
    }
	yyparse();
	
	if(EsteCorecta == 1)
	{
		cout<<"CORECT\n";	
	}	

	ts->printVars();
	return 0;
}

int yyerror(const char *msg)
{
	cout<<"EROARE: "<<msg<<endl;	
	return 1;
}
