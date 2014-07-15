//
//  PostMessageViewController.m
//  FindMe
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "PostMessageViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "PostNews.h"
#import "PostDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface PostMessageViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    NSMutableArray *_dataArr;
}

@end

@implementation PostMessageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self getPostMessageByNewsId:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)getPostMessageByNewsId:(NSString *)newsId{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/news/news_list.do",Host];
    NSString *type = (newsId?@"ol":@"nl");
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"type": type}];
    if ([type isEqualToString:@"nl"]) {
        [_dataArr removeAllObjects];
    }else{
        [parameters setValue:newsId forKey:@"newsId"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak __typeof(&*self)weakSelf = self;
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *newsList = [responseObject objectForKey:@"newsList"];
        if (newsList!=nil) {
            [_dataArr addObjectsFromArray:[PostNews objectArrayWithKeyValuesArray:newsList]];
            [weakSelf.tableView reloadData];
        }else{
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"postNewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    cell.textLabel.text = ((PostNews *)_dataArr[indexPath.row]).postContent;
    if ([((PostNews *)_dataArr[indexPath.row]).isRead isEqualToString:@"0"]) {
            [cell viewWithTag:100].hidden = NO;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"messageToPostDetail" sender:_dataArr[indexPath.row]];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"messageToPostDetail"]) {
        PostDetailViewController *controller = (PostDetailViewController *)segue.destinationViewController;
        controller.post = sender;
    }
}
#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"暂无动态";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    textColor = HDRED;
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    text = @"赶快吐槽起来";
    font = [UIFont systemFontOfSize:13.0];
    textColor = HDRED;
    paragraph.lineSpacing = 4.0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"graylogo"];
}


@end
