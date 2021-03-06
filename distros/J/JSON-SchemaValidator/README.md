# NAME

JSON::SchemaValidator - JSON Schema Validator

# SYNOPSIS

    my $validator = JSON::SchemaValidator->new;

    my $result = $validator->validate([1], {type => 'object'});

    if (!$result->is_success) {
        #  [
        #    {
        #        uri       => '#',
        #        message   => "Must be of type object",
        #        attribute => 'type',
        #        details   => ['object']
        #    }
        #  ]

        return $result->errors;
    }

# DESCRIPTION

[JSON::SchemaValidator](https://metacpan.org/pod/JSON%3A%3ASchemaValidator) is a JSON schema validator.

# DEVELOPMENT

## Repository

    http://github.com/vti/json-schemavalidator

## Testing

This distribution contains specification tests, that can run as following:

    # Run specific draft
    JSON_SCHEMA_SPEC='draft=draft4' prove t/spec.t

    # Run specific suite
    JSON_SCHEMA_SPEC='draft=draft4!suite=minProperties' prove t/spec.t

# CREDITS

# AUTHOR

Viacheslav Tykhanovskyi, `vti@cpan.org`.

# COPYRIGHT AND LICENSE

Copyright (C) 2020, Viacheslav Tykhanovskyi

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.
