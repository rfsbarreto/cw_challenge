# Rails Application

This is a Rails application that is designed to be run with docker-compose.

## Running the Rails application inside a Docker container

Follow these steps to run the Rails application inside a Docker container:

1. Make sure Docker and docker-compose are installed on your machine.
2. Navigate to the directory containing the `docker-compose.yml` file.
3. Run the following command to build and start the Docker containers:

```bash
docker-compose up --build
docker-compose exec web rails db:setup

```

The Rails server should now be running on your local machine at `localhost:3000`.

## Running RSpec inside the Docker container

To run RSpec inside the Docker container, follow these steps:

1. If you haven't already, start the Docker containers using the `docker-compose up` command described above.
2. Run the following command to execute RSpec:

```bash
docker-compose run --rm web bundle exec rspec

```

This will run all RSpec tests within the Docker container.

## Application Endpoints

This application has the following endpoints:

1. `POST /transactions`: This endpoint is used to send transaction information. The response payload indicates whether the transaction was approved or denied.
    
    ```jsx
    curl --location 'localhost:3000/transactions/' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic Y2xvdWR3YWxrOmFfdG9rZW4=' \
    --data '{
    "transaction_id" : 20,
    "merchant_id" : 29744,
    "user_id" : 9605,
    "card_number" : "434505******9116",
    "transaction_date" : "2019-11-31T13:16:11.812632",
    "transaction_amount" : 373,
    "device_id" : 285475
    }'
    ```
    
2. `POST /transactions/:id/chargeback`: This endpoint is used to set a transaction as chargebacked.
    
    ```jsx
    curl --location --request POST 'localhost:3000/transactions/20/chargeback' \
    --header 'Authorization: Basic Y2xvdWR3YWxrOmFfdG9rZW4=' 
    ```
    

## Architecture Decisions

The architecture of this application is based on a service object approach. This design pattern was chosen for its ability to keep the application modular, making it easier to maintain and scale.

There are two main services in the application:

1. `Transactions::Creator`: This service is responsible for creating transactions. It encapsulates the logic of creating a new transaction, making sure that the controller stays lean and the model free of business logic.
2. `Transactions::CheckFraud`: This service is designed to check for potential fraud in transactions. By isolating this logic in a separate service, it's easier to modify the fraud detection rules without impacting other parts of the application.

Both are used into the `POST /transaction`  endpoint, to persist and then check if the transaction is fraudulent or not

## Database Modeling

Instead of only a Transaction model, I put up a more robust solution with User and Merchant models, with this I could structure the Application in a way that it is easily extendable. 

![Untitled](erb.png)

In the current solution, I have already incorporated certain attributes into their own Entity. These include 'block_transactions' and 'max_transaction_amount' for the User model, as well as 'block_transactions' and 'number_of_chargebacks' for the Merchant model. From an architectural perspective, this structure  is more open to extensions in Rules.

An alternative to my approach is to have only a transactions model, with predetermined rules framed as SQL queries inside scopes. While this method works, it could become difficult to maintain as we add more rules over time.

## Rules

I applied 4  pre-determined rules into the approval ou deny of transaction:

- User is blocked:
    - User already has a chargeback in history
- Merchant is blocked:
    - Got the ideia from the sample file provided
    - If a merchant has 30% of transactions chargebacked within a week were he had a certain minimum number of transactions, the merchant is blocked.
    - Rule is applied through a schedule task: `lib/tasks/update_merchants_blocked_transactions.rake`
- Transaction above a user limit, defaulting to 2.000
- Too much transactions under timeframe: defaults of 3 transactions under 2 minutes

## Machine Learning Prediction

Under the timeline of the project I was not able to study enough to make a good and relevant model, but that is because I never did something like it since my graduation days. However the architecture is extensible enough to easily add a existent model or even call a service that predicts. It would need a new service `transactions/ml_model` , where you could chain his call inside `Transactions::CheckFraud` .

## Challenge Questions and Data Analysis

The answers for the Challenge questions can be found in the `answers` directory on `answers.pdf` file. The Jupyter Notebook for the analysis could be found in `answers/CW_data_analysis.ipynb`