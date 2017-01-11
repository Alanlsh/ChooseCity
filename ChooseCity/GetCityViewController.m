//
//  GetCityViewController.m
//  ChooseCity
//
//  Created by Alan on 2017/1/11.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "GetCityViewController.h"

#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define KWIDTH(W)                       (W/375.f)*kScreenWidth  //获取在当前屏幕的width
#define KHEIGHT(H)                      (H/667.f)*kScreenHeight //获取在当前屏幕的height
#define kScreenHeight					[[UIScreen mainScreen] bounds].size.height
// 获取屏幕宽度 即:整屏的宽度
#define kScreenWidth					[[UIScreen mainScreen] bounds].size.width


#define HISTORYCITY    @"history"    //历史搜索数据存储本地key
#define MAXNUMOFHIDTORY  10          //历史数据最大数值

@interface GetCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar      *searchBar;

@property (nonatomic, strong) UITableView      *tableView;


@property (nonatomic, strong) NSMutableDictionary     *brandDictionary;   //非热门

@property (nonatomic, strong) NSMutableArray          *searchArray;       //历史搜索
@property (nonatomic, strong) NSMutableDictionary           *searchDictionary; //历史搜索按钮

@property (nonatomic, strong) NSArray          *titleArray;        //key  首字母索引

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation GetCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    /// 城市数据
    
    self.searchArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:HISTORYCITY]];
    self.brandDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"D":@[@"大理",@"大连",@"大山"],@"K":@[@"昆明",@"昆山",@"我诶",@"哈市",@"水电费",@"收到了",@"按时发发发实打实的发顺丰的发生的",@"阿萨德",@"第三方",@"啊啊"]}];
    self.titleArray = [self.brandDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
    self.searchDictionary = [[NSMutableDictionary alloc] init];
    
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
        return [self getNumForRowArray:self.searchArray font:15];
    }
    //列表 若干A、B、C...小数组
    NSArray *smallArray = self.brandDictionary[self.titleArray[section - 2]]; //self.cityArray[section - 2];
    
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
        
        NSString *key = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
        NSArray *array = self.searchDictionary[key];
        for (NSInteger i = 0; i < array.count; i ++) {
            UIButton *button = array[i];
            [cell addSubview:button];
        }
    }else  if (indexPath.section == 0) {
        cell.textLabel.text = @"获取定位城市";
    }else
    {
        //非热门
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

#pragma mark - 根据字符串长度  判断有多少行
- (NSInteger)getNumForRowArray:(NSArray *)array font:(CGFloat)font
{
    NSInteger line = 1;
    CGFloat left = 10;
    
    // 默认
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [self.searchDictionary setValue:mutableArray forKey:@"1"];
    
    for (NSInteger i = 0; i < array.count; i ++ ) {
        
        //按钮的高度按照cell高度44设置
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:font];
        
        NSString *str = array[i];
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
        
        ///适度调节城市字体间距
        CGFloat width = 60;
        
        if (size.width + left + width <= kScreenWidth - 20) {
            CGRect buttonRect = button.frame;
            buttonRect.origin.x = left;
            buttonRect.size.width = size.width + width;
            button.frame = buttonRect;
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            // 不须换行时
            NSString *key = [NSString stringWithFormat:@"%zd",line];
            NSMutableArray *lineArray = [self.searchDictionary valueForKey:key];
            [lineArray addObject:button];
            
            left = size.width + left + width;
        }else{
            line ++;
            left = 10;
            
            // 换行时添加
            NSString *key = [NSString stringWithFormat:@"%zd",line];
            NSMutableArray *lineArray = [[NSMutableArray alloc] init];
            [self.searchDictionary setValue:lineArray forKey:key];
            
            CGRect buttonRect = button.frame;
            buttonRect.origin.x = left;
            buttonRect.size.width = size.width + width;
            button.frame = buttonRect;
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [lineArray addObject:button];
            
            left = size.width + left + width;
        }
    }
    return line;
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


