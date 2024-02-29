@IsTest
private class ObjectSerializationUtilTest {
    @IsTest
    public static void testDeserializeDateWithValidDateString() {
        Date expectedDate = Date.newInstance(2021, 10, 31);
        Date actualDate = ObjectSerializationUtil.deserializeDate('20211031');
        Assert.areEqual(expectedDate, actualDate, 'Expected and actual dates should be equal');
    }

    @IsTest
    public static void testDeserializeDateWithNullDateString() {
        Date actualDate = ObjectSerializationUtil.deserializeDate(null);
        Assert.areEqual(null, actualDate, 'Actual date should be null');
    }

    @IsTest
    public static void testDeserializeDatWithWhitespaceDateString() {
        Date actualDate = ObjectSerializationUtil.deserializeDate('   ');
        Assert.areEqual(null, actualDate, 'Actual date should be null');
    }

    @IsTest
    public static void testDeserializeDateWithInvalidDateStringShouldThrowException() {
        try {
            Date actualDate = ObjectSerializationUtil.deserializeDate('2021-10-31');
            Assert.fail('Should have thrown an exception for invalid date string');
        } catch (Exception e) {
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testSerializeToURLQueryString() {
        Map<String, Object> queryParams = new Map<String, Object>();
        queryParams.put('param1', 'value1');
        queryParams.put('param2', 123);

        String expectedOutput = '?param1=value1&param2=123';

        String actualOutput = ObjectSerializationUtil.serializeToURLQueryString(queryParams);

        Assert.areEqual(expectedOutput, actualOutput);
    }
    @IsTest
    static void testSerializeToURLQueryStringWithEmptyMap() {
        Map<String, Object> queryParams = new Map<String, Object>();
        String expectedOutput = '';

        String actualOutput = ObjectSerializationUtil.serializeToURLQueryString(queryParams);

        System.assertEquals(expectedOutput, actualOutput);
    }

    @IsTest
    public static void testSerializeToURLQueryStringWithNullMap() {
        Map<String, Object> queryParams = null;
        String expectedOutput = '';

        String actualOutput = ObjectSerializationUtil.serializeToURLQueryString(queryParams);

        System.assertEquals(expectedOutput, actualOutput);
    }
    @IsTest
    public static void testSerializeURLWithPathParam() {
        String namedCredential = 'My_Named_Credential';
        String pathParam = '123';
        Map<String, Object> queryParams = new Map<String, Object>{
                'param1' => 'value1',
                'param2' => 'value2'
        };

        String serializedUrl = ObjectSerializationUtil.serializeURL(namedCredential, pathParam, queryParams);

        String expectedUrl = 'callout:My_Named_Credential/123?param1=value1&param2=value2';
        System.assertEquals(expectedUrl, serializedUrl);
    }
    @IsTest
    public static void testSerializeURLWithoutPathParam() {
        String namedCredential = 'My_Named_Credential';
        Object pathParam = null;
        Map<String, Object> queryParams = new Map<String, Object>{
                'param1' => 'value1',
                'param2' => 'value2'
        };

        String serializedUrl = ObjectSerializationUtil.serializeURL(namedCredential, pathParam, queryParams);

        String expectedUrl = 'callout:My_Named_Credential?param1=value1&param2=value2';
        System.assertEquals(expectedUrl, serializedUrl);
    }
    @IsTest
    public static void testSerializeURLWithoutQueryParam() {
        String namedCredential = 'My_Named_Credential';
        String pathParam = '123';
        Map<String, Object> queryParams = new Map<String, Object>();

        String serializedUrl = ObjectSerializationUtil.serializeURL(namedCredential, pathParam, queryParams);

        String expectedUrl = 'callout:My_Named_Credential/123';
        System.assertEquals(expectedUrl, serializedUrl);
    }
    @IsTest
    public static void testSerializeURLWithEmptyNamedCredential() {
        String namedCredential = '';
        Object pathParam = '123';
        Map<String, Object> queryParams = new Map<String, Object>{
                'param1' => 'value1',
                'param2' => 'value2'
        };
        try {
            String serializedUrl = ObjectSerializationUtil.serializeURL(namedCredential, pathParam, queryParams);
            Assert.fail('Should have thrown an exception for empty named credential');
        } catch (Exception e) {}
    }
}
