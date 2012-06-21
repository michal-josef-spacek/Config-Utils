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
requires 'Error::Pure' => 0.07;
requires 'Exporter' => 0;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://rt.cpan.org/Public/Dist/Display.html'.
	'?Name=Config-Utils';
resources 'homepage' => 'https://github.com/tupinek/Config-Utils';
resources 'repository' => 'git://github.com/tupinek/Config-Utils';
test_requires 'English' => 0;
test_requires 'File::Object' => 0.04;
test_requires 'Test::More' => 0;
test_requires 'Test::Pod' => 0;
test_requires 'Test::Pod::Coverage' => 0;
tests_recursive;
version '0.02';

# Run.
WriteAll();
