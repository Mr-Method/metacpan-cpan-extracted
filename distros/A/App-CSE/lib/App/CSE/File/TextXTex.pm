package App::CSE::File::TextXTex;
$App::CSE::File::TextXTex::VERSION = '0.012';
use Moose;
extends qw/App::CSE::File::TextPlain/;

__PACKAGE__->meta->make_immutable();
