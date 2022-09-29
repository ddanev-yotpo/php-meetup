<?php

namespace PHPMeetup\Command;

use Exception;
use PDO;
use PHPMeetup\Application\BaseCommand;
use PHPMeetup\Helpers\AwsSqsClient;
use function PHPMeetup\Helpers\placeholders;

class Leader extends BaseCommand
{
    private PDO $connection;

    public function run(array $argv = [])
    {
        $this->connection = new PDO(getenv('DB_PDO_DSN'));
        $sqs_client = new AwsSqsClient(getenv('SQS_URL'));

        while (!$this->stop_requested) {
            try {
                $this->connection->beginTransaction();
                $numbers = $this->getUnprocessedNumbers();

                if (!$numbers) {
                    $this->log('Numbers set is empty');
                    $this->connection->commit();
                    sleep(5);
                    continue;
                }

                $this->log('Start processing ' . count($numbers) . ' rows!');

                $items = [];
                foreach ($numbers as $number) {
                    $items[$number['id']] = [
                        'data' => [
                            'id' => $number['id'],
                            'number' => $number['number'],
                        ]
                    ];
                }
                $this->log('End processing rows!');
                $this->log('Start pushing messages to SQS!');
                $result = $sqs_client->pushMessages($items);

                if ($result === false) {
                    throw new Exception('Failed pushing messages to SQS');
                }
                $this->log('End pushing messages to SQS!');

                $this->log('Start updating rows to pushed!');
                $this->updateNumbersToPushed(array_keys($items));
                $this->log('End updating rows to pushed!');

                $this->connection->commit();
                $this->fakeLoad();
            } catch (Exception $e) {
                $this->log($e->getMessage());
                $this->connection->rollBack();
                sleep(5);
            }
        }
    }

    private function fakeLoad()
    {
        for ($i=0; $i<1e8; $i++ ){
            $x = rand(1,999999);
        }
    }

    private function getUnprocessedNumbers(): array
    {
        return $this->connection->query(
            "SELECT `id`, `number`
                FROM `read`
                WHERE
                    `processed` = 0 AND
                    `pushed_timestamp` IS NULL
                LIMIT 100
                FOR UPDATE
                SKIP LOCKED;
            ")->fetchAll();
    }

    private function updateNumbersToPushed(array $ids): int|bool
    {
        $placeholders = placeholders($ids);
        $current_time = date('Y-m-d H:i:s', time());
        $sql = "UPDATE `read`
            SET `pushed_timestamp` = '{$current_time}'
            WHERE `id` IN ($placeholders)";
        $stmt = $this->connection->prepare($sql);

        return $stmt->execute($ids);
    }
}