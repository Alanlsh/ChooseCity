//
//  ChooseCityViewController.h
//  ChooseCity
//
//  Created by Alan on 2017/1/10.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCityViewController : UIViewController

@property (nonatomic, copy) void(^getCityBlock)(NSString *city);

@end
