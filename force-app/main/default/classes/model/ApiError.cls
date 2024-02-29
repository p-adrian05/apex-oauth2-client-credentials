public with sharing class ApiError {
    public String code;
    public String statusCode;
    public String error;
    public String message;

    /**
     * Deserializes the provided JSON string into an ApiError object.
     * @example
     * {
         "code": "400",
         "statusCode": "400 - Bad Request"
         "error": "invalid request",
         "message": "The request body is invalid."
        }
     * @param errorJson The JSON string representing the error.
     * @return An ApiError object deserialized from the JSON string,
      * or If deserialization fails, the message attribute of the returned ApiError object is set to the provided errorJson string.
    */
    public static ApiError deserializeJson(String errorJson) {
        ApiError apiError;
        try{
            apiError = (ApiError) JSON.deserialize(errorJson,ApiError.class);
        }catch (Exception e){
            System.debug(LoggingLevel.ERROR, e.getMessage());
            apiError = new ApiError();
            apiError.message = errorJson;
        }
        return apiError;
    }
   public override String toString(){
        String result = '';
        if(!String.isBlank(code)){
            result += 'Code: ' + code + ', ';
        }
        if(!String.isBlank(statusCode)){
            result += 'Status Code: ' + statusCode + ', ';
        }
        if(!String.isBlank(error)){
            result += 'Error: ' + error + ', ';
        }
        if(!String.isBlank(message)){
            result += 'Message: ' + message;
        }
        result = result.removeEnd(', ');
        if(String.isBlank(result)) {
             result = 'API Error information is empty.';
        }
        return result;
    }
}