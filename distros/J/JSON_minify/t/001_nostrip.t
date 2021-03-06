#!/usr/bin/perl
##
## json-minify.pl
## Copyright ©2018 Rémi Cohen-Scali
##
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the “Software”), to 
## deal in the Software without restriction, including without limitation the 
## rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
## sell copies of the Software, and to permit persons to whom the Software is 
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
## FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
## IN THE SOFTWARE.
## 

use 5.008;

use strict;
use warnings;

no warnings 'syntax';

BEGIN{
    our $r = eval "use Test::NoWarnings; 1" || 0;
}

use Test;

plan tests => 5;
    
use JSON_minify;

##
## Test input strings
##
my $in_str1 = "{\n    // COMMENT\n    \"key1\": /* COMMENT */ \"value1\",\n    \"key2\": 4, /*COMMENT*/\n    \"key3\": false,\n    /* COMMENT\n     * COMMENT\n     * COMMENT */\n    \"key4\": /*\n    COMMENT\n */ [\n        \"str1\", \"str2\", \"str3\"\n    ],\n    \"key5\" : // COMMENT\n    {\n        \"key51\": \"test \",\n        \"key52\": \"test /* */ test \"\n    }\n}\n";
my $in_str2 = "\n			// this is a JSON file with comments\n			{\n				\"foo\": \"bar\",	// this is cool\n				\"bar\": [\n					\"baz\", \"bum\", \"zam\"\n				],\n			/* the rest of this document is just fluff\n			   in case you are interested. */\n				\"something\": 10,\n				\"else\": 20\n			}\n			\n			/* NOTE: You can easily strip the whitespace and comments\n			   from such a file with the JSON.minify() project hosted\n			   here on github at http://github.com/getify/JSON.minify\n    */\n";
my $in_str3 = "    \n    {\"/*\":\"*/\",\"//\":\"\",/*\"//\"*/\"/*/\"://\n    \"//\"}\n    \n";
my $in_str4 = "    /*\n    this is a\n    multi line comment */{\n    \n    \"foo\"\n    :\n    \"bar/*\"// something\n    ,	\"b\\\"az\":/*\n    something else */\"blah\"\n    \n}\n";
my $in_str5 = "{\"foo\": \"ba\\\"r//\", \"bar\\\\\": \"b\\\\\\\"a/*z\",\n    \"baz\\\\\\\\\": /* yay */ \"fo\\\\\\\\\\\"*/o\"\n}\n";

##
## Test output strings
##
my $out_str1 = "{\n           \n\"key1\":               \"value1\",\n\"key2\":4,           \n\"key3\":false,\n           \n\n                    \n\n                        \n\"key4\":  \n\n               \n\n    [\n\"str1\",\"str2\",\"str3\"\n],\n\"key5\":           \n{\n\"key51\":\"test \",\n\"key52\":\"test /* */ test \"\n}\n}\n";
my $out_str2 = "\n                                           \n{\n\"foo\":\"bar\",                  \n\"bar\":[\n\"baz\",\"bum\",\"zam\"\n],\n                                                  \n\n	 	 	                                          \n\"something\":10,\n\"else\":20\n}\n\n                                                                  \n\n	 	 	                                                                     \n\n	 	 	                                                                 \n\n          \n";
my $out_str3 = "\n{\"/*\":\"*/\",\"//\":\"\",        \"/*/\":  \n\"//\"}\n\n";
my $out_str4 = "  \n\n                   \n\n                                {\n\n\"foo\"\n:\n\"bar/*\"             \n,\"b\\\"az\":  \n\n                           \"blah\"\n\n}\n";
my $out_str5 = "{\"foo\":\"ba\\\"r//\",\"bar\\\\\":\"b\\\\\\\"a/*z\",\n\"baz\\\\\\\\\":           \"fo\\\\\\\\\\\"*/o\"\n}\n";

##
## Ok let's instantiate the minifier
##
my $minifier = JSON_minify->new();

##
## Test 1
##
my $ret_str1 = $minifier->minify_string($in_str1, 0);
ok ($out_str1 eq $ret_str1);
print "'$out_str1'\n";

##
## Test 2
##
my $ret_str2 = $minifier->minify_string($in_str2, 0);
ok ($out_str2 eq $ret_str2);
print "'$out_str1'\n";

##
## Test 3
##
my $ret_str3 = $minifier->minify_string($in_str3, 0);
ok ($out_str3 eq $ret_str3);
print "'$out_str1'\n";

##
## Test 4
##
my $ret_str4 = $minifier->minify_string($in_str4, 0);
ok ($out_str4 eq $ret_str4);
print "'$out_str1'\n";

##
## Test 5
##
my $ret_str5 = $minifier->minify_string($in_str5, 0);
ok ($out_str5 eq $ret_str5);
print "'$out_str1'\n";

__END__
