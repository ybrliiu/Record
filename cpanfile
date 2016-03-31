requires 'perl', '5.014004';
requires 'Mouse', '2.4.5';

on 'test' => sub {
    requires 'Test::More', '1.001014';
    requires 'Test::Exception', '0.43';
};

