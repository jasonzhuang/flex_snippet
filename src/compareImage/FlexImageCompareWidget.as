package compareImage {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import compareImage.DragSlider;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	/**
	 *	FlexImageCompareWidget
	 */
	public class FlexImageCompareWidget extends UIComponent {
		private var imageWidth:int;
		private var imageHeight:int;

		private var movePoint:Point;
		private var originDragStagePoint:Point;
		private var originDragPoint:Point;
		private var originMaskPoint:Point;
		private var offset:Number;
		
		private var scaleFactor:Number=1;
		private var bound:Rectangle;
		
		private var imageCompareWidget:ImageCompareWidget;
		private var dragDivider:DragSlider;
		private var beforeLabel:Label;
		private var afterLabel:Label;
		private var labelContainer:UIComponent;
		
		public function FlexImageCompareWidget() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			//NOTE:MUST remove the listener
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		private function onRemoveFromStage(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private function slideDragEvents(e:MouseEvent):void {
			originDragStagePoint = new Point(e.stageX, e.stageY);
			originDragPoint = new Point(dragDivider.x, dragDivider.y);
			trace("originDragPoint: " + originDragPoint);
			originMaskPoint = new Point((originDragPoint.x + dragDivider.width/2 -bound.x) /scaleFactor , originDragPoint.y/scaleFactor);
			trace("originMaskPoint: " + originMaskPoint);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveDivider, false, 0, true);
		}
		
		private function onAddToStage(event:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true); 
		}
		
		private function onStageMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDivider);
		}
		
		private function moveDivider(event:MouseEvent):void {
			movePoint = new Point(event.stageX, event.stageY);
			offset = movePoint.x - originDragStagePoint.x;
			dragDivider.x = originDragPoint.x + offset;
			limitDragBounds();
			limitMaskBounds();
		}
		
		private function limitMaskBounds():void {
			var positionX:int = originMaskPoint.x + offset /scaleFactor;
			
			if(positionX<=0){
				positionX = 0;
			}else if(positionX>= bound.width/scaleFactor){
				positionX = bound.width/scaleFactor;
			}
			
			imageCompareWidget.imageMask.x = positionX;
		}
		
		private function limitDragBounds():void {
			var container:Rectangle = imageCompareWidget.getBounds(this);
			if(dragDivider.x < container.x) {
				dragDivider.x = container.x - dragDivider.width/2;
			} else if(dragDivider.x > container.right) {
				dragDivider.x = container.right - dragDivider.width/2;
			}
		}
		
		public function setComparePhotoes(before:Bitmap, after:Bitmap):void {
			if(!before || !after) {
				throw new Error("color enhance photoes error!!");
			}
			
			if(before.width != after.width || before.height != after.height) {
				throw new Error("before width " + before.width + ", after width " + after.width + " , before height: " + before.height + ", after height: " + after.height);
			}
			
			imageCompareWidget.reloadResource(before, after);
		}
		
		override protected function createChildren():void {
			if(!imageCompareWidget) {
				imageCompareWidget = new ImageCompareWidget();
				imageCompareWidget.addEventListener(ImageCompareWidget.URL_RELOADED, refreshView);
				this.addChild(imageCompareWidget);
			}
			
			if(!dragDivider) {
				//dragDivider = new DividerDrag();
				dragDivider = new DragSlider();
				dragDivider.buttonMode = true;
				dragDivider.addEventListener(MouseEvent.MOUSE_DOWN, slideDragEvents, false, 0, true);  
				this.addChild(dragDivider);
				trace("dragDivider width: " + dragDivider.width);
			}
			
			if(!labelContainer) {
				labelContainer = new UIComponent();
				var back:Shape = new Shape();
				back.graphics.beginFill(0x000000, 0.5);
				back.graphics.drawRect(0,0,1,1);
				back.graphics.endFill();
				labelContainer.addChild(back);
				this.addChild(labelContainer);
			}
			
			if(!beforeLabel) {
				beforeLabel = new Label();
				beforeLabel.width = 45;
				beforeLabel.height = 25;
				beforeLabel.text = "优化前";
				beforeLabel.setStyle("color", "#ffffff");
				this.addChild(beforeLabel);
			}
			
			if(!afterLabel) {
				afterLabel = new Label();
				afterLabel.width = 45;
				afterLabel.height = 25;
				afterLabel.text = "优化后";
				afterLabel.setStyle("color", "#ffffff");
				this.addChild(afterLabel);
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			trace("unscaledWidth: " + unscaledWidth + ", unscaledHeight: " + unscaledHeight);
			imageWidth = imageCompareWidget.imageW;
			imageHeight = imageCompareWidget.imageH;
			
			imageCompareWidget.x = (unscaledWidth - imageWidth) /2.0;
			imageCompareWidget.y = (unscaledHeight - imageHeight) / 2.0;
			bound = imageCompareWidget.getBounds(this);
			trace("current imageCompareWidget bound: " + bound);
			setLabelContainerPosition();
			setDragDividerPosition();
			setMaskPosition();
		}
		
		private function setLabelContainerPosition():void {
			var back:Shape = labelContainer.getChildAt(0) as Shape;
			back.graphics.clear();
			back.graphics.beginFill(0x000000, 0.5);
			back.graphics.drawRect(0,0,bound.width, 25);
			back.graphics.endFill();
			labelContainer.x = bound.x;
			labelContainer.y = bound.bottom - back.height;
			setLabelPosition();
		}
		
		private function setLabelPosition():void {
			var containerBound:Rectangle = labelContainer.getBounds(this);
			beforeLabel.x = containerBound.x;
			beforeLabel.y = containerBound.y + containerBound.height /4;
			afterLabel.x = containerBound.right - afterLabel.width;
			afterLabel.y = containerBound.y + containerBound.height /4;
		}
		
		private function setDragDividerPosition():void {
			dragDivider.x = (bound.right+bound.x)/2 - dragDivider.width/2;
			dragDivider.y = (bound.bottom + bound.y)/2 - dragDivider.height/2;
		}
		
		private function setMaskPosition():void {
			if(!imageCompareWidget || !imageCompareWidget.imageMask) {
				return;
			}
			var p:Point = new Point((dragDivider.x + dragDivider.width/2 -bound.x) /scaleFactor , dragDivider.y/scaleFactor);
			imageCompareWidget.imageMask.x = p.x;
		}
		
		private function refreshView(event:Event):void {
			this.invalidateDisplayList();
		}
	}
}