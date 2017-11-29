//
//  CityListViewController.m
//  CityList
//
//  Created by 赵剑秋 on 17/11/28.
//  Copyright © 2017年 赵剑秋. All rights reserved.
//

#import "CityListViewController.h"
#import "ChineseString.h"
#import "GlobalMacro.h"
@interface CityListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UIImageView *upImgView;
}

@property (nonatomic, strong) UITableView *cityTableView;

@property (nonatomic, strong)UIButton *centerButton;
@property (nonatomic, strong)UIButton *cancelButton;
@property(nonatomic,strong)NSMutableArray *cityIndexArray;//索引数组
@property(nonatomic,strong)NSMutableArray *cityLetterCategoryArr;//首字母分类数组
@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) UILabel *sectionTitleLabel;//正中的label字母显示
@property (nonatomic, strong) NSTimer *timer;//动画的timer
@end

@implementation CityListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.centerButton setTitle:_cityName forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    
    [self loadCityList];
    
    [self initSectionTitleView];
}

-(void)initTableView{
    
    //中间城市按钮
    self.centerButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 30, 80, 30)];
    self.centerButton.center=CGPointMake(ScreenWidth/2, 45);
    
    
    [self.centerButton setTitle:_cityName forState:UIControlStateNormal];
    [self.centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.centerButton];
    
    //三角下拉收起箭头
    
    upImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 7, 3)];
    upImgView.center=CGPointMake(ScreenWidth/2, 40+20);
    upImgView.image=[UIImage imageNamed:@"收起状态"];
    [self.view addSubview:upImgView];
    
    
    self.cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 10, 60, 30)];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal ];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    self.cancelButton.hidden=YES;
    
    
    
    self.cityTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    self.cityTableView.delegate=self;
    self.cityTableView.dataSource=self;
    self.cityTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.cityTableView];
    
    self.cityTableView.hidden=YES;
    
    self.cityTableView.bounces=NO;
    
    
}

-(void)centerClick{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma  mark 室内地图sdk获取数据源

//得到城市列表
-(void)loadCityList{
    
    self.cityIndexArray=[NSMutableArray array];
    self.cityLetterCategoryArr=[NSMutableArray array];
    self.cityListArray=[NSMutableArray array];
    
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data.plist" ofType:nil]];
    self.cityListArray=[NSMutableArray array];
    for (NSString *cityName in dic.allKeys) {
        [self.cityListArray addObject:cityName];
    }
    
    
    //右侧索引表
    self.cityIndexArray = [ChineseString IndexArray:self.cityListArray];
    //无序数组 按首字母分类 得到 有序数组
    self.cityLetterCategoryArr = [ChineseString LetterSortArray:self.cityListArray];
    self.cityTableView.hidden=NO;
    [self.cityTableView reloadData];
    
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


// 点击导航栏取消按钮
-(void)cancelAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableView deletegate
//右侧索引显示
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    self.cityTableView.sectionIndexBackgroundColor=[UIColor clearColor];
    
    self.cityTableView.sectionIndexColor=[UIColor whiteColor];
    
    return self.cityIndexArray;
    
}

//城市列表
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init] ;
    UILabel *topLineLabel=[[UILabel alloc]init];
    
    UILabel *bottomLineLabel=[[UILabel alloc]init];
    
    
    topLineLabel.backgroundColor=CREAT_COLOR(150, 150, 150, 1.0);
    bottomLineLabel.backgroundColor=CREAT_COLOR(150, 150, 150, 1.0);
    myView.frame=CGRectMake(0, 0, ScreenWidth, 30);
    myView.backgroundColor =[UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-90)/2.0, 0, 90, 30)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=[self.cityIndexArray objectAtIndex:section];
    [myView addSubview:titleLabel];
    
    topLineLabel.frame=CGRectMake(0, 0, ScreenWidth, 0.5);
    bottomLineLabel.frame=CGRectMake(0, myView.frame.size.height-0.5, ScreenWidth,0.5);
    [myView addSubview:topLineLabel];
    [myView addSubview:bottomLineLabel];
    
    return myView;
}
//section.count
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.cityIndexArray count];
    
    
}
//section--row.count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    return [[self.cityLetterCategoryArr objectAtIndex:section] count];
    
    
    
}
//cell显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text = [[self.cityLetterCategoryArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor=[UIColor whiteColor];
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
    
    //点击city时刷新建筑物界面
    NSString *regionName=[[self.cityLetterCategoryArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    for (int i=0; i<self.cityListArray.count; i++) {
        NSString *cityName=self.cityListArray[i];
        if ([regionName isEqualToString:cityName] ) {
            
            [self.centerButton setTitle:regionName forState:UIControlStateNormal];
        }
    }
    
    self.cancelButton.hidden=YES;
    
    upImgView.hidden=YES;
    
    
    
    [self.delegate loadBuildListWithCityName:regionName];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
