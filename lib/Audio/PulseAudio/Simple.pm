package Audio::PulseAudio::Simple;

use strict;
use warnings;
use Audio::PulseAudio;

our $VERSION = v0.0.1;

require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

sub new
{
	my ( $class, %attr ) = @_;
	$attr{name} //= $0;
	$attr{stream_name} //= "";
	my $func = $class->can( 'new_c' );
	@_ = ( $class, @attr{ qw(server name direction device stream_name sample_spec channel_map buffer_attr) } );
	goto &$func;
}

1;
