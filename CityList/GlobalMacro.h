//
//  GlobalMacro.h
//  Maoner
//
//  Created by 赵剑秋 on 16/7/7.
//  Copyright © 2016年 赵剑秋. All rights reserved.
//

#ifndef GlobalMacro_h
#define GlobalMacro_h




//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width



#define CREAT_COLOR(R,G,B,ALPHA) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:ALPHA]


/**
 *  HUD自动隐藏
 *
 */
#define HUDNormal(msg) {MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:NO];\
hud.mode = MBProgressHUDModeText;\
hud.minShowTime=1;\
hud.detailsLabelText= msg;\
hud.detailsLabelFont = [UIFont systemFontOfSize:17];\
[hud hide:YES afterDelay:1];\
}


#endif /* GlobalMacro_h */
