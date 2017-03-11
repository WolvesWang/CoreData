//
//  WBLabel.h
//  CoreData
//
//  Created by wangwenbing on 2017/3/8.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBLabelDelegate <NSObject>

- (void)labelDidChangeFrame:(CGRect)frame;

@end

typedef enum {
    
    WBLabelTextAlignmentLeft,
    WBLabelTextAlignmentCenter,
    WBLabelTextAlignmentRight,
    WBLabelTextAlignmentJustify
    
} WBLabelTextAlignment;

@interface WBLabel : UIView

@property (nonatomic, assign) NSUInteger numberOfLines;

@property (nonatomic, assign) CGFloat lineHeight;

@property (nonatomic, readonly) CGFloat textHeight;

@property (nonatomic, assign) CGFloat mininumFontSize;

@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) UIColor *fontHighlightColor;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL limitNumberOfLines;

@property (nonatomic, assign) BOOL shouldResizeToFit;

@property (nonatomic, assign) WBLabelTextAlignment textAlignment;

@property (nonatomic, assign) BOOL adjustSizeToFit;

@property (nonatomic, weak) NSObject<WBLabelDelegate> *delegate;

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text;

- (instancetype)initWithText:(NSString *)text;

+ (instancetype)label;
+ (instancetype)labelWithFrame:(CGRect)frame andText:(NSString *)text;
+ (instancetype)labelWithText:(NSString *)text;

- (void)setText:(NSString *)text;
- (void)setLineHeight:(CGFloat)lineHeight;
- (void)setNumberOfLines:(NSUInteger)numberOfLines;
- (void)setFont:(UIFont *)font;
- (void)setFontColor:(UIColor *)fontColor;
- (void)setLimitNumberOfLines:(BOOL)limitNumberOfLines;
- (void)setTextAlignment:(WBLabelTextAlignment)textAlignment;
- (void)setShouldResizeToFit:(BOOL)shouldResizeToFit;

- (NSString *)text;
- (CGFloat)lineHeight;
- (UIColor *)fontColor;
- (UIFont *)font;
- (NSUInteger)numberOfLines;
- (BOOL)limitNumberOfLines;
- (BOOL)shouldResizeToFit;
- (WBLabelTextAlignment)textAlignment;

@end
