package pagination.components {
    import mx.utils.StringUtil;

    /**
     * <p>
     * Utility class used to check method's input paramters.
     * </p>
     */
    public class StringUtil {

        /**
         * Check whether the 2nd string is contained in 1st one. The validation can be case
         * sensitive or not.
         *
         * @param str1 string
         * @param str2 another string
         * @ignoreClass whether the validateion is not case sensitive.
         */
        public static function contains(str1:String, str2:String, ignoreCase:Boolean =
                false):Boolean {
            //FIXME null parameter
            //ParamUtil.checkEmptyString(str1, "str1", false);

            str1 = ignoreCase ? str1.toUpperCase() : str1;

            //NOTE: if input string is null of string's method lastIndexOf(), FlashPlayer 10 in IE8
            //will crash.
            if (str2 == null) {
                return false;
            }

            str2 = ignoreCase ? str2.toUpperCase() : str2;

            return str1.lastIndexOf(str2) > -1;
        }

        /**
         * <p>
         * Check whether the given string is empty or null. When str is null or empty, it will
         * return <code>false</code>
         * </p>
         *
         * @param str string value to be checked.
         * @param ignoreSpace flag whether the spaces at the begining or end of string should be
         * ignored, or a string only containing spaces will not be considered as empty.
         */
        public static function isEmpty(str:String, ignoreSpace:Boolean = true):Boolean {
            if (str == null) {
                return true;
            }

            str = ignoreSpace ? mx.utils.StringUtil.trim(str) : str;

            return str.length == 0;
        }

        /**
         * Remove spaces at the begin or end of given string. If the given string only has spaces,
         * a null will be returned.
         *
         * @param str string to be trimmed
         * @return trimmed string
         */
        public static function trim(str:String):String {
            if (str == null) {
                return null;
            }

            str = mx.utils.StringUtil.trim(str);

            return str.length == 0 ? null : str;
        }
    }
}