import plaid
import plaid.api
from plaid.api import plaid_api
from plaid.model.sandbox_public_token_create_request import SandboxPublicTokenCreateRequest
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
from plaid.model.products import Products
from plaid.model.accounts_balance_get_request import AccountsBalanceGetRequest
from plaid.model.transactions_get_request import TransactionsGetRequest
from plaid.model.transactions_get_request_options import TransactionsGetRequestOptions

from fastapi import FastAPI
import uvicorn
from datetime import datetime
import json

app = FastAPI()

configuration = plaid.Configuration(
    host = plaid.Environment.Sandbox,
    api_key={
        'clientId': '6505d6cb92928f00191e1c13',
        'secret': 'e1f58f3ca77fd96b8b97d82a6d89c8',
    }
)

api_client = plaid.ApiClient(configuration)
client = plaid_api.PlaidApi(api_client)

def get_sandbox():
    '''Returns data for sandbox user: -> {access_token, item_id, request_id}'''
    pt_request = SandboxPublicTokenCreateRequest(
    institution_id='ins_1',
    initial_products=[Products('transactions')]
    )
    pt_response = client.sandbox_public_token_create(pt_request)
    # The generated public_token can now be
    # exchanged for an access_token
    exchange_request = ItemPublicTokenExchangeRequest(
        public_token=pt_response['public_token']
    )
    exchange_response = client.item_public_token_exchange(exchange_request)
    return exchange_response

sandbox_user = get_sandbox()

@app.get('/accounts/balances')
def get_account_balances():
    request = AccountsBalanceGetRequest(access_token=sandbox_user['access_token'])
    response = client.accounts_balance_get(request)
    return response.to_dict()

@app.get("/transactions")
def get_transactions():
    request = TransactionsGetRequest(
            access_token=sandbox_user['access_token'],
            start_date=datetime.strptime('2020-01-01', '%Y-%m-%d').date(),
            end_date=datetime.now().date(),
            options=TransactionsGetRequestOptions(
              include_personal_finance_category=True
            )
    )
    response = client.transactions_get(request)
    transactions = response['transactions']
    return response.to_dict()
    

@app.get('/receipt/analyze')
def analyze_receipt():
    print('Analyzing Receipt')


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8000)