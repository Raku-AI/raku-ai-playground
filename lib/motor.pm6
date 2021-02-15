unit module motor;

enum KeyboardAction is export <Left-Key Right-Key Space-Key>;

sub press-key($keyboard-action) is export {
    if $*DISTRO.name eq "macosx" {
        press-key-on-mac $keyboard-action;
    } else {
        die "press-key not implemented on $*DISTRO";
    }
}

sub press-key-on-mac($keyboard-action) {
    my $kp-action;
    given $keyboard-action {
        when Left-Key {
            $kp-action = "kp:arrow-left";
        }
        when Right-Key {
            $kp-action = "kp:arrow-right";
        }
        when Space-Key {
            $kp-action = "kp:space";
        }
    }
    my $command = "cliclick $kp-action";
    shell $command;
}

