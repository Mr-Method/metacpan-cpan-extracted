# automatically generated file, don't edit



# Copyright 2011 David Cantrell, derived from data from libphonenumber
# http://code.google.com/p/libphonenumber/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package Number::Phone::StubCountry::MV;
use base qw(Number::Phone::StubCountry);

use strict;
use warnings;
use utf8;
our $VERSION = 1.20201204215957;

my $formatters = [
                {
                  'format' => '$1-$2',
                  'leading_digits' => '
            [3467]|
            9[13-9]
          ',
                  'pattern' => '(\\d{3})(\\d{4})'
                },
                {
                  'format' => '$1 $2 $3',
                  'leading_digits' => '[89]',
                  'pattern' => '(\\d{3})(\\d{3})(\\d{4})'
                }
              ];

my $validators = {
                'fixed_line' => '
          (?:
            3(?:
              0[0-3]|
              3[0-59]
            )|
            6(?:
              [57][02468]|
              6[024-68]|
              8[024689]
            )
          )\\d{4}
        ',
                'geographic' => '
          (?:
            3(?:
              0[0-3]|
              3[0-59]
            )|
            6(?:
              [57][02468]|
              6[024-68]|
              8[024689]
            )
          )\\d{4}
        ',
                'mobile' => '
          46[46]\\d{4}|
          (?:
            7\\d|
            9[13-9]
          )\\d{5}
        ',
                'pager' => '',
                'personal_number' => '',
                'specialrate' => '(900\\d{7})|(4[05]0\\d{4})',
                'toll_free' => '800\\d{7}',
                'voip' => ''
              };
my %areanames = ();
$areanames{en} = {"960670", "Vaavu",
"960680", "Laamu",
"960331", "Malé\/Hulhulé\/Aarah",
"960656", "Noonu",
"960301", "Malé\/Hulhulé\/Aarah",
"960668", "Alifu\ Dhaalu",
"960652", "Haa\ Dhaalu",
"960334", "Malé\/Hulhulé\/Aarah",
"960335", "Hulhumalé",
"960688", "Addu",
"960302", "Malé\ Region",
"960678", "Thaa",
"960654", "Shaviyani",
"960332", "Malé\/Hulhulé\/Aarah",
"960339", "Vilimalé",
"960660", "Baa",
"960674", "Faafu",
"960333", "Malé\/Hulhulé\/Aarah",
"960684", "Gaafu\ Dhaalu",
"960303", "Malé\ Region",
"960658", "Raa",
"960662", "Lhaviyani",
"960666", "Alifu\ Alifu",
"960330", "Malé\/Hulhulé\/Aarah",
"960300", "Malé\/Hulhulé\/Aarah",
"960686", "Gnaviyani",
"960689", "Addu",
"960676", "Dhaalu",
"960650", "Haa\ Alifu",
"960665", "Kaafu",
"960664", "Kaafu",
"960672", "Meemu",
"960682", "Gaafu\ Alifu",};

    sub new {
      my $class = shift;
      my $number = shift;
      $number =~ s/(^\+960|\D)//g;
      my $self = bless({ number => $number, formatters => $formatters, validators => $validators, areanames => \%areanames}, $class);
        return $self->is_valid() ? $self : undef;
    }
1;