public with sharing class OAuthToken {
    private String access_token;
    private String refresh_token;
    private String token_type;
    private Integer expires_in;
    private String scope;
    private Datetime expire_time;

    public OAuthToken setAccessToken(String accessToken) {
        this.access_token = accessToken;
        return this;
    }
    public String getAccessToken() {
        return this.access_token;
    }
    public OAuthToken setRefreshToken(String refreshToken) {
        this.refresh_token = refreshToken;
        return this;
    }
    public String getRefreshToken() {
        return this.refresh_token;
    }
    public OAuthToken setType(String tokenType) {
        this.token_type = tokenType;
        return this;
    }
    public String getType() {
        return this.token_type;
    }
    public OAuthToken setExpiresIn(Integer expiresIn) {
        this.expires_in = expiresIn;
        if(expiresIn != null && this.expire_time == null){
            this.expire_time = Datetime.now().addSeconds(expiresIn);
        }
        return this;
    }
    public Integer getExpiresIn() {
        return this.expires_in;
    }
    public OAuthToken setScope(String scope) {
        this.scope = scope;
        return this;
    }
    public String getScope() {
        return this.scope;
    }
    public OAuthToken setExpireTime(Datetime tokenExpireTime) {
        this.expire_time = tokenExpireTime;
        return this;
    }
    public Datetime getExpireTime() {
        return this.expire_time;
    }
    /**
     * Checks if the access token is expired.
     *
     * @return True if the access token is expired, false otherwise.
    */
    public Boolean isExpired() {
        if(!String.isBlank(this.access_token) && this.expire_time != null && this.expire_time > Datetime.now()){
            return false;
        }
        return true;
    }
    /**
         * Deserializes a JSON string into an OAuthToken object.
         * @example
         * {
             "access_token": "as..Ds",
             "refresh_token": "2b..6u"
             "token_type": "bearer",
             "expires_in": 3600,
             "scope": "read"
            }
         *
         * @param json The JSON string to be deserialized.
         * @return The deserialized OAuthToken object.
         * @throws OAuthTokenException If there is an error during deserialization.
    */
    public static OAuthToken deserialize(String json) {
        try{
            OAuthToken apiToken = (OAuthToken) System.JSON.deserialize(json, OAuthToken.class);
            apiToken.setExpiresIn(apiToken.expires_in);
            return apiToken;
        }catch (Exception e){
            throw new OAuthTokenException('Failed to deserialize OAuth token: ' + e.getMessage());
        }
    }
    public Boolean equals(Object obj) {
        if (obj instanceof OAuthToken) {
            OAuthToken other = (OAuthToken) obj;
            return this.access_token == other.access_token &&
                    this.refresh_token == other.refresh_token &&
                    this.token_type == other.token_type &&
                    this.expires_in == other.expires_in &&
                    this.scope == other.scope &&
                    this.expire_time == other.expire_time;
        }
        return false;
    }
    public Integer hashCode() {
        return (access_token != null ? access_token.hashCode() : 0)
                ^ (refresh_token != null ? refresh_token.hashCode() : 0)
                ^ (token_type != null ? token_type.hashCode() : 0)
                ^ (expires_in != null ? String.valueOf(expires_in).hashCode() : 0)
                ^ (scope != null ? scope.hashCode() : 0)
                ^ (expire_time != null ? String.valueOf(expire_time).hashCode() : 0);
    }
}