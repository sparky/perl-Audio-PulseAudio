package Audio::PulseAudio;

# Audio::PulseAudio - perl bindings to the PulseAudio library.
#
# Copyright 2020 Przemyslaw Iskra <sparky.pld@gmail.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

use strict;
use warnings;

our $VERSION = v0.0.1;

require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

1;

__END__

=head1 NAME

Audio::PulseAudio - bindings to the PulseAudio library.

=head1 DESCRIPTION

=head2 Introduction

This document describes the client API for the PulseAudio sound
server. The API comes in two flavours to accommodate different styles
of applications and different needs in complexity:

=over

=item The complete but somewhat complicated to use asynchronous API

=item The simplified, easy to use, but limited synchronous API

=back

All strings in PulseAudio are in the UTF-8 encoding, regardless of current
locale. Some functions will filter invalid sequences from the string, some
will simply fail. To ensure reliable behaviour, make sure everything you
pass to the API is already in UTF-8.

=head2 Simple API

Use this if you develop your program in synchronous style and just
need a way to play or record data on the sound server. See
L<Audio::PulseAudio::Simple> for more details.

At this moment this is the only API implemented in this perl wrapper.

=head1 REFERENCES

L<https://freedesktop.org/software/pulseaudio/doxygen/index.html>

=head1 AUTHOR

Iskra

=cut
