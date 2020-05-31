package Audio::PulseAudio::ChannelMap;

use strict;
use warnings;
use Audio::PulseAudio;


1;

__END__

=head1 NAME

Audio::PulseAudio::ChannelMap - Remap channels for the data stream

=head1 DESCRIPTION

Optional when creating a stream object.

=head2 Overview

Channel maps provide a way to associate channels in a stream with a
specific speaker position. This relieves applications of having to
make sure their channel order is identical to the final output.

=head2 Channel Labels

=over

=item Audio::PulseAudio::CHANNEL_POSITION_INVALID

=item Audio::PulseAudio::CHANNEL_POSITION_MONO

=item Audio::PulseAudio::CHANNEL_POSITION_LEFT

=item Audio::PulseAudio::CHANNEL_POSITION_RIGHT

=item Audio::PulseAudio::CHANNEL_POSITION_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_FRONT_LEFT

=item Audio::PulseAudio::CHANNEL_POSITION_FRONT_RIGHT

=item Audio::PulseAudio::CHANNEL_POSITION_FRONT_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_REAR_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_REAR_LEFT

=item Audio::PulseAudio::CHANNEL_POSITION_REAR_RIGHT

=item Audio::PulseAudio::CHANNEL_POSITION_LFE

=item Audio::PulseAudio::CHANNEL_POSITION_SUBWOOFER

=item Audio::PulseAudio::CHANNEL_POSITION_FRONT_LEFT_OF_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_FRONT_RIGHT_OF_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_SIDE_LEFT

=item Audio::PulseAudio::CHANNEL_POSITION_SIDE_RIGHT

=item Audio::PulseAudio::CHANNEL_POSITION_AUX0

=item Audio::PulseAudio::CHANNEL_POSITION_AUX1

=item Audio::PulseAudio::CHANNEL_POSITION_AUX2

=item Audio::PulseAudio::CHANNEL_POSITION_AUX3

=item Audio::PulseAudio::CHANNEL_POSITION_AUX4

=item Audio::PulseAudio::CHANNEL_POSITION_AUX5

=item Audio::PulseAudio::CHANNEL_POSITION_AUX6

=item Audio::PulseAudio::CHANNEL_POSITION_AUX7

=item Audio::PulseAudio::CHANNEL_POSITION_AUX8

=item Audio::PulseAudio::CHANNEL_POSITION_AUX9

=item Audio::PulseAudio::CHANNEL_POSITION_AUX10

=item Audio::PulseAudio::CHANNEL_POSITION_AUX11

=item Audio::PulseAudio::CHANNEL_POSITION_AUX12

=item Audio::PulseAudio::CHANNEL_POSITION_AUX13

=item Audio::PulseAudio::CHANNEL_POSITION_AUX14

=item Audio::PulseAudio::CHANNEL_POSITION_AUX15

=item Audio::PulseAudio::CHANNEL_POSITION_AUX16

=item Audio::PulseAudio::CHANNEL_POSITION_AUX17

=item Audio::PulseAudio::CHANNEL_POSITION_AUX18

=item Audio::PulseAudio::CHANNEL_POSITION_AUX19

=item Audio::PulseAudio::CHANNEL_POSITION_AUX20

=item Audio::PulseAudio::CHANNEL_POSITION_AUX21

=item Audio::PulseAudio::CHANNEL_POSITION_AUX22

=item Audio::PulseAudio::CHANNEL_POSITION_AUX23

=item Audio::PulseAudio::CHANNEL_POSITION_AUX24

=item Audio::PulseAudio::CHANNEL_POSITION_AUX25

=item Audio::PulseAudio::CHANNEL_POSITION_AUX26

=item Audio::PulseAudio::CHANNEL_POSITION_AUX27

=item Audio::PulseAudio::CHANNEL_POSITION_AUX28

=item Audio::PulseAudio::CHANNEL_POSITION_AUX29

=item Audio::PulseAudio::CHANNEL_POSITION_AUX30

=item Audio::PulseAudio::CHANNEL_POSITION_AUX31

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_FRONT_LEFT

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_FRONT_RIGHT

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_FRONT_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_REAR_LEFT

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_REAR_RIGHT

=item Audio::PulseAudio::CHANNEL_POSITION_TOP_REAR_CENTER

=item Audio::PulseAudio::CHANNEL_POSITION_MAX

=back

=head1 CONSTRUCTOR

=head2 $channel_map = Audio::PulseAudio::ChannelMap->new( [CHANNEL1_POSITION], [CHANNEL2_POSITION], ... )

Create and initialise a new channel map with the given positions.

=head2 $channel_map = Audio::PulseAudio::ChannelMap->init

Create and initialise an empty channel map. The channel map will have a defined
state but valid() will fail for it.

=head2 $channel_map = Audio::PulseAudio::ChannelMap->init_mono

Create and initialize the channel map for monaural audio.

=head2 $channel_map = Audio::PulseAudio::ChannelMap->init_stereo

Create and initialize the channel map for stereophonic audio.

=head2 $channel_map = Audio::PulseAudio::ChannelMap->init_auto( $channels, $def )

Create and initialize the channel map for the specified number of
channels using default labels and return a pointer to it. This call
will fail (return C<undef>) if there is no default channel map known for this
specific number of channels and mapping.

=head2 $channel_map = Audio::PulseAudio::ChannelMap->init_extend( $channels, $def )

Similar to init_auto() but instead of failing if no
default mapping is known with the specified parameters it will
synthesize a mapping based on a known mapping with fewer channels
and fill up the rest with AUX0...AUX31 channels.

Channel map definition can be one of:

=over

=item Audio::PulseAudio::CHANNEL_MAP_AIFF

The mapping from RFC3551, which is based on AIFF-C.

=item Audio::PulseAudio::CHANNEL_MAP_ALSA

The default mapping used by ALSA. This mapping is probably
not too useful since ALSA's default channel mapping depends on
the device string used.

=item Audio::PulseAudio::CHANNEL_MAP_AUX

Only aux channels.

=item Audio::PulseAudio::CHANNEL_MAP_WAVEEX

Microsoft's WAVEFORMATEXTENSIBLE mapping. This mapping works
as if all LSBs of dwChannelMask are set.

=item Audio::PulseAudio::CHANNEL_MAP_OSS

The default channel mapping used by OSS as defined in the OSS
4.0 API specs. This mapping is probably not too useful since
the OSS API has changed in this respect and no longer knows a
default channel mapping based on the number of channels.

=item Audio::PulseAudio::CHANNEL_MAP_DEF_MAX

Upper limit of valid channel mapping definitions.

=item Audio::PulseAudio::CHANNEL_MAP_DEFAULT

The default channel map.

=back

=head2 $channel_map = Audio::PulseAudio::ChannelMap->parse( $name )

Parse a channel position list or well-known mapping name into a
channel map structure. This turns the output of
sprint() and to_name() back into a C<Audio::PulseAudio::ChannelMap>.

=head1 METHODS

=head2 $nr_channels = $channel_map->channels( [NR_CHANNELS] )

Get or set the number of channels. If the new number of channels is larger
than the previous one they will have random values.

=head2 @positions = $channel_map->map( [CHANNEL1_POSITION], [CHANNEL2_POSITION], ... )

Get or set the channel positions. It will extend the map as needed.

=head2 $position = $channel_map->channel( $channel_id, [CHANNEL_POSITION] )

Get or set the position of a specific channel. It will extend the map as
needed.

=head2 $channel_map->valid()

Returns true if the specified channel map is considered valid.

=head2 $channel_map->equal( $other_channel_map )

Compare two channel maps. Returns true if both match.

=head2 $channel_map_name = $channel_map->sprint()

Pretty print a sample type specification to a string. Returns a string.

=head2 $channel_map->compatible( $sample_spec )

Return true if the specified channel map is compatible with
the specified sample spec.

=head2 $channel_map->superset( $subset_channel_map )

Returns true if every channel defined in C<$subset_channel_map> is also defined in C<$channel_map>.

=head2 $channel_map->can_balance

Returns true if it makes sense to apply a volume 'balance'
with this mapping, i.e. if there are left/right channels
available.

=head2 $channel_map->can_fade

Returns true if it makes sense to apply a volume 'fade'
(i.e. 'balance' between front and rear) with this mapping, i.e. if
there are front/rear channels available.

=head2 $channel_map->can_lfe_balance

Returns true if it makes sense to apply a volume 'lfe balance'
(i.e. 'balance' between LFE and non-LFE channels) with this mapping,
i.e. if there are LFE and non-LFE channels available.

=head2 $channel_map->to_name

Tries to find a well-known channel mapping name for this channel
mapping, i.e. "stereo", "surround-71" and so on. If the channel
mapping is unknown C<undef> will be returned. This name can be parsed
with parse() constructor.

=head2 $channel_map->to_pretty_name

Tries to find a human readable text label for this channel
mapping, i.e. "Stereo", "Surround 7.1" and so on. If the channel
mapping is unknown NULL will be returned.

=head2 $channel_map->has_position

Returns true if the specified channel position is available at
least once in the channel map.

=head2 $mask = $channel_map->mask

Generates a bit mask from a channel map.

=head1 FUNCTIONS

None of the functions are exported. You should call them with fully qualified
names.

=head2 $position_name = channel_position_to_string( $position )

Return a text label for the specified channel position.

=head2 $position = channel_position_from_string( $name )

The inverse of channel_position_to_string().

=head2 $position_name = channel_position_to_pretty_string( $position )

Return a human readable text label for the specified channel position.

=head2 $bit = channel_position_mask( $position )

Makes a bit mask from a channel position.

=head1 REFERENCES

L<https://freedesktop.org/software/pulseaudio/doxygen/channelmap.html>,
L<https://freedesktop.org/software/pulseaudio/doxygen/channelmap_8h.html>

=head1 AUTHOR

Iskra

=cut
