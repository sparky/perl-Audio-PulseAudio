package Audio::PulseAudio::SampleSpec;

use strict;
use warnings;
use Audio::PulseAudio;

sub new
{
	my ( $class, %attr ) = @_;
	$attr{rate} //= 44100;
	$attr{channels} //= 2;
	return $class->new_c( @attr{ qw(format rate channels) } );
}

1;
