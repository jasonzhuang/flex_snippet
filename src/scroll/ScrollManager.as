package scroll {
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IInvalidating;
	
	import spark.components.Group;
	import spark.primitives.Rect;

	/**
	 *	ScrollManager
	 */
	public class ScrollManager {
		private var viewport:Group;
		private var stage:Stage;
		
		private var oldMovingMouseY:Number;
		
		private static var _instance:ScrollManager;
		
		//模拟值, 用来表示是否需要进行滚动
		private const FUDGE:Number = 35;
		//向上拖动滚动条移动距离
		private const UP_SCROLL_DELTA:int = 50;
		//向下拖动滚动条移动距离
		private const DOWN_SCROLL_DELTA:int = 80;
		
		public function registerViewport(viewport:Group):void {
			this.viewport = viewport;
			this.stage = viewport.stage;
		}
		
		public static function getInstance():ScrollManager {
			if(_instance == null) {
				_instance = new ScrollManager();
			}
			return _instance;
		}
		
		public function startScroll(mouseEvent:MouseEvent):void {
			oldMovingMouseY = mouseEvent.stageY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		private function onMouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//callLater目的是防止拖动时超过了viewport后页面不会立即刷新
			if (viewport is IInvalidating) {
				viewport.callLater(IInvalidating(viewport).validateNow);
				//将滚动条直接定位到拖动的目的地
				var rect:Rectangle = viewport.scrollRect;
				viewport.verticalScrollPosition = rect.y;
				trace("========final vsp ========", rect.y);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void {
			var currentMouseX:Number = event.stageX;
			var currentMouseY:Number = event.stageY;
			trace("mouseY ", currentMouseY);
			
			//计算滚动方向
			var delta:Number = currentMouseY - oldMovingMouseY;
			var direction:int = (delta > 0) ? 1 : (delta < 0) ? -1: 0;
			var scrollDelta:Number = direction > 0 ? DOWN_SCROLL_DELTA : UP_SCROLL_DELTA;
			
			//当前鼠标位置相对viewport坐标空间的坐标值
			var localPoint:Point = viewport.globalToLocal(new Point(currentMouseX, currentMouseY));
			trace("localPoint: ", localPoint);
			var scrollRect:Rectangle = viewport.scrollRect;
			trace("viewport rect", scrollRect);
			
			//滚动条件
			if(needScroll(localPoint, scrollRect, direction)) {
				trace("direction  ", direction > 0 ? " UP": " DOWN");
				scrollRect.y += scrollDelta*direction;
				viewport.scrollRect = scrollRect;
				if (viewport is IInvalidating) {
					IInvalidating(viewport).validateNow();
				}
			}
			
			oldMovingMouseY = currentMouseY;
		}
		
		private function needScroll(localPoint:Point, scrollRect:Rectangle, direction:int):Boolean {
			var localY:Number = localPoint.y;
			var bottom:Number = scrollRect.bottom;
			var top:Number = scrollRect.top;
			
			if(direction > 0 && (localY + FUDGE) > bottom) {
				return true;
			}
			
			if(direction< 0 && (localY - FUDGE) < top) {
				return true;
			}
			
			return false;
		}
	}
}