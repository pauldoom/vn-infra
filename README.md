# VoltageNoir Infra

A small collection of infrastructure as code that declares
the resources I want in the world.

## State and Locking

All state is stored in AWS S3 with one top level state bucket
per-account/region.

All locking is performed with a DynamoDB lock table with one
top level table per-account/region.

`bin/aws_init` will create the S3 bucket and DynamoDB table
as needed and is safe to rerun.

The `stacks/account` stack is used to track these resources.
