
/*
 * *********** WARNING **************
 * This file generated by Apache::DAV::WrapXS/0.01
 * Any changes made here will be lost
 * ***********************************
 * 1. /opt/perl5.6.1/lib/site_perl/5.6.1/ExtUtils/XSBuilder/WrapXS.pm:38
 * 2. /opt/perl5.6.1/lib/site_perl/5.6.1/ExtUtils/XSBuilder/WrapXS.pm:1898
 * 3. xsbuilder/xs_generate.pl:6
 */


#include "mod_dav.h"

#include "EXTERN.h"

#include "perl.h"

#include "XSUB.h"

#include "moddav_xs_sv_convert.h"

#include "moddav_xs_typedefs.h"



void Apache__DAV__StateList_new_init (pTHX_ Apache__DAV__StateList  obj, SV * item, int overwrite) {

    SV * * tmpsv ;

    if (SvTYPE(item) == SVt_PVMG) 
        memcpy (obj, (void *)SvIVX(item), sizeof (*obj)) ;
    else if (SvTYPE(item) == SVt_PVHV) {
        if ((tmpsv = hv_fetch((HV *)item, "condition", sizeof("condition") - 1, 0)) || overwrite) {
            obj -> condition = (int)davxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "etag", sizeof("etag") - 1, 0)) || overwrite) {
            const char * tmpobj = ((const char *)davxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> etag = (const char *)strdup(tmpobj);
            else
                obj -> etag = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "locktoken", sizeof("locktoken") - 1, 0)) || overwrite) {
            obj -> locktoken = (dav_locktoken *)davxs_sv2_Apache__DAV__LockToken((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "next", sizeof("next") - 1, 0)) || overwrite) {
            obj -> next = (struct dav_if_state_list *)davxs_sv2_Apache__DAV__StateList((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
   ; }

    else
        croak ("initializer for Apache::DAV::StateList::new is not a hash or object reference") ;

} ;


MODULE = Apache::DAV::StateList    PACKAGE = Apache::DAV::StateList 

Apache::DAV::IfStateType
type(obj, val=NULL)
    Apache::DAV::StateList obj
    Apache::DAV::IfStateType val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Apache__DAV__IfStateType) & obj->type;
    if (items > 1) {
         croak ("type is read only") ;
    }
  OUTPUT:
    RETVAL

MODULE = Apache::DAV::StateList    PACKAGE = Apache::DAV::StateList 

int
condition(obj, val=0)
    Apache::DAV::StateList obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->condition;

    if (items > 1) {
        obj->condition = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Apache::DAV::StateList    PACKAGE = Apache::DAV::StateList 

const char *
etag(obj, val=NULL)
    Apache::DAV::StateList obj
    const char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (const char *)  obj->etag;

    if (items > 1) {
        obj->etag = (const char *)strdup(val);
    }
  OUTPUT:
    RETVAL

MODULE = Apache::DAV::StateList    PACKAGE = Apache::DAV::StateList 

Apache::DAV::LockToken
locktoken(obj, val=NULL)
    Apache::DAV::StateList obj
    Apache::DAV::LockToken val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Apache__DAV__LockToken)  obj->locktoken;

    if (items > 1) {
        obj->locktoken = (Apache__DAV__LockToken) val;
    }
  OUTPUT:
    RETVAL

MODULE = Apache::DAV::StateList    PACKAGE = Apache::DAV::StateList 

Apache::DAV::StateList
next(obj, val=NULL)
    Apache::DAV::StateList obj
    Apache::DAV::StateList val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Apache__DAV__StateList)  obj->next;

    if (items > 1) {
        obj->next = (Apache__DAV__StateList) val;
    }
  OUTPUT:
    RETVAL

MODULE = Apache::DAV::StateList    PACKAGE = Apache::DAV::StateList 



SV *
new (class,initializer=NULL)
    char * class
    SV * initializer 
PREINIT:
    SV * svobj ;
    Apache__DAV__StateList  cobj ;
    SV * tmpsv ;
CODE:
    davxs_Apache__DAV__StateList_create_obj(cobj,svobj,RETVAL,malloc(sizeof(*cobj))) ;

    if (initializer) {
        if (!SvROK(initializer) || !(tmpsv = SvRV(initializer))) 
            croak ("initializer for Apache::DAV::StateList::new is not a reference") ;

        if (SvTYPE(tmpsv) == SVt_PVHV || SvTYPE(tmpsv) == SVt_PVMG)  
            Apache__DAV__StateList_new_init (aTHX_ cobj, tmpsv, 0) ;
        else if (SvTYPE(tmpsv) == SVt_PVAV) {
            int i ;
            SvGROW(svobj, sizeof (*cobj) * av_len((AV *)tmpsv)) ;     
            for (i = 0; i <= av_len((AV *)tmpsv); i++) {
                SV * * itemrv = av_fetch((AV *)tmpsv, i, 0) ;
                SV * item ;
                if (!itemrv || !*itemrv || !SvROK(*itemrv) || !(item = SvRV(*itemrv))) 
                    croak ("array element of initializer for Apache::DAV::StateList::new is not a reference") ;
                Apache__DAV__StateList_new_init (aTHX_ &cobj[i], item, 1) ;
            }
        }
        else {
             croak ("initializer for Apache::DAV::StateList::new is not a hash/array/object reference") ;
        }
    }
OUTPUT:
    RETVAL 

PROTOTYPES: disabled

BOOT:
    items = items; /* -Wall */

