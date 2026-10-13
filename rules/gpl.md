---
paths:
  - "**/*.gpl"
  - "**/*.GPL"
---
# Guidance Programming Language (GPL) Guidelines

## 0. How to use this reference (instructions for the agent)

- GPL is an **object-oriented BASIC modeled on VB.NET 2003**, but it is **not** VB.NET. When in doubt, follow this file, not VB.NET habits.
- Before writing code, check **Section 1 (Critical rules)** — most compile errors come from VB.NET features GPL does not support.
- Never invent classes, methods, or properties. If something is not listed here, say so and ask, or flag it as "verify in the GPL Dictionary".
- Motion code must respect the **motion preconditions** (Section 13.1): power enabled, robot homed, robot `Attached`.
- Prefer clear, commented code using `'` comments. Keep one statement per line.

---

## 1. Critical rules & differences from VB.NET (read first)

| Topic | GPL rule |
|---|---|
| Statements per line | **Exactly one.** No `:` statement separator (colon is only for labels). |
| Line continuation | Space + underscore at end of line: ` _`. Comment lines cannot be continued. |
| Statement terminator | None. |
| Case sensitivity | Identifiers are **not** case sensitive. String comparisons with `=`, `<>`, etc. **are** case sensitive. |
| Characters | 7-bit ASCII only (no Unicode/extended chars in names or string literals). |
| String literals | Max **128 characters**; embed `"` as `""`. |
| Types | `Boolean, Byte, Short, Integer, Single, Double, String` + classes. **No** `Long/Int64, Decimal, Int16, Int32, Char, Variant, Date, Object` (as a declared type). |
| Type suffixes | **Not supported** (`725L`, `Dim x!` are invalid). |
| Typing | Strong typing always; every variable must be declared. No `Option Strict/Explicit/Base/Compare`. |
| `Dim` type | A type must be given: `Dim x` alone is invalid. |
| `Dim a, b As Integer` | **Both** a and b are Integer (type applies to preceding untyped names). |
| Declarations location | Local variables may only be declared at the **outermost level** of a procedure (not inside `For`, `If`, `While`, etc.). Scope = whole procedure; forward references allowed. |
| Arrays | Always 0-based; `Dim a(9)` = 10 elements; max rank 4. **No array initializer** (`= {…}`). |
| Late binding | Not supported. Every object variable must have an explicit class. |
| Procedure calls | Parentheses **always required** around arguments of user `Sub`/`Function` calls; use `()` when there are no args. `Call` is optional. |
| Optional args | **User procedures cannot** have `Optional` params, default values, or `ParamArray`. (Many *built-in* methods do have optional params.) |
| Not supported | `GoSub`, `Static Sub/Function`, conditional compilation (`#If`), `Friend`/`Protected`, passing a `Get/Set` Property ByRef. Inheritance is not documented — do not use `Inherits`. |
| `Select` | Written `Select expr` … `End Select` (documented form has no `Case` after `Select`). `Case` accepts comma-separated **expressions only** (no `Is >`, no `x To y` ranges). |
| Exceptions | `Catch` **must** name an exception object, which should be pre-allocated with `New`. No typed `Catch ex As …` filters, no `When`. |
| Lines starting with `#` | Ignored (use for `#Region` / `#End Region`). |
| `&` operator gotcha | `&H…` is hex and `&O…` is octal. Always put a **space after `&`** when concatenating (`s & HEAD`, not `s &HEAD`). |
| Integer division result | `/` always yields a real result, even for integers. Use `\` for integer division. |
| Assignment to integer | Real results are **rounded** when stored into integer variables (7.875 → 8). |

---

## 2. Projects, files, and execution

- The executable unit is a **Project** = a folder (folder name = project name), e.g. `/flash/projects/MyProject/`.
- `Project.gpr` — **required** project file; lists the files and the **start procedure** (which must be `Public`).
- `*.gpl` — source files; each contains one or more `Module`s (only Modules — and, per the dictionary, Classes — may appear at the top level of a file).
- `*.gpo` — optional file(s) containing a global module of taught `Location` and `Profile` objects shared by the project.
- Workflow: **Load → Compile → Start** (console commands, GDE, or `Controller.Load(path)` / `Controller.Unload(name)`).
- Multiple projects can be loaded; up to **32 user threads** can run simultaneously.
- A PC (GDE – Guidance Development Environment) is needed to develop/debug, not to run.

---

## 3. Lexical structure

```vb
Label: Statement            ' Comment
100: x = x + 1              ' numeric labels are allowed
#Region "Motion helpers"    ' lines starting with # are ignored
#End Region
```

- Labels: a valid identifier or integer literal, followed by `:`; may be alone on a line.
- Identifiers: start with a letter or `_`, up to 128 chars total (letters, digits, `_`). A name starting with `_` must contain another non-underscore character. Names cannot match keywords, and within a context must be unique even across types.
- Comments: `'` to end of line.
- Numeric literals: decimal, `&H1F` (hex), `&O17` (octal).
- Boolean: `True` (−1, any non-zero is true), `False` (0).

---

## 4. Data types, constants, conversions

### 4.1 Types
| Type | Description |
|---|---|
| `Boolean` | True (≠0) / False (0) |
| `Byte` | unsigned 8-bit (0–255) |
| `Short` | signed 16-bit |
| `Integer` | signed 32-bit |
| `Single` | 32-bit float |
| `Double` | 64-bit float (**fastest**: all arithmetic is done in Double internally) |
| `String` | arbitrary length (optimized for ≤128 chars); storage auto-allocated — **never** use `New` with String |
| Class types | `Location`, `Profile`, `RefFrame`, `Exception`, `Thread`, user classes, etc. |

Automatic conversion happens between numeric types, and a String is auto-converted to Double where a number is expected (`2.34 + "1.01"` = 3.35) — prefer explicit conversions.

### 4.2 Conversion & numeric functions
`CBool(x)`, `CByte(x)`, `CShort(x)`, `CInt(x)`, `CSng(x)`, `CDbl(x)` (numeric or String → type), `CStr(x)` (numeric → String), `Hex(x)` (Integer → hex String), `Fix(x)` (truncate toward 0), `Int(x)` (truncate toward −∞), `Rnd(seed)` (pseudo-random).

### 4.3 Predefined constants
| Constant | Value / meaning |
|---|---|
| `GPL_CR` | 13 (carriage return) |
| `GPL_LF` | 10 (line feed) |
| `GPL_Righty` | &H01 right-shoulder config |
| `GPL_Lefty` | &H02 left-shoulder config |
| `GPL_Above` | &H04 elbow above wrist |
| `GPL_Below` | &H08 elbow below wrist |
| `GPL_Flip` | &H10 wrist pitched up |
| `GPL_NoFlip` | &H20 wrist pitched down |
| `GPL_Single` | &H1000 limit wrist to ±180° |

Use with `Chr(GPL_CR)` for strings and `loc.Config = GPL_Righty + GPL_Single` for configurations.

---

## 5. Declarations and scope

### 5.1 Forms
```vb
[Public | Private | Shared] Dim name[, name…] As [New] type [= [New] init]
Public name As type            ' Dim may be omitted when Public/Private is present
Private name As type
Static name As type            ' inside a procedure: value persists between calls
[Public | Private] Const NAME As type = constant_expr
```

Examples:
```vb
Dim ii As Short
Static jj As Short
Dim n As Integer, x As Double
Dim ii, jj As Integer              ' both Integer
Dim Count As Integer = 1           ' re-initialized every time the statement runs
Dim name As String = "Charlie"
Dim Loc1 As New Location           ' allocate object
Dim Loc2 As Location = New Location
Const MaxCount As Integer = 10
```

Rules:
- With an initializer or `New` clause, only **one** variable name may precede `As`.
- `New` may appear after `As` **or** after `=`, not both.
- `Public`/`Private` not allowed inside procedures; `Shared` not allowed at module level (module variables are implicitly shared).
- Local `Dim` variables are reset to 0 / False / Nothing / "" on every procedure entry.
- `Const` types: primitive or String; init must be a constant expression (constants, other Consts, built-in functions).

### 5.2 Scope
- Procedure-level: visible within the procedure only.
- Module-level `Dim`/`Private`: visible to all procedures in that module; value persists.
- Module-level `Public`: visible to all modules in all loaded projects. Access as `ModuleName.var`; the module prefix may be omitted only if the name is unambiguous.
- Nested/class members need the full path: `MyMod.My_class.MaxSize`.
- Module-level variables are initialized once at project start, in source order (errors appear under a hidden procedure `_Init`).
- A user `Sub Init` inside a module runs automatically during module initialization, before the start procedure.
- Never define procedures named `_Init` or `_New` (reserved/internal).

---

## 6. Arrays

```vb
Dim Count(9) As Integer          ' 10 elements, 0..9
Dim M(3, 4) As Integer           ' 4 x 5
Dim D(,) As Integer              ' rank 2, not allocated
ReDim D(1, 100)                  ' allocate/resize (cannot change rank, cannot declare)
ReDim Preserve Count(19)         ' keep data; only last dimension may change
Dim A(9) As Integer, B() As Integer
B = A                            ' reference copy: B and A share data
```

Array members (whole arrays only): `arr.GetUpperBound(dim)` (dim 0..rank−1), `arr.Length` (total elements), `arr.Rank`.
Note: `sarr.Length` = element count; `sarr(0).Length` = string length.
Passing a whole array ByVal/ByRef behaves like objects (pointer to data / pointer to variable).
**Do not ReDim an array while other threads use it** (can crash the controller).

---

## 7. Operators (highest → lowest precedence)

| Operator | Notes |
|---|---|
| `^` | exponent (negative base requires integer power) |
| unary `-` | `2 * -4` is valid |
| `*`, `/` | `/` always returns real |
| `\` | integer division (truncates): `2.3 \ 2` = 1 |
| `Mod` | remainder, works on reals: `13.3 Mod 2` = 1.3 |
| `+`, `-` | |
| `&` (or `+`) | string concatenation — **prefer `&`** |
| `<<`, `>>` | arithmetic shifts |
| `=`, `<>`, `<`, `>`, `<=`, `>=`, `Is` | `Is` compares object references: `obj Is Nothing` |
| `Not` | logical/bitwise |
| `And`, `AndAlso` | `And` evaluates both sides (bitwise if non-Boolean); `AndAlso` short-circuits |
| `Or`, `OrElse` | `OrElse` short-circuits |
| `Xor` | |

Compound assignment: `^= *= /= \= += -= <<= >>= &=` (e.g. `s &= " more"` is faster than `s = s & " more"`).
Negating object test: `If Not obj Is Nothing Then`.

---

## 8. Math

Methods of the global `Math` class:
`Math.Abs, Acos, Asin, Atan, Atan2(sine_factor, cosine_factor), Ceiling, Cos, Cosh, E, Exp, Floor, Log (ln), Log10, Max(a,b), Min(a,b), PI, Pow(base,exp), Sign, Sin, Sinh, Sqrt, Tan, Tanh`.

**Trig functions use radians**, while Location angles (Yaw/Pitch/Roll, joint angles) are in **degrees**. Convert explicitly: `Math.Sin(deg * Math.PI / 180)`, `deg = Math.Atan2(s, c) * 180 / Math.PI`.

Also built in (not in Math): `Fix(x)`, `Int(x)`, `Rnd(seed)`.

---

## 9. Strings

### 9.1 String members (0-based positions)
| Member | Syntax / notes |
|---|---|
| `String.Compare(a, b, ignore_case)` | shared method; `ignore_case` optional |
| `s.IndexOf(sub, start)` | returns 0-based position; `start` optional |
| `s.Length` | property |
| `s.Split(sep)` | first char of `sep` is the separator; returns String array |
| `s.Substring(first, length)` | 0-based; `length` optional |
| `s.ToLower`, `s.ToUpper` | |
| `s.Trim(chars)`, `s.TrimEnd(chars)`, `s.TrimStart(chars)` | `chars` optional (default whitespace) |

### 9.2 Legacy functions (1-based positions)
`Asc(s)`, `Chr(code 0–255)`, `Len(s)`, `LCase(s)`, `UCase(s)`, `Mid(s, first, length)` (1-based), `Instr(start, target, search)` (1-based), `Format(value, fmt)`, `ToBitString(value, type, big_endian)`, `FromBitString(str, type, big_endian)` (`type` is a keyword: `Byte, Short, Integer, Single, Double`).

`Format` specs: `"G"` general (default), `"F"` fixed (2 decimals), `"E"` scientific, or custom like `"0.00#"`.

```vb
Dim s1, s2 As String
s1 = "Joe's"
s2 = s1 & " balance: " & CStr(10.2)
msg = "Test" & Chr(GPL_CR) & Chr(GPL_LF)
```

---

## 10. Control structures

```vb
GoTo label

If cond Then
    ...
ElseIf cond2 Then
    ...
Else
    ...
End If
If cond Then statement               ' single-line form

For i = start To finish [Step inc]   ' Step optional (default 1), can be negative
    ...                              ' Exit For
Next i                               ' bounds evaluated once at loop start

While cond
    ...                              ' Exit While
End While

Do While cond | Do Until cond
    ...                              ' Exit Do
Loop
Do
    ...
Loop While cond | Loop Until cond

Select match_value                   ' numeric or String
    Case 1, 3, 5, 7
        ...
    Case "red", color2, "blue" & "green"
        ...                          ' Exit Select
    Case Else                        ' must be last
        ...
End Select
```

- Conditions: any numeric expression; non-zero = True.
- `For` variable: any numeric variable, array element, or object/structure *field* — **not** an object property.
- String `Case` matching is case sensitive.
- Exit statements: `Exit Do | For | Function | Property | Select | Sub | Try | While`.
- `End` statements: `End Class | Function | Get | If | Module | Property | Select | Set | Sub | While | Try`.

---

## 11. Procedures, modules, classes, delegates

### 11.1 Sub / Function
```vb
[Public | Private | Shared] Sub Name([ByVal | ByRef] p As type, ...)
    ...
End Sub

[Public | Private | Shared] Function Name([ByVal | ByRef] p As type, ...) As type
    Return value            ' or:  Name = value : Exit Function (on separate lines)
End Function
```
- Default passing is **ByVal**. ByRef arguments must be variables.
- Objects are always pointers: ByVal lets the callee modify the object's contents but not rebind the caller's variable; ByRef lets it rebind the caller's variable too.
- Procedures cannot be nested; must be inside a Module or Class.
- Default visibility is `Private`; `Shared` only inside classes.
- Returning: `End Sub/Function`, `Exit Sub/Function`, or `Return [value]` (value required in Function, forbidden in Sub). If the top-level procedure exits, its thread ends.

Calling:
```vb
Call MyProcedure(1, 2, 3)
MyProcedure(1, 2, 3)
x = 2 * MyFunction(y)
MyFunction(y)              ' result discarded
DoWork()                   ' empty parens for no-arg user procedures
```

### 11.2 Modules
```vb
Module Test
    Dim Count As Integer            ' private to module
    Private nBlocks As Integer      ' same
    Public TotalArea As Single      ' global

    Public Sub Main()
        ...
    End Sub
End Module
```
Modules are top-level only (not nested). Items default to `Private`. Access public items as `Module.item`.

### 11.3 User-defined classes
```vb
Public Class cc
    Public count As Integer                   ' per-object field
    Public Shared MaxSize As Integer          ' one copy for the class
    Private size_in As Integer

    Public Sub New()                          ' constructor (overloads allowed)
        count = 25
    End Sub
    Public Sub New(value As Integer)
        count = value
    End Sub

    Public Sub Increment()
        count = count + 1                     ' implicit current object (Me)
    End Sub

    Public Property Size As Integer           ' [ReadOnly | WriteOnly] allowed
        Get
            Return size_in
        End Get
        Set (value As Integer)                ' parameter type must equal property type
            If value > 10 Then
                value = 10
            ElseIf value < 0 Then
                value = 0
            End If
            size_in = value
        End Set
    End Property
End Class

' usage
Dim aa As New cc
Dim bb As New cc(15)
aa.Increment()
aa.Size = 20
```
- Classes may be declared at file top level, in a Module, or nested in another Class. Default `Private`.
- `Me` refers to the current object (error in Shared procedures).
- Shared procedures: `ClassName.Proc()`; cannot touch instance fields without an explicit object.
- Properties may take parameters; they can only be declared inside classes.
- No late binding; no declared `Object` type.

### 11.4 Objects: allocation, copying, Nothing
```vb
Dim a As Location            ' pointer = Nothing; using a member now → error
a = New Location             ' allocate
b = a                        ' copies POINTER (shared data)
c = a.Clone                  ' independent copy (many classes have Clone)
a = Nothing                  ' release
If a Is Nothing Then ...
```
Memory is managed automatically (no leaks); when unsure, allocate with `New`.

### 11.5 Delegates
```vb
Delegate Function My_template(ByVal arg1 As Integer) As String
Delegate Sub My_sub_template(ByVal x As Double)

Dim del_obj(1) As My_template
del_obj(0) = New My_template(AddressOf f0)
del_obj(1) = New My_template("f1")                    ' by name, resolved at runtime
Dim d As My_template = New My_template(AddressOf my_obj.My_fn) ' bound to an object
str = del_obj(index)(3)                                ' call through delegate
```
- Signature must match exactly. Not allowed for Property procedures.
- String form must be a module-level public procedure or top-level class public shared procedure: `"proc"`, `"module.proc"`, or `"class.proc"`. `AddressOf` is faster; String is more flexible.

---

## 12. Exception handling

```vb
Dim exc As New Exception        ' must be allocated before Catch

Try
retry:
    Move.Loc(loc1, profile1)
    Move.WaitForEOM
Catch exc
    If exc.ErrorCode = -153 Then
        profile1.Speed *= 0.9
        GoTo retry              ' legal: Catch → same Try block
    End If
    Controller.SystemMessage(exc.Message)
    Throw exc                   ' re-raise to outer handler
Finally
    ' always runs
End Try
```
Rules:
- A `Try` needs one `Catch`, one `Finally`, or one of each.
- Try blocks nest; exceptions propagate up through procedure calls to the nearest enclosing `Try…Catch`. A `Finally`-only Try runs its Finally before propagating.
- `GoTo` may jump from `Catch` into its `Try` block, or within the same block; no other jumps into/out of Try/Catch/Finally.
- `Exit Try` in Try/Catch jumps to Finally; not allowed inside Finally.
- `Throw exception_object` raises an exception anytime.
- If "Break on exception" (DataID 307 or GDE option) is on, Try/Catch is ignored (debug aid).

Exception object members: `ErrorCode` (get/set, negative codes), `Message` (text), `Qualifier` (general exceptions), `RobotError` (Boolean), `RobotNum`, `Axis` (bit mask, robot exceptions), `Clone`, `UpdateErrorCode` (replace vague codes −1029/−1030/−1043 with specific ones).

Creating a custom exception:
```vb
Dim exc As New Exception
exc.ErrorCode = -799
Throw exc
```

---

## 13. Motion control

Basic pick-and-place needs only **Signal, Location, Profile, Move**. Advanced: **RefFrame, Robot, Controller, Latch**.
Units: **mm** and **degrees**. Axes are numbered from **1**; array-based axis data starts at element **0** (element 0 = axis 1).

### 13.1 Motion preconditions (must hold before any `Move.*`)
1. High power enabled — `Controller.PowerEnabled = True` (not allowed by software on CAT-3 safety systems; operator presses the hardware button).
2. Motors commutated (automatic during power enable / homing).
3. Robot homed after each controller restart — `Robot.Home` (attached robot) or `Robot.HomeAll`.
4. Thread has attached the robot — `Robot.Attached = 1` (release with `Robot.Attached = 0`).

### 13.2 Signal class (global) — digital & analog I/O
```vb
Dim s As Boolean
s = Signal.DIO(10001)            ' read first general input
Signal.DIO(1) = True             ' set first general output
mask = Signal.DIO(10001, 8)      ' 8 channels as bit mask (bit0 = first channel)
v = Signal.AIO(10001)            ' first analog input (scaled float)
Signal.AIO(1) = 0.5              ' first analog output
```
DIO numbering (`bank` 0 = local, 1–15 = remote RIO/Modbus modules, 96 points/bank):
| Signal type | Numbers |
|---|---|
| Test channel | 0 (always reads False) |
| General outputs | 1 + 100·bank … 96 + 100·bank |
| Dedicated outputs | 8001 + 100·bank … |
| General inputs | 10001 + 100·bank … 10096 + 100·bank |
| Dedicated inputs | 18001 + 100·bank … |
| Software I/O | 20001 – 20064 |
| Servo-network slave node n | add 100000·n |

A **negative** channel number means active-low (True when level is low). Only outputs can be written. `count` 1–32 returns a bit mask (not the same as omitting `count`).
AIO: outputs 1–10000, inputs 10001–20000; values scaled (often ±1.0 or ±100).

### 13.3 Location class
Two kinds (`loc.Type`): **0 = Cartesian** (X, Y, Z mm + Yaw, Pitch, Roll deg; default for `New Location`), **1 = Angles** (joint positions).
- Euler convention: rotate about Z (Yaw), then new Y (Pitch), then new Z (Roll).
- "Total position" (`Pos`) = `PosWrtRef` combined with its reference frame(s); `PosWrtRef` = value relative to its `RefFrame` (Cartesian only).

| Member | Kind | Notes |
|---|---|---|
| `loc.XYZ(x, y, z, yaw, pitch, roll)` | method | sets PosWrtRef; all args optional (default 0); sets Type = Cartesian |
| `loc.XYZInc(dx, dy, dz)` | method | increment PosWrtRef |
| `Location.XYZValue(x, y, z, yaw, pitch, roll)` | shared method | returns a new Cartesian Location |
| `loc.X / .Y / .Z / .Yaw / .Pitch / .Roll` | property | PosWrtRef components |
| `loc.Angles(a1, …, a12)` | method | sets joint values; sets Type = Angles |
| `loc.Angle(axis)` | property | one joint (axis 1–12) |
| `loc.Pos` / `loc.PosWrtRef` | property | total / relative position |
| `loc.RefFrame` | property | reference frame object |
| `loc.Config` | property | configuration bit flags (`GPL_Righty` etc.) |
| `loc.ZClearance` | property | approach distance (mm) used by `Move.Approach` |
| `loc.ZWorld` | property | True = clearance is absolute world Z; False = along tool −Z |
| `loc.Here` | method | record current position of the **Selected** robot (preserves ZClearance/ZWorld/RefFrame — preferred over `loc = Robot.Where`) |
| `loc.Here3(loc0, locx, locy)` | method | define frame from origin + X-axis point + Y-direction point |
| `loc.Inverse` | method | inverse transform |
| `loc.Mul(loc2)` | method | compose: loc2 expressed in loc's frame |
| `Location.Distance(l1, l2)` | shared | XYZ distance |
| `loc.KineSol(mode, loc)` | method | Cartesian ↔ Angles via kinematics |
| `loc.Normalize` | method | fix numeric inconsistencies |
| `loc.ConveyorLimit(mode)` | method | distance to conveyor limits |
| `loc.Clone`, `loc.Text` | | copy; free-use string |

```vb
Dim a As New Location, b As New Location
Dim c As Location
a.XYZ(10, 25, -40, 0, 0, 90)
b.XYZ(0, 5, 0)
c = a.Mul(b)                       ' c = (5, 25, -40, 0, 0, 90)
x = loc.Inverse.X                  ' dot operator can be chained
```

### 13.4 Profile class — motion parameters
`Dim p As New Profile` loads defaults from the configuration database.

| Property | Meaning |
|---|---|
| `Speed` | peak speed, % of nominal (1 … robot max; 100 = rated) |
| `Speed2` | secondary speed % for selected axes during Cartesian moves |
| `Accel`, `Decel` | % of nominal |
| `AccelRamp`, `DecelRamp` | S-curve ramp time (s) |
| `Straight` | True = Cartesian straight line; False (default) = joint interpolated |
| `InRange` | `<0` don't stop, blend with next motion (continuous path); `0` stop, no position check; small `>0` loose; `100` (default) tightest |
| `Text`, `Clone` | |

### 13.5 Move class (global)
| Method | Purpose |
|---|---|
| `Move.Loc(loc, prof)` | move to total position of `loc` |
| `Move.Approach(loc, prof)` | move to clearance position of `loc` (uses ZClearance/ZWorld) |
| `Move.Rel(loc, prof)` | move relative to actual end of previous motion (Cartesian increments are in **tool** coordinates) |
| `Move.OneAxis(axis, pos, relative_flag, prof)` | single axis; can move out-of-range axes back in range |
| `Move.Arc(loc1, loc2, prof)` / `Move.Circle(loc1, loc2, prof)` | circular path through 3 points (current + 2) |
| `Move.Delay(seconds)` | pause motion queue |
| `Move.WaitForEOM` | block thread until motion completes |
| `Move.Extra(p1, p2, p3, p4)` | extra independent axes for next Cartesian move |
| `Move.ForceOverlap(mode, criterion)` | mode 0 = % time overlap; mode 1 = max corner-rounding distance |
| `Move.Trigger(mode, pt, channel)` / `Move.Trigger(mode, pt, thread_obj, event_mask)` | set DOUT or thread event at a point of the motion (mode 0: % from start, 1: % from end, …); channel <0 turns OFF, 0 disables |
| `Move.StartJogMode()`, `Move.SetJogCommand(mode, axis, speed%)` | jog/manual |
| `Move.StartVelocityCntrl(mode, adc_mask, speeds(), prof)`, `Move.SetSpeeds(speeds(), prof)` | velocity mode |
| `Move.StartTorqueCntrl(motor_mask, adc_mask, torques())`, `Move.SetTorques(torques())` | torque mode (%) |
| `Move.StartRealTimeMod(coords, change_type)`, `Move.SetRealTimeMod(changes(6))` | real-time path modification (license) |
| `Move.StartSpeedDAC(mode, n_segments, speeds(), dacs())` | analog out proportional to tool speed (license) |
| `Move.StopSpecialModes` | exit any special mode (rapid decel) |

Execution semantics: a `Move.*` call **queues** a motion and returns once it starts (or blends); if a previous motion is still running, the thread blocks until it can start. Use `Move.WaitForEOM` before acting on I/O (e.g. gripper) that requires the robot to be stopped.

### 13.6 RefFrame class — reference frames
```vb
Dim tray_ref As New RefFrame        ' Type 0 = basic; .Loc allocated automatically
Dim part1 As New Location
part1.RefFrame = tray_ref
tray_ref.Loc.XYZ(10, 20, 30, 0, 180, 20)
```
| Member | Notes |
|---|---|
| `Type` | 0 basic, 1 pallet, 2 conveyor (license) |
| `Loc` | frame's Location; `Loc.RefFrame` chains to a parent frame |
| `Pos()`, `PosWrtRef()` | methods returning total / relative Cartesian location |
| `Text` | free-use |
| Pallet (Type 1): `PalletPitch(i)`, `PalletMaxIndex(i)`, `PalletIndex(i)` (i: 1 row, 2 col, 3 layer; indices are 1-based), `PalletOrder` (0 R-C-L, 1 R-L-C, 2 C-R-L, 3 C-L-R, 4 L-R-C, 5 L-C-R), `PalletNextPos`, `PalletRowColLay(r, c, l)`. Wraps after last element. Loc XYZ = first element; Loc axes = row/col/layer directions. |
| Conveyor (Type 2): `ConveyorRobot`, `ConveyorOffset` | X axis = belt direction |

```vb
Dim ref1 As New RefFrame
Dim loc1 As New Location
ref1.Type = 1
ref1.Loc.XYZ(100, 50, -80, 0, 0, 0)
ref1.PalletPitch(1) = 10
ref1.PalletPitch(2) = 20
ref1.PalletMaxIndex(1) = 3
ref1.PalletMaxIndex(2) = 3
loc1.RefFrame = ref1
ref1.PalletRowColLay(1, 1, 1)
ref1.PalletNextPos
```

### 13.7 Robot class (global)
`robot` args are optional; 0/omitted = Selected robot (1..N).

| Member | Notes |
|---|---|
| `Robot.Attached` | get/set; `= n` takes exclusive control, `= 0` releases; also sets `Selected` |
| `Robot.Selected` | default robot for read-only ops and `loc.Here` |
| `Robot.Home`, `Robot.HomeAll` | homing (power on; HomeAll: no robot attached by another thread) |
| `Robot.Where(robot)` / `Robot.WhereAngles(robot)` | current Cartesian / joint location |
| `Robot.Dest`, `DestAngles`, `Source`, `SourceAngles` | planned end / start of last motion |
| `Robot.SpeedAngles(robot)` | instantaneous axis speeds |
| `Robot.Tool = loc` / `Robot.Tool(robot)` | tool offset (e.g. `tool.XYZ(0,0,100)`) |
| `Robot.Base = loc` / `Robot.Base(robot)` | base offset |
| `Robot.RestartTool`, `RestartBase` | offsets set at restart |
| `Robot.Payload = pct` | payload % of max (for dynamic feedforward) |
| `Robot.RapidDecel(robot)` | rapid stop of current motion |
| `Robot.TrajState(robot, mode)`, `Robot.CartMode(robot)`, `Robot.LastProfile(robot)` | status |
| `Robot.JointToMotor(robot, joints(), motors())`, `Robot.MotorToJoint(robot, motors(), joints())` | conversions |
| `Robot.MotorTempStatus(robot, motor)`, `Robot.Custom(robot, index)`, `Robot.DefLinComp(...)`, `Robot.RealTimeModAcm(robot)` | advanced |

Other threads can still read robot state, disable power, E-stop, or `RapidDecel` an attached robot.

### 13.8 Controller class (global)
| Member | Notes |
|---|---|
| `Controller.PowerEnabled = True/False` / `Controller.PowerEnabled(timeout) = True` | request motor power; read to test |
| `Controller.PowerState(mode)` | power sequence state |
| `Controller.SoftEStop = True` | trigger soft E-stop |
| `Controller.SystemSpeed = pct` | global speed scaling |
| `Controller.SystemMessage(msg)` | message to web Operator Control Panel log (**use for operator messages**) |
| `Controller.ShowDialog("Yes,No", msg, button_index)` (+ `text_field`; advanced mode with `mode`, field labels/values) | pop-up on web panel, up to 4 buttons |
| `Controller.ShowDialogMCP(button_mask, msg, button_return[, text_field])` | pendant dialog |
| `Controller.RecordButton` | latched MCP RECORD button |
| `Controller.PDb(dataid, unit, unit2, index)` / `Controller.PDbNum(...)` | read/write parameter database (strings / numbers) |
| `Controller.Command(cmd)` | run console command, returns output String |
| `Controller.ErrorLog(n)` | nth most recent error log entry |
| `Controller.Load(path)` / `Controller.Unload(name)` | project management |
| `Controller.Timer(select)` | seconds (125 µs resolution), Double |
| `Controller.Tick` | trajectory generator period (s) |
| `Controller.SleepTick(ticks)` | delay N trajectory periods |

### 13.9 Latch class
Shared: `Latch.Count(robot)`, `Latch.Flush(robot)`, `Latch.Result(robot, no_exception)` (returns Latch object or Nothing), `Latch.ThreadEvent(robot) = mask`.
Object: `lat.Location(type)`, `lat.Angle(axis)`, `lat.Signal`, `lat.Timestamp(select)`, `lat.ErrorCode`.

---

## 14. Threads

Up to 32 user threads; preemptive, round-robin (1 ms slices; system tick 125 µs).

```vb
Dim t As New Thread("Worker")          ' procedure name as String (must be Public; class procs: Public Shared, "Class.Proc")
t.Argument = 5                         ' numeric parameter for the thread
t.Start()
t.SendEvent(&H0001)                    ' event 1
ok = t.Join(1000)                      ' wait ≤1000 ms; -1 = forever; returns True if idle
```
Constructor: `New Thread(procedure_name, project_name, thread_name, stack_size_kb)` (only first required).

| Member | Notes |
|---|---|
| `Start()`, `Abort()`, `Suspend()`, `Resume()`, `Join(ms)` | control |
| `Argument`, `Name`, `Project`, `StartProcedure`, `ThreadState` | ThreadState: −1 none, 0 idle/done, 1 stopping, 2 running, 3 paused, 4 paused with error |
| `SendEvent(mask)` | events 1–16 = bits 0–15 (`&HFFFF` max) |
| `Thread.WaitEvent(mask, timeout_ms)` | wait/clear events; returns received mask; mask 0 = poll |
| `Thread.Sleep(ms)` | 0 = yield; <0 = suspend forever |
| `Thread.CurrentThread()` | current thread object |
| `Thread.Schedule(priority 0–16, period, high_priority_time, phase)` | sporadic high-priority scheduling |
| `Thread.TestAndSet(var, new)` | atomic read-then-write; returns old value |

Thread safety:
- Safe: reading/writing single numeric/Boolean values; simple String assignment.
- **Unsafe**: read-modify-write (`a = a + 1`), multi-field objects/arrays as a group, String methods that modify, dynamic arrays (ReDim).
- Interlock with a semaphore:
```vb
Public Sub acquire_sem(ByRef sem_var As Integer)
    While Thread.TestAndSet(sem_var, 1) <> 0
        Thread.Sleep(0)
    End While
End Sub
Public Sub release_sem(ByRef sem_var As Integer)
    sem_var = 0
End Sub
```

---

## 15. Console, files, serial, NVRAM

### 15.1 Console (debug only)
`Console.Write(value)`, `Console.WriteLine(value)` — one number or String per call; combine with `CStr`. Destination depends on how the thread was started (GDE output window or `/dev/com1`). Use `Controller.SystemMessage` for operator messages.

### 15.2 File class (shared methods)
`File.Copy(src, dst, overwrite)`, `File.CreateDirectory(path)`, `File.DeleteDirectory(path)` (must be empty), `File.DeleteFile(path)`, `File.GetDirectories(path)` / `File.GetFiles(path)` (String arrays), `File.Length(path)`, `File.ComputeLength(path)`, `File.ComputeCRC(path)`.

Devices: `/flash` (permanent, slow to write; wait ≥15 s after writing before power-off; `/flash2`…`/flash8` sub-partitions), `/ROMDISK` (RAM, lost on restart), `/NVRAM` (small, power-fail safe), `/GPL`. File names 1–43 chars, **case sensitive**.

### 15.3 Streams
| StreamReader | StreamWriter |
|---|---|
| `New StreamReader(path)` | `New StreamWriter(path[, append])` |
| `Read()` (byte, <0 at end), `ReadLine()`, `Peek()` (<0 = none/EOF), `Close` | `Write(v)`, `WriteLine(v)`, `Flush`, `AutoFlush`, `NewLine` (default CR-LF), `Close` |

```vb
Public Sub file_write_read()
    Dim o As New StreamWriter("/ROMDISK/filetest")
    Dim i As StreamReader
    Dim line As String
    Dim ii As Integer
    For ii = 1 To 10
        o.WriteLine("Line " & CStr(ii))
    Next ii
    o.Close()
    i = New StreamReader("/ROMDISK/filetest")
    While i.Peek() >= 0
        line = i.ReadLine()
        Console.WriteLine(line)
    End While
    i.Close()
End Sub
```

### 15.4 Serial ports
Same Stream classes on `/dev/com1` … `/dev/com4`, remote `/dev/comrXY`. Open both a reader and writer on the same port. Serial output defaults to AutoFlush True. Opening `/dev/com1` disables the serial console (DataID 125). Poll with `Peek()` + `Thread.Sleep()` to avoid blocking.

### 15.5 NVRAM
Files `/NVRAM/file1` … `file16`; create with `"-size n"` (default 1024) and optional `"-wrap"` (circular):
```vb
Dim tfile As New StreamWriter("/NVRAM/file3 -size 64 -wrap", True)
```
Records ≤255 bytes, written atomically. Also 8 NV 32-bit integers via DataID 1892 (`Controller.PDbNum`).

---

## 16. Networking (TCP/UDP)

| Class | Key members |
|---|---|
| `New IPEndPoint(ip_string, port)` | both optional; `""` = any IP; `.IPAddress`, `.Port` |
| `New TcpListener(ep)` | `.Start()`, `.Pending`, `.AcceptSocket()` → Socket, `.Stop()` / `.Close()` |
| `New TcpClient([ep])` | `.Client` → Socket, `.Close()` |
| `New UdpClient([ep])` | `.Client` → Socket, `.Close()` |
| `Socket` (never `New`) | `Send(buf[, max_len])`, `Receive(buf, max_len)` → byte count (0 = closed), `SendTo(buf, max_len, ep)`, `ReceiveFrom(buf, max_len, ByRef ep)`, `Connect(ep)`, `Close`, `Available`, `Blocking`, `KeepAlive`, `ReceiveTimeout`, `SendTimeout` (ms), `RemoteEndPoint` |

```vb
Public Sub Tcp_client()
    Dim ep As New IPEndPoint("192.168.0.2", 1234)
    Dim tc As New TcpClient(ep)
    Dim ts As Socket
    Dim reply As String
    ts = tc.Client
    ts.Send("Test message" & Chr(GPL_CR) & Chr(GPL_LF))
    ts.Receive(reply, 1000)
    Console.WriteLine("Reply: " & reply)
    ts.Close()
End Sub
```

TCP server pattern: `tl = New TcpListener(New IPEndPoint("", port))` → `tl.Start()` → `While Not tl.Pending() : Thread.Sleep(…)` → `ts = tl.AcceptSocket()` → loop `Receive/Send` → `ts.Close()`.

---

## 17. MODBUS/TCP (master)

```vb
Dim ep As New IPEndPoint("192.168.0.150")   ' port omitted = standard Modbus port
Dim mb As New Modbus(ep)
Dim bool() As Boolean
Dim regs() As Integer
mb.Timeout = 2000                            ' ms; default infinite
mb.ReadCoils(1, 16, bool)                    ' start, count, ByRef array (auto-sized)
mb.ReadDiscreteInputs(1, 16, bool)
mb.ReadHoldingRegisters(1, 2, regs)
mb.ReadInputRegisters(1, 2, regs)
mb.WriteSingleCoil(1, True)
mb.WriteSingleRegister(1, 600)
mb.WriteMultipleCoils(1, bool)
mb.WriteMultipleRegisters(1, regs)
s = mb.ReadDeviceId(object_id)
mb.Close()                                   ' at end of session, not after each request
```
Connection is made on first read/write; failure throws an exception.

---

## 18. Vision (PreciseVision)

Server IP = DataID 424; TCP port 1410; 30 s reply timeout.
- `Vision`: `New Vision`, `.Process(process_name[, id])`, `.ResultCount(tool_name)`, `.Result(tool_name, index[, loc])` → `VisResult`, `.Status` (0 none, 1 running, 2 error, 3 success), `.ErrorCode`, `.IPAddress`, `.Instance`, `.ToolProperty(name)`, `.Disconnect`.
- `VisResult`: `.Loc` (Cartesian Location), `.Info(n)`, `.InfoCount`, `.InfoString`, `.InspectPassed`, `.InspectActual`, `.ErrorCode`, `.ProcessID`, `.Type`.

```vb
Dim vis As New Vision
Dim vResult As New VisResult
Dim vsRefFrame As New RefFrame
vis.Process("Main")
If vis.ResultCount("part1") = 0 Then
    Console.WriteLine("Vision object not found")
    GoTo done
End If
vResult = vis.Result("part1", 1)
vsRefFrame.Loc.PosWrtRef = vResult.Loc
vsRelPoint.RefFrame = vsRefFrame
Move.Approach(vsRelPoint, vsProfile)
Move.Loc(vsRelPoint, vsProfile)
done:
vis.Disconnect
```

---

## 19. XML (DOM, libxml2-based)

- `XmlDoc`: `New XmlDoc(root_name)`, `XmlDoc.LoadFile(path, options)`, `XmlDoc.LoadString(s, options)`, `doc.SaveFile(path, options)`, `doc.SaveString(ByRef s, options)`, `doc.DocumentElement`, `doc.CreateNode(type, name)`, `doc.ErrorCode`, `doc.Message`, `XmlDoc.EncodeEntities(s)`, `XmlDoc.DecodeEntities(s)`.
- `XmlNode`: `AddAttribute(name, val)`, `AddElement(name, val)`, `AddElementNode(name[, val])` → node, `GetAttribute(name)`, `GetElement(name)`, `GetAttributeNode`, `GetElementNode`, `SetAttribute`, `SetElement`, `HasAttribute`, `HasElement`, `HasChildNodes`, `ChildNodeCount`, `FirstChild`, `LastChild`, `NextSibling`, `PreviousSibling`, `ParentNode`, `OwnerDocument`, `AppendChild`, `InsertBefore`, `InsertAfter`, `RemoveChild`, `RemoveElement`, `RemoveAttribute`, `ReplaceChild`, `Clone(deep, doc)`, `Name`, `Type` (String, e.g. `"element"`), `Value`.
- **Always check `doc.ErrorCode` after LoadFile/LoadString** (only severe errors throw). You must encode `" & ' < >` yourself with `EncodeEntities`. Error −801 = node no longer attached to a tree.

```vb
Public Sub XmlCreate(ByRef doc As XmlDoc)
    Dim root As XmlNode
    Dim elem As XmlNode
    doc = New XmlDoc("procedureControl")
    root = doc.DocumentElement
    root.AddAttribute("cellId", "TestCell")
    root.AddElement("command", "start")
    elem = root.AddElementNode("procedure")
    elem.AddAttribute("jobId", "090507001")
    elem.AddElement("type", "protocol")
End Sub
```

---

## 20. Complete example — pick and place skeleton

```vb
Module Main_Module
    Public safe As New Location
    Public pick As New Location
    Public place As New Location
    Public fast As New Profile
    Public slow As New Profile

    Public Sub Main()
        Dim exc As New Exception
        Try
            Init_Robot()
            Setup()
            While True
                Pick_And_Place()
            End While
        Catch exc
            Controller.SystemMessage("Error: " & exc.Message)
        Finally
            Robot.Attached = 0
        End Try
    End Sub

    Public Sub Init_Robot()
        Controller.PowerEnabled(30) = True    ' non-CAT-3 systems only
        Robot.Attached = 1
        Robot.Home
    End Sub

    Public Sub Setup()
        safe.XYZ(300, 0, 200, 0, 180, 0)
        pick.XYZ(350, 100, 20, 0, 180, 0)
        pick.ZClearance = 50
        place.XYZ(350, -100, 20, 0, 180, 0)
        place.ZClearance = 50
        fast.Speed = 80
        fast.InRange = -1                     ' blend via points
        slow.Speed = 20
        slow.Straight = True
        slow.InRange = 100                    ' stop precisely
    End Sub

    Public Sub Pick_And_Place()
        Move.Loc(safe, fast)
        Move.Approach(pick, fast)
        Move.Loc(pick, slow)
        Move.WaitForEOM
        Signal.DIO(1) = True                  ' close gripper (example output)
        Thread.Sleep(200)
        Move.Approach(pick, slow)
        Move.Approach(place, fast)
        Move.Loc(place, slow)
        Move.WaitForEOM
        Signal.DIO(1) = False                 ' open gripper
        Thread.Sleep(200)
        Move.Approach(place, slow)
    End Sub
End Module
```
(Signal numbers, locations, and speeds are placeholders — use the cell's actual I/O map and taught positions, typically stored in a `.gpo` file.)

---

## 21. Quick checklist before submitting GPL code

- [ ] One statement per line; ` _` for continuation; no `:` separators.
- [ ] Every variable declared with a type, at the outermost level of its procedure.
- [ ] No unsupported types (`Long`, `Object`, `Date`, `Char`, `Decimal`, `Variant`) or suffix characters.
- [ ] Objects allocated with `New` before use; `.Clone` when an independent copy is needed.
- [ ] Parentheses on all user procedure calls; no optional parameters in user procedures.
- [ ] `Select x` / `Case a, b` (no `Is`/`To` in Case).
- [ ] `Catch excObj` with `Dim excObj As New Exception`.
- [ ] Space after `&` when concatenating; string literals ≤128 chars, ASCII only.
- [ ] Motion: power on, homed, `Robot.Attached = n`; `Move.WaitForEOM` before I/O that needs a stopped robot; release with `Robot.Attached = 0`.
- [ ] Shared data between threads protected with `Thread.TestAndSet` locks; no ReDim on shared arrays.
- [ ] Start procedure and thread procedures declared `Public`.
