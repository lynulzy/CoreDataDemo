//
//  Item.h
//  Done
//
//  Created by ZSXJ on 15/1/19.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedAt;

@end
