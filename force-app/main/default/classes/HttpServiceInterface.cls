public interface HttpServiceInterface {
    /**
     * Sends a GET request to the specified URL using the provided named credential, path parameters, and query parameters.
     *
     * @param namedCredential The named credential to use for the request.
     * @param pathParam The path parameters to include in the URL, e.g. /{recordId}.
     * @param queryParams The query parameters to include in the URL e.g. ?name=value.
     * @return The HTTP response received from the server.
     */
    HttpResponse GET(String namedCredential,Object pathParam, Map<String,Object> queryParams);
    /**
      * Sends a POST request to the specified URL using the provided named credential, path parameters, and body.
      *
      * @param namedCredential The named credential to use for the request.
      * @param pathParam The path parameters to include in the URL, e.g. /{recordId}.
      * @param body The body object to include in the request.
      * @return The HTTP response received from the server.
    */
    HttpResponse POST(String namedCredential, Object pathParam,Object body);
}