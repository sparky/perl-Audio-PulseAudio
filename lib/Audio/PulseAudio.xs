#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "pulse/pulseaudio.h"

#define PERL_PA_SET_GET_RETVAL( field ) 					\
	STMT_START {								\
		if ( items > 1 )						\
			field = SvOK( ST(1) ) ? SvUV( ST(1) ) : -1;		\
		RETVAL = (field == -1) ? &PL_sv_undef : newSVuv( field );	\
	} STMT_END

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

INCLUDE: PulseAudio/BufferAttr.xs#
INCLUDE: PulseAudio/ChannelMap.xs#
INCLUDE: PulseAudio/SampleSpec.xs#
