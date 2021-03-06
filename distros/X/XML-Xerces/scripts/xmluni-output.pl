#!/usr/bin/perl -w
use XML::Xerces;

my @strings = qw(
fgAnyString
fgAttListString
fgCommentString
fgCDATAString
fgDefaultString
fgDocTypeString
fgEBCDICEncodingString
fgElemString
fgEmptyString
fgEncodingString
fgEntitString
fgEntityString
fgEntitiesString
fgEnumerationString
fgExceptDomain
fgFixedString
fgIBM037EncodingString
fgIBM037EncodingString2
fgIBM1140EncodingString
fgIBM1140EncodingString2
fgIBM1140EncodingString3
fgIBM1140EncodingString4
fgIESString
fgIDString
fgIDRefString
fgIDRefsString
fgImpliedString
fgIgnoreString
fgIncludeString
fgISO88591EncodingString
fgISO88591EncodingString2
fgISO88591EncodingString3
fgISO88591EncodingString4
fgISO88591EncodingString5
fgISO88591EncodingString6
fgISO88591EncodingString7
fgISO88591EncodingString8
fgISO88591EncodingString9
fgISO88591EncodingString10
fgISO88591EncodingString11
fgISO88591EncodingString12
fgLocalHostString
fgNoString
fgNotationString
fgNDATAString
fgNmTokenString
fgNmTokensString
fgPCDATAString
fgPIString
fgPubIDString
fgRefString
fgRequiredString
fgStandaloneString
fgVersion1_0
fgVersion1_1
fgSysIDString
fgUnknownURIName
fgUCS4EncodingString
fgUCS4EncodingString2
fgUCS4EncodingString3
fgUCS4BEncodingString
fgUCS4BEncodingString2
fgUCS4LEncodingString
fgUCS4LEncodingString2
fgUSASCIIEncodingString
fgUSASCIIEncodingString2
fgUSASCIIEncodingString3
fgUSASCIIEncodingString4
fgUTF8EncodingString
fgUTF8EncodingString2
fgUTF16EncodingString
fgUTF16EncodingString2
fgUTF16EncodingString3
fgUTF16EncodingString4
fgUTF16EncodingString5
fgUTF16BEncodingString
fgUTF16BEncodingString2
fgUTF16LEncodingString
fgUTF16LEncodingString2
fgVersionString
fgValidityDomain
fgWin1252EncodingString
fgXMLChEncodingString
fgXMLDOMMsgDomain
fgXMLString
fgXMLStringSpace
fgXMLStringHTab
fgXMLStringCR
fgXMLStringLF
fgXMLStringSpaceU
fgXMLStringHTabU
fgXMLStringCRU
fgXMLStringLFU
fgXMLDeclString
fgXMLDeclStringSpace
fgXMLDeclStringHTab
fgXMLDeclStringLF
fgXMLDeclStringCR
fgXMLDeclStringSpaceU
fgXMLDeclStringHTabU
fgXMLDeclStringLFU
fgXMLDeclStringCRU
fgXMLNSString
fgXMLNSColonString
fgXMLNSURIName
fgXMLErrDomain
fgXMLURIName
fgYesString
fgZeroLenString
fgDTDEntityString
fgAmp
fgLT
fgGT
fgQuot
fgApos
fgWFXMLScanner
fgIGXMLScanner
fgSGXMLScanner
fgDGXMLScanner
fgArrayIndexOutOfBoundsException_Name
fgEmptyStackException_Name
fgIllegalArgumentException_Name
fgInvalidCastException_Name
fgIOException_Name
fgNoSuchElementException_Name
fgNullPointerException_Name
fgXMLPlatformUtilsException_Name
fgRuntimeException_Name
fgTranscodingException_Name
fgUnexpectedEOFException_Name
fgUnsupportedEncodingException_Name
fgUTFDataFormatException_Name
fgNetAccessorException_Name
fgMalformedURLException_Name
fgNumberFormatException_Name
fgParseException_Name
fgInvalidDatatypeFacetException_Name
fgInvalidDatatypeValueException_Name
fgSchemaDateTimeException_Name
fgXPathException_Name
fgNegINFString
fgNegZeroString
fgPosZeroString
fgPosINFString
fgNaNString
fgEString
fgZeroString
fgNullString
fgXercesDynamic
fgXercesSchema
fgXercesSchemaFullChecking
fgXercesSchemaExternalSchemaLocation
fgXercesSchemaExternalNoNameSpaceSchemaLocation
fgXercesSecurityManager
fgXercesLoadExternalDTD
fgXercesContinueAfterFatalError
fgXercesValidationErrorAsFatal
fgXercesUserAdoptsDOMDocument
fgXercesCacheGrammarFromParse
fgXercesUseCachedGrammarInParse
fgXercesScannerName
fgXercesCalculateSrcOfs
fgXercesStandardUriConformant
fgSAX2CoreValidation
fgSAX2CoreNameSpaces
fgSAX2CoreNameSpacePrefixes
fgDOMCanonicalForm
fgDOMCDATASections
fgDOMComments
fgDOMCharsetOverridesXMLEncoding
fgDOMDatatypeNormalization
fgDOMEntities
fgDOMInfoset
fgDOMNamespaces
fgDOMNamespaceDeclarations
fgDOMSupportedMediatypesOnly
fgDOMValidateIfSchema
fgDOMValidation
fgDOMWhitespaceInElementContent
fgDOMWRTCanonicalForm
fgDOMWRTDiscardDefaultContent
fgDOMWRTEntities
fgDOMWRTFormatPrettyPrint
fgDOMWRTNormalizeCharacters
fgDOMWRTSplitCdataSections
fgDOMWRTValidation
fgDOMWRTWhitespaceInElementContent
fgDOMWRTBOM
fgXercescDefaultLocale
);

my $column = 50;
foreach my $string (@strings) {
  my $length = $column - length $string;
  my $space = ' ' x $length;
  my $var = "XML::Xerces::XMLUni::$string";
  printf STDERR "%s:%s%s\n", $string, $space, $$var;
}
