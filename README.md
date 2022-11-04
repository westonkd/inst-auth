# InstAuth

## Current Data Model
This will need some tweaking, but is a decent start: https://dbdiagram.io/d/636539c5c9abfc6111705ec1

## Quick(ish) Demo
https://www.youtube.com/watch?v=xN60ia1Y7l0

## Central Ideas
*TL;DR* - InstAuth speaks OAuth2 + OIDC with clients. It's an abstractiont that knows how to auth with
a large variety of established (or custom) auth providers. These providers are configurable by the
InstAuth tenant owners.

- Each region has a regional tenant. Each regional tenant has many "normal" tenants
  - Regional tenant host: `us-east-1.id.instructure.docker`
  - Normal tenant: `hogwarts.us-east-1.id.instructure.docker`
- Each tenant can have many Connections. Connections contain Authn/Authz provider client information
  (Like Google, Microsoft, custom OIDC provider, whatever)
- The first connection that we should enable is the "Canvas LMS" connection pointing to the tenant's
  associated Canvas host
- Connections have many Applications. Applications are like developer keys in Canvas, but customizable
  (example: They allow selecting a grant_type)
- End clients (like new quizzes) do OIDC with InstAuth. InstAuth, in turn, does OIDC/whatever with the
  user selected Connection, provisions a user (or finds them), and generates an internal InstAuth access_token and id_token (JWTs)
- InstAuth access_tokens are opaque to clients. They are intended to be consumed by an API Gateway
- InstAuth id_tokens are signed with an InstAuth private key and are intended to be consumed by clients
- InstAuth exposes a JWK keyset per tenant

## Swimlane Diagram of Request Flow
https://swimlanes.io/d/DONLGfdtO
<img src="https://static.swimlanes.io/0c2c094ccac963a28252fd09f58030d5.png">
