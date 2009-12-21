package Path::Dispatcher::Debugger;
use Any::Moose;
use Path::Dispatcher;
use Data::Dumper;

has dispatcher => (
    is       => 'ro',
    isa      => 'Path::Dispatcher',
    required => 1,
);

sub handle_request {
    my $self = shift;
    my $request = shift;

    HTTP::Engine::Response->new(body => Dumper($self->dispatcher));
}

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

