package Audio::PulseAudio::BufferAttr;

use strict;
use warnings;
use Audio::PulseAudio;

sub new
{
	my ( $class, %attr ) = @_;
	return $class->new_c( @attr{ qw(maxlength tlength prebuf minreq fragsize) } );
}

1;
