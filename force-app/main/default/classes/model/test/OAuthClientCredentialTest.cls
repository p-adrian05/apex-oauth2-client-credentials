@IsTest
public with sharing class OAuthClientCredentialTest {
    @IsTest
    public static void testEqualsIsTrueAndHashcodeIsEqual() {
        OAuthClientCredential credential1 = new OAuthClientCredential()
                .setClientId('client1')
                .setClientSecret('secret1');

        OAuthClientCredential credential2 = new OAuthClientCredential()
                .setClientId('client1')
                .setClientSecret('secret1');

        Assert.isTrue(credential1.equals(credential2));
        Assert.areEqual(credential1.hashCode(), credential2.hashCode());
    }
    @IsTest
    public static void testEqualsIsFalseAndHashcodeIsNotEqual() {
        OAuthClientCredential credential1 = new OAuthClientCredential()
                .setClientId('client2')
                .setClientSecret('secret1');

        OAuthClientCredential credential2 = new OAuthClientCredential()
                .setClientId('client1')
                .setClientSecret('secret1');

        Assert.isFalse(credential1.equals(credential2));
        Assert.areNotEqual(credential1.hashCode(), credential2.hashCode());
    }
    @IsTest
    public static void testEqualsIsFalseAndHashcodeIsEqual() {
        OAuthClientCredential credential1 = new OAuthClientCredential()
                .setClientId('client2')
                .setClientSecret('secret1');

        OAuthClientCredential credential2 = new OAuthClientCredential()
                .setClientId('secret1')
                .setClientSecret('client2');

        Assert.isFalse(credential1.equals(credential2));
        Assert.areEqual(credential1.hashCode(), credential2.hashCode());
    }
}