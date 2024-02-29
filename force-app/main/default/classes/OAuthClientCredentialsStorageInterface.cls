public interface OAuthClientCredentialsStorageInterface {
    OAuthToken getToken();
    OAuthClientCredential getCredential();
    void updateToken(OAuthToken token);
    void updateCredential(OAuthClientCredential credential);
}