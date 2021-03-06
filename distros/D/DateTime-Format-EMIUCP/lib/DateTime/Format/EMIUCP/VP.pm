package DateTime::Format::EMIUCP::VP;

=head1 NAME

DateTime::Format::EMIUCP::VP - Parse VP field for EMI-UCP protocol

=head1 SYNOPSIS

  use DateTime::Format::EMIUCP::VP;

  my $dt = DateTime::Format::EMIUCP::VP->parse_datetime('0302120655');
  print $dt->ymd; # 2012-02-03
  print $dt->hms; # 06:55:00

  $dt->set_formatter(DateTime::Format::EMIUCP::VP->new);
  print $dt; # 0302120655

=head1 DESCRIPTION

This format is a part of EMI-UCP protocol message. EMI-UCP protocol is
primarily used to connect to short message service centers (SMSCs) for mobile
telephones.

VP is a string of 10 numeric characters which represents validity period time
in ddMMyyHHmm format.

See EMI-UCP Interface 5.2 Specification for further explanations.

=cut

use 5.006;

use strict;
use warnings;

our $VERSION = '0.0300';

use DateTime::Format::EMIUCP;

=head1 METHODS

=over

=item DateTime I<$dt> = $fmt->parse_datetime(Str I<$scts>)

Given a string in the pattern specified in the constructor, this method will
return a new DateTime object.

Year number below 70 means the date before year 2000.

If given a string that doesn't match the pattern, the formatter will croak.

=cut

use DateTime::Format::Builder (
    parsers => {
        parse_datetime => [
            {
                params => [qw( day month year hour minute )],
                regex  => qr/^(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$/,
                postprocess => \&_fix_year,
            },
        ]
    }
);


BEGIN { *_fix_year = \&DateTime::Format::EMIUCP::_fix_year; }


=item Str I<$scts> = $fmt->format_datetime(DateTime I<$dt>)

Given a DateTime object, this methods returns a string formatted in the
object's format.

=back

=cut

sub format_datetime {
    my ($self, $dt) = @_;
    return sprintf '%02d%02d%02d%02d%02d',
        $dt->day, $dt->month, $dt->year % 100,
        $dt->hour, $dt->minute;
};


1;

__END__

=head1 PREREQUISITES

=over 2

=item *

L<DateTime::Format::Builder>

=back

=head1 SEE ALSO

L<DateTime::Format::EMIUCP>, L<DateTime>.

=head1 BUGS

If you find the bug or want to implement new features, please report it at
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTime-Format-EMIUCP>

The code repository is available at
L<http://github.com/dex4er/perl-DateTime-Format-EMIUCP>

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2012 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
