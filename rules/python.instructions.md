---
name: 'Python coding guidelines'
applyTo: "**/*.py"  
paths:
  - "**/*.py"  
---
# Python coding standards
- Use 2 spaces for indentation. Always indent using spaces, no tabs.

- Class names are written in PascalCase, with first letter uppercase.

- Class methods, local variables and functions are written in camelCase, with first letter lowercase, for example:
  `myVariable`
  `index`
```python
  def myFunction( self) -> None:
    pass
```

- Class data members are written in camel case, with leading underscore, for example, `_myDataMember`.

- Make sure that, before any function or method, there is a horizontal bar, for example in case of a function:
```python
#--------------------------------------------------------------------------------------------------
def testFunction():
  pass
```
  and in case of a method:
```python
#--------------------------------------------------------------------------------------------------
def myMethodFunction( self) -> None:
  pass
```

- At the beginning of each Python file, add the following code to setup the module logging:
```python
import logging
log = logging.getLogger(__name__)
```

- At the top of each empty Python file, add the following banner:
```python
#!/usr/bin/env python3
#--------------------------------------------------------------------------------------------------
# Diego Minguzzi
#--------------------------------------------------------------------------------------------------
```

- Prefer the ternary operator, if it fits one line, to the if else assignment for example:
```python
# prefer this:
device = 'cuda' if torch.cuda.is_available() else 'cpu'

# to this:
if torch.cuda.is_available():
    device = 'cuda'
else:
    device = 'cpu'
```
