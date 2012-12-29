package pagination.components {
    public class PaginationHelper {
        private static var pageInfo:PageInfo;

        public static function constructPageInfo(selectedPage:int,
                startIndex:int, endIndex:int, pageSize:int):PageInfo
        {
            if (!pageInfo) {
                pageInfo = new PageInfo();
            }

            pageInfo.selectedPage = selectedPage;
            pageInfo.startIndex = startIndex;
            pageInfo.endIndex = endIndex;
            pageInfo.pageSize = pageSize;
            return pageInfo;
        }
    }
}