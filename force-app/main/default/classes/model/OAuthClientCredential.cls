public with sharing class OAuthClientCredential {
    private String clientId;
    private String clientSecret;
    private String tenantId;

    public OAuthClientCredential setClientId(String clientId) {
        this.clientId = clientId;
        return this;
    }
    public String getClientId() {
        return this.clientId;
    }
    public OAuthClientCredential setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
        return this;
    }
    public String getClientSecret() {
        return this.clientSecret;
    }
    public OAuthClientCredential setTenantId(String tenantId) {
        this.tenantId = tenantId;
        return this;
    }
    public String getTenantId() {
        return this.tenantId;
    }
    public Boolean equals(Object obj) {
        if (obj instanceof OAuthClientCredential) {
            OAuthClientCredential other = (OAuthClientCredential) obj;
            return this.clientId == other.clientId &&
                    this.clientSecret == other.clientSecret &&
                    this.tenantId == other.tenantId;
        }
        return false;
    }
    public Integer hashCode() {
        return (clientId != null ? clientId.hashCode() : 0)
                ^ (clientSecret != null ? clientSecret.hashCode() : 0)
                ^ (tenantId != null ? tenantId.hashCode() : 0);
    }
}