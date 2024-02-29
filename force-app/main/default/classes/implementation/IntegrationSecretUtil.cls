public with sharing class IntegrationSecretUtil {

    /**
     *  Masks a given token with a specified mask character.
     *
     * @example KV0OtVrMBNk8c08 -> KV0*********c08,HxKShF -> H****F, P0dvS5nW -> P0****nW
     * @param token the string to be masked.
     * @param maskCharacter the character that will be used to mask the token string.
     * @return the masked token string or the original token string if the token is null, empty or the token length is less than 3.
     * @throws IllegalArgumentException if the replacement string is null or empty.
     */
    public String maskToken(String token,String maskCharacter) {
        if(String.isBlank(maskCharacter)){
            throw new IllegalArgumentException('maskCharacter string cannot be null or empty!');
        }
        if (String.isBlank(token) || token.length()<=2) {
            return token;
        }
        Integer length = token.length();
        Integer visibleChars = Math.max(1, Math.min(3, (length + 1) / 4));
        Integer hiddenChars = length - visibleChars * 2;

        String hiddenPart = maskCharacter.repeat(hiddenChars);

        String serializedToken = token.substring(0, visibleChars) + hiddenPart + token.substring(token.length() - visibleChars);

        return serializedToken;
    }
}