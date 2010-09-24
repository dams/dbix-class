use strict;
use warnings;

#FIXME find a better name for this test and possibly move to the right subdir

use Test::More;
use Test::Exception;

use lib qw(t/lib);
use DBIC::SqlMakerTest;
use DBICTest;

my $schema = DBICTest->init_schema();

lives_ok {
    my $tags_rs = $schema->resultset('Tag');

    $tags_rs->search(
        {
            tagid => 42,
        },
        {
            order_by => [
                sprintf '%s.tag', $tags_rs->current_source_alias
            ],
        }
    )->related_resultset('cd')->search(
        undef,
        {
            rows => 1,
        }
    )->related_resultset('tracks')->first;
} "Chaining searches with m2o/order_by and o2m/rows does not die";

done_testing;
