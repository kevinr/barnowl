use strict;
use warnings;

package BarnOwl::Module::IRC::Completion;

use BarnOwl::Completion::Util qw(complete_flags);

my %networks = ();
my %dests = ();
my %servers = ();

sub complete_networks { keys %networks }
sub complete_dests    { keys %dests }
sub complete_channels { grep /^#/, keys %dests }
sub complete_nicks    { grep /^[^#]/, keys %dests }
sub complete_servers  { keys %servers }

sub complete_irc_connect {
    my $ctx = shift;
    return complete_flags($ctx,
        [qw(-s)],
        {
            "-a" => \&complete_networks,
            "-p" => sub {},
            "-n" => sub {},
        },
        \&complete_servers
       );
}

sub complete_irc_network {
    my $ctx = shift;
    return complete_flags($ctx,
        [],
        {
            "-a" => \&complete_networks,
        },
       );
}

sub complete_irc_dest {
    my $ctx = shift;
    return complete_flags($ctx,
        [],
        {
            "-a" => \&complete_networks,
        },
        \&complete_dests
       );
}

sub complete_irc_channel {
    my $ctx = shift;
    return complete_flags($ctx,
        [],
        {
            "-a" => \&complete_networks,
        },
        \&complete_channels
       );
}

sub complete_irc_nick {
    my $ctx = shift;
    return complete_flags($ctx,
        [],
        {
            "-a" => \&complete_networks,
        },
        \&complete_nicks
       );
}

sub on_message {
    my $m = shift;
    return unless $m->type eq 'IRC';
    $networks{$m->network} = 1;
    $dests{$m->recipient} = 1;
    $dests{$m->sender} = 1;
    $servers{$m->server} = 1;
}

BarnOwl::Completion::register_completer('irc-connect'    => \&complete_irc_connect);
BarnOwl::Completion::register_completer('irc-disconnect' => \&complete_irc_network);
BarnOwl::Completion::register_completer('irc-msg'        => \&complete_irc_dest);
BarnOwl::Completion::register_completer('irc-mode'       => \&complete_irc_dest);
BarnOwl::Completion::register_completer('irc-join'       => \&complete_irc_channel);
BarnOwl::Completion::register_completer('irc-part'       => \&complete_irc_channel);
BarnOwl::Completion::register_completer('irc-names'      => \&complete_irc_channel);
BarnOwl::Completion::register_completer('irc-whois'      => \&complete_irc_nick);
BarnOwl::Completion::register_completer('irc-motd'       => \&complete_irc_network);
BarnOwl::Completion::register_completer('irc-topic'      => \&complete_irc_channel);
BarnOwl::Completion::register_completer('irc-quote'      => \&complete_irc_network);

$BarnOwl::Hooks::newMessage->add("BarnOwl::Module::IRC::Completion::on_message");

1;
