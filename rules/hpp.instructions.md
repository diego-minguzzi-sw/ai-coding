---
name: 'C++ header files coding guidelines'
applyTo: 
  - "**/*.h"  
  - "**/*.hpp"  
paths:
  - "**/*.h"
  - "**/*.hpp"  
---
# C++ coding standards for header files
- Use 2 spaces for indentation. Always indent using spaces, no tabs.

- Class names are written in PascalCase, with first letter uppercase.

- Class methods and functions are written in camelCase, with first letter lowercase

- Class data members are written in camel case, with leading underscore

- If you write a new class, add the default copy and move constructors

- If you write a new class, add the default copy and move assignment operators

- class data members of built in types, must have an initializer in the header

- no unscoped enums, only scoped enums, ```c++ enum class RobotState { Idle, Running } ```

- getter methods have the same name as the data member, without the leading underscore. They are const methods

- order include files :
  - at the beginning write include files of the project, alphabetically sorted
  - then write third party include files , ROS2 include files, etc alphabetically sorted
  - at the end put standard library include files, alphabetically sorted

- in methods and function declarations, do no add the parameter names, for user-defined, stl, and stdlib types

- inline functions, with the body in the header file, are not recommended, unless they are one line

- vertically align the member variables, considering the longer member variable data type

- initialize class data members of built-in types (int, float, uint32_t, etc.) using curly braces

Example of the rules above.

```c++
/*
 * Copyright (c) 2026 Brooks Laboratory Automation Solutions Pty Ltd
 */
#ifndef MY_NAMESPACE__MY_CLASS_H_
#define MY_NAMESPACE__MY_CLASS_H_

#include "my_library/my_classes.h"
#include "my_library/my_utilities.h"

#include <cmath>
#include <string>

namespace my_namespace {


class MyClass
{
public:
  MyClass( const MyClass&)= default;
  MyClass( MyClass&&)= default;

  MyClass& operator=( const MyClass&)= default;
  MyClass& operator=( MyClass&&)= default;

  void myFunction( void);

  bool isMoving( MotionState);

private:
  int               _aValue{};
  ::std::string     _objectId{};
  Logger&           _logger;
  CobotStaticParams _params;
  int               _numEvents{};
};

bool canSelectRobotInMotionState( MotionState);

} // namespace my_namespace

#endif  //MY_NAMESPACE__MY_CLASS_H_

```
