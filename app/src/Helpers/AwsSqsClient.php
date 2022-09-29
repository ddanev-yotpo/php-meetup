<?php

namespace PHPMeetup\Helpers;

use Aws\Result;
use Aws\Sqs\SqsClient;

class AwsSqsClient {
    private SqsClient $sqs_client;

    public function __construct(private readonly string $sqs_queue_url) {
        $options = [
            'version' => 'latest',
            'region' => 'us-east-1'
        ];
        
        $this->sqs_client = new SqsClient($options);
    }

    /**
     * @param int $number_of_messages
     *
     * @return mixed|null
     */
    public function getMessages(int $number_of_messages = 1): mixed
    {
        $result = $this->sqs_client->receiveMessage([
            'AttributeNames' => ['All'],
            'MaxNumberOfMessages' => $number_of_messages,
            'MessageAttributeNames' => ['All'],
            'QueueUrl' => $this->sqs_queue_url,
            'WaitTimeSeconds' => 20,
        ]);

        return $result->get('Messages');
    }

    /**
     * @param array $items
     *
     * @return bool
     */
    public function pushMessages(array $items): bool
    {
        $entries = [];

        foreach ($items as $key => $value) {
            $entry = [
                'Id' => $key
            ];

            if (isset($value['message_deduplication_id'])) {
                $entry['MessageDeduplicationId'] = $value['message_deduplication_id'];
                unset($value['message_deduplication_id']);
            }
            if (isset($value['message_group_id'])) {
                $entry['MessageGroupId'] = $value['message_group_id'];
                unset($value['message_group_id']);
            }

            $entry['MessageBody'] = json_encode($value);
            $entries[] = $entry;
        }

        $batches = array_chunk($entries, 10);
        foreach ($batches as $batch) {
            $response = $this->sqs_client->sendMessageBatch([
                'Entries' => $batch,
                'QueueUrl' => $this->sqs_queue_url,
            ]);

            if (isset($response->toArray()['Failed'])) {
                return false;
            }
        }

        return true;
    }

    /**
     * @param array $messages
     *
     * @return bool
     */
    public function deleteMessages(array $messages): bool
    {
        $entries = [];

        foreach ($messages as $message) {
            $entries[] = [
                'Id' => $message['MessageId'],
                'ReceiptHandle' => $message['ReceiptHandle'],
            ];
        }

        $batches = array_chunk($entries, 10);
        foreach ($batches as $batch) {
            $response = $this->sqs_client->deleteMessageBatch([
                'Entries' => $batch,
                'QueueUrl' => $this->sqs_queue_url,
            ]);

            if (isset($response->toArray()['Failed'])) {
                return false;
            }
        }

        return true;
    }
    
}