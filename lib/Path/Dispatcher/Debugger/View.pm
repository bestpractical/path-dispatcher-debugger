package Path::Dispatcher::Debugger::View;
use strict;
use warnings;
use Scalar::Util 'blessed';
use Template::Declare::Tags;
use base 'Template::Declare';

sub page (&;@) {
    my $contents = shift;
    return sub {
        my ($self, $debugger, @args) = @_;
        html {
            body {
                head {
                    title { blessed($debugger) };
                    for my $file ('jquery-1.2.6.js', 'path-dispatcher-debugger.js') {
                        script {
                            attr {
                                type => 'text/javascript',
                                src  => "/static/$file",
                            }
                        }
                    }
                }
                h2 { $debugger->dispatcher->name };
                $contents->($self, $debugger, @args);
            }
        }
    }
}

template '/' => page {
    my ($self, $debugger) = @_;

    show 'testing_form';
    show 'matching_rules' => $debugger;
};

template testing_form => sub {
    label { attr { for => 'path' } 'Path' }
    input {
        attr {
            type  => 'text',
            name  => 'path',
            class => 'path_tester',
            size  => 50,
        }
    }
};

template matching_rules => sub {
    my ($self, $debugger, $path) = @_;
    $path = '' if !defined($path);

    div {
        attr {
            id => 'matching_rules',
        };
        display_rules($debugger->dispatcher->rules);
    };
};

sub display_rules {
    my @rules = @_;

    ol {
        for my $rule (@rules) {
            li { display_rule($rule) };
        }
    };
}

sub display_rule {
    my ($rule) = @_;

    if ($rule->isa('Path::Dispatcher::Rule::Tokens')) {
        tt { $rule->readable_attributes };
    }
    elsif ($rule->isa('Path::Dispatcher::Rule::Under')) {
        outs 'Under ';
        outs(display_rule($rule->predicate));
        outs(display_rules($rule->rules));
    }
    elsif ($rule->isa('Path::Dispatcher::Rule::Regex')) {
        outs 'qr/';
        tt { $rule->regex };
        outs '/';
    }
    else {
        blessed($rule);
    }
}

1;

