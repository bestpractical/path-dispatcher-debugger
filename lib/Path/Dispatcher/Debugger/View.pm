package Path::Dispatcher::Debugger::View;
use strict;
use warnings;
use Template::Declare::Tags;
use base 'Template::Declare';

template '/' => sub {
    h1 { "Yo" };
};


1;

