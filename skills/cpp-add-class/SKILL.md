---
name: cpp-add-class
description: Use it to add a new C++ header and implementation file containing a class, given source path, namespace and class name
---
Steps to create a .h and a .cpp file containing initial code for a new C++ class: additional methods and data members will be added later.

Parameters asked to the user:

  - [src_path] mandatory parameter: the root path of the project or subproject: the directory containing the CMakeLists.txt file
  - [namespace] mandatory parameter: the namespace of the C++ class to be created : C++ namespace
  - [class_name] mandatory parameter: the name of the new C++ class, to be created, it must be camelCase, uppercase first letter

Suppose that, for example:

- [src_path] = /home/user/repo/src/my_library
- [namespace] = entities::office
- [class_name] = CompanyEmployee

Refer to the skill: cpp-create-file to create both the Header and the Implementation file.

# Create the Header file ( .h extension)
The name of the file is created starting from the [class_name].
[class_name] is CamelCase
[file_name] corresponds to [class_name] but it is lowercase snakecase

Create the header file in the path: [src_path]/include/[top_namespace]/[sub_namespace]/.../[file_name].h

In the example above, the actual path is:
/home/user/repo/src/my_library/include/entities/office/company_employee.h

# Populate the Header file ( .h extension)
If the [class_name] and [namespace] are those of the example, populate the header file with the content below.
Note that the header guard macro is created concatenating the namespace and the class name, uppercase snake case,
with trailing _H_

```c++
/*************************************************************************************************
 * [Author]
 **************************************************************************************************/
#ifndef ENTITIES_OFFICE_COMPANY_EMPLOYEE_H_
#define ENTITIES_OFFICE_COMPANY_EMPLOYEE_H_

#include <string>

namespace entities {
namespace office {

class CompanyEmployee
{
public:
  // explicit CompanyEmployee(...);

  CompanyEmployee() = default;
  CompanyEmployee( const CompanyEmployee&) = default;
  CompanyEmployee( CompanyEmployee&&) = default;

  CompanyEmployee& operator=( const CompanyEmployee&) = default;
  CompanyEmployee& operator=( CompanyEmployee&&) = default;

  ::std::string toString() const;

private:
};

} // namespace office
} // namespace entities

#endif//ENTITIES_OFFICE_COMPANY_EMPLOYEE_H_
```

# Create the Implementation file ( .cpp extension)
The filename of the implemementation file is the same as the header file, but with .cpp extension, but created  in a different path:
[src_path]/source/[top_namespace]/[sub_namespace]/.../[file_name].cpp

Given the example above, the filepath is:
/home/user/repo/src/my_library/source/entities/office/company_employee.cpp

# Populate the Implementation file ( .cpp extension)

```c++
#include "entities/office/employee.h"

namespace entities {
namespace office {

/*
//------------------------------------------------------------------------------------------------
CompanyEmployee:::CompanyEmployee(...)
{
}
*/

//------------------------------------------------------------------------------------------------
::std::string CompanyEmployee::toString() const {
  return ::std::string{};
}

} // namespace office
} // namespace entities
```
