/* ====================================================================
 * Copyright (c) 2000-2001 by Soheil Seyfaie. All rights reserved.
 * This program is free software; you can redistribute it and/or modify
 * it under the same terms as Perl itself.
 * ====================================================================
 *
 * $Author: soheil $
 * $Id: Bitmap.xs,v 1.2 2001/12/30 20:26:34 soheil Exp $
 */


#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "SWF.h"
#include "perl_swf.h"


MODULE = SWF::Bitmap		PACKAGE = SWF::Bitmap		PREFIX = SWFBitmap_
PROTOTYPES: ENABLE

SWF::Bitmap
SWFBitmap_new(package="SWF::Bitmap", filename, alpha=NULL)
	char    *package
	char    *filename = NO_INIT
        char    *alpha
        PREINIT:
        CV      *cv;
        STRLEN  len;
        char   *my_sub;
	CODE:
        filename = (char *) SvPV(ST(1), len);
        if( strncasecmp(filename+len-4, ".jpg", 4) == 0 ||
            strncasecmp(filename+len-5, ".jpeg", 5) == 0)
            my_sub = alpha ? "SWF::Bitmap::newSWFJpegWithAlpha" : "SWF::Bitmap::newSWFJpegBitmap";
        else if(strncasecmp(filename+len-4, ".dbl", 4) == 0)
            my_sub = "SWF::Bitmap::newSWFDBLBitmap";
        else
            croak("argument to SWF::Bitmap::New must be a JPG or dbl filename");

        PUSHMARK(mark);
        cv = GvCV(gv_fetchpv(my_sub, FALSE, SVt_PVCV));
#ifdef PERL_OBJECT
        (void)(*CvXSUB(cv))(cv, pPerl);
#else
        (void)(*CvXSUB(cv))(aTHXo_ cv);
#endif


SWF::Bitmap
newSWFDBLBitmap(package="SWF::Bitmap", filename)
         char    *package
         char    *filename
         PREINIT: 
         FILE    *dbl;
         CODE:
         if ( !(dbl = fopen(filename, "rb")) ){
             fprintf(stderr, "Unable to open %s\n", filename);
             ST(0) = &sv_undef;
         }else{
                RETVAL = newSWFDBLBitmap(dbl);
                ST(0) = sv_newmortal();
                sv_setref_pv(ST(0), package, (void*)RETVAL);
         }

SWF::Bitmap
newSWFJpegWithAlpha(package="SWF::Bitmap", filename, mask)
        char    *package
        char    *filename
        char    *mask
        PREINIT:
        FILE    *f;
        FILE    *alpha;
        CODE:
        if ( !(f = fopen(filename, "rb")) ){
            fprintf(stderr, "Unable to open %s\n", filename);
            ST(0) = &sv_undef;
        }
        else{
            if ( !(alpha = fopen(mask, "rb")) ){
                fprintf(stderr, "Unable to open %s\n", mask);
                ST(0) = &sv_undef;
            }
            else{
                RETVAL = newSWFJpegWithAlpha(f, alpha);
                ST(0) = sv_newmortal();
                sv_setref_pv(ST(0), package, (void*)RETVAL);
           }
        }

SWF::Bitmap
newSWFJpegBitmap(package="SWF::Bitmap", filename)
        char    *package
        char    *filename
	PREINIT:
	FILE    *f;
	CODE:
	if (!(f = fopen(filename, "rb"))) {
		fprintf(stderr, "Unable to open %s\n", filename);
		ST(0) = &sv_undef;
	}else{
        	RETVAL = newSWFJpegBitmap(f);
	        ST(0) = sv_newmortal();
        	sv_setref_pv(ST(0), package, (void*)RETVAL);
	}

int
SWFBitmap_getWidth(b)
	SWF::Bitmap	b

int
SWFBitmap_getHeight(b)
	SWF::Bitmap	b

void
destroySWFBitmap(bitmap)
        SWF::Bitmap     bitmap 
        ALIAS:
        SWF::Bitmap::DESTROY = 1
        CODE:
	S_DEBUG(2, fprintf(stderr, "Bitmap DESTROY CALLED\n"));
        destroySWFBitmap(bitmap);


