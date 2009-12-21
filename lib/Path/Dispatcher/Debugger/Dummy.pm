package Path::Dispatcher::Debugger::Dummy;
use strict;
use warnings;
use Path::Dispatcher::Declarative -base;

under man => sub {
    on guts => sub { 'bomb' };
    on cut  => sub { 'guts' };
    on elec => sub { 'cut'  };
    on ice  => sub { 'elec' };
    on fire => sub { 'ice'  };
    on bomb => sub { 'fire' };
};

1;

