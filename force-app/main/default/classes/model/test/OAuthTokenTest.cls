@IsTest
public with sharing class OAuthTokenTest {
    @IsTest
    public static void testSetExpiresInWithExpireTimeIsNull(){
        Integer expiresIn = 3423;
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setExpiresIn(expiresIn)
                .setType('bearer')
                .setScope('newscope');

        Assert.isNotNull(oAuthToken.getExpireTime());
        Assert.isTrue(oAuthToken.getExpireTime().addSeconds(-expiresIn)<=Datetime.now());
    }
    @IsTest
    public static void testSetExpiresInWithExpireTimeIsSet(){
        Datetime expectedExpireTime = Datetime.now().addSeconds(45);
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setExpiresIn(3423)
                .setType('bearer')
                .setExpireTime(expectedExpireTime)
                .setScope('newscope');

        Assert.isTrue(expectedExpireTime.isSameDay(oAuthToken.getExpireTime()));
    }
    @IsTest
    public static void testIsExpiredWithAccessTokenAndFutureExpireTime() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setExpiresIn(3423)
                .setType('bearer')
                .setScope('newscope');

        Assert.isFalse(oAuthToken.isExpired());
    }

    @IsTest
    public static void testIsExpiredWithBlankAccessToken() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken(' ')
                .setRefreshToken('123Asd')
                .setExpiresIn(3423)
                .setType('bearer')
                .setScope('newscope');

        Assert.isTrue(oAuthToken.isExpired());
    }
    @IsTest
    public static void testIsExpiredWithNullAccessToken() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken(null)
                .setRefreshToken('123Asd')
                .setExpiresIn(3423)
                .setType('bearer')
                .setScope('newscope');

        Assert.isTrue(oAuthToken.isExpired());
    }
    @IsTest
    public static void testIsExpiredWithPastExpireTime() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(Datetime.now().addSeconds(-45))
                .setScope('newscope');

        Assert.isTrue(oAuthToken.isExpired());
    }
    @IsTest
    public static void testIsExpiredWithNullExpireTime() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        Assert.isTrue(oAuthToken.isExpired());
    }
    @IsTest
    public static void testDeserializeWithValidJSON() {
        String json = '{"access_token":"asd213","refresh_token":"123Asd","token_type":"bearer","expires_in":3423,"scope":"newscope"}';

        OAuthToken oAuthToken = OAuthToken.deserialize(json);

        Assert.isNotNull(oAuthToken.getAccessToken());
        Assert.isNotNull(oAuthToken.getRefreshToken());
        Assert.isNotNull(oAuthToken.getType());
        Assert.isNotNull(oAuthToken.getExpiresIn());
        Assert.isNotNull(oAuthToken.getScope());
        Assert.isNotNull(oAuthToken.getExpireTime());
    }
    @IsTest
    public static void testDeserializeWithInvalidJSON() {
        String json = '{"access_token":"newToken","token_type":"bearer","expires_in":3423,"scope":"newscope}';

        try{
            OAuthToken oAuthToken = OAuthToken.deserialize(json);
            System.assert(false, 'Expected exception not thrown for invalid JSON string passed to deserialize method');
        }catch (Exception e){ }
    }
    @IsTest
    public static void testEqualsIsTrueAndHashcodeIsEqual() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        OAuthToken oAuthToken2 = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        Assert.isTrue(oAuthToken.equals(oAuthToken2));
        Assert.areEqual(oAuthToken.hashCode(), oAuthToken2.hashCode());
    }
    @IsTest
    public static void testEqualsIsFalseAndHashcodeIsNotEqual() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        OAuthToken oAuthToken2 = new OAuthToken()
                .setAccessToken('newToken2')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        Assert.isFalse(oAuthToken.equals(oAuthToken2));
        Assert.areNotEqual(oAuthToken.hashCode(), oAuthToken2.hashCode());
    }
    @IsTest
    public static void testEqualsIsFalseAndHashcodeIsEqual() {
        OAuthToken oAuthToken = new OAuthToken()
                .setAccessToken('newToken')
                .setRefreshToken('123Asd')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        OAuthToken oAuthToken2 = new OAuthToken()
                .setAccessToken('123Asd')
                .setRefreshToken('newToken')
                .setType('bearer')
                .setExpireTime(null)
                .setExpiresIn(null)
                .setScope('newscope');

        Assert.isFalse(oAuthToken.equals(oAuthToken2));
        Assert.areEqual(oAuthToken.hashCode(), oAuthToken2.hashCode());
    }
}