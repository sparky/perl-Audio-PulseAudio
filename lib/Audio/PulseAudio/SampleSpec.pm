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

__END__

=head1 NAME

Audio::PulseAudio::SampleSpec - Sample Format Specifications

=head1 DESCRIPTION

You need pass this object to L<Audio::PulseAudio::Simple> constructor.

=head2 Overview

PulseAudio is capable of handling a multitude of sample formats, rates
and channels, transparently converting and mixing them as needed.

=head2 Sample Format

PulseAudio supports the following sample formats:

=over

=item Audio::PulseAudio::SAMPLE_U8 - pack "C"

Unsigned 8 bit integer PCM.

=item Audio::PulseAudio::SAMPLE_S16LE - pack "s<" or "v!"

Signed 16 integer bit PCM, little endian.

=item Audio::PulseAudio::SAMPLE_S16BE - pack "s>" or "n!"

Signed 16 integer bit PCM, big endian.

=item Audio::PulseAudio::SAMPLE_FLOAT32LE - pack "f<"

32 bit IEEE floating point PCM, little endian.

=item Audio::PulseAudio::SAMPLE_FLOAT32BE - pack "f>"

32 bit IEEE floating point PCM, big endian.

=item Audio::PulseAudio::SAMPLE_ALAW

8 bit a-Law.

=item Audio::PulseAudio::SAMPLE_ULAW

8 bit mu-Law.

=item Audio::PulseAudio::SAMPLE_S32LE - pack "l<" or "V!"

Signed 32 bit integer PCM, little endian.

=item Audio::PulseAudio::SAMPLE_S32BE - pack "l>" or "N!"

Signed 32 bit integer PCM, big endian.

=item Audio::PulseAudio::SAMPLE_S24LE - pack "l<X"

Signed 24 bit integer PCM packed, little endian.

=item Audio::PulseAudio::SAMPLE_S24BE

Signed 24 bit integer PCM packed, big endian.

=item Audio::PulseAudio::SAMPLE_S24_32LE - pack "l<" or "V!"

Signed 24 bit integer PCM in LSB of 32 bit words, little endian.

=item Audio::PulseAudio::SAMPLE_S24_32BE - pack "l>" or "N!"

Signed 24 bit integer PCM in LSB of 32 bit words, big endian.

=back

The floating point sample formats have the range from -1.0 to 1.0.

The sample formats that are sensitive to endianness have convenience
macros for native endian (NE), and reverse endian (RE).

=over

=item Audio::PulseAudio::SAMPLE_S16NE - pack "s"

=item Audio::PulseAudio::SAMPLE_FLOAT32NE - pack "f"

=item Audio::PulseAudio::SAMPLE_FLOAT32 - pack "f"

=item Audio::PulseAudio::SAMPLE_S32NE - pack "l"

=item Audio::PulseAudio::SAMPLE_S24NE

=item Audio::PulseAudio::SAMPLE_S24_32NE - pack "l"

=item Audio::PulseAudio::SAMPLE_S16RE

=item Audio::PulseAudio::SAMPLE_FLOAT32RE

=item Audio::PulseAudio::SAMPLE_S32RE

=item Audio::PulseAudio::SAMPLE_S24RE

=item Audio::PulseAudio::SAMPLE_S24_32RE

=back

=head2 Sample Rates

PulseAudio supports any sample rate between 1 Hz and 192000 Hz. There is no
point trying to exceed the sample rate of the output device though as the
signal will only get downsampled, consuming CPU on the machine running the
server.

=head2 Channels

PulseAudio supports up to 32 individual channels. The order of the
channels is up to the application, but they must be continuous. To map
channels to speakers, see \ref channelmap.

=head1 CONSTRUCTOR

=head2 $sample_spec = Audio::PulseAudio::SampleSpec->new( format => $fmt, rate => $rate, channels => $channels );

Create a new sample specification object.

=over

=item format

Sample format, described above.

=item rate

The sample rate. (e.g. 44100).

=item channels

Audio channels. (1 for mono, 2 for stereo, ...)

=back

=head2 $sample_spec = Audio::PulseAudio::SampleSpec->new_c( $format, $rate, $channels );

Same, but without the argument names.

=head2 $sample_spec = Audio::PulseAudio::SampleSpec->init();

Create an empty sample specification.
The sample spec will have a defined state but
valid() will fail for it.

=head1 METHODS

=head2 $sample_spec->format( [NEW_VALUE] )

Get or set the C<format> value.

=head2 $sample_spec->rate( [NEW_VALUE] )

Get or set the C<rate> value.

=head2 $sample_spec->channels( [NEW_VALUE] )

Get or set the C<channels> value.

=head2 $bytes_per_second = $sample_spec->bytes_per_second()

Return the amount of bytes that constitute playback of one second of
audio, with the specified sample spec.

=head2 $frame_bytes = $sample_spec->frame_size()

Return the size of a frame with the specific sample type.

=head2 $sample_bytes = $sample_spec->sample_size()

Return the size of a sample with the specific sample type.

=head2 $microseconds = $sample_spec->bytes_to_usec( $bytes )

Calculate the time, in microseconds, it would take to play a buffer of
the specified size with the specified sample type. The return value will always
be rounded down for non-integral return values.

=head2 $mytes = $sample_spec->usec_to_bytes( $microseconds )

Calculates the size of a buffer required, for playback duration
of the time specified, with the specified sample type. The
return value will always be rounded down for non-integral
return values.

=head2 $sample_spec->valid()

Return true when the sample type specification is valid.

=head2 $sample_spec->equal( $other_sample_spec )

Return true when the two sample type specifications match.

=head2 $spec_name = $sample_spec->sprint()

Pretty print a sample type specification to a string. Returns a string.

=head1 FUNCTIONS

=head2 $bytes = sample_size_of_format( $format )

Similar to sample_size() but take a sample format instead of a
full sample spec.

=head2 sample_format_valid( $format )

Return true if the given integer is a valid sample format.

=head2 sample_rate_valid( $rate )

Return true if the rate is within the supported range.

=head2 $format_name = sample_format_to_string( $format )

Return a descriptive string for the specified sample format.

=head2 $format = parse_sample_format( $format_name )

Parse a sample format text. Inverse of sample_format_to_string().

=head2 $size_string = bytes_sprint( $bytes )

Pretty print a byte value (e.g. "2.5 MiB").

=head2 sample_format_is_le( $format )

Returns 1 when the specified format is little endian, 0 when
big endian. Returns -1 when endianness does not apply to the
specified format, or endianess is unknown.

=head2 sample_format_is_be( $format )

Returns 1 when the specified format is big endian, 0 when
little endian. Returns -1 when endianness does not apply to the
specified format, or endianess is unknown.

=head2 sample_format_is_ne( $format )

Returns 1 when the specified format is native endian, 0 when
not. Returns -1 when endianness does not apply to the
specified format, or endianess is unknown.

=head2 sample_format_is_re( $format )

Returns 1 when the specified format is reverse endian, 0 when
native. Returns -1 when endianness does not apply to the
specified format, or endianess is unknown.

=head1 REFERENCES

L<https://freedesktop.org/software/pulseaudio/doxygen/sample.html>

=head1 AUTHOR

Iskra

=cut
