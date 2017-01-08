//
//  PPAsyncDrawingView.h
//  PPAsyncDrawingKit
//
//  Created by DSKcpp on 16/6/29.
//  Copyright © 2016年 DSKcpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPAsyncDrawingViewLayer;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PPAsyncDrawingType) {
    PPAsyncDrawingTypeNone,
    PPAsyncDrawingTypeSync,
    PPAsyncDrawingTypeAsync
};

/**
 PPAsyncDrawingView is a base class, can not be used directly, need to use inheritance.
 */
@interface PPAsyncDrawingView : UIView

/**
 default is YES, Globally async drawing enabled.
 */
@property (nonatomic, class, assign) BOOL globallyAsyncDrawingEnabled;
@property (nonatomic, assign) BOOL serializesDrawingOperations;
@property (nonatomic, assign) NSInteger dispatchPriority;
@property (nullable, nonatomic, assign) dispatch_queue_t dispatchDrawQueue;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) PPAsyncDrawingType drawingPolicy;
@property (nonatomic, assign, readonly) NSUInteger drawingCount;
@property (nonatomic, assign, readonly) BOOL alwaysUsesOffscreenRendering;

- (void)interruptDrawingWhenPossible;
- (dispatch_queue_t)drawQueue;
- (PPAsyncDrawingViewLayer *)drawingLayer;
- (void)redraw;
- (void)drawingWillStartAsynchronously:(BOOL)async;
- (void)drawingDidFinishAsynchronously:(BOOL)async success:(BOOL)success;
- (BOOL)drawInRect:(CGRect)rect withContext:(nullable CGContextRef)context asynchronously:(BOOL)async;
- (BOOL)drawInRect:(CGRect)rect withContext:(nullable CGContextRef)context asynchronously:(BOOL)async userInfo:(nullable NSDictionary *)userInfo;
- (nullable NSDictionary *)currentDrawingUserInfo;
- (void)setNeedsDisplayAsync;
@end

@interface PPAsyncDrawingViewLayer : CALayer

/**
 下一次 Drawing 完成之前是否要保留之前的 Contnets，默认 NO
 */
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) PPAsyncDrawingType drawingPolicy;
@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign, readonly) int32_t drawingCount;

- (void)increaseDrawingCount;
- (BOOL)drawsCurrentContentAsynchronously;
@end

NS_ASSUME_NONNULL_END
