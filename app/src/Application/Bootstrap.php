<?php

namespace PHPMeetup\Application;

use function PHPMeetup\Helpers\camelize;

class Bootstrap
{
    public function load(array $argv)
    {
        @[$cli, $name, $args] = $argv;
        if (!$name) {
            die("Command name argument missing.\n");
        }
        $name = camelize($name);
        $fqdn_name = '\\PHPMeetup\\Command\\'.$name;
        if(class_exists($fqdn_name)){
            $instance = new $fqdn_name();
            if($instance instanceof CommandInterface){
                $instance->run($args ?? []);
            }
        }
    }
}
