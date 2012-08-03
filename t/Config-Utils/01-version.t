# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Utils;
use Test::More 'tests' => 1;

# Test.
is($Config::Utils::VERSION, 0.04, 'Version.');
