#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>

// Serialize object into plain objects for JSON serializer
id serialize(id value) {
  if ([value isKindOfClass:[NSString class]] ||
      [value isKindOfClass:[NSNumber class]]) {
    return value;
  }

  // Format NSDates
  if ([value isKindOfClass:[NSDate class]]) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale =
        [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *iso8601String = [dateFormatter stringFromDate:value];
    return iso8601String;
  }

  // Serialize NSArray
  if ([value isKindOfClass:[NSMutableArray class]] ||
      [value isKindOfClass:[NSArray class]]) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id item in value) {
      id result = serialize(item);
      if (result == nil) {
        continue;
      }
      [array addObject:result];
    }
    return array;
  }

  // Serialize NSDictionary
  if ([value isKindOfClass:[NSMutableDictionary class]] ||
      [value isKindOfClass:[NSDictionary class]]) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (id key in value) {
      id result = serialize([value objectForKey:key]);
      if (result == nil) {
        continue;
      }
      [dict setObject:result forKey:key];
    }
    return dict;
  }

  if ([value isKindOfClass:[ABMultiValue class]]) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [value count]; i++) {
      NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
      [dict setObject:[value identifierAtIndex:i] forKey:@"identitier"];
      [dict setObject:[value labelAtIndex:i] forKey:@"label"];
      [dict setObject:[value valueAtIndex:i] forKey:@"value"];
      [array addObject:dict];
    }
    return array;
  }

  if ([value isKindOfClass:[NSDateComponents class]]) {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]
        initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorianCalendar dateFromComponents:value];
    return serialize(date);
  }

  return nil;
}

NSString *stringify(id value) {
  NSError *writeError = nil;
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:value
                                      options:NSJSONWritingPrettyPrinted
                                        error:&writeError];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
  return jsonString;
}

int main(int argc, char **argv) {

  // Get all prople from address book.
  NSArray *people = [[ABAddressBook sharedAddressBook] people];

  // Get a list of all properties on the record.
  NSArray *properties = [ABPerson properties];

  for (ABPerson *person in people) {
    // Move properties into a dictionary.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *property in properties) {
      id val = [person valueForProperty:property];
      if (val == nil) {
        continue;
      }
      [dict setObject:val forKey:property];
    }
    // Output JSON separated by newlines.

    printf("%s\n", [stringify(serialize(dict)) UTF8String]);
  }
}
