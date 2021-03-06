
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

#include "Apache/DAV/Apache__DAV.h"

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_add_lock(r, resource, lockdb, request)
    Apache r
    Apache::DAV::Resource resource
    Apache::DAV::LockDB lockdb
    Apache::DAV::Lock request
PREINIT:
    Apache__DAV__Response response;
PPCODE:
    RETVAL = dav_add_lock(r, resource, lockdb, request, &response);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_Apache__DAV__Error_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__Response_2obj(response)) ;

MODULE = Apache::DAV    PACKAGE = Apache::DAV::WalkerCtx   PREFIX = dav_

void
dav_add_response(ctx, href, status, propstats)
    Apache::DAV::WalkerCtx ctx
    const char * href
    int status
    Apache::DAV::PropsResult propstats

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropDB   PREFIX = dav_

void
dav_close_propdb(db)
    Apache::DAV::PropDB db

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

int
dav_dyn_module_add(p, name, mod)
    Apache::Pool p
    const char * name
    Apache::DAV::DynModule mod

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

const char *
dav_empty_elem(p, elem)
    Apache::Pool p
    Apache::DAV::XMLElem elem

MODULE = Apache::DAV    PACKAGE = Apache::DAV::XMLElem   PREFIX = dav_

Apache::DAV::XMLElem
dav_find_child(elem, tagname)
    Apache::DAV::XMLElem elem
    const char * tagname

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::DynModule
dav_find_module(name)
    const char * name

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropDB   PREFIX = dav_

Apache::DAV::PropsResult
dav_get_allprops(db, getvals)
    Apache::DAV::PropDB db
    int getvals
CODE:
    RETVAL = glue_dav_get_allprops(db, getvals);
OUTPUT:
    RETVAL


MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_get_depth(r, def_depth)
    Apache r
    int def_depth

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::Table
dav_get_dir_params(r)
    Apache r

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

size_t
dav_get_limit_xml_body(r)
    Apache r

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

const char *
dav_get_lockdb_path(r)
    Apache r

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_get_locktoken_list(r)
    Apache r
PREINIT:
    Apache__DAV__LockTokenList ltl;
PPCODE:
    RETVAL = dav_get_locktoken_list(r, &ltl);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_Apache__DAV__Error_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__LockTokenList_2obj(ltl)) ;

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropDB   PREFIX = dav_

Apache::DAV::PropsResult
dav_get_props(db, doc)
    Apache::DAV::PropDB db
    Apache::DAV::XMLDoc doc
CODE:
    RETVAL = glue_dav_get_props(db, doc);
OUTPUT:
    RETVAL


MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::DynHooks
dav_get_provider_hooks(r, provider_type)
    Apache r
    int provider_type

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_get_resource(r)
    Apache r
PREINIT:
    Apache__DAV__Resource res_p;
PPCODE:
    RETVAL = dav_get_resource(r, &res_p);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_IV_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__Resource_2obj(res_p)) ;

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_get_resource_state(r, resource)
    Apache r
    Apache::DAV::Resource resource

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

const char *
dav_get_target_selector(r)
    Apache r

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

time_t
dav_get_timeout(r)
    Apache r

MODULE = Apache::DAV    PACKAGE = Apache::Array   PREFIX = dav_

int
dav_insert_uri(uri_array, uri)
    Apache::Array uri_array
    const char * uri

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_load_module(name, module_sym, filename)
    const char * name
    const char * module_sym
    const char * filename

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_lock_parse_lockinfo(r, resrouce, lockdb, doc)
    Apache r
    Apache::DAV::Resource resrouce
    Apache::DAV::LockDB lockdb
    Apache::DAV::XMLDoc doc
PREINIT:
    Apache__DAV__Lock lock_request;
PPCODE:
    RETVAL = dav_lock_parse_lockinfo(r, resrouce, lockdb, doc, &lock_request);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_Apache__DAV__Error_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__Lock_2obj(lock_request)) ;

MODULE = Apache::DAV    PACKAGE = Apache::DAV::LockDB   PREFIX = dav_

Apache::DAV::Error
dav_lock_query(lockdb, resource)
    Apache::DAV::LockDB lockdb
    Apache::DAV::Resource resource
PREINIT:
    Apache__DAV__Lock locks;
PPCODE:
    RETVAL = dav_lock_query(lockdb, resource, &locks);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_Apache__DAV__Error_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__Lock_2obj(locks)) ;

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

const char *
dav_lookup_status(status)
    int status

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

Apache::DAV::Error
dav_new_error(p, status, error_id, desc)
    Apache::Pool p
    int status
    int error_id
    const char * desc

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_notify_created(r, lockdb, resource, resource_state, depth)
    Apache r
    Apache::DAV::LockDB lockdb
    Apache::DAV::Resource resource
    int resource_state
    int depth

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_open_lockdb(r, ro=0)
    Apache r
    int ro
PREINIT:
    Apache__DAV__LockDB lockdb;
PPCODE:
    RETVAL = dav_open_lockdb(r, ro, &lockdb);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_Apache__DAV__Error_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__LockDB_2obj(lockdb)) ;

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_open_propdb(r, lockdb, resource, ro=0, ns_xlate=NULL)
    Apache r
    Apache::DAV::LockDB lockdb
    Apache::DAV::Resource resource
    int ro
    Apache::Array ns_xlate
PREINIT:
    Apache__DAV__PropDB propdb;
PPCODE:
    RETVAL = dav_open_propdb(r, lockdb, resource, ro, ns_xlate, &propdb);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_Apache__DAV__Error_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__PropDB_2obj(propdb)) ;

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_parse_input(r)
    Apache r
PREINIT:
    Apache__DAV__XMLDoc pdoc;
PPCODE:
    RETVAL = dav_parse_input(r, &pdoc);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_IV_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__XMLDoc_2obj(pdoc)) ;

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

void *
dav_prepare_scan(p, mod)
    Apache::Pool p
    Apache::DAV::DynModule mod

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

void
dav_process_builtin_modules(p)
    Apache::Pool p

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

void
dav_process_module(p, mod)
    Apache::Pool p
    Apache::DAV::DynModule mod

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropCtx   PREFIX = dav_

void
dav_prop_commit(ctx)
    Apache::DAV::PropCtx ctx

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropCtx   PREFIX = dav_

void
dav_prop_exec(ctx)
    Apache::DAV::PropCtx ctx

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropCtx   PREFIX = dav_

void
dav_prop_rollback(ctx)
    Apache::DAV::PropCtx ctx

MODULE = Apache::DAV    PACKAGE = Apache::DAV::PropCtx   PREFIX = dav_

void
dav_prop_validate(ctx)
    Apache::DAV::PropCtx ctx

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_proppatch(r, resource, doc)
    Apache r
    Apache::DAV::Resource resource
    Apache::DAV::XMLDoc doc
PREINIT:
    Apache__DAV__Text propstat_text_ptr;
PPCODE:
    RETVAL = dav_proppatch(r, resource, doc, &propstat_text_ptr);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_IV_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__Text_2obj(propstat_text_ptr)) ;

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

Apache::DAV::Error
dav_push_error(p, status, error_id, desc, prev)
    Apache::Pool p
    int status
    int error_id
    const char * desc
    Apache::DAV::Error prev

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

const char *
dav_quote_string(p, s, quotes)
    Apache::Pool p
    const char * s
    int quotes

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

void
dav_quote_xml_elem(p, elem)
    Apache::Pool p
    Apache::DAV::XMLElem elem

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

Apache::DAV::Error
dav_revert_resource_writability(r, resource, parent_resource, undo, resource_existed, resource_was_writable, parent_was_writable)
    Apache r
    Apache::DAV::Resource resource
    Apache::DAV::Resource parent_resource
    int undo
    int resource_existed
    int resource_was_writable
    int parent_was_writable

MODULE = Apache::DAV    PACKAGE = Apache::DAV::DynHooks   PREFIX = dav_

int
dav_scan_providers(ctx, output)
    void * ctx
    Apache::DAV::DynHooks output
PREINIT:
    Apache__DAV__DynProvider provider;
PPCODE:
    RETVAL = dav_scan_providers(ctx, &provider, output);
    XSprePUSH;
    EXTEND(SP, 2) ;
    PUSHs(davxs_IV_2obj(RETVAL)) ;
    PUSHs(davxs_Apache__DAV__DynProvider_2obj(provider)) ;

MODULE = Apache::DAV    PACKAGE = Apache::Pool   PREFIX = dav_

void
dav_text_append(p, hdr, text)
    Apache::Pool p
    Apache::DAV::TextHeader hdr
    const char * text

MODULE = Apache::DAV    PACKAGE = Apache   PREFIX = dav_

int
dav_unlock(r, resource, locktoken)
    Apache r
    Apache::DAV::Resource resource
    Apache::DAV::LockToken locktoken

MODULE = Apache::DAV    PACKAGE = Apache::DAV::XMLDoc   PREFIX = dav_

int
dav_validate_root(doc, tagname)
    Apache::DAV::XMLDoc doc
    const char * tagname

PROTOTYPES: disabled

BOOT:
    items = items; /* -Wall */

