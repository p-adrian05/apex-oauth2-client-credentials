# Introduction
The Apex library offers a generic implementation for the OAuth 2 Client Credentials Flow authorization process in Salesforce. 
This is particularly useful when you need to authenticate to an external API for callouts using the OAuth2 Client Credentials Grant.

The OAuth 2 Client Credentials Flow is a type of authentication flow where the client can request an access token using its own credentials (client id and client secret), 
without the need for user interaction.

The library aims to simplify the implementation of this flow in Salesforce Apex by providing a generic implementation.
This means that you can use the library to authenticate to any external API that supports the OAuth 2 Client Credentials Flow,
without having to write the implementation from scratch.

In addition to the authentication process, the library also handles the refreshing of access tokens.
This is important because access tokens have a limited lifespan and need to be refreshed periodically. 
The library handles this automatically, so you don't have to worry about it.

## 1. Implement OAuthClientCredentialsStorageInterface
The __OAuthClientCredentialsStorageInterface__ is an interface that defines the methods required to store and retrieve OAuth client credentials and tokens.

The __OAuthClientCredentialsStorageInterface__ interface defines the following methods:

- __OAuthToken getToken()__: This method returns the current OAuth access token.
- __OAuthClientCredential getCredential()__: This method returns the current OAuth client credentials.
- __void updateToken(OAuthToken token)__: This method updates the current OAuth access token.
- __void updateCredential(OAuthClientCredential credential)__: This method updates the current OAuth client credentials.

Where __OAuthToken__ and __OAuthClientCredential__ are custom classes that represent the OAuth access token and client credentials respectively. These classes should contain the necessary fields to store the relevant information.

Implementing this interface requires you to provide an implementation for each of the methods defined in the interface. 

The implementation should handle the storage and retrieval of the OAuth client credentials and tokens, which could be done using a custom setting, a custom metadata type, or custom SObject.
In the example below uses __Invoice_Invoice_Integration_Setting__c__ which is a Custom Setting.
```java
public with sharing class InvoiceIntegrationSettingService implements OAuthClientCredentialsStorageInterface{
    private final Invoice_Invoice_Integration_Setting__c integrationSetting;

    public InvoiceIntegrationSettingService(){
        integrationSetting = getIntegrationSetting();
    }
    
    private Invoice_Invoice_Integration_Setting__c getIntegrationSetting(){
        Invoice_Integration_Setting__c integrationSetting = Invoice_Integration_Setting__c.getOrgDefaults();
        if(integrationSetting.Id == null){
            integrationSetting = initializeIntegrationSetting();
            insert integrationSetting;
        }
        return integrationSetting;
    }
    private Invoice_Integration_Setting__c initializeIntegrationSetting(){
        Invoice_Integration_Setting__c integrationSetting = new Invoice_Integration_Setting__c();
        return integrationSetting;
    }
    public OAuthToken getToken(){
        Invoice_Integration_Setting__c integrationSetting = getIntegrationSetting();
        OAuthToken token = new OAuthToken()
                .setAccessToken(integrationSetting.Access_Token__c)
                .setExpireTime(integrationSetting.Token_Expire_Time__c)
                .setExpiresIn(integrationSetting.Token_Expires_In__c == null ? null 
                        : Integer.valueOf(integrationSetting.Token_Expires_In__c))
                .setType(integrationSetting.Token_Type__c)
                .setScope(integrationSetting.Scope__c);
        return token;
    }
    public OAuthClientCredential getCredential(){
        Invoice_Integration_Setting__c integrationSetting = getIntegrationSetting();
        OAuthClientCredential oAuthClientCredential = new OAuthClientCredential()
                .setClientId(integrationSetting.Client_Id__c)
                .setClientSecret(integrationSetting.Client_Secret__c)
                .setTenantId(integrationSetting.Tenant_Id__c);
        return oAuthClientCredential;
    }
    public void updateToken(OAuthToken token){
        integrationSetting.Access_Token__c = token.getAccessToken();
        integrationSetting.Token_Expires_In__c = token.getExpiresIn();
        integrationSetting.Token_Type__c = token.getType();
        integrationSetting.Scope__c = token.getScope();
        integrationSetting.Token_Expire_Time__c = token.getExpireTime();
        update integrationSetting;
    }
    public void updateCredential(OAuthClientCredential oAuthClientCredential){
        integrationSetting.Client_Id__c = oAuthClientCredential.getClientId();
        integrationSetting.Client_Secret__c = oAuthClientCredential.getClientSecret();
        integrationSetting.Tenant_Id__c = oAuthClientCredential.getTenantId();
        update integrationSetting;
    }
}
```
## 2. Implement your api specific service
Once you have implemented the __OAuthClientCredentialsStorageInterface__, you can now create a service that implements the business logic of your application.

In this example, we will implement a service for the Invoice API. This service will use the provided implementation of the __HttpServiceInterface__ to make HTTP requests to the Invoice API endpoint.

Here's an example implementation of the __InvoiceApiService__ class:
```java

public with sharing class InvoiceApiService {
    private final static String INVOICE_API_NAMED_CREDENTIAL = 'INVOICE_API_NAMED_CRENDETIAL';
    private final HttpServiceInterface httpService;

    public InvoiceApiService(HttpServiceInterface httpService) {
        this.httpService = httpService;
    }

    public Invoice getInvoiceById(String invoiceId) {
        ObjectUtil.requireNonEmpty(invoiceId, 'Invoice id is required to get invoice');

        Object invoiceObject = getResource(API_NAMED_CREDENTIAL, invoiceId, null, Invoice.class);
        if (invoiceObject == null) {
            throw new InvoiceApiException('Invoice with id ' + invoiceId + ' not found');
        }
        return (Invoice) invoiceObject;
    }
    private Object getResource(String namedCredential,String pathParam,Map<String,Object> queryParams, Type typeToDeserialize) {
        HttpResponse response = httpService.GET(namedCredential,pathParam,queryParams);

        if(response.getStatusCode() < 300) {
            return JSON.deserialize(response.getBody(), typeToDeserialize);
        }else if(response.getStatusCode() == 404){
            System.debug(response.getBody());
            return null;
        }else{
            System.debug(response.getBody());
            ApiError apiError = ApiError.deserializeJson(response.getBody());
            throw new InvoiceApiException('Error while getting resource from Invoice API: ' + apiError);
        }
    }
}
```
## 3. Construct your api service with the OAuthClientCredentialsHttpService
Finally, you can create the __InvoiceApiController__ to make HTTP requests to the Invoice API endpoint using the __OAuthClientCredentialsHttpService__.

In this implementation, the __InvoiceApiController__ class has a static instance of the __OAuthClientCredentialsStorageInterface__, __HttpServiceInterface__, and your __InvoiceApiService__ implementations.

To create an instance of your __InvoiceApiService__, you need to provide an implementation of the HttpServiceInterface. 
The __HttpServiceInterface__ implementation is provided for you in the __OAuthClientCredentialsHttpService__ class.

To construct the __OAuthClientCredentialsHttpService__, you need to pass in an instance of your __InvoiceIntegrationSettingService__ 
implementation of the __OAuthClientCredentialsStorageInterface__ 
and the __OAuthClientCredentialsService__ implementation with the named credential that is used for authentication to the __Invoice API__.

Here's an example implementation of the __InvoiceApiController__ class:
```java
public with sharing class InvoiceApiController {
    private static final String AUTH_NAMED_CREDENTIAL = 'Invoice_API_AUTH';
    @TestVisible
    private static HttpServiceInterface HTTP_SERVICE = 
            new OAuthClientCredentialsHttpService(new InvoiceIntegrationSettingService(), 
                                                  new OAuthClientCredentialsService(AUTH_NAMED_CREDENTIAL));
    @TestVisible
    private static InvoiceApiService INVOICE_API_SERVICE = new InvoiceApiService(HTTP_SERVICE);

    @AuraEnabled
    public static Invoice getInvoiceById(String invoiceId) {
        return INVOICE_API_SERVICE.getInvoiceById(invoiceId);
    }
}
```