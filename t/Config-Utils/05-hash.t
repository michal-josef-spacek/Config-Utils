# Modules.
use Cnf::Utils qw(hash);
use English qw(-no_match_vars);
use Test::More 'tests' => 8;

print "Testing: hash().\n";
my $self = {
	'config' => {},
	'stack' => [],
};
hash($self, ['key'], 'val');
is($self->{'config'}->{'key'}, 'val');

$self = {
	'config' => {},
	'stack' => [],
};
hash($self, ['key', 'subkey'], 'val');
is(ref $self->{'config'}->{'key'}, 'HASH');
is($self->{'config'}->{'key'}->{'subkey'}, 'val');

$self = {
	'config' => {
		'key' => 'value',
	},
	'set_conflicts' => 0,
	'stack' => [],
};
hash($self, ['key'], 'val');
is($self->{'config'}->{'key'}, 'val');

$self = {
	'config' => {
		'key' => 'value',
	},
	'set_conflicts' => 0,
	'stack' => [],
};
hash($self, ['key', 'subkey'], 'val');
is(ref $self->{'config'}->{'key'}, 'HASH');
is($self->{'config'}->{'key'}->{'subkey'}, 'val');

$self = {
	'config' => {
		'key' => 'value',
	},
	'set_conflicts' => 1,
	'stack' => [],
};
eval {
	hash($self, ['key'], 'val');
};
is($EVAL_ERROR, "Conflict in 'key'.\n");

$self = {
	'config' => {
		'key' => 'value',
	},
	'set_conflicts' => 1,
	'stack' => [],
};
eval {
	hash($self, ['key', 'subkey'], 'val');
};
is($EVAL_ERROR, "Conflict in 'key'.\n");
