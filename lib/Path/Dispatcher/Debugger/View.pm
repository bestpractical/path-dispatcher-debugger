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
    show 'testing_form';
    show 'matching_rules' => $debugger, '';
};

template testing_form => sub {
    label { attr { for => 'path' } 'Path' }
    input {
        attr {
            type => 'text',
            name => 'path',
            size => 50,
        }
    }
};

template matching_rules => sub {
    my ($self, $debugger, $path) = @_;
    my $dispatcher = $debugger->dispatcher;

    ol {
        for my $rule ($dispatcher->rules) {
            li { $rule->name }
        }
    };
};


1;

