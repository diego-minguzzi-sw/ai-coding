---
name: 'C++ implementation files coding guidelines'
applyTo: "**/*.cpp"
paths:
  - "**/*.cpp"
---
# C++ coding standards for implementation files
- Use 2 spaces for indentation. Always indent using spaces, no tabs.

- initialize variables with ```c++ auto ```. Use initialization with auto the variable and the data type. Examples:
```c++
  auto graspErrorCode= ::gw_comm::autom_elements::ErrorCode::OK;
  auto errorMessage = ::std::string{};
```

- When comparing a constant and a variable for equality or not equality, place the constant first. this is MANDATORY.
  Examples
```c++
  if ( ::robot_control::GraspState::GraspingObject!=graspState)
  {
    return false;
  }
```
```c++ if( nullptr == motor ) { return; }  ```


- Class names are written in PascalCase, with first letter uppercase. Example: ```c++ class RobotAutomationElement ```

- Class methods and functions are written in camelCase, with first letter lowercase. Example: ```c++ void toString() const; ```

- Class data members are written in camel case, with leading underscore

- getter methods have the same name as the data member, without the leading underscore. They are const methods.

- order include files :
  - at the beginning write include files of the project, alphabetically sorted
  - then write third party include files , ROS2 include files, etc alphabetically sorted
  - at the end put standard library include files, alphabetically sorted.

- in methods and function declarations, do no add the parameter names, for non built-in types.

- inline functions, with the body in the header file, are not recommended, unless they are one line.

- vertically align the member variables, considering the longer member variable data type.

- Before any method or function implementation, insert a horizontal comment line with dashes, 99 characters wide.

- In switch case constructors handling enumerations, there must be no ```c++ default: ``` . Rather, all enumerators must be handled.


Example of the rules above.

```c++
/*
 * Copyright (c) 2026 Brooks Laboratory Automation Solutions Pty Ltd
 */
#include "my_library/my_classes.h"

#include <cmath>
#include <string>

namespace my_namespace {

//------------------------------------------------------------------------------------------------
void MyClass::myFunction( void)
{
  // Implementation
}

//------------------------------------------------------------------------------------------------
bool MyClass::isMoving( MotionState)
{
  // Implementation
  return false;
}

//------------------------------------------------------------------------------------------------
void MyClass::addFocMotor( ::AqmErpc::MotorId motorId, PtrFocMotorDevice&& motor )
{
  _focMotors.insert_or_assign( motorId, ::std::move( motor ) );
}

} // namespace my_namespace

```
