package pagination.components {
    import flash.events.Event;

    import mx.controls.Image;
    import mx.controls.Label;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.core.UIComponent;

    [Style(name="iconPosition",type="String", enumeration="left, right")]

    [Style(name="gap", type="Number", format="Length", inherit="no", defaultValue="8")]

    [Style(name="leadingSpace", type="Number", inherit="no", defaultValue="0")]

    [Style(name="tailingSpace", type="Number", inherit="no", defaultValue="0")]

    [Style(name="labelColor", type="String", inherit="no", defaultValue="")]

    [Style(name="labelSize", type="Number", inherit="no", defaultValue="0")]

    [Style(name="labelTextDecoration", type="String", inherit="no", enumeration="none, underline", defaultValue="none")]

    [Style(name="labelFontFamily", type="String", inherit="no", defaultValue="")]

    [Style(name="labelFontWeight", type="String", inherit="no", enumeration="normal, bold", defaultValue="normal")]


    //============new added================

    [Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

    [Style(name="paddingTop", type="Number", format="Length", inherit="no")]

    public class IconedLabel extends UIComponent implements IListItemRenderer {

        public static const ICON_POSITION_STYLE_NAME:String = "iconPosition";

        public static const ICON_POSITION_STYLE_RIGHT:String = "right";

        public static const ICON_POSITION_STYLE_LEFT:String = "left";

        public static const GAP_STYLE_NAME:String = "gap";

        public static const LEADING_SPACE_STYLE_NAME:String = "leadingSpace";

        public static const TAILING_SPACE_STYLE_NAME:String = "tailingSpace";

        public static const LABEL_COLOR:String = "labelColor";

        public static const LABEL_SIZE:String = "labelSize";

        public static const LABEL_TEXT_DECORATION:String = "labelTextDecoration";

        public static const LABEL_FONT_FAMILY:String = "labelFontFamily";

        public static const LABEL_FONT_WEIGHT:String = "labelFontWeight";

        private var icon:Image;

        protected var label:Label;

        private var _data:Object;

        //style of image position
        private var imagePositionChanged:Boolean = true;

        protected static const defaultGap:Number = 6;

        //defualt gap between icon and image
        protected var gapValue:Number = defaultGap;

        private var gapChanged:Boolean = true;

        private var labelColorChanged:Boolean = true;

        private var labelSizeChanged:Boolean = true;

        //the style default boolean must be true, then the inline style can effect
        private var labelTextDecorationChanged:Boolean = true;

        private var labelFontFamilyChanged:Boolean = true;

        private var labelFontWeightChanged:Boolean = true;

        private var labelBackgroundChanged:Boolean = true;

        /**
        *  getter and setter data function
        */
        [Bindable("dataChanged")]
        public function set data(value:Object):void {
            if (this._data == value) {
                return;
            }

            this._data = value;

            this.invalidateProperties();
            this.invalidateSize();
            this.invalidateDisplayList();

            this.dispatchEvent(new Event("dataChanged"));
        }

        public function get data():Object{
            return this._data;
        }

        //image source property
        private var _iconSource:Object;

        //reset image property
        private var iconSourceChanged:Boolean = false;

        /**
        * getter and setter iconSource
        */
        [Bindable("iconChanged")]
        public function set iconSource(value:Object):void {
            if (value == this._iconSource) {
                return;
            }

            this._iconSource = value;

            this.iconSourceChanged = true;

            this.invalidateProperties();
            this.invalidateSize();
            this.invalidateDisplayList();

            this.dispatchEvent(new Event("iconChanged"));
        }

        public function get iconSource():Object {
            return this._iconSource;
        }

        //the text in the Label coomponent
        private var _text:String;

        //reset text property
        private var textChanged:Boolean = false;

        /**
        * getter and setter text
        */
        [Bindable("textChanged")]
        public function set text(value:String):void {
            if (value == this._text) {
                return;
            }

            _text = value;

            this.textChanged = true;

            this.invalidateProperties();
            this.invalidateSize();
            this.invalidateDisplayList();

            this.dispatchEvent(new Event("textChanged"));
        }

        public function get text():String {
            return this._text;
        }

        public function get labelCompo():Label {
            return this.label;
        }

        /**
        * Constructor.
        */
        public function IconedLabel() {
            super();
        }

        /**
        * Create child objects of the component
        */
        override protected function createChildren():void {
            super.createChildren();

            if (!this.icon) {
                this.icon = new Image();
                this.icon.source = _iconSource;
                this.icon.visible = true;
                //set true, so the object is included in its parent container's layout
                this.icon.includeInLayout = true;

                this.addChild(this.icon);
            }

            if (!this.label) {
                this.label = new Label();
                this.label.text = this._text;
                this.label.visible = true;
                //set true, so the object is included in its parent container's layout
                this.label.includeInLayout = true;

                this.addChild(label);
            }
        }

        /**
        * Processes the properties set on the component
        */
        protected override function commitProperties():void {
            if (this.textChanged) {
                this.label.text = this._text;
                this.textChanged = false;
            }

            if (this.iconSourceChanged) {
                this.icon.source = this._iconSource;
                this.iconSourceChanged = false;
            }

        }

        /**
        * Calculates the default size, and optionally the default minimum size, of the component
        */
        protected override function measure():void {
            super.measure();

            var w:Number = this.getLeadingSpace();
            var h:Number = 0;

            if (this.icon && this.icon.includeInLayout) {
                w += this.icon.measuredWidth;
                h = this.icon.measuredHeight > h ? this.icon.measuredHeight : h;
            }

            w += this.getGap();

            if (this.label && this.label.includeInLayout) {
                w += this.label.measuredWidth;
                h = this.label.measuredHeight > h ? this.label.measuredHeight : h;
            }

            w += this.getTailingSpace();

//            w+= getStyle("paddingLeft") + getStyle("paddingRight");

            h+= getStyle("paddingTop") + getStyle("paddingBottom");

            this.measuredWidth = this.measuredMinWidth = w;
            this.measuredHeight = this.measuredMinHeight = h;
        }

        /**
        * heck the style name passed to it, and handle the change accordingly
        *
        */
        override public function styleChanged(stylePro:String):void {
            super.styleChanged(stylePro);

            if (stylePro == ICON_POSITION_STYLE_NAME) {
                this.imagePositionChanged = true;

                this.invalidateDisplayList();
                return;
            }

            if (stylePro == GAP_STYLE_NAME) {
                this.gapChanged = true;

                this.invalidateSize();
                this.invalidateDisplayList();
                return;
            }

            if (stylePro == LEADING_SPACE_STYLE_NAME) {
                this.leadingSpaceChanged = true;

                this.invalidateSize();
                this.invalidateDisplayList();
                return;
            }

            if (stylePro == TAILING_SPACE_STYLE_NAME) {
                this.tailingSpaceChanged = true;

                this.invalidateSize();
                this.invalidateDisplayList();
                return;
            }

            if (stylePro == LABEL_COLOR) {
                this.labelColorChanged = true;

                this.invalidateDisplayList();
            }

            if (stylePro == LABEL_SIZE) {
                this.invalidateDisplayList();
            }

            if (stylePro == LABEL_TEXT_DECORATION) {
                this.labelTextDecorationChanged = true;

                this.invalidateDisplayList();
            }

            if (stylePro == LABEL_FONT_FAMILY) {
                this.labelFontFamilyChanged = true;

                this.invalidateDisplayList();
            }

            if (stylePro == LABEL_FONT_WEIGHT) {
                this.labelFontWeightChanged = true;

                this.invalidateDisplayList();
            }
        }

        /**
        * sizes and positions the children of your component
        */
        override protected function updateDisplayList(unscaledWidth:Number,
                unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

//            var paddingLeft:Number = getStyle("paddingLeft");
            var paddingTop:Number = getStyle("paddingTop");
//            var paddingRight:Number = getStyle("paddingRight");
            var paddingBottom:Number = getStyle("paddingBottom");

            var x:Number = this.getLeadingSpace();

            //set image width and height
            var iconWidth:Number = this.icon.getExplicitOrMeasuredWidth();
            var iconHeight:Number = this.icon.getExplicitOrMeasuredHeight();
            this.icon.setActualSize(iconWidth, iconHeight);

            //calculate label width and heigh
            var labelWidth:Number =
                    unscaledWidth - iconWidth
                            - this.getGap() - this.getLeadingSpace() - this.getTailingSpace();
            var labelHeight:Number = this.label.getExplicitOrMeasuredHeight();
            this.label.setActualSize(labelWidth, labelHeight);

            //set image position
            var iconX:Number =
                    this.isIconLeft() ? x : this.getGap() + labelWidth + this.getLeadingSpace();
//            var iconY:Number = (unscaledHeight - iconHeight) / 2;
            var iconY:Number = (unscaledHeight - paddingTop -paddingBottom - iconHeight)/2;

            this.icon.move(iconX, iconY);

            var color:String = this.getStyle(LABEL_COLOR);
            if (!StringUtil.isEmpty(color)) {
                this.label.setStyle("color", color);
            }

            var size:Number = new Number(this.getStyle(LABEL_SIZE));
            if (size > 0) {
                this.label.setStyle("fontSize", size);
            }

            var textDecoration:String = this.getStyle(LABEL_TEXT_DECORATION);
            if (this.labelTextDecorationChanged) {
                this.label.setStyle("textDecoration", textDecoration);
                this.labelTextDecorationChanged = false;
            }

            if (this.labelFontFamilyChanged) {
                var fontFamily:String = this.getStyle(LABEL_FONT_FAMILY);
                this.label.setStyle("fontFamily", fontFamily);
                this.labelFontFamilyChanged = false;
            }

            if (this.labelFontWeightChanged) {
                var fontWeight:String = this.getStyle(LABEL_FONT_WEIGHT);
                this.label.setStyle("fontWeight", fontWeight);
                this.labelFontWeightChanged = false;
            }

            if (this.labelColorChanged) {
                var fontColor:String = this.getStyle(LABEL_COLOR);
                this.label.setStyle("color", fontColor);
                this.labelColorChanged = false;
            }

            //set label position
            var labelX:Number =
                    this.isIconLeft() ? this.getLeadingSpace() + this.getGap() + iconWidth : x;
//            var labelY:Number = (unscaledHeight - labelHeight) / 2;
            var labelY:Number = (unscaledHeight -paddingTop -paddingBottom - labelHeight)/2;

            this.label.move(labelX, labelY);
        }

        private var iconLeft:Boolean = true;

        private var iconPositionChanged:Boolean = true;

        //determine if icon display left and label display right
        protected function isIconLeft():Boolean {
            if (this.iconPositionChanged) {
                var iconPosition:String = this.getStyle(ICON_POSITION_STYLE_NAME);

                if (StringUtil.isEmpty(iconPosition)) {
                    this.iconLeft = true;
                } else {

            //if user set the <code>LEADING_SPACE_STYLE_NAME </code>style,icon display left
           //else if user explictly set the <code>ICON_POSITION_STYLE_RIGHT</code>,icon dispaly right
                    switch (iconPosition) {
                    case ICON_POSITION_STYLE_LEFT:
                        this.iconLeft = true;
                        break;
                    case ICON_POSITION_STYLE_RIGHT:
                        this.iconLeft = false;
                        break;
                    default:
                        throw new ArgumentError(
                                "Unsupport " + ICON_POSITION_STYLE_NAME + " style value: "
                                        + iconPosition);
                    }
                }

                this.iconPositionChanged = false;
            }

            return this.iconLeft;
        }

        //calculate gap between icon and label
        protected function getGap():Number {
            if (this.gapChanged) {
                this.gapValue = Number(this.getStyle(GAP_STYLE_NAME));

                if (!this.gapValue || isNaN(this.gapValue)) {
                    this.gapValue = defaultGap;
                }

                this.gapValue = this.gapValue < 0 ? 8 : this.gapValue;

                this.gapChanged = false;
            }

            return this.gapValue;
        }

        private var leadingSpaceValue:Number = 0;

        private var leadingSpaceChanged:Boolean = true;

        //calculate space between first child and lead of the component
        protected function getLeadingSpace():Number {
            if (this.leadingSpaceChanged) {
                this.leadingSpaceValue = Number(this.getStyle(LEADING_SPACE_STYLE_NAME));

                if (!this.leadingSpaceValue || isNaN(this.leadingSpaceValue)) {
                    this.leadingSpaceValue = 0;
                }

                this.leadingSpaceValue = this.leadingSpaceValue < 0 ? 0 : this.leadingSpaceValue;

                this.leadingSpaceChanged = false;
            }

            return this.leadingSpaceValue;
        }

        private var tailingSpaceValue:Number = 0;

        private var tailingSpaceChanged:Boolean = true;

        //calculate space between second chilid and tail of the component
        protected function getTailingSpace():Number {
            if (this.tailingSpaceChanged) {
                this.tailingSpaceValue = Number(this.getStyle(TAILING_SPACE_STYLE_NAME));

                if (!this.tailingSpaceValue || isNaN(this.tailingSpaceValue)) {
                    this.tailingSpaceValue = 0;
                }

                this.tailingSpaceValue = this.tailingSpaceValue < 0 ? 0 : this.tailingSpaceValue;

                this.tailingSpaceChanged = false;
            }

            return this.tailingSpaceValue;
        }

    }
}