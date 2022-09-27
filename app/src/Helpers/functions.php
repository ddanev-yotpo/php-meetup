<?php

namespace PHPMeetup\Helpers;

function camelize(string $input, string $separator = '_'): string
{
    return str_replace($separator, '', ucwords($input, $separator));
}