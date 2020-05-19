package Audio::PulseAudio;

use strict;
use warnings;

our $VERSION = v0.0.1;

require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

1;
