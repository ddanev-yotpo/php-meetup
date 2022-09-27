<?php

namespace PHPMeetup\Application;

class BaseCommand implements CommandInterface
{

    protected bool $stop_requested = false;
    private int|false $pid;
    private string $command_name;

    public function __construct()
    {
        $this->pid = getmypid();
        $this->command_name = static::class;
        pcntl_async_signals(true);
        pcntl_signal(SIGTERM, [$this, 'cleanShutdown']);
    }

    protected function log(string $message, array $extra = []): void
    {
        $message = "[PID: $this->pid] [Command: $this->command_name] " . $message . "\n";
        if ($extra) {
            $message .= "[EXTRA]\n" . json_encode($extra, JSON_PRETTY_PRINT);
        }
        print($message);
    }

    public function cleanShutdown(): void
    {
        $this->stop_requested = true;
        $this->log('SIGTERM in cleanShutdown');
        $this->cleanup();
    }

    public function run(array $argv)
    {
        // TODO: Implement run() method.
    }

    public function cleanup()
    {
        // TODO: Implement cleanup() method.
    }
}