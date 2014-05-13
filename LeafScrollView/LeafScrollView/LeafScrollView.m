//
//  LeafScrollView.m
//  LeafScrollView
//
//  Created by Wang on 14-5-12.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import "LeafScrollView.h"

#define TOP_BG_HIDE 120.0f
#define TOP_FLAG_HIDE 55.0f
#define RATE 2
#define SWITCH_Y -TOP_FLAG_HIDE
#define ORIGINAL_POINT CGPointMake(self.bounds.size.width/2, -20)
@implementation LeafScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -TOP_BG_HIDE, self.bounds.size.width, self.bounds.size.height-TOP_BG_HIDE)];
        self.bgImageView.image = [UIImage imageNamed:@"bg.jpg"];
        [self addSubview:self.bgImageView];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:self.scrollView];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate  = self;
        self.scrollView.scrollsToTop = NO;
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_SCROLL_SPACE, self.bounds.size.width, self.bounds.size.height-TOP_SCROLL_SPACE)];
        [self.scrollView addSubview:_containerView];
        self.containerView.backgroundColor = [UIColor whiteColor];
        
        //刷新标志
        _refreshImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.refreshImgView.center = ORIGINAL_POINT;
        self.refreshImgView.image = [UIImage imageNamed:@"refresh"];
        [self addSubview:self.refreshImgView];
        
        self.contentRect = self.containerView.bounds;
        
        [self prepare];
    }
    return self;
}

#pragma scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    CGFloat rate = point.y/scrollView.contentSize.height;
    if(point.y+TOP_BG_HIDE>5){
        self.bgImageView.frame = CGRectMake(0, (-TOP_BG_HIDE)*(1+rate*RATE), self.bgImageView.frame.size.width, self.bgImageView.frame.size.height);
    }
    if(!_isLoading){
        if(scrollView.dragging){
            if(point.y+TOP_FLAG_HIDE>=0){
                self.refreshImgView.center = CGPointMake(self.refreshImgView.center.x,(-TOP_FLAG_HIDE)*(1+rate*RATE*7)+20);//纯属凑数，哈哈，你可以换个策略哦
            }
            self.refreshImgView.transform = CGAffineTransformMakeRotation(rate*30);
        }else{
            //判断位置
            if(point.y<SWITCH_Y){//触发刷新状态
                [self startRotate];
            }else{
                self.refreshImgView.center = CGPointMake(self.refreshImgView.center.x,(-TOP_FLAG_HIDE)*(1+rate*RATE*7)+20);
            }
        }
    }
}


#pragma method
-(void)prepare{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+1);
}
-(void)setRefreshImage:(UIImage *)image{
    self.refreshImgView.image = image;
}
-(void)setBgImage:(UIImage *)image{
    if(image){
    
        self.bgImageView.image = image;
        CGSize size = image.size;
        CGRect rect = self.bgImageView.frame;
        rect.size.width = self.bounds.size.width;
        rect.size.height = self.bounds.size.width * (size.height/size.width);
        self.bgImageView.frame = rect;
    }
}
-(void)setContentView:(UIView *)contentView{
    if(contentView){
        _contentView = contentView;
        [self.containerView addSubview:contentView];
    }
}

-(void)startRotate{
    _isLoading = YES;
    stopRotating = NO;
    angle = 0;
    [self rotateRefreshImage];
    if(self.beginUpdatingBlock){
        self.beginUpdatingBlock(self);
    }
}
-(void)endUpdating{
    stopRotating = YES;
}
-(void)rotateRefreshImage{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.refreshImgView.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 10;
        if(!stopRotating){
            [self rotateRefreshImage];
        }else{
            //上升隐藏
            [UIView animateWithDuration:0.2 animations:^{
                self.refreshImgView.center = ORIGINAL_POINT;
            } completion:^(BOOL finished) {
                _isLoading = NO;
            }];
        }
    }];
}

@end
