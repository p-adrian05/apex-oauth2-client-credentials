@IsTest
public with sharing class BadRequestCalloutMock implements HttpCalloutMock{
    private final SingleRequestMock singleRequestMock;

    private final String jsonResponse = '{' +
            ' "statusCode": 400,' +
            ' "message": "Invalid request",' +
            ' "error": "Bad Request"' +
            '}';

    public BadRequestCalloutMock() {
        singleRequestMock = new SingleRequestMock(400, 'Bad Request', jsonResponse, null);
    }

    public HttpResponse respond(HttpRequest request) {
        return singleRequestMock.respond(request);
    }
}