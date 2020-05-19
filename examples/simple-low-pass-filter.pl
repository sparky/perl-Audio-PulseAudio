#!/usr/bin/perl

use strict;
use warnings;

use Audio::PulseAudio::BufferAttr;
use Audio::PulseAudio::SampleSpec;
use Audio::PulseAudio::Simple;

# Requested input and output format
my $sample_spec = Audio::PulseAudio::SampleSpec->new(
	# Same endiannes as the computer
	format      => Audio::PulseAudio::SAMPLE_FLOAT32NE,
	rate        => 44100,
	channels    => 2,
);

my $frame_size = $sample_spec->frame_size();
my $buffer_size = 60 * $frame_size;

my $buffer_attr = Audio::PulseAudio::BufferAttr->new(
	maxlength   => 64 * $buffer_size,
	tlength     =>  2 * $buffer_size,
	fragsize    =>      $buffer_size,
);

my $stream_in = Audio::PulseAudio::Simple->new(
	name        => 'Audio::PulseAudio::Simple',
	stream_name => 'Capture',
	direction   => Audio::PulseAudio::STREAM_RECORD,
	sample_spec => $sample_spec,
	buffer_attr => $buffer_attr,
);

my $stream_out = Audio::PulseAudio::Simple->new(
	name        => 'Audio::PulseAudio::Simple',
	stream_name => 'Playback',
	direction   => Audio::PulseAudio::STREAM_PLAYBACK,
	sample_spec => $sample_spec,
	buffer_attr => $buffer_attr,
);

use constant FACTOR => 0.002;
use constant MULTIPLIER => 15;

use constant COLUMNS => 80;

my $lpf_left = 0; my $lpf_right = 0;
my $max_left = 0; my $max_right = 0;
while (1)
{
	# This will block.
	$stream_in->read( my $buffer, $buffer_size );

	my @samples = unpack "f" . ( $buffer_size / 4 ), $buffer;
	my @samples_out;
	while ( my ( $left, $right ) = splice @samples, 0, 2 )
	{
		$lpf_left  += FACTOR * ( $left - $lpf_left );
		$lpf_right += FACTOR * ( $right - $lpf_right );
		push @samples_out, $lpf_left * MULTIPLIER, $lpf_right * MULTIPLIER;

		$left  = abs( $lpf_left );
		$right = abs( $lpf_right );
		$max_left  *= 0.9999;
		$max_right *= 0.9999;
		$max_left = $left
			if $left > $max_left;
		$max_right = $right
			if $right > $max_right;
	}

	my $buffer_out = pack "f" . ( $buffer_size / 4 ), @samples_out;
	$stream_out->write( $buffer_out );

	my $count_left = int( COLUMNS * MULTIPLIER * $max_left );
	my $count_right = int( COLUMNS * MULTIPLIER * $max_right );
	$count_left = COLUMNS  if $count_left > COLUMNS;
	$count_right = COLUMNS if $count_right > COLUMNS;

	my $char_larger = ',';
	my $count_smaller = $count_left;
	my $count_larger  = $count_right;
	if ( $count_left > $count_right )
	{
		$char_larger = "'";
		$count_larger  = $count_left;
		$count_smaller = $count_right;
	}

	printf "%s%s%s\r", ":" x $count_smaller, $char_larger x ($count_larger - $count_smaller), " " x (COLUMNS - $count_larger);
	STDOUT->flush();
}

