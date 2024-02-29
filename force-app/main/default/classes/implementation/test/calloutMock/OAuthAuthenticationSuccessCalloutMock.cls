@IsTest
public with sharing class OAuthAuthenticationSuccessCalloutMock implements HttpCalloutMock {
    private final SingleRequestMock singleRequestMock;
    private final String jsonResponse =
            '{' +
                    '"access_token": "ZkatwxasdZkatwxasd",' +
                    '"refresh_token": "Zkasdas",' +
                    '"expires_in": 32400,' +
                    '"token_type": "Bearer",' +
                    '"scope": "your scope"' +
                    '}';

    public OAuthAuthenticationSuccessCalloutMock() {
        singleRequestMock = new SingleRequestMock(200, 'OK', jsonResponse, null);
    }
    public HttpResponse respond(HttpRequest request) {
        Assert.areEqual('POST', request.getMethod(), 'Expected POST request');

        Pattern MyPattern = Pattern.compile('^client_id=\\w+&client_secret=\\w+&grant_type=\\w+$');
        Matcher MyMatcher = MyPattern.matcher(request.getBody());
        Assert.isTrue(MyMatcher.matches(), 'Expected client_id, client_secret and grant_type in request body');

        return singleRequestMock.respond(request);
    }
}