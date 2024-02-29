@IsTest
public with sharing class NotFoundCalloutMock implements HttpCalloutMock {
    private final SingleRequestMock singleRequestMock;

    private final String jsonResponse = '{' +
            ' "statusCode": 404,' +
            ' "message": "Not found"' +
            '}';

    public NotFoundCalloutMock() {
        singleRequestMock = new SingleRequestMock(404, 'Not Found', jsonResponse, null);
    }

    public HttpResponse respond(HttpRequest request) {
        return singleRequestMock.respond(request);
    }
}