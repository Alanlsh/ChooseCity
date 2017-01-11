//
//  ViewController.m
//  ChooseCity
//
//  Created by Alan on 2017/1/10.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "ViewController.h"

#import "ChooseCityViewController.h"
#import "GetCityViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 100, 64)];
    button.backgroundColor =[UIColor redColor];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
    
    
}

- (void)buttonClicked:(id)sender
{
    ///方式一
//    ChooseCityViewController *viewController = [[ChooseCityViewController alloc] init];
    
    ///方式二
    GetCityViewController *viewController = [[GetCityViewController alloc] init];
    viewController.getCityBlock = ^(NSString *city){
    
        NSLog(@"_________________%@__________________",city);

    };
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
}



@end
