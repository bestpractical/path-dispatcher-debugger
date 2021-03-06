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
                    link {
                        attr {
                            rel  => 'stylesheet',
                            type => 'text/css',
                            href => '/static/path-dispatcher-debugger.css',
                        }
                    };

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
        h3 { "\u$type-matching: $path" };

        my @matches;
        my @unmatches;

        if ($type eq 'completion') {
            my $path_object = $debugger->dispatcher->path_class->new($path);
            for my $rule ($debugger->dispatcher->rules) {
                my @completions = $rule->complete($path_object);
                if (@completions) {
                    push @matches, { rule => $rule, completions => \@completions };
                }
                else {
                    push @unmatches, $rule;
                }
            }
        }
        else {
            my $dispatch = $debugger->dispatcher->dispatch($path);
            my %seen = map { $_ => 1 } map { $_->rule } $dispatch->matches;
            @matches   = grep {  $seen{$_} } $debugger->dispatcher->rules;
            @unmatches = grep { !$seen{$_} } $debugger->dispatcher->rules;
        }

        h5 { "Matched Rules" };
        div {
            class is 'matched_rules';
            display_rules(@matches);
        }
        h5 { "Unmatched Rules" };
        div {
            class is 'unmatched_rules';
            display_rules(@unmatches);
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
    my $rule = shift;
    my $extra;

    if (ref($rule) eq 'HASH') {
        $extra = $rule;
        $rule = delete $extra->{rule};
    }

    if ($rule->isa('Path::Dispatcher::Rule::Tokens')) {
        tt { $rule->readable_attributes };
    }
    elsif ($rule->isa('Path::Dispatcher::Rule::Under')) {
        outs 'Under ';
        outs(display_rule($rule->predicate));
        if ($extra->{completions}) {
            display_completions(@{ delete $extra->{completions} });
        }

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

    if ($extra->{completions}) {
        display_completions(@{ $extra->{completions} });
    }
}

sub display_completions {
    my @completions = @_;

    span {
        while (my $c = shift @completions) {
            a {
                attr {
                    class   => 'completion',
                    onclick => "PathDispatcherDebugger.set_path('$c'); return false;",
                    href    => '#',
                }
                $c
            };
            span { ', ' } if @completions;
        }
    }
}

1;

