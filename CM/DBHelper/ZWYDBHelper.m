//
//  ZWYDBHelper.m
//  CM
//
//  Created by zwy on 14/11/12.
//  Copyright (c) 2014年 zwy. All rights reserved.
//

#import "ZWYDBHelper.h"
#import "FMDB.h"
#import "FMDatabaseQueue.h"
#import "AppDelegate.h"
@implementation ZWYDBHelper

+ (void)initDB {
    FMDatabase *db;
    
    

    //版本号不一致，创建数据库
    NSString *dbFilePath =
    [ZWYDBHelper applicationCacheDirectoryFile:DB_FILE_NAME];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbFilePath] == NO) {
        //创建数据库
        //创建表
        NSString *createtablePath =
        [[NSBundle mainBundle] pathForResource:@"CM" ofType:@"sql"];
        NSString *sql = [[NSString alloc] initWithContentsOfFile:createtablePath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        NSArray *sqlArray = [sql componentsSeparatedByString:@";"];
        
        db = [FMDatabase databaseWithPath:dbFilePath];
        if (![db open]) {
            return;
        }
        
        for (int i = 0; i < sqlArray.count; i++) {
            NSString *sql = [sqlArray objectAtIndex:i];
            if(sql.length > 0)
            {
                BOOL succse = [db executeUpdate:[sqlArray objectAtIndex:i]];
                if(succse)
                {
                    NSLog(@"123");
                }
            }
                
            
        }
        
        // 版本号 TODO
        [ZWYDBHelper dbVersionNubmer];
    }
    else
    {
        NSString *configTalbePath =
        [[NSBundle mainBundle] pathForResource:@"DBConfig" ofType:@"plist"];
        NSDictionary *configTable =
        [[NSDictionary alloc] initWithContentsOfFile:configTalbePath];
        
        //创建数据库
        //从配置文件获得数据口版本号
        NSNumber *dbConfigVersion = [configTable objectForKey:@"DB_VERSION"];
        //从数据库DBVersionInfo表记录返回的数据库版本号
        int versionNumber = [ZWYDBHelper dbVersionNubmer];
        if ([dbConfigVersion integerValue] != versionNumber) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            
            
            if ([fileManager removeItemAtPath:dbFilePath error:nil])
            {
                db = [FMDatabase databaseWithPath:dbFilePath];
                if (![db open]) {
                    return;
                }
                NSString *createtablePath =
                [[NSBundle mainBundle] pathForResource:@"CM" ofType:@"sql"];
                NSString *sql = [[NSString alloc] initWithContentsOfFile:createtablePath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
                NSArray *sqlArray = [sql componentsSeparatedByString:@";"];
                for (int i = 0; i < sqlArray.count; i++) {
                    NSString *sql = [sqlArray objectAtIndex:i];
                    if(sql.length > 0)
                    {
                        BOOL succse = [db executeUpdate:[sqlArray objectAtIndex:i]];
                        if(succse)
                        {
                            NSLog(@"123");
                        }
                    }
                    
                    
                }
            }
            
            [ZWYDBHelper dbVersionNubmer];
            
        }
        
    }
    [db close];
    
    
}
+ (NSString *)applicationCacheDirectoryFile:(NSString *)fileName {
    NSString *CacheDirectory = [NSSearchPathForDirectoriesInDomains(
                                                                    NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [CacheDirectory stringByAppendingPathComponent:fileName];
    return path;
}
+ (int)dbVersionNubmer {
    FMDatabase *db;
    NSString *dbFilePath =
    [ZWYDBHelper applicationCacheDirectoryFile:DB_FILE_NAME];
    int versionNumber = -1;
    db = [FMDatabase databaseWithPath:dbFilePath];
    if (![db open]) {
        return versionNumber;
    }
    else {
        NSString *sql =
        @"create table if not exists DBVersionInfo(version_number int)";
        if (![db executeUpdate:sql]) {
            
        }
        NSString *qsql = @"select version_number from DBVersionInfo";
        FMResultSet *resultSet = [db executeQuery:qsql];
        if ([resultSet next]) {
            versionNumber = [resultSet intForColumn:@"version_number"];
        }
        else
        {
            NSString *configTalbePath =
            [[NSBundle mainBundle] pathForResource:@"DBConfig" ofType:@"plist"];
            NSDictionary *configTable =
            [[NSDictionary alloc] initWithContentsOfFile:configTalbePath];
            
            //创建数据库
            //从配置文件获得数据口版本号
            NSNumber *dbConfigVersion = [configTable objectForKey:@"DB_VERSION"];

            NSString *csql = @"insert into DBVersionInfo(version_number) values(%d)";
            csql = [NSString stringWithFormat:csql,[dbConfigVersion integerValue]];
            [db executeUpdate:csql];
        }
    }
    [db close];
    return versionNumber;
}

@end
