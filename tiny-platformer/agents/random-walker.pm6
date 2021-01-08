unit module random-walker;

sub nextAction(@map) is export {
    my $command = ["cliclick kp:arrow-left", "cliclick kp:arrow-right", "cliclick kp:space"][3.rand.Int];
    shell $command;
}
