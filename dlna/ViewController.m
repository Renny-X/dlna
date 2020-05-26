//
//  ViewController.m
//  dlna
//
//  Created by X on 2020/5/27.
//  Copyright © 2020 X. All rights reserved.
//

#import "ViewController.h"
#import <MRDLNA/MRDLNA.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, DLNADelegate>

@property(nonatomic, strong) UITableView *tableV;

@property(nonatomic, strong) NSArray *deviceArr;

@property(nonatomic, strong) MRDLNA *dlnaManager;

@end

@implementation ViewController

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableV.delegate = self;
        _tableV.dataSource = self;
    }
    return _tableV;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.title = @"DLNA";
    
    self.deviceArr = [NSArray array];
    [self.view addSubview:self.tableV];
    [self.dlnaManager startSearch];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dlnaManager = [MRDLNA sharedMRDLNAManager];
    self.dlnaManager.delegate = self;
    
    // Do any additional setup after loading the view.
}

#pragma mark - DLNADelegate
- (void)searchDLNAResult:(NSArray *)devicesArray {
    self.deviceArr = [NSArray arrayWithArray:devicesArray];
    [self.tableV reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DLNA_DEVICE_DATASOURCE"];
    CLUPnPDevice *model = self.deviceArr[indexPath.row];
    cell.textLabel.text = model.friendlyName;
    cell.detailTextLabel.text = model.modelName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *testUrl = @"https://v-cdn.zjol.com.cn/280443.mp4";
    testUrl = @"https://www.baidu.com";
    testUrl = @"http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8";
    
    CLUPnPDevice *model = self.deviceArr[indexPath.row];
    NSLog(@"%@", model);
    
    self.dlnaManager.device = model;
    self.dlnaManager.playUrl = testUrl;
    [self.dlnaManager startDLNA];
}

@end
