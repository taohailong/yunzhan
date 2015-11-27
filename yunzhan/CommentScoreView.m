//
//  CommentScoreView.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommentScoreView.h"

@implementation CommentScoreView

-(id)init
{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    _big = NO;
    return self;
}

-(void)setScore:(double)score
{
    if (_score>5) {
        return;
    }
    _score = score;
    [self setNeedsDisplay];
}

-(void)setStarTypeIsBig:(BOOL)type
{
    _big = type;
}


-(void)drawRect:(CGRect)rect
{
    int total = 5;
    
    int full = (int)_score;
    
     UIImage* starfull = nil;
    
    if (_big) {
        starfull =[UIImage imageNamed:@"starBig_full"];
    }
    else
    {
        starfull =[UIImage imageNamed:@"starSmall_full"];
    }
   
    CGRect frame = CGRectMake(1, 1, starfull.size.width, starfull.size.height);
    for ( int i = 0; i<full; i++) {
        [starfull drawInRect:frame];
        frame.origin.x += 5+ frame.size.width;
    }
    
    float half = _score-full;
    if (half>0) {
        
        
        UIImage* starhalf = nil;
        
        if (_big) {
            starhalf =[UIImage imageNamed:@"starBig_half"];
        }
        else
        {
            starhalf =[UIImage imageNamed:@"starSmall_half"];
        }

        [starhalf drawInRect:frame];
         frame.origin.x += 5+ frame.size.width;
    }
    
    int intEmpty = total - full;
    if (intEmpty != 0) {
        
        UIImage* starempty = nil;
        if (_big) {
            starempty =[UIImage imageNamed:@"starBig_empty"];
        }
        else
        {
            starempty =[UIImage imageNamed:@"starSmall_empty"];
        }
        
        
        
        for ( int i = 0; i<intEmpty; i++) {
            
            [starempty drawInRect:frame];
            frame.origin.x += 5+ frame.size.width;
        }

    }
    
}
@end
