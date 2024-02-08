# marketplace-starter-rails

This repo is an example of how to build a [QuickNode Marketplace](https://quicknode.com/marketplace) add-on using Ruby on Rails and PostgreSQL.

It implements the 4 provisioning routes that a partner needs to [integrate with Marketplace](https://www.quicknode.com/guides/quicknode-products/marketplace/how-provisioning-works-for-marketplace-partners/), as well as the required Healthcheck route.

It also has support for:

- [RPC methods](https://www.quicknode.com/guides/quicknode-products/marketplace/how-to-create-an-rpc-add-on-for-marketplace/) via a `POST /rpc` route
- [A dashboard view](https://www.quicknode.com/guides/quicknode-products/marketplace/how-sso-works-for-marketplace-partners/) with Single Sign On using JSON Web Tokens (JWT).


## Getting Started

To install and run the application locally:

1. Clone this repo.
1. `bundle`
1. Update the this [README.md](README.md) file to have the name of your add-on, etc...
1. Update [config/database.yml](config/database.yml), [config/cable.yml](config/cable.yml), and [config/envirotnments/production.rb](config/environments/production.rb) file and replace `marketplace_starter_rails` with the name of your application.
1. `cp .env.example .env` and then update as you see fit.
1. `bin/rails db:create`
1. `bin/rails db:migrate`
1. Edit your credentials/secrets using `bin/rails credentials:edit`.
1. Install foreman: `gem install foreman`
1. Run the specs with `bin/ci`
1. Start the application in development mode with `bin/dev`
1. Visit [http://localhost:3009/](http://localhost:3009)

## Routes

The application has 4 provisioning routes protected by HTTP Basic Auth:

- `POST /provision`
- `PUT /update`
- `DELETE /deactivate_endpoint`
- `DELETE /deprovision`

It has a public healthcheck route that returns 200 if the service and the database is up and running:

- `GET /healthcheck`

It has a dashboard that can be accessed using Single Sign On with JSON Web Token (JWT):

- `GET /dash/:id?jwt=foobar`

It has an JSON RPC route:

- `POST /rpc`

## Adding RPC Methods

To add a new RPC method, simply add a new file to the [app/services/rpc_method_handlers](app/services/rpc_method_handlers) directory following the naming convention where the filename should be the name of the method lowercased and using `_` (for example: `eth_send_raw_transaction` or `qn_get_token_balance`) and the class should be inside the `RPCMethodHandlers` module and have a name in camel case (for example, `EthSendRawTransaction` or `QnGetTokenBalance`). These handlers must have an initialize class that accepts the params and have a `call` method which should return a ruby hash that can be converted to JSON using `.to_json`.

As an example, take a look at [app/services/rpc_method_handlers/qn_hello_world.rb](app/services/rpc_method_handlers/qn_hello_world.rb) or [app/services/rpc_method_handlers/eth_send_raw_transaction_faster.rb](app/services/rpc_method_handlers/eth_send_raw_transaction_faster.rb)

## Making calls to the customer's endpoint

This Rails app has a service object that makes it easy to make RPC calls to the customer's endpoint. You can use it like this:

```ruby
endpoint = Endpoint.last
service = EndpointService.neW(endpoint)
response = service.rpc_call('eth_blockNumber', [])
puts response
```

## Testing with qn-marketplace-cli

You can use the [qn-marketplace-cli](https://github.com/quiknode-labs/qn-marketplace-cli) tool to quickly test your add-on while developing it.

For the commands below, the `--basic-auth` flag is the Base64 encoding of `username:password`.
You need to make sure to replace that with your valid credentials (as defined in your `bin/rails credentials:edit`).


#### Healthcheck:

```sh
../qn-marketplace-cli/qn-marketplace-cli healthcheck --url http://localhost:3009/healthcheck
```

#### Provisioning:

```sh
../qn-marketplace-cli/qn-marketplace-cli pudd --base-url http://localhost:3009 --basic-auth dXNlcm5hbWU6cGFzc3dvcmQ=
```

#### SSO:

Below, make sure that the `jwt-secret` matches `QN_SSO_SECRET` in `bin/rails credentials:edit`

```
../qn-marketplace-cli/qn-marketplace-cli sso --url http://localhost:3009/provision  --basic-auth dXNlcm5hbWU6cGFzc3dvcmQ= --jwt-secret jwt-secret --email jon@example.com --name jon --org QuickNode
```

#### RPC:

```sh
../qn-marketplace-cli/qn-marketplace-cli rpc --url http://localhost:3009/provision --rpc-url http://localhost:3009/rpc --rpc-method qn_hello_world --rpc-params "[\"abc\"]" --basic-auth dXNlcm5hbWU6cGFzc3dvcmQ= --verbose
```

## Deploying

### Deploying to Heroku

To deploy to heroku:

1. Ensure you have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed on your machine.
1. Login to Heroku from CLI: `heroku login`
1. Create the application `heroku apps:create <your app name>`. Make sure you replace `<your app name>` with the name of your add-on.
1. Add Postgresql database: `heroku addons:create heroku-postgresql:basic`. You can change to a bigger plan such as `standard-0` or `standard-2` instead of `basic` if you want a more robust database.
1. Set your master key on heroku config for rails credentials: `heroku config:set RAILS_MASTER_KEY=yourkey`
1. Deploy it with `git push heroku main`
1. Open the app: `heroku open`
1. Verify that the healtheck endpoint works by adding `/healthcheck` at the end of the URL from previous step. You should see a green page.

## LICENSE

MIT