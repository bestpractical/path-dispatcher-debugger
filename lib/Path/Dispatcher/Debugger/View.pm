package Path::Dispatcher::Debugger::View;
use strict;
use warnings;
use Template::Declare::Tags;
use base 'Template::Declare';

sub page (&;@) {
    my $contents = shift;
    return sub {
        my ($self, $debugger) = @_;
        html {
            body {
                h2 { $debugger->dispatcher->name };
                $contents->(@_);
            }
        }
    }
}

template '/' => page {
    my ($self, $debugger) = @_;
};


1;

