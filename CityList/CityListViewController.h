//
//  CityListViewController.h
//  CityList
//
//  Created by 赵剑秋 on 17/11/28.
//  Copyright © 2017年 赵剑秋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reloadBuildListDelegate <NSObject>

-(void)loadBuildListWithCityName:(NSString *)cityName;

@end

@interface CityListViewController : UIViewController

@property (nonatomic,weak) id <reloadBuildListDelegate> delegate;

@property (nonatomic,copy) NSString *cityName;
@end
