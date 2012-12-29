package dynamicAuthorize
{
    import flash.utils.Dictionary;
    import mx.core.ByteArrayAsset;

    public class PermissionManager
    {
        //used for store all permissions from xml file
        private static var permissionRepository:Dictionary = new Dictionary();
        //used for store permissions from UserInfo.rolePermissionsMap
        private static var permissionCodeMap:Dictionary = new Dictionary();
        //used for store dynamically property.
        private var registeredPropertyArray:Array = new Array();

        /**Indicate if ready for authorize**/
        public  var isAuthorizationDataAvailable:Boolean = false;

        /** The Singleton instance */
        private static var instance:PermissionManager;

        //Notice:You must specify that the MIME type for the embedding is application/octet-stream,
        //which causes the byte data to be embedded "as is", with no interpretation.
        //It also causes the autogenerated class to extend ByteArrayAsset rather than another
        //asset class.
        //embed xml, not using URLLoader
        [Embed(source="assets/data/PermissionMapping.xml", mimeType="application/octet-stream")]
        private static const xmlData:Class;

        public function PermissionManager() {
            if (instance != null) {
                throw new Error("Singleton error");
            }
            instance = this;
        }

        public static function getInstance():PermissionManager {
            if (instance == null) {
                instance = new PermissionManager();
                initializePermissionManager();
            }
            return instance;
        }

        private static function initializePermissionManager():void {
            //get data from embed source and convert it to xml
            var storyByteArray:ByteArrayAsset = ByteArrayAsset(new xmlData());
            var xml:XML = new XML(storyByteArray.readUTFBytes(storyByteArray.length));
            //store the permissions from xml
            var children:XMLList = xml.children();
            for each(var mapping:XML in children) {
                permissionRepository[mapping.@identifier.toString()] =
                        mapping.@permissionCode.toString();
            }
        }

        public function active(userInfo:UserInfo):void {
            if (!userInfo) {
                return;
            }

            this.isAuthorizationDataAvailable = true;
            var roleMap:Object = userInfo.rolePermissionsMap;

            //indicate what permissions the user has.
            for each (var permissions:Array in roleMap) {
                for each(var permissionCodeStr:String in permissions){
                    permissionCodeMap[permissionCodeStr] = true;
                }
            }

            updateRegisteredPropertiesAuthState();
        }

        private function updateRegisteredPropertiesAuthState():void {
            for each(var permission:Object in this.registeredPropertyArray) {
                updatePropertyAuthorizationState(permission.propertyName, permission.owner);
            }
        }

        private function updatePropertyAuthorizationState(propertyName:String, owner:Object):void {
            //get given permission in the xml file
            var permissionCode:String = getPermissionCodeForString(propertyName);
            //check if usr has the permission
            if(isPermissionCodeAuthorized(permissionCode)) {
                //callback function
                owner[propertyName] = true;
            } else {
                //callback function
                owner[propertyName] = false;
            }
        }

        private function getPermissionCodeForString(str:String):String {
            var permissionCode:String = permissionRepository[str];
            if(permissionCode == null) {
                throw new Error("No permission code found for \"" + str + "\"");
            }
            return permissionCode;
        }

        //check if user has the given permission.
        private function isPermissionCodeAuthorized(permissionCode:String):Boolean {
            if(!isAuthorizationDataAvailable) {
                throw new Error("Illegal operation: Checking authorized " + 
                        "state before userInfo data is received." + 
                        "PermissionManager.isAuthorizationDataAvailable must" + 
                        "be true before making this request.");
            }
            var result:* = permissionCodeMap[permissionCode];
            return result == true;
        }

        /**
         * Sets the authorized state of the component as appropriate
         * for the user's role.  This can be called at any time.  If it
         * is called before userInfo is loaded then the component will
         * be "remembered" and updated as appropriate when userInfo data
         * is received.  If this is called after userInfo data is received
         * the component's authorized state is set immediately.  Note that
         * the "authorized state" in this implementation means visible,
         * enabled, and includeInLayout are all set to true when authorized
         * and false otherwise.  See removeComponentFromView and
         * restoreComponentInView, below.
         */
        public function registerProperty(propertyName:String, owner:Object):void {
            if(owner[propertyName]){
                throw new Error("Property " + propertyName + " on object " + owner.id + "should be " + 
                        "initialized to 'false.");
            }
            else if (!isAuthorizationDataAvailable){
                this.registeredPropertyArray.push({owner:owner, propertyName:propertyName});
            } else {
                updatePropertyAuthorizationState(propertyName, owner);
            }
        }
    }
}