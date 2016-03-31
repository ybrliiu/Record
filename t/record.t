use Record 'test';
use Test::More;

my $class = 'Record';

subtest 'project_dir' => sub {
  like (Record->project_dir(), qr/Record/);
};

done_testing;
