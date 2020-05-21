#!perl
#
use strict;
use warnings;

use ExtUtils::MakeMaker v7.21;

WriteMakefile(
	NAME         => 'Audio::PulseAudio',
	VERSION_FROM => 'lib/Audio/PulseAudio.pm',
	XSMULTI      => 1,
	OPTIMIZE     => '-O2 -gdwarf-2 -Wall -I.',
	LIBS         => '-lpulse -lpthread',
	XSBUILD      => {
		xs => {
			'lib/Audio/PulseAudio/Simple' => {
				LDFROM => 'lib/Audio/PulseAudio/Simple$(OBJ_EXT) -lpulse-simple'
			},
		},
	},
);
