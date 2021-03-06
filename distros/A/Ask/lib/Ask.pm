use 5.008008;
use strict;
use warnings;

package Ask;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.015';

use Carp qw(croak);
use Moo::Role qw();
use Module::Runtime qw(use_module use_package_optimistically);
use Module::Pluggable (
	search_path => 'Ask',
	except      => [qw/ Ask::API Ask::Functions Ask::Question /],
	inner       => 0,
	require     => 0,
	sub_name    => '__plugins',
);
use namespace::autoclean;

sub import {
	shift;
	if ( @_ ) {
		require Ask::Functions;
		unshift @_, 'Ask::Functions';
		goto( $_[0]->can( 'import' ) );
	}
}

sub plugins {
	__plugins( @_ );
}

sub backends {
	my $class = shift;
	sort { $b->quality <=> $a->quality }
		grep {
		eval { use_package_optimistically( $_ )->DOES( 'Ask::API' ) }
		} $class->plugins;
}

sub detect {
	my $class = shift;
	my %args  = @_ == 1 ? %{ $_[0] } : @_;
	
	my @implementations = $class->backends;
	
	if ( exists $ENV{PERL_ASK_BACKEND} ) {
		@implementations = use_module( $ENV{PERL_ASK_BACKEND} );
	}
	elsif ( $ENV{AUTOMATED_TESTING}
		or $ENV{PERL_MM_USE_DEFAULT}
		or not @implementations )
	{
		@implementations = use_module( 'Ask::Fallback' );
	}
	
	my @traits = @{ delete( $args{traits} ) || [] };
	for my $i ( @implementations ) {
		my $k    = @traits ? "Moo::Role"->create_class_with_roles( $i, @traits ) : $i;
		my $self = eval { $k->new( { %args, %{ $args{$i} or {} } } ) } or next;
		return $self if $self->is_usable;
	}
	
	croak "No usable backend for Ask";
} #/ sub detect

sub Q {
	require Ask::Question;
	'Ask::Question'->new( @_ );
}

my $instance;
sub instance {
	shift;
	@_ ? ( $instance = $_[0] ) : ( $instance ||= __PACKAGE__->detect );
}

1;

__END__

=head1 NAME

Ask - ask your users about stuff

=head1 SYNOPSIS

Object-oriented style:

   use Ask;
   
   my $ask = Ask->detect;
   
   if ($ask->question(text => "Are you happy?")
   and $ask->question(text => "Do you know it?")
   and $ask->question(text => "Really want to show it?")) {
      $ask->info(text => "Then clap your hands!");
   }

Functional style:

   use Ask ':all';
   
   if (question("Are you happy?")
   and question("Do you know it?")
   and question("Really want to show it?")) {
      info("Then clap your hands!");
   }

=head1 DESCRIPTION

The C<Ask> suite is a set of modules for interacting with users; prompting
them for information, displaying messages, warnings and errors, etc.

There are already countless CPAN modules for doing this sort of thing, but
what sets C<Ask> apart from them is that C<Ask> will detect how your script
is being run (in a terminal, headless, etc) and choose an appropriate way
to interact with the user.

=head2 Class Methods

=over

=item C<< Ask->instance >>

Singleton pattern. Can also be passed an argument to use it as a setter.

=item C<< Ask->detect(%arguments) >>

A constructor, sort of. It inspects the program's environment and returns an
object that implements the Ask API (see below).

Backend-specific arguments can be provided:

  my $ask = Ask->detect(
    %common_args,
    'Ask::STDIO'  => \%stdio_args,
    'Ask::Zenity' => \%zenity_args,
  );

Note that these objects don't usually inherit from C<Ask>, so the following
will typically be false:

   my $ask = Ask->detect(%arguments);
   $ask->isa("Ask");

Instead, check:

   my $ask = Ask->detect(%arguments);
   $ask->DOES("Ask::API");

=item C<< Ask->backends >>

Returns a list of available backends. Each backend is a Perl class name. Some
of the backends may be available (i.e. installed and able to be compiled)
without being usable under current circumstances (e.g. the Gtk2 backend is
available but cannot be used because no X server is running). To check
usability, instantiate the class and call C<is_usable> on the instance.

The list is sorted in "quality" order, best to worst, though quality is
subjective.

=item C<< Ask->plugins >>

The same as C<< Ask->backends >>, but doesn't check that each result is a
loadable Perl class, and doesn't sort them in any particular order.

=back

=head2 The Ask API

Objects returned by the C<detect> method implement the Ask API. This
section documents that API.

The following methods are provided by objects implementing the Ask
API. They are largely modeled on the interface for GNOME Zenity.

=over

=item C<< info(text => $text, %arguments) >>

Display a message to the user.

Setting the argument C<no_wrap> to true can be used to I<hint> that line
wrapping should be avoided.

The C<lang> argument can be used to indicate the language of the C<text> as
an ISO 639-1 code (e.g. "en" for English). Not all objects implementing the
Ask API will pay attention to this hint, so don't be too surprised to see
text in French with an English "OK" button underneath!

=item C<< warning(text => $text, %arguments) >>

Display a warning to the user.

Supports the same arguments as C<info>.

=item C<< error(text => $text, %arguments) >>

Display an error message (not necessarily fatal) to the user.

Supports the same arguments as C<info>.

=item C<< entry(%arguments) >>

Ask the user to enter some text. Returns that text.

The C<text> argument is supported as a way of communicating what you'd like
them to enter. The C<hide_text> argument can be set to true to I<hint> that
the text entered should not be displayed on screen (e.g. password input).

The C<default> argument can be used to supply a default return value if the
user cannot be asked for some reason (e.g. running on an unattended terminal).

The C<lang> argument can be used to indicate the language of the C<text> as
an ISO 639-1 code (e.g. "en" for English).

=item C<< question(text => $text, %arguments) >>

Ask the user to answer an affirmative/negative question (i.e. OK/cancel,
yes/no) defaulting to affirmative. Returns boolean.

The C<text> argument is the text of the question; the C<ok_label> argument
can be used to set the label for the affirmative button; the C<cancel_label>
argument for the negative button.

The C<default> argument can be used to supply a default return value if the
user cannot be asked for some reason (e.g. running on an unattended terminal).

The C<lang> argument can be used to indicate the language of the C<text> as
an ISO 639-1 code (e.g. "en" for English).

=item C<< file_selection(%arguments) >>

Ask the user for a file name. Returns the file name. No checks are made to
ensure the file exists.

The C<multiple> argument can be used to indicate that multiple files may be
selected (they are returned as a list); the C<directory> argument can be
used to I<hint> that you want a directory.

The C<default> argument can be used to supply a default return value if the
user cannot be asked for some reason (e.g. running on an unattended terminal).
If C<multiple> is true, then this must be an arrayref.

Until version 0.011, returned values are strings. Thereafter, returned values
are L<Path::Tiny> objects.

=item C<< single_choice(text => $text, choices => \@choices) >>

Asks the user to select a single option from many choices.

For example:

   my $answer = $ask->single_choice(
      text    => "If a=1, b=2. What is a+b?",
      choices => [
         [ A => 12 ],
         [ B => 3  ],
         [ C => 2  ],
         [ D => 42 ],
         [ E => "Fish" ],
      ],
   );

The choices are C<< identifier => label >> pairs. The identifiers are not
necessarily displayed to the user making the choice; the labels are. The
function returns the identifier for the chosen option.

The C<default> argument can be used to supply a default return value if the
user cannot be asked for some reason (e.g. running on an unattended terminal).

The C<lang> argument can be used to indicate the language of the C<text> and
labels as an ISO 639-1 code (e.g. "en" for English).

=item C<< multiple_choice(text => $text, choices => \@choices) >>

Asks the user to select zero or more options from many choices.

   my @ingredients = $ask->multiple_choice(
      text    => "What do you want on your pizza?",
      choices => [
         [ cheese    => 'Cheese' ],
         [ tomato    => 'Tomato' ],
         [ ham       => 'Ham'    ],
         [ pineapple => 'Pineapple' ],
         [ chocolate => 'Chocolate' ],
      ],
   );

Returns list of identifiers.

The C<default> argument can be used to supply a default return value if the
user cannot be asked for some reason (e.g. running on an unattended terminal).
It must be an arrayref.

The C<lang> argument can be used to indicate the language of the C<text> and
labels as an ISO 639-1 code (e.g. "en" for English).

=back

If you wish to create your own implementation of the Ask API, please
read L<Ask::API> for more information.

=head2 Extending Ask

Implementing L<Ask::API> allows you to extend Ask to other environments.

To add extra methods to the Ask API you may use Moo roles:

   {
      package AskX::Method::Password;
      use Moo::Role;
      sub password {
         my ($self, %o) = @_;
         $o{hide_text} //= 1;
         $o{text}      //= "please enter your password";
         $self->entry(%o);
      }
   }
   
   my $ask = Ask->detect(traits => ['AskX::Method::Password']);
   say "GOT: ", $ask->password;

=head2 Export

You can optionally export the Ask methods as functions. The functions behave
differently from the object-oriented interface in one regard; if called with
one parameter, it's taken to be the "text" named argument.

   use Ask qw( question info );
   
   if (question("Are you happy?")
   and question("Do you know it?")
   and question("Really want to show it?")) {
      info("Then clap your hands!");
   }

Ask uses L<Sub::Exporter::Progressive>, so exported functions may be renamed:

   use Ask
      question => { -as => 'interrogate' },
      info     => { -as => 'notify' },
   ;

=head2 I18n

It is strongly recommended that you pass a C<lang> argument with each method
call. Not all backends yet pay attention to it.

See also L<AskX::AutoLang> as a way to avoid passing C<< lang => "fu" >> to
every single method call!

=head1 ENVIRONMENT

The C<PERL_ASK_BACKEND> environment variable can be used to influence the
outcome of C<< Ask->detect >>. Indeed, it trumps all other factors. If set,
it should be a full class name.

If either of the C<AUTOMATED_TESTING> or C<PERL_MM_USE_DEFAULT> environment
variables are set to true, the C<< Ask::Fallback >> backend will automatically
be used.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Ask>.

=head1 SEE ALSO

Terminal backends:

=over

=item *

L<Ask::STDIO> - very basic usage of STDIN/STDOUT/STDERR

=item *

L<Ask::Caroline> - uses L<Caroline> and L<Term::ANSIColor> for better interaction

=item *

L<Ask::Clui> - uses L<Term::Clui> for better interaction

=back

GUI backends:

=over

=item *

L<Ask::Gtk> - GUI using L<Gtk2>.

=item *

L<Ask::Prima> - GUI using L<Prima>.

=item *

L<Ask::Tk> - GUI using L<Tk>.

=item *

L<Ask::Wx> - GUI using L<Wx>.

=item *

L<Ask::Zenity> - GUI using the C<< /usr/bin/zenity >> binary (part of GNOME)

=back

Backends which perform no real user interaction:

=over

=item *

L<Ask::Callback> - implementation for testing; redirects input and output to callback functions.

=item *

L<Ask::Fallback> - returns default answers; for scripts running unattended.

=back

See L<Ask::API> for documentation of API internals.

See L<Ask::Question> for an alternative way of using Ask.

Similar modules: L<IO::Prompt>, L<IO::Prompt::Tiny> and many others.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012-2013, 2020 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
