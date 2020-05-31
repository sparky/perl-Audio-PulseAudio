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

__END__

=head1 NAME

Audio::PulseAudio::BufferAttr - Playback and record buffer sizes

=head1 DESCRIPTION

You can pass this object to L<Audio::PulseAudio::Simple> constructor
if you wish to overwrite pulseaudio buffering defaults.

=head1 CONSTRUCTOR

=head2 $buffer_attr = Audio::PulseAudio::BufferAttr->new( maxlength => $ml, ... );

=over

=item maxlength

Maximum length of the buffer in bytes. Setting this to C<undef>
will initialize this to the maximum value supported by server,
which is recommended.

In strict low-latency playback scenarios you might want to set this to
a lower value, likely together with the C<STREAM_ADJUST_LATENCY> flag.
If you do so, you ensure that the latency doesn't grow beyond what is
acceptable for the use case, at the cost of getting more underruns if
the latency is lower than what the server can reliably handle.

=item tlength

Playback only: target length of the buffer. The server tries
to assure that at least tlength bytes are always available in
the per-stream server-side playback buffer. The server will
only send requests for more data as long as the buffer has
less than this number of bytes of data.

It is recommended to set this to C<undef>, which will
initialize this to a value that is deemed sensible by the
server. However, this value will default to something like 2s;
for applications that have specific latency requirements
this value should be set to the maximum latency that the
application can deal with.

When C<STREAM_ADJUST_LATENCY> is not set this value will
influence only the per-stream playback buffer size. When
C<STREAM_ADJUST_LATENCY> is set the overall latency of the sink
plus the playback buffer size is configured to this value. Set
C<STREAM_ADJUST_LATENCY> if you are interested in adjusting the
overall latency. Don't set it if you are interested in
configuring the server-side per-stream playback buffer
size.

=item prebuf

Playback only: pre-buffering. The server does not start with
playback before at least prebuf bytes are available in the
buffer. It is recommended to set this to C<undef>, which
will initialize this to the same value as tlength, whatever
that may be.

Initialize to 0 to enable manual start/stop control of the stream.
This means that playback will not stop on underrun and playback
will not start automatically, instead L<stream_cork()> needs to
be called explicitly. If you set this value to 0 you should also
set C<STREAM_START_CORKED>. Should underrun occur, the read index
of the output buffer overtakes the write index, and hence the
fill level of the buffer is negative.

Start of playback can be forced using L<stream_trigger()> even
though the prebuffer size hasn't been reached. If a buffer
underrun occurs, this prebuffering will be again enabled.

=item minreq

Playback only: minimum request. The server does not request
less than minreq bytes from the client, instead waits until the
buffer is free enough to request more bytes at once. It is
recommended to set this to C<undef>, which will initialize
this to a value that is deemed sensible by the server. This
should be set to a value that gives PulseAudio enough time to
move the data from the per-stream playback buffer into the
hardware playback buffer.

=item fragsize

Recording only: fragment size. The server sends data in
blocks of fragsize bytes size. Large values diminish
interactivity with other operations on the connection context
but decrease control overhead. It is recommended to set this to
C<undef>, which will initialize this to a value that is
deemed sensible by the server. However, this value will default
to something like 2s; For applications that have specific
latency requirements this value should be set to the maximum
latency that the application can deal with.

If C<STREAM_ADJUST_LATENCY> is set the overall source latency
will be adjusted according to this value. If it is not set the
source latency is left unmodified.

=back

=head2 $buffer_attr = Audio::PulseAudio::BufferAttr->new_c( $maxlength, $tlength, $prebuf, $minreq, $fragsize )

Does the same thing, but in a less convenient manner.

=head1 METHODS

=head2 $buffer_attr->maxlength( [NEW_VALUE] );

Get or set the C<maxlength> value.

=head2 $buffer_attr->tlength( [NEW_VALUE] );

Get or set the C<tlength> value.

=head2 $buffer_attr->prebuf( [NEW_VALUE] );

Get or set the C<prebuf> value.

=head2 $buffer_attr->minreq( [NEW_VALUE] );

Get or set the C<minreq> value.

=head2 $buffer_attr->fragsize( [NEW_VALUE] );

Get or set the C<fragsize> value.

=head1 REFERENCES

L<https://freedesktop.org/software/pulseaudio/doxygen/structpa__buffer__attr.html>

=head1 AUTHOR

Iskra

=cut
