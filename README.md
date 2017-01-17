# docker-localdev

Miscellaneous docker images intended for local development

- [AWS DynamoDB local](#aws-dynamodb-local)
- [AWS Fake SQS](#aws-fake-sqs)

## AWS DynamoDB local

Runs [DynamoDB Local](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)
in "shared DB" mode (one set of tables regardless of region and credentials). The server is exposed 
on **port 8000**.

To optionally initialize your local deployment (with tables, prepopulated data, etc.), you can mount a
host directory as a data volume to ```/bootstrap```. The following file types will be used for initialization.

- ```*.sh``` files will be executed, and the environment variable, ```$DYNAMO_ENDPOINT_URL``` will
  be available in the scripts. For example:
  ```
  #!/bin/bash

  aws dynamodb create-table \
    --table-name mytable \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url $DYNAMO_ENDPOINT_URL
  ```

- ```*.json``` files should contain a json [table definition](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html#API_CreateTable_RequestSyntax).
  For example:
  ```
  {
    "TableName": "mytable",
    "KeySchema": [
        {
            "AttributeName": "id",
            "KeyType": "HASH"
        }
    ],
    "AttributeDefinitions": [
        {
            "AttributeName": "id",
            "AttributeType": "S"
        }
    ],
    "ProvisionedThroughput": {
        "ReadCapacityUnits": 5,
        "WriteCapacityUnits": 5
    }
  }
  ```

Sample command: ```docker run -v /path/to/bootstrap:/bootstrap -p 8000:8000 <aws-dynamodb-local-image>```

## AWS Fake SQS

Runs [Fake SQS](https://github.com/iain/fake_sqs). The server is exposed on **port 4568**.

To optionally initialize your local deployment (with queues, prepopulated messages, etc.), you can mount a
host directory as a data volume to ```/bootstrap```. The following file types will be used for initialization.

- ```*.sh``` files will be executed, and the environment variable, ```$SQS_ENDPOINT_URL``` will
  be available in the scripts. For example:
  ```
  #!/bin/bash

  aws sqs create-queue --queue-name myqueue1 --endpoint-url $SQS_ENDPOINT_URL
  aws sqs create-queue --queue-name myqueue2 --endpoint-url $SQS_ENDPOINT_URL
  ```

Sample command: ```docker run -v /path/to/bootstrap:/bootstrap -p 4568:4568 <aws-fake-sqs>```