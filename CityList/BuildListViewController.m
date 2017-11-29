//
//  BuildListViewController.m
//  CityList
//
//  Created by 赵剑秋 on 17/11/28.
//  Copyright © 2017年 赵剑秋. All rights reserved.
//

#import "BuildListViewController.h"
#import "GlobalMacro.h"
#import "ChineseString.h"
#import "CityListViewController.h"

@interface BuildListViewController ()<UITableViewDataSource,UITableViewDelegate,reloadBuildListDelegate>
{
    UIImageView *downImgView;
    UIImageView *upImgView;
}

@property (nonatomic, strong) UITableView *buildTableView;


@property (nonatomic, strong)UIButton *centerButton;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic,copy) NSString *cityName;

@property (nonatomic, strong) NSMutableArray *buildListArray;
@property(nonatomic,strong)NSMutableArray *buildIndexArray;//索引数组
@property(nonatomic,strong)NSMutableArray *buildLetterCategoryArr;//首字母分类数组


@property (nonatomic, strong) UILabel *sectionTitleLabel;//正中的label字母显示
@property (nonatomic, strong) NSTimer *timer;//动画的timer
@end

@implementation BuildListViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //设置导航栏颜色
    
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    self.tabBarController.tabBar.hidden=YES;
    
    //中间城市按钮
    if (_cityName==nil) {
        _cityName=@"北京";
    }
    self.centerButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 10, 80, 30)];
    self.centerButton.center=CGPointMake(ScreenWidth/2, 25);
    [self.centerButton setTitle:self.cityName forState:UIControlStateNormal];
    [self.centerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(selectCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.centerButton];
    self.centerButton.hidden=NO;
    
    
    //三角下拉收起箭头
    downImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 7, 3)];
    downImgView.image=[UIImage imageNamed:@"下拉状态"];
    downImgView.center=CGPointMake(ScreenWidth/2, 40);
    [self.navigationController.navigationBar addSubview:downImgView];
    
}

/**
 * 视图即将消失
 */

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.centerButton.hidden=YES;
    self.cancelButton.hidden=YES;
    
    upImgView.hidden=YES;
    downImgView.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initTableView];
    
    [self loadBuildListWithCityName:@"北京"];
    [self initSectionTitleView];
}
-(void)initTableView{
    
    //创建建筑物列表
    self.buildTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.buildTableView.delegate=self;
    self.buildTableView.dataSource=self;
    
    [self.view addSubview:self.buildTableView];
    
    
    
}
#pragma  mark 室内地图sdk获取数据源


//得到建筑列表
-(void)loadBuildListWithCityName:(NSString *)cityName{
    
    _cityName=cityName;
    
    [self.centerButton setTitle:cityName forState:UIControlStateNormal];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data.plist" ofType:nil]];
    
    NSArray *buildArr=[dic objectForKey:cityName];
    
    self.buildLetterCategoryArr=[NSMutableArray array];
    self.buildIndexArray=[NSMutableArray array];
    
    self.buildListArray=[NSMutableArray arrayWithArray:buildArr];
    
    [self.buildIndexArray removeAllObjects];
    [self.buildLetterCategoryArr removeAllObjects];
    
    //    self.dataList=[NSMutableArray array];
    //右侧索引表
    self.buildIndexArray = [ChineseString IndexArray:buildArr];
    //无序数组 按首字母分类 得到 有序数组
    self.buildLetterCategoryArr = [ChineseString LetterSortArray:buildArr];
    //回到主线程刷新界面
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    self.buildTableView.hidden=NO;
    [self.buildTableView reloadData];
    //                NSLog(@"停止刷新");
    
    
    
    
}
#pragma mark 索引视图和点击
//索引标题屏幕正中的label显示
-(void)initSectionTitleView{
    
    self.sectionTitleLabel = ({
        UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-100)/2, (ScreenHeight-100)/2,100,100)];
        sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
        sectionTitleLabel.font = [UIFont boldSystemFontOfSize:60];
        sectionTitleLabel.textColor = [UIColor whiteColor];
        sectionTitleLabel.backgroundColor = [UIColor darkGrayColor];
        sectionTitleLabel.layer.cornerRadius = 6;
        sectionTitleLabel.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
        sectionTitleLabel;
    });
    [self.view addSubview:self.sectionTitleLabel];
    self.sectionTitleLabel.hidden = YES;
}


//动画滑动索引
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleLabel.hidden = YES;
        }];
    });
}

//显示正中label
-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleLabel setText:title];
    self.sectionTitleLabel.hidden = NO;
    self.sectionTitleLabel.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)selectCityAction:(UIButton *)button{
    
    CityListViewController *cityListViewController=[[CityListViewController alloc]init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        cityListViewController.providesPresentationContextTransitionStyle =YES;
        cityListViewController.definesPresentationContext =YES;
        cityListViewController.modalPresentationStyle =UIModalPresentationOverCurrentContext;
        cityListViewController.view.backgroundColor=CREAT_COLOR(0, 0, 0, 0.8);
        cityListViewController.delegate=self;
        cityListViewController.cityName=_cityName;
        [self presentViewController:cityListViewController animated:NO completion:nil];
        
    } else {
        
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:cityListViewController animated:NO completion:nil];
        
    }
    
}
// 点击导航栏取消按钮
-(void)cancelAction{
    
    self.cancelButton.hidden=YES;
    downImgView.hidden=NO;
    upImgView.hidden=YES;
    
}

#pragma mark - UITableView deletegate
//右侧索引显示
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
    self.buildTableView.sectionIndexColor=[UIColor blackColor];
    return self.buildIndexArray;
    
    
    
}
//城市列表
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init] ;
    UILabel *topLineLabel=[[UILabel alloc]init];
    
    UILabel *bottomLineLabel=[[UILabel alloc]init];
    
    
    topLineLabel.backgroundColor=CREAT_COLOR(240, 240, 240, 1.0);
    bottomLineLabel.backgroundColor=CREAT_COLOR(240, 240, 240, 1.0);
    myView.frame=CGRectMake(0, 0, ScreenWidth, 30);
    myView.backgroundColor =[UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-90)/2.0, 0, 90, 30)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text=[self.buildIndexArray objectAtIndex:section];
    [myView addSubview:titleLabel];
    
    topLineLabel.frame=CGRectMake(0, 0, ScreenWidth, 1);
    
    bottomLineLabel.frame=CGRectMake(0, myView.frame.size.height-1, ScreenWidth,1);
    [myView addSubview:topLineLabel];
    [myView addSubview:bottomLineLabel];
    
    return myView;
}
//section.count
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    
    return [self.buildIndexArray count];
    
    
    
}
//section--row.count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [[self.buildLetterCategoryArr objectAtIndex:section] count];
    
    
    
}
//cell显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.textLabel setText:[[self.buildLetterCategoryArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
    
    
}
//点击右侧索引表项时调用
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [self showSectionTitle:title];
    return index;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
    
    
}
//cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
