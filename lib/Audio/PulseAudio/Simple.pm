package Audio::PulseAudio::Simple;

use strict;
use warnings;
use Audio::PulseAudio;

our $VERSION = v0.0.1;

require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

sub new
{
	my ( $class, %attr ) = @_;
	$attr{name} //= $0;
	$attr{stream_name} //= "";
	my $func = $class->can( 'new_c' );
	@_ = ( $class, @attr{ qw(server name direction device stream_name sample_spec channel_map buffer_attr) } );
	goto &$func;
}

1;

__END__

=head1 NAME

Audio::PulseAudio::Simple - A simple but limited synchronous pulse audio API.

=head1 DESCRIPTION

=head2 Overview

The simple API is designed for applications with very basic sound
playback or capture needs. It can only support a single stream per
connection and has no support for handling of complex features like
events, channel mappings and volume control. It is, however, very simple
to use and quite sufficient for many programs.

=head2 Connecting

The first step before using the sound system is to connect to the
server. This is normally done this way:

  my $ss = Audio::PulseAudio::SampleSpec->new(
      format   => Audio::PulseAudio::SAMPLE_S16NE,
      channels => 2,
      rate     => 44100,
  );

  my $stream = Audio::PulseAudio::Simple->new(
      name        => "Fooapp",
      direction   => Audio::PulseAudio::STREAM_PLAYBACK,
      stream_name => "Music",
      sample_spec => $ss,
  );

At this point a connected object is returned. If there is a problem the call
will die with the appropriate error message.

=head2 Transferring data

Once the connection is established to the server, data can start flowing.
Using the connection is very similar to the normal read() and write()
system calls. The main difference is that they are methods in this class.
Note that these operations always block.

=head2 Cleanup

Once playback or capture is complete, the connection should be closed
and resources freed. This is done when $stream object is destroyed.

=head1 CONSTRUCTOR

=head2 $stream = Audio::PulseAudio::Simple->new( direction => $dir, sample_spec => $ss, ... );

Create a new simple connection to the server. Most arguments are optional,
not needed or have decent defaults. However C<direction> and C<sample_spec>
are required.

=over

=item server

Server name. I am not sure what it does.

=item name

Name of your application to advertise to the server.

=item direction

Stream direction, one of:
C<Audio::PulseAudio::STREAM_PLAYBACK>,
C<Audio::PulseAudio::STREAM_RECORD>.

=item device

Preferred device?

=item stream_name

If your application has multiple streams it is best to name them all.

=item sample_spec

An object of type L<Audio::PulseAudio::SampleSpec>.

=item channel_map

An object of type L<Audio::PulseAudio::ChannelMap>.

=item buffer_attr

An object of type L<Audio::PulseAudio::BufferAttr>.

=back

=head2 $stream = Audio::PulseAudio::Simple->new_c( $server, $name, $direction, $device, $stream_name, $sample_spec, $channel_map, $buffer_attr )

Does the same thing, but only useful for people who can count up to 8... on one hand.

=head1 METHODS

=head2 $stream->write( $buffer )

Write some data to the server. The stream should be open in playback direction.

=head2 $stream->drain()

Wait until all data already written is played by the daemon.

=head2 $stream->read( my $buffer, $length )

Read $length bytes of data from the server and place it in the $buffer.
The stream should be open in the record direction. If not enough data is
available the call will block.

To avoid unnecessary memory allocation you should reuse the same $buffer
variable for all calls to read().

=head2 $stream->flush()

Flush the playback or record buffer. Throw away all data currently in buffers.

=head2 $us = $stream->get_latency()

Return the total latency of the playback or record pipeline, in microseconds.

=head1 REFERENCES

L<https://freedesktop.org/software/pulseaudio/doxygen/simple_8h.html>,
L<https://freedesktop.org/software/pulseaudio/doxygen/simple.html>

=head1 AUTHOR

Iskra

=cut
