//
//  TableViewCell.m
//  LWAsyncDisplayViewDemo
//
//  Created by 刘微 on 16/3/16.
//  Copyright © 2016年 WayneInc. All rights reserved.
//

#import "TableViewCell.h"
#import "LWAsyncDisplayView.h"
#import "LWDefine.h"


@interface TableViewCell ()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;

@end

@implementation TableViewCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.asyncDisplayView];
    }
    return self;
}

#pragma mark - Actions

/**
 *  点击图片查看大图
 *
 */
- (void)didClickedImageView:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    for (NSInteger i = 0; i < self.layout.imagePostionArray.count; i ++) {
        CGRect imagePosition = CGRectFromString(self.layout.imagePostionArray[i]);
        if (CGRectContainsPoint(imagePosition, point)) {
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedImageWithCellLayout:atIndex:)] &&
                [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
                [self.delegate tableViewCell:self didClickedImageWithCellLayout:self.layout atIndex:i];
            }
        }
    }
}

/**
 *  点击链接回调
 *
 */
- (void)lwAsyncDicsPlayView:(LWAsyncDisplayView *)lwLabel didCilickedLinkWithfData:(id)data {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickedLinkWithData:)] &&
        [self.delegate conformsToProtocol:@protocol(TableViewCellDelegate)]) {
        [self.delegate tableViewCell:self didClickedLinkWithData:data];
    }
}

#pragma mark - Draw and setup

- (void)setLayout:(CellLayout *)layout {
    if (_layout == layout) {
        return;
    }
    _layout = layout;
    [self setupCell];
}

- (void)layoutSubviews {
    [self _layoutSubViews];
    [super layoutSubviews];
}

- (void)_layoutSubViews {
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.layout.cellHeight);
}

- (void)setupCell {
    self.asyncDisplayView.layout = self.layout.layout;
}

- (void)extraAsyncDisplayIncontext:(CGContextRef)context size:(CGSize)size {
    //绘制头像外框
    CGContextAddRect(context,self.layout.avatarPosition);
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextSetLineWidth(context, 0.3f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextStrokePath(context);
    //绘制图片背景
    for (NSInteger i = 0; i < self.layout.imagePostionArray.count; i ++) {
        CGContextAddRect(context, CGRectFromString(self.layout.imagePostionArray[i]));
        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextFillPath(context);
    }
    //绘制菜单按钮
    [self _drawImage:[UIImage imageNamed:@"menu"] rect:_layout.menuPosition context:context];
    //绘制评论背景
    UIImage*commentBgImage = [[UIImage imageNamed:@"comment"]
                              stretchableImageWithLeftCapWidth:40.0f
                              topCapHeight:15.0f];
    [commentBgImage drawInRect:self.layout.commentBgPosition];
}

- (void)_drawImage:(UIImage *)image rect:(CGRect)rect context:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
}

#pragma mark - Getter

- (LWAsyncDisplayView *)asyncDisplayView {
    if (!_asyncDisplayView) {
        _asyncDisplayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
        _asyncDisplayView.delegate = self;
    }
    return _asyncDisplayView;
}


@end
