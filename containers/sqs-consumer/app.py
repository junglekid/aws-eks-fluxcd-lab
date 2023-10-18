'''
Python App to show how to receive and delete messages from AWS SQS Queue
'''
import logging
import os
import sys
import time
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)
sqs = boto3.resource("sqs")


def get_queue(name):
    """
    Gets an SQS queue by name.
    """
    try:
        queue = sqs.get_queue_by_name(QueueName=name)
        logger.info("Got queue '%s' with URL=%s", name, queue.url)
    except ClientError as error:
        logger.exception("Couldn't get queue named %s.", name)
        raise error
    else:
        return queue


def delete_messages(queue, messages):
    """
    Delete a batch of messages from a queue in a single request.
    """
    try:
        entries = [
            {"Id": str(ind), "ReceiptHandle": msg.receipt_handle}
            for ind, msg in enumerate(messages)
        ]
        response = queue.delete_messages(Entries=entries)
        if "Successful" in response:
            for msg_meta in response["Successful"]:
                logger.info("Deleted %s",
                            messages[int(msg_meta["Id"])].receipt_handle)
        if "Failed" in response:
            for msg_meta in response["Failed"]:
                logger.warning("Could not delete %s",
                               messages[int(msg_meta["Id"])].receipt_handle)
    except ClientError:
        logger.exception("Couldn't delete messages from queue %s", queue)
    else:
        return response


def receive_messages(queue, max_number, wait_time):
    """
    Receive a batch of messages in a single request from an SQS queue.
    """
    try:
        messages = queue.receive_messages(
            MessageAttributeNames=['All'],
            MaxNumberOfMessages=max_number,
            WaitTimeSeconds=wait_time
        )
        for msg in messages:
            logger.info("Received message: %s: %s", msg.message_id, msg.body)
    except ClientError as error:
        logger.exception("Couldn't receive messages from queue: %s", queue)
        raise error
    else:
        return messages


def main():
    """
    Main Function
    """
    sqs_queue_name = os.getenv('SQS_QUEUE_NAME')
    # sqs_queue_name = 'eks-fluxcd-lab-sqs-queue'
    sleep_wait = int(os.getenv('SLEEP_WAIT'))
    # sleep_wait = 10

    sleep = True
    while sleep:
        sqs_queue = get_queue(sqs_queue_name)
        batch_size = 10
        print(f"Receiving, handling, and deleting messages in \
              batches of {batch_size}.")
        more_messages = True
        while more_messages:
            received_messages = receive_messages(sqs_queue, batch_size, 5)
            print(".", end="")
            sys.stdout.flush()
            if received_messages:
                delete_messages(sqs_queue, received_messages)
            else:
                more_messages = False
        print("Done.")
        if sleep:
            time.sleep(sleep_wait)
            print(f"\nSleeping for {sleep_wait} seconds...")


if __name__ == '__main__':
    main()
