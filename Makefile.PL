use inc::Module::Install;

name       'Path-Dispatcher-Debugger';
all_from   'lib/Path/Dispatcher/Debugger.pm';
repository 'http://github.com/bestpractical/path-dispatcher-debugger';

requires 'Any::Moose';
requires 'Plack::Request';
requires 'Plack::App::File';
requires 'Plack::App::Template::Declare';
requires 'Path::Dispatcher';
requires 'Template::Declare';
requires 'Scalar::Util';

install_script('bin/path-dispatcher-debugger');
install_share;

WriteAll;

