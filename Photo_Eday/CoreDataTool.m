//
//  CoreDataTool.m
//  Photo_Eday
//
//  Created by dongl on 14-7-22.
//  Copyright (c) 2014年 dongl. All rights reserved.
//

#import "CoreDataTool.h"
#import "ImgHistory.h"
#import "DestributionSentence.h"
#import "DestributionTitle.h"
#import "TimeTool.h"
@implementation CoreDataTool

//建
+(NSManagedObjectContext*)CreatCoreData:(NSString *)dataName{
//     1.搭建上下文环境
// 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
// 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
// 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *homeDir = NSHomeDirectory();
//    NSString *docs = [NSString stringWithFormat:@"%@/Photo_Eday.app",homeDir];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:dataName]];
//    NSLog(@"%@",url);
// 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
    [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        
    }
// 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    
    return context;
}




+(void)insertInfo:(NSInteger)number
     andCreatTime:(NSString *)creattime
     andPhtotPath:(NSString*)path
        anddtitle:(NSString*)title
      andsentence:(NSString*)sentence
{

    //添加数据
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    ImgHistory *imgH = [NSEntityDescription insertNewObjectForEntityForName:@"ImgHistory" inManagedObjectContext:context];
    imgH.number = [NSNumber numberWithInteger:number];
    imgH.creatTime = creattime;
    imgH.imgLocalPath = path;
    imgH.title = title;
    imgH.sentence = sentence;
    
    NSError *error = nil;
    BOOL success = [context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
}
//首页数据 获取时间
+(NSArray*)TraverseMainViewInfo:(NSString *)dataname andlistname:(NSString *)listname{
    NSMutableArray *arrInfo = [[NSMutableArray alloc]initWithCapacity:10];
    
    NSManagedObjectContext *context = [self CreatCoreData:dataname];
    // 3.从数据库中查询数据
    // 初始化一个查询请求
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request2.entity = [NSEntityDescription entityForName:listname inManagedObjectContext:context];
    
    // 执行请求
    NSError *error5 = nil;
    NSArray *objs2 = [context executeFetchRequest:request2 error:&error5];
    for (NSManagedObject *obj in objs2) {
        NSString *creatTimg = [obj valueForKey:@"creatTime"];
        NSString *pathsBefore = [obj valueForKey:@"imgLocalPath"];
//        NSString *pathsChange = ;
        NSArray *arrGroup = @[creatTimg,pathsBefore,[obj valueForKey:@"imgChangeLocalPath"]];
        
        NSDictionary *dicGroup = [[NSDictionary alloc]initWithObjectsAndKeys:arrGroup,[obj valueForKey:@"id"], nil];
        
        [arrInfo addObject:dicGroup];

    }
    if (error5) {
        [NSException raise:@"查询错误" format:@"%@", [error5 localizedDescription]];
    }
    return arrInfo;
}
//删
+(void)DeletInfo:(NSString*)value{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"imgLocalPath == %@",value];

    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    
    
    [context deleteObject:[objs lastObject]];
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

  }





+(NSArray*)getbeforecompletepath{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"imgLocalPath CONTAINS[cd] %@",@"before"];


    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *photogroup = [NSMutableArray new];
    for (ImgHistory *img in objs) {
        [photogroup addObject:img.imgLocalPath];
    }
    
    return photogroup ;
}

+(NSArray*)getchanged{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"imgLocalPath CONTAINS[cd] %@",@"after"];
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *photogroup = [NSMutableArray new];
    for (ImgHistory *img in objs) {
        NSRange rang = NSMakeRange(img.imgLocalPath.length-5, 1);
        NSString *string = [img.imgLocalPath substringWithRange:rang];
        [photogroup addObject:string];
    }
    
    
    return [photogroup copy];
}

+(NSArray*)getbefore{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"imgLocalPath CONTAINS[cd] %@",@"before"];
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *photogroup = [NSMutableArray new];
    for (ImgHistory *img in objs) {
        NSRange rang = NSMakeRange(img.imgLocalPath.length-5, 1);
        NSString *string = [img.imgLocalPath substringWithRange:rang];
        [photogroup addObject:string];
    }
    
    
    return [photogroup copy];
}



+(NSInteger)getPhtotCount{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    return [objs count];
}

+(NSArray*)getCreateTimes{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];

    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *creattimes = [NSMutableArray new];
    for (ImgHistory *img in objs) {
        [creattimes addObject: img.creatTime];
    }
    
    NSSet *set = [NSSet setWithArray:creattimes];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *userArray = [set sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return userArray;
}

+(NSArray*)getchangedcompletepath{
    NSManagedObjectContext *context = [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"imgLocalPath CONTAINS[cd] %@",@"after"];
    
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *photogroup = [NSMutableArray new];
    for (ImgHistory *img in objs) {
        [photogroup addObject:img.imgLocalPath];
    }
    
    return [photogroup copy];

}

+(NSArray*)getSentences:(NSInteger)age
               andsmile:(NSInteger)smile{
    NSManagedObjectContext *context =  [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"DestributionSentence" inManagedObjectContext:context];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"age == %i AND smile == %i",age,smile];
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( DestributionSentence *sentence in objs) {
        [arr addObject:sentence.sentence];
    }
    
    return [arr copy];
}

+(NSArray*)getTitle:(NSInteger)number
          andgender:(NSInteger)gender{
    NSManagedObjectContext *context =  [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"DestributionTitle" inManagedObjectContext:context];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"age == %i AND gender == %i",number,gender];
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( DestributionTitle *sentence in objs) {
        [arr addObject:sentence.title];
    }
    
    return [arr copy];
}

+(NSString *)getImageBeforePathByCreatetime:(NSString *)createtime{

    NSManagedObjectContext *context =  [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"creatTime ==%@ AND imgLocalPath CONTAINS[cd] %@",createtime,@"before"];
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( ImgHistory *his in objs) {
        [arr addObject:his.imgLocalPath];
    }
    
    return [arr firstObject];
}

+(NSString *)getImageAfterPathByCreatetime:(NSString *)createtime{
    
    NSManagedObjectContext *context =  [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"creatTime ==%@ AND imgLocalPath CONTAINS[cd] %@",createtime,@"after"];
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( ImgHistory *his in objs) {
        [arr addObject:his.imgLocalPath];
    }
    
    return [arr firstObject];
}

+(NSArray *)getImageByCreatetime:(NSString*)createtime{
    NSManagedObjectContext *context =  [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"creatTime == %@ ",createtime];
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( ImgHistory *his in objs) {
        [arr addObject:his.imgLocalPath];
    }
    
    return [arr copy];
}

+(NSArray *)getallphoto{
    NSManagedObjectContext *context =  [CoreDataTool CreatCoreData:data_Name];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"ImgHistory" inManagedObjectContext:context];
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error ];
    NSMutableArray *arr = [NSMutableArray new];
    
    for ( ImgHistory *his in objs) {
        [arr addObject:his.imgLocalPath];
    }
    return [arr copy];
}

@end
