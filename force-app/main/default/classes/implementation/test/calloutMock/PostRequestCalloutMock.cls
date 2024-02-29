@IsTest
public with sharing class PostRequestCalloutMock implements HttpCalloutMock {
    private final SingleRequestMock singleRequestMock;

    private final String jsonResponse = '{' +
    '    "record": "e281cd4c"' +
    '}';

    public PostRequestCalloutMock() {
    singleRequestMock = new SingleRequestMock(200, 'OK', jsonResponse, null);
}

    public HttpResponse respond(HttpRequest request) {
        Assert.areEqual('POST', request.getMethod(), 'HTTP Method should be POST');
        Assert.isTrue(!String.isBlank(request.getBody()), 'HTTP Body should not be empty ');
        return singleRequestMock.respond(request);
    }
}