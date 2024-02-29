
@IsTest
public with sharing class OAuthClientCredentialsHttpServiceTest {
    @IsTest
    public static void testPOST() {
        String namedCredential = 'API_POST';
        String pathParam = 'recordId';
        Test.setMock(HttpCalloutMock.class, new PostRequestCalloutMock());
        OAuthClientCredential clientCredential = new OAuthClientCredential().setTenantId('newTenantId');
        //Mock oauth token
        Stub oAuthTokenStub = new Stub(OAuthToken.class);
        String isExpiredMethodToInvoke = 'isExpired';
        oAuthTokenStub.setReturnValue(isExpiredMethodToInvoke, false);
        OAuthToken oAuthTokenMock = (OAuthToken) oAuthTokenStub.instance;
        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        String getTokenMethodToInvoke = 'getToken';
        String getCredentialMethodToInvoke = 'getCredential';
        oAuthStorageStub.setReturnValue(getTokenMethodToInvoke, oAuthTokenMock);
        oAuthStorageStub.setReturnValue(getCredentialMethodToInvoke, clientCredential);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        String createAuthorizedHttpRequestMethodToInvoke = 'createAuthorizedRequest';
        oAuthServiceStub.setReturnValue(createAuthorizedHttpRequestMethodToInvoke, new HttpRequest());
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;

        OAuthClientCredentialsHttpService httpService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        HttpResponse actualHttpResponse = httpService.POST(namedCredential, pathParam,'body');

        Assert.areEqual(1,Limits.getCallouts());
        Assert.isNotNull(actualHttpResponse.getBody());
    }
    @IsTest
    public static void testGET() {
        String namedCredential = 'API_GET';
        String recordId = 'recordId';
        Test.setMock(HttpCalloutMock.class, new GetRequestCalloutMock());
        OAuthClientCredential clientCredential = new OAuthClientCredential().setTenantId('newTenantId');
        //Mock oauth token
        Stub oAuthTokenStub = new Stub(OAuthToken.class);
        String isExpiredMethodToInvoke = 'isExpired';
        oAuthTokenStub.setReturnValue(isExpiredMethodToInvoke, false);
        OAuthToken oAuthTokenMock = (OAuthToken) oAuthTokenStub.instance;
        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        String getTokenMethodToInvoke = 'getToken';
        String getCredentialMethodToInvoke = 'getCredential';
        oAuthStorageStub.setReturnValue(getTokenMethodToInvoke, oAuthTokenMock);
        oAuthStorageStub.setReturnValue(getCredentialMethodToInvoke, clientCredential);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        String createAuthorizedHttpRequestMethodToInvoke = 'createAuthorizedRequest';
        oAuthServiceStub.setReturnValue(createAuthorizedHttpRequestMethodToInvoke, new HttpRequest());
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;

        OAuthClientCredentialsHttpService httpService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        HttpResponse actualHttpResponse = httpService.GET(namedCredential, recordId,null);

        Assert.areEqual(1,Limits.getCallouts());
        Assert.isNotNull(actualHttpResponse.getBody());
    }
    @IsTest
    public static void testTestConnectionWithBadRequest() {
        Test.setMock(HttpCalloutMock.class, new BadRequestCalloutMock());
        OAuthClientCredential clientCredential = new OAuthClientCredential().setTenantId('newTenantId');

        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;
        String createAuthorizedHttpRequestMethodToInvoke = 'createAuthorizedRequest';
        oAuthServiceStub.setReturnValue(createAuthorizedHttpRequestMethodToInvoke, new HttpRequest());
        String authenticateMethodToInvoke = 'authenticate';
        oAuthServiceStub.setReturnValue(authenticateMethodToInvoke, new OAuthToken());

        TestConnectionServiceInterface testConnectionService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        try{
            String result = testConnectionService.testConnection(clientCredential, 'Test_Named_Credential');
            Assert.fail('Expected Exception to be thrown');
        }catch (OAuthException e){ }

        Assert.areEqual(1,Limits.getCallouts());
        oAuthServiceStub.assertInvoked(createAuthorizedHttpRequestMethodToInvoke);
        oAuthServiceStub.assertInvoked(authenticateMethodToInvoke);
    }
    @IsTest
    public static void testTestConnectionWithSuccess() {
        Test.setMock(HttpCalloutMock.class, new GetRequestCalloutMock());
        OAuthClientCredential clientCredential = new OAuthClientCredential().setTenantId('newTenantId');

        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;
        String createAuthorizedHttpRequestMethodToInvoke = 'createAuthorizedRequest';
        oAuthServiceStub.setReturnValue(createAuthorizedHttpRequestMethodToInvoke, new HttpRequest());
        String authenticateMethodToInvoke = 'authenticate';
        oAuthServiceStub.setReturnValue(authenticateMethodToInvoke, new OAuthToken());

        TestConnectionServiceInterface testConnectionService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        String result = testConnectionService.testConnection(clientCredential, 'Test_Named_Credential');

        Assert.isTrue(result.containsIgnoreCase('Connection successful'));
        Assert.areEqual(1,Limits.getCallouts());
        oAuthServiceStub.assertInvoked(createAuthorizedHttpRequestMethodToInvoke);
        oAuthServiceStub.assertInvoked(authenticateMethodToInvoke);
    }
    @IsTest
    public static void testTestConnectionWithNotFound() {
        Test.setMock(HttpCalloutMock.class, new NotFoundCalloutMock());
        OAuthClientCredential clientCredential = new OAuthClientCredential().setTenantId('newTenantId');

        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;
        String createAuthorizedHttpRequestMethodToInvoke = 'createAuthorizedRequest';
        oAuthServiceStub.setReturnValue(createAuthorizedHttpRequestMethodToInvoke, new HttpRequest());
        String authenticateMethodToInvoke = 'authenticate';
        oAuthServiceStub.setReturnValue(authenticateMethodToInvoke, new OAuthToken());

        TestConnectionServiceInterface testConnectionService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        String result = testConnectionService.testConnection(clientCredential, 'Test_Named_Credential');

        Assert.isTrue(result.containsIgnoreCase('Connection successful'));
        Assert.areEqual(1,Limits.getCallouts());
        oAuthServiceStub.assertInvoked(createAuthorizedHttpRequestMethodToInvoke);
        oAuthServiceStub.assertInvoked(authenticateMethodToInvoke);
    }
    @IsTest
    public static void testCreateHttpRequest() {
        String method = 'GET';
        String url = 'https://api.com';
        OAuthClientCredential clientCredential = new OAuthClientCredential().setTenantId('newTenantId');
        //Mock oauth token
        Stub oAuthTokenStub = new Stub(OAuthToken.class);
        String isExpiredMethodToInvoke = 'isExpired';
        oAuthTokenStub.setReturnValue(isExpiredMethodToInvoke, false);
        OAuthToken oAuthTokenMock = (OAuthToken) oAuthTokenStub.instance;
        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        String getTokenMethodToInvoke = 'getToken';
        String getCredentialMethodToInvoke = 'getCredential';
        oAuthStorageStub.setReturnValue(getTokenMethodToInvoke, oAuthTokenMock);
        oAuthStorageStub.setReturnValue(getCredentialMethodToInvoke, clientCredential);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        String createAuthorizedHttpRequestMethodToInvoke = 'createAuthorizedRequest';
        oAuthServiceStub.setReturnValue(createAuthorizedHttpRequestMethodToInvoke, new HttpRequest());
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;

        OAuthClientCredentialsHttpService httpService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        HttpRequest actualHttpRequest = httpService.createHttpRequest(method, url);

        Assert.areEqual(method, actualHttpRequest.getMethod());
        Assert.areEqual(url, actualHttpRequest.getEndpoint());
        oAuthStorageStub.assertInvoked(getCredentialMethodToInvoke);
        oAuthServiceStub.assertInvoked(createAuthorizedHttpRequestMethodToInvoke);
    }
    @IsTest
    public static void testGetAccessTokenWhenNonExpiredInCache() {
        //Mock the cached oauth token
        Stub cachedOAuthTokenStub = new Stub(OAuthToken.class);
        String isExpiredMethodToInvoke = 'isExpired';
        cachedOAuthTokenStub.setReturnValue(isExpiredMethodToInvoke, false);
        OAuthToken cachedAuthTokenMock = (OAuthToken) cachedOAuthTokenStub.instance;
        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        String getTokenMethodToInvoke = 'getToken';
        String updateTokenMethodToInvoke = 'updateToken';
        oAuthStorageStub.setReturnValue(getTokenMethodToInvoke, cachedAuthTokenMock);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        String authenticateMethodToInvoke = 'authenticate';
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;

        OAuthClientCredentialsHttpService httpService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        OAuthToken actualOAuthToken = httpService.getApiToken(new OAuthClientCredential());

        Assert.isTrue(cachedAuthTokenMock === actualOAuthToken, 'Expected the cached oauth token to be returned');
        oAuthServiceStub.assertNotInvoked(authenticateMethodToInvoke);
        oAuthStorageStub.assertInvoked(getTokenMethodToInvoke);
        oAuthStorageStub.assertNotInvoked(updateTokenMethodToInvoke);
        cachedOAuthTokenStub.assertInvoked(isExpiredMethodToInvoke);
    }
    @IsTest
    public static void testGetAccessTokenWhenExpiredInCache() {
        //Mock the cached oauth token
        Stub cachedOAuthTokenStub = new Stub(OAuthToken.class);
        String isExpiredMethodToInvoke = 'isExpired';
        cachedOAuthTokenStub.setReturnValue(isExpiredMethodToInvoke, true);
        OAuthToken cachedAuthTokenMock = (OAuthToken) cachedOAuthTokenStub.instance;
        //Mock the new Api Token
        Stub newOauthTokenStub = new Stub(OAuthToken.class);
        OAuthToken newOauthTokenMock = (OAuthToken) newOauthTokenStub.instance;
        // Mock the OAuthClientCredentialsStorageInterface
        Stub oAuthStorageStub = new Stub(OAuthClientCredentialsStorageInterface.class);
        String getTokenMethodToInvoke = 'getToken';
        String updateTokenMethodToInvoke = 'updateToken';
        oAuthStorageStub.setReturnValue(getTokenMethodToInvoke, cachedAuthTokenMock);
        OAuthClientCredentialsStorageInterface oAuthStorageMock = (OAuthClientCredentialsStorageInterface) oAuthStorageStub.instance;
        // Mock the OAuthClientCredentialsServiceInterface
        Stub oAuthServiceStub = new Stub(OAuthClientCredentialsServiceInterface.class);
        String authenticateMethodToInvoke = 'authenticate';
        oAuthServiceStub.setReturnValue(authenticateMethodToInvoke, newOauthTokenMock);
        OAuthClientCredentialsServiceInterface oAuthServiceMock = (OAuthClientCredentialsServiceInterface) oAuthServiceStub.instance;

        OAuthClientCredentialsHttpService httpService = new OAuthClientCredentialsHttpService(oAuthStorageMock,oAuthServiceMock);
        OAuthToken actualOAuthToken = httpService.getApiToken(new OAuthClientCredential());

        Assert.isTrue(actualOAuthToken === newOauthTokenMock, 'Expected the new oauth token to be returned');
        oAuthServiceStub.assertInvoked(authenticateMethodToInvoke);
        oAuthStorageStub.assertInvoked(getTokenMethodToInvoke);
        oAuthStorageStub.assertInvoked(updateTokenMethodToInvoke);
        cachedOAuthTokenStub.assertInvoked(isExpiredMethodToInvoke);
    }
}