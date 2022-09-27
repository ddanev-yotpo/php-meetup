<?php

namespace PHPMeetup\Application;

interface CommandInterface {
    public function run(array $argv);
    public function cleanup();
}