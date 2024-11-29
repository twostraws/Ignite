//
// Property.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents CSS properties that can be applied to HTML elements.
/// These properties control the visual appearance and layout of elements.
public enum Property: String {
    /// Sets the color of form control elements when in an active/selected state
    case accentColor = "accent-color"

    /// Controls how an element's absolute positioning is calculated
    case absolutePosition = "absolute-position"

    /// Specifies the alignment of flex container's lines when there is extra space
    case alignContent = "align-content"

    /// Controls alignment of flex items on the cross axis
    case alignItems = "align-items"

    /// Controls alignment of an individual flex item on the cross axis
    case alignSelf = "align-self"

    /// Resets all properties to their inherited or initial values
    case all = "all"

    /// Controls whether an element is animated
    case animation = "animation"

    /// Specifies the delay before animation starts
    case animationDelay = "animation-delay"

    /// Specifies whether animation should play forwards, backwards, or alternate
    case animationDirection = "animation-direction"

    /// Specifies how long an animation should take to complete one cycle
    case animationDuration = "animation-duration"

    /// Specifies how a CSS animation should progress through keyframes
    case animationFillMode = "animation-fill-mode"

    /// Specifies the number of times an animation should be played
    case animationIterationCount = "animation-iteration-count"

    /// Specifies a name for the @keyframes animation
    case animationName = "animation-name"

    /// Specifies whether the animation is running or paused
    case animationPlayState = "animation-play-state"

    /// Specifies the speed curve of an animation
    case animationTimingFunction = "animation-timing-function"

    /// Controls whether an element is treated as a block or inline element
    case appearance = "appearance"

    /// Sets a preferred aspect ratio for the box
    case aspectRatio = "aspect-ratio"

    /// Applies graphical effects like blur or color shift to the area behind an element
    case backdropFilter = "backdrop-filter"

    /// Determines whether the back face of an element is visible when facing the user
    case backfaceVisibility = "backface-visibility"

    /// Shorthand property for all background properties
    case background = "background"

    /// Sets whether a background image scrolls with the element or is fixed
    case backgroundAttachment = "background-attachment"

    /// Defines how an element's background images should blend with each other and the background color
    case backgroundBlendMode = "background-blend-mode"

    /// Specifies whether or not an element's background extends under its border
    case backgroundClip = "background-clip"

    /// Specifies the background color of an element
    case backgroundColor = "background-color"

    /// Specifies one or more background images for an element
    case backgroundImage = "background-image"

    /// Specifies the origin position of a background image
    case backgroundOrigin = "background-origin"

    /// Controls how background images are positioned
    case backgroundPosition = "background-position"

    /// Sets the horizontal starting position of a background image
    case backgroundPositionX = "background-position-x"

    /// Sets the vertical starting position of a background image
    case backgroundPositionY = "background-position-y"

    /// Controls whether background images are repeated
    case backgroundRepeat = "background-repeat"

    /// Controls the size of background images
    case backgroundSize = "background-size"

    /// Defines the size of an element in the block direction
    case blockSize = "block-size"

    /// Sets all border properties in a single declaration
    case border = "border"

    /// Sets all border properties for block-level elements
    case borderBlock = "border-block"

    /// Sets the color of block-level borders
    case borderBlockColor = "border-block-color"

    /// Sets border properties for the block end edge
    case borderBlockEnd = "border-block-end"

    /// Sets the color of the block end border
    case borderBlockEndColor = "border-block-end-color"

    /// Sets the style of the block end border
    case borderBlockEndStyle = "border-block-end-style"

    /// Sets the width of the block end border
    case borderBlockEndWidth = "border-block-end-width"

    /// Sets border properties for the block start edge
    case borderBlockStart = "border-block-start"

    /// Sets the color of the block start border
    case borderBlockStartColor = "border-block-start-color"

    /// Sets the style of the block start border
    case borderBlockStartStyle = "border-block-start-style"

    /// Sets the width of the block start border
    case borderBlockStartWidth = "border-block-start-width"

    /// Sets the style of block-level borders
    case borderBlockStyle = "border-block-style"

    /// Sets the width of block-level borders
    case borderBlockWidth = "border-block-width"

    /// Sets all the border properties for the bottom border
    case borderBottom = "border-bottom"

    /// Sets the color of the bottom border
    case borderBottomColor = "border-bottom-color"

    /// Sets the radius of the border bottom left corner
    case borderBottomLeftRadius = "border-bottom-left-radius"

    /// Sets the radius of the border bottom right corner
    case borderBottomRightRadius = "border-bottom-right-radius"

    /// Sets the style of the bottom border
    case borderBottomStyle = "border-bottom-style"

    /// Sets the width of the bottom border
    case borderBottomWidth = "border-bottom-width"

    /// Sets whether table borders should collapse into a single border
    case borderCollapse = "border-collapse"

    /// Sets the color of all borders
    case borderColor = "border-color"

    /// Sets the radius of the border end end corner
    case borderEndEndRadius = "border-end-end-radius"

    /// Sets the radius of the border end start corner
    case borderEndStartRadius = "border-end-start-radius"

    /// A shorthand property for border-image-source, border-image-slice, etc.
    case borderImage = "border-image"

    /// Specifies how far the border image extends beyond the border box
    case borderImageOutset = "border-image-outset"

    /// Specifies whether the border image should be repeated, rounded or stretched
    case borderImageRepeat = "border-image-repeat"

    /// Specifies how to slice the border image
    case borderImageSlice = "border-image-slice"

    /// Specifies the path to the border image
    case borderImageSource = "border-image-source"

    /// Specifies the width of the border image
    case borderImageWidth = "border-image-width"

    /// A shorthand property for all the border-inline properties
    case borderInline = "border-inline"

    /// Sets the color of inline borders
    case borderInlineColor = "border-inline-color"

    /// Sets border properties for the inline end edge
    case borderInlineEnd = "border-inline-end"

    /// Sets the color of the inline end border
    case borderInlineEndColor = "border-inline-end-color"

    /// Sets the style of the inline end border
    case borderInlineEndStyle = "border-inline-end-style"

    /// Sets the width of the inline end border
    case borderInlineEndWidth = "border-inline-end-width"

    /// Sets border properties for the inline start edge
    case borderInlineStart = "border-inline-start"

    /// Sets the color of the inline start border
    case borderInlineStartColor = "border-inline-start-color"

    /// Sets the style of the inline start border
    case borderInlineStartStyle = "border-inline-start-style"

    /// Sets the width of the inline start border
    case borderInlineStartWidth = "border-inline-start-width"

    /// Sets the style of inline borders
    case borderInlineStyle = "border-inline-style"

    /// Sets the width of inline borders
    case borderInlineWidth = "border-inline-width"

    /// Sets all the border properties for the left border
    case borderLeft = "border-left"

    /// Sets the color of the left border
    case borderLeftColor = "border-left-color"

    /// Sets the style of the left border
    case borderLeftStyle = "border-left-style"

    /// Sets the width of the left border
    case borderLeftWidth = "border-left-width"

    /// A shorthand property for the four border-*-radius properties
    case borderRadius = "border-radius"

    /// Sets all the border properties for the right border
    case borderRight = "border-right"

    /// Sets the color of the right border
    case borderRightColor = "border-right-color"

    /// Sets the style of the right border
    case borderRightStyle = "border-right-style"

    /// Sets the width of the right border
    case borderRightWidth = "border-right-width"

    /// Sets the distance between the borders of adjacent cells
    case borderSpacing = "border-spacing"

    /// Sets the radius of the border start end corner
    case borderStartEndRadius = "border-start-end-radius"

    /// Sets the radius of the border start start corner
    case borderStartStartRadius = "border-start-start-radius"

    /// Sets the style of all four borders
    case borderStyle = "border-style"

    /// Sets all the border properties for the top border
    case borderTop = "border-top"

    /// Sets the color of the top border
    case borderTopColor = "border-top-color"

    /// Sets the radius of the border top left corner
    case borderTopLeftRadius = "border-top-left-radius"

    /// Sets the radius of the border top right corner
    case borderTopRightRadius = "border-top-right-radius"

    /// Sets the style of the top border
    case borderTopStyle = "border-top-style"

    /// Sets the width of the top border
    case borderTopWidth = "border-top-width"

    /// Sets the width of all four borders
    case borderWidth = "border-width"

    /// Sets the bottom position of positioned elements
    case bottom = "bottom"

    /// Specifies how an element's box decoration should be painted when broken across multiple lines/pages
    case boxDecorationBreak = "box-decoration-break"

    /// Creates a reflective effect below an element
    case boxReflect = "box-reflect"

    /// Adds shadow effects around an element's frame
    case boxShadow = "box-shadow"

    /// Defines how the width and height of an element are calculated
    case boxSizing = "box-sizing"

    /// Specifies the page/column/region break behavior after an element
    case breakAfter = "break-after"

    /// Specifies the page/column/region break behavior before an element
    case breakBefore = "break-before"

    /// Specifies the page/column/region break behavior inside an element
    case breakInside = "break-inside"

    /// Specifies the placement of a table caption
    case captionSide = "caption-side"

    /// Sets the color of the cursor (caret) in inputs, textareas, or contenteditable elements
    case caretColor = "caret-color"

    /// Specifies which sides of an element where other floating elements are not allowed
    case clear = "clear"

    /// Clips an absolutely positioned element
    case clip = "clip"

    /// Clips an element using SVG or shape functions
    case clipPath = "clip-path"

    /// Sets the color of text
    case color = "color"

    /// Sets the color scheme of an element
    case colorScheme = "color-scheme"

    /// Specifies the number of columns an element should be divided into
    case columnCount = "column-count"

    /// Specifies how to fill columns
    case columnFill = "column-fill"

    /// Specifies the gap between columns
    case columnGap = "column-gap"

    /// A shorthand property for setting column-rule-width, column-rule-style, and column-rule-color
    case columnRule = "column-rule"

    /// Specifies the color of the rule between columns
    case columnRuleColor = "column-rule-color"

    /// Specifies the style of the rule between columns
    case columnRuleStyle = "column-rule-style"

    /// Specifies the width of the rule between columns
    case columnRuleWidth = "column-rule-width"

    /// Specifies how many columns an element should span across
    case columnSpan = "column-span"

    /// Specifies the width of columns
    case columnWidth = "column-width"

    /// A shorthand property for column-width and column-count
    case columns = "columns"

    /// Used with the ::before and ::after pseudo-elements to generate content
    case content = "content"

    /// Increments CSS counters
    case counterIncrement = "counter-increment"

    /// Creates or resets CSS counters
    case counterReset = "counter-reset"

    /// Sets or resets CSS counters
    case counterSet = "counter-set"

    /// Specifies the mouse cursor shown when hovering over an element
    case cursor = "cursor"

    /// Specifies the text direction/writing direction
    case direction = "direction"

    /// Specifies how an element should be displayed
    case display = "display"

    /// Specifies whether or not to display borders on empty cells in a table
    case emptyCells = "empty-cells"

    /// Applies graphical effects like blur or color shift to an element
    case filter = "filter"

    /// A shorthand property for the flex-grow, flex-shrink, and flex-basis properties
    case flex = "flex"

    /// Specifies the initial length of a flexible item
    case flexBasis = "flex-basis"

    /// Specifies the direction of the flexible items
    case flexDirection = "flex-direction"

    /// A shorthand property for flex-direction and flex-wrap
    case flexFlow = "flex-flow"

    /// Specifies how much a flex item will grow relative to the other flex items
    case flexGrow = "flex-grow"

    /// Specifies how much a flex item will shrink relative to the other flex items
    case flexShrink = "flex-shrink"

    /// Specifies whether the flexible items should wrap or not
    case flexWrap = "flex-wrap"

    /// Specifies whether an element should float left, right, or not at all
    case float = "float"

    /// Shorthand property for font-style, font-variant, font-weight, font-size/line-height, and font-family
    case font = "font"

    /// Specifies the font family for text
    case fontFamily = "font-family"

    /// Controls advanced typographic features in OpenType fonts
    case fontFeatureSettings = "font-feature-settings"

    /// Controls the usage of the kerning information from a font
    case fontKerning = "font-kerning"

    /// Specifies the font size of text
    case fontSize = "font-size"

    /// Preserves the readability of text when font fallback occurs
    case fontSizeAdjust = "font-size-adjust"

    /// Selects a normal, condensed, or expanded face from a font family
    case fontStretch = "font-stretch"

    /// Specifies whether a font should be styled with a normal, italic, or oblique face
    case fontStyle = "font-style"

    /// Specifies the variant of a font
    case fontVariant = "font-variant"

    /// Controls the usage of alternate glyphs for capital letters
    case fontVariantCaps = "font-variant-caps"

    /// Specifies whether the text should be displayed in a normal, bold or lighter face
    case fontWeight = "font-weight"

    /// Specifies the gap between grid rows and columns
    case gap = "gap"

    /// Specifies a CSS Grid layout using rows and columns
    case grid = "grid"

    /// Specifies the size of the grid container
    case gridArea = "grid-area"

    /// Specifies whether columns in a grid container should have a fixed width or adapt to their content
    case gridAutoColumns = "grid-auto-columns"

    /// Controls how the auto-placement algorithm works in grid layouts
    case gridAutoFlow = "grid-auto-flow"

    /// Specifies whether rows in a grid container should have a fixed height or adapt to their content
    case gridAutoRows = "grid-auto-rows"

    /// Specifies the column position of a grid item
    case gridColumn = "grid-column"

    /// Specifies where to end the grid item column
    case gridColumnEnd = "grid-column-end"

    /// Specifies where to start the grid item column
    case gridColumnStart = "grid-column-start"

    /// Specifies the row position of a grid item
    case gridRow = "grid-row"

    /// Specifies where to end the grid item row
    case gridRowEnd = "grid-row-end"

    /// Specifies where to start the grid item row
    case gridRowStart = "grid-row-start"

    /// Shorthand property that sets grid-template-rows, grid-template-columns, and grid-template-areas
    case gridTemplate = "grid-template"

    /// Specifies the size of the grid columns
    case gridTemplateAreas = "grid-template-areas"

    /// Specifies the size of the grid columns
    case gridTemplateColumns = "grid-template-columns"

    /// Specifies the size of the grid rows
    case gridTemplateRows = "grid-template-rows"

    /// Controls how hanging punctuation should be handled
    case hangingPunctuation = "hanging-punctuation"

    /// Sets the height of an element
    case height = "height"

    /// Controls how words should be hyphenated when text wraps across multiple lines
    case hyphens = "hyphens"

    /// Specifies the rendering quality of images when scaled
    case imageRendering = "image-rendering"

    /// Defines the size of an element in the inline direction
    case inlineSize = "inline-size"

    /// Shorthand that sets all inset properties at once
    case inset = "inset"

    /// Shorthand that sets the block start and end insets
    case insetBlock = "inset-block"

    /// Sets the inset distance for the block end edge
    case insetBlockEnd = "inset-block-end"

    /// Sets the inset distance for the block start edge
    case insetBlockStart = "inset-block-start"

    /// Shorthand that sets the inline start and end insets
    case insetInline = "inset-inline"

    /// Sets the inset distance for the inline end edge
    case insetInlineEnd = "inset-inline-end"

    /// Sets the inset distance for the inline start edge
    case insetInlineStart = "inset-inline-start"

    /// Defines whether an element should create a new stacking context
    case isolation = "isolation"

    /// Aligns flex container's items along the main axis
    case justifyContent = "justify-content"

    /// Aligns grid items along the inline axis
    case justifyItems = "justify-items"

    /// Aligns a grid item inside a cell along the inline axis
    case justifySelf = "justify-self"

    /// Specifies the left position of a positioned element
    case left = "left"

    /// Sets the spacing between text characters
    case letterSpacing = "letter-spacing"

    /// Sets the height of a line box
    case lineHeight = "line-height"

    /// Shorthand for list-style-type, list-style-position and list-style-image
    case listStyle = "list-style"

    /// Specifies an image as the list-item marker
    case listStyleImage = "list-style-image"

    /// Specifies the position of the list-item markers
    case listStylePosition = "list-style-position"

    /// Specifies the type of list-item marker
    case listStyleType = "list-style-type"

    /// Sets margin area on all four sides
    case margin = "margin"

    /// Sets both block start and end margins
    case marginBlock = "margin-block"

    /// Sets the margin for the block end edge
    case marginBlockEnd = "margin-block-end"

    /// Sets the margin for the block start edge
    case marginBlockStart = "margin-block-start"

    /// Sets the bottom margin
    case marginBottom = "margin-bottom"

    /// Sets both inline start and end margins
    case marginInline = "margin-inline"

    /// Sets the margin for the inline end edge
    case marginInlineEnd = "margin-inline-end"

    /// Sets the margin for the inline start edge
    case marginInlineStart = "margin-inline-start"

    /// Sets the left margin
    case marginLeft = "margin-left"

    /// Sets the right margin
    case marginRight = "margin-right"

    /// Sets the top margin
    case marginTop = "margin-top"

    /// Shorthand property for all mask properties
    case mask = "mask"

    /// Sets the mask area
    case maskClip = "mask-clip"

    /// Sets how mask layers are combined
    case maskComposite = "mask-composite"

    /// Sets the mask image
    case maskImage = "mask-image"

    /// Specifies how the mask image values should be interpreted
    case maskMode = "mask-mode"

    /// Specifies the origin position of a mask
    case maskOrigin = "mask-origin"

    /// Sets the starting position of a mask
    case maskPosition = "mask-position"

    /// Sets how a mask image is repeated
    case maskRepeat = "mask-repeat"

    /// Specifies the size of a mask
    case maskSize = "mask-size"

    /// Specifies whether the mask is treated as a luminance or alpha mask
    case maskType = "mask-type"

    /// Sets the maximum height
    case maxHeight = "max-height"

    /// Sets the maximum width
    case maxWidth = "max-width"

    /// Sets the maximum size in the block direction
    case maxBlockSize = "max-block-size"

    /// Sets the maximum size in the inline direction
    case maxInlineSize = "max-inline-size"

    /// Sets the minimum size in the block direction
    case minBlockSize = "min-block-size"

    /// Sets the minimum size in the inline direction
    case minInlineSize = "min-inline-size"

    /// Sets the minimum height
    case minHeight = "min-height"

    /// Sets the minimum width
    case minWidth = "min-width"

    /// Sets how an element's content should blend with its background
    case mixBlendMode = "mix-blend-mode"

    /// Specifies how an image or video should be resized to fit its container
    case objectFit = "object-fit"

    /// Specifies the alignment of the replaced element's content object within its box
    case objectPosition = "object-position"

    /// Sets the opacity level for an element
    case opacity = "opacity"

    /// Sets the order of a flexible item relative to others
    case order = "order"

    /// Sets the minimum number of lines that must be left at the bottom of a page
    case orphans = "orphans"

    /// Shorthand property for outline-width, outline-style and outline-color
    case outline = "outline"

    /// Sets the color of an outline
    case outlineColor = "outline-color"

    /// Offsets an outline from the edge of an element
    case outlineOffset = "outline-offset"

    /// Sets the style of an outline
    case outlineStyle = "outline-style"

    /// Sets the width of an outline
    case outlineWidth = "outline-width"

    /// Specifies what happens if content overflows an element's box
    case overflow = "overflow"

    /// Specifies how the browser should handle scrolling anchors
    case overflowAnchor = "overflow-anchor"

    /// Specifies whether or not the browser should insert line breaks within words
    case overflowWrap = "overflow-wrap"

    /// Specifies whether to clip content, render scrollbars or display overflow content of a block-level element
    case overflowX = "overflow-x"

    /// Same as overflow-x but for the vertical direction
    case overflowY = "overflow-y"

    /// Specifies what a browser does when reaching the boundary of a scrolling area
    case overscrollBehavior = "overscroll-behavior"

    /// Sets the overscroll behavior of an element in the block direction
    case overscrollBehaviorBlock = "overscroll-behavior-block"

    /// Sets the overscroll behavior of an element in the inline direction
    case overscrollBehaviorInline = "overscroll-behavior-inline"

    /// Sets the overscroll behavior of an element in the x direction
    case overscrollBehaviorX = "overscroll-behavior-x"

    /// Sets the overscroll behavior of an element in the y direction
    case overscrollBehaviorY = "overscroll-behavior-y"

    /// Shorthand property for all padding properties
    case padding = "padding"

    /// Sets padding for both block start and end edges
    case paddingBlock = "padding-block"

    /// Sets padding for the block end edge
    case paddingBlockEnd = "padding-block-end"

    /// Sets padding for the block start edge
    case paddingBlockStart = "padding-block-start"

    /// Sets bottom padding
    case paddingBottom = "padding-bottom"

    /// Sets padding for both inline start and end edges
    case paddingInline = "padding-inline"

    /// Sets padding for the inline end edge
    case paddingInlineEnd = "padding-inline-end"

    /// Sets padding for the inline start edge
    case paddingInlineStart = "padding-inline-start"

    /// Sets left padding
    case paddingLeft = "padding-left"

    /// Sets right padding
    case paddingRight = "padding-right"

    /// Sets top padding
    case paddingTop = "padding-top"

    /// Specifies how a page break should behave after an element
    case pageBreakAfter = "page-break-after"

    /// Specifies how a page break should behave before an element
    case pageBreakBefore = "page-break-before"

    /// Specifies how a page break should behave inside an element
    case pageBreakInside = "page-break-inside"

    /// Specifies the order in which painting operations are drawn
    case paintOrder = "paint-order"

    /// Specifies the perspective from which all child elements of the object are viewed
    case perspective = "perspective"

    /// Specifies the origin position for the perspective property
    case perspectiveOrigin = "perspective-origin"

    /// Shorthand property for align-content and justify-content
    case placeContent = "place-content"

    /// Shorthand property for align-items and justify-items
    case placeItems = "place-items"

    /// Shorthand property for align-self and justify-self
    case placeSelf = "place-self"

    /// Specifies whether or not an element can be the target for pointer events
    case pointerEvents = "pointer-events"

    /// Specifies the type of positioning for an element
    case position = "position"

    /// Specifies the type of quotation marks
    case quotes = "quotes"

    /// Specifies whether an element is resizable by the user
    case resize = "resize"

    /// Specifies the right position of a positioned element
    case right = "right"

    /// Specifies the rotation of an element
    case rotate = "rotate"

    /// Specifies the gap between rows in a grid layout
    case rowGap = "row-gap"

    /// Specifies the scaling of an element
    case scale = "scale"

    /// Specifies how auto scrolling behavior should be handled
    case scrollBehavior = "scroll-behavior"

    /// Sets scroll margin on all sides
    case scrollMargin = "scroll-margin"

    /// Sets scroll margin for both block start and end edges
    case scrollMarginBlock = "scroll-margin-block"

    /// Sets scroll margin for the block end edge
    case scrollMarginBlockEnd = "scroll-margin-block-end"

    /// Sets scroll margin for the block start edge
    case scrollMarginBlockStart = "scroll-margin-block-start"

    /// Sets bottom scroll margin
    case scrollMarginBottom = "scroll-margin-bottom"

    /// Sets scroll margin for both inline start and end edges
    case scrollMarginInline = "scroll-margin-inline"

    /// Sets scroll margin for the inline end edge
    case scrollMarginInlineEnd = "scroll-margin-inline-end"

    /// Sets scroll margin for the inline start edge
    case scrollMarginInlineStart = "scroll-margin-inline-start"

    /// Sets left scroll margin
    case scrollMarginLeft = "scroll-margin-left"

    /// Sets right scroll margin
    case scrollMarginRight = "scroll-margin-right"

    /// Sets top scroll margin
    case scrollMarginTop = "scroll-margin-top"

    /// Sets scroll padding on all sides
    case scrollPadding = "scroll-padding"

    /// Sets scroll padding for both block start and end edges
    case scrollPaddingBlock = "scroll-padding-block"

    /// Sets scroll padding for the block end edge
    case scrollPaddingBlockEnd = "scroll-padding-block-end"

    /// Sets scroll padding for the block start edge
    case scrollPaddingBlockStart = "scroll-padding-block-start"

    /// Sets bottom scroll padding
    case scrollPaddingBottom = "scroll-padding-bottom"

    /// Sets scroll padding for both inline start and end edges
    case scrollPaddingInline = "scroll-padding-inline"

    /// Sets scroll padding for the inline end edge
    case scrollPaddingInlineEnd = "scroll-padding-inline-end"

    /// Sets scroll padding for the inline start edge
    case scrollPaddingInlineStart = "scroll-padding-inline-start"

    /// Sets left scroll padding
    case scrollPaddingLeft = "scroll-padding-left"

    /// Sets right scroll padding
    case scrollPaddingRight = "scroll-padding-right"

    /// Sets top scroll padding
    case scrollPaddingTop = "scroll-padding-top"

    /// Specifies where to snap when scrolling
    case scrollSnapAlign = "scroll-snap-align"

    /// Specifies whether the scroll container is allowed to "pass over" possible snap positions
    case scrollSnapStop = "scroll-snap-stop"

    /// Specifies how strictly snap points are enforced on the scroll container
    case scrollSnapType = "scroll-snap-type"

    /// Sets the color of the scrollbar
    case scrollbarColor = "scrollbar-color"

    /// Specifies the width of tab characters
    case tabSize = "tab-size"

    /// Sets the layout algorithm used for a table
    case tableLayout = "table-layout"

    /// Specifies the horizontal alignment of text
    case textAlign = "text-align"

    /// Specifies how the last line of a block or a line right before a forced line break is aligned
    case textAlignLast = "text-align-last"

    /// Sets the text decoration
    case textDecoration = "text-decoration"

    /// Specifies the color of the text-decoration
    case textDecorationColor = "text-decoration-color"

    /// Specifies the type of line in text-decoration
    case textDecorationLine = "text-decoration-line"

    /// Specifies the style of the line in text-decoration
    case textDecorationStyle = "text-decoration-style"

    /// Sets the thickness of the decoration line
    case textDecorationThickness = "text-decoration-thickness"

    /// Applies emphasis marks to text
    case textEmphasis = "text-emphasis"

    /// Specifies the color of the emphasis marks
    case textEmphasisColor = "text-emphasis-color"

    /// Sets the position of the emphasis marks
    case textEmphasisPosition = "text-emphasis-position"

    /// Specifies the type of emphasis marks
    case textEmphasisStyle = "text-emphasis-style"

    /// Specifies the indentation of the first line in a text-block
    case textIndent = "text-indent"

    /// Specifies the justification method used when text-align is "justify"
    case textJustify = "text-justify"

    /// Defines the orientation of text in a line
    case textOrientation = "text-orientation"

    /// Specifies what should happen when text overflows the containing element
    case textOverflow = "text-overflow"

    /// Adds shadow to text
    case textShadow = "text-shadow"

    /// Controls the capitalization of text
    case textTransform = "text-transform"

    /// Sets the offset distance of an underline text decoration line
    case textUnderlineOffset = "text-underline-offset"

    /// Specifies the position of the underline text decoration line
    case textUnderlinePosition = "text-underline-position"

    /// Specifies the top position of a positioned element
    case top = "top"

    /// Applies a 2D or 3D transformation to an element
    case transform = "transform"

    /// Specifies the origin for transformations
    case transformOrigin = "transform-origin"

    /// Specifies how nested elements are rendered in 3D space
    case transformStyle = "transform-style"

    /// Shorthand property for transition-property, transition-duration, transition-timing-function, and transition-delay
    case transition = "transition"

    /// Specifies when the transition effect will start
    case transitionDelay = "transition-delay"

    /// Specifies how many seconds or milliseconds a transition effect takes to complete
    case transitionDuration = "transition-duration"

    /// Specifies the name of the CSS property the transition effect is for
    case transitionProperty = "transition-property"

    /// Specifies the speed curve of the transition effect
    case transitionTimingFunction = "transition-timing-function"

    /// Specifies translation of an element along the X and Y axes
    case translate = "translate"

    /// Specifies how bi-directional text should be handled
    case unicodeBidi = "unicode-bidi"

    /// Specifies whether the user can select text
    case userSelect = "user-select"

    /// Sets the vertical alignment of an element
    case verticalAlign = "vertical-align"

    /// Specifies whether or not an element is visible
    case visibility = "visibility"

    /// Specifies how white-space inside an element is handled
    case whiteSpace = "white-space"

    /// Sets the minimum number of lines that must be left at the top of a page
    case widows = "widows"

    /// Sets the width of an element
    case width = "width"

    /// Specifies how words should break when reaching the end of a line
    case wordBreak = "word-break"

    /// Sets the spacing between words
    case wordSpacing = "word-spacing"

    /// Allows long words to be broken and wrap onto the next line
    case wordWrap = "word-wrap"

    /// Specifies whether lines of text are laid out horizontally or vertically
    case writingMode = "writing-mode"

    /// Sets the stack order of a positioned element
    case zIndex = "z-index"

    /// Sets the zoom level of an element
    case zoom = "zoom"
}
