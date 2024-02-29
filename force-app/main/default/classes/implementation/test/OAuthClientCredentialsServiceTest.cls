@IsTest
public with sharing class OAuthClientCredentialsServiceTest {
    @IsTest
    public static void testCreateAuthorizedHttpRequest() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpiresIn(3600)
                .setScope('newscope');
        String tenantId = 'tenant1';

        OAuthClientCredentialsServiceInterface oAuthService = new OAuthClientCredentialsService('Auth_Named_Credential');
        HttpRequest httpRequest = oAuthService.createAuthorizedRequest(oAuthToken,tenantId);

        Assert.areEqual('Bearer ' + oAuthToken.getAccessToken(), httpRequest.getHeader('Authorization'));
        Assert.areEqual(tenantId, httpRequest.getHeader('Tenant'));
    }
    @IsTest
    public static void testCreateAuthorizedHttpRequestWithNullToken() {
        OAuthClientCredentialsServiceInterface oAuthService= new OAuthClientCredentialsService('Auth_Named_Credential');
        String tenantId = 'tenant1';
        try{
            HttpRequest httpRequest = oAuthService.createAuthorizedRequest(null,tenantId);
            Assert.fail('Expected IllegalArgumentException to be thrown');
        }catch (IllegalArgumentException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testCreateAuthorizedHttpRequestWithNullAccessToken() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken(null);
        String tenantId = 'tenant1';
        OAuthClientCredentialsServiceInterface oAuthService = new OAuthClientCredentialsService('Auth_Named_Credential');
        try{
            HttpRequest httpRequest = oAuthService.createAuthorizedRequest(oAuthToken,tenantId);
            Assert.fail('Expected IllegalArgumentException to be thrown');
        }catch (IllegalArgumentException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testAuthenticate() {
        OAuthClientCredential credential = new OAuthClientCredential()
                .setClientId('client2')
                .setClientSecret('secret1');

        Test.setMock(HttpCalloutMock.class, new OAuthAuthenticationSuccessCalloutMock());
        OAuthClientCredentialsServiceInterface oAuthService = new OAuthClientCredentialsService('Auth_Named_Credential');
        OAuthToken oAuthToken = oAuthService.authenticate(credential);

        Assert.isNotNull(oAuthToken);
        Assert.isNotNull(oAuthToken.getAccessToken());
        Assert.isNotNull(oAuthToken.getType());
        Assert.isNotNull(oAuthToken.getExpiresIn());
        Assert.isNotNull(oAuthToken.getScope());
        Assert.isNotNull(oAuthToken.getExpireTime());
    }
    @IsTest
    public static void testAuthenticateWithEmptyClientId() {
        OAuthClientCredential credential = new OAuthClientCredential()
                .setClientId(' ')
                .setClientSecret('secret1');

        OAuthClientCredentialsServiceInterface oAuthService = new OAuthClientCredentialsService('Auth_Named_Credential');
        try{
            OAuthToken oAuthToken = oAuthService.authenticate(credential);
            Assert.fail('Expected OAuthException to be thrown');
        }catch (IllegalArgumentException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testAuthenticateWithNullClientSecret() {
        OAuthClientCredential credential = new OAuthClientCredential()
                .setClientId('clientId123')
                .setClientSecret(null);

        OAuthClientCredentialsServiceInterface oAuthService = new OAuthClientCredentialsService('Auth_Named_Credential');
        try{
            OAuthToken oAuthToken = oAuthService.authenticate(credential);
            Assert.fail('Expected OAuthException to be thrown');
        }catch (IllegalArgumentException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testAuthenticateWithBadRequest() {
        OAuthClientCredential credential = new OAuthClientCredential()
                .setClientId('clientId123')
                .setClientSecret('secret1');

        Test.setMock(HttpCalloutMock.class, new BadRequestCalloutMock());
        OAuthClientCredentialsServiceInterface oAuthService = new OAuthClientCredentialsService('Auth_Named_Credential');
        try{
            OAuthToken oAuthToken = oAuthService.authenticate(credential);
            Assert.fail('Expected OAuthException to be thrown');
        }catch (OAuthException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testCreateAuthenticationBody() {
        String clientId = 'client1';
        String clientSecret = 'secret1';

        String expectedBody = 'client_id=client1&client_secret=secret1&grant_type=client_credentials';
        String actualBody = OAuthClientCredentialsService.createClientCredentialBody(clientId, clientSecret);

        Assert.areEqual(expectedBody, actualBody);
    }
}