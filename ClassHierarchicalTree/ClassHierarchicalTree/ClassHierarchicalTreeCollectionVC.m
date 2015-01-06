//
//  ClassHierarchicalTreeCollectionVC.m
//  ClassHierarchicalTree
//
//  Created by JoyWang on 15/1/6.
//  Copyright (c) 2015年 joywt. All rights reserved.
//

#import "ClassHierarchicalTreeCollectionVC.h"
#import "CustomCollectionViewCell.h"
#import "CustomConnectLines.h"
#import "CustomLayout.h"
@interface ClassHierarchicalTreeCollectionVC ()<MyCustomProtocol>
{
    NSDictionary *source;
    NSArray *rightSource;
    NSArray *centerSource;
    NSArray *leftSource;
}
@end

@implementation ClassHierarchicalTreeCollectionVC

static NSString * const reuseIdentifier = @"MyCustomLayoutCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    leftSource = @[@"NSObject"];
    centerSource = @[@"NSLayoutConstraint",@"NSLayoutManager",@"NSParagraphStyle",@"UIAcceleration",@"UIAccelerometer",@"UIAccessibilityElement",@"UIBarItem",@"UIActivity",@"UIBezierPath"];
    rightSource = @[@"NSMutableParagraphStyle",@"UIBarButtonItem",@"UITabBarItem"];
    source = @{@"NSObject":@[@"NSLayoutConstraint",@"NSLayoutManager",@{@"NSParagraphStyle":@[@"NSMutableParagraphStyle"]},@"UIAcceleration",@"UIAccelerometer",@"UIAccessibilityElement",@{@"UIBarItem":@[@"UIBarButtonItem",@"UITabBarItem"]},@"UIActivity",@"UIBezierPath"]};
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:@"ConnectionViewKind" withReuseIdentifier:@"CustomSupplementaryView"];
    
    CustomLayout *layout = [[CustomLayout alloc] init];
    [layout setCustomDataSource:self];
    [self.collectionView setCollectionViewLayout:layout];
    // Do any additional setup after loading the view.
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

#pragma mark <MyCustomProtocol>

- (NSArray *)childrenAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.section ==0 ) {
        NSMutableArray *customArray = [NSMutableArray array];
        for ( int i = 0 ;i < centerSource.count ;i ++ ) {
            [customArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section+1]];
        }
        return customArray;
    }else if (indexPath.section==1){
        NSMutableArray *customArray = [NSMutableArray array];
        __block NSInteger row = 0;
        NSArray *temp = source[[[source allKeys] firstObject]];
        [temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[NSDictionary class]]){
                NSArray *array = obj[[[obj allKeys] firstObject]];
                for (int i = 0; i<array.count; i++) {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:indexPath.section+1];
                    if (idx==indexPath.row) {
                        [customArray addObject:index];
                    }
                    row ++;
                    
                }
            }
        }];
        return customArray;
        
    }
    return nil;
}

/** 返回每个类需要占有多少行,以及他有几个子类 **/

- (NSInteger)numRowsForClassAndChildrenAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.section==1) {
        if(indexPath.row==6){
            return 2;
        }
    }
    
    return 1;
    //    return [self collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return leftSource.count;
            break;
        case 1:
            return centerSource.count;
        default:
            return rightSource.count;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.section==0) {
        [cell.myCustomLabel setText:leftSource[indexPath.row]];
    }else if(indexPath.section==1){
        [cell.myCustomLabel setText:centerSource[indexPath.row]];
        
    }else{
        
        [cell.myCustomLabel setText:rightSource[indexPath.row]];
    }
    
    // Configure the cell
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%s ....... indexPath Row:%d",__PRETTY_FUNCTION__,(int)indexPath.row);
    const NSInteger tag = 11;
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:@"ConnectionViewKind" withReuseIdentifier:@"CustomSupplementaryView" forIndexPath:indexPath];
    UIView *layoutView =  [view viewWithTag:tag];
    if (layoutView!=nil) {
        [layoutView removeFromSuperview];
        layoutView = nil;
    }
    CustomConnectLines *cview = [[CustomConnectLines alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [cview setTag:tag];
    BOOL hasBrother = NO;
    if (indexPath.section==1 ||(indexPath.section==2 && indexPath.row!=0)) {
        hasBrother = YES;
    }
    BOOL isEnd = NO;
    if ((indexPath.section==1 && indexPath.row == centerSource.count-1) || (indexPath.section==2 && indexPath.row==(rightSource.count-1))) {
        isEnd = YES;
    }
    
    BOOL isFirst  = NO;
    if ((indexPath.section==1&&indexPath.row==0)||(indexPath.section==2 && indexPath.row==1)) {
        isFirst = YES;
    }
    [cview layoutLine:isFirst isEnd:isEnd hasBrother:hasBrother hasParent:(indexPath.section>0)];
    
    [view addSubview:cview];
    return view;
}

@end
