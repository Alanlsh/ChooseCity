//
//  ChooseCityViewController.m
//  ChooseCity
//
//  Created by Alan on 2017/1/10.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "ChooseCityViewController.h"

#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define KWIDTH(W)                       (W/375.f)*kScreenWidth  //获取在当前屏幕的width
#define KHEIGHT(H)                      (H/667.f)*kScreenHeight //获取在当前屏幕的height
#define kScreenHeight					[[UIScreen mainScreen] bounds].size.height
// 获取屏幕宽度 即:整屏的宽度
#define kScreenWidth					[[UIScreen mainScreen] bounds].size.width
#define HISTORYCITY    @"history"    //历史搜索数据存储本地key
#define MAXNUMOFHIDTORY  10          //历史数据最大数值
#define NUMBUTTONFORROW  3.0         //历史搜索每行分布n个button

@interface ChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar      *searchBar;

@property (nonatomic, strong) UITableView      *tableView;

@property (nonatomic, strong) NSMutableDictionary     *brandDictionary;   //非热门

@property (nonatomic, strong) NSMutableArray          *searchArray;       //历史搜索

@property (nonatomic, strong) NSArray          *titleArray;        //key  首字母索引

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ChooseCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    /// 城市数据
    
    self.searchArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:HISTORYCITY]];
    self.brandDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"D":@[@"大理",@"大连",@"大山"],@"K":@[@"昆明",@"昆山"]}];
    
    self.titleArray = [self.brandDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
   
    [self.view addSubview: self.tableView];
}

// 选择城市
- (void)selectCity:(UIButton *)button
{
    if (self.getCityBlock) {
        self.getCityBlock(button.titleLabel.text);
    }
    [self.searchArray insertObject:button.titleLabel.text atIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return self.brandDictionary.allKeys.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (section == 0) {
            return 1;
        }else if (section == 1){//历史搜索
            
            if (self.searchArray.count == 0) return 1;
            
            NSInteger numButtonForRow = NUMBUTTONFORROW;
            if (self.searchArray.count%numButtonForRow > 0) {
                
                return self.searchArray.count/NUMBUTTONFORROW + 1;
            }else{
                return self.searchArray.count/NUMBUTTONFORROW;
            }
        }
    //列表 若干A、B、C...小数组
        NSArray *smallArray = self.brandDictionary[self.titleArray[section - 2]];
        
        return smallArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
        if (indexPath.section == 1)
        {//历史搜索
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"hotCell"];
            
            UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KHEIGHT(47))];
            aview.backgroundColor = [UIColor whiteColor];
            [cell addSubview:aview];
            
            for (NSInteger i = 0; i < 4; i ++ ) {
                NSInteger integer = NUMBUTTONFORROW*indexPath.row + 1 + i ;
                if (integer < self.searchArray.count || integer == self.searchArray.count)
                {
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(KWIDTH(20) + KWIDTH(335)/NUMBUTTONFORROW * i, 0, KWIDTH(335)/NUMBUTTONFORROW , KHEIGHT(47))];
                    [button setTitle:self.searchArray[integer - 1] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
  
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    button.tag = integer - 1;
                    [cell addSubview:button];
                }
            }
            
        }else  if (indexPath.section == 0) {
            cell.textLabel.text = @"获取定位城市";
        }else
        {
            //列表
            NSArray *smallArray =  self.brandDictionary[self.titleArray[indexPath.section - 2]];
            cell.textLabel.text = smallArray[indexPath.row];
        }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHEIGHT(24);
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (section == 0)
        {
            return @"GPS定位城市";
        }else if (section == 1){
            return @"历史搜索";
        }
        //城市列表 若干A、B、C...小数组
        return self.titleArray[section - 2];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.titleArray];
    [array insertObject:@"历史" atIndex:0];
    return [array copy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        if (self.getCityBlock) {
            self.getCityBlock(cell.textLabel.text);
            [self.searchArray insertObject:cell.textLabel.text atIndex:0];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }else if (indexPath.section == 1){
        return;
    }else{
        if (self.getCityBlock) {
            self.getCityBlock(cell.textLabel.text);
            [self.searchArray insertObject:cell.textLabel.text atIndex:0];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSMutableSet *set = [[NSMutableSet alloc] init];
    NSMutableArray *historyCityArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < self.searchArray.count; i ++) {
        NSString *str = self.searchArray[i];
        if (![set containsObject:str]) {
            [historyCityArray addObject:str];
            [set addObject:str];
        }
    }
    
    if (historyCityArray.count > MAXNUMOFHIDTORY ) {
        historyCityArray = [[NSMutableArray alloc] initWithArray:[historyCityArray subarrayWithRange:NSMakeRange(0, MAXNUMOFHIDTORY)]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:historyCityArray forKey:HISTORYCITY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - lazy initializing tableView
- (UITableView *)tableView
{
    if (!_tableView) {//KHEIGHT(44)
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight =  KHEIGHT(47);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, KHEIGHT(44))];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

@end


