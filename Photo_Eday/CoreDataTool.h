//
//  CoreDataTool.h
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataTool : NSObject
+(NSManagedObjectContext*)CreatCoreData:(NSString *)dataName;
+(NSArray*)TraverseMainViewInfo:(NSString *)dataname andlistname:(NSString *)listname;
+(void)DeletInfo:(NSString*)value;
+(void)insertInfo:(NSInteger)number
            andCreatTime:(NSString *)creattime
            andPhtotPath:(NSString*)path
            anddtitle:(NSString*)title
      andsentence:(NSString*)sentence;
+(NSArray*)getbeforecompletepath;
+(NSArray*)getchanged;
+(NSArray*)getbefore;
+(NSArray*)getchangedcompletepath;
+(NSArray*)getCreateTimes;
+(NSArray*)getSentences:(NSInteger)age
               andsmile:(NSInteger)smile;
+(NSArray*)getTitle:(NSInteger)number
          andgender:(NSInteger)gender;
+(NSInteger)getPhtotCount;


+(NSString *)getImageBeforePathByCreatetime:(NSString *)createtime;
+(NSString *)getImageAfterPathByCreatetime:(NSString *)createtime;
+(NSArray *)getImageByCreatetime:(NSString*)createtime;
+(NSArray *)getallphoto;

@end
