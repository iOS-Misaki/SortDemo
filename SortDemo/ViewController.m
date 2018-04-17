//
//  ViewController.m
//  SortDemo
//
//  Created by 余意 on 2018/4/12.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "ViewController.h"
#import "SortView.h"
#import "SortObject.h"

#define  SCREENWIDTH              [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT             [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong) UIView * containerView;

@property (nonatomic,strong) UISegmentedControl * segment;

@property (nonatomic,strong) NSMutableArray * sortViewArray;

@property (nonatomic,strong) NSMutableArray * randomArray;

@property (nonatomic,assign) NSInteger count;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self containerView];
    
    self.count = 100;
    self.randomArray = [NSMutableArray arrayWithCapacity:self.count];
    [self setup_random];
    
    [self addSortViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [UIView new];
        [self.view addSubview:_containerView];
        _containerView.frame = CGRectMake(0, 50, SCREENWIDTH, SCREENHEIGHT - 200);
        
        NSArray * array = @[@"冒泡",@"选择",@"插入",@"快排",@"希尔",@"归并",@"堆",@"基数"];
        
        _segment = [[UISegmentedControl alloc]initWithItems:array];
        [_segment addTarget:self action:@selector(itemChange:) forControlEvents:UIControlEventValueChanged];
        _segment.frame = CGRectMake(10, SCREENHEIGHT - 130, SCREENWIDTH - 20, 30);
        [self.view addSubview:_segment];
        
        UIButton * btn = [UIButton new];
        btn.frame = CGRectMake(10, SCREENHEIGHT - 80, SCREENWIDTH - 20, 44);
        [btn setTitle:@"排序" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(sort) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    return _containerView;
}

- (NSMutableArray *)sortViewArray
{
    if (!_sortViewArray)
    {
        _sortViewArray = [NSMutableArray arrayWithCapacity:self.count];
    }
    return _sortViewArray;
}

#pragma mark - 生成随机数数组
- (void)setup_random
{
    for (NSInteger i = 0 ; i < self.count ; i ++)
    {
        int height = (int)(SCREENHEIGHT - 200);
        NSInteger random = arc4random() % height;
        NSNumber * num = [NSNumber numberWithInteger:random];
        [self.randomArray addObject:num];
    }
}


- (void)addSortViews
{
    for (NSInteger i = 0 ; i < self.count ; i ++ )
    {
        CGFloat width = SCREENWIDTH / self.count;
        SortView * sortView = [[SortView alloc]initWithFrame:CGRectMake(i * width, 0, width, [self.randomArray[i] integerValue])];
        [self.containerView addSubview:sortView];
        [self.sortViewArray addObject:sortView];
    }
}

- (void)resetView
{
    for(UIView * view in self.sortViewArray)
    {
        [view removeFromSuperview];
    }
    
    [self.sortViewArray removeAllObjects];
    [self.randomArray removeAllObjects];
    [self setup_random];
    [self addSortViews];
}

- (void)itemChange:(UISegmentedControl *)sender
{
    [self resetView];
}

- (void)sort
{
    SortObject *  sortObject = [SortObject new];
    __weak typeof(self) weakSelf = self;
    sortObject.sortObjectBlock = ^(NSInteger index,NSNumber * value){
        [NSThread sleepForTimeInterval:0.003];
        [weakSelf updateSortViewWithIndex:index widthValue:value];
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (self.segment.selectedSegmentIndex) {
            case 0:
                [sortObject sort0:self.randomArray];
                break;
            case 1:
                [sortObject sort1:self.randomArray];
                break;
            case 2:
                [sortObject sort2:self.randomArray];
                break;
            case 3:
                [sortObject sort3:self.randomArray];
                break;
            case 4: {
                [sortObject sort4:self.randomArray];
                break;
            }
            case 5:
                [sortObject sort5:self.randomArray];
                break;
            case 6:
                [sortObject sort6:self.randomArray];
                break;
            case 7:
                [sortObject sort7:self.randomArray];
                break;
            default:
                break;
        }
        
    });
}


#pragma mark - 更新视图
- (void)updateSortViewWithIndex:(NSInteger)index widthValue:(NSNumber *)value
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SortView * sortView = (SortView *)[weakSelf.sortViewArray objectAtIndex:index];
        [sortView updateHeight:[value integerValue]];
    });
}


@end
