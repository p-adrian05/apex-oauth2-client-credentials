/**
 *  Authentication Service for OAuth 2.0 Client Credentials Flow
 */
public with sharing class OAuthClientCredentialsService implements OAuthClientCredentialsServiceInterface {
    private final static String AUTHORIZATION_HEADER = 'Authorization';
    private final static String TENANT_HEADER = 'Tenant';
    private final static String CONTENT_TYPE_HEADER = 'Content-Type';

    private final static String AUTH_CONTENT_TYPE= 'application/x-www-form-urlencoded';
    private final static String HTTP_METHOD_POST = 'POST';
    private final static String CALLOUT = 'callout:';
    private final static String CLIENT_CREDENTIALS_GRANT_TYPE = 'client_credentials';
    private final static String BEARER = 'Bearer ';

    private final String AUTH_NAMED_CREDENTIAL;

    public OAuthClientCredentialsService(String authNamedCredential){
        ObjectUtil.requireNonEmpty(authNamedCredential,'Auth Named Credential cannot be empty for OAuth Service!');
        this.AUTH_NAMED_CREDENTIAL = authNamedCredential;
    }
    /**
     * Creates an authorized HTTP request with the provided OAuth token and optional tenant ID.
     *
     * @param oauthToken The OAuth token to use for authorization.
     * @param tenantId The optional tenant ID to include in the request header.
     * @return An authorized HttpRequest object.
    */
    public HttpRequest createAuthorizedRequest(OAuthToken oauthToken,String tenantId){
        ObjectUtil.requireNonNull(oauthToken,'OAuthToken cannot be null!');
        ObjectUtil.requireNonEmpty(oauthToken.getAccessToken(),'Access Token cannot be empty!');

        HttpRequest request = new HttpRequest();
        request.setHeader(AUTHORIZATION_HEADER, BEARER+oauthToken.getAccessToken());
        if(String.isNotBlank(tenantId)){
            request.setHeader(TENANT_HEADER,tenantId);
        }
        return request;
    }
    /**
     * Authenticates the client using the provided OAuth client credential.
     *
     * @param oAuthClientCredential The OAuth client credential used for authentication.
     * @return An OAuthToken object representing the authenticated token.
     * @throws OAuthException If the authentication fails.
    */
    public OAuthToken authenticate(OAuthClientCredential oAuthClientCredential){
        ObjectUtil.requireNonNull(oAuthClientCredential,'Client Credential cannot be empty for OAuth authentication!');
        ObjectUtil.requireNonEmpty(oAuthClientCredential.getClientId(),'Client Id cannot be empty for OAuth authentication!');
        ObjectUtil.requireNonEmpty(oAuthClientCredential.getClientSecret(),'Client Secret cannot be empty for OAuth authentication!');

        HttpRequest req = new HttpRequest();
        req.setHeader(CONTENT_TYPE_HEADER,AUTH_CONTENT_TYPE);
        req.setEndpoint(CALLOUT+AUTH_NAMED_CREDENTIAL);
        req.setMethod(HTTP_METHOD_POST);
        req.setBody(createClientCredentialBody(oAuthClientCredential.getClientId(),oAuthClientCredential.getClientSecret()));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode()<300) {
            return OAuthToken.deserialize(res.getBody());
        }else{
            ApiError apiError = ApiError.deserializeJson(res.getBody());
            System.debug(LoggingLevel.ERROR,apiError);
            throw new OAuthException('Failed to authenticate: '+apiError);
        }
    }
    @TestVisible
    private static String createClientCredentialBody(String clientId, String clientSecret){
        return String.format('client_id={0}&client_secret={1}&grant_type={2}', new List<String>{
                clientId,
                clientSecret,
                CLIENT_CREDENTIALS_GRANT_TYPE
        });
    }
}