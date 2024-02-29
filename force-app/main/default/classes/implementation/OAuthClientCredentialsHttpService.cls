/**
 * HttpService implementation for OAuth 2.0 Client Credentials Flow.
 */
public with sharing class OAuthClientCredentialsHttpService implements HttpServiceInterface,TestConnectionServiceInterface{
    private final static String CALLOUT = 'callout:';
    private final static String HTTP_METHOD_GET = 'GET';
    private final static String HTTP_METHOD_POST = 'POST';

    private final OAuthClientCredentialsStorageInterface oAuthStorage;
    private final OAuthClientCredentialsServiceInterface oAuthService;

    public OAuthClientCredentialsHttpService(OAuthClientCredentialsStorageInterface oAuthStorage,
            OAuthClientCredentialsServiceInterface oAuthService) {
        this.oAuthStorage = oAuthStorage;
        this.oAuthService = oAuthService;
    }
    /**
     * Sends a GET request to the specified URL using the provided named credential, path parameters, and query parameters.
     *
     * @param namedCredential The named credential to use for the request.
     * @param pathParam The path parameters to include in the URL, e.g. /{recordId}.
     * @param queryParams The query parameters to include in the URL e.g. ?name=value.
     * @return The HTTP response received from the server.
     */
    public HttpResponse GET(String namedCredential,Object pathParam, Map<String,Object> queryParams) {
        String url = ObjectSerializationUtil.serializeURL(namedCredential,pathParam,queryParams);
        HttpRequest req = createHttpRequest(HTTP_METHOD_GET, url);
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
    /**
     * Sends a POST request to the specified URL using the provided named credential, path parameters, and body.
     *
     * @param namedCredential The named credential to use for the request.
     * @param pathParam The path parameters to include in the URL, e.g. /{recordId}.
     * @param body The body object to include in the request.
     * @return The HTTP response received from the server.
     */
    public HttpResponse POST(String namedCredential, Object pathParam,Object body) {
        String url = ObjectSerializationUtil.serializeURL(namedCredential,pathParam,null);
        HttpRequest req = createHttpRequest(HTTP_METHOD_POST, url);
        if(body!=null){
            req.setBody(JSON.serialize(body));
        }
        Http http = new Http();
        HttpResponse res = http.send(req);
        return res;
    }
    /**
     * Tests the connection to a named credential using the provided client credential.
     *
     * @param clientCredential The client credential used for authentication, must be of type OAuthClientCredential.
     * @param namedCredential The name of the named credential to test the connection with.
     * @return A string indicating the success of the connection test.
     * @throws OAuthException If the client credential is not of type OAuthClientCredential or if the connection fails.
    */
    public String testConnection(Object clientCredential,String namedCredential) {
        ObjectUtil.requireNonNull(clientCredential,'Client Credential cannot be null!');
        ObjectUtil.requireNonEmpty(namedCredential,'Named Credential for test connection cannot be empty!');
        if(!(clientCredential instanceof OAuthClientCredential)){
            throw new OAuthException('Client Credential must be of type OAuthClientCredential!');
        }
        OAuthClientCredential oAuthClientCredential = (OAuthClientCredential) clientCredential;

        OAuthToken oAuthToken = oAuthService.authenticate(oAuthClientCredential);
        HttpRequest request = oAuthService.createAuthorizedRequest(oAuthToken,oAuthClientCredential.getTenantId());

        request.setEndpoint(CALLOUT+namedCredential);
        request.setMethod(HTTP_METHOD_GET);
        Http http = new Http();
        HttpResponse res = http.send(request);

        if(res.getStatusCode() >= 400 && res.getStatusCode() !=404) {
            ApiError apiError = ApiError.deserializeJson(res.getBody());
            System.debug(LoggingLevel.ERROR,apiError);
            throw new OAuthException('Failed to connect! '+apiError);
        }
        System.debug(LoggingLevel.INFO,'Connection successful for Named Credential: '+namedCredential);
        return 'Connection successful!';
    }
    @TestVisible
    private HttpRequest createHttpRequest(String method, String url) {
        OAuthClientCredential oAuthClientCredential = oAuthStorage.getCredential();

        OAuthToken oAuthToken = getApiToken(oAuthClientCredential);
        HttpRequest request = oAuthService.createAuthorizedRequest(oAuthToken,oAuthClientCredential.getTenantId());

        request.setEndpoint(url);
        request.setMethod(method);
        return request;
    }
    @TestVisible
    private OAuthToken getApiToken(OAuthClientCredential oAuthClientCredential){
        OAuthToken cachedOAuthToken = oAuthStorage.getToken();
        if(!cachedOAuthToken.isExpired()){
            return cachedOAuthToken;
        }
        OAuthToken oAuthToken = oAuthService.authenticate(oAuthClientCredential);
        try{
            oAuthStorage.updateToken(oAuthToken);
        }catch (Exception e){
            System.debug(LoggingLevel.ERROR,'Failed to update OAuth token! '+e.getMessage());
        }
        return oAuthToken;
    }
}