//
//  SortObject.m
//  SortDemo
//
//  Created by 余意 on 2018/4/17.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "SortObject.h"


@implementation SortObject

#pragma mark - 冒泡
- (NSMutableArray *)sort0:(NSMutableArray *)array
{
    for (NSInteger i = 0 ; i < array.count ; i ++ )
    {
        for (NSInteger j = 0 ; j < i ; j ++ )
        {
            if (array[i] < array[j])
            {
                if (_sortObjectBlock)
                {
                    _sortObjectBlock(i,array[j]);
                    _sortObjectBlock(j,array[i]);
                }
                
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array.copy;
}

#pragma mark - 选择排序
- (NSMutableArray *)sort1:(NSMutableArray *)array
{
    for (NSInteger i = 0 ; i < array.count ; i ++ )
    {
        for (NSInteger j = i + 1 ; j < array.count ; j ++ )
        {
            if (array[i] > array[j])
            {
                if (_sortObjectBlock)
                {
                    _sortObjectBlock(i,array[j]);
                    _sortObjectBlock(j,array[i]);
                }
                
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    return array.copy;
}

#pragma mark - 插入排序
- (NSMutableArray *)sort2:(NSMutableArray *)array
{
    for (NSInteger i = 0 ; i < array.count ; i ++ )
    {
        NSNumber * temp = array[i];
        for (NSInteger j = i - 1 ; j >= 0 && temp < array[j] ; j -- )
        {
            if (_sortObjectBlock)
            {
                _sortObjectBlock(j,array[j + 1]);
                _sortObjectBlock(j + 1,array[j]);
            }
            
            [array exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
        }
    }
    
    return array.copy;
}

#pragma mark - 快速排序

- (NSMutableArray *)sort3:(NSMutableArray *)array
{
    [self quickSort:array leftIndex:0 rightIndex:array.count - 1];
    return array.copy;
}

- (void)quickSort:(NSMutableArray *)array leftIndex:(NSInteger)left rightIndex:(NSInteger)right
{
    if (left < right)
    {
        NSInteger temp = [self getMiddleIndex:array leftIndex:left rightIndex:right];
        [self quickSort:array leftIndex:left rightIndex:temp - 1];
        [self quickSort:array leftIndex:temp + 1 rightIndex:right];
    }
}

- (NSInteger)getMiddleIndex:(NSMutableArray *)array leftIndex:(NSInteger)left rightIndex:(NSInteger)right
{
    NSNumber * temp = array[left];
    while (left < right) {
        while (left < right && temp <= array[right]) {
            right -- ;
        }
        
        if (left < right)
        {
            if (_sortObjectBlock)
            {
                _sortObjectBlock(left,array[right]);
            }
            
            array[left] = array[right];
        }
        
        while (left < right && array[left] <= temp) {
            left ++ ;
        }
        
        if (left < right)
        {
            if (_sortObjectBlock)
            {
                _sortObjectBlock(right,array[left]);
            }
            
            array[right] = array[left];
        }
    }
    
    if (_sortObjectBlock)
    {
        _sortObjectBlock(left,temp);
    }
    
    array[left] = temp;
    
    return left;
}

#pragma mark - 希尔排序
- (NSMutableArray *)sort4:(NSMutableArray *)array
{
    for (NSInteger increment = array.count / 2 ; increment > 0 ; increment /= 2 )
    {
        for (NSInteger i = increment ; i < array.count ; i ++ )
        {
            NSInteger j = i ;
            for (; j - increment >= 0 && array[j] < array[j-increment]; j -= increment)
            {
                if (_sortObjectBlock)
                {
                    _sortObjectBlock(j,array[j - increment]);
                    _sortObjectBlock(j - increment,array[j]);
                }
                
                [array exchangeObjectAtIndex:j withObjectAtIndex:(j - increment)];
            }
        }
    }
    return array.copy;
}

#pragma mark - 归并排序

- (NSMutableArray *)sort5:(NSMutableArray *)array
{
    [self megerSortWithArray:array];
    return array.copy;
}

- (void)megerSortWithArray:(NSMutableArray *)array
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:1];
    for (NSNumber * num in array)
    {
        NSMutableArray * subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }
    while (tempArray.count != 1) {
        NSInteger i = 0 ;
        while (i < tempArray.count - 1) {
            tempArray[i] = [self mergeArrayFirstList:tempArray[i] secondList:tempArray[i + 1]];
            [tempArray removeObjectAtIndex:(i + 1)];
            for (NSInteger subIndex = 0 ; subIndex < [tempArray[i] count]; subIndex ++)
            {
                NSInteger index = [self countEndIndex:i SubItemIndex:subIndex TempArray:tempArray];
                if (_sortObjectBlock)
                {
                    _sortObjectBlock(index,tempArray[i][subIndex]);
                }
            }
            
            i ++ ;
        }
    }
    array = tempArray[0];
}

- (NSArray *)mergeArrayFirstList:(NSArray *)array1 secondList:(NSArray *)array2
{
    NSMutableArray * resultArray = [NSMutableArray array];
    NSInteger firstIndex = 0;
    NSInteger secondIndex = 0;
    while (firstIndex < array1.count && secondIndex < array2.count) {
        if ([array1[firstIndex] integerValue] < [array2[secondIndex] integerValue])
        {
            [resultArray addObject:array1[firstIndex]];
            firstIndex ++ ;
        }
        else
        {
            [resultArray addObject:array2[secondIndex]];
            secondIndex ++ ;
        }
    }
    while (firstIndex < array1.count) {
        [resultArray addObject:array1[firstIndex]];
        firstIndex ++ ;
    }
    while (secondIndex < array2.count) {
        [resultArray addObject:array2[secondIndex]];
        secondIndex ++ ;
    }
    return resultArray.copy;
}

- (NSInteger)countEndIndex:(NSInteger)endIndex SubItemIndex:(NSInteger)subItemIndex TempArray:(NSMutableArray *)tempArray
{
    NSInteger sum = 0 ;
    for (NSInteger i = 0 ; i < endIndex ; i ++ )
    {
        sum += [tempArray[i] count];
    }
    return sum + subItemIndex;
}

#pragma mark - 堆排序
- (NSMutableArray *)sort6:(NSMutableArray *)array
{
    return [self heapSort:array];
}


- (NSMutableArray *)heapSort:(NSMutableArray *)array
{
    NSMutableArray * list = [NSMutableArray arrayWithArray:array];
    NSInteger endIndex = array.count - 1;
    //创建大顶堆 把array 转换为大顶堆层次的遍历结果
    [self heapCreate:list];
    
    while (endIndex >= 0) {
        
        //交换大顶堆的收尾两个值
        if (_sortObjectBlock)
        {
            _sortObjectBlock(0,list[endIndex]);
            _sortObjectBlock(endIndex,list[0]);
            
            [list exchangeObjectAtIndex:0 withObjectAtIndex:endIndex];
        }
        
        //缩小大顶堆的范围
        endIndex -- ;
        [self heapAdjast:list withStartIndex:0 withEndIndex:endIndex + 1];
    }
    
    
    return list;
}


//构建大顶堆的层次遍历序列
- (void)heapCreate:(NSMutableArray *)array
{
    NSInteger i = array.count;
    for (; i > 0; i -- )
    {
        [self heapAdjast:array withStartIndex:i - 1 withEndIndex:array.count];
    }
}

//对大顶堆的局部调整，使其改节点的所有父类符合大顶堆的特点
- (void)heapAdjast:(NSMutableArray *)array withStartIndex:(NSInteger)startIndex withEndIndex:(NSInteger)endIndex
{
    NSNumber * temp = array[startIndex];
    //父节点下标
    NSInteger fatherIndex = startIndex + 1;
    //左孩子下标
    NSInteger leftChildIndex = fatherIndex * 2;
    while (leftChildIndex <= endIndex) {
        //比较左右节点 找出较大的角标
        if (leftChildIndex < endIndex && array[leftChildIndex - 1] < array[leftChildIndex])
        {
            leftChildIndex ++ ;
        }
        
        //如果较大的子节点比根节点大 赋值为父节点
        if (temp < array[leftChildIndex - 1])
        {
            if (_sortObjectBlock)
            {
                _sortObjectBlock(fatherIndex - 1,array[leftChildIndex - 1]);
            }
            
            array[fatherIndex - 1] = array[leftChildIndex - 1];
        }
        else
        {
            break ;
        }
        
        fatherIndex = leftChildIndex;
        leftChildIndex = fatherIndex * 2;
    }
    
    if (_sortObjectBlock)
    {
        _sortObjectBlock(fatherIndex - 1,temp);
    }
    
    array[fatherIndex - 1] = temp;
}

#pragma mark - 基数排序
- (NSMutableArray *)sort7:(NSMutableArray *)array
{
    [self radixSort:array];
    return array.copy;
}

- (void)radixSort:(NSMutableArray *)array
{
    //创建空桶
    NSMutableArray * bucket = [self createBucket];
    
    //待排数组的最大数值
    NSNumber * maxNumber = [self listMaxItem:array];
    
    //最大数值的数字位数
    NSInteger maxLength = [self numberLength:maxNumber];
    
    //按照从低位到高位的顺序执行排序过程
    for (NSInteger digit = 1 ; digit <= maxLength ; digit ++ )
    {
        //入桶
        for (NSNumber * item in array)
        {
            //确定item 归属哪个桶 以digit位数为基数
            NSInteger baseNumber = [self fetchBaseNumber:item digit:digit];
            NSMutableArray * mutArray = bucket[baseNumber];
            //将数据放入空桶上
            [mutArray addObject:item];
        }
        
        NSInteger index = 0;
        
        //出桶
        for (NSInteger i = 0 ; i < bucket.count ; i ++ )
        {
            NSMutableArray * subArray = bucket[i];
            //将桶的数据放回待排数组中
            while (subArray.count != 0) {
                NSNumber * number = [subArray objectAtIndex:0];
                
                if (_sortObjectBlock)
                {
                    _sortObjectBlock(index,number);
                }
                
                array[index] = number;
                [subArray removeObjectAtIndex:0];
                index ++ ;
            }
        }
    }
}

//创建空桶
- (NSMutableArray *)createBucket
{
    NSMutableArray * bucket = [NSMutableArray array];
    for (NSInteger i = 0 ; i < 10 ; i ++ )
    {
        NSMutableArray * array = [NSMutableArray array];
        [bucket addObject:array];
    }
    return bucket;
}

//取列表最大值
- (NSNumber *)listMaxItem:(NSArray *)array
{
    NSNumber * maxNumber = array[0];
    for (NSNumber * number in array)
    {
        if (maxNumber < number)
        {
            maxNumber = number;
        }
    }
    return maxNumber;
}

//数字的位数
- (NSInteger)numberLength:(NSNumber *)number
{
    NSString * string = [NSString stringWithFormat:@"%ld",(long)[number integerValue]];
    return string.length;
}

//number 操作的数字  digit 位数  返回该位数上的数字
- (NSInteger)fetchBaseNumber:(NSNumber *)number digit:(NSInteger)digit
{
    //digit为基数位数
    if (digit > 0 && digit <= [self numberLength:number])
    {
        NSMutableArray * numbersArray = [NSMutableArray array];
        NSString * string = [NSString stringWithFormat:@"%ld",[number integerValue]];
        for (NSInteger index = 0 ; index < [self numberLength:number] ; index ++ )
        {
            NSString * temp = [string substringWithRange:NSMakeRange(index, 1)];
            [numbersArray addObject:temp];
        }
        NSString * str = numbersArray[numbersArray.count - digit];
        return [str integerValue];
    }
    return 0;
}


@end
