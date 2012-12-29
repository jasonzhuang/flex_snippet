package pagination.components {
    import flash.events.Event;

    /**
    * Dispatched whenever the current page value is changed.
    */
    public class PaginationEvent extends Event {
        public static const PAGE_CHANGE:String = "pageChange";

        private var _pageInfo:PageInfo;

        public function get pageInfo():PageInfo {
            return this._pageInfo;
        }

        /**
        * Notice:in super(), default bubbles is false, so if want the event bubble, should
        * explicitly set the bubbles
        */
        public function PaginationEvent(pageInfo:PageInfo, bubbles:Boolean = true) {
            super(PAGE_CHANGE, bubbles);
            this._pageInfo = pageInfo;
        }

        override public function clone():Event {
            return new PaginationEvent(this._pageInfo, this.bubbles);
        }
    }
}