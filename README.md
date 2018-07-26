
&ensp;&ensp;&ensp;&ensp;先看图，这里为了方便展示gif图片，在冒泡排序、选择排序、插入排序，视图更新停留的时间设置为0.001秒，其他排序设置视图更新时间为0.003秒。

![0冒泡排序（0.001s）.gif](https://upload-images.jianshu.io/upload_images/1487718-c67a8b114e5a12b8.gif?imageMogr2/auto-orient/strip)

![1选择排序（0.001s）.gif](https://upload-images.jianshu.io/upload_images/1487718-ab8a517890793cd8.gif?imageMogr2/auto-orient/strip)

![2插入排序（0.001s）.gif](https://upload-images.jianshu.io/upload_images/1487718-94a562e4f40c9067.gif?imageMogr2/auto-orient/strip)

![3快速排序（0.003s）.gif](https://upload-images.jianshu.io/upload_images/1487718-20d8e1c4744b3002.gif?imageMogr2/auto-orient/strip)

![4希尔排序（0.003s）.gif](https://upload-images.jianshu.io/upload_images/1487718-2db8865d136d7b27.gif?imageMogr2/auto-orient/strip)

![5归并排序（0.003s）.gif](https://upload-images.jianshu.io/upload_images/1487718-92b55075ee71d41f.gif?imageMogr2/auto-orient/strip)

![6堆排序（0.003s）.gif](https://upload-images.jianshu.io/upload_images/1487718-f489ad65de02a3a1.gif?imageMogr2/auto-orient/strip)

![7基数排序（0.003s）.gif](https://upload-images.jianshu.io/upload_images/1487718-333d51fc00d19b26.gif?imageMogr2/auto-orient/strip)


## 算法复杂度
![复杂度.jpg](https://upload-images.jianshu.io/upload_images/1487718-3fe0a1205ccd214d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 可视化
### 高度可视化
&ensp;&ensp;&ensp;&ensp;首先，用视图`SortView`的高度来代表随机数，为了便于查看，本身的颜色随着高度变化而变化，对外暴露一个更改高度的方法。
```
#import "SortView.h"

@implementation SortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat y = self.superview.frame.size.height - self.frame.size.height;

    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;

    CGFloat weight = frame.size.height / self.superview.frame.size.height;
    UIColor * color = [UIColor colorWithHue:weight saturation:1 brightness:1 alpha:1];
    self.backgroundColor = color;
}

- (void)updateHeight:(CGFloat)height
{
    CGRect temp = self.frame;
    temp.size.height = height;
    self.frame = temp;
}
```

&ensp;&ensp;&ensp;&ensp;然后再生成随机数数组和`sortView`数组一一对应。
```
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
```
### 排序交换回调
&ensp;&ensp;&ensp;&ensp;然后在排序类，定义一个回调`SortObjectBlock`，用于更新视图的高度。`index`参数是在数组的索引值，`value`是索引值对应元素要修改的高度。
```
typedef void(^SortObjectBlock)(NSInteger index,NSNumber * value);

@interface SortObject : NSObject

@property (nonatomic,copy) SortObjectBlock sortObjectBlock;
```

### 阻塞时间完成视觉效果
`SortObjectBlock`在排序的时候，接收回调,为了方面观察排序的变化，每次数组中有值发生变化的时候阻塞线程0.001s。
```
- (void)sort
{
    SortObject *  sortObject = [SortObject new];
    __weak typeof(self) weakSelf = self;
    sortObject.sortObjectBlock = ^(NSInteger index,NSNumber * value){
        [NSThread sleepForTimeInterval:0.001];
        [weakSelf updateSortViewWithIndex:index widthValue:value];
    };

    ...
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
```

## 8种算法
### 冒泡排序
```
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
```

### 选择排序
```
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
```

### 插入排序
```

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
```

### 快速排序
&ensp;&ensp;&ensp;&ensp;快速排序是对冒泡排序的一种改进，通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。

```
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
        //递归前半部分
        [self quickSort:array leftIndex:left rightIndex:temp - 1];
        //递归后半部分
        [self quickSort:array leftIndex:temp + 1 rightIndex:right];
    }
}

// 将数组以第一个值为准分成两部分，前半部分比该值要小，后半部分比该值要大
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
```

### 希尔排序
&ensp;&ensp;&ensp;&ensp;希尔排序又叫缩小增量排序，属于插入排序的一种。把记录按下标的一定增量分组，对每组使用直接插入排序算法排序；随着增量逐渐减少，每组包含的关键词越来越多，当增量减至1时，整个文件恰被分成一组，算法便终止。这里取得的增量为一半。
```
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
```


### 归并排序
&ensp;&ensp;&ensp;&ensp;归并排序是建立在归并操作上的一种有效的排序算法,该算法是采用分治法的一个非常典型的应用。将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。
```
#pragma mark - 归并排序

- (NSMutableArray *)sort5:(NSMutableArray *)array
{
    [self megerSortWithArray:array];
    return array.copy;
}

- (void)megerSortWithArray:(NSMutableArray *)array
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:1];
    //将数组中的每一个元素放入一个数组中
    for (NSNumber * num in array)
    {
        NSMutableArray * subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }

    //对这个数组中的数组进行合并，直到合并完毕为止
    while (tempArray.count != 1) {
        NSInteger i = 0 ;
        while (i < tempArray.count - 1) {
            //将tempArray[i] 和 tempArray[i+1]合并
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

//将两个有序数组进行合并,返回一个排序好的数组
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
```


### 堆排序
&ensp;&ensp;&ensp;&ensp;它是选择排序的一种。可以利用数组的特点快速定位指定索引的元素。堆分为大根堆和小根堆，是完全二叉树。大根堆的要求是每个节点的值都不大于其父节点的值。
```
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
```

### 基数排序
&ensp;&ensp;&ensp;&ensp;它是透过键值的部份资讯，将要排序的元素分配至某些“桶”中，藉以达到排序的作用。
```
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
```

**参考:[iOS可视化动态绘制八种排序过程(Swift版)](https://www.cnblogs.com/ludashi/p/6065086.html)**

**源码:[SortDemo](https://github.com/iOS-Misaki/SortDemo)**



