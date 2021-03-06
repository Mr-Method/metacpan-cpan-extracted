package MPMinus::Skel::Simple; # $Id: Simple.pm 281 2019-05-16 16:53:58Z minus $
use strict;
use utf8;

=encoding utf8

=head1 NAME

MPMinus::Skel::Simple - Internal helper's methods for MPMinus::Skel

=head1 VIRSION

Version 1.01

=head1 SYNOPSIS

none

=head1 DESCRIPTION

Internal helper's methods for MPMinus::Skel

no public methods

=head2 build, dirs, pool

Main methods. For internal use only

=head1 SEE ALSO

L<MPMinus::Skel>

=head1 AUTHOR

Serż Minus (Sergey Lepenkov) L<http://www.serzik.com> E<lt>abalama@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (C) 1998-2019 D&D Corporation. All Rights Reserved

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See C<LICENSE> file and L<https://dev.perl.org/licenses/>

=cut

use constant SIGNATURE => "simple";

use vars qw($VERSION);
$VERSION = '1.01';

sub build {
    my $self = shift;

    my $rplc = $self->{rplc};

    # DATA signature
    $rplc->{DATASIGN} = "__DATA__";

    # END signature
    $rplc->{ENDSIGN} = "__END__";

    $self->maybe::next::method();
    return 1;
}
sub dirs {
    my $self = shift;
    $self->{subdirs}{(SIGNATURE)} = [
        {
            path => 'lib/MPM/%PROJECT_NAME%',
            mode => 0755,
        },
        {
            path => 'src',
            mode => 0755,
        },
        {
            path => 't',
            mode => 0755,
        },
    ];
    $self->maybe::next::method();
    return 1;
}
sub pool {
    my $self = shift;
    my $pos =  tell DATA;
    my $data = scalar(do { local $/; <DATA> });
    seek DATA, $pos, 0;
    $self->{pools}{(SIGNATURE)} = $data;
    $self->maybe::next::method();
    return 1;
}

1;
__DATA__

-----BEGIN FILE-----
Name: %PROJECT_NAME%.pm
File: lib/MPM/%PROJECT_NAME%.pm
Mode: 644

package MPM::%PROJECT_NAME%; # %DOLLAR%Id%DOLLAR%

%PODSIG%head1 NAME

MPM::%PROJECT_NAME% - %PROJECT_NAME% project

%PODSIG%head1 VERSION

Version %PROJECT_VERSION%

%PODSIG%head1 SYNOPSIS

    use MPM::%PROJECT_NAME%;

%PODSIG%head1 DESCRIPTION

%PROJECT_NAME% project

%PODSIG%head1 HISTORY

%PODSIG%over 8

%PODSIG%item B<%PROJECT_VERSION% %GMT%>

Init version

%PODSIG%back

See C<Changes> file

%PODSIG%head1 SEE ALSO

L<MPMinus>

%PODSIG%head1 AUTHOR

%AUTHOR% E<lt>%SERVER_ADMIN%E<gt>

%PODSIG%head1 COPYRIGHT

Copyright (C) %YEAR% %AUTHOR%. All Rights Reserved

%PODSIG%head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See C<LICENSE> file and L<https://dev.perl.org/licenses/>

%PODSIG%cut

use vars qw($VERSION);
$VERSION = '%PROJECT_VERSION%';

1;

-----END FILE-----

-----BEGIN FILE-----
Name: Handlers.pm
File: lib/MPM/%PROJECT_NAME%/Handlers.pm
Mode: 644

package MPM::%PROJECT_NAME%::Handlers; # %DOLLAR%Id%DOLLAR%
use strict;

%PODSIG%head1 NAME

MPM::%PROJECT_NAME%::Handlers - MPMinus Init Handler of %PROJECT_NAME%

%PODSIG%head1 VERSION

Version %PROJECT_VERSION%

%PODSIG%head1 SYNOPSIS

    PerlInitHandler MPM::%PROJECT_NAME%::Handlers

%PODSIG%head1 DESCRIPTION

MPMinus %PROJECT_NAME% Init Handler

%PODSIG%head1 HISTORY

See C<Changes> file

%PODSIG%head1 SEE ALSO

L<MPMinus>

%PODSIG%head1 AUTHOR

%AUTHOR% E<lt>%SERVER_ADMIN%E<gt>

%PODSIG%head1 COPYRIGHT

Copyright (C) %YEAR% %AUTHOR%. All Rights Reserved

%PODSIG%head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See C<LICENSE> file and L<https://dev.perl.org/licenses/>

%PODSIG%cut

use MPMinus;

use base qw/MPMinus::BaseHandlers/;

use vars qw($VERSION);
$VERSION = '%PROJECT_VERSION%';

sub handler {
    my $r = shift;
    my $m = MPMinus->m;
    $m->conf_init($r, __PACKAGE__);
    __PACKAGE__->Init($m);

    # Handlers
    $r->handler('modperl'); # modperl, perl-script
    #$r->push_handlers(PerlHeaderParserHandler => sub { __PACKAGE__->HeaderParserHandler($m) });
    $r->push_handlers(PerlAccessHandler   => sub { __PACKAGE__->AccessHandler($m) });
    $r->push_handlers(PerlAuthenHandler   => sub { __PACKAGE__->AuthenHandler($m) });
    $r->push_handlers(PerlAuthzHandler    => sub { __PACKAGE__->AuthzHandler($m) });
    $r->push_handlers(PerlTypeHandler     => sub { __PACKAGE__->TypeHandler($m) });
    $r->push_handlers(PerlFixupHandler    => sub { __PACKAGE__->FixupHandler($m) });
    $r->push_handlers(PerlResponseHandler => sub { __PACKAGE__->ResponseHandler($m) });
    $r->push_handlers(PerlLogHandler      => sub { __PACKAGE__->LogHandler($m) });
    $r->push_handlers(PerlCleanupHandler  => sub { __PACKAGE__->CleanupHandler($m) });

    return __PACKAGE__->InitHandler($m);
}
sub InitHandler {
    my $pkg = shift;
    my $m = shift;

    # ... Setting general mpminus nodes ...
    # $m->set( nodename => ' ... value ... ' ) unless $m->nodename;

    return __PACKAGE__->SUPER::InitHandler($m);
}

1;

-----END FILE-----

-----BEGIN FILE-----
Name: Index.pm
File: lib/MPM/%PROJECT_NAME%/Index.pm
Mode: 644

package MPM::%PROJECT_NAME%::Index; # %DOLLAR%Id%DOLLAR%
use strict;

%PODSIG%head1 NAME

MPM::%PROJECT_NAME%::Index - Indexer of %PROJECT_NAME%

%PODSIG%head1 VERSION

Version %PROJECT_VERSION%

%PODSIG%head1 SYNOPSIS

    none

%PODSIG%head1 DESCRIPTION

This module defines list of connected modules to the project.

%PODSIG%head2 init

Initializer of the project modules

%PODSIG%head1 HISTORY

See C<Changes> file

%PODSIG%head1 SEE ALSO

L<MPMinus>

%PODSIG%head1 AUTHOR

%AUTHOR% E<lt>%SERVER_ADMIN%E<gt>

%PODSIG%head1 COPYRIGHT

Copyright (C) %YEAR% %AUTHOR%. All Rights Reserved

%PODSIG%head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See C<LICENSE> file and L<https://dev.perl.org/licenses/>

%PODSIG%cut

use vars qw($VERSION);
$VERSION = '%PROJECT_VERSION%';

use base qw/
    MPM::%PROJECT_NAME%::Root
    MPM::%PROJECT_NAME%::Info
/;

#
# THE NEXT TWO LINES ARE NOT FOR EDITING! PLEASE DO NOT TOUCH THIS PART OF THE FILE
#

our @ISA;
sub init { my $d = shift; foreach (@ISA) { $d->set($_->record) } }

1;

-----END FILE-----

-----BEGIN FILE-----
Name: Info.pm
File: lib/MPM/%PROJECT_NAME%/Info.pm
Mode: 644

package MPM::%PROJECT_NAME%::Info; # %DOLLAR%Id%DOLLAR%
use strict;
use utf8;

%PODSIG%head1 NAME

MPM::%PROJECT_NAME%::Info - Info controller (/mpminfo)

%PODSIG%head1 VERSION

Version %PROJECT_VERSION%

%PODSIG%head1 SYNOPSIS

    GET /mpminfo

%PODSIG%head1 DESCRIPTION

Info controller (/mpminfo)

%PODSIG%head1 HISTORY

See C<Changes> file

%PODSIG%head1 SEE ALSO

L<MPMinus>

%PODSIG%head1 AUTHOR

%AUTHOR% E<lt>%SERVER_ADMIN%E<gt>

%PODSIG%head1 COPYRIGHT

Copyright (C) %YEAR% %AUTHOR%. All Rights Reserved

%PODSIG%head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See C<LICENSE> file and L<https://dev.perl.org/licenses/>

%PODSIG%cut

use vars qw($VERSION);
$VERSION = '%PROJECT_VERSION%';

sub record {
    (
        -uri      => '/mpminfo',
        -response => sub { shift->mpminfo },
    )
}

1;

-----END FILE-----

-----BEGIN FILE-----
Name: Root.pm
File: lib/MPM/%PROJECT_NAME%/Root.pm
Mode: 644

package MPM::%PROJECT_NAME%::Root; # %DOLLAR%Id%DOLLAR%
use strict;
use utf8;

%PODSIG%head1 NAME

MPM::%PROJECT_NAME%::Root - Root controller (/)

%PODSIG%head1 VERSION

Version %PROJECT_VERSION%

%PODSIG%head1 SYNOPSIS

    GET /

%PODSIG%head1 DESCRIPTION

Root controller (/)

%PODSIG%head1 HISTORY

See C<Changes> file

%PODSIG%head1 SEE ALSO

L<MPMinus>

%PODSIG%head1 AUTHOR

%AUTHOR% E<lt>%SERVER_ADMIN%E<gt>

%PODSIG%head1 COPYRIGHT

Copyright (C) %YEAR% %AUTHOR%. All Rights Reserved

%PODSIG%head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See C<LICENSE> file and L<https://dev.perl.org/licenses/>

%PODSIG%cut

use vars qw($VERSION);
$VERSION = '%PROJECT_VERSION%';

use Encode;
use Apache2::Const;

use constant DEFAULT_CONTENT_TYPE => 'text/html; charset=utf-8';

sub record {
    (
        -uri      => '/',
        -type     => \&hType,
        -response => \&hResponse,
    )
}

sub hType {
    my $self = shift;
    my $r = $self->r;
    $r->content_type(DEFAULT_CONTENT_TYPE);
    return Apache2::Const::OK;
}
sub hResponse {
    my $self = shift;
    my $r = $self->r;

    my $pos =  tell DATA;
    my $data = scalar(do { local $/; <DATA> });
    seek DATA, $pos, 0;

    $r->set_content_length(length(Encode::encode_utf8($data)) || 0);
    $r->print($data);
    $r->rflush();

    return Apache2::Const::OK;
}

1;

%DATASIGN%
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Root of «%PROJECT_NAME%» | MPMinus v%PROJECT_VERSION%</title>
    <meta charset="utf-8" />
    <meta name="description" content="%PROJECT_NAME% - MPMinus v%PROJECT_VERSION% project" />
    <link rel="shortcut icon" href="favicon.ico" />
    <link href="css/main.css" rel="stylesheet" />
    <script src="js/main.js"></script>
</head>
<body>
<div class="box bg1 header">
    <a href="https://metacpan.org/release/MPMinus" title="MPMinus on meta::cpan"><img class="logo" alt="MPMinus Logo" src="img/logo.svg" /></a>
    <h1>MPMinus v%PROJECT_VERSION%</h1>
    <div class="subtitle">Root of «%PROJECT_NAME%»</div>
</div>
<p></p>
<h2>Welcome to simple MPMinus project!</h2>
<table>
    <tr>
        <td class="w">Information page</td>
        <td><a href="/mpminfo">/mpminfo</a></td>
    </tr>
    <tr>
        <td class="w">Apache Server Status <sup>*</sup></td>
        <td><a href="/server-status">/server-status</a></td>
    </tr>
    <tr>
        <td class="w">Apache Server Information <sup>*</sup></td>
        <td><a href="/server-info">/server-info</a></td>
    </tr>
    <tr>
        <td class="w">The mod_perl2 status <sup>*</sup></td>
        <td><a href="/perl-status">/perl-status</a></td>
    </tr>
    <tr>
        <td class="w">Documentation</td>
        <td><a href="https://metacpan.org/release/MPMinus" title="MPMinus on meta::cpan">https://metacpan.org/release/MPMinus</a></td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: right"><strong>*</strong> &mdash; please check status of mod_info, mod_status and Apache2::Status modules first</td>
    </tr>
</table>

<h2 id="LICENSE">LICENSE</h2>
<div class="box bg5 small">
    <p>
        This program is free software; you can redistribute it and/or
        modify it under the same terms as Perl itself.
    </p>
    <p>
        See <b>LICENSE</b> file and <a href="https://dev.perl.org/licenses/" title="LICENSE">https://dev.perl.org/licenses/</a>
    </p>
</div>
<p></p>
<div class="box bg1">
    <div class="footer">
        <small>Copyright &copy; %YEAR% %AUTHOR%. All Rights Reserved</small>
    </div>
</div>
</body>
</html>
-----END FILE-----

-----BEGIN FILE-----
Name: %PROJECT_NAMEL%.conf
File: src/%PROJECT_NAMEL%.conf
Mode: 644

#
# This file contains Your MPMinus configuration directives.
# For testing copy this file to Your document_root directory
# and restart Apache web server
#
#   cp ./%PROJECT_NAMEL%.conf %DOCUMENT_ROOT%/%PROJECT_NAMEL%.conf
#
# NOTE!!
# All directives MUST BE written in Apache-config style!
# See https://metacpan.org/pod/Config::General#-ApacheCompatible
#

TestStringParam1    Test # Any comments also can be and here
TestStringParam2    "Blah Blah Blah"
TestIntegerParam    123
TestFlag1           true
TestFlag2           on
TestFlag3           yes

<TestSectionFoo>
  Foo   yes
  Bar   no
  baz
</TestSectionFoo>

Include conf/*.conf

-----END FILE-----

-----BEGIN FILE-----
Name: %SERVER_NAME%.apache24.conf
File: src/%SERVER_NAME%.apache24.conf
Mode: 644

#PerlSwitches -I[MODPERL_ROOT_UNIX]/lib
PerlModule MPM::%PROJECT_NAME%::Handlers
<VirtualHost *:80>
    ServerName %SERVER_NAME%

    ServerAdmin %SERVER_ADMIN%

    DocumentRoot "[DOCUMENT_ROOT_UNIX]"
    <Directory "[DOCUMENT_ROOT_UNIX]">
        Options FollowSymLinks ExecCGI
        DirectoryIndex disabled
        AllowOverride All
        Require all granted
    </Directory>

    AddDefaultCharset utf-8

    PerlOptions +GlobalRequest

    # MPMinus Configuration
    #PerlSetVar ModperlRoot "[MODPERL_ROOT_UNIX]"
    #PerlSetVar Config "[MODPERL_ROOT_UNIX]/%PROJECT_NAMEL%.conf"
    #PerlSetVar ConfDir "[MODPERL_ROOT_UNIX]/conf"
    #PerlSetVar Debug off

    # Handlers
    <LocationMatch "^(/|/mpminfo)%DOLLAR%">
        PerlInitHandler MPM::%PROJECT_NAME%::Handlers
    </LocationMatch>

    # Logging
    LogLevel perl:debug
    ErrorLog [APACHE_LOG_DIR]/%SERVER_NAME%-error_log
    CustomLog [APACHE_LOG_DIR]/%SERVER_NAME%-access_log common

</VirtualHost>
-----END FILE-----

-----BEGIN FILE-----
Name: %SERVER_NAME%.apache22.conf
File: src/%SERVER_NAME%.apache22.conf
Mode: 644

#PerlSwitches -I[MODPERL_ROOT_UNIX]/lib
PerlModule MPM::%PROJECT_NAME%::Handlers
<VirtualHost *:80>
    ServerName %SERVER_NAME%

    ServerAdmin %SERVER_ADMIN%

    DocumentRoot "[DOCUMENT_ROOT_UNIX]"
    <Directory "[DOCUMENT_ROOT_UNIX]">
        Options Indexes FollowSymLinks ExecCGI
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

    AddDefaultCharset utf-8

    PerlOptions +GlobalRequest

    # MPMinus Configuration
    #PerlSetVar ModperlRoot "[MODPERL_ROOT_UNIX]"
    #PerlSetVar Config "[MODPERL_ROOT_UNIX]/%PROJECT_NAMEL%.conf"
    #PerlSetVar ConfDir "[MODPERL_ROOT_UNIX]/conf"
    #PerlSetVar Debug off

    # Handlers
    <LocationMatch "^(/|/mpminfo)%DOLLAR%">
        PerlInitHandler MPM::%PROJECT_NAME%::Handlers
    </LocationMatch>

    # Logging
    LogLevel debug
    ErrorLog logs/%SERVER_NAME%-error_log
    CustomLog logs/%SERVER_NAME%-access_log common

</VirtualHost>
-----END FILE-----

-----BEGIN FILE-----
Name: 01-use.t
File: t/01-use.t
Mode: 644

#!/usr/bin/perl -w
#########################################################################
#
# %AUTHOR%, <%SERVER_ADMIN%>
#
# Copyright (C) %YEAR% %AUTHOR%. All Rights Reserved
#
# This is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.
#
# %DOLLAR%Id%DOLLAR%
#
#########################################################################
use Test::More tests => 2;
BEGIN { use_ok('MPM::%PROJECT_NAME%'); };
ok(MPM::%PROJECT_NAME%->VERSION,'Version checking');
1;

-----END FILE-----

-----BEGIN FILE-----
Name: MANIFEST
File: MANIFEST
Mode: 644

# Generated by %AUTHOR% %GMT%
# %DOLLAR%Id%DOLLAR%

# Common files
Changes                 Changes list
INSTALL                 Install file
LICENSE                 License file
Makefile.PL             Makefile builder
MANIFEST                This file
README                  !!! READ ME FIRST !!!
TODO                    TO DO list

# Libraries
lib/MPM/%PROJECT_NAME%.pm
lib/MPM/%PROJECT_NAME%/Handlers.pm
lib/MPM/%PROJECT_NAME%/Index.pm
lib/MPM/%PROJECT_NAME%/Root.pm
lib/MPM/%PROJECT_NAME%/Info.pm

# Includes
inc/MY.pm               MakeMaker MY package

# Tests
t/01-use.t              Test script

# Sources
src/favicon.ico         Favicon
src/robots.txt          Robot's file
src/index.html          Default file
src/META.yml            META file after creating
src/%PROJECT_NAMEL%.conf
src/%SERVER_NAME%.apache22.conf
src/%SERVER_NAME%.apache24.conf

# Miscellaneous content
conf/README             README
css/main.css            CSS file
img/logo.svg            Logo
inc/README              README
js/main.js              JS file

-----END FILE-----

-----BEGIN FILE-----
Name: Makefile.PL
File: Makefile.PL
Mode: 711

#!/usr/bin/perl -w
use strict; # %DOLLAR%Id%DOLLAR%
use lib qw/inc/;

use ExtUtils::MakeMaker;
use MPMinus::Helper::Util qw/load_metadata getApache back2slash/;
use File::Spec;
use CTK ();
use CTK::Util ();

use MY;

use constant {
        METAFILE        => 'META.yml',
        DOCUMENT_ROOT   => '%DOCUMENT_ROOT%',
        MODPERL_ROOT    => '%MODPERL_ROOT%',
        SERVER_NAME     => '%SERVER_NAME%',
        PROJECT_NAME    => '%PROJECT_NAME%',
        PROJECT_NAMEL   => '%PROJECT_NAMEL%',
        PROJECT_VERSION => '%PROJECT_VERSION%',
        PROJECT_TYPE    => '%PROJECT_TYPE%',
        AUTHOR          => '%AUTHOR%',
        SERVER_ADMIN    => '%SERVER_ADMIN%',
    };

# Set up MPMINUS_* variables and remove from @ARGV
# MPMINUS_FORCE         -- Enable force mode
# MPMINUS_DOCUMENT_ROOT -- Projcect DOCUMENT_ROOT, destination directory
@ARGV = grep defined, map { (/^(MPMINUS_[A-Z0-9_]+)=(.*)/ && ($ENV{$1} = $2)) ? undef : $_ } @ARGV;

# Requirements
my $prereq_pm = {
        'MPMinus'       => 1.21,
    };

# Macro
my $macro = {
        # Main constants
        PROJECT_NAME    => PROJECT_NAME,
        PROJECT_NAMEL   => PROJECT_NAMEL,
        PROJECT_VERSION => PROJECT_VERSION,
        PROJECT_TYPE    => PROJECT_TYPE,
        SERVER_NAME     => SERVER_NAME,
        DOCUMENT_ROOT   => DOCUMENT_ROOT,
        MODPERL_ROOT    => MODPERL_ROOT,
        AUTHOR          => AUTHOR,
        SERVER_ADMIN    => SERVER_ADMIN,

        # MM constant
        PERM_DIR_X      => 755,
        APACHE_SIGN     => getApache("APACHE_SIGN"),
        APACHE_LOG_DIR  => getApache("APACHE_LOG_DIR"),

        # Dirs
        INST_WWW        => 'build',
    };

# Set document root
if ($ENV{MPMINUS_FORCE}) {
    my $document_root = $ENV{MPMINUS_DOCUMENT_ROOT} // DOCUMENT_ROOT;
    die(sprintf("Aborted! Directory \"%s\" already exists!", $document_root)) if -e $document_root;
    $macro->{DOCUMENT_ROOT} = $macro->{MODPERL_ROOT} = $document_root;
} else {
    set_document_root($ENV{MPMINUS_DOCUMENT_ROOT});
}

# Create DOCUMENT_ROOT_UNIX and MODPERL_ROOT_UNIX
foreach my $key (qw/DOCUMENT_ROOT MODPERL_ROOT/) {
    $macro->{sprintf("%s_UNIX", $key)} = back2slash($macro->{$key});
}

printf("Document Root directory: %s\n\n", $macro->{DOCUMENT_ROOT});

WriteMakefile(
    'NAME'                  => sprintf('MPM::%s', PROJECT_NAME),
    'MIN_PERL_VERSION'      => 5.016001,
    'VERSION_FROM'          => sprintf('lib/MPM/%s.pm', PROJECT_NAME),
    'ABSTRACT_FROM'         => sprintf('lib/MPM/%s.pm', PROJECT_NAME),
    'PREREQ_PM'             => $prereq_pm,
    'AUTHOR'                => sprintf('%s <%s>', AUTHOR, SERVER_ADMIN),
    'LICENSE'               => 'perl',
    'META_MERGE' => { "meta-spec" => { version => 2 },
        macro => $macro,
        resources => {
            mpminus         => 'https://metacpan.org/release/MPMinus',
            license         => 'https://dev.perl.org/licenses/',
        },
    },
    macro => $macro,
    clean => {
        FILES => '$(INST_WWW) *.tmp',
    },
);

sub set_document_root {
    my $dr = shift;

    my $c = new CTK(plugins => "cli");
    my %meta = load_metadata( File::Spec->catfile("src", METAFILE) );

    # DocumentRoot and ModperlRoot
    my $server_name = $meta{SERVER_NAME} || SERVER_NAME;
    my $document_root = $meta{DOCUMENT_ROOT} || DOCUMENT_ROOT;
    my $modperl_root = $meta{MODPERL_ROOT} || MODPERL_ROOT;
    my $document_root_calc = File::Spec->catdir(CTK::Util::webdir(), $server_name);
    my @mpvs = ();
    push @mpvs, $dr if defined($dr) && length($dr);
    push @mpvs, $document_root_calc;
    push @mpvs, $document_root if ($document_root ne $document_root_calc);
    push @mpvs, $modperl_root if ($document_root ne $modperl_root);
    print "You need to specify the destination directory (Document Root)\n";
    print "Select one item or specify the path manually:\n";
    my $i = 0;
    foreach my $v (@mpvs) {$i++;
        printf "  %d) %s\n", $i, $v;
    }
    $document_root = $c->cli_prompt('Root directory:', $mpvs[0]);
    if ($document_root && $document_root =~ /^\d/ ) {
        my $i = 0;
        foreach my $v (@mpvs) {$i++;
            if ($document_root eq "$i") {
                $document_root = $v;
                last;
            }
        }
    }
    $macro->{DOCUMENT_ROOT} = $macro->{MODPERL_ROOT} = $document_root;
    if ((-e $document_root)
        && $c->cli_prompt("Directory \"$document_root\" already exists! Are you sure you want to continue?:","no") !~ /^\s*y/i
      ) {
        die("Operation aborted");
    }
}

1;

%ENDSIGN%
-----END FILE-----

-----BEGIN FILE-----
Name: MY.pm
File: inc/MY.pm
Mode: 644

package MY;
use CTK::Util;

sub postamble {
my $section = <<'MAKE_FRAG';

CRLF = $(ABSPERLRUNINST) -MMPMinus::Helper::Command -e crlf --
RPLC = $(ABSPERLRUNINST) -MMPMinus::Helper::Command -e replace --
MY_INSTALL = $(ABSPERLRUNINST) -MMPMinus::Helper::Command -e install --

pure_all :: configured.tmp
[TAB]$(NOECHO) $(ECHO) "Configured."

# General config files
configured.tmp : $(INST_WWW)$(DFSEP).exists \
  src$(DFSEP)$(PROJECT_NAMEL).conf \
  $(INST_WWW)$(DFSEP)src$(DFSEP)$(SERVER_NAME).conf \
  apache$(APACHE_SIGN).tmp
[TAB]$(CP) src$(DFSEP)$(PROJECT_NAMEL).conf $(INST_WWW)$(DFSEP)$(PROJECT_NAMEL).conf
[TAB]-$(CP) conf$(DFSEP)* $(INST_WWW)$(DFSEP)conf
[TAB]-$(CP) css$(DFSEP)* $(INST_WWW)$(DFSEP)css
[TAB]-$(CP) img$(DFSEP)* $(INST_WWW)$(DFSEP)img
[TAB]-$(CP) js$(DFSEP)* $(INST_WWW)$(DFSEP)js
[TAB]$(CP) src$(DFSEP)favicon.ico $(INST_WWW)
[TAB]$(CP) src$(DFSEP)index.html $(INST_WWW)
[TAB]$(CP) src$(DFSEP)robots.txt $(INST_WWW)
[TAB]-$(CP) $(INST_WWW)$(DFSEP)src$(DFSEP).htaccess $(INST_WWW)$(DFSEP)conf$(DFSEP).htaccess
[TAB]-$(CP) $(INST_WWW)$(DFSEP)src$(DFSEP).htaccess $(INST_WWW)$(DFSEP)templates$(DFSEP).htaccess
[TAB]$(CRLF) $(INST_WWW)
[TAB]$(NOECHO) $(TOUCH) configured.tmp

# Creating directories
$(INST_WWW)$(DFSEP).exists :: Makefile.PL
[TAB]$(MKPATH) $(INST_WWW)
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)
[TAB]$(NOECHO) $(MKPATH) $(INST_WWW)$(DFSEP)conf
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)$(DFSEP)conf
[TAB]$(NOECHO) $(MKPATH) $(INST_WWW)$(DFSEP)css
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)$(DFSEP)css
[TAB]$(NOECHO) $(MKPATH) $(INST_WWW)$(DFSEP)img
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)$(DFSEP)img
[TAB]$(NOECHO) $(MKPATH) $(INST_WWW)$(DFSEP)js
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)$(DFSEP)js
[TAB]$(NOECHO) $(MKPATH) $(INST_WWW)$(DFSEP)src
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)$(DFSEP)src
[TAB]$(NOECHO) $(MKPATH) $(INST_WWW)$(DFSEP)templates
[TAB]$(NOECHO) $(CHMOD) $(PERM_DIR_X) $(INST_WWW)$(DFSEP)templates
[TAB]$(NOECHO) $(TOUCH) $(INST_WWW)$(DFSEP).exists

# Apache config include
$(INST_WWW)$(DFSEP)src$(DFSEP)$(SERVER_NAME).conf : src$(DFSEP)$(SERVER_NAME).apache$(APACHE_SIGN).conf
[TAB]$(CP) src$(DFSEP)$(SERVER_NAME).apache$(APACHE_SIGN).conf $(INST_WWW)$(DFSEP)src$(DFSEP)$(SERVER_NAME).conf
[TAB]$(RPLC) $(INST_WWW)$(DFSEP)src$(DFSEP)$(SERVER_NAME).conf

# Apache files
apache.tmp :
[TAB]$(NOECHO) $(TOUCH) apache.tmp

apache22.tmp :
[TAB]$(NOECHO) $(ECHO) "Order allow,deny" > $(INST_WWW)$(DFSEP)src$(DFSEP).htaccess
[TAB]$(NOECHO) $(ECHO) "Deny from all" >> $(INST_WWW)$(DFSEP)src$(DFSEP).htaccess
[TAB]$(NOECHO) $(TOUCH) apache22.tmp

apache24.tmp :
[TAB]$(NOECHO) $(ECHO) "Require all denied" > $(INST_WWW)$(DFSEP)src$(DFSEP).htaccess
[TAB]$(NOECHO) $(TOUCH) apache24.tmp

install :: installed.tmp
[TAB]$(NOECHO) $(ECHO) "Installed."
[TAB]$(NOECHO) $(ECHO) "!!!!!!!!!!!!!!!!!!!!!!!!!! Congratulations! !!!!!!!!!!!!!!!!!!!!!!!!!!"
[TAB]$(NOECHO) $(ECHO) "!!"
[TAB]$(NOECHO) $(ECHO) "!! Your project successfully installed to destination directory"
[TAB]$(NOECHO) $(ECHO) "!!"
[TAB]$(NOECHO) $(ECHO) "!!   $(DOCUMENT_ROOT)"
[TAB]$(NOECHO) $(ECHO) "!!"
[TAB]$(NOECHO) $(ECHO) "!! Before start, make sure to correctly configure Your Apache server."
[TAB]$(NOECHO) $(ECHO) "!! Sample configuration files are located in src directory of Your"
[TAB]$(NOECHO) $(ECHO) "!! projcet. Copy this file to Apache conf directory and restart it"
[TAB]$(NOECHO) $(ECHO) "!!"
[TAB]$(NOECHO) $(ECHO) "!!   apachectl restart"
[TAB]$(NOECHO) $(ECHO) "!!"
[TAB]$(NOECHO) $(ECHO) "!! Thank You for using our project,"
[TAB]$(NOECHO) $(ECHO) "!! developers MPMinus"
[TAB]$(NOECHO) $(ECHO) "!!"
[TAB]$(NOECHO) $(ECHO) "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

installed.tmp : configured.tmp
[TAB]$(MY_INSTALL) $(INST_WWW)
[TAB]$(NOECHO) $(TOUCH) installed.tmp

MAKE_FRAG

return CTK::Util::dformat($section, {
        TAB => "\t",
    });
}

1;

%ENDSIGN%
-----END FILE-----
