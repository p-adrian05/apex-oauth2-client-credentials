@IsTest
private class ObjectUtilTest {

    @IsTest
    public static void testRequireNonNullObjectWithObjectShouldReturnObject(){
        List<String> expectedListObj = new List<String>{'test'};
        String exceptionMessage = 'Exception Message';
        Object actualObj = ObjectUtil.requireNonNull(expectedListObj,exceptionMessage);

        Assert.areEqual(expectedListObj, actualObj);
    }
    @IsTest
    public static void testRequireNonNullObjectWithNullShouldThrowException(){
        Integer expectedInt = null;
        String exceptionMessage = 'Exception Message';
        try {
            ObjectUtil.requireNonNull(expectedInt, exceptionMessage);
            Assert.fail('Exception should be thrown');
        }catch (Exception e) {
            Assert.areEqual(exceptionMessage, e.getMessage());
        }
    }
    @IsTest
    public static void testRequireNonNullStringWithStringShouldReturnString(){
        String expectedStr = 'test';
        String exceptionMessage = 'Exception Message';
        String actualStr = ObjectUtil.requireNonNull(expectedStr,exceptionMessage);

        Assert.areEqual(expectedStr, actualStr);
    }
    @IsTest
    public static void testRequireNonNullStringWithNullShouldThrowException(){
        String expectedStr = null;
        String exceptionMessage = 'Exception Message';
        try {
            ObjectUtil.requireNonNull(expectedStr, exceptionMessage);
            Assert.fail('Exception should be thrown');
        }catch (Exception e) {
            Assert.areEqual(exceptionMessage, e.getMessage());
        }
    }
    @IsTest
    public static void testRequireNonEmptyStringWithNonEmptyStringShouldReturnString(){
        String expectedStr = 'test';
        String exceptionMessage = 'Exception Message';

        String actualStr = ObjectUtil.requireNonEmpty(expectedStr, exceptionMessage);
        Assert.areEqual(expectedStr, actualStr);
    }
    @IsTest
    public static void testRequireNonEmptyStringWithEmptyStringShouldThrowException(){
        String expectedStr = '  ';
        String exceptionMessage = 'Exception Message';
        try {
            ObjectUtil.requireNonEmpty(expectedStr, exceptionMessage);
            Assert.fail('Exception should be thrown');
        }catch (Exception e) {
            Assert.areEqual(exceptionMessage, e.getMessage());
        }
    }
    @IsTest
    public static void testRequireNonEmptyListWithStringShouldReturnString(){
        List<Integer> expectedList = new List<Integer>{12};
        String exceptionMessage = 'Exception Message';
        List<Object> actualList = ObjectUtil.requireNonEmpty(expectedList,exceptionMessage);

        Assert.areEqual(expectedList,actualList);
    }
    @IsTest
    public static void testRequireNonEmptyListWithEmptyListShouldThrowException(){
        List<String> listObj = new List<String>{};
        String exceptionMessage = 'Exception Message';
        try {
            ObjectUtil.requireNonEmpty(listObj, exceptionMessage);
            Assert.fail('Exception should be thrown');
        }catch (Exception e) {
            Assert.areEqual(exceptionMessage, e.getMessage());
        }
    }
    @IsTest
    public static void testRequireNonEmptyListWithNullShouldThrowException(){
        List<String> listObj = null;
        String exceptionMessage = 'Exception Message';
        try {
            ObjectUtil.requireNonEmpty(listObj, exceptionMessage);
            Assert.fail('Exception should be thrown');
        }catch (Exception e) {
            Assert.areEqual(exceptionMessage, e.getMessage());
        }
    }
}