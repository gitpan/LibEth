/* This is part of the LibEth library, an ANSI C library for Ethiopic
   text and information processing (http://libeth.netpedia.net).
   Copyright (C) 1995-1998 Daniel Yacob.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include <libeth/fidel.h>
#include <libeth/etstdlib.h>
#include <libeth/etstdio.h>
#include <libeth/sysinfo.h>
#include <libeth/etmath.h>
#include <libeth/ettime.h>
#include <libeth/html.h>

extern void lexer_reset ( LibEthFlags* lethFlags );

int image_sputs ( FCHAR* uniString, char** outString, char* iPath, LibEthFlags* mylflags );

int
image_sputs (uniString, outString, iPath, mylflags)
	FCHAR* uniString;
	char** outString;
	char* iPath;
	LibEthFlags* mylflags;
{
register int i=-1, j=0, count=0;
int uniAddr;
unsigned char* fidelName;
char* tempString = (char*) malloc ( 20 * (fidel_strlen (uniString) + 1) * sizeof (char));


  while ( (uniAddr = uniString[++i]) )
    if ( uniString[i] < ANSI )
      tempString[j++] = uniString[i];
    else if ( isethiopic (uniAddr) )
        {
          count++;
          mylflags->csOut = ( uniAddr > FYA ) ? muletex : sera ;

          fidelName = fidel_sputc ( uniAddr, mylflags );

          if ( fidelName[0] == '`' )
            {
              fidelName[0] = fidelName[1];
              fidelName[1] = '2';
            }
          else if ( uniAddr > FYA )
            {
              fidelName[strlen(fidelName)-1] = '\0';  /* kill the 'G' */
            }

/*        Our images use Tigrigna names, so we need to switch names back
 *        if we used an Amharic file.
 */
          if ( !isfdigit(uniAddr) && mylflags->out->l == amh )
            {
              if ( fidelName[0] == 'a' && fidelName[1] != '2' )
                fidelName[0] = 'e';
              else if ( fidelName[0] == 'A' )
                fidelName[0] = 'a';
            }


          sprintf ( &tempString[j], "<img src=%s/%s>", iPath, fidelName );
          j = strlen ( tempString );
          free (fidelName);
        }
      else
        tempString[j++] = uniString[i];


  *outString = (char *) malloc ( (strlen ( tempString ) + 1) * sizeof (char) );
  strcpy ( *outString, tempString );
  free ( (char *)tempString );

  mylflags->csOut = image;


  return ( count );
}


MODULE = LibEth		PACKAGE = LibEth		



float
LibEthVersion ()


char *
LibEthVersionName ()
	CODE:
		char ** version;
		LibEthVersionString (version);
		RETVAL = *version;
		OUTPUT:
		RETVAL


unsigned char *
ConvertEthiopicString (string, sysIn, xferIn, sysOut, xferOut, fontOut, langOut, iPath, closing)
	char* string;
	int sysIn;
	int xferIn;
	int sysOut;
	int xferOut;
	int fontOut;
	enum Languages langOut;
	char* iPath;
	int closing;

	CODE:
	LibEthFlags* mylflags =  SetDefaultLibEthFlags (langOut, eng, langOut);
	unsigned char* outString = NULL;
	FCHAR* uniString = NULL;
	FCHAR* xString = NULL;
	int setId = NIL, nestLevel = 0;
	enum HTMLEscapes TagOn = Off;
	int closeString;


	mylflags->cstIn       = mylflags->cstOut = html;
	mylflags->csIn        = sysIn;
	mylflags->tvIn        = xferIn;
	mylflags->csOut       = sysOut;
	mylflags->tvOut       = xferOut;
	mylflags->fontFaceOut = fontOut;

    closeString = (closing) ? CLOSESTRING : 0x00;

    uniString = sget_fstring ( string, mylflags );

    if ( mylflags->csOut == jis && mylflags->cstOut == html )
      jis_remap_space ( uniString );
    if ( mylflags->csOut == image )
	  image_sputs (uniString, (char **)&outString, iPath, mylflags);
    else if ( isFidelTrueType( sysOut ) )
      fidel_HTML_sputs (uniString, &outString, setId, &TagOn, closeString | NESTONCE,  &nestLevel, mylflags);
     else
	   fidel_sputs (uniString, &outString, mylflags);


	free ((FCHAR *)uniString);
	free ((LibEthFlags *)mylflags);
	if ( sysIn == sera )
	  lexer_reset ( mylflags );


	RETVAL = outString;
	OUTPUT:
	RETVAL


unsigned char *
ArabToEthiopic (Enumber, system, xfer, font, iPath)
	char* Enumber;
	int system;
	int xfer;
	int font;
	char* iPath;

	CODE:
	LibEthFlags* mylflags =  SetDefaultLibEthFlags (NIL, eng, NIL);
	FCHAR* uniString;
	int setId = NIL, nestLevel = 0;
	enum HTMLEscapes TagOn = Off;
	unsigned char* outString;


	mylflags->cstIn       = mylflags->cstOut = html;
	mylflags->csOut       = system;
	mylflags->tvOut       = xfer;
	mylflags->fontFaceOut = font;

	uniString = arabtof ( Enumber );
    if ( mylflags->csOut == jis && mylflags->cstOut == html )
      jis_remap_space ( uniString );
    if ( mylflags->csOut == image )
	  image_sputs (uniString, (char **)&outString, iPath, mylflags);
    else if ( isFidelTrueType( system ) )
      fidel_HTML_sputs (uniString, &outString, setId, &TagOn, CLOSESTRING | NESTONCE,  &nestLevel, mylflags);
     else
	   fidel_sputs (uniString, &outString, mylflags);

	free ((FCHAR *)uniString); 
	free ((LibEthFlags *)mylflags);

	RETVAL = outString;
	OUTPUT:
	RETVAL


long int
EthiopicToFixed ( date, month, year )
	int date;
	int month;
	long int year;


long int
GregorianToFixed ( date, month, year )
	int date;
	int month;
	long int year;


void
FixedToEthiopic ( fixed, date, month, year )
	long int fixed;
	int date;
	int month;
	long int year;
	CODE:
		FixedToEthiopic ( fixed, &date, &month, &year );
		OUTPUT:
		date
		month
		year


void
FixedToGregorian ( fixed, date, month, year )
	long int fixed;
	int date;
	int month;
	long int year;
	CODE:
		FixedToGregorian ( fixed, &date, &month, &year );
		OUTPUT:
		date
		month
		year


unsigned char*
isEthiopianHoliday ( date, month, year, LCInfo )
	int date;
	int month;
	long int year;
	unsigned int LCInfo;


boolean
isEthiopicLeapYear ( year )
	long int year;


boolean
isLeapYear ( year )
	long int year;


unsigned char* 
getEthiopicMonth ( month, lang, LCInfo )
  int month;
  enum Languages lang;
  unsigned int LCInfo;


unsigned char*
getEthiopicDayOfWeek ( date, month, year, langOut, LCInfo )
	int date;
	int month;
	long int year;
	enum Languages langOut;
	unsigned int LCInfo;


unsigned char*
getEthiopicDayName ( date, month, LCInfo )
  int date;
  int month;
  unsigned int LCInfo;


boolean
isBogusEthiopicDate ( date, month, year )
	int date;
	int month;
	long int year;


boolean
isBogusGregorianDate ( date, month, year )
	int date;
	int month;
	long int year;


char *
GregorianToEthiopic ( date, month, year )
	int date;
	int month;
	long int year;
	CODE:
        char * outString = (char *) malloc ( 11 * sizeof(char) );
		GregorianToEthiopic (&date, &month, &year);
		OUTPUT:
		date
		month
		year


char *
EthiopicToGregorian ( date, month, year )
	int date;
	int month;
	long int year;
	CODE:
        char * outString = (char *) malloc ( 11 * sizeof(char) );
		EthiopicToGregorian (&date, &month, &year);
		sprintf (outString,"%i,%i,%i", date, month, year);
		RETVAL = outString;
		OUTPUT:
		RETVAL


unsigned char *
ConvertEthiopicFileByLine (fileP, sysIn, xferIn, sysOut, xferOut, fontOut, langOut, iPath, aynIsZero, setId, nestLevel, TagOn, recycle)
	FILE* fileP;
	int sysIn;
	int xferIn;
	int sysOut;
	int xferOut;
	int fontOut;
	enum Languages langOut;
	char* iPath;
	boolean aynIsZero
	int setId;
	int nestLevel;
	enum HTMLEscapes TagOn;
	boolean recycle;

	CODE:
 	LibEthFlags* mylflags;
	unsigned char* outString = NULL;
	FCHAR* uniString = NULL;
	/* static FILE* lastFileP; */

	if ( feof(fileP) )
	  RETVAL = NULL;

    else {

	if ( !recycle )
	  {
		mylflags =  SetDefaultLibEthFlags (langOut, eng, langOut);
		recycle = true;
		mylflags->cstIn       = mylflags->cstOut = html;
		mylflags->csIn        = sysIn;
		mylflags->tvIn        = xferIn;
		mylflags->csOut       = sysOut;
		mylflags->tvOut       = xferOut;
		mylflags->fontFaceOut = fontOut;
		/* lastFileP = fileP; */
      }
/*  else
      fileP = lastFileP; */


	uniString = fidel_fgets (NULL, WSIZE, fileP, mylflags);


	if ( aynIsZero )
	  ayn2zero ( uniString );
    if ( mylflags->csOut == jis && mylflags->cstOut == html )
      jis_remap_space ( uniString );
    if ( mylflags->csOut == image )
	  image_sputs (uniString, (char **)&outString, iPath, mylflags);
    else if ( isFidelTrueType( sysOut ) )
	  setId = fidel_HTML_sputs (uniString, &outString, setId, &TagOn, NESTONCE, &nestLevel, mylflags);
     else
	   fidel_sputs (uniString, &outString, mylflags);


	free ((FCHAR *)uniString); 
	if ( feof(fileP) )
		free ((LibEthFlags *)mylflags);

	RETVAL = outString;

    }  /* endif ( feof(fileP) ), this is a wee XS hack... */

	OUTPUT:
	RETVAL
	fileP
	recycle
	setId
	nestLevel
	TagOn


void
ConvertEthiopicFile (fileP, sysIn, xferIn, sysOut, xferOut, fontOut, langOut, iPath, aynIsZero)
	FILE* fileP;
	int sysIn;
	int xferIn;
	int sysOut;
	int xferOut;
	int fontOut;
	enum Languages langOut;
	char* iPath;
	boolean aynIsZero

	CODE:
	LibEthFlags* mylflags;
	unsigned char* outString = NULL;
	FCHAR* uniString = NULL;
	int setId = NIL, nestLevel = 0;
	enum HTMLEscapes TagOn = Off;


	if ( feof(fileP) )
	  return;


	mylflags              =  SetDefaultLibEthFlags (langOut, eng, langOut);
	mylflags->cstIn       = mylflags->cstOut = html;
	mylflags->csIn        = sysIn;
	mylflags->tvIn        = xferIn;
	mylflags->csOut       = sysOut;
	mylflags->tvOut       = xferOut;
	mylflags->csOut       = sysOut;
	mylflags->tvOut       = xferOut;
	mylflags->fontFaceOut = fontOut;

	do 
	  {
		if ( (uniString = fidel_fgets (NULL, WSIZE, fileP, mylflags)) == NULL )
		  break;

		if ( aynIsZero )
		  ayn2zero ( uniString );
    	if ( mylflags->csOut == jis && mylflags->cstOut == html )
    	  jis_remap_space ( uniString );
    	if ( mylflags->csOut == image )
		  image_sputs (uniString, (char **)&outString, iPath, mylflags);
    	else if ( isFidelTrueType( sysOut ) )
		  setId = fidel_HTML_sputs (uniString, &outString, setId, &TagOn, NESTONCE, &nestLevel, mylflags);
    	 else
		   fidel_sputs (uniString, &outString, mylflags);

		fprintf ( stdout, "%s", outString );

		free ((unsigned char *)outString); 
		free ((FCHAR *)uniString); 
	  }
	while (!feof(fileP));


	free ((LibEthFlags *)mylflags);


	OUTPUT:
	fileP


unsigned char *
ConvertEthiopicFileToString (fileP, sysIn, xferIn, sysOut, xferOut, fontOut, langOut, iPath, aynIsZero)
	FILE* fileP;
	int sysIn;
	int xferIn;
	int sysOut;
	int xferOut;
	int fontOut;
	enum Languages langOut;
	char* iPath;
	boolean aynIsZero

	CODE:
	LibEthFlags* mylflags;
	unsigned char *outString = NULL, *returnString = NULL;
	unsigned char *fileString = NULL, *tempString = NULL;
	FCHAR* uniString = NULL;
	int setId = NIL, nestLevel = 0;
	enum HTMLEscapes TagOn = Off;
	int top = 0, newStringLength = 0, end = 50000;


	if ( feof(fileP) )
	  return;

    fileString = (unsigned char*) calloc ( end, sizeof (unsigned char)  );

	mylflags              = SetDefaultLibEthFlags (langOut, eng, langOut);
	mylflags->cstIn       = mylflags->cstOut = html;
	mylflags->csIn        = sysIn;
	mylflags->tvIn        = xferIn;
	mylflags->csOut       = sysOut;
	mylflags->tvOut       = xferOut;
	mylflags->csOut       = sysOut;
	mylflags->tvOut       = xferOut;
	mylflags->fontFaceOut = fontOut;

	do 
	  {
		if ( (uniString = fidel_fgets (NULL, WSIZE, fileP, mylflags)) == NULL )
		  break;

		if ( aynIsZero )
		  ayn2zero ( uniString );
    	if ( mylflags->csOut == jis && mylflags->cstOut == html )
    	  jis_remap_space ( uniString );
    	if ( mylflags->csOut == image )
		  image_sputs (uniString, (char **)&outString, iPath, mylflags);
    	else if ( isFidelTrueType ( sysOut ) )
		  setId = fidel_HTML_sputs (uniString, &outString, setId, &TagOn, CLOSESTRING | NESTONCE, &nestLevel, mylflags);
    	 else
		   fidel_sputs (uniString, &outString, mylflags);

        newStringLength = strlen ( outString );

		if ( (top + newStringLength) < end )
		  {
		    strcat ( fileString, outString );
		    top += newStringLength;
		  }
        else
          {
            end *= 1.5;
            tempString = (unsigned char*) calloc ( end, sizeof (unsigned char)  );
		    strcpy ( tempString, fileString );
		    strcat ( tempString, outString );
		    free ((unsigned char *)outString); 
		    outString = fileString;
		    fileString = tempString;
          }
	    top += newStringLength;


		free ((unsigned char *)outString); 
		free ((FCHAR *)uniString); 
	  }
	while (!feof(fileP));


	free ((LibEthFlags *)mylflags);

    returnString = (unsigned char*) malloc ( (top+1) * sizeof (unsigned char)  );
    strcpy ( returnString, fileString );
	free ((unsigned char *)fileString); 


	RETVAL = returnString;
	OUTPUT:
	RETVAL
	fileP
