#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "pulse/simple.h"
#include "pulse/error.h"

MODULE = Audio::PulseAudio::Simple	PACKAGE = Audio::PulseAudio::Simple

PROTOTYPES: DISABLE

pa_simple *
new_c( class, server, name, direction, device, stream_name, sample_spec, channel_map = NULL, buffer_attr = NULL )
	const char *class
	const char *server
	const char *name
	UV direction
	const char *device
	const char *stream_name
	const pa_sample_spec *sample_spec
	const pa_channel_map *channel_map
	const pa_buffer_attr *buffer_attr
	CODE:
		pa_simple *self;
		int error = 0;
		self = pa_simple_new( server, name, direction, device, stream_name, sample_spec, channel_map, buffer_attr, &error );
		if ( !self )
			croak( "Failed to initialise Audio::PulseAudio::Simple: (%d): %s", error, pa_strerror( error ) );
		RETVAL = self;
	OUTPUT:
		RETVAL

int
write( self, buffer )
	pa_simple *self
	SV *buffer
	CODE:
		int error = 0;
		STRLEN bytes;
		const void *data = SvPV( buffer, bytes );
		RETVAL = pa_simple_write( self, data, bytes, &error );
		if ( error )
			croak( "Write failed (%d): %s", error, pa_strerror( error ) );
	OUTPUT:
		RETVAL

int
drain( self )
	pa_simple *self
	CODE:
		int error = 0;
		RETVAL = pa_simple_drain( self, &error );
		if ( error )
			croak( "Drain failed (%d): %s", error, pa_strerror( error ) );
	OUTPUT:
		RETVAL

int
read( self, buffer, bytes )
	pa_simple *self
	SV *buffer
	size_t bytes
	CODE:
		int error = 0;
		if ( SvPOK( buffer ) )
			SvPOK_only( buffer );
		else if ( !SvOK( buffer ) )
			SvPVCLEAR( buffer );
		else
			(void)SvPVbyte_force( buffer, PL_na );

		void *data = SvGROW( buffer, bytes );
		RETVAL = pa_simple_read( self, data, bytes, &error );
		if ( RETVAL && error )
			croak( "Read failed (%d): %s", error, pa_strerror( error ) );
		SvCUR_set( buffer, bytes );
		SvUTF8_off( buffer );
	OUTPUT:
		RETVAL

UV
get_latency( self )
	pa_simple *self
	CODE:
		int error = 0;
		RETVAL = pa_simple_get_latency( self, &error );
		if ( error )
			croak( "Get latency failed (%d): %s", error, pa_strerror( error ) );
	OUTPUT:
		RETVAL

IV
flush( self )
	pa_simple *self
	CODE:
		int error = 0;
		RETVAL = pa_simple_flush( self, &error );
		if ( error )
			croak( "Flush failed (%d): %s", error, pa_strerror( error ) );
	OUTPUT:
		RETVAL

void
DESTROY( self )
	pa_simple *self
	CODE:
		pa_simple_free( self );
