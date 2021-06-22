#https://www.tutorialspoint.com/execute_perl_online.php

$z = 3;

sub g {
    my ($a, $b) = @_;
    print "$z $b\n";
    $z = $a + 1;
}

sub f {
    my ($x) = @_;
    local $z = 2;
    g($x, $z);
    print "$z\n";
}

f(42);

print $z."\n";
