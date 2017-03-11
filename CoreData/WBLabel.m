//
//  WBLabel.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/8.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "WBLabel.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>


#define DEFAULT_FONT_SIZE 12

@interface WBLabel ()
{
    NSUInteger _numberOfLines;
    CGFloat _lineHeight;
    NSString *_text;
    UIFont *_font;
    UIColor *_fontColor;
    UIColor *_fontHighlightColor;
    BOOL _limitNumberOfLines;
    BOOL _shouldResizeToFit;
    WBLabelTextAlignment _textAlignment;
}

- (void)drawTransparentBackground;// 绘制透明的背景


@end

CGRect CTLineGetTypographicBoundAsRect(CTLineRef line, CGPoint lineOrigin)
{
    //上升 ， 下降
    CGFloat ascent = 0, descent = 0, leading = 0;
    //dj. 印刷上的,排字上的 Typographic
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    
    return CGRectMake(lineOrigin.x, lineOrigin.y - descent, width, height);
    
}

@implementation WBLabel

- (void)setNumberOfLines:(NSUInteger)numberOfLines
{
    if (numberOfLines != _numberOfLines) {
        _numberOfLines = numberOfLines;
        [self setNeedsDisplay];
    }
}

- (void)setLineHeight:(CGFloat)lineHeight {
    if (lineHeight != _lineHeight) {
        _lineHeight = lineHeight;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font
{
    if (font != _font) {
        _font = font;
        _lineHeight = _font.lineHeight;
        [self setNeedsDisplay];
    }
}

- (void)setFontColor:(UIColor *)fontColor
{
    if (fontColor != _fontColor) {
        _fontColor = fontColor;
        [self setNeedsDisplay];
    }
}

- (void)setFontHighlightColor:(UIColor *)fontHighlightColor
{
    if (fontHighlightColor != _fontHighlightColor) {
        _fontHighlightColor = fontHighlightColor;
    }
}

- (void)setLimitNumberOfLines:(BOOL)limitNumberOfLines
{
    if (limitNumberOfLines != _limitNumberOfLines) {
        _limitNumberOfLines = limitNumberOfLines;
        [self setNeedsDisplay];
    }
}

- (void)setShouldResizeToFit:(BOOL)shouldResizeToFit
{
    if (shouldResizeToFit != _shouldResizeToFit) {
        _shouldResizeToFit = shouldResizeToFit;
        self.clipsToBounds = NO;
        [self setNeedsDisplay];
    }
}

- (void)setTextAlignment:(WBLabelTextAlignment)textAlignment {
    
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        [self setNeedsDisplay];
    }
}

- (NSString *)text
{
    return _text;
}

- (UIFont *)font
{
    return _font;
}

- (CGFloat)lineHeight
{
    return _lineHeight;
}

- (NSUInteger)numberOfLines
{
    return _numberOfLines;
    
}

- (UIColor *)fontColor
{
    return _fontColor;
}

- (UIColor *)fontHighlightColor
{
    return _fontHighlightColor;
}

- (BOOL)limitNumberOfLines {
    return _limitNumberOfLines;
    
}

- (BOOL)shouldResizeToFit
{
    return _shouldResizeToFit;
}

- (WBLabelTextAlignment)textAlignment
{
    return _textAlignment;
}

- (void)setup
{
    _textHeight = 0;
    _font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
    _lineHeight = _font.lineHeight;
    _textAlignment = WBLabelTextAlignmentLeft;
    self.contentMode = UIViewContentModeRedraw;
    [self setOpaque:NO];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    if (self = [super initWithFrame:frame]) {
        _text = text;
        [self setup];
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init]) {
        _text = text;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
+ (instancetype)label
{
    return [[self alloc] init];
}

+ (instancetype)labelWithText:(NSString *)text
{
    return [[self alloc] initWithText:text];
}

+ (instancetype)labelWithFrame:(CGRect)frame andText:(NSString *)text
{
    return [[self alloc] initWithFrame:frame andText:text];
}

#pragma mark - Drawing

-(void)drawTransparentBackground {
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}

- (CGFloat)textOffsetForLine:(CTLineRef)line inRect:(CGRect)rect {
    CGFloat x;
    
    switch (_textAlignment) {
            
        case WBLabelTextAlignmentLeft: {
            //adj. 齐平的, 同高的 FLush factor 因数
            double offset = CTLineGetPenOffsetForFlush(line, 0, rect.size.width);
            x = offset;
            break;
        }
        case WBLabelTextAlignmentCenter: {
            double offset = CTLineGetPenOffsetForFlush(line, 0.5, rect.size.width);
            x = offset;
            break;
        }
        case WBLabelTextAlignmentRight: {
            
            double offset = CTLineGetPenOffsetForFlush(line, 2, rect.size.width);
            x = offset;
            break;
        }
        default:
            x = 0;
            break;
    }
    
    return x;
}
- (void)drawTextInRect:(CGRect)rect withFont:(UIFont *)aFont lineHeight:(CGFloat)lineHeight inContext:(CGContextRef)context {
    
    if (!_text) {
        return;
    }
    
    CGContextClearRect(context, rect);
    
    //Create a CoreText font object with name and size from the UIKit one
    CTFontRef font = CTFontCreateWithName((CFStringRef)aFont.fontName ,
                                          aFont.pointSize,
                                          NULL);
    
    //Setup the attributes dictionary with font and color
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (__bridge id)font, (id)kCTFontAttributeName,
                                _fontColor.CGColor, kCTForegroundColorAttributeName,
                                nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                             initWithString:_text
                                             attributes:attributes] ;
    
    CFRelease(font);
    
    //Create a TypeSetter object with the attributed text created earlier on
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    //Start drawing from the upper side of view (the context is flipped, so we need to grab the height to do so)
    CGFloat y = rect.origin.y + rect.size.height - aFont.ascender;
    
    BOOL shouldDrawAlong = YES;
    int count = 0;
    CFIndex currentIndex = 0;
    
    _textHeight = 0;
    
    //Start drawing lines until we run out of text
    while (shouldDrawAlong) {
        
        //Get CoreText to suggest a proper place to place the line break
        CFIndex lineLength = CTTypesetterSuggestLineBreak(typeSetter,
                                                          currentIndex,
                                                          rect.size.width);
        
        //Create a new line with from current index to line-break index
        CFRange lineRange = CFRangeMake(currentIndex, lineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, lineRange);
        
        //Create a new CTLine if we want to justify the text
        if (_textAlignment == WBLabelTextAlignmentJustify) {
            
            CTLineRef justifiedLine = CTLineCreateJustifiedLine(line, 1.0, rect.size.width);
            CFRelease(line); line = nil;
            
            line = justifiedLine;
        }
        
        CGFloat x = [self textOffsetForLine:line inRect:rect];
        
        // Draw highlight if color has been set
        if (_fontHighlightColor != nil) {
            CGContextSetFillColorWithColor(context, _fontHighlightColor.CGColor);
            CGRect lineRect = CTLineGetTypographicBoundAsRect(line, CGPointMake(x, y));// + (self._lineHeight - self._font.pointSize) / 2));
            
            lineRect = CGRectIntegral(lineRect);
            lineRect = CGRectInset(lineRect, -1, -1);
            lineRect.origin.y -= 1;
            
            NSString *substring = [_text substringWithRange:NSMakeRange(lineRange.location, lineRange.length)];
            
            substring = [substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (0 < [substring length]) {
                
                CGContextFillRect(context, lineRect);
            }
        }
        //Setup the line position
        CGContextSetTextPosition(context, x, y);
        CTLineDraw(line, context);
        
        //Check to see if our index didn't exceed the text, and if should limit to number of lines
        if ((currentIndex + lineLength >= [_text length]) &&
            !(_limitNumberOfLines && count < _numberOfLines-1) )    {
            shouldDrawAlong = NO;
            
        }
        
        count++;
        CFRelease(line);
        
        CGFloat minFontSizeChange = 1;
        y -= lineHeight;
        
        currentIndex += lineLength;
        _textHeight  += lineHeight;
        
        if (_adjustSizeToFit && aFont.pointSize > _mininumFontSize) {
            
            if (rect.size.height < _textHeight) {
                
                NSString *fontName = aFont.fontName;
                CGFloat pointSize = aFont.pointSize;
                CGFloat lineHeightRatio = lineHeight / pointSize;
                CGFloat newPointSize = pointSize - minFontSizeChange;
                
                // Make sure newPointSize is not less than the _minimumFontSize
                newPointSize = newPointSize < _mininumFontSize ? _mininumFontSize : newPointSize;
                
                UIFont *newFont = [UIFont fontWithName:fontName size:newPointSize];
                CGFloat newLineHeight = roundf(newPointSize * lineHeightRatio);
                
                _font = newFont;
                _lineHeight = newLineHeight;
                
                CGContextClearRect(context, rect);
                CFRelease(typeSetter);
                
                return [self drawTextInRect:rect withFont:newFont lineHeight:newLineHeight inContext:context];
            }
        }
    }
    
    CFRelease(typeSetter);
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Grab the drawing context and flip it to prevent drawing upside-down
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSaveGState(context);
    
    [self drawTextInRect:rect withFont:_font lineHeight:_lineHeight inContext:context];
    
    if (_shouldResizeToFit && rect.size.height < _textHeight) {
        
        
        CGRect newFrame = CGRectMake(self.frame.origin.x,
                                     self.frame.origin.y,
                                     self.frame.size.width,
                                     _textHeight);
        [self setFrame:newFrame];
        
        // Notify delegate that we did change frame
        [self.delegate labelDidChangeFrame:self.frame];
        
        // Redraw in the new bounds
        //[self setNeedsDisplayInRect:newFrame];
        //[self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.000001];
        
        CGRect newRect = rect;
        newRect.size.height = _textHeight;
        CGContextClearRect(context, newRect);
        
        CGContextRestoreGState(context);
        //[self drawTextInRect:newRect withFont:self._font lineHeight:self._lineHeight inContext:context];
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.000001];
        //[self drawRect:newRect];
        
    } else {
        CGContextRestoreGState(context);
        
        [super drawRect:rect];
    }
}
@end
