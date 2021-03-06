/**
 * perl-libxml-mm.h
 * $Id$
 *
 * Basic concept:
 * perl varies in the implementation of UTF8 handling. this header (together
 * with the c source) implements a few functions, that can be used from within
 * the core module inorder to avoid cascades of c pragmas
 */
/*
 * This is free software, you may use it and distribute it under the same terms as
 * Perl itself.
 *
 * Copyright 2001-2009 AxKit.com Ltd.
*/

#ifndef __PERL_LIBXML_MM_H__
#define __PERL_LIBXML_MM_H__

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"

#include <libxml/parser.h>

#ifdef __cplusplus
}
#endif

/*
 * NAME xs_warn
 * TYPE MACRO
 *
 * this makro is for XML::LibXML development and debugging.
 *
 * SYNOPSIS
 * xs_warn("my warning")
 *
 * this makro takes only a single string(!) and passes it to perls
 * warn function if the XS_WARNRINGS pragma is used at compile time
 * otherwise any xs_warn call is ignored.
 *
 * pay attention, that xs_warn does not implement a complete wrapper
 * for warn!!
 */
#ifdef XS_WARNINGS
#define xs_warn(string) warn("%s",string)
#else
#define xs_warn(string)
#endif

struct _ProxyNode {
    xmlNodePtr node;
    xmlNodePtr owner;
    int count;
};

struct _DocProxyNode {
    xmlNodePtr node;
    xmlNodePtr owner;
    int count;
    int encoding; /* only used for proxies of xmlDocPtr */
    int psvi_status; /* three-state flag for a document */
};

#define Pmm_NO_PSVI 0
#define Pmm_PSVI_TAINTED 1

/* helper type for the proxy structure */
typedef struct _DocProxyNode DocProxyNode;
typedef struct _ProxyNode ProxyNode;

/* pointer to the proxy structure */
typedef ProxyNode* ProxyNodePtr;
typedef DocProxyNode* DocProxyNodePtr;

/* this my go only into the header used by the xs */
#define SvPROXYNODE(x) (INT2PTR(ProxyNodePtr,SvIV(SvRV(x))))
#define PmmPROXYNODE(x) (INT2PTR(ProxyNodePtr,x->_private))
#define SvNAMESPACE(x) (INT2PTR(xmlNsPtr,SvIV(SvRV(x))))

#define x_PmmREFCNT(node)      node->count
#define x_PmmREFCNT_inc(node)  node->count++
#define x_PmmNODE(xnode)       xnode->node
#define x_PmmOWNER(node)       node->owner
#define x_PmmOWNERPO(node)     ((node && x_PmmOWNER(node)) ? (ProxyNodePtr)x_PmmOWNER(node)->_private : node)

#define x_PmmENCODING(node)    ((DocProxyNodePtr)(node))->encoding
#define x_PmmNodeEncoding(node) ((DocProxyNodePtr)(node->_private))->encoding

#define x_SetPmmENCODING(node,code) x_PmmENCODING(node)=(code)
#define x_SetPmmNodeEncoding(node,code) x_PmmNodeEncoding(node)=(code)

#ifndef NO_XML_LIBXML_THREADS
#ifdef USE_ITHREADS
#define XML_LIBXML_THREADS
#endif
#endif

#ifdef XML_LIBXML_THREADS

/* structure for storing thread-local refcount */
struct _LocalProxyNode {
	ProxyNodePtr proxy;
	int count;
};
typedef struct _LocalProxyNode LocalProxyNode;
typedef LocalProxyNode* LocalProxyNodePtr;


#define x_PmmUSEREGISTRY		(x_PROXY_NODE_REGISTRY_MUTEX != NULL)
#define x_PmmREGISTRY		(INT2PTR(xmlHashTablePtr,SvIV(SvRV(get_sv("XML::LibXML::__PROXY_NODE_REGISTRY",0)))))

#endif /* XML_LIBXML_THREADS */

ProxyNodePtr
x_PmmNewNode(xmlNodePtr node);

ProxyNodePtr
x_PmmNewFragment(xmlDocPtr document);

SV*
x_PmmCreateDocNode( unsigned int type, ProxyNodePtr pdoc, ...);

int
x_PmmREFCNT_dec( ProxyNodePtr node );

SV*
x_PmmNodeToSv( xmlNodePtr node, ProxyNodePtr owner );

/* x_PmmFixProxyEncoding
 * TYPE
 *    Method
 * PARAMETER
 *    @dfProxy: The proxystructure to fix.
 *
 * DESCRIPTION
 *
 * This little helper allows to fix the proxied encoding information
 * after a not standard operation was done. This is required for
 * XML::LibXSLT
 */
void
x_PmmFixProxyEncoding( ProxyNodePtr dfProxy );

/* x_PmmSvNodeExt
 * TYPE
 *    Function
 * PARAMETER
 *    @perlnode: the perl reference that holds the scalar.
 *    @copy : copy flag
 *
 * DESCRIPTION
 *
 * The function recognizes XML::LibXML and XML::GDOME
 * nodes as valid input data. The second parameter 'copy'
 * indicates if in case of GDOME nodes the libxml2 node
 * should be copied. In some cases, where the node is
 * cloned anyways, this flag has to be set to '0', while
 * the default value should be allways '1'.
 */
xmlNodePtr
x_PmmSvNodeExt( SV * perlnode, int copy );

/* x_PmmSvNode
 * TYPE
 *    Macro
 * PARAMETER
 *    @perlnode: a perl reference that holds a libxml node
 *
 * DESCRIPTION
 *
 * x_PmmSvNode fetches the libxml node such as x_PmmSvNodeExt does. It is
 * a wrapper, that sets the copy always to 1, which is good for all
 * cases XML::LibXML uses.
 */
#define x_PmmSvNode(n) x_PmmSvNodeExt(n,1)


xmlNodePtr
x_PmmSvOwner( SV * perlnode );

SV*
x_PmmSetSvOwner(SV * perlnode, SV * owner );

void
x_PmmFixOwner(ProxyNodePtr node, ProxyNodePtr newOwner );

void
x_PmmFixOwnerNode(xmlNodePtr node, ProxyNodePtr newOwner );

int
x_PmmContextREFCNT_dec( ProxyNodePtr node );

SV*
x_PmmContextSv( xmlParserCtxtPtr ctxt );

xmlParserCtxtPtr
x_PmmSvContext( SV * perlctxt );

/**
 * NAME x_PmmCopyNode
 * TYPE function
 *
 * returns libxml2 node
 *
 * DESCRIPTION
 * This function implements a nodetype independant node cloning.
 *
 * Note that this function has to stay in this module, since
 * XML::LibXSLT reuses it.
 */
xmlNodePtr
x_PmmCloneNode( xmlNodePtr node , int deep );

/**
 * NAME x_PmmNodeToGdomeSv
 * TYPE function
 *
 * returns XML::GDOME node
 *
 * DESCRIPTION
 * creates an Gdome node from our XML::LibXML node.
 * this function is very usefull for the parser.
 *
 * the function will only work, if XML::LibXML is compiled with
 * XML::GDOME support.
 *
 */
SV *
x_PmmNodeToGdomeSv( xmlNodePtr node );

/**
 * NAME x_PmmNodeTypeName
 * TYPE function
 *
 * returns the perl class name for the given node
 *
 * SYNOPSIS
 * CLASS = x_PmmNodeTypeName( node );
 */
const char*
x_PmmNodeTypeName( xmlNodePtr elem );

xmlChar*
x_PmmEncodeString( const char *encoding, const char *string );

char*
x_PmmDecodeString( const char *encoding, const xmlChar *string);

/* string manipulation will go elsewhere! */

/*
 * NAME c_string_to_sv
 * TYPE function
 * SYNOPSIS
 * SV *my_sv = c_string_to_sv( "my string", encoding );
 *
 * this function converts a libxml2 string to a SV*. although the
 * string is copied, the func does not free the c-string for you!
 *
 * encoding is either NULL or a encoding string such as provided by
 * the documents encoding. if encoding is NULL UTF8 is assumed.
 *
 */
SV*
C2Sv( const xmlChar *string, const xmlChar *encoding );

/*
 * NAME sv_to_c_string
 * TYPE function
 * SYNOPSIS
 * SV *my_sv = sv_to_c_string( my_sv, encoding );
 *
 * this function converts a SV* to a libxml string. the SV-value will
 * be copied into a *newly* allocated string. (don't forget to free it!)
 *
 * encoding is either NULL or a encoding string such as provided by
 * the documents encoding. if encoding is NULL UTF8 is assumed.
 *
 */
xmlChar *
Sv2C( SV* scalar, const xmlChar *encoding );

SV*
nodeC2Sv( const xmlChar * string,  xmlNodePtr refnode );

xmlChar *
nodeSv2C( SV * scalar, xmlNodePtr refnode );

#endif
