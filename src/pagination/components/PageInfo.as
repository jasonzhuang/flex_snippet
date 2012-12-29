package pagination.components {
    public class PageInfo {
        private var _selectedPage:int;
        private var _startIndex:int;
        private var _endIndex:int;
        private var _pageSize:int;

        public function PageInfo(selectedPage:int = 0, startIndex:int = 0,
                endIndex:int = 0, pageSize:int = 0)
        {
            this._selectedPage = selectedPage;
            this._startIndex = startIndex;
            this._endIndex = endIndex;
            this._pageSize = pageSize;
        }

        public function get selectedPage():int {
            return this._selectedPage;
        }

        public function set selectedPage(value:int):void {
            this._selectedPage = value;
        }

        public function get startIndex():int {
            return this._startIndex;
        }

        public function set startIndex(value:int):void {
            this._startIndex = value
        }

        public function get endIndex():int {
            return this._endIndex;
        }

        public function set endIndex(value:int):void {
            this._endIndex = value;
        }

        public function get pageSize():int {
            return this._pageSize;
        }

        public function set pageSize(value:int):void {
            this._pageSize = value;
        }
    }
}