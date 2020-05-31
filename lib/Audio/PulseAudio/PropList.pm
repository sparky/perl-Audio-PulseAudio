package Audio::PulseAudio::PropList;

use strict;
use warnings;
use Audio::PulseAudio;

sub setf
{
	my ( $self, $key, $format, @args ) = @_;
	$self->sets( $key, sprintf $format, @args );
}

1;

__END__

=head1 NAME

Audio::PulseAudio::PropList - Property list

=head1 DESCRIPTION

PropList is a key-value structure that allows you to transfer the given
properties to the PulseAudio server. It is recommended when creating a context
object. Not needed in the simple interface.

The key of a property is always a simple string, while the value can be either
a properly formated UTF-8 string (set using sets()) or binary data
(set using set()). It is up to the application to pick the correct type.

The data structure gives no guarantees about the order of the properties,
it may change at any point.

Since the data structure will accept any correctly formated string as a key it
is preferred to use the supplied constants to avoid any misspellings.

=head2 Properties

=over

=item Audio::PulseAudio::PROP_MEDIA_NAME

For streams: localized media name, formatted as UTF-8.
E.g. "Guns'N'Roses: Civil War".

=item Audio::PulseAudio::PROP_MEDIA_TITLE

For streams: localized media title if applicable, formatted as UTF-8.
E.g. "Civil War"

=item Audio::PulseAudio::PROP_MEDIA_ARTIST

For streams: localized media artist if applicable, formatted as UTF-8.
E.g. "Guns'N'Roses"

=item Audio::PulseAudio::PROP_MEDIA_COPYRIGHT

For streams: localized media copyright string if applicable, formatted
as UTF-8. E.g. "Evil Record Corp."

=item Audio::PulseAudio::PROP_MEDIA_SOFTWARE

For streams: localized media generator software string if applicable, formatted
as UTF-8. E.g. "Foocrop AudioFrobnicator"

=item Audio::PulseAudio::PROP_MEDIA_LANGUAGE

For streams: media language if applicable, in standard POSIX format.
E.g. "de_DE"

=item Audio::PulseAudio::PROP_MEDIA_FILENAME

For streams: source filename if applicable, in URI format or local path.
E.g. "/home/lennart/music/foobar.ogg"

=item Audio::PulseAudio::PROP_MEDIA_ICON

For streams: icon for the media. A binary blob containing PNG image data

=item Audio::PulseAudio::PROP_MEDIA_ICON_NAME

For streams: an XDG icon name for the media. E.g. "audio-x-mp3"

=item Audio::PulseAudio::PROP_MEDIA_ROLE

For streams: logic role of this media. One of the strings "video", "music",
"game", "event", "phone", "animation", "production", "a11y", "test"

=item Audio::PulseAudio::PROP_FILTER_WANT

For streams: the name of a filter that is desired, e.g. "echo-cancel"
or "equalizer-sink". PulseAudio may choose to not apply the filter if it does
not make sense (for example, applying echo-cancellation on a Bluetooth headset
probably does not make sense.

=item Audio::PulseAudio::PROP_FILTER_APPLY

For streams: the name of a filter that is desired, e.g. "echo-cancel"
or "equalizer-sink". Differs from C<Audio::PulseAudio::PROP_FILTER_WANT>
in that it forces PulseAudio to apply the filter, regardless of whether
PulseAudio thinks it makes sense to do so or not. If this is set,
C<Audio::PulseAudio::PROP_FILTER_WANT> is ignored. In other words, you almost
certainly do not want to use this.

=item Audio::PulseAudio::PROP_FILTER_SUPPRESS

For streams: the name of a filter that should specifically suppressed (i.e.
overrides C<Audio::PulseAudio::PROP_FILTER_WANT>. Useful for the times that
C<Audio::PulseAudio::PROP_FILTER_WANT> is automatically added (e.g.
echo-cancellation for phone streams when $VOIP_APP does its own, internal AEC)

=item Audio::PulseAudio::PROP_EVENT_ID

For event sound streams: XDG event sound name. e.g. "message-new-email"
(Event sound streams are those with media.role set to "event")

=item Audio::PulseAudio::PROP_EVENT_DESCRIPTION

For event sound streams: localized human readable one-line description
of the event, formatted as UTF-8. E.g. "Email from C<lennart@example.com>
received."

=item Audio::PulseAudio::PROP_EVENT_MOUSE_X

For event sound streams: absolute horizontal mouse position on the screen
if the event sound was triggered by a mouse click, integer formatted as text
string. E.g. "865"

=item Audio::PulseAudio::PROP_EVENT_MOUSE_Y

For event sound streams: absolute vertical mouse position on the screen
if the event sound was triggered by a mouse click, integer formatted as text
string. E.g. "432"

=item Audio::PulseAudio::PROP_EVENT_MOUSE_HPOS

For event sound streams: relative horizontal mouse position on the screen
if the event sound was triggered by a mouse click, float formatted as text
string, ranging from 0.0 (left side of the screen) to 1.0 (right side
of the screen). E.g. "0.65"

=item Audio::PulseAudio::PROP_EVENT_MOUSE_VPOS

For event sound streams: relative vertical mouse position on the screen
if the event sound was triggered by a mouse click, float formatted as text
string, ranging from 0.0 (top of the screen) to 1.0 (bottom of the screen).
E.g. "0.43"

=item Audio::PulseAudio::PROP_EVENT_MOUSE_BUTTON

For event sound streams: mouse button that triggered the event if applicable,
integer formatted as string with 0=left, 1=middle, 2=right. E.g. "0"

=item Audio::PulseAudio::PROP_WINDOW_NAME

For streams that belong to a window on the screen: localized window title.
E.g. "Totem Music Player"

=item Audio::PulseAudio::PROP_WINDOW_ID

For streams that belong to a window on the screen: a textual id for identifying
a window logically. E.g. "org.gnome.Totem.MainWindow"

=item Audio::PulseAudio::PROP_WINDOW_ICON

For streams that belong to a window on the screen: window icon. A binary blob
containing PNG image data

=item Audio::PulseAudio::PROP_WINDOW_ICON_NAME

For streams that belong to a window on the screen: an XDG icon name for
the window. E.g. "totem"

=item Audio::PulseAudio::PROP_WINDOW_X

For streams that belong to a window on the screen: absolute horizontal window position on the screen, integer formatted as text string. E.g. "865".

=item Audio::PulseAudio::PROP_WINDOW_Y

For streams that belong to a window on the screen: absolute vertical window position on the screen, integer formatted as text string. E.g. "343".

=item Audio::PulseAudio::PROP_WINDOW_WIDTH

For streams that belong to a window on the screen: window width on the screen, integer formatted as text string. e.g. "365".

=item Audio::PulseAudio::PROP_WINDOW_HEIGHT

For streams that belong to a window on the screen: window height on the screen, integer formatted as text string. E.g. "643".

=item Audio::PulseAudio::PROP_WINDOW_HPOS

For streams that belong to a window on the screen: relative position of
the window center on the screen, float formatted as text string, ranging from
0.0 (left side of the screen) to 1.0 (right side of the screen). E.g. "0.65".

=item Audio::PulseAudio::PROP_WINDOW_VPOS

For streams that belong to a window on the screen: relative position of
the window center on the screen, float formatted as text string, ranging from
0.0 (top of the screen) to 1.0 (bottom of the screen). E.g. "0.43".

=item Audio::PulseAudio::PROP_WINDOW_DESKTOP

For streams that belong to a window on the screen: if the windowing system
supports multiple desktops, a comma separated list of indexes of the desktops
this window is visible on. If this property is an empty string, it is visible
on all desktops (i.e. 'sticky'). The first desktop is 0. E.g. "0,2,3"

=item Audio::PulseAudio::PROP_WINDOW_X11_DISPLAY

For streams that belong to an X11 window on the screen: the X11 display string.
E.g. ":0.0"

=item Audio::PulseAudio::PROP_WINDOW_X11_SCREEN

For streams that belong to an X11 window on the screen: the X11 screen
the window is on, an integer formatted as string. E.g. "0"

=item Audio::PulseAudio::PROP_WINDOW_X11_MONITOR

For streams that belong to an X11 window on the screen: the X11 monitor
the window is on, an integer formatted as string. E.g. "0"

=item Audio::PulseAudio::PROP_WINDOW_X11_XID

For streams that belong to an X11 window on the screen: the window XID,
an integer formatted as string. E.g. "25632"

=item Audio::PulseAudio::PROP_APPLICATION_NAME

For clients/streams: localized human readable application name.
E.g. "Totem Music Player"

=item Audio::PulseAudio::PROP_APPLICATION_ID

For clients/streams: a textual id for identifying an application logically.
E.g. "org.gnome.Totem"

=item Audio::PulseAudio::PROP_APPLICATION_VERSION

For clients/streams: a version string, e.g. "0.6.88"

=item Audio::PulseAudio::PROP_APPLICATION_ICON

For clients/streams: application icon. A binary blob containing PNG image data

=item Audio::PulseAudio::PROP_APPLICATION_ICON_NAME

For clients/streams: an XDG icon name for the application. E.g. "totem"

=item Audio::PulseAudio::PROP_APPLICATION_LANGUAGE

For clients/streams: application language if applicable, in standard POSIX
format. E.g. "de_DE"

=item Audio::PulseAudio::PROP_APPLICATION_PROCESS_ID

For clients/streams on UNIX: application process PID, an integer formatted
as string. E.g. "4711"

=item Audio::PulseAudio::PROP_APPLICATION_PROCESS_BINARY

For clients/streams: application process name. E.g. "totem"

=item Audio::PulseAudio::PROP_APPLICATION_PROCESS_USER

For clients/streams: application user name. E.g. "lennart"

=item Audio::PulseAudio::PROP_APPLICATION_PROCESS_HOST

For clients/streams: host name the application runs on. E.g. "omega"

=item Audio::PulseAudio::PROP_APPLICATION_PROCESS_MACHINE_ID

For clients/streams: the D-Bus host id the application runs on.
E.g. "543679e7b01393ed3e3e650047d78f6e"

=item Audio::PulseAudio::PROP_APPLICATION_PROCESS_SESSION_ID

For clients/streams: an id for the login session the application runs in.
On Unix the value of $XDG_SESSION_ID. E.g. "5"

=item Audio::PulseAudio::PROP_DEVICE_STRING

For devices: device string in the underlying audio layer's format.
E.g. "surround51:0"

=item Audio::PulseAudio::PROP_DEVICE_API

For devices: API this device is access with. E.g. "alsa"

=item Audio::PulseAudio::PROP_DEVICE_DESCRIPTION

For devices: localized human readable device one-line description.
E.g. "Foobar Industries USB Headset 2000+ Ultra"

=item Audio::PulseAudio::PROP_DEVICE_BUS_PATH

For devices: bus path to the device in the OS' format.
E.g. "/sys/bus/pci/devices/0000:00:1f.2"

=item Audio::PulseAudio::PROP_DEVICE_SERIAL

For devices: serial number if applicable. E.g. "4711-0815-1234"

=item Audio::PulseAudio::PROP_DEVICE_VENDOR_ID

For devices: vendor ID if applicable. E.g. 1274

=item Audio::PulseAudio::PROP_DEVICE_VENDOR_NAME

For devices: vendor name if applicable. E.g. "Foocorp Heavy Industries"

=item Audio::PulseAudio::PROP_DEVICE_PRODUCT_ID

For devices: product ID if applicable. E.g. 4565

=item Audio::PulseAudio::PROP_DEVICE_PRODUCT_NAME

For devices: product name if applicable. E.g. "SuperSpeakers 2000 Pro"

=item Audio::PulseAudio::PROP_DEVICE_CLASS

For devices: device class. One of "sound", "modem", "monitor", "filter"

=item Audio::PulseAudio::PROP_DEVICE_FORM_FACTOR

For devices: form factor if applicable. One of "internal", "speaker",
"handset", "tv", "webcam", "microphone", "headset", "headphone", "hands-free",
"car", "hifi", "computer", "portable"

=item Audio::PulseAudio::PROP_DEVICE_BUS

For devices: bus of the device if applicable. One of "isa", "pci", "usb",
"firewire", "bluetooth"

=item Audio::PulseAudio::PROP_DEVICE_ICON

For devices: icon for the device. A binary blob containing PNG image data

NOTE: use set() for this one.

=item Audio::PulseAudio::PROP_DEVICE_ICON_NAME

For devices: an XDG icon name for the device. E.g. "sound-card-speakers-usb"

=item Audio::PulseAudio::PROP_DEVICE_ACCESS_MODE

For devices: access mode of the device if applicable. One of "mmap",
"mmap_rewrite", "serial"

=item Audio::PulseAudio::PROP_DEVICE_MASTER_DEVICE

For filter devices: master device id if applicable.

=item Audio::PulseAudio::PROP_DEVICE_BUFFERING_BUFFER_SIZE

For devices: buffer size in bytes, integer formatted as string.

=item Audio::PulseAudio::PROP_DEVICE_BUFFERING_FRAGMENT_SIZE

For devices: fragment size in bytes, integer formatted as string.

=item Audio::PulseAudio::PROP_DEVICE_PROFILE_NAME

For devices: profile identifier for the profile this devices is in.
E.g. "analog-stereo", "analog-surround-40", "iec958-stereo", ...

=item Audio::PulseAudio::PROP_DEVICE_INTENDED_ROLES

For devices: intended use. A space separated list of roles (see PROP_MEDIA_ROLE)
this device is particularly well suited for, due to latency, quality or form
factor.

=item Audio::PulseAudio::PROP_DEVICE_PROFILE_DESCRIPTION

For devices: human readable one-line description of the profile this device
is in. E.g. "Analog Stereo", ...

=item Audio::PulseAudio::PROP_MODULE_AUTHOR

For modules: the author's name, formatted as UTF-8 string.
E.g. "Lennart Poettering"

=item Audio::PulseAudio::PROP_MODULE_DESCRIPTION

For modules: a human readable one-line description of the module's purpose
formatted as UTF-8. E.g. "Frobnicate sounds with a flux compensator"

=item Audio::PulseAudio::PROP_MODULE_USAGE

For modules: a human readable usage description of the module's arguments
formatted as UTF-8.

=item Audio::PulseAudio::PROP_MODULE_VERSION

For modules: a version string for the module. E.g. "0.9.15"

=item Audio::PulseAudio::PROP_FORMAT_SAMPLE_FORMAT

For PCM formats: the sample format used as returned by sample_format_to_string() from
L<Audio::PulseAudio::SampleSpec>.

=item Audio::PulseAudio::PROP_FORMAT_RATE

For all formats: the sample rate (unsigned integer)

=item Audio::PulseAudio::PROP_FORMAT_CHANNELS

For all formats: the number of channels (unsigned integer)

=item Audio::PulseAudio::PROP_FORMAT_CHANNEL_MAP

For PCM formats: the channel map of the stream as returned by
L<Audio::PulseAudio::ChannelMap> sprint()

=back

=head1 CONSTRUCTOR

=head2 $proplist = Audio::PulseAudio::PropList->new( [KEY1 => VALUE1, KEY2 => VALUE2, ... ] )

Allocate a property list. Optionally set the keys to the given values. If the
key name ends in ".icon" it will be set as binary, otherwise it will be set as
a utf8 string.

=head2 $proplist = Audio::PulseAudio::PropList->from_string( STR )

Allocate a new property list and assign key/value from a human readable string.
The reverse of to_string() below.

=head1 METHODS

=head2 $proplist = $self->clone

Allocate a new property list and copy over every single entry from
the specified list.

=head2 $self->sets( KEY1 => VALUE1, [KEY2 => VALUE2, ... ] )

Append a new string entry to the property list, possibly overwriting an already
existing entry with the same key. Will accept only valid UTF-8.

=head2 $self->setp( "KEY1=VALUE1", ["KEY2=VALUE2", ... ] )

Append a new string entry to the property list, possibly overwriting an already
existing entry with the same key. Will accept only valid UTF-8. The string
passed in must contain a '='. Left hand side of the '=' is used as key name,
the right hand side as string data.

=head2 $self->setf( KEY => FORMAT, ARG1, ARG2, ... )

Append a new string entry to the property list, possibly overwriting an already
existing entry with the same key. Will accept only valid UTF-8. The data can be
passed as printf()-style format string with arguments.

=head2 $self->set( KEY1 => VALUE1, [KEY2 => VALUE2, ... ] )

Append a new arbitrary data entry to the property list, possibly overwriting
an already existing entry with the same key.

Unless you itend to attach binary data (like the png icons) you should be using
one of the other set methods instead.

=head2 @values = $self->gets( KEY1, [KEY2, ... ] )

Return a string entry for the specified keys. Binary data and missing keys
will return C<undef>.

=head2 @values = $self->get( KEY1, [KEY2, ... ] )

Return the values for the specified keys. Works both with binary and string
data. Missing keys will return C<undef>.

=head2 $self->unset( KEY1, [KEY2, ... ] )

Removes entries from the property list, identified be the specified key names.

=head2 $self->iterate( $state )

Iterate through the property list. Dangerous, use L<keys> instead.

  my $state;
  while ( my $key = $self->iterate( $state ) )
  {
    ...
  }

=head2 @keys = $self->keys

Return the list of keys set in this property list.

  foreach my $key ( $self->keys )
  {
    ...
  }

=head2 $self->update( MODE, $other )

Merge property list C<$other> into <$self>, adhering the merge mode as
specified in C<MODE>:

=over

=item Audio::PulseAudio::UPDATE_SET

Replace the entire property list with the new one. Don't keep any of the old
data around.

=item Audio::PulseAudio::UPDATE_MERGE

Merge new property list into the existing one, not replacing any old entries
if they share a common key with the new property list.

=item Audio::PulseAudio::UPDATE_REPLACE

Merge new property list into the existing one, replacing all old entries that
share a common key with the new property list.

=back

=head2 $self->to_string

Format the property list nicely as a human readable string. This works very
much like to_string_sep() and uses a newline as separator and appends one final
one.

=head2 $self->to_string_sep( SEP )

Format the property list nicely as a human readable string and choose
the separator.

=head2 $self->contains( KEY )

Returns true if an entry for the specified key exists in the property list.

=head2 $self->clear

Remove all entries from the property list object.

=head2 $self->size

Return the number of entries in the property list.

=head2 $self->isempty

Returns true when the proplist is empty.

=head2 $self->equal( $other )

Return true when C<$self> and C<$other> have the same keys and values.

=head1 FUNCTIONS

None of the functions are exported. You should call them with fully qualified
names.

=head2 key_valid( KEY )

Returns true if the key is valid (not necessarily recognised by the server).

=head1 EXAMPLES

=head2 Transfer property list to a perl hash

  use Audio::PulseAudio::PropList;

  my $proplist = Audio::PulseAudio::PropList->new(
      Audio::PulseAudio::PROP_APPLICATION_NAME() => "my shiny app",
  );

  # Transfer to a perl hash
  my @keys = $proplist->keys;
  my %hash;
  @hash{ @keys } = $proplist->get( @keys );

=head1 REFERENCES

L<https://freedesktop.org/software/pulseaudio/doxygen/proplist_8h.html>

=head1 AUTHOR

Iskra

=cut
