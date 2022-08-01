# Acceptance Tests

This module uses [tfxjs](https://github.com/IBM/tfxjs) to run acceptance tests.

## Running the tests

In your terminal run the following commands in the acceptance_tests directory:
```shell
export TF_VAR_ibmcloud_api_key=<your platform api key>
npm run build
npm run test
```