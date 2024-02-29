public interface TestConnectionServiceInterface {
    /**
     * Tests the connection to a named credential using the provided client credential.
     *
     * @param obj The object used for authentication, depends on the type of the implementation.
     * @param namedCredential The name of the named credential to test the connection with.
     * @return A string indicating the success of the connection test.
     * @throws OAuthException if the connection fails.
    */
    String testConnection(Object obj,String namedCredential);
}