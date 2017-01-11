//
//  GetCityViewController.h
//  ChooseCity
//
//  Created by Alan on 2017/1/11.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetCityViewController : UIViewController

@property (nonatomic, copy) void(^getCityBlock)(NSString *city);

@end
