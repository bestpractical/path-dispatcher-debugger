package Path::Dispatcher::Debugger;
use Any::Moose;
use Any::Moose '::Util::TypeConstraints' => [qw/subtype as coerce from via/];
use Path::Dispatcher;

use Path::Dispatcher::Debugger::View;
use constant view_class => 'Path::Dispatcher::Debugger::View';

subtype 'PathDispatcher'
    => as 'Path::Dispatcher';

coerce 'PathDispatcher'
    => from 'Str'
    => via {
        my $dispatcher = $_;
        if ($dispatcher =~ /^{/) {
            $dispatcher = eval $dispatcher;
            die $@ if $@;
        }
        else {
            Any::Moose::load_class($dispatcher);
        }

        if ($dispatcher->isa('Path::Dispatcher::Declarative')) {
            $dispatcher = $dispatcher->dispatcher;
        }

        $dispatcher;
    };

has dispatcher => (
    is       => 'ro',
    isa      => 'PathDispatcher',
    coerce   => 1,
    required => 1,
);

no Any::Moose;
no Any::Moose '::Util::TypeConstraints';

1;

__END__

=head1 NAME

Path::Dispatcher::Debugger - flexible and extensible dispatch

=head1 SYNOPSIS

    plackup bin/pddb.psgi

=head1 AUTHOR

Shawn M Moore, C<< <sartak at bestpractical.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-path-dispatcher-debugger at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Path-Dispatcher-Debugger>.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Best Practical Solutions.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

