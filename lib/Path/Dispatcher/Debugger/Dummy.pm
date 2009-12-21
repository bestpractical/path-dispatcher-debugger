package Path::Dispatcher::Debugger::Dummy;
use strict;
use warnings;
use Path::Dispatcher::Declarative -base;

sub shoot { my $weapon = shift; sub { $weapon } };

under man => sub {
    on guts => shoot 'bomb';
    on cut  => shoot 'guts';
    on elec => shoot 'cut' ;
    on ice  => shoot 'elec';
    on fire => shoot 'ice' ;
    on bomb => shoot 'fire';
};

on devil   => shoot 'elec';
on clone   => shoot 'fire';
on bubbles => shoot 'guts';
on wily    => shoot 'fire';

1;

