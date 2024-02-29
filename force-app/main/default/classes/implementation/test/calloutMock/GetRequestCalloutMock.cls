
public with sharing class GetRequestCalloutMock implements HttpCalloutMock{
    private final SingleRequestMock singleRequestMock;

    private final String jsonResponse = '{"recordId": "id3"}';

    public GetRequestCalloutMock() {
        singleRequestMock = new SingleRequestMock(200, 'OK', jsonResponse, null);
    }

    public HttpResponse respond(HttpRequest request) {
        Assert.areEqual('GET', request.getMethod(), 'HTTP Method should be GET');
        return singleRequestMock.respond(request);
    }
}