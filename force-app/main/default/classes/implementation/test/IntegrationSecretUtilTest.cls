@IsTest
public with sharing class IntegrationSecretUtilTest {

    @IsTest
    public static void testMaskWithNullToken() {
        String token = null;
        String maskChar = '*';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();

        String result = integrationSecretUtil.maskToken(token, maskChar);
        Assert.isNull(result);
    }
    @IsTest
    public static void testMaskWithEmptyToken() {
        String token = ' ';
        String maskChar = '*';
        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();

        String result = integrationSecretUtil.maskToken(token, maskChar);
        Assert.areEqual(token, result);
    }
    @IsTest
    public static void testMaskWithNullMaskCharacter() {
        String token = 'KV85';
        String maskChar = null;
        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        try{
            String result = integrationSecretUtil.maskToken(token, maskChar);
            Assert.fail('Expected exception was not thrown when mask character is null!');
        }catch (IllegalArgumentException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testMaskWithEmptyMaskCharacter() {
        String token = 'KV85';
        String maskChar = ' ';
        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        try{
            String result = integrationSecretUtil.maskToken(token, maskChar);
            Assert.fail('Expected exception was not thrown when mask character is empty!');
        }catch (IllegalArgumentException e){
            Assert.isNotNull(e.getMessage());
        }
    }
    @IsTest
    public static void testMaskTokenWith1lengthToken() {
        String token = 'a';
        String maskChar = '*';
        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String result = integrationSecretUtil.maskToken(token, maskChar);

        System.assertEquals(token, result);
    }
    @IsTest
    public static void testMaskTokenWith2lengthToken() {
        String token = '2a';
        String maskChar = '*';
        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String result = integrationSecretUtil.maskToken(token, maskChar);

        System.assertEquals(token, result);
    }
    @IsTest
    public static void testMaskTokenWith3LengthToken() {
        String tokenToMask = 'KV8';
        String maskChar = '#';
        String expectedToken = 'K#8';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith4LengthToken() {
        String tokenToMask = 'KV85';
        String maskChar = '#';
        String expectedToken = 'K##5';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith5LengthToken() {
        String tokenToMask = 'KV821';
        String maskChar = '#';
        String expectedToken = 'K###1';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith6LengthToken() {
        String tokenToMask = 'Ad8213';
        String maskChar = '#';
        String expectedToken = 'A####3';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith7LengthToken() {
        String tokenToMask = 'AD8213A';
        String maskChar = '#';
        String expectedToken = 'AD###3A';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith8LengthToken() {
        String tokenToMask = 'KV8213As';
        String maskChar = '*';
        String expectedToken = 'KV****As';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith9LengthToken() {
        String tokenToMask = 'KV8213AS3';
        String maskChar = '*';
        String expectedToken = 'KV*****S3';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskTokenWith10LengthToken() {
        String tokenToMask = 'KV8213AS3RD';
        String maskChar = '*';
        String expectedToken = 'KV8*****3RD';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
    @IsTest
    public static void testMaskGreaterThanGreaterThan10LengthToken() {
        String tokenToMask = 'KV0OtVrMBNk8c08';
        String maskChar = '*';
        String expectedToken = 'KV0*********c08';

        IntegrationSecretUtil integrationSecretUtil = new IntegrationSecretUtil();
        String actualToken = integrationSecretUtil.maskToken(tokenToMask, maskChar);

        Assert.areEqual(expectedToken, actualToken);
        Assert.areEqual(tokenToMask.length(), actualToken.length());
    }
}