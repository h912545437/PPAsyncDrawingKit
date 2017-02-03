//
//  PPTextLayoutLine.m
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 2016/10/26.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import "PPTextLayoutLine.h"
#import "PPTextLayout.h"
#import "PPTextUtilties.h"
#import "PPTextLayoutFrame.h"
#import "PPTextFontMetrics.h"
#import "PPAssert.h"

@implementation PPTextLayoutLine
- (instancetype)initWithCTLine:(CTLineRef)lineRef origin:(CGPoint)origin layout:(PPTextLayout *)layout
{
    PPAssert(lineRef, @"CTLineRef not null");
    if (self = [super init]) {
        _baselineOrigin = origin;
        _textLayout = layout;
        _lineRef = CFRetain(lineRef);
        CFRange range = CTLineGetStringRange(lineRef);
        _stringRange = PPNSRangeFromCFRange(range);
        [self setupWithCTLine];
    }
    return self;
}

- (void)setupWithCTLine
{
    PPTextFontMetrics *fontMetrics = [[PPTextFontMetrics alloc] init];
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    _width = CTLineGetTypographicBounds(_lineRef, &ascent, &descent, &leading);
    fontMetrics.ascent = ascent;
    fontMetrics.descent = descent;
    fontMetrics.leading = leading;
    _lineMetrics = fontMetrics;
//    _baselineOrigin = [_layout convertPointFromCoreText:_baselineOrigin];
}

- (CGRect)fragmentRect
{
    CGFloat height = _lineMetrics.ascent + _lineMetrics.descent;
    return CGRectMake(_baselineOrigin.x, _baselineOrigin.y - _lineMetrics.ascent, _width, height);
}

- (void)dealloc
{
    if (_lineRef) {
        CFRelease(_lineRef);
    }
}

- (void)enumerateLayoutRunsUsingBlock:(void (^)(NSDictionary *, NSRange))block
{
    if (block && _lineRef) {
        CFArrayRef runs = CTLineGetGlyphRuns(_lineRef);
        CFIndex count = CFArrayGetCount(runs);
        for (NSInteger i = 0; i < count; i++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            NSRange range = PPNSRangeFromCFRange(CTRunGetStringRange(run));
            block(attributes, range);
        }
    }
}

- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)index
{
    if (_lineRef) {
        return CTLineGetOffsetForStringIndex(_lineRef, index, NULL);
    } else {
        return 0.0f;
    }
}

- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)index
{
    CGPoint point = _baselineOrigin;
    if (_lineRef) {
        CGFloat x = [self offsetXForCharacterAtIndex:index];
        return CGPointMake(x, point.y);
    }
    return point;
}

- (NSUInteger)characterIndexForBoundingPosition:(CGPoint)position
{
    if (_lineRef) {
        [self locationDeltaFromRealRangeToLineRefRange];
        return CTLineGetStringRange(_lineRef).length;
    } else {
        return _stringRange.length;
    }
}
@end