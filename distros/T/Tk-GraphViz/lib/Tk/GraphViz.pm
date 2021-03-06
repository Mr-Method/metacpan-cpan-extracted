# -*-Perl-*-
package Tk::GraphViz;

use strict;
use warnings;

our $VERSION = '1.10';

use Tk 800.020;
use Tk::Font;
use Tk::IO;

use base qw(Tk::Derived Tk::Canvas);

use IO qw(Handle File Pipe);
use Carp;

use IPC::Open3;
use POSIX qw( :sys_wait_h :errno_h );
use Fcntl;
use Text::ParseWords qw(parse_line);

# Initialize as a derived Tk widget
Construct Tk::Widget 'GraphViz';


######################################################################
# Class initializer
#
######################################################################
sub ClassInit
{
  my ($class, $mw) = @_;


  $class->SUPER::ClassInit($mw);
}


######################################################################
# Instance initializer
#
######################################################################
sub Populate
{
  my ($self, $args) = @_;

  $self->SUPER::Populate($args);


  # Default resolution, for scaling
  $self->{dpi} = 72;
  $self->{margin} = .15 * $self->{dpi};

  # Keep track of fonts used, so they can be scaled
  # when the canvas is scaled
  $self->{fonts} = {};
}


######################################################################
# Show a GraphViz graph
#
# Major steps:
# - generate layout of the graph, which includes
#   locations / color info
# - clear canvas
# - parse layout to add nodes, edges, subgraphs, etc
# - resize to fit the graph
######################################################################
sub show
{
  my ($self, $graph, %opt) = @_;

  die __PACKAGE__.": Nothing to show" unless defined $graph;
  $self->MainWindow->update;

  # Layout is actually done in the background, so the graph
  # will get updated when the new layout is ready
  $self->_startGraphLayout ( $graph, %opt );
}


######################################################################
# Begin the process of creating the graph layout.
# Layout is done with a separate process, and it can be time
# consuming.  So allow the background task to run to completion
# without blocking this process.  When the layout task is complete,
# the graph display is actually updated.
######################################################################
sub _startGraphLayout
{
  my ($self, $graph, %opt) = @_;
  my ($filename,$delete_file) = $self->_createDotFile ( $graph, %opt );
  $self->{layout} = [];
  $self->_startDot ( $filename, delete_file => $delete_file, %opt );
}


######################################################################
# Display the new graph layout.
# This is called once the layout of the graph has been completed.
# The layout data itself is stored as a list layout elements,
# typically read directly from the background layout task
######################################################################
sub _showGraphLayout
{
  my ($self, %opt) = @_;

  # Erase old contents
  unless ( defined $opt{keep} && $opt{keep} ) {
    $self->delete ( 'all' );
    delete $self->{fonts}{_default} if exists $self->{fonts}{_default};
  }

  # Display new contents
  my $layoutData = $self->_parseLayout($self->{layout}, %opt);
  $layoutData = $opt{prerender}->($layoutData) if $opt{prerender};
  $self->_renderGraph($layoutData);

  # Update scroll-region to new bounds
  $self->_updateScrollRegion( %opt );

  if ( defined $opt{fit} && $opt{fit} ) {
    $self->fit();
  }

  1;
}



######################################################################
# Create a (temporary) file on disk containing the graph
# in canonical GraphViz/dot format.
#
# '$graph' can be
# - a GraphViz instance
# - a scalar containing graph in dot format:
#   must match /^\s*(?:di)?graph /
# - a IO::Handle from which to read a graph in dot format
#   (contents will be read and converted to a scalar)
# - a filename giving a file that contains a graph in dot format
#
# Returns a filename that contains the DOT description for the graph,
# and an additional flag to indicate if the file is temprary
######################################################################
sub _createDotFile
{
  my ($self, $graph, %opt) = @_;

  my $filename = undef;
  my $delete_file = undef;

  my $ref = ref($graph);
  if ( $ref ne '' ) {
    # A blessed reference
    if ( $ref->isa('GraphViz') ||
	 UNIVERSAL::can( $graph, 'as_canon') ) {
      ($filename, my $fh) = $self->_mktemp();
      eval { $graph->as_canon ( $fh ); };
      if ( $@ ) {
	die __PACKAGE__.": Error calling GraphViz::as_canon on $graph: $@";
      }
      $fh->close;
      $delete_file = 1;
    } elsif ( $ref->isa('GraphViz2') ) {
      ($filename, my $fh) = $self->_mktemp();
      eval { print $fh $graph->dot_input };
      if ( $@ ) {
	die __PACKAGE__.": Error calling GraphViz2::dot_input on $graph: $@";
      }
      $fh->close;
      $delete_file = 1;
    } elsif ( $ref->isa('IO::Handle') ) {
      ($filename, my $fh) = $self->_mktemp();
      while ( <$graph> ) { $fh->print; }
      $fh->close;
      $delete_file = 1;
    } else {
      confess "Unknown object type '$graph'";
    }
  }

  else {
    # Not a blessed reference

    # Try it as a filename
    # Skip the filename test if it has newlines
    if ( $graph !~ /\n/m &&
	 -r $graph ) {
      $filename = $graph;
      $delete_file = 0;
    }

    # Try it as a scalar
    elsif ( $graph =~ /^\s*(?:di)?graph / ) {
      ($filename, my $fh) = $self->_mktemp();
      $fh->print ( $graph );
      $fh->close;
      $delete_file = 1;
    }

    else {
      die __PACKAGE__.": Bad graph: '$graph'";
    }
  }

  confess unless defined($filename) && defined($delete_file);
  ($filename, $delete_file);
}


######################################################################
# Create a temp file for writing, open a handle to it
#
######################################################################
{
my $_mktemp_count = 0;
sub _mktemp
{
  my $tempDir = $ENV{TEMP} || $ENV{TMP} || '/tmp';
  my $filename = sprintf ( "%s/Tk-GraphViz.dot.$$.%d.dot",
			   $tempDir, $_mktemp_count++ );
  my $fh = IO::File->new( $filename, 'w' ) ||
    confess "Can't write temp file: $filename: $!";
  binmode($fh);
  ($filename, $fh);
}
}


######################################################################
# Starting running 'dot' (or some other layout command) in the
# background, to convert a dot file to layout output format.
#
######################################################################
sub _startDot
{
  my ($self, $filename, %opt) = @_;

  confess "Can't read file: $filename" 
    unless -r $filename;

  my @layout_cmd = $self->_makeLayoutCommand ( $filename, %opt );

  my $delete_file = delete $opt{delete_file};
  my $then = sub {
    unlink $filename if $delete_file;
    $self->_showGraphLayout( %opt );
  };
  # Simple, non-asynchronous mode: execute the
  # process synchnronously and wait for all its output
  if ( !defined($opt{async}) || !$opt{async} ) {
    my $pipe = IO::Pipe->new;
    $pipe->reader ( @layout_cmd );
    while ( <$pipe> ) { push @{$self->{layout}}, $_; }
    $then->();
    return 1;
  }

  my $fh  = Tk::IO->new(
    -linecommand  => sub {
      push @{$self->{layout}}, @_;
    },
    -childcommand => sub {
      my ($stat) = @_;
      my ($error, $status); # not used but captured in case
      if ( $stat == 0xff00 ) {
        $error = "exec failed";
      } elsif ( $stat > 0x80 ) {
        $stat >>= 8;
      } elsif ( $stat & 0x80 ) {
        $stat &= ~0x80;
        $error = "Killed by signal $stat (coredump)";
      } else {
        $error = "Kill by signal $stat";
      }
      $status = $stat;
      $then->();
    },
  );
  $fh->exec(@layout_cmd);
}


######################################################################
# $self->_disableBlocking ( $fh )
#
# Turn off blocking-mode for the given handle
######################################################################
sub _disableBlocking
{
  my ($self, $fh) = @_;

  my $flags = 0;
  fcntl ( $fh, &F_GETFL, $flags ) or
    confess "Can't get flags for handle";
  $flags = ($flags+0) | O_NONBLOCK;
  fcntl ( $fh, &F_SETFL, $flags ) or
    confess "Can't set flags for handle";

  1;
}


######################################################################
# Assemble the command for executing dot/neato/etc as a child process
# to generate the layout.  The layout of the graph will be read from
# the command's stdout
######################################################################
sub _makeLayoutCommand
{
  my ($self, $filename, %opt) = @_;

  my $layout_cmd = $opt{layout} || 'dot';
  my @opts = ();

  if ( defined $opt{graphattrs} ) {
    # Add -Gname=value settings to command line
    my $list = $opt{graphattrs};
    my $ref = ref($list);
    die __PACKAGE__.": Expected array reference for graphattrs"
      unless defined $ref && $ref eq 'ARRAY';
    while ( my ($key, $val) = splice @$list, 0, 2 ) {
      push @opts, "-G$key=\"$val\"";
    }
  }

  if ( defined $opt{nodeattrs} ) {
    # Add -Gname=value settings to command line
    my $list = $opt{nodeattrs};
    my $ref = ref($list);
    die __PACKAGE__.": Expected array reference for nodeattrs"
      unless defined $ref && $ref eq 'ARRAY';
    while ( my ($key, $val) = splice @$list, 0, 2 ) {
      push @opts, "-N$key=\"$val\"";
    }
  }

  if ( defined $opt{edgeattrs} ) {
    # Add -Gname=value settings to command line
    my $list = $opt{edgeattrs};
    my $ref = ref($list);
    die __PACKAGE__.": Expected array reference for edgeattrs"
      unless defined $ref && $ref eq 'ARRAY';
    while ( my ($key, $val) = splice @$list, 0, 2 ) {
      push @opts, "-E$key=\"$val\"";
    }
  }

  return ($layout_cmd, @opts, '-Tdot', $filename);
}


######################################################################
# Parse the layout data in dot 'text' format, as returned
# by _dot2layout.  Nodes / edges / etc defined in the layout
# are added as object in the canvas
######################################################################
sub _parseLayout
{
  my ($self, $layoutLines, %opt) = @_;
  my ($context, @saveStack) = { node => {}, edge => {}, graph => {} };
  my %returnData = (global => { map +($_ => $self->{$_}), qw(dpi) });
  my $accum = undef;
  foreach ( @$layoutLines ) {
    s/\r//g;  # get rid of any returns ( dos text files)
    chomp;
    # Handle line-continuation that gets put in for longer lines,
    # as well as lines that are continued with commas at the end
    if ( defined $accum ) {
      $_ = $accum . $_;
      $accum = undef;
    }
    if ( s/\\\s*$// ||
         /\,\s*$/ ) {
      $accum = $_;
      next;
    }
    s/^\s+//;
    #STDERR->print ( "gv _parse: '$_'\n" );
    my @words = parse_line '\s+', 1, $_;
    if ($words[0] =~ /^(?:di)?graph$/ and $words[-1] eq '{') {
      # starting line, ignore
      next;
    }
    if ( $words[0] =~ /^\]\s*;$/ ) {
      # end of attributes not finishing on same line as important info, ignore
      next;
    }
    if ($context->{my $c = $words[0]}) {
      shift @words;
      %{ $context->{$c} } = (%{ $context->{$c} }, %{ _parseAttrs(join ' ', @words) });
      next;
    }
    if ( ($words[0] eq 'subgraph' and $words[-1] eq '{') or $words[0] eq '{') {
      push @saveStack, $context;
      $context = { map +($_ => {%{ $context->{$_} }}), keys %$context };
      delete $context->{graph}{label};
      delete $context->{graph}{bb};
    } elsif ( $words[0] eq '}' ) {
      # End of a graph section
      if ( @saveStack ) {
	# Subgraph
	if ( defined($context->{graph}{bb}) && $context->{graph}{bb} ne '' ) {
	  my ($x1,$y1,$x2,$y2) = split ( /\s*,\s*/, $context->{graph}{bb} );
	  push @{ $returnData{subgraph} }, [ $x1, $y1, $x2, $y2, %{ $context->{graph} } ];
	}
	$context = pop @saveStack;
      } else {
	# End of the graph
	# Create any whole-graph label
	if ( defined($context->{graph}{bb}) ) {
	  my ($x1,$y1,$x2,$y2) = split ( /\s*,\s*/, $context->{graph}{bb} );
	  # delete bb attribute so rectangle is not drawn around whole graph
	  delete $context->{graph}{bb};
	  push @{ $returnData{subgraph} }, [ $x1, $y1, $x2, $y2, %{ $context->{graph} } ];
	}
	last;
      }
    } elsif ( ($words[1] || '') =~ /^-[>\-]$/ ) {
      # Edge
      my ($n1, undef, $n2) = splice @words, 0, 3;
      my %edgeAttrs = (%{ $context->{edge} }, %{ _parseAttrs(join ' ', @words) });
      my ($drawArrows,@coords) = $self->_parseEdgePos( delete $edgeAttrs{pos} || die "no 'pos' on edge" );
      $edgeAttrs{pos} = [ $drawArrows, \@coords ];
      push @{ $returnData{edge}{$n1}{$n2} }, \%edgeAttrs;
    } elsif ( /(.+?)\s*(?:\[(.+)\];)?\s*$/ ) {
      # Node
      my ($name) = splice @words, 0, 1;
      # Get rid of any leading/trailing quotes
      $name =~ s/^\"//;
      $name =~ s/\"?;?$//;
      my %nodeAttrs = (%{ $context->{node} }, %{ _parseAttrs(join ' ', @words) });
      $returnData{node}{$name} = { %{ $returnData{node}{$name} || {} }, %nodeAttrs };
    } else {
      warn "Failed to parse DOT line: '$_'";
    }
  }
  \%returnData;
}


sub _renderGraph {
  my ($self, $layoutData) = @_;
  $self->_createNode($_, %{ $layoutData->{node}{$_} }) for keys %{ $layoutData->{node} };
  for my $f (keys %{ $layoutData->{edge} }) {
    for my $t (keys %{ $layoutData->{edge}{$f} }) {
      $self->_createEdge($f, $t, %$_) for @{ $layoutData->{edge}{$f}{$t} };
    }
  }
  $self->_createSubgraph(@$_) for @{ $layoutData->{subgraph} };
}


######################################################################
# Parse attributes of a node / edge / graph / etc,
# store the values in a hash
######################################################################
sub _parseAttrs {
  my ($attrs) = @_;
  my %attrHash;
  $attrs =~ s/^\[(.*?)\]?;?\s*$/$1/;
  for (parse_line '\s*,\s*', 1, $attrs) {
    my ($key, $val) = split /\s*=\s*/, $_, 2;
    $val =~ s/^"(.*)"$/$1/;
    $val =~ s/\\(.)/ $1 eq '"' ? $1 : "\\$1" /ge;
    $attrHash{$key} = $val;
  }
  \%attrHash;
}


######################################################################
# Create a subgraph / cluster
#
######################################################################
sub _createSubgraph
{
  my ($self, $x1, $y1, $x2, $y2, %attrs) = @_;

  my $label = $attrs{label};
  my $color = $attrs{color} || 'black';

  # Want box to be filled with background color by default, so that
  # it is 'clickable'
  my $fill = $self->cget('-background');

  my $tags = [
    subgraph => ($label ? "subgraph=$label" : ()),
    map "$_=$attrs{$_}", sort keys %attrs
  ];

  # Get/Check a valid color
  $color = $self->_tryColor($color);

  my @styleArgs;
  if( $attrs{style} ){
    my $style = $attrs{style};
    if ( $style =~ /dashed/i ) {
      @styleArgs = (-dash => '-');
    }
    elsif ( $style =~ /dotted/ ) {
      @styleArgs = (-dash => '.');
    }
    elsif ( $style =~ /filled/ ) {
      $fill = ( $self->_tryColor($attrs{fillcolor}) || $color );
    }
    elsif( $style =~ /bold/ ) {
      # Bold outline, gets wider line
      push @styleArgs, (-width => 2);
    }
  }

  # Create the box if coords are defined
  if( $attrs{bb} ) {
    my $id = $self->createRectangle ( $x1, -1 * $y2, $x2, -1 * $y1,
				      -outline => $color,
				      -fill => $fill, @styleArgs,
				      -tags => [ @$tags, 'outermost' ] );
    $self->lower($id); # make sure it doesn't obscure anything
  }

  # Create the label, if defined
  if ( defined($attrs{label}) ) {
    my $lp = $attrs{lp} || '';
    my ($x,$y) = split(/\s*,\s*/,$lp);
    if ( $lp eq '' ) { ($x,$y) = ($x1, $y2); }

    $label =~ s/\\n/\n/g;
    my @args = ( $x, -1 * $y,
		 -text => $label,
		 -tags => $tags );
    push @args, ( -state => 'disabled' );
    if ( $lp eq '' ) { push @args, ( -anchor => 'nw' ); }

    $self->createText ( @args );
  }
}


######################################################################
# Create a node
#
######################################################################
sub _createNode
{
  my ($self, $name, %attrs) = @_;

  return unless $attrs{pos}; # node specified elsewhere but also in subgraph

  my ($x,$y) = split(/,/, $attrs{pos});
  my $dpi = $self->{dpi};
  my $w = $attrs{width} * $dpi; #inches
  my $h = $attrs{height} * $dpi; #inches
  my $x1 = $x - $w/2.0;
  my $y1 = $y - $h/2.0;
  my $x2 = $x + $w/2.0;
  my $y2 = $y + $h/2.0;

  my $label = $attrs{label};
  if (defined $label) {
    $label =~ s/\\(.)/ $1 eq 'N' ? $name : "\\$1" /ge;
  } else {
    $label = $name;
  }
  $attrs{label} = $label;

  #STDERR->printf ( "createNode: $name \"$label\" ($x1,$y1) ($x2,$y2)\n" );

  # Node shape
  my @tags = (node => "node=$name", map "$_=$attrs{$_}", sort keys %attrs);

  my @args = ();

  my $outline = $self->_tryColor($attrs{color}) || 'black';
  my $fill = $self->_tryColor($attrs{fillcolor}) || $self->cget('-background');
  my $fontcolor = $self->_tryColor($attrs{fontcolor}) || 'black';
  my $shape = $attrs{shape} || '';

  foreach my $style ( split ( /,/, $attrs{style}||'' ) ) {
    if ( $style eq 'filled' ) {
      $fill = ( $self->_tryColor($attrs{fillcolor}) ||
		$self->_tryColor($attrs{color}) ||
		'lightgrey' );
    }
    elsif ( $style eq 'invis' ) {
      $outline = undef;
      $fill = undef;
    }
    elsif ( $style eq 'dashed' ) {
      push @args, -dash => '--';
    }
    elsif ( $style eq 'dotted' ) {
      push @args, -dash => '.';
    }
    elsif ( $style eq 'bold' ) {
      push @args, -width => 2.0;
    }
    elsif ( $style =~ /setlinewidth\((\d+)\)/ ) {
      push @args, -width => "$1";
    }
  }

  push @args, -outline => $outline if ( defined($outline) );
  push @args, -fill => $fill if ( defined($fill) );

  my $orient = $attrs{orientation} || 0.0;
  if ( $shape eq 'record' ) {
    $self->_createRecordNode ( $label, \@args, %attrs, tags => \@tags );
  } else {
    $self->_createShapeNode ( $shape, $x1, -1*$y2, $x2, -1*$y1,
			      $orient, 1, @args, -tags => \@tags );
    $label = undef if ( $shape eq 'point' );
    # Node label
    if ( defined $label ) {
      @args = ( ($x1 + $x2)/2, -1*($y2 + $y1)/2, -text => $label,
		-anchor => 'center', -justify => 'center',
		-tags => \@tags, -fill => $fontcolor );
      push @args, ( -state => 'disabled' );
      push @args, -font => $self->_getFont(@attrs{qw(fontname fontsize)});
      $self->createText ( @args );
    }
  }

  # Return the bounding box of the node
  ($x1,$y1,$x2,$y2);
}


######################################################################
# Create an item of a specific shape, generally used for creating
# node shapes.
######################################################################
my %polyShapes =
  ( box => [ [ 0, 0 ], [ 0, 1 ], [ 1, 1 ], [ 1, 0 ] ],
    rect => [ [ 0, 0 ], [ 0, 1 ], [ 1, 1 ], [ 1, 0 ] ],
    rectangle => [ [ 0, 0 ], [ 0, 1 ], [ 1, 1 ], [ 1, 0 ] ],
    triangle => [ [ 0, .75 ], [ 0.5, 0 ], [ 1, .75 ] ],
    invtriangle => [ [ 0, .25 ], [ 0.5, 1 ], [ 1, .25 ] ],
    diamond => [ [ 0, 0.5 ], [ 0.5, 1.0 ], [ 1.0, 0.5 ], [ 0.5, 0.0 ] ],
    pentagon => [ [ .5, 0 ], [ 1, .4 ], [ .75, 1 ], [ .25, 1 ], [ 0, .4 ] ],
    hexagon => [ [ 0, .5 ], [ .33, 0 ], [ .66, 0 ],
		 [ 1, .5 ], [ .66, 1 ], [ .33, 1 ] ],
    septagon => [ [ .5, 0 ], [ .85, .3 ], [ 1, .7 ], [ .75, 1 ],
		  [ .25, 1 ], [ 0, .7 ], [ .15, .3 ] ],
    octagon => [ [ 0, .3 ], [ 0, .7 ], [ .3, 1 ], [ .7, 1 ],
		 [ 1, .7 ], [ 1, .3 ], [ .7, 0 ], [ .3, 0 ] ],
    trapezium => [ [ 0, 1 ], [ .21, 0 ], [ .79, 0 ], [ 1, 1 ] ],
    invtrapezium => [ [ 0, 0], [ .21, 1 ], [ .79, 1 ], [ 1, 0 ] ],
    parallelogram => [ [ 0, 1 ], [ .20, 0 ], [ 1, 0 ], [ .80, 1 ] ],
    house => [ [ 0, .9 ], [ 0, .5 ], [ .5, 0 ], [ 1, .5 ], [ 1, .9 ] ],
    invhouse => [ [ 0, .1 ], [ 0, .5 ], [ .5, 1 ], [ 1, .5 ], [ 1, .1 ] ],
    folder => [ [ 0, 0.1 ], [ 0, 1 ], [ 1, 1 ], [ 1, 0.1 ],
                [0.9, 0 ], [0.7 , 0 ] , [0.6, 0.1 ] ],
    component => [ [ 0, 0 ], [ 0, 0.1 ], [ 0.03, 0.1 ], [ -0.03, 0.1 ],
                   [ -0.03, 0.3 ], [ 0.03 , 0.3 ], [ 0.03, 0.1 ],
                   [ 0.03 , 0.3 ], [ 0 , 0.3 ], [ 0, 0.7 ], [ 0.03, 0.7 ],
                   [ -0.03, 0.7 ], [ -0.03, 0.9 ], [ 0.03 , 0.9 ],
                   [ 0.03, 0.7 ], [ 0.03 , 0.9 ], [ 0 , 0.9 ],
                   [ 0, 1 ], [ 1, 1 ], [ 1, 0 ] ],
    Msquare => [
      [0, 0], [0, 0.2], [0.2, 0], [0, 0.2], [0, 0], # non-closed triangle = stays filled
      [1, 0], [1, 0.2], [0.8, 0], [1, 0.2], [1, 0],
      [1, 1], [1, 0.8], [0.8, 1], [1, 0.8], [1, 1],
      [0, 1], [0, 0.8], [0.2, 1], [0, 0.8], [0, 1],
      ],
    Mdiamond => [
      [0.0, 0.5], [0.1, 0.4], [0.1, 0.6], [0.1, 0.4], [0.0, 0.5],
      [0.5, 0.0], [0.6, 0.1], [0.4, 0.1], [0.6, 0.1], [0.5, 0.0],
      [1.0, 0.5], [0.9, 0.6], [0.9, 0.4], [0.9, 0.6], [1.0, 0.5],
      [0.5, 1.0], [0.4, 0.9], [0.6, 0.9], [0.4, 0.9], [0.5, 1.0],
      ],
);

sub _createShapeNode
{
  my ($self, $shape, $x1, $y1, $x2, $y2, $orient, $outermost, %args) = @_;

  #STDERR->printf ( "createShape: $shape ($x1,$y1) ($x2,$y2)\n" );
  my $id = undef;

  my @extraArgs = ();
  my $tags = $args{-tags};
  my @outermostArgs = $outermost ? (-tags => [@$tags, 'outermost']) : ();

  # Special handling for recursive calls to create periphery shapes
  # (for double-, triple-, etc)
  my $periphShape = $args{_periph};
  if ( defined $periphShape ) {
    delete $args{_periph};

    # Periphery shapes are drawn non-filled, so they are
    # not clickable
    push @extraArgs, ( -fill => undef, -state => 'disabled' );
  };


  # Simple shapes: defined in the polyShape hash
  if ( exists $polyShapes{$shape} ) {
    $id = $self->_createPolyShape ( $polyShapes{$shape}, 
				    $x1, $y1, $x2, $y2, $orient,
				    %args, @extraArgs, @outermostArgs );
  }

  # Other special-case shapes:

  elsif ( $shape =~ s/^double// ) {
    my $diam = max(abs($x2-$x1),abs($y2-$y1));
    my $inset = max(2,min(5,$diam*.1));
    return $self->_createShapeNode ( $shape, $x1, $y1, $x2, $y2, $orient, 0,
				     %args, _periph => [ 1, $inset ] );
  }

  elsif ( $shape =~ s/^triple// ) {
    my $diam = max(abs($x2-$x1),abs($y2-$y1));
    my $inset = min(5,$diam*.1);
    return $self->_createShapeNode ( $shape, $x1, $y1, $x2, $y2, $orient, 0,
				     %args, _periph => [ 2, $inset ] );
  }

  elsif (  $shape eq 'plaintext' ) {
    # Don't draw an outline for plaintext
    $id = 0;
  }

  elsif ( $shape eq 'point' ) {
    # Draw point as a small oval
    $shape = 'oval';
  }

  elsif ( $shape eq 'ellipse' || $shape eq 'circle' ) {
    $shape = 'oval';
  }

  elsif ( $shape eq 'oval' ) {

  }

  elsif ( $shape eq '' ) {
    # Default shape = ellipse
    $shape = 'oval';
  }

  else {
    warn __PACKAGE__.": Unsupported shape type: '$shape', using box";
  }

  if ( !defined $id ) {
    if ( $shape eq 'oval' ) {
      $id = $self->createOval ( $x1, $y1, $x2, $y2, %args, @extraArgs, @outermostArgs );
    } else {
      $id = $self->createRectangle ( $x1, $y1, $x2, $y2, %args, @extraArgs, @outermostArgs );
    }
  }

  # Need to create additional periphery shapes?
  if ( defined $periphShape ) {
    # This method of stepping in a fixed amount in x and y is not
    # correct, because the aspect of the overall shape changes...
    my $inset = $periphShape->[1];
    $x1 += $inset;
    $y1 += $inset;
    $x2 -= $inset;
    $y2 -= $inset;
    if ( --$periphShape->[0] > 0 ) { 
      @extraArgs = ( _periph => $periphShape );
    } else {
      @extraArgs = ();
    }
    return $self->_createShapeNode ( $shape, $x1, $y1, $x2, $y2, $orient, 0,
				     %args, @extraArgs );
  }

  $id;
}


######################################################################
# Create an arbitrary polygonal shape, using a set of unit points.
# The points will be scaled to fit the given bounding box.
######################################################################
sub _createPolyShape
{
  my ($self, $upts, $x1, $y1, $x2, $y2, $orient, %args) = @_;

  my ($ox, $oy) = 1.0;
  if ( $orient != 0 ) {
    $orient %= 360.0;

    # Convert to radians, and rotate ccw instead of cw
    $orient *= 0.017453; # pi / 180.0
    my $c = cos($orient);
    my $s = sin($orient);
    my $s_plus_c = $s + $c;
    my @rupts = ();
    foreach my $upt ( @$upts ) {
      my ($ux, $uy) = @$upt;
      $ux -= 0.5;
      $uy -= 0.5;

      #STDERR->printf ( "orient: rotate (%.2f,%.2f) by %g deg\n",
      #		       $ux, $uy, $orient / 0.017453 );
      $ux = $ux * $c - $uy * $s; # x' = x cos(t) - y sin(t)
      $uy = $uy * $s_plus_c;     # y' = y sin(t) + y cos(t)
      #STDERR->printf ( "       --> (%.2f,%.2f)\n", $ux, $uy  );

      $ux += 0.5;
      $uy += 0.5;

      push @rupts, [ $ux, $uy ];
    }
    $upts = \@rupts;
  }

  my $dx = $x2 - $x1;
  my $dy = $y2 - $y1;
  my @pts = ();
  foreach my $upt ( @$upts ) {
    my ($ux, $uy ) = @$upt;

    push @pts, ( $x1 + $ux*$dx, $y1 + $uy*$dy );
  }
  $self->createPolygon ( @pts, %args );
}

sub _parse {
  my ($label, $debug) = @_;
  require Tk::GraphViz::parseRecordLabel;
  # Setup to parse the label (Label parser object created using Parse::Yapp)
  my $parser = Tk::GraphViz::parseRecordLabel->new;
  $parser->YYData->{INPUT} = $label;
  # And parse it...
  $parser->YYParse(
    yylex => \&Tk::GraphViz::parseRecordLabel::Lexer,
    yyerror => \&Tk::GraphViz::parseRecordLabel::Error,
    yydebug => ($debug && 0x1F),
  ) or die __PACKAGE__.": Error Parsing Record Node Label '$label'\n";
}

# parsing now preserves deep structure but for this we just want flat list
sub _flatten {
  my ($data) = @_;
  return $data if ref($data) ne 'ARRAY';
  map _flatten($_), @$data;
}

######################################################################
# Draw the node record shapes
######################################################################
my $TEXT_MARGIN = 8; # arbitrarily chosen
sub _createRecordNode
{
  my ($self, $label, $shape_args, %attrs) = @_;

  my $tags = $attrs{tags};

  # Get Rectangle Coords
  my @rectsCoords = map [ split ',', $_ ], split ' ', $attrs{rects};

  my @labels = _flatten(_parse($label));

  # Draw the rectangles
  my $portIndex = 1;  # Ports numbered from 1. This is used for the port name
                      # in the tags, if no port name is defined in the dot file
  foreach my $rectCoords ( @rectsCoords ) {
    my ($port, $text) = %{shift @labels};

    # use port index for name, if one not defined
    $port = $portIndex unless ( $port =~ /\S/);

    my @portTags = @$tags;
    push @portTags, "port=$port";

    # get rid of leading trailing whitespace
    $text =~ s/^\s+//;
    $text =~ s/\s+$//;

    push @portTags, "label=$text";

    my ($x1,$y1,$x2,$y2) = @$rectCoords;
    $self->createRectangle ( $x1, -$y1, $x2, -$y2, @$shape_args, -tags => [@portTags, $portIndex == 1 ? "outermost" : ()] );
    my ($y_anchor, $anchor_arg, $x_anchor) = (-($y1 + $y2)/2);
    my %label_attrs = _label2attrs($text);
    if ($label_attrs{-justify} eq 'left') {
      $x_anchor = $x1 + $TEXT_MARGIN;
      $anchor_arg = 'w';
    } elsif ($label_attrs{-justify} eq 'right') {
      $x_anchor = $x2 - $TEXT_MARGIN;
      $anchor_arg = 'e';
    } else {
      $x_anchor = ($x1 + $x2)/2;
      $anchor_arg = 'center';
    }
    $self->createText(
      $x_anchor, $y_anchor, -anchor => $anchor_arg,
      -text => $text, -tags => \@portTags,
      -font => $self->_getFont(@attrs{qw(fontname fontsize)}),
    );

    $portIndex++;
  }
}


######################################################################
# Create a edge
#
######################################################################
sub _createEdge
{
  my ($self, $n1, $n2, %attrs) = @_;

  my $x1 = undef;
  my $y1 = undef;
  my $x2 = undef;
  my $y2 = undef;

  my $tags = [ edge => "edge=$n1 $n2",
	       "node1=$n1", "node2=$n2",
               map "$_=$attrs{$_}", sort keys %attrs,
               ];

  # Parse the edge position
  my $pos = $attrs{pos} || return;
  my ($drawArrows, $coords) = @$pos;
  my @coords = @$coords;
  my $arrowhead = $attrs{arrowhead};
  my $arrowtail = $attrs{arrowtail};

  my @args = ();

  # Convert Bezier control points to 4 real points to smooth against
  #  Canvas line smoothing doesn't use beziers, so we supply more points
  #   along the manually-calculated bezier points.

  my @tailCoords = $drawArrows->{s} ? @{ shift @coords } : ();
  my @headCoords = $drawArrows->{e} ? @{ pop @coords } : ();
  @coords = map @$_, @coords; #flatten coords array

  my @newCoords;
  my ($startIndex, $stopIndex);
  $startIndex = 0;
  $stopIndex  = 7;
  my $lastFlag = 0;
  my @controlPoints;
  while($stopIndex <= $#coords){
    @controlPoints = @coords[$startIndex..$stopIndex];

    # If this is the last set, set the flag, so we will get
    # the last point
    $lastFlag = 1 if( $stopIndex == $#coords);

    push @newCoords, 
      $self->_bezierInterpolate(\@controlPoints, 0.1, $lastFlag);

    $startIndex += 6;
    $stopIndex += 6;
  }

  unshift @newCoords, @tailCoords;
  push @newCoords, @headCoords;

  # Convert Sign of y-values of coords, record min/max
  for( my $i = 0; $i < @newCoords; $i+= 2){
    my ($x,$y) = @newCoords[$i, $i+1];
    push @args, $x, -1*$y;
    #printf ( "  $x,$y\n" );
    $x1 = min($x1, $x);
    $y1 = min($y1, $y);
    $x2 = max($x2, $x);
    $y2 = max($y2, $y);
  }

  #STDERR->printf ( "createEdge: $n1->$n2 ($x1,$y1) ($x2,$y2)\n" );
  if ( $drawArrows->{s} &&
       $drawArrows->{e} &&
       (not defined $arrowhead) &&
       (not defined $arrowtail) ) { # two-sided arrow
    push @args, -arrow => 'both';
  }
  elsif ( $drawArrows->{e} &&
	  (not defined $arrowhead) ) { # arrow just at the end
    push @args, -arrow => 'last';	
  }
  elsif ( $drawArrows->{s} &&
	  (not defined $arrowtail) ) { # arrow just at the start
    push @args, -arrow => 'first';	
  }

  my $color = $attrs{color};

  foreach my $style ( split(/,/, $attrs{style}||'') ) {
    if ( $style eq 'dashed' ) {
      push @args, -dash => '--';
    }
    elsif ( $style eq 'dotted' ) {
      push @args, -dash => ',';
    }
    elsif ( $style =~ /setlinewidth\((\d+)\)/ ) {
      push @args, -width => "$1";
    }
    elsif ( $style =~ /invis/ ) {
      # invisible edge, make same as background
      $color = $self->cget('-background');
    }
  }

  push @args, -fill => ( $self->_tryColor($color) || 'black' );

  # Create the line
  $self->createLine ( @args, -smooth => 1, -tags => $tags );

  # Create the arrowhead (at end of line)
  if ( defined($arrowhead) && $arrowhead =~ /^(.*)dot$/ ) {
    my $modifier = $1;

    # easy implementation for calculating the arrow position
    my ($x1, $y1) = @newCoords[(@newCoords-2), (@newCoords-1)];
    my ($x2, $y2) = @newCoords[(@newCoords-4), (@newCoords-3)];
    my $x = ($x1 + $x2)/2;
    my $y = ($y1 + $y2)/2;
    my @args = ($x-4, -1*($y-4), $x+4, -1*($y+4));

    # check for modifiers
    if ($modifier eq "o") {
      push @args, -fill => $self->cget('-background');
    } else {
      push @args, -fill => ($self->_tryColor($color) || 'black');
    }

    # draw
    $self->createOval ( @args );
  }

  # Create the arrowtail (at start of line)
  if ( defined($arrowtail) && $arrowtail =~ /^(.*)dot$/ ) {
    my $modifier = $1;

    # easy implementation for calculating the arrow position
    my ($x1, $y1) = @newCoords[0, 1];
    my ($x2, $y2) = @newCoords[2, 3];
    my $x = ($x1 + $x2)/2;
    my $y = ($y1 + $y2)/2;
    my @args = ($x-4, -1*($y-4), $x+4, -1*($y+4));

    # check for modifiers
    if ($modifier eq "o") {
      push @args, -fill => $self->cget('-background');
    } else {
      push @args, -fill => ($self->_tryColor($color) || 'black');
    }

    # draw
    $self->createOval ( @args );
  }

  # Create optional label
  my $label = $attrs{label};
  my $lp = $attrs{lp};
  if ( defined($label) && defined($lp) ) {
    $label =~ s/\\n/\n/g;
    $tags->[0] = 'edgelabel'; # Replace 'edge' w/ 'edgelabel'
    my ($x,$y) = split(/,/, $lp);
    my @args = ( $x, -1*$y, -text => $label, -tags => $tags,
                 -justify => 'center' );
    push @args, ( -state => 'disabled' );
    $self->createText ( @args );
  }
}


######################################################################
# Parse the coordinates for an edge from the 'pos' string
#
######################################################################
sub _parseEdgePos
{
  my ($self, $pos) = @_;

  # Note: Arrows can be at the start and end, i.e.
  #    pos =  s,410,104 e,558,59 417,98 ...
  #      (See example graph 'graphs/directed/ldbxtried.dot')

  # hash of start/end coords
  # Example: e => [ 12, 3 ], s = [ 1, 3 ]
  my %drawArrows;

  # Process all start/end points (could be none, 1, or 2)
  while ( $pos =~ s/^([se])\s*\,\s*([\d.e\+]+)\s*\,\s*([\d.e\+]+)\s+// ) {
    my ($where, $x, $y) = ($1, $2, $3);
    $drawArrows{$where} = [ $x, $y ];
  }

  my @loc = split(/ |,/, $pos);
  my @coords;
  while ( @loc >= 2 ) {
    my ($x,$y) = splice(@loc,0,2);
    push @coords, [$x,$y];
  }
  unshift(@coords, $drawArrows{s}), $drawArrows{s} = 1 if $drawArrows{s};
  push(@coords, $drawArrows{e}), $drawArrows{e} = 1 if $drawArrows{e};

  (\%drawArrows, @coords);
}


######################################################################
# Sub to make points on a curve, based on Bezier control points
#  Inputs:
#   $controlPoints: Array of control points (x/y P0,1,2,3)
#   $tinc:  Increment to use for t (t = 0 to 1 )
#   $lastFlag: Flag = 1 to generate the last point (where t = 1)
#
#  Output;
#   @outputPoints: Array of points along the bezier curve
#
#  Equations used
#Found Bezier Equations at http://pfaedit.sourceforge.net/bezier.html
#
#	A cubic Bezier curve may be viewed as:
#	x = ax*t3 + bx*t2 + cx*t +dx
#	 y = ay*t3 + by*t2 + cy*t +dy
#
#	Where
#
#	dx = P0.x
#	dy = P0.y
#	cx = 3*P1.x-3*P0.x
#	cy = 3*P1.y-3*P0.y
#	bx = 3*P2.x-6*P1.x+3*P0.x
#	by = 3*P2.y-6*P1.y+3*P0.y
#	ax = P3.x-3*P2.x+3*P1.x-P0.x
#	ay = P3.y-3*P2.y+3*P1.y-P0.y
######################################################################
sub _bezierInterpolate
{
  my ($self,$controlPoints, $tinc, $lastFlag) = @_;

  # interpolation constants
  my ($ax,$bx,$cx,$dx);
  my ($ay,$by,$cy,$dy);

  $dx =    $controlPoints->[0];
  $cx =  3*$controlPoints->[2] - 3*$controlPoints->[0];
  $bx =  3*$controlPoints->[4] - 6*$controlPoints->[2] + 3*$controlPoints->[0];
  $ax = (  $controlPoints->[6] - 3*$controlPoints->[4] + 3*$controlPoints->[2]
	   - $controlPoints->[0] );

  $dy =    $controlPoints->[1];
  $cy =  3*$controlPoints->[3] - 3*$controlPoints->[1];
  $by =  3*$controlPoints->[5] - 6*$controlPoints->[3] + 3*$controlPoints->[1];
  $ay = (  $controlPoints->[7] - 3*$controlPoints->[5] + 3*$controlPoints->[3]
	   - $controlPoints->[1] );

  my @outputPoints;
  for( my $t=0; $t <= 1; $t+=$tinc ){
    # don't do the last point unless lastflag set
    next if($t == 1 && !$lastFlag);

    # Compute X point
    push @outputPoints, ($ax*$t**3 + $bx*$t**2 + $cx*$t +$dx);

    # Compute Y point
    push @outputPoints, ($ay*$t**3 + $by*$t**2 + $cy*$t +$dy);
  }

  return @outputPoints;
}


######################################################################
# Update scroll region to new bounds, to encompass
# the entire contents of the canvas
######################################################################
sub _updateScrollRegion
{
  my ($self) = @_;

  # Ignore passed in in bbox, get a new one
  my ($x1,$y1,$x2,$y2) = $self->bbox('all');
  return 0 unless defined $x1;

  # Set canvas size from graph bounding box
  my $m = 0;#$self->{margin};
  $self->configure ( -scrollregion => [ $x1-$m, $y1-$m, $x2+$m, $y2+$m ],
		     -confine => 1 );

  # Reset original scale factor
  $self->{_scaled} = 1.0;

  1;
}


######################################################################
# Update the scale factor
#
# Called by operations that do scaling
######################################################################
sub _scaleAndMoveView
{
  my ($self, $scale, $x, $y) = @_;

  $self->scale ( 'all' => 0, 0, $scale, $scale );
  my $new_scaled = $self->{_scaled} * $scale;
  #STDERR->printf ( "\nscaled: %s -> %s\n",
  #		       $self->{_scaled}, $new_scaled );

  # Scale the fonts:
  my $fonts = $self->{fonts};
  #print "new_scaled = $new_scaled\n";
  foreach my $fontName ( keys %$fonts ) {
    my $font = $fonts->{$fontName}{font};
    my $origSize = $fonts->{$fontName}{origSize};

    # Flag to indicate size is negative (i.e. specified in pixels)
    my $negativeSize = $origSize < 0 ? -1 : 1;
    $origSize = abs($origSize); # Make abs value for finding scale

    # Fonts can't go below size 2, or they suddenly jump up to size 6...
    my $newSize = max(2,int( $origSize*$new_scaled + 0.5));

    $newSize *= $negativeSize;

    $font->configure ( -size => $newSize );
    #print "Font '$fontName' Origsize = $origSize, newsize $newSize, actual size ".$font->actual(-size)."\n";
  }

  $self->{_scaled} = $new_scaled;

  # Reset scroll region
  my @sr = $self->cget( '-scrollregion' );
  my $sr = \@sr;
  if ( @sr == 1 ) { $sr = $sr[0]; }
  $_ *= $scale foreach ( @$sr );
  $self->configure ( -scrollregion => $sr );

  # Change the view to center on correct area
  # $x and $y are expected to be coords in the pre-scaled system
  my ($left, $right) = $self->xview;
  my ($top, $bot) = $self->yview;
  my $xpos = ($x*$scale-$sr->[0])/($sr->[2]-$sr->[0]) - ($right-$left)/2.0;
  my $ypos = ($y*$scale-$sr->[1])/($sr->[3]-$sr->[1]) - ($bot-$top)/2.0;
  $self->xview( moveto => $xpos );
  $self->yview( moveto => $ypos );

  #($left, $right) = $self->xview;
  #($top, $bot) = $self->yview;
  #STDERR->printf( "scaled: midx=%s midy=%s\n",
  #		  ($left+$right)/2.0, ($top+$bot)/2.0 );
  1;
}


######################################################################
# Setup some standard bindings.
#
# This enables some standard useful functionality for scrolling,
# zooming, etc.
#
# The bindings need to interfere as little as possible with typical
# bindings that might be employed in an application using this
# widget (e.g. Button-1).
#
# Also, creating these bindings (by calling this method) is strictly
# optional.
######################################################################
sub createBindings
{
  my ($self, %opt) = @_;

  if ( scalar(keys %opt) == 0 # Empty options list
       || defined $opt{'-default'} && $opt{'-default'} ) {

    # Default zoom bindings
    $opt{'-zoom'} = 1;

    # Default scroll bindings
    $opt{'-scroll'} = 1;

    # Key-pad bindings
    $opt{'-keypad'} = 1;
  }

  if ( defined $opt{'-zoom'} ) {
    $self->_createZoomBindings( %opt );
  }

  if ( defined $opt{'-scroll'} ) {
    $self->_createScrollBindings( %opt );
  }

  if ( defined $opt{'-keypad'} ) {
    $self->_createKeypadBindings( %opt );
  }
  $self;
}


######################################################################
# Setup bindings for zooming operations
#
# These are bound to a specific mouse button and optional modifiers.
# - To zoom in: drag out a box from top-left/right to bottom-right/left
#   enclosing the new region to display
# - To zoom out: drag out a box from bottom-left/right to top-right/left.
#   size of the box determines zoom out factor.
######################################################################
sub _createZoomBindings
{
  my ($self, %opt) = @_;

  # Interpret zooming options

  # What mouse button + modifiers starts zoom?
  my $zoomSpec = $opt{'-zoom'};
  die __PACKAGE__.": No -zoom option" unless defined $zoomSpec;
  if ( $zoomSpec =~ /^\<.+\>$/ ) {
    # This should be a partial bind event spec, e.g. <1>, or <Shift-3>
    # -- it must end in a button number
    die __PACKAGE__.": Illegal -zoom option"
      unless ( $zoomSpec =~ /^\<.+\-\d\>$/ ||
	       $zoomSpec =~ /^\<\d\>$/ );
  }
  else {
    # Anything else: use the default
    $zoomSpec = '<Shift-2>';
  }

  # Color for zoom rect
  my $zoomColor = $opt{'-zoomcolor'} || 'red';

  # Initial press starts drawing zoom rect
  my $startEvent = $zoomSpec;
  $startEvent =~ s/(\d\>)$/ButtonPress-$1/;
  #STDERR->printf ( "startEvent = $startEvent\n" );
  $self->Tk::bind ( $startEvent => sub { $self->_startZoom ( $zoomSpec,
							     $zoomColor ) });
}


######################################################################
# Called whenever a zoom event is started.  This creates the initial
# zoom rectangle, and installs (temporary) bindings for mouse motion
# and release to drag out the zoom rect and then compute the zoom
# operation.
#
# The motion / button release bindings have to be installed temporarily
# so they don't conflict with other bindings (such as for scrolling
# or panning).  The original bindings for those events have to be
# restored once the zoom operation is completed.
######################################################################
sub _startZoom
{
  my ($self, $zoomSpec, $zoomColor) = @_;

  # Start of the zoom rectangle
  my $x = $self->canvasx ( $Tk::event->x );
  my $y = $self->canvasy ( $Tk::event->y );
  my @zoomCoords = ( $x, $y, $x, $y );
  my $zoomRect = $self->createRectangle 
    ( @zoomCoords, -outline => $zoomColor );

  # Install the Motion binding to drag out the rectangle -- store the
  # origin binding.
  my $dragEvent = '<Motion>';
  #STDERR->printf ( "dragEvent = $dragEvent\n" );
  my $origDragBind = $self->Tk::bind ( $dragEvent );
  $self->Tk::bind ( $dragEvent => sub {
		      $zoomCoords[2] = $self->canvasx ( $Tk::event->x );
		      $zoomCoords[3] = $self->canvasy ( $Tk::event->y );
		      $self->coords ( $zoomRect => @zoomCoords );
		    } );

  # Releasing button finishes zoom rect, and causes zoom to happen.
  my $stopEvent = $zoomSpec;
  $stopEvent =~ s/^\<.*(\d\>)$/<ButtonRelease-$1/;
  #STDERR->printf ( "stopEvent = $stopEvent\n" );
  my $threshold = 10;
  my $origStopBind = $self->Tk::bind ( $stopEvent );
  $self->Tk::bind ( $stopEvent => sub {
		      # Delete the rect
		      $self->delete ( $zoomRect );

		      # Restore original bindings
		      $self->Tk::bind ( $dragEvent => $origDragBind );
		      $self->Tk::bind ( $stopEvent => $origStopBind );

		      # Was the rectangle big enough?
		      my $dx = $zoomCoords[2] - $zoomCoords[0];
		      my $dy = $zoomCoords[3] - $zoomCoords[1];

		      return if ( abs($dx) < $threshold ||
				  abs($dy) < $threshold );

		      # Find the zooming factor
		      my $zx = $self->width() / abs($dx);
		      my $zy = $self->height() / abs($dy);
		      my $scale = min($zx, $zy);

		      # Zoom in our out?
		      # top->bottom drag means out,
		      # bottom->top drag means in.
		      # (0,0) is top left, so $dy > 0 means top->bottom
		      if ( $dy > 0 ) {
			# Zooming in!
			#STDERR->printf ( "Zooming in: $scale\n" );
		      } else {
			# Zooming out!
			$scale = 1 - 1.0 / $scale;
			#STDERR->printf ( "Zooming out: $scale\n" );
		      }

		      # Scale everying up / down
		      $self->_scaleAndMoveView
			( $scale,
			  ($zoomCoords[0]+$zoomCoords[2])/2.0,
			  ($zoomCoords[1]+$zoomCoords[3])/2.0 );
		    });

  1;
}


######################################################################
# Setup bindings for scrolling / panning operations
#
######################################################################
sub _createScrollBindings
{
  my ($self, %opt) = @_;

  # Interpret scrolling options

  # What mouse button + modifiers starts scroll?
  my $scrollSpec = $opt{'-scroll'};
  die __PACKAGE__.": No -scroll option" unless defined $scrollSpec;
  if ( $scrollSpec =~ /^\<.+\>$/ ) {
    # This should be a partial bind event spec, e.g. <1>, or <Shift-3>
    # -- it must end in a button number
    die __PACKAGE__.": Illegal -scroll option"
      unless ( $scrollSpec =~ /^\<.+\-\d\>$/ ||
	       $scrollSpec =~ /^\<\d\>$/ );
  }
  else {
    # Anything else: use the default
    $scrollSpec = '<2>';
  }

  # Initial press starts panning
  my $startEvent = $scrollSpec;
  $startEvent =~ s/(\d\>)$/ButtonPress-$1/;
  #STDERR->printf ( "startEvent = $startEvent\n" );
  $self->Tk::bind ( $startEvent => sub { $self->_startScroll 
					   ( $scrollSpec ) } );
}


######################################################################
# Called whenever a scroll event is started.  This installs (temporary)
# bindings for mouse motion and release to complete the scrolling.
#
# The motion / button release bindings have to be installed temporarily
# so they don't conflict with other bindings (such as for zooming)
# The original bindings for those events have to be restored once the
# zoom operation is completed.
######################################################################
sub _startScroll
{
  my ($self, $scrollSpec) = @_;

  # State data to keep track of scroll operation
  my $startx = $self->canvasx ( $Tk::event->x );
  my $starty = $self->canvasy ( $Tk::event->y );

  # Dragging causes scroll to happen
  my $dragEvent = '<Motion>';
  #STDERR->printf ( "dragEvent = $dragEvent\n" );
  my $origDragBind = $self->Tk::bind ( $dragEvent );
  $self->Tk::bind ( $dragEvent => sub {
		      my $x = $self->canvasx ( $Tk::event->x );
		      my $y = $self->canvasy ( $Tk::event->y );

		      # Compute scroll ammount
		      my $dx = $x - $startx;
		      my $dy = $y - $starty;
		      #STDERR->printf ( "Scrolling: dx=$dx, dy=$dy\n" );

                      # Feels better is scroll speed is reduced.
		      # Also is more natural inverted, feeld like dragging
		      # the canvas
                      $dx *= -.9;
                      $dy *= -.9;

                      my ($xv) = $self->xview();
                      my ($yv) = $self->yview();
		      my @sr = $self->cget( '-scrollregion' );
                      #STDERR->printf ( "  xv=$xv, yv=$yv\n" );
                      my $xpct = $xv + $dx/($sr[2]-$sr[0]);
                      my $ypct = $yv + $dy/($sr[3]-$sr[1]);
                      #STDERR->printf ( "  xpct=$xpct, ypct=$ypct\n" );
                      $self->xview ( moveto => $xpct );
                      $self->yview ( moveto => $ypct );

		      # This is the new reference point for
		      # next motion event
		      $startx = $x;
		      $starty = $y;
                      #STDERR->printf ( "  scrolled\n" );

		    } );

  # Releasing button finishes scrolling
  my $stopEvent = $scrollSpec;
  $stopEvent =~ s/^\<.*(\d\>)$/<ButtonRelease-$1/;
  #STDERR->printf ( "stopEvent = $stopEvent\n" );
  my $origStopBind = $self->Tk::bind ( $stopEvent );
  $self->Tk::bind ( $stopEvent => sub {

		      # Restore original bindings
		      $self->Tk::bind ( $dragEvent => $origDragBind );
		      $self->Tk::bind ( $stopEvent => $origStopBind );

		    } );

  1;
}


######################################################################
# Setup bindings for keypad keys to do zooming and scrolling
#
# This binds +/- on the keypad to zoom in and out, and the arrow/number
# keys to scroll.
######################################################################
sub _createKeypadBindings
{
  my ($self, %opt) = @_;

  $self->Tk::bind ( '<KeyPress-KP_Add>' =>
		  sub { $self->zoom( -in => 1.15 ) } );
  $self->Tk::bind ( '<KeyPress-KP_Subtract>' =>
		  sub { $self->zoom( -out => 1.15 ) } );

  $self->Tk::bind ( '<KeyPress-KP_1>' =>
		  sub { $self->xview( scroll => -1, 'units' );
			$self->yview( scroll => 1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_2>' =>
		  sub { $self->yview( scroll => 1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_3>' =>
		  sub { $self->xview( scroll => 1, 'units' );
			$self->yview( scroll => 1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_4>' =>
		  sub { $self->xview( scroll => -1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_6>' =>
		  sub { $self->xview( scroll => 1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_7>' =>
		  sub { $self->xview( scroll => -1, 'units' );
			$self->yview( scroll => -1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_8>' =>
		  sub { $self->yview( scroll => -1, 'units' ) } );
  $self->Tk::bind ( '<KeyPress-KP_9>' =>
		  sub { $self->xview( scroll => 1, 'units' );
			$self->yview( scroll => -1, 'units' ) } );

  1;
}


#######################################################################
## Setup binding for 'fit' operation
##
## 'fit' scales the entire contents of the graph to fit within the
## visible portion of the canvas.
#######################################################################
#sub _createFitBindings
#{
#  my ($self, %opt) = @_;
#
#  # Interpret options
#
#  # What event to bind to?
#  my $fitEvent = $opt{'-fit'};
#  die __PACKAGE__.": No -fit option" unless defined $fitEvent;
#  if ( $fitEvent =~ /^\<.+\>$/ ) {
#    die __PACKAGE__.": Illegal -fit option"
#      unless ( $fitEvent =~ /^\<.+\>$/ );
#  }
#  else {
#    # Anything else: use the default
#    $fitEvent = '<Key-f>';
#  }
#
#  STDERR->printf ( "fit event = $fitEvent\n" );
#  $self->Tk::bind ( $fitEvent => sub { $self->fit( 'all' ) });
#  1;
#}


######################################################################
# Scale the graph to fit within the canvas
#
######################################################################
sub fit
{
  my ($self, $idOrTag) = @_;
  $idOrTag = 'all' unless defined $idOrTag;

  my $w = $self->width();
  my $h = $self->height();
  my ($x1,$y1,$x2,$y2) = $self->bbox( $idOrTag );
  return 0 unless ( defined $x1 && defined $x2 &&
		    defined $y1 && defined $y2 );

  my $dx = abs($x2 - $x1);
  my $dy = abs($y2 - $y1);

  my $scalex = $w / $dx;
  my $scaley = $h / $dy;
  my $scale = min ( $scalex, $scaley );
  if ( $scalex >= 1.0 && $scaley >= 1.0 ) {
    $scale = max ( $scalex, $scaley );
  }

  $self->_scaleAndMoveView ( $scale, 0, 0 );
  $self->xview( moveto => 0 );
  $self->yview( moveto => 0 );

  1;
}


######################################################################
# Zoom in or out, keep top-level centered.
#
######################################################################
sub zoom
{
  my ($self, $dir, $scale) = @_;

  if ( $dir eq '-in' ) {
    # Make things bigger
  }
  elsif ( $dir eq '-out' ) {
    # Make things smaller
    $scale = 1 / $scale;
  }

  my ($xv1,$xv2) = $self->xview();
  my ($yv1,$yv2) = $self->yview();
  my $xvm = ($xv2 + $xv1)/2.0;
  my $yvm = ($yv2 + $yv1)/2.0;
  die "Empty scrollregion - have you called this before show?"
    unless my @sr = $self->cget( -scrollregion );
  my ($l, $t, $r, $b) = @sr;

  $self->_scaleAndMoveView ( $scale,
			     $l + $xvm *($r - $l),
			     $t + $yvm *($b - $t) );

  1;
}


sub zoomTo
{
  my ($self, $tagOrId) = @_;

  $self->fit();

  my @bb = $self->bbox( $tagOrId );
  return unless @bb == 4 && defined($bb[0]);

  my $w = $bb[2] - $bb[0];
  my $h = $bb[3] - $bb[1];
  my $scale = 2;
  my $x1 = $bb[0] - $scale * $w;
  my $y1 = $bb[1] - $scale * $h;
  my $x2 = $bb[2] + $scale * $w;
  my $y2 = $bb[3] + $scale * $h;

  #STDERR->printf("zoomTo:  bb = @bb\n".
  #		 "         w=$w h=$h\n".
  #		 "         x1,$y1, $x2,$y2\n" );

  $self->zoomToRect( $x1, $y1, $x2, $y2 );
}


sub zoomToRect
{
  my ($self, @box) = @_;

  # make sure x1,y1 = lower left, x2,y2 = upper right
  ($box[0],$box[2]) = ($box[2],$box[0]) if $box[2] < $box[0];
  ($box[1],$box[3]) = ($box[3],$box[1]) if $box[3] < $box[1];

  # What is the scale relative to current bounds?
  my ($l,$r) = $self->xview;
  my ($t,$b) = $self->yview;
  my $curr_w = $r - $l;
  my $curr_h = $b - $t;

  my @sr = $self->cget( -scrollregion );
  my $sr_w = $sr[2] - $sr[0];
  my $sr_h = $sr[3] - $sr[1];
  my $new_l = max(0.0,$box[0] / $sr_w);
  my $new_t = max(0.0,$box[1] / $sr_h);
  my $new_r = min(1.0,$box[2] / $sr_w);
  my $new_b = min(1.0,$box[3] / $sr_h);

  my $new_w = $new_r - $new_l;
  my $new_h = $new_b - $new_t;

  my $scale = max( $curr_w/$new_w, $curr_h/$new_h );

  $self->_scaleAndMoveView( $scale,
			    ($box[0] + $box[2])/2.0,
			    ($box[1] + $box[3])/2.0 );

  1;
}

sub _findNode {
  my ($self, $node) = @_;
  return if !defined $node or !length $node;
  my @f = $self->find(withtag => "outermost&&node=$node");
  return if @f != 1;
  $f[0];
}

sub scrollTo {
  my ($self, $node) = @_;
  return if !defined(my $id = $self->_findNode($node));
  my @c = $self->coords($id);
  $self->_centerView(@c);
}

sub _centerView {
  my ($self, $x, $y) = @_;
  my @xview = $self->xview;
  my @yview = $self->yview;
  my $xwidth = $xview[1]-$xview[0];
  my $ywidth = $yview[1]-$yview[0];
  my @scrollregion = @{$self->cget(-scrollregion)};
  my ($tox, $toy);
  if (!defined $x || !defined $y) {
    ($tox, $toy) = (0.5, 0.5);
  } else {
    $tox = ($x-$scrollregion[0])/($scrollregion[2]-$scrollregion[0])
      - $xwidth/2;
    $toy = ($y-$scrollregion[1])/($scrollregion[3]-$scrollregion[1])
      - $ywidth/2;
  }
  $self->xview('moveto' => $tox);
  $self->yview('moveto' => $toy);
}

sub nodes {
  my ($self) = @_;
  map /^node=(.*)/, map $self->gettags($_), $self->find(withtag => "outermost&&node");
}

sub edges {
  my ($self) = @_;
  map {
    my %tags_h = map split(/=/, $_, 2), grep /^node\d+=/, $self->gettags($_);
    [ map $tags_h{"node$_"}, 1..keys %tags_h ];
  } $self->find ( withtag => 'edge' );
}

######################################################################
# Over-ridden createText Method
#
# Handles the embedded \l\r\n graphViz control characters
######################################################################
sub createText
{
  my ($self, $x, $y, %attrs) = @_;
  if( defined($attrs{-text}) ) {
    %attrs = (%attrs, _label2attrs($attrs{-text}));
    # Fix the label tag, if there is one
    if( defined(my $tags = $attrs{-tags})){
      my ($label) = map /^label=(.*)/, @$tags;
      if (defined $label) {
        $label = $attrs{-text};
        $attrs{-tags} = ["label=$label", grep !/^label=/, @$tags];
      }
    }
    $attrs{-font} = $self->_defaultFont unless defined $attrs{-font};
  }
  $self->SUPER::createText ( $x, $y, %attrs );
}

my %JUSTIFY = (l => 'left', n => 'center', r => 'right');
sub _label2attrs {
  my ($label) = @_;
  return if !defined $label;
  my %attrs;
  my $justify = 'center';
  $label =~ s/\\(.)/
    if (my $j = $JUSTIFY{$1}) {
      $justify = $j;
      "\n";
    } else {
      $1
    }
  /ge;
  $label =~ s/\n$//;
  $attrs{-text} = $label;
  $attrs{-justify} = $justify;
  %attrs;
}

sub _defaultFont {
  my ($self) = @_;
  my $fonts = $self->{fonts};
  return $fonts->{_default}{font} if defined $fonts->{_default}{font};
  # Create dummy item, so we can see what font is used
  my $dummyID = $self->SUPER::createText(100,25, -text => "Should never see");
  # Make a copy that we will mess with:
  my $defaultfont = $self->itemcget($dummyID,-font)->Clone;
  $fonts->{_default}{font}     = $defaultfont;
  $fonts->{_default}{origSize} = $defaultfont->actual(-size);
  # Delete the dummy item
  $self->delete($dummyID);
  $fonts->{_default}{font};
}

my $FONTSCALE = 0.7; # arbitrary
sub _getFont {
  my ($self, $family, $size) = @_;
  return $self->_defaultFont unless defined $family;
  my $fonts = $self->{fonts};
  my $key = join '-', grep defined, $family, $size;
  return $fonts->{$key}{font} if defined $fonts->{$key}{font};
  my @args = (-family => $family);
  push @args, -size => $size * $FONTSCALE if defined $size;
  my $font = $self->Font(@args)->Clone;
  $fonts->{$key}{origSize} = $font->actual(-size);
  return $fonts->{$key}{font} = $font;
}

######################################################################
#  Sub to try a color name, returns the color name if recognized
#   'black' and issues a warning if not
######################################################################
sub _tryColor
{
  my ($self,$color) = @_;

  return undef unless defined($color);

  # Special cases
  if( $color eq 'crimson' ) {
    # crimison not defined in Tk, so use GraphViz's definition
    return sprintf("#%02X%02x%02X", 246,231,220); 
  }
  elsif( $color =~ /^(-?\d+\.?\d*)\s+(-?\d+\.?\d*)\s+(-?\d+\.?\d*)\s*$/ ) {
    # three color numbers
    my($hue,$sat,$bright) = ($1,$2,$3);
    return $self->_hsb2rgb($hue,$sat,$bright);
  }

  return 'black' if !length $color; # sensible default

  # Don't check color if it is a hex rgb value
  unless( $color =~ /^\#\w+/ ) {
    my $tryColor = $color;
    $tryColor =~ s/\_//g; # get rid of any underscores
    my @rgb;
    eval { @rgb = $self->rgb($tryColor); };
    if ($@) {
      warn __PACKAGE__.": Unknown color '$color', using black instead\n";
      $color = 'black';
    } else {
      $color = $tryColor;
    }
  }

  $color;
}	


######################################################################
# Sub to convert from Hue-Sat-Brightness to RGB hex number
#
######################################################################
sub _hsb2rgb
{
  my ($self,$h,$s,$v) = @_;

  my ($r,$g,$b);
  if( $s <= 0){
    $v = int($v);
    ($r,$g,$b) = ($v,$v,$v);
  }
  else{
    if( $h >= 1){
      $h = 0;
    }
    $h = 6*$h;
    my $f = $h - int($h);
    my $p = $v * (1 - $s);
    my $q = $v * ( 1 - ($s * $f));
    my $t = $v * ( 1 - ($s * (1-$f)));
    my $i = int($h);
    if( $i == 0){	   ($r,$g,$b)  = ($v, $t, $p);}
    elsif( $i == 1){ ($r,$g,$b)  = ($q, $v, $p);}
    elsif( $i == 2){($r,$g,$b)   = ($p, $v, $t);}
    elsif( $i == 3){($r,$g,$b)   = ($p, $q, $v);}
    elsif( $i == 4){($r,$g,$b)   = ($t, $p, $v);}
    elsif( $i == 5){($r,$g,$b)   = ($v, $p, $q);}

  }

  sprintf("#%02X%02x%02X", 255*$r, 255*$g, 244*$b);
}


######################################################################
# Utility functions
######################################################################

sub min {
  no warnings 'numeric';
  if ( defined($_[0]) ) {
    if ( defined($_[1]) ) { return ($_[0] < $_[1])? $_[0] : $_[1]; }
    else { return $_[0]; }
  } else {
    if ( defined($_[1]) ) { return $_[1]; }
    else { return undef; }
  }
}

sub max {
  no warnings 'numeric';
  if ( defined($_[0]) ) {
    if ( defined($_[1]) ) { return ($_[0] > $_[1])? $_[0] : $_[1]; }
    else { return $_[0]; }
  } else {
    if ( defined($_[1]) ) { return $_[1]; }
    else { return undef; }
  }
}

__END__


=head1 NAME

Tk::GraphViz - Render an interactive GraphViz graph

=head1 SYNOPSIS

    use Tk::GraphViz;
    my $gv = $mw->GraphViz ( qw/-width 300 -height 300/ )
      ->pack ( qw/-expand yes -fill both/ );
    $gv->show ( $dotfile );

=head1 DESCRIPTION

The B<GraphViz> widget is derived from L<Tk::Canvas>.  It adds the ability to render graphs in the canvas.  The graphs can be specified either using the B<DOT> graph-description language, or using via a L<GraphViz> or L<GraphViz2> object.

When B<show()> is called, the graph is passed to the B<dot> command to generate the layout info.  That info is then used to create rectangles, lines, etc in the canvas that reflect the generated layout.

Once the items have been created in the graph, they can be used like any normal canvas items: events can be bound, etc.  In this way, interactive graphing applications can be created very easily.

=head1 METHODS

=head2 $gv->show ( graph, ?opt => val, ...? )

Renders the given graph in the canvas.  The graph itself can be specified in a number of formats.  'graph' can be one of the following:

=over 4

=item - An instance of the GraphViz class (or subclass thereof)

=item - A scalar containing a graph in DOT format.  The scalar must match /^\s*(?:di)?graph /.

=item - An instance of the IO::Handle class (or subclass thereof), from which to read a graph in DOT format.

=item - The name / path of a file that contains a graph in DOT format.

=back

show() will recognize some options that control how the graph is rendered, etc.  The recognized options:

=over 4

=item layout => CMD

Specifies an alternate command to invoke to generate the layout of the graph.  If not given, then default is 'dot'.  This can be used, for example, to use 'neato' instead of 'dot'.

=item graphattrs => [ name => value, ... ]

Allows additional default graph attributes to be specified.  Each name => value pair will be passed to dot as '-Gname=value' on the command-line.

=item nodeattrs => [ name => value, ... ]

Allows additional default node attributes to be specified.  Each name => value pair will be passed to dot as '-Nname=value' on the command-line.

=item edgeattrs => [ name => value, ... ]

Allows additional default edge attributes to be specified.  Each name => value pair will be passed to dot as '-Ename=value' on the command-line.

=item fit => $boolean

If true, calls the L<< /$gv->fit() >> method after parsing the DOT output.
As of 1.05, this no longer defaults to true.

=item prerender => \&coderef

If given, the code-ref will be called with the graph description data
before the actual drawing on a canvas begins, in a hash-ref, e.g. for
the file C<< digraph G { a -> b } >>:

  {
    edge => {
      a => {
	b => [
	  {
	    pos => [
	      { e => 1 },
	      [
		[ '27', '71.697' ],
		[ '27', '63.983' ],
		[ '27', '54.712' ],
		[ '27', '46.112' ],
		[ '27', '36.104' ],
	      ]
	    ]
	  }
	]
      }
    },
    global => { dpi => 72 }, # default value, might be overridden
    node => {
      a => { height => '0.5', label => '\\N', pos => '27,90', width => '0.75' },
      b => { height => '0.5', label => '\\N', pos => '27,18', width => '0.75' }
    },
    subgraph => [
      [ '0', '0', '54', '108' ]
    ]
  }

The code's return value needs to be a hash-ref structured similarly to
the above, which will be used to render the graph. Coordinates increase
upwards and to the right. Nodes' C<pos> are at their centre.

This feature is experimental as of 1.10, and the data-structure shape
or interface may change.

=back

For example, to use neato to generate a layout with non-overlapping nodes and spline edges:

    $gv->show ( $file, layout => 'neato',
                graphattrs => [qw( overlap false spline true )] );


=head2 $gv->createBindings ( ?option => value? )

The Tk::GraphViz canvas can be configured with some bindings for standard operations.  If no options are given, the default bindings for zooming and scrolling will be enabled.  Alternative bindings can be specified via these options:

=over 4

=item -zoom => I<true>

Creates the default bindings for zooming.  Zooming in or out in the canvas will be bound to <Shift-2> (Shift + mouse button 2).  To zoom in, click and drag out a zoom rectangle from top left to bottom right.  To zoom out, click and drag out a zoom rectangle from bottom left to top right.

=item -zoom => I<spec>

This will bind zooming to an alternative event sequence.  Examples:

    -zoom => '<1>'      # Zoom on mouse button 1
    -zoom => '<Ctrl-3>' # Zoom on Ctrl + mouse button 3

=item -scroll => I<true>

Creates the default bindings for scrolling / panning.  Scrolling the canvas will be bound to <2> (Mouse button 2).

=item -scroll => I<spec>

This will bind scrolling to an alternative event sequence.  Examples:

    -scroll => '<1>'      # Scroll on mouse button 1
    -scroll => '<Ctrl-3>' # Scroll on Ctrl + mouse button 3

=item -keypad => I<true>

Binds the keypad arrow / number keys to scroll the canvas, and the keypad +/- keys to zoom in and out.  Note that the canvas must have the keyboard focus for these bindings to be activated.  This is done by default when createBindings() is called without any options.

=back

=head2 $gv->fit()

Scales all of the elements in the canvas to fit the canvas' width and height.

=head2 $gv->zoom( -in => factor )

Zoom in by scaling everything up by the given scale factor.  The factor should be > 1.0 in order to get reasonable behavior.

=head2 $gv->zoom( -out => factor )

Zoom out by scaling everything down by the given scale factor.  This is equivalent to

    $gv->zoom ( -in => 1/factor )

The factor should be > 1.0 in order to get reasonable behavior.

=head2 $gv->scrollTo(nodename)

If the given node (identified by being tagged with C<node> and that
nodename) exists, the viewport is moved to have that at the centre.

=head2 $gv->nodes

Returns a list of the names of the graph's nodes, as identified by being
tagged with C<node>.

=head2 $gv->edges

Returns a list of the graph's edges, as identified by being tagged with
C<edge>, as array-refs with the incident nodes' names.

=head1 TAGS

In order to facilitate binding, etc, all of the graph elements (nodes,
edges, subgraphs) that are created in the canvas will be tagged.
Prior to version 1.09, this was done in pairs of tags, but that is not
how tags in Tk work: they are individual things.

Each element is composed of several parts, typically at least a shape,
and text. Each of these parts will be tagged with its element type
(e.g. C<node>), so that all of the visible area will be bindable as
such. They will also all be tagged with e.g. C<node=thisNodeName>,
for use together with C<gettags>. Only the outermost (or for a record,
the first) will be tagged with C<outermost>, so that a single part can
be found with e.g. a C<withtags "outermost&&node=thisNodeName">, such
as to find the coordinates of the whole element.

Additionally, all attributes attached to an element in the graph
description (e.g. C<color>, C<style>, C<label>) will be included as tags,
in the form e.g. C<color=red>.

=head2 Nodes

Node elements are identified with a 'node' tag.  For example, to bind
something to all nodes in a graph:

    $gv->bind ( 'node', '<Any-Enter>', sub { ... } );

=head2 Edges

Edge elements are identified with a 'edge' tag.  For example, to bind
something to all edges in a graph:

    $gv->bind ( 'edge', '<Any-Enter>', sub { ... } );

The "naming tag" will be string of the form C<edge=node1 node2>,
where node1 and node2 are the names of the respective nodes.  To make
it convenient to get the individual node names, the edge also has tags
'node1' and 'node2', which give the node names separately. Components
of edges do not have an C<outermost> tag.

=head2 Subgraphs

Subgraph elements are identified with a 'subgraph' tag.

=head1 EXAMPLES

The following example creates a GraphViz widgets to display a graph from a file specified on the command line.  Whenever a node is clicked, the node name and label are printed to stdout:

    use GraphViz;
    use Tk;

    my $mw = MainWindow->new();
    my $gv = $mw->Scrolled ( 'GraphViz',
                             -background => 'white',
                             -scrollbars => 'sw' )
      ->pack ( -expand => '1', -fill => 'both' );

    $gv->bind ( 'node', '<Button-1>', sub {
        my @tags = $gv->gettags('current');
        my ($label) = map /^label=(.*)/, @tags;
        my ($node) = map /^node=(.*)/, @tags;
        printf ( "Clicked node: '%s' => %s\n", $node, $label );
    } );

    $gv->show ( shift );
    MainLoop;


=head1 BUGS AND LIMITATIONS

Lots of DOT language features not yet implemented

=over 4

=item Various node shapes and attributes: polygon, skew, ...

=item Edge arrow head types

=back

=head1 ACKNOWLEDGEMENTS

See L<http://www.graphviz.org/> for more info on the graphviz tools.

=head1 AUTHOR

Jeremy Slade E<lt>jeremy@jkslade.netE<gt>

Other contributors:
Mike Castle,
John Cerney,
Phi Kasten,
Jogi Kuenstner
Tobias Lorenz,
Charles Minc,
Reinier Post,
Slaven Rezic

=head1 COPYRIGHT AND LICENSE

Copyright 2003-2008 by Jeremy Slade

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

