use t::Utils config => +{
    type   => 'Binary',
    driver => 'DBI',
    dsn    => 'dbi:mysql:database=test',
};
run;
