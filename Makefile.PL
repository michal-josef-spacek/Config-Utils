# Pragmas.
use strict;
use warnings;

# Modules.
use inc::Module::Install;

# Definition.
abstract 'Config utilitites.';
author 'Michal Špaček <skim@cpan.org>';
license 'bsd';
name 'Config-Utils';
requires 'Error::Pure' => 0.05;
requires 'Exporter' => 0;
requires 'Readonly' => 0;
resources 'repository' => {
	'url' => 'git://github.com/tupinek/Config-Utils',
	'web' => 'https://github.com/tupinek/Config-Utils',
	'type' => 'git',
};
test_requires 'English' => 0;
test_requires 'File::Object' => 0.03;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
