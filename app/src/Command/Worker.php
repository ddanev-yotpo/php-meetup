<?php

namespace PHPMeetup\Command;

use Exception;
use PDO;
use PHPMeetup\Application\BaseCommand;
use PHPMeetup\Helpers\AwsSqsClient;

class Worker extends BaseCommand
{
    private PDO $connection;

    public function run(array $argv = [])
    {
        $this->connection = new PDO(getenv('DB_PDO_DSN'));
        $this->connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $sqs_client = new AwsSqsClient(getenv('SQS_URL'));

        while (!$this->stop_requested) {
            $messages = $sqs_client->getMessages(10);

            if (!$messages) {
                $this->log('Message set is empty!');
                sleep(5);
                continue;
            }

            $this->log('Start preparing ' . count($messages) . ' messages!');
            $results = [];
            foreach ($messages as $message) {
                $body = $message['Body'] ?? [];

                if (!$body) {
                    $this->log('Error! Empty SQS Body!', $message);
                    continue;
                }
                $body = json_decode($body, true);
                ['number' => $number, 'id' => $id] = $body['data'];
                $results[$id] = [
                    'number' => $number,
                    'sum' => $number + $number,
                    'multiply' => $number * $number,
                ];
            }

            $this->log('End preparing ' . count($messages) . ' messages!');
            try {
                $this->connection->beginTransaction();

                $inserted = $this->saveMany('processed', $results);
                $this->log("Processed inserted [$inserted]");

                $updated = $this->setProcessed('read', array_keys($results));
                $this->log("Read updated [$updated]");
                $sqs_client->deleteMessages($messages);
                $this->connection->commit();
                sleep(10);
            } catch (Exception $e) {
                $this->log($e->getMessage());
                $this->connection->rollBack();
                sleep(5);
            }
        }
    }

    /**
     * @param string $table
     * @param array  $data
     *
     * @return bool
     */
    private function saveMany(string $table, array $data): bool
    {
        $placeholders = [];
        $insert_values = [];
        foreach ($data as $d) {
            $placeholders[] = '(' . rtrim(str_repeat('?,', sizeof($d)), ',') . ')';
            array_push($insert_values, ...array_values($d));
        }
        $columns = array_keys(reset($data));
        $sql = "INSERT INTO `$table` (" . implode(",", $columns) . ") VALUES " .
            implode(',', $placeholders);

        $stmt = $this->connection->prepare($sql);
        return $stmt->execute($insert_values);
    }

    /**
     * @param string $table
     * @param array  $id
     *
     * @return int|bool
     */
    private function setProcessed(string $table, array $id): int|bool
    {
        $placeholders = rtrim(str_repeat('?,', sizeof($id)), ',');
        $sql = "UPDATE `$table`
            SET `processed` = 1
            WHERE `id` IN ($placeholders)";

        $stmt = $this->connection->prepare($sql);
        return $stmt->execute($id);
    }
}