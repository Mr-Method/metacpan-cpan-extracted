/*
 * Generated by asn1c-0.9.23 (http://lionet.info/asn1c)
 * From ASN.1 module "MAP-MS-DataTypes"
 * 	found in "../asn1src/MAP-MS-DataTypes.asn"
 * 	`asn1c -gen-PER -fskeletons-copy -fnative-types`
 */

#include "AnyTimeSubscriptionInterrogationArg.h"

static asn_TYPE_member_t asn_MBR_AnyTimeSubscriptionInterrogationArg_1[] = {
	{ ATF_NOFLAGS, 0, offsetof(struct AnyTimeSubscriptionInterrogationArg, subscriberIdentity),
		(ASN_TAG_CLASS_CONTEXT | (0 << 2)),
		+1,	/* EXPLICIT tag at current level */
		&asn_DEF_SubscriberIdentity,
		0,	/* Defer constraints checking to the member type */
		0,	/* No PER visible constraints */
		0,
		"subscriberIdentity"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct AnyTimeSubscriptionInterrogationArg, requestedSubscriptionInfo),
		(ASN_TAG_CLASS_CONTEXT | (1 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_RequestedSubscriptionInfo,
		0,	/* Defer constraints checking to the member type */
		0,	/* No PER visible constraints */
		0,
		"requestedSubscriptionInfo"
		},
	{ ATF_NOFLAGS, 0, offsetof(struct AnyTimeSubscriptionInterrogationArg, gsmSCF_Address),
		(ASN_TAG_CLASS_CONTEXT | (2 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_ISDN_AddressString,
		0,	/* Defer constraints checking to the member type */
		0,	/* No PER visible constraints */
		0,
		"gsmSCF-Address"
		},
	{ ATF_POINTER, 2, offsetof(struct AnyTimeSubscriptionInterrogationArg, extensionContainer),
		(ASN_TAG_CLASS_CONTEXT | (3 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_ExtensionContainer,
		0,	/* Defer constraints checking to the member type */
		0,	/* No PER visible constraints */
		0,
		"extensionContainer"
		},
	{ ATF_POINTER, 1, offsetof(struct AnyTimeSubscriptionInterrogationArg, longFTN_Supported),
		(ASN_TAG_CLASS_CONTEXT | (4 << 2)),
		-1,	/* IMPLICIT tag at current level */
		&asn_DEF_NULL,
		0,	/* Defer constraints checking to the member type */
		0,	/* No PER visible constraints */
		0,
		"longFTN-Supported"
		},
};
static int asn_MAP_AnyTimeSubscriptionInterrogationArg_oms_1[] = { 3, 4 };
static ber_tlv_tag_t asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1[] = {
	(ASN_TAG_CLASS_UNIVERSAL | (16 << 2))
};
static asn_TYPE_tag2member_t asn_MAP_AnyTimeSubscriptionInterrogationArg_tag2el_1[] = {
    { (ASN_TAG_CLASS_CONTEXT | (0 << 2)), 0, 0, 0 }, /* subscriberIdentity at 2812 */
    { (ASN_TAG_CLASS_CONTEXT | (1 << 2)), 1, 0, 0 }, /* requestedSubscriptionInfo at 2813 */
    { (ASN_TAG_CLASS_CONTEXT | (2 << 2)), 2, 0, 0 }, /* gsmSCF-Address at 2814 */
    { (ASN_TAG_CLASS_CONTEXT | (3 << 2)), 3, 0, 0 }, /* extensionContainer at 2815 */
    { (ASN_TAG_CLASS_CONTEXT | (4 << 2)), 4, 0, 0 } /* longFTN-Supported at 2816 */
};
static asn_SEQUENCE_specifics_t asn_SPC_AnyTimeSubscriptionInterrogationArg_specs_1 = {
	sizeof(struct AnyTimeSubscriptionInterrogationArg),
	offsetof(struct AnyTimeSubscriptionInterrogationArg, _asn_ctx),
	asn_MAP_AnyTimeSubscriptionInterrogationArg_tag2el_1,
	5,	/* Count of tags in the map */
	asn_MAP_AnyTimeSubscriptionInterrogationArg_oms_1,	/* Optional members */
	2, 0,	/* Root/Additions */
	4,	/* Start extensions */
	6	/* Stop extensions */
};
asn_TYPE_descriptor_t asn_DEF_AnyTimeSubscriptionInterrogationArg = {
	"AnyTimeSubscriptionInterrogationArg",
	"AnyTimeSubscriptionInterrogationArg",
	SEQUENCE_free,
	SEQUENCE_print,
	SEQUENCE_constraint,
	SEQUENCE_decode_ber,
	SEQUENCE_encode_der,
	SEQUENCE_decode_xer,
	SEQUENCE_encode_xer,
	SEQUENCE_decode_uper,
	SEQUENCE_encode_uper,
	0,	/* Use generic outmost tag fetcher */
	asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1,
	sizeof(asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1)
		/sizeof(asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1[0]), /* 1 */
	asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1,	/* Same as above */
	sizeof(asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1)
		/sizeof(asn_DEF_AnyTimeSubscriptionInterrogationArg_tags_1[0]), /* 1 */
	0,	/* No PER visible constraints */
	asn_MBR_AnyTimeSubscriptionInterrogationArg_1,
	5,	/* Elements count */
	&asn_SPC_AnyTimeSubscriptionInterrogationArg_specs_1	/* Additional specs */
};

