//
// Animation-Property.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// CSS properties that can be animated
public enum AnimatableProperty: String {
    /// Controls the aspect ratio of an element
    case aspectRatio = "aspect-ratio"
    /// Controls the background properties of an element
    case background = "background"
    /// Controls the background color of an element
    case backgroundColor = "background-color"
    /// Controls the background position of an element
    case backgroundPosition = "background-position"
    /// Controls the horizontal background position of an element
    case backgroundPositionX = "background-position-x"
    /// Controls the vertical background position of an element
    case backgroundPositionY = "background-position-y"
    /// Controls the background size of an element
    case backgroundSize = "background-size"
    /// Controls the block size of an element
    case blockSize = "block-size"
    /// Controls all border properties of an element
    case border = "border"
    /// Controls bottom border properties of an element
    case borderBottom = "border-bottom"
    /// Controls bottom border color of an element
    case borderBottomColor = "border-bottom-color"
    /// Controls the radius of the bottom-left corner
    case borderBottomLeftRadius = "border-bottom-left-radius"
    /// Controls the radius of the bottom-right corner
    case borderBottomRightRadius = "border-bottom-right-radius"
    /// Controls the width of the bottom border
    case borderBottomWidth = "border-bottom-width"
    /// Controls all border colors
    case borderColor = "border-color"
    /// Controls the end border radius in logical properties
    case borderEndEndRadius = "border-end-end-radius"
    /// Controls the start border radius in logical properties
    case borderEndStartRadius = "border-end-start-radius"
    /// Controls block border properties
    case borderBlock = "border-block"
    /// Controls block border color
    case borderBlockColor = "border-block-color"
    /// Controls end block border color
    case borderBlockEndColor = "border-block-end-color"
    /// Controls end block border width
    case borderBlockEndWidth = "border-block-end-width"
    /// Controls start block border color
    case borderBlockStartColor = "border-block-start-color"
    /// Controls start block border width
    case borderBlockStartWidth = "border-block-start-width"
    /// Controls block border width
    case borderBlockWidth = "border-block-width"
    /// Controls inline border properties
    case borderInline = "border-inline"
    /// Controls inline border color
    case borderInlineColor = "border-inline-color"
    /// Controls end inline border color
    case borderInlineEndColor = "border-inline-end-color"
    /// Controls end inline border width
    case borderInlineEndWidth = "border-inline-end-width"
    /// Controls start inline border color
    case borderInlineStartColor = "border-inline-start-color"
    /// Controls start inline border width
    case borderInlineStartWidth = "border-inline-start-width"
    /// Controls inline border width
    case borderInlineWidth = "border-inline-width"
    /// Controls left border properties
    case borderLeft = "border-left"
    /// Controls left border color
    case borderLeftColor = "border-left-color"
    /// Controls left border width
    case borderLeftWidth = "border-left-width"
    /// Controls right border properties
    case borderRight = "border-right"
    /// Controls right border color
    case borderRightColor = "border-right-color"
    /// Controls right border width
    case borderRightWidth = "border-right-width"
    /// Controls border spacing
    case borderSpacing = "border-spacing"
    /// Controls start end border radius
    case borderStartEndRadius = "border-start-end-radius"
    /// Controls start start border radius
    case borderStartStartRadius = "border-start-start-radius"
    /// Controls top border properties
    case borderTop = "border-top"
    /// Controls top border color
    case borderTopColor = "border-top-color"
    /// Controls top-left border radius
    case borderTopLeftRadius = "border-top-left-radius"
    /// Controls top-right border radius
    case borderTopRightRadius = "border-top-right-radius"
    /// Controls top border width
    case borderTopWidth = "border-top-width"
    /// Controls bottom position
    case bottom = "bottom"
    /// Controls box shadow
    case boxShadow = "box-shadow"
    /// Controls clipping
    case clip = "clip"
    /// Controls text color
    case color = "color"
    /// Controls column count
    case columnCount = "column-count"
    /// Controls column gap
    case columnGap = "column-gap"
    /// Controls column rule
    case columnRule = "column-rule"
    /// Controls column rule color
    case columnRuleColor = "column-rule-color"
    /// Controls column rule width
    case columnRuleWidth = "column-rule-width"
    /// Controls column width
    case columnWidth = "column-width"
    /// Controls columns
    case columns = "columns"
    /// Controls filter effects
    case filter = "filter"
    /// Controls flex properties
    case flex = "flex"
    /// Controls flex basis
    case flexBasis = "flex-basis"
    /// Controls flex grow
    case flexGrow = "flex-grow"
    /// Controls flex shrink
    case flexShrink = "flex-shrink"
    /// Controls font properties
    case font = "font"
    /// Controls font size
    case fontSize = "font-size"
    /// Controls font size adjust
    case fontSizeAdjust = "font-size-adjust"
    /// Controls font stretch
    case fontStretch = "font-stretch"
    /// Controls font weight
    case fontWeight = "font-weight"
    /// Controls grid properties
    case grid = "grid"
    /// Controls grid area
    case gridArea = "grid-area"
    /// Controls grid auto columns
    case gridAutoColumns = "grid-auto-columns"
    /// Controls grid auto flow
    case gridAutoFlow = "grid-auto-flow"
    /// Controls grid auto rows
    case gridAutoRows = "grid-auto-rows"
    /// Controls grid column
    case gridColumn = "grid-column"
    /// Controls grid column end
    case gridColumnEnd = "grid-column-end"
    /// Controls grid column start
    case gridColumnStart = "grid-column-start"
    /// Controls grid row
    case gridRow = "grid-row"
    /// Controls grid row end
    case gridRowEnd = "grid-row-end"
    /// Controls grid row start
    case gridRowStart = "grid-row-start"
    /// Controls grid template
    case gridTemplate = "grid-template"
    /// Controls grid template areas
    case gridTemplateAreas = "grid-template-areas"
    /// Controls grid template columns
    case gridTemplateColumns = "grid-template-columns"
    /// Controls grid template rows
    case gridTemplateRows = "grid-template-rows"
    /// Controls height
    case height = "height"
    /// Controls inline size
    case inlineSize = "inline-size"
    /// Controls inset
    case inset = "inset"
    /// Controls block inset
    case insetBlock = "inset-block"
    /// Controls block end inset
    case insetBlockEnd = "inset-block-end"
    /// Controls block start inset
    case insetBlockStart = "inset-block-start"
    /// Controls inline inset
    case insetInline = "inset-inline"
    /// Controls inline end inset
    case insetInlineEnd = "inset-inline-end"
    /// Controls inline start inset
    case insetInlineStart = "inset-inline-start"
    /// Controls left position
    case left = "left"
    /// Controls letter spacing
    case letterSpacing = "letter-spacing"
    /// Controls line height
    case lineHeight = "line-height"
    /// Controls margin
    case margin = "margin"
    /// Controls block margin
    case marginBlock = "margin-block"
    /// Controls block end margin
    case marginBlockEnd = "margin-block-end"
    /// Controls block start margin
    case marginBlockStart = "margin-block-start"
    /// Controls bottom margin
    case marginBottom = "margin-bottom"
    /// Controls inline margin
    case marginInline = "margin-inline"
    /// Controls inline end margin
    case marginInlineEnd = "margin-inline-end"
    /// Controls inline start margin
    case marginInlineStart = "margin-inline-start"
    /// Controls left margin
    case marginLeft = "margin-left"
    /// Controls right margin
    case marginRight = "margin-right"
    /// Controls top margin
    case marginTop = "margin-top"
    /// Controls maximum height
    case maxHeight = "max-height"
    /// Controls maximum width
    case maxWidth = "max-width"
    /// Controls maximum block size
    case maxBlockSize = "max-block-size"
    /// Controls maximum inline size
    case maxInlineSize = "max-inline-size"
    /// Controls minimum block size
    case minBlockSize = "min-block-size"
    /// Controls minimum inline size
    case minInlineSize = "min-inline-size"
    /// Controls minimum height
    case minHeight = "min-height"
    /// Controls minimum width
    case minWidth = "min-width"
    /// Controls object position
    case objectPosition = "object-position"
    /// Controls offset anchor
    case offsetAnchor = "offset-anchor"
    /// Controls offset distance
    case offsetDistance = "offset-distance"
    /// Controls offset path
    case offsetPath = "offset-path"
    /// Controls offset rotation
    case offsetRotate = "offset-rotate"
    /// Controls opacity
    case opacity = "opacity"
    /// Controls order
    case order = "order"
    /// Controls outline
    case outline = "outline"
    /// Controls outline color
    case outlineColor = "outline-color"
    /// Controls outline offset
    case outlineOffset = "outline-offset"
    /// Controls outline width
    case outlineWidth = "outline-width"
    /// Controls padding
    case padding = "padding"
    /// Controls block padding
    case paddingBlock = "padding-block"
    /// Controls block end padding
    case paddingBlockEnd = "padding-block-end"
    /// Controls block start padding
    case paddingBlockStart = "padding-block-start"
    /// Controls bottom padding
    case paddingBottom = "padding-bottom"
    /// Controls inline padding
    case paddingInline = "padding-inline"
    /// Controls inline end padding
    case paddingInlineEnd = "padding-inline-end"
    /// Controls inline start padding
    case paddingInlineStart = "padding-inline-start"
    /// Controls left padding
    case paddingLeft = "padding-left"
    /// Controls right padding
    case paddingRight = "padding-right"
    /// Controls top padding
    case paddingTop = "padding-top"
    /// Controls perspective
    case perspective = "perspective"
    /// Controls perspective origin
    case perspectiveOrigin = "perspective-origin"
    /// Controls right position
    case right = "right"
    /// Controls rotation
    case rotate = "rotate"
    /// Controls scale
    case scale = "scale"
    /// Controls text decoration color
    case textDecorationColor = "text-decoration-color"
    /// Controls text indent
    case textIndent = "text-indent"
    /// Controls text shadow
    case textShadow = "text-shadow"
    /// Controls top position
    case top = "top"
    /// Controls transform
    case transform = "transform"
    /// Controls transform origin
    case transformOrigin = "transform-origin"
    /// Controls translation
    case translate = "translate"
    /// Controls vertical alignment
    case verticalAlign = "vertical-align"
    /// Controls visibility
    case visibility = "visibility"
    /// Controls width
    case width = "width"
    /// Controls word spacing
    case wordSpacing = "word-spacing"
    /// Controls z-index
    case zIndex = "z-index"
}
