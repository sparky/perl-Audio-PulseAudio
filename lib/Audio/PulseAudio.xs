#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "pulse/pulseaudio.h"

typedef struct
{
	IV iv;
	const char *name;
} perl_pa_const_iv_t;
#define const_iv(name) { (IV)PA_ ## name, # name }

MODULE = Audio::PulseAudio	PACKAGE = Audio::PulseAudio

PROTOTYPES: DISABLE

BOOT:
{
	HV *stash = gv_stashpv ("Audio::PulseAudio", 1);

	static const perl_pa_const_iv_t const_iv[] = {
#include "gen/const_iv.h"
	};

	int i;
	for ( i = 0; i < sizeof( const_iv ) / sizeof( const_iv[0] ); i++ )
		newCONSTSUB( stash, const_iv[i].name, newSViv( const_iv[i].iv ) );
}

INCLUDE: PulseAudio/BufferAttr.xsi
INCLUDE: PulseAudio/SampleSpec.xsi
