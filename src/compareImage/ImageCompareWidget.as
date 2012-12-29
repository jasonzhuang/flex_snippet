package compareImage {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import mx.core.INavigatorContent;
	import mx.core.UIComponent;
	
	/**
	 *	ImageCompare
	 */
	public class ImageCompareWidget extends Sprite {
		public static const URL_RELOADED:String = "urlReloaded";
		
		private var _before:Bitmap;
		private var _after:Bitmap;
		private var _mask:Sprite;
		
		private var _imageW:Number;
		private var _imageH:Number;
		
		public function get imageW():Number {
			return this._imageW;
		}
		
		public function get imageH():Number {
			return this._imageH;
		}
		
		public function get imageMask():Sprite {
			return this._mask;
		}
		
		public function reloadResource(beforePhoto:Bitmap, afterPhoto:Bitmap): void {
			clearOldData();
			_before = beforePhoto;
			_after = afterPhoto;
			recordSize(_before.width, _before.height);
			constructUI();
		}
		
		private function clearOldData():void {
			if(_before) {
				_before.bitmapData.dispose();
			}
			
			if(_after) {
				_after.bitmapData.dispose();
			}
			_before = null;
			_after = null;
		}
		
		private function removeAllChildren():void {
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		private function recordSize(w:int, h:int):void {
			_imageW = w;
			_imageH = h;
		}
		
		private function constructUI():void {
			//NOTE:remove old children
			removeAllChildren();

			_mask = new Sprite();
			_mask.graphics.beginFill(0x00000000, 0.5);
			_mask.graphics.drawRect(0,0,imageW,imageH);
			_mask.graphics.endFill();
			this.addChild(_mask);
			
			_after.mask = _mask;
			
			this.addChild(_before);
			this.addChild(_after);
	
			this.dispatchEvent(new Event(URL_RELOADED, true));
		}
		
		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
		{
			if (_before == null)
			{
				return super.getBounds(targetCoordinateSpace);
			}
			return _before.getBounds(targetCoordinateSpace);
		}
	}
}