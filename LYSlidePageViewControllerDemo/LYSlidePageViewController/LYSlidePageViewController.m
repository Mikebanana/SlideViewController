//
//  LYSlidePageViewController.m
//  LYSlidePageControllerDemo
//
//  Created by discover on 2017/12/28.
//  Copyright © 2017年 fengzhuo. All rights reserved.
//

#import "LYSlidePageViewController.h"

#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
/** 状态栏高度 */
#define SYSTEM_STATUSHEIGHT  CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])
/** 导航栏高度 */
#define SYSTEM_NAVIGATIONHEIGHT 44
/** 默认初始位置 */
#define kNavigationBarHeight (SYSTEM_STATUSHEIGHT + SYSTEM_NAVIGATIONHEIGHT)
#define kTabbarHeight  (SYSTEM_STATUSHEIGHT > 20 ? 83.0 : 49.0)
#define   KUIScreenWidth  [UIScreen mainScreen].bounds.size.width
#define   KUIScreenHeight  [UIScreen mainScreen].bounds.size.height
#define MainBGColor RGBColor(242,242,242)
#define btnHeight 39
#define bottomHeight 1
#define sliderHeight 2
#define baseTopBtnTag 988
#define backViewHeight 40.0
#define normalTextColor RGBColor(89, 89, 89)
#define selectedTextColor RGBColor(255, 81, 93)
@interface LYSlidePageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton*  currentButton;
@property (nonatomic,strong) UIView*  topBackView;
@property (nonatomic,strong) UIView*  sliderView;
@property (nonatomic,strong) UIScrollView*  mainScrollView;
@property (nonatomic,assign) CGPoint currentOffset;
@property (nonatomic,assign) BOOL isDefaultTitle;

@end

@implementation LYSlidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentButton = [UIButton new];
    self.sliderView = [UIView new];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.topBackView];
    
}
- (UIView*)topBackView{
    if (_topBackView == nil) {
        _currentOffset = CGPointMake(0, 0);
        _topBackView = [[UIView alloc]init];
        _topBackView.frame = CGRectMake( 0,  kNavigationBarHeight,  KUIScreenWidth,  backViewHeight);
        _topBackView.backgroundColor = [UIColor whiteColor];
        _topBackView.userInteractionEnabled = true;
        UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, backViewHeight-1, KUIScreenWidth, bottomHeight)];
        bottomLine.backgroundColor = MainBGColor;
        [_topBackView addSubview:bottomLine];
    }
    return _topBackView;
}

- (UIScrollView*)mainScrollView{
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, backViewHeight+kNavigationBarHeight, KUIScreenWidth, KUIScreenHeight - backViewHeight - kNavigationBarHeight)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        [_mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        _mainScrollView.showsVerticalScrollIndicator = false;
        _mainScrollView.showsHorizontalScrollIndicator = false;
        _mainScrollView.contentOffset = self.currentOffset;
        
    }
    return _mainScrollView;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self setBtnAndSplitLineWithTitleArray:titleArray];
}
-(void)setControllerArray:(NSArray *)controllerArray{
    _controllerArray = controllerArray;
    [controllerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *controller = (UIViewController*)obj;
        controller.view.frame = CGRectMake(idx*KUIScreenWidth, 0, KUIScreenWidth, self.mainScrollView.frame.size.height);
        [self addChildViewController:controller];
        [self.mainScrollView addSubview:controller.view];
        
    }];
    
}

- (void)setBtnAndSplitLineWithTitleArray:(NSArray*)titlesArray{
    CGFloat btnWidth = KUIScreenWidth/titlesArray.count;
    //底部选择的红色水平线
    _sliderView.backgroundColor = selectedTextColor;
    for (int i = 0; i<titlesArray.count; i++) {
        UIButton *btn = [self setBtnWithIndex:i btnWidth:btnWidth titlesArray:titlesArray];
        if (i == 0) {
            btn.selected = YES;
            self.currentButton = btn;
            self.sliderView.frame = CGRectMake(0, backViewHeight - sliderHeight, btnWidth, sliderHeight);
            [self.topBackView addSubview:self.sliderView];
        }
        [self.topBackView addSubview:btn];
    }
    self.mainScrollView.contentSize = CGSizeMake(titlesArray.count*KUIScreenWidth, 0);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSValue*newValue = change[NSKeyValueChangeNewKey];
    CGPoint new = [newValue CGPointValue];
    self.sliderView.frame=CGRectMake(new.x*self.sliderView.frame.size.width/KUIScreenWidth, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = (NSUInteger)(self.mainScrollView.contentOffset.x/KUIScreenWidth);
    if (index < self.titleArray.count) {
        UIButton * btn = (UIButton *)[self.topBackView viewWithTag:index+baseTopBtnTag];
        [self slideBtnClick:btn];
    }
}

- (UIButton*)setBtnWithIndex:(NSInteger)index
               btnWidth:(CGFloat)btnWidth
                 titlesArray:(NSArray*)titlesArray{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(index*btnWidth, 0, btnWidth, backViewHeight-sliderHeight)];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:titlesArray[index] forState:UIControlStateNormal];
    [btn setTitleColor:normalTextColor forState:UIControlStateNormal];
    [btn setTitleColor:selectedTextColor forState:UIControlStateSelected];
    btn.tag = index + baseTopBtnTag;
    [btn addTarget:self action:@selector(slideBtnClick:) forControlEvents:UIControlEventTouchDown];
    return btn;
    
}
- (void)slideBtnClick:(UIButton*)sender{
    if (sender == self.currentButton) {
        return;
    }else{
        self.currentButton.selected = false;
        sender.selected = !sender.selected;
        self.currentButton = sender;
        [UIView animateWithDuration:.3 animations:^{
            self.mainScrollView.contentOffset = CGPointMake((sender.tag - baseTopBtnTag)*KUIScreenWidth, 0);
            self.sliderView.center = CGPointMake(self.currentButton.center.x, self.sliderView.center.y);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mainScrollView.contentOffset = self.currentOffset;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.currentOffset = self.mainScrollView.contentOffset;
}
- (void)dealloc{
    [self.mainScrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
