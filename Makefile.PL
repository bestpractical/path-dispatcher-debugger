use inc::Module::Install;

name       'Path-Dispatcher-Debugger';
all_from   'lib/Path/Dispatcher/Debugger.pm';
repository 'http://github.com/bestpractical/path-dispatcher-debugger';

requires 'Any::Moose';
requires 'HTTP::Engine';
requires 'Path::Dispatcher';
requires 'Template::Declare';

WriteAll;

