public interface OAuthClientCredentialsServiceInterface {
    /**
   * Creates an authorized HTTP request with the provided OAuth token and optional tenant ID.
   *
   * @param oauthToken The OAuth token to use for authorization.
   * @param tenantId The optional tenant ID to include in the request header.
   * @return An authorized HttpRequest object.
    */
    HttpRequest createAuthorizedRequest(OAuthToken oauthToken,String tenantId);
    /**
    * Authenticates the client using the provided OAuth client credential.
    *
    * @param oAuthClientCredential The OAuth client credential used for authentication.
    * @return An OAuthToken object representing the authenticated token.
    * @throws OAuthException If the authentication fails.
   */
    OAuthToken authenticate(OAuthClientCredential oAuthClientCredential);
}