//
//  FriendsViewController.m
//  WXNavi
//
//  Created by Somiya on 06/06/2018.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "FriendsViewController.h"
#import "Constants.h"
#import <objc/runtime.h>
#import "UINavigationController+StatusBarStyle.h"

typedef NS_ENUM(NSInteger, SingMoveDirection) {
    SingMoveDirectionUp, // 向上滑动
    SingMoveDireCtionDown // 向下滑动
};

const static CGFloat header_h = 270.f;
const static CGFloat shadow_h = 100.f;
const static CGFloat header_inset = 100;
const static CGFloat navi_h = 64;
const static CGFloat xxxthreshold = 14;
const static CGFloat maxFontSize = 17;

@interface FriendsViewController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _lastTouchOffset;
    BOOL _isEndTouches;
    SingMoveDirection _direction;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *naviView;
@property(nonatomic, assign) UIStatusBarStyle barStyle;
@property(nonatomic, strong) UIView *indicatorView;
@property(nonatomic, strong) UIView *backLabel;
@property(nonatomic, strong) UIView *butnItem;
@end

@implementation FriendsViewController
#pragma mark - System Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self setupHeaderUI];
    _isEndTouches = YES;

    // 添加照相按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(takePicture)];

    self.navigationItem.rightBarButtonItem = right;

    // 添加监听，监听应用从后台进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"pixel"] forBarMetrics:UIBarMetricsDefault]; // 导航栏背景设置为透明
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"pixel"]]; //导航栏底部线条设为透明

    if (self.tableView) {
        if (self.tableView.contentOffset.y > header_h - navi_h) {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName: RGBA(0, 0, 0, 1)}];
            self.barStyle = UIStatusBarStyleDefault;
            [self setNeedsStatusBarAppearanceUpdate];
            return;
        }
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName: RGBA(0, 0, 0, 0)}];
    self.barStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _barStyle;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self customNaviBar];
    self.naviView.frame = (CGRect) {self.naviView.frame.origin, {self.naviView.frame.size.width, 64}};
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    self.indicatorView.frame =  (CGRect) {{8, 11.5}, {13, 21}};
    self.indicatorView.alpha = 1;
    self.backLabel.frame =  (CGRect) {{8, 6}, {54, 30}};
    self.backLabel.alpha = 1;
    self.butnItem.frame =  (CGRect) {{323, 6}, {47, 30}};
    self.backLabel.alpha = 1;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: RGBA(255, 255, 255, 1)}];

    self.barStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    [self.naviView removeFromSuperview];
    self.naviView = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init Properties
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBA(20, 98, 104, 1);
        _tableView.contentInset = UIEdgeInsetsMake(-header_inset, 0, 0, 0);
    }
    return _tableView;
}

#pragma mark - Custom Methods
- (void)customNaviBar {
    if (!self.naviView) {
        self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        self.naviView.backgroundColor = RGBA(240, 240, 240, 1);
        self.naviView.alpha = 0;
        NSArray<UIView *> *subviews = self.navigationController.navigationBar.subviews;
        for (UIView *subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                [subview addSubview:self.naviView];
            }
            if ([subview isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                self.butnItem = subview;
            }
            if ([subview isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")]) {
                for (UIView *subview1 in subview.subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
                        self.backLabel = subview1;
                    }
                }
            }
            if ([subview isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                self.indicatorView = subview;
            }
        }
    }
}

- (void)takePicture {

}

- (void)applicationEnterForeground {
    Log_str(@"进入前台");
    // 防止后台进入前台的时候，tableview的contentOffset向下偏移
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)setupHeaderUI {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, header_h)];
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(-20, -shadow_h, SCREEN_WIDTH + 40, shadow_h)];
    shadowView.backgroundColor = RGBA(20, 98, 104, 1);
    shadowView.layer.shadowColor = RGBA(20, 98, 104, 1).CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 70);
    shadowView.layer.shadowOpacity = 0.7;
    shadowView.layer.shadowRadius = 15;

    UIImage *image = [UIImage imageNamed:@"cover.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = (CGRect) {{0, 0}, {SCREEN_WIDTH, header_h}};
    [header addSubview:imageView];
    [imageView addSubview:shadowView];
    self.tableView.tableHeaderView = header;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isEndTouches = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGFloat h = header_h - navi_h;
    CGFloat delta = y - h;
    if (delta < 0) {
        delta = 0;
    }
    if (delta > navi_h) {
        delta = navi_h;
    }
    CGFloat rate = (delta / 15);
    NSMutableDictionary *textAttributes = [[self.navigationController.navigationBar titleTextAttributes] mutableCopy];
    // 修改导航栏外观
    self.navigationController.navigationBar.tintColor = RGBA(255 * (1 - rate), 255 * (1 - rate), 255 * (1 - rate), 1);
    textAttributes[NSForegroundColorAttributeName] = RGBA(0, 0, 0, rate);
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    self.naviView.alpha = rate;

    // 修改状态栏外观
    if (rate > 0.5) {
        self.barStyle = UIStatusBarStyleDefault;
    } else {
        self.barStyle = UIStatusBarStyleLightContent;
    }
    [self setNeedsStatusBarAppearanceUpdate];

    CGFloat move_delta = y - _lastTouchOffset;
    _lastTouchOffset = y;
    if (move_delta >= 0) {
        _direction = SingMoveDirectionUp;
    } else {
        _direction = SingMoveDireCtionDown;
    }

    if (_direction == SingMoveDirectionUp) {
        if (y > header_h - navi_h) {
            // 改变导航栏高度及title字体和位置
            CGRect frame = self.naviView.frame;
            frame.size.height -= move_delta;
            if (frame.size.height < 40) {
                frame.size.height = 40;
            }
            self.naviView.frame = (CGRect) {{0, 0}, {frame.size.width, frame.size.height}};

            textAttributes = [[self.navigationController.navigationBar titleTextAttributes] mutableCopy];
            UIFont *font = textAttributes[NSFontAttributeName];
            CGFloat fontSize = font.pointSize - move_delta * (4.0f / 24.0f);
            if (fontSize < 13) {
                fontSize = 13;
            }
            textAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:fontSize];
            [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];

            CGFloat top = [self.navigationController.navigationBar titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault] - move_delta * (16.0f / 24.0f);
            if (top < -16) {
                top = -16;
            }
            [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:top forBarMetrics:UIBarMetricsDefault];

            // 控制返回按钮和照相机显示隐藏
            CGRect indicatorFrame = self.indicatorView.frame; // {{8, 11.5}, {13, 21}} y值在0 ~ 11.5之间移动
            indicatorFrame.origin.y -= move_delta;
            if (indicatorFrame.origin.y < 0) {
                indicatorFrame.origin.y = 0.0f;
            }
            self.indicatorView.alpha = indicatorFrame.origin.y / 11.5f;
            self.indicatorView.frame = (CGRect) {{indicatorFrame.origin.x, indicatorFrame.origin.y}, indicatorFrame.size};

            CGRect backLabelFrame = self.backLabel.frame; // {{8, 6}, {54, 30}} y值在-5.5 ~ 6之间移动
            CGFloat back_label_y = backLabelFrame.origin.y - move_delta;
            if (back_label_y < -5.5) {
                back_label_y = -5.5f;
            }
            self.backLabel.alpha = fabsf(-5.5f - back_label_y) / 11.5f;
            self.backLabel.frame = (CGRect) {{backLabelFrame.origin.x, back_label_y}, backLabelFrame.size};

            CGRect butnItemFrame = self.butnItem.frame; // {{323, 6}, {47, 30}} y值在-5.5 ~ 6之间移动
            CGFloat back_item_y = butnItemFrame.origin.y - move_delta;
            if (back_item_y < -5.5) {
                back_item_y = -5.5f;
            }
            self.butnItem.alpha = fabsf(-5.5f - back_item_y) / 11.5f;
            self.butnItem.frame = (CGRect) {{butnItemFrame.origin.x, back_item_y}, butnItemFrame.size};
        }
    }
    if (_direction == SingMoveDireCtionDown) {
        if ((y > header_h - navi_h) && (y < header_h)) {
            // 改变导航栏高度及title字体和位置
            CGRect frame = self.naviView.frame;
            frame.size.height -= move_delta;
            if (frame.size.height > 64) {
                frame.size.height = 64;
            }
            self.naviView.frame = (CGRect) {{0, 0}, {frame.size.width, frame.size.height}};

            textAttributes = [[self.navigationController.navigationBar titleTextAttributes] mutableCopy];
            UIFont *font = textAttributes[NSFontAttributeName];
            CGFloat fontSize = font.pointSize - move_delta * (4.0f / 24.0f);
            if (fontSize > 17) {
                fontSize = 17;
            }
            textAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:fontSize];
            [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];

            CGFloat top = [self.navigationController.navigationBar titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault] - move_delta * (16.0f / 24.0f);
            if (top > 0) {
                top = 0;
            }
            [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:top forBarMetrics:UIBarMetricsDefault];

            // 控制返回按钮和照相机显示隐藏
            CGRect indicatorFrame = self.indicatorView.frame; // {{8, 11.5}, {13, 21}} y值在0 ~ 11.5之间移动
            CGFloat indicator_y = indicatorFrame.origin.y - move_delta;
            if (indicator_y > 11.5) {
                indicator_y = 11.5;
            }
            self.indicatorView.alpha = indicator_y / 11.5f;
            self.indicatorView.frame = (CGRect) {{indicatorFrame.origin.x, indicator_y}, indicatorFrame.size};

            CGRect backLabelFrame = self.backLabel.frame; // {{8, 6}, {54, 30}} y值在-5.5 ~ 6之间移动
            CGFloat back_label_y = backLabelFrame.origin.y - move_delta;
            if (back_label_y > 6) {
                back_label_y = 6;
            }
            self.backLabel.alpha = fabsf(-5.5f - back_label_y) / 11.5f;
            self.backLabel.frame = (CGRect) {{backLabelFrame.origin.x, back_label_y}, backLabelFrame.size};

            CGRect butnItemFrame = self.butnItem.frame; // {{323, 6}, {47, 30}} y值在-5.5 ~ 6之间移动
            CGFloat back_item_y = butnItemFrame.origin.y - move_delta;
            if (back_item_y > 6) {
                back_item_y = 6;
            }
            self.butnItem.alpha = fabsf(-5.5f - back_item_y) / 11.5f;
            self.butnItem.frame = (CGRect) {{butnItemFrame.origin.x, back_item_y}, butnItemFrame.size};
        }
    }

    if (_direction == SingMoveDireCtionDown && _isEndTouches) {
        // 改变导航栏高度及title字体和位置
        CGRect frame = self.naviView.frame;
        frame.size.height -= move_delta;
        if (frame.size.height > 64) {
            frame.size.height = 64;
        }
        self.naviView.frame = (CGRect) {{0, 0}, {frame.size.width, frame.size.height}};

        textAttributes = [[self.navigationController.navigationBar titleTextAttributes] mutableCopy];
        UIFont *font = textAttributes[NSFontAttributeName];
        CGFloat fontSize = font.pointSize - move_delta * (4.0f / 24.0f);
        if (fontSize > maxFontSize) {
            fontSize = maxFontSize;
        }
        textAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:fontSize];
        [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];

        CGFloat top = [self.navigationController.navigationBar titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault] - move_delta * (16.0f / 24.0f);
        if (top > 0) {
            top = 0;
        }
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:top forBarMetrics:UIBarMetricsDefault];

        // 控制返回按钮和照相机显示隐藏
        CGRect indicatorFrame = self.indicatorView.frame; // {{8, 11.5}, {13, 21}} y值在0 ~ 11.5之间移动
        CGFloat indicator_y = indicatorFrame.origin.y - move_delta;
        if (indicator_y > 11.5) {
            indicator_y = 11.5;
        }
        self.indicatorView.alpha = indicator_y / 11.5f;
        self.indicatorView.frame = (CGRect) {{indicatorFrame.origin.x, indicator_y}, indicatorFrame.size};
        NSLog(@"========= %f", indicatorFrame.origin.y);
        NSLog(@"indicator frame %@", NSStringFromCGRect(indicatorFrame));

        CGRect backLabelFrame = self.backLabel.frame; // {{8, 6}, {54, 30}} y值在-5.5 ~ 6之间移动
        CGFloat back_label_y = backLabelFrame.origin.y - move_delta;
        if (back_label_y > 6) {
            back_label_y = 6;
        }
        self.backLabel.alpha = fabsf(-5.5f - back_label_y) / 11.5f;
        self.backLabel.frame = (CGRect) {{backLabelFrame.origin.x, back_label_y}, backLabelFrame.size};

        CGRect butnItemFrame = self.butnItem.frame; // {{323, 6}, {47, 30}} y值在-5.5 ~ 6之间移动
        CGFloat back_item_y = butnItemFrame.origin.y - move_delta;
        if (back_item_y > 6) {
            back_item_y = 6;
        }
        self.butnItem.alpha = fabsf(-5.5f - back_item_y) / 11.5f;
        self.butnItem.frame = (CGRect) {{butnItemFrame.origin.x, back_item_y}, butnItemFrame.size};
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _lastTouchOffset = scrollView.contentOffset.y;
    _isEndTouches = YES;
}
@end
