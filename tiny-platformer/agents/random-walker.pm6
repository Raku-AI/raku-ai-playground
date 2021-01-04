unit module random-walker;

sub nextAction() is export {
    return ["left", "right", "jump"][3.rand.Int];
}
