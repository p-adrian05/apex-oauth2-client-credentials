public with sharing class ObjectUtil {

    /**
   *   Checks that the specified object reference is not null.
   *   This method is designed primarily for doing parameter validation in methods and constructors.
   *
   *   @param obj - the object reference to check for nullity
   *   @param message - detail message to be used in the event that a IllegalArgumentException is thrown
   *
   *   @return: obj if not null
   *   @throws:IllegalArgumentException - if obj is null
  */
    public static Object requireNonNull(Object obj, String message){
        if (obj == null){
            throw new IllegalArgumentException(message);
        }
        return obj;
    }
    /**
     *   Checks that the specified String is not null.
     *   This method is designed primarily for doing parameter validation in methods and constructors.
     *
     *   @param str - a string value to check for nullity
     *   @param message - detail message to be used in the event that a IllegalArgumentException is thrown
     *
     *   @return: str if not null
     *   @throws:IllegalArgumentException - if str is null
    */
    public static String requireNonNull(String str, String message){
        if (str == null){
            throw new IllegalArgumentException(message);
        }
        return str;
    }
    /**
    *   Checks that the specified String is white space, empty (''), or null
    *   This method is designed primarily for doing parameter validation in methods and constructors.
    *
    *   @param str - a string value to check for emptiness
    *   @param message - detail message to be used in the event that a IllegalArgumentException is thrown
    *
    *   @return: str if not empty
    *   @throws:IllegalArgumentException - if str is empty
   */
    public static String requireNonEmpty(String str, String message){
        if (String.isBlank(str)){
            throw new IllegalArgumentException(message);
        }
        return str;
    }
    /**
   *   Checks that the specified List of objects is not null and not empty
   *   This method is designed primarily for doing parameter validation in methods and constructors.
   *
   *   @param objs - a List of Objects to check for nullity
   *   @param message - detail message to be used in the event that a IllegalArgumentException is thrown
   *
   *   @return: objs if or not null and contains more than 0 element
   *   @throws:IllegalArgumentException - if objs is null or empty
  */
    public static List<Object> requireNonEmpty(List<Object> objs, String message){
        if(objs == null){
            requireNonNull(objs,message);
        }else if (objs.size()==0){
            throw new IllegalArgumentException(message);
        }
        return objs;
    }
}