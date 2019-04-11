/*
 * CS3377
 * parse.y - example bison file
 * Dr. Perkins
 *
 * https://www.youtube.com/watch?v=dK2qBbDn5W0
 *
 *  "Two all beef patties, special sauce, lettuce, cheese, pickles, onions, on a Sesame Seed Bun."
 */



%{
  #include <stdio.h>
  int yylex(void);
  void yyerror(char *);
%}

%union
{
    int value;
    char *str;
}

%type	<value>	INTEGER
%type	<str>   HASH
%type	<str>   COMMA
%type	<str>   DASH
%type	<str>   SR
%type	<str>	JR
%type	<str>	NAMETOKEN
%type	<str>	IDENTIFIERTOKEN
%type	<str>	NAME_INITIAL_TOKEN
%type	<str>	ROMANTOKEN


%token  HASH
%token  COMMA
%token  DASH
%token	SR
%token	JR
%token	NAMETOKEN
%token	IDENTIFIERTOKEN
%token  NAME_INITIAL_TOKEN
%token  ROMANTOKEN
%token  INTEGER
%token	NEWLINE

%start	Postal_Addresses

%%

/*
 * Careful here... the very last entry in the source file should not
 * have a double newline.  An extra blank line indicates that another
 * BigMac Description is starting.
 *
 * This entry follows the pattern in the notes that discusses
 * how to handle an unknown number of items.
 */

Postal_Addresses:
			Address_Block NEWLINE Postal_Addresses
		|	Address_Block
		//|	error NEWLINE { printf("Bad postal address... skipping to newline\n"); }
		;


/*
 * Careful here, each of the parts of the Big Mac  should be on
 * their own line.  Therefore, each part definition below requires that it see a
 * NEWLINE at the end.  The very last line of the input file needs a final
 * new line after the final bun.  Do not follow by
 * an extra new line as tht indicates another starting Big Mac.
 * 
 * Doing things this way allows us to use the 'error' token and skip
 * to the NEWLINE to throw away the line we are working on, but
 * continue with the next line in case it is OK.
 */

Address_Block:
			Name_Part Street_Address Location_Part
	//	|	error NEWLINE { printf("Bad address block ... skipping to newline\n"); }
		;

Name_Part:		
			Personal_Part Last_Name Suffix_Part NEWLINE 
	|		Personal_Part Last_Name NEWLINE 
	|		Personal_Part NEWLINE 
	|		error NEWLINE { printf("Bad name-part ... skipping to newline\n"); }
	;

Personal_Part:
			NAMETOKEN {fprintf(stderr, "<FirstName> %s", $1); fprintf(stderr, "<FirstName>\n"); }
	|		NAME_INITIAL_TOKEN {fprintf(stderr, "<Suffix> %s", $1); fprintf(stderr, "<Suffix>\n"); }
	//|		error NEWLINE { printf("Bad personal-part ... skipping to newline\n"); }
	;

Last_Name:
			NAMETOKEN {fprintf(stderr, "<LastNAme> %s", $1); fprintf(stderr, "<LastName>\n"); }
	//|		error NEWLINE { printf("Bad last name ... skipping to newline\n"); }
	;

Suffix_Part:
			SR {fprintf(stderr, "<sr> %s", $1); fprintf(stderr, "<sr>\n"); }
	|		JR {fprintf(stderr, "<jr> %s", $1); fprintf(stderr, "<jr>\n"); }
	|		ROMANTOKEN{fprintf(stderr, "<roman> %s", $1); fprintf(stderr, "<roman>\n"); }
	//|		error NEWLINE { printf("Bad suffix ... skipping to newline\n"); }
	;

Street_Address:
			Street_Number Street_Name INTEGER NEWLINE
	| 		Street_Number Street_Name HASH INTEGER NEWLINE
	|		Street_Number Street_Name NEWLINE 
	|		error NEWLINE { printf("Bad street address ... skipping to newline\n"); }
	;

Street_Number:
			INTEGER {fprintf(stderr, "<street num> %d", $1); fprintf(stderr, "<street num>\n"); }
	|		IDENTIFIERTOKEN {fprintf(stderr, "<Iden token> %s", $1); fprintf(stderr, "<Ident Token>\n"); }
	//|		error NEWLINE { printf("Bad street number ... skipping to newline\n"); }
	;

Street_Name:
			NAMETOKEN {fprintf(stderr, "<Street name> %s", $1); fprintf(stderr, "<Street Name>\n"); }
	//|		error NEWLINE { printf("Bad street name ... skipping to newline\n"); }
	;

Location_Part:
			Town_Name COMMA State_Code Zip_Code NEWLINE
	|		error NEWLINE { printf("Bad location-part ... skipping to newline\n"); }
	;

Town_Name:		NAMETOKEN {fprintf(stderr, "<Town name> %s", $1); fprintf(stderr, "<town>\n"); }
	//|		error NEWLINE { printf("Bad town name... skipping to newline\n"); }

	;

State_Code:			
			NAMETOKEN {fprintf(stderr, "<State> %s", $1); fprintf(stderr, "<State>\n"); }
	//|		error NEWLINE { printf("Bad state code... skipping to newline\n"); }
	;

Zip_Code:		INTEGER DASH INTEGER {fprintf(stderr, "<ZIP> %d", $1); fprintf(stderr, "<ZIP>\n"); }
	|		INTEGER INTEGER {fprintf(stderr, "<ZIP> %d", $1); fprintf(stderr, "<ZIP>\n"); }
	|		INTEGER {fprintf(stderr, "<ZIP> %d", $1); fprintf(stderr, "<ZIP>\n"); }
	//|		error NEWLINE { printf("Bad zip code ... skipping to newline\n"); }
	;

%%

void yyerror(char *s)
{
}


