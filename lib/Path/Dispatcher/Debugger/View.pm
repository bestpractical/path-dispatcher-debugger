package Path::Dispatcher::Debugger::View;
use strict;
use warnings;
use Scalar::Util 'blessed';
use Template::Declare::Tags;
use base 'Template::Declare';

sub page (&;@) {
    my $contents = shift;
    return sub {
        my ($self, $request, $debugger, @args) = @_;
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
                $contents->($self, $request, $debugger, @args);
            }
        }
    }
}

template '/' => page {
    my ($self, $request, $debugger) = @_;

    show 'testing_form';
    show 'matching_rules' => $request, $debugger;
};

template testing_form => sub {
    label { attr { for => 'path' } 'Path' }
    input {
        attr {
            type  => 'text',
            name  => 'path',
            id    => 'path_tester',
            size  => 50,
        }
    }

    input {
        attr {
            type    => 'radio',
            name    => 'dispatch_type',
            class   => 'dispatch_type',
            value   => 'dispatch',
            checked => 'checked',
        }
    }
    label { 'Dispatch' }

    input {
        attr {
            type  => 'radio',
            name  => 'dispatch_type',
            class => 'dispatch_type',
            value => 'prefix',
        }
    }
    label { 'Prefix' }

    input {
        attr {
            type  => 'radio',
            name  => 'dispatch_type',
            class => 'dispatch_type',
            value => 'completion',
        }
    }
    label { 'Completion' }
};

template matching_rules => sub {
    my ($self, $request, $debugger) = @_;

    my $path = $request->param('test_path');
    $path = '' if !defined($path);

    my $type = $request->param('dispatch_type') || 'dispatch';

    div {
        attr {
            id => 'matching_rules',
        };
        h3 { "Matching: $path" };

        if ($type eq 'completion') {
            my @matches;
            my @not_matches;

            for my $rule ($debugger->dispatcher->rules) {
                my @completions = $rule->complete($path);
                if (@completions) {
                    push @matches, [$rule, join ', ', @completions];
                }
                else {
                    push @not_matches, $rule;
                }
            }

            h5 { "Matched Rules" };
            display_rules(@matches);
            h5 { "Unmatched Rules" };
            display_rules(@not_matches);
        }
        else {
            my $dispatch = $debugger->dispatcher->dispatch($path);
            my %seen = map { $_ => 1 } map { $_->rule } $dispatch->matches;

            h5 { "Matched Rules" };
            display_rules(grep {  $seen{$_} } $debugger->dispatcher->rules);
            h5 { "Unmatched Rules" };
            display_rules(grep { !$seen{$_} } $debugger->dispatcher->rules);
        }
    };
};

sub display_rules {
    my @rules = @_;

    ul {
        for my $rule (@rules) {
            li { display_rule($rule) };
        }
    };
}

sub display_rule {
    my ($rule) = @_;
    my $extra;

    ($rule, $extra) = @$rule if ref($rule) eq 'ARRAY';

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
        outs blessed($rule);
    }

    span { $extra } if defined $extra;
}

1;

