# Modules.
use Cnf::Utils qw(conflict);
use English qw(-no_match_vars);
use Test::More 'tests' => 2;

print "Testing: conflict().\n";
my $self = {
	'stack' => [],
};
eval {
	conflict($self, {'key' => 'value'}, 'key');
};
is($EVAL_ERROR, '');

$self->{'set_conflicts'} = 1;
eval {
	conflict($self, {'key' => 'value'}, 'key');
};
is($EVAL_ERROR, "Conflict in 'key'.\n");
