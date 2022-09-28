<?php

namespace PHPMeetup\Helpers;

function camelize(string $input, string $separator = '_'): string
{
    return str_replace($separator, '', ucwords($input, $separator));
}


function placeholders(array $items): string
{
    return rtrim(str_repeat('?,', sizeof($items)), ',');
}