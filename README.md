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
1. Update [config/database.yml](config/database.yml), [config/cable.yml](config/cable.yml), and [config/envirotnments/production.rb](config/envirotnments/production.rb) file and replace `marketplace_starter_rails` with the name of your application.
1. `bin/rails db:create`
1. `bin/rails db:migrate`
1. Edit your credentials/secrets using `bin/rails credentials:edit`
1. Install foreman: `gem install foreman`
1. Run the specs with `bin/ci`
1. Start the application in development mode with `bin/dev`

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
You need to make sure to replace that with your valid credentials (as defined in your `.env` file).


#### Healthcheck:

```sh
../qn-marketplace-cli/qn-marketplace-cli healthcheck --url http://localhost:3009/healthcheck
```

#### Provisioning:

```sh
../qn-marketplace-cli/qn-marketplace-cli pudd --base-url http://localhost:3009 --basic-auth dXNlcm5hbWU6cGFzc3dvcmQ= --quicknode-id foobar
```

#### SSO:

Below, make sure that the `jwt-secret` matches `QN_SSO_SECRET` in `.env` file.

```
../qn-marketplace-cli/qn-marketplace-cli sso --url http://localhost:3009/provision  --basic-auth dXNlcm5hbWU6cGFzc3dvcmQ= --jwt-secret jwt-secret --email jon@example.com --name jon --org QuickNode --quicknode-id foobar
```

#### RPC:

```sh
../qn-marketplace-cli/qn-marketplace-cli rpc --url http://localhost:3009/provision --rpc-url http://localhost:3009/rpc --rpc-method qn_test --rpc-params "[\"abc\"]" --basic-auth dXNlcm5hbWU6cGFzc3dvcmQ= --quicknode-id foobar
```


## Obtaining the Basic Auth String

To obtain a basic auth string, you can use Go or your language of choice with your username and password, as such:

```go
package main

import (
	"encoding/base64"
	"fmt"
)

func main() {
	data := "username:password"
	encodedData := base64.StdEncoding.EncodeToString([]byte(data))
	fmt.Println(encodedData)
}
```

## LICENSE

MIT