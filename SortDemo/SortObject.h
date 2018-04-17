//
//  SortObject.h
//  SortDemo
//
//  Created by 余意 on 2018/4/17.
//  Copyright © 2018年 余意. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SortObjectBlock)(NSInteger index,NSNumber * value);

@interface SortObject : NSObject

@property (nonatomic,copy) SortObjectBlock sortObjectBlock;

- (NSMutableArray *)sort0:(NSMutableArray *)array;
- (NSMutableArray *)sort1:(NSMutableArray *)array;
- (NSMutableArray *)sort2:(NSMutableArray *)array;
- (NSMutableArray *)sort3:(NSMutableArray *)array;
- (NSMutableArray *)sort4:(NSMutableArray *)array;
- (NSMutableArray *)sort5:(NSMutableArray *)array;
- (NSMutableArray *)sort6:(NSMutableArray *)array;
- (NSMutableArray *)sort7:(NSMutableArray *)array;


@end
