# InstAuth

## Central Ideas
- Clients only do OAuth2/OIDC with InstAuth
- InstAuth supports "connections" to authn services and performs the proper authn exchange for whichever connection the user selects
- Canvas is the first "connection" supported in InstAuth. Connections can then be moved one at a time from Canvas into InstAuth.
- Each service backing a connection exposes a standard ".well-known" openid-configuration endpoint for discovery of scopes, etc.