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
	const char *name;
	IV iv;
} perl_pa_const_iv_t;
#define const_iv(name) { # name, (IV)PA_ ## name }

typedef struct
{
	const char *name;
	const char *value;
	size_t len;
} perl_pa_const_pv_t;
#define const_pv(name) { # name, PA_ ## name, sizeof( PA_ ## name ) - 1 }

MODULE = Audio::PulseAudio	PACKAGE = Audio::PulseAudio

PROTOTYPES: DISABLE

BOOT:
{
	HV *stash = gv_stashpv ("Audio::PulseAudio", 1);

	static const perl_pa_const_iv_t const_iv[] = {
#include "gen/const_iv.h"
	};

	static const perl_pa_const_pv_t const_pv[] = {
#include "gen/const_pv.h"
	};

	int i;
	for ( i = 0; i < sizeof( const_iv ) / sizeof( const_iv[0] ); i++ )
		newCONSTSUB( stash, const_iv[i].name, newSViv( const_iv[i].iv ) );

	for ( i = 0; i < sizeof( const_pv ) / sizeof( const_pv[0] ); i++ )
		newCONSTSUB( stash, const_pv[i].name, newSVpvn( const_pv[i].value, const_pv[i].len ) );
}

INCLUDE: PulseAudio/BufferAttr.xs#
INCLUDE: PulseAudio/ChannelMap.xs#
INCLUDE: PulseAudio/PropList.xs#
INCLUDE: PulseAudio/SampleSpec.xs#
