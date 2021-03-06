package Sah::SchemaR::date::dow_name::id;

our $DATE = '2020-03-08'; # DATE
our $VERSION = '0.005'; # VERSION

our $rschema = ["cistr",[{examples=>[{valid=>0,value=>""},{valid=>1,value=>"mg"},{valid=>1,value=>"min"},{valid=>1,value=>"minggu"},{summary=>"English",valid=>0,value=>"sun"},{valid=>0,value=>1}],in=>["mg","sn","sl","rb","km","jm","sb","min","sen","sel","rab","kam","jum","sab","minggu","senin","selasa","rabu","kamis","jumat","sabtu"],summary=>"Day-of-week name (abbreviated or full, in Indonesian)"}],["cistr"]];

1;
# ABSTRACT: Day-of-week name (abbreviated or full, in Indonesian)

__END__

=pod

=encoding UTF-8

=head1 NAME

Sah::SchemaR::date::dow_name::id - Day-of-week name (abbreviated or full, in Indonesian)

=head1 VERSION

This document describes version 0.005 of Sah::SchemaR::date::dow_name::id (from Perl distribution Sah-Schemas-Date-ID), released on 2020-03-08.

=head1 DESCRIPTION

This module is automatically generated by Dist::Zilla::Plugin::Sah::Schemas during distribution build.

A Sah::SchemaR::* module is useful if a client wants to quickly lookup the base type of a schema without having to do any extra resolving. With Sah::Schema::*, one might need to do several lookups if a schema is based on another schema, and so on. Compare for example L<Sah::Schema::poseven> vs L<Sah::SchemaR::poseven>, where in Sah::SchemaR::poseven one can immediately get that the base type is C<int>. Currently L<Perinci::Sub::Complete> uses Sah::SchemaR::* instead of Sah::Schema::* for reduced startup overhead when doing tab completion.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Sah-Schemas-Date-ID>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Sah-Schemas-Date-ID>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Sah-Schemas-Date-ID>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020, 2019 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
