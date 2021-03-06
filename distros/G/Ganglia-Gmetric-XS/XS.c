/*
 * This file was generated automatically by ExtUtils::ParseXS version 3.24 from the
 * contents of XS.xs. Do not edit this file, edit XS.xs instead.
 *
 *    ANY CHANGES MADE HERE WILL BE LOST!
 *
 */

#line 1 "XS.xs"
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_sv_2pv_flags
#include "ppport.h"

#include "ganglia.h"

#ifdef GANGLIA30
#  define Ganglia_metric          Ganglia_gmetric
#  define Ganglia_metric_create   Ganglia_gmetric_create
#  define Ganglia_metric_set      Ganglia_gmetric_set
#  define Ganglia_metric_send     Ganglia_gmetric_send
#  define Ganglia_metric_destroy  Ganglia_gmetric_destroy
#endif

#define XS_STATE(type, x) \
  INT2PTR(type, SvROK(x) ? SvIV(SvRV(x)) : SvIV(x))

typedef struct ganglia_t {
  Ganglia_pool              context;
  Ganglia_metric            gmetric;
  Ganglia_udp_send_channels channel;
  Ganglia_gmond_config      gconfig;
  char*                     spoof;
} ganglia;

#line 39 "XS.c"
#ifndef PERL_UNUSED_VAR
#  define PERL_UNUSED_VAR(var) if (0) var = var
#endif

#ifndef dVAR
#  define dVAR		dNOOP
#endif


/* This stuff is not part of the API! You have been warned. */
#ifndef PERL_VERSION_DECIMAL
#  define PERL_VERSION_DECIMAL(r,v,s) (r*1000000 + v*1000 + s)
#endif
#ifndef PERL_DECIMAL_VERSION
#  define PERL_DECIMAL_VERSION \
	  PERL_VERSION_DECIMAL(PERL_REVISION,PERL_VERSION,PERL_SUBVERSION)
#endif
#ifndef PERL_VERSION_GE
#  define PERL_VERSION_GE(r,v,s) \
	  (PERL_DECIMAL_VERSION >= PERL_VERSION_DECIMAL(r,v,s))
#endif
#ifndef PERL_VERSION_LE
#  define PERL_VERSION_LE(r,v,s) \
	  (PERL_DECIMAL_VERSION <= PERL_VERSION_DECIMAL(r,v,s))
#endif

/* XS_INTERNAL is the explicit static-linkage variant of the default
 * XS macro.
 *
 * XS_EXTERNAL is the same as XS_INTERNAL except it does not include
 * "STATIC", ie. it exports XSUB symbols. You probably don't want that
 * for anything but the BOOT XSUB.
 *
 * See XSUB.h in core!
 */


/* TODO: This might be compatible further back than 5.10.0. */
#if PERL_VERSION_GE(5, 10, 0) && PERL_VERSION_LE(5, 15, 1)
#  undef XS_EXTERNAL
#  undef XS_INTERNAL
#  if defined(__CYGWIN__) && defined(USE_DYNAMIC_LOADING)
#    define XS_EXTERNAL(name) __declspec(dllexport) XSPROTO(name)
#    define XS_INTERNAL(name) STATIC XSPROTO(name)
#  endif
#  if defined(__SYMBIAN32__)
#    define XS_EXTERNAL(name) EXPORT_C XSPROTO(name)
#    define XS_INTERNAL(name) EXPORT_C STATIC XSPROTO(name)
#  endif
#  ifndef XS_EXTERNAL
#    if defined(HASATTRIBUTE_UNUSED) && !defined(__cplusplus)
#      define XS_EXTERNAL(name) void name(pTHX_ CV* cv __attribute__unused__)
#      define XS_INTERNAL(name) STATIC void name(pTHX_ CV* cv __attribute__unused__)
#    else
#      ifdef __cplusplus
#        define XS_EXTERNAL(name) extern "C" XSPROTO(name)
#        define XS_INTERNAL(name) static XSPROTO(name)
#      else
#        define XS_EXTERNAL(name) XSPROTO(name)
#        define XS_INTERNAL(name) STATIC XSPROTO(name)
#      endif
#    endif
#  endif
#endif

/* perl >= 5.10.0 && perl <= 5.15.1 */


/* The XS_EXTERNAL macro is used for functions that must not be static
 * like the boot XSUB of a module. If perl didn't have an XS_EXTERNAL
 * macro defined, the best we can do is assume XS is the same.
 * Dito for XS_INTERNAL.
 */
#ifndef XS_EXTERNAL
#  define XS_EXTERNAL(name) XS(name)
#endif
#ifndef XS_INTERNAL
#  define XS_INTERNAL(name) XS(name)
#endif

/* Now, finally, after all this mess, we want an ExtUtils::ParseXS
 * internal macro that we're free to redefine for varying linkage due
 * to the EXPORT_XSUB_SYMBOLS XS keyword. This is internal, use
 * XS_EXTERNAL(name) or XS_INTERNAL(name) in your code if you need to!
 */

#undef XS_EUPXS
#if defined(PERL_EUPXS_ALWAYS_EXPORT)
#  define XS_EUPXS(name) XS_EXTERNAL(name)
#else
   /* default to internal */
#  define XS_EUPXS(name) XS_INTERNAL(name)
#endif

#ifndef PERL_ARGS_ASSERT_CROAK_XS_USAGE
#define PERL_ARGS_ASSERT_CROAK_XS_USAGE assert(cv); assert(params)

/* prototype to pass -Wmissing-prototypes */
STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params);

STATIC void
S_croak_xs_usage(pTHX_ const CV *const cv, const char *const params)
{
    const GV *const gv = CvGV(cv);

    PERL_ARGS_ASSERT_CROAK_XS_USAGE;

    if (gv) {
        const char *const gvname = GvNAME(gv);
        const HV *const stash = GvSTASH(gv);
        const char *const hvname = stash ? HvNAME(stash) : NULL;

        if (hvname)
            Perl_croak(aTHX_ "Usage: %s::%s(%s)", hvname, gvname, params);
        else
            Perl_croak(aTHX_ "Usage: %s(%s)", gvname, params);
    } else {
        /* Pants. I don't think that it should be possible to get here. */
        Perl_croak(aTHX_ "Usage: CODE(0x%"UVxf")(%s)", PTR2UV(cv), params);
    }
}
#undef  PERL_ARGS_ASSERT_CROAK_XS_USAGE

#ifdef PERL_IMPLICIT_CONTEXT
#define croak_xs_usage(a,b)    S_croak_xs_usage(aTHX_ a,b)
#else
#define croak_xs_usage        S_croak_xs_usage
#endif

#endif

/* NOTE: the prototype of newXSproto() is different in versions of perls,
 * so we define a portable version of newXSproto()
 */
#ifdef newXS_flags
#define newXSproto_portable(name, c_impl, file, proto) newXS_flags(name, c_impl, file, proto, 0)
#else
#define newXSproto_portable(name, c_impl, file, proto) (PL_Sv=(SV*)newXS(name, c_impl, file), sv_setpv(PL_Sv, proto), (CV*)PL_Sv)
#endif /* !defined(newXS_flags) */

#line 181 "XS.c"

XS_EUPXS(XS_Ganglia__Gmetric__XS__ganglia_initialize); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Ganglia__Gmetric__XS__ganglia_initialize)
{
    dVAR; dXSARGS;
    if (items != 3)
       croak_xs_usage(cv,  "class, config, spoof");
    {
	SV *	class = ST(0)
;
	char *	config = (char *)SvPV_nolen(ST(1))
;
	char *	spoof = (char *)SvPV_nolen(ST(2))
;
#line 37 "XS.xs"
    ganglia *gang;
    SV *sv;
#line 199 "XS.c"
	SV *	RETVAL;
#line 40 "XS.xs"
    if (SvROK(class))
      croak("Cannot call new() on a reference");
    Newxz(gang, 1, ganglia);
#ifdef DIAG
    PerlIO_printf(PerlIO_stderr(), "config:%s\n", config);
#endif

    gang->context = Ganglia_pool_create(NULL);
    if (! gang->context)
      croak("failed to Ganglia_pool_create");

    gang->gconfig = Ganglia_gmond_config_create(config, 0);
    if (! gang->gconfig)
      croak("failed to Ganglia_gmond_config_create");

    gang->channel = Ganglia_udp_send_channels_create(gang->context, gang->gconfig);
    if (! gang->channel)
      croak("failed to Ganglia_udp_send_channels_create");

    gang->spoof = spoof;

    RETVAL = sv_setref_iv(newSV(0), SvPV_nolen(class), PTR2IV(gang));
#line 224 "XS.c"
	ST(0) = RETVAL;
	sv_2mortal(ST(0));
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Ganglia__Gmetric__XS__ganglia_send); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Ganglia__Gmetric__XS__ganglia_send)
{
    dVAR; dXSARGS;
    if (items != 12)
       croak_xs_usage(cv,  "self, name, value, type, units, group, desc, title, slope, tmax, dmax, spoof");
    {
	SV *	self = ST(0)
;
	char *	name = (char *)SvPV_nolen(ST(1))
;
	char *	value = (char *)SvPV_nolen(ST(2))
;
	char *	type = (char *)SvPV_nolen(ST(3))
;
	char *	units = (char *)SvPV_nolen(ST(4))
;
	char *	group = (char *)SvPV_nolen(ST(5))
;
	char *	desc = (char *)SvPV_nolen(ST(6))
;
	char *	title = (char *)SvPV_nolen(ST(7))
;
	unsigned int	slope = (unsigned int)SvUV(ST(8))
;
	unsigned int	tmax = (unsigned int)SvUV(ST(9))
;
	unsigned int	dmax = (unsigned int)SvUV(ST(10))
;
	char *	spoof = (char *)SvPV_nolen(ST(11))
;
#line 80 "XS.xs"
    ganglia *gang;
    char *spf;
#line 266 "XS.c"
	int	RETVAL;
	dXSTARG;
#line 83 "XS.xs"
    int   r;
    gang = XS_STATE(ganglia *, self);

    gang->gmetric = Ganglia_metric_create(gang->context);
    if (! gang->gmetric)
      croak("failed to Ganglia_metric_create");
#ifdef DIAG
    PerlIO_printf(PerlIO_stderr(), "send:%s=%s\n", name,value);
#endif
    r = Ganglia_metric_set(gang->gmetric, name, value, type, units, slope, tmax, dmax);
    switch(r) {
    case 1:
      croak("gmetric parameters invalid. exiting.\n");
    case 2:
      croak("one of your parameters has an invalid character '\"'. exiting.\n");
    case 3:
      croak("the type parameter \"%s\" is not a valid type. exiting.\n", type);
    case 4:
      croak("the value parameter \"%s\" does not represent a number. exiting.\n", value);
    }

    if (*group != '\0')
        Ganglia_metadata_add(gang->gmetric, "GROUP", group);
    if (*desc  != '\0')
        Ganglia_metadata_add(gang->gmetric, "DESC", desc);
    if (*title != '\0')
        Ganglia_metadata_add(gang->gmetric, "TITLE", title);

    if (gang->spoof)
        spf = gang->spoof;
    if (spoof && *spoof != '\0')
        spf = spoof;
    if (spf)
        Ganglia_metadata_add(gang->gmetric, SPOOF_HOST, spf);

    RETVAL = ! Ganglia_metric_send(gang->gmetric, gang->channel);
    Ganglia_metric_destroy(gang->gmetric);
#line 307 "XS.c"
	XSprePUSH; PUSHi((IV)RETVAL);
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Ganglia__Gmetric__XS__ganglia_heartbeat); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Ganglia__Gmetric__XS__ganglia_heartbeat)
{
    dVAR; dXSARGS;
    if (items != 2)
       croak_xs_usage(cv,  "self, spoof");
    {
	SV *	self = ST(0)
;
	char *	spoof = (char *)SvPV_nolen(ST(1))
;
#line 128 "XS.xs"
    ganglia *gang;
#line 327 "XS.c"
	int	RETVAL;
	dXSTARG;
#line 130 "XS.xs"
    int   r;
    char *spf;
    gang = XS_STATE(ganglia *, self);

    gang->gmetric = Ganglia_metric_create(gang->context);
    if (! gang->gmetric)
      croak("failed to Ganglia_metric_create");
#ifdef DIAG
    PerlIO_printf(PerlIO_stderr(), "heartbeat\n");
#endif
    r = Ganglia_metric_set(gang->gmetric, "heartbeat", "0", "uint32", "", 0, 0, 0);
    switch(r) {
    case 1:
      croak("gmetric parameters invalid. exiting.\n");
    case 2:
      croak("one of your parameters has an invalid character '\"'. exiting.\n");
    }
    if (gang->spoof)
        spf = gang->spoof;
    if (spoof && *spoof != '\0')
        spf = spoof;
    if (spf)
      Ganglia_metadata_add(gang->gmetric, SPOOF_HOST, spf);
    Ganglia_metadata_add(gang->gmetric, SPOOF_HEARTBEAT, "yes");
#ifdef DIAG
    PerlIO_printf(PerlIO_stderr(), "spoof: %s\n", spoof);
#endif
    RETVAL = ! Ganglia_metric_send(gang->gmetric, gang->channel);
    Ganglia_metric_destroy(gang->gmetric);
#line 360 "XS.c"
	XSprePUSH; PUSHi((IV)RETVAL);
    }
    XSRETURN(1);
}


XS_EUPXS(XS_Ganglia__Gmetric__XS_DESTROY); /* prototype to pass -Wmissing-prototypes */
XS_EUPXS(XS_Ganglia__Gmetric__XS_DESTROY)
{
    dVAR; dXSARGS;
    if (items != 1)
       croak_xs_usage(cv,  "self");
    {
	SV *	self = ST(0)
;
#line 166 "XS.xs"
    ganglia *gang;
#line 378 "XS.c"
#line 168 "XS.xs"
#ifdef DIAG
    PerlIO_printf(PerlIO_stderr(), "DESTROY: called\n" );
    PerlIO_printf(PerlIO_stderr(), "REFCNT:self=%d\n", SvREFCNT(self));
#endif
    gang = XS_STATE(ganglia *, self);
    if (gang == NULL) {
#ifdef DIAG
      PerlIO_printf(PerlIO_stderr(), "DESTROY: gang is null\n" );
#endif
      return;
    }

    if (gang->context != NULL)
      Ganglia_pool_destroy(gang->context);
    cfg_free(gang->gconfig);
    Safefree(gang);
#ifdef DIAG
    PerlIO_printf(PerlIO_stderr(), "DESTROY: done\n" );
#endif
#line 399 "XS.c"
    }
    XSRETURN_EMPTY;
}

#ifdef __cplusplus
extern "C"
#endif
XS_EXTERNAL(boot_Ganglia__Gmetric__XS); /* prototype to pass -Wmissing-prototypes */
XS_EXTERNAL(boot_Ganglia__Gmetric__XS)
{
    dVAR; dXSARGS;
#if (PERL_REVISION == 5 && PERL_VERSION < 9)
    char* file = __FILE__;
#else
    const char* file = __FILE__;
#endif

    PERL_UNUSED_VAR(cv); /* -W */
    PERL_UNUSED_VAR(items); /* -W */
#ifdef XS_APIVERSION_BOOTCHECK
    XS_APIVERSION_BOOTCHECK;
#endif
    XS_VERSION_BOOTCHECK;

        newXS("Ganglia::Gmetric::XS::_ganglia_initialize", XS_Ganglia__Gmetric__XS__ganglia_initialize, file);
        newXS("Ganglia::Gmetric::XS::_ganglia_send", XS_Ganglia__Gmetric__XS__ganglia_send, file);
        newXS("Ganglia::Gmetric::XS::_ganglia_heartbeat", XS_Ganglia__Gmetric__XS__ganglia_heartbeat, file);
        newXS("Ganglia::Gmetric::XS::DESTROY", XS_Ganglia__Gmetric__XS_DESTROY, file);
#if (PERL_REVISION == 5 && PERL_VERSION >= 9)
  if (PL_unitcheckav)
       call_list(PL_scopestack_ix, PL_unitcheckav);
#endif
    XSRETURN_YES;
}

