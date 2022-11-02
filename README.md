# InstAuth

## Central Ideas
- Clients only do OAuth2/OIDC with InstAuth
- InstAuth supports "connections" to authn services and performs the proper authn exchange for whichever connection the user selects. We could have some generic like "OIDC Provier" and "SAML Provider", but also have specific connections available like "Google."
- Canvas is the first "connection" supported in InstAuth. Connections can then be moved one at a time from Canvas into InstAuth.
- Each service backing a connection exposes a standard ".well-known" openid-configuration endpoint for discovery of scopes, etc.
- Callbacks goes to a regional tenant, which redirect to a specific tenant based on JWT state contents. This reduces the number of callback URLs we need to manage in providers.
- Each tenant allows users to create "Applications," which are credential sets. "Applications" let users select grant types (auth code, pkce, client credentials, etc)
- Each tenant has a JWKS key set to allow verification of id_tokens they issue
- Tokens issued by InstAuth are signed (and encrypted) with a secret shared with API Gateway