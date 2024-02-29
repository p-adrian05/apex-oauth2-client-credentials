public with sharing class ObjectSerializationUtil {
    /**
     * Serializes a date string in the format YYYYMMDD into a Date object.
     *
     * @param dateString the date string to be serialized
     * @return the serialized Date object
     * @throws IllegalArgumentException if the date string is not in the format YYYYMMDD
     */
    public static Date deserializeDate(String dateString) {
        if (dateString == null || dateString.isWhitespace()) {
            return null;
        }
        if (dateString.length() != 8) {
            throw new IllegalArgumentException('Invalid date, string must be in format YYYYMMDD');
        }
        String year = dateString.substring(0, 4);
        String month = dateString.substring(4, 6);
        String day = dateString.substring(6, 8);
        String dateFormat = year + '-' + month + '-' + day;
        return Date.valueOf(dateFormat);
    }
    /**
     * Serializes a map of query parameters into a URL query string.
     * @example Map<String,Object> queryParams = new Map<String,Object>{'param1' => 'value1', 'param2' => 'value2'};
     *      Expected result: '?param1=value1&param2=value2'
     * @param queryParams the map containing the query parameters
     * @return the URL query string representing the serialized query parameters
     */
    public static String serializeToURLQueryString(Map<String,Object> queryParams){
        String queryParamString = '';
        if(queryParams != null && !queryParams.isEmpty()){
            queryParamString += '?';
            for(String key : queryParams.keySet()){
                queryParamString += key+'='+queryParams.get(key)+'&';
            }
            queryParamString = queryParamString.removeEnd('&');
        }
        return queryParamString;
    }
    /**
     * Serializes a URL by combining a named credential, path parameter, and query parameters.
     *
     * @param namedCredential The named credential to use in the URL creation. Must not be empty.
     * @param pathParam The path parameter to append to the named credential. Can be null.
     * @param queryParams A map of query parameters to include in the URL.
     * @return The serialized URL as a string.
 */
    public static String serializeURL(String namedCredential, Object pathParam, Map<String,Object> queryParams){
        ObjectUtil.requireNonEmpty(namedCredential,'Named credential cannot be empty for url creation!');
        String url = 'callout:' + namedCredential+(pathParam==null?'':'/'+pathParam);
        String queryParamString = ObjectSerializationUtil.serializeToURLQueryString(queryParams);
        url += queryParamString;
        return url;
    }
}
