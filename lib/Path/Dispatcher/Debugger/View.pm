package Path::Dispatcher::Debugger::View;
use strict;
use warnings;
use Template::Declare::Tags;
use base 'Template::Declare';

template '/' => sub {
    my ($self, $debugger) = @_;
    h1 { $debugger->dispatcher->name };
    ol {
        li { $_->name } for $debugger->dispatcher->rules;
    }
};


1;

