@IsTest
public with sharing class ApiErrorTest {
    @IsTest
    public static void testDeserializeJson() {
        String errorJson = '{ "code": "400", "statusCode": "400 - Bad Request", "error": "invalid request", "message": "The request body is invalid." }';

        ApiError result = ApiError.deserializeJson(errorJson);

        Assert.areEqual('400', result.code);
    }

    @IsTest
    public static void testDeserializeJson_InvalidJson() {
        String errorJson = 'Invalid JSON';

        ApiError result = ApiError.deserializeJson(errorJson);

        Assert.areEqual(errorJson, result.message);
    }
}