@IsTest
public with sharing class UnauthorizedCalloutMock implements HttpCalloutMock {
    private final SingleRequestMock singleRequestMock;

    private final String jsonResponse = '{' +
            ' "statusCode": 401,' +
            ' "message": "Unauthorized"' +
            '}';

    public UnauthorizedCalloutMock() {
        singleRequestMock = new SingleRequestMock(401, 'Unauthorized', jsonResponse, null);
    }

    public HttpResponse respond(HttpRequest request) {
        return singleRequestMock.respond(request);
    }

}