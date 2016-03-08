//
//  RepeatScrollView.m
//  YBExample
//
//  Created by 陶海龙 on 15/12/7.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "RepeatScrollView.h"
@interface RepeatScrollView()<UIScrollViewDelegate>
{
    UIScrollView* _scroll;
    NSArray* _dataSource;
    UIPageControl* _pageControl;
    RepeatScrollBlock _tapBlock;
    NSTimer* _timer;
}

@property (nonatomic, strong) UIImageView *leftImageView, *middleImageView, *rightImageView;
@property(nonatomic,assign)NSInteger currentIndex;
@end


@implementation RepeatScrollView
@synthesize leftImageView,middleImageView,rightImageView;
@synthesize currentIndex;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _scroll = [[UIScrollView alloc]initWithFrame:(CGRectMake(0, 0, frame.size.width, frame.size.height))];
        _scroll.delegate = self;
        _scroll.pagingEnabled = YES;
         _scroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scroll];

        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self configureImageView];
        [self creatPageControl];
    }
    return  self;
}


-(void)setAutoRepeat
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];

}


-(void)repeatAction
{
    if (_dataSource.count<2) {
        return;
    }
    
    int nu = ceil(_scroll.contentOffset.x / _scroll.bounds.size.width);
    nu = nu + 1;
    CGPoint point = _scroll.contentOffset;
    if (nu==3) {
        point.x = 0;
    }
    else
    {
      point.x = _scroll.bounds.size.width*nu;
    }
    [_scroll setContentOffset:point animated:YES];
}



-(void)setTapCallBack:(RepeatScrollBlock)block
{
    _tapBlock = block;
}

-(void)tapAction{
    
//    NSLog(@"index is %ld",(long)_pageControl.currentPage);
    if (_tapBlock) {
        
        id<RepeatScrollProtocol>tapData = _dataSource[_pageControl.currentPage];
        _tapBlock(_pageControl.currentPage,tapData);
    }
}


-(void)setDataSource:(NSArray*)dataArr
{
    if (dataArr.count==0) {
        return;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
     for (id<RepeatScrollProtocol> pic  in dataArr) {
         
       [manager downloadImageWithURL:[NSURL URLWithString:[pic getImageUrl]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
           
       }];
    }
    
    
    _dataSource = dataArr;
    _pageControl.numberOfPages = _dataSource.count;
     _pageControl.currentPage = 0;
    if (_dataSource.count>=2) {
        
        _scroll.contentSize = CGSizeMake(self.frame.size.width * 3, self.self.frame.size.height);
         _scroll.contentOffset = CGPointMake(self.frame.size.width, 0);
        
       
        id<RepeatScrollProtocol>last = _dataSource.lastObject;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[last getImageUrl]] placeholderImage:nil];
        
        
        id<RepeatScrollProtocol>first = _dataSource.firstObject;
        [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:[first getImageUrl]] placeholderImage:nil];
        
        
        id<RepeatScrollProtocol>second = _dataSource[1];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[second getImageUrl]] placeholderImage:nil];
        
    }
    else
    {
        _scroll.contentSize = CGSizeMake(self.frame.size.width ,self.frame.size.height);
        _scroll.contentOffset = CGPointMake(0, 0);
        
        id<RepeatScrollProtocol>first = _dataSource.firstObject;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[first getImageUrl]] placeholderImage:nil];
    }
}


-(void)configureImageView{

    self.leftImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))];
    self.middleImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))];
    self.rightImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height))];
   
    [_scroll addSubview:self.leftImageView];
    [_scroll addSubview:self.middleImageView];
    [_scroll addSubview:self.rightImageView];
}


-(void)creatPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:(CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20))];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:222/255.0 green:227.0/255.0 blue:223.0/255.0 alpha:1.0];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.x;
    if (_dataSource.count != 0) {
        
        if (offset >= 2*self.frame.size.width) {
            
            scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
            
            self.currentIndex++;
            
            if (self.currentIndex == _dataSource.count -1) {
                
                [self setImagesDataLeft:_dataSource[self.currentIndex - 1] Middle:_dataSource[self.currentIndex] Right:_dataSource.firstObject];
                _pageControl.currentPage = self.currentIndex;
                self.currentIndex = -1;
            }
            else if (self.currentIndex == _dataSource.count){
                
                [self setImagesDataLeft:_dataSource.lastObject Middle:_dataSource.firstObject Right:_dataSource[1]];
                _pageControl.currentPage = 0;
                self.currentIndex = 0;
                
            }
            else if(self.currentIndex == 0){
                
                [self setImagesDataLeft:_dataSource.lastObject Middle:_dataSource[self.currentIndex] Right:_dataSource[self.currentIndex+1]];
                _pageControl.currentPage = self.currentIndex;
            }else{
                
                [self setImagesDataLeft:_dataSource[self.currentIndex-1] Middle:_dataSource[self.currentIndex] Right:_dataSource[self.currentIndex+1]];
                _pageControl.currentPage = self.currentIndex;
            }
            
        }
        if (offset <= 0) {
            
            scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
            self.currentIndex--;
            if (self.currentIndex == -2) {
                
                self.currentIndex = _dataSource.count-2;
                [self setImagesDataLeft:_dataSource[_dataSource.count-1] Middle:_dataSource[self.currentIndex] Right:_dataSource.lastObject];
                _pageControl.currentPage = self.currentIndex;
            }
            else if (self.currentIndex == -1) {
                
                self.currentIndex = _dataSource.count-1;
                
                [self setImagesDataLeft:_dataSource[self.currentIndex-1] Middle:_dataSource[self.currentIndex] Right:_dataSource.firstObject];
                _pageControl.currentPage = self.currentIndex;
                
            }else if (self.currentIndex == 0){
                
                [self setImagesDataLeft:_dataSource.lastObject Middle:_dataSource[self.currentIndex] Right:_dataSource[self.currentIndex+1]];
                
                _pageControl.currentPage = self.currentIndex;
                
            }else{
                
                [self setImagesDataLeft:_dataSource[self.currentIndex-1] Middle:_dataSource[self.currentIndex] Right:_dataSource[self.currentIndex+1]];
                _pageControl.currentPage = self.currentIndex;
            }
            
        }
    }
}

-(void)setImagesDataLeft:(id<RepeatScrollProtocol>)left Middle:(id<RepeatScrollProtocol>)middle Right:(id<RepeatScrollProtocol>)right
{
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[left getImageUrl]] placeholderImage:nil];
    
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:[middle getImageUrl]] placeholderImage:nil];
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[right getImageUrl]] placeholderImage:nil];
}

@end
