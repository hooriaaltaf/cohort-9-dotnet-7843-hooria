Ú
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Services\UserService.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
Services% -
{ 
public 

class 
UserService 
{ 
private 
readonly 
IUserRepository (
_userRepository) 8
;8 9
public

 
UserService

 
(

 
IUserRepository

 *
userRepository

+ 9
)

9 :
{ 	
_userRepository 
= 
userRepository ,
;, -
} 	
public 
async 
Task 
< 
List 
< 
UserDTO &
>& '
>' (
GetAllUsersAsync) 9
(9 :
): ;
{ 	
var 
users 
= 
await 
_userRepository -
.- .
GetAllAsync. 9
(9 :
): ;
;; <
return 
users 
. 
Select 
(  
u  !
=>" $
new% (
UserDTO) 0
{ 
Id 
= 
u 
. 
Id 
, 
Username 
= 
u 
. 
Username %
,% &
Email 
= 
u 
. 
Email 
,  
Role 
= 
u 
. 
Role 
. 
Name "
} 
) 
. 
ToList 
( 
) 
; 
} 	
public 
async 
Task 
< 
UserDTO !
>! "
GetUserByIdAsync# 3
(3 4
int4 7
userId8 >
)> ?
{ 	
var 
user 
= 
await 
_userRepository ,
., -
GetByIdAsync- 9
(9 :
userId: @
)@ A
;A B
if 
( 
user 
== 
null 
) 
{ 
throw   
new    
KeyNotFoundException   .
(  . /
$str  / @
)  @ A
;  A B
}!! 
return## 
new## 
UserDTO## 
{$$ 
Id%% 
=%% 
user%% 
.%% 
Id%% 
,%% 
Username&& 
=&& 
user&& 
.&&  
Username&&  (
,&&( )
Email'' 
='' 
user'' 
.'' 
Email'' "
,''" #
Role(( 
=(( 
user(( 
.(( 
Role((  
.((  !
Name((! %
})) 
;)) 
}** 	
}++ 
},, î´
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Services\TaskService.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
Services% -
{ 
public 

class 
TaskService 
{ 
private 
readonly 
ITaskRepository (
_taskRepository) 8
;8 9
private 
readonly 
IUserRepository (
_userRepository) 8
;8 9
private 
readonly 
ILogger  
<  !
TaskService! ,
>, -
_logger. 5
;5 6
public 
TaskService 
( 
ITaskRepository 
taskRepository *
,* +
IUserRepository 
userRepository *
,* +
ILogger 
< 
TaskService 
>  
logger! '
)' (
{ 	
_taskRepository 
= 
taskRepository ,
;, -
_userRepository 
= 
userRepository ,
;, -
_logger 
= 
logger 
; 
} 	
public 
async 
Task 
< 
List 
< 
TaskDTO &
>& '
>' ( 
GetTasksForUserAsync) =
(= >
int> A
currentUserIdB O
,O P
stringQ W
currentUserRoleX g
)g h
{   	
bool!! 
isAdmin!! 
=!! 
currentUserRole!! *
==!!+ -
$str!!. 5
;!!5 6
var"" 
tasks"" 
="" 
await"" 
_taskRepository"" -
.""- .
GetAllForUserAsync"". @
(""@ A
currentUserId""A N
,""N O
isAdmin""P W
)""W X
;""X Y
return## 
tasks## 
.## 
Select## 
(##  
MapToDto##  (
)##( )
.##) *
ToList##* 0
(##0 1
)##1 2
;##2 3
}$$ 	
public'' 
async'' 
Task'' 
<'' 
TaskDTO'' !
>''! "
GetTaskByIdAsync''# 3
(''3 4
int''4 7
taskId''8 >
,''> ?
int''@ C
currentUserId''D Q
,''Q R
string''S Y
currentUserRole''Z i
)''i j
{(( 	
var)) 
task)) 
=)) 
await)) 
_taskRepository)) ,
.)), -
GetByIdAsync))- 9
())9 :
taskId)): @
)))@ A
;))A B
if** 
(** 
task** 
==** 
null** 
)** 
{++ 
throw,, 
new,,  
KeyNotFoundException,, .
(,,. /
$str,,/ @
),,@ A
;,,A B
}-- 
bool// 
isAdmin// 
=// 
currentUserRole// *
==//+ -
$str//. 5
;//5 6
bool00 
isOwnerOrAssignee00 "
=00# $
task00% )
.00) *
CreatedByUserId00* 9
==00: <
currentUserId00= J
||00K M
task00N R
.00R S
AssignedToUserId00S c
==00d f
currentUserId00g t
;00t u
if22 
(22 
!22 
isAdmin22 
&&22 
!22 
isOwnerOrAssignee22 .
)22. /
{33 
throw44 
new44 $
ForbiddenAccessException44 2
(442 3
$str443 b
)44b c
;44c d
}55 
return77 
MapToDto77 
(77 
task77  
)77  !
;77! "
}88 	
public;; 
async;; 
Task;; 
<;; 
TaskDTO;; !
>;;! "
CreateTaskAsync;;# 2
(;;2 3
CreateTaskDTO;;3 @
dto;;A D
,;;D E
int;;F I
currentUserId;;J W
,;;W X
string;;Y _
currentUserRole;;` o
);;o p
{<< 	
if== 
(== 
!== 
Enum== 
.== 
	IsDefined== 
(==  
typeof==  &
(==& '
TaskPriority==' 3
)==3 4
,==4 5
dto==6 9
.==9 :
Priority==: B
!==B C
.==C D
Value==D I
)==I J
)==J K
{>> 
throw?? 
new?? %
InvalidOperationException?? 3
(??3 4
$str??4 M
)??M N
;??N O
}@@ 
boolBB 
isAdminBB 
=BB 
currentUserRoleBB *
==BB+ -
$strBB. 5
;BB5 6
intDD 
assignedToUserIdDD  
;DD  !
ifEE 
(EE 
isAdminEE 
&&EE 
dtoEE 
.EE 
AssignedToUserIdEE /
.EE/ 0
HasValueEE0 8
)EE8 9
{FF 
varGG 
assigneeGG 
=GG 
awaitGG $
_userRepositoryGG% 4
.GG4 5
GetByIdAsyncGG5 A
(GGA B
dtoGGB E
.GGE F
AssignedToUserIdGGF V
.GGV W
ValueGGW \
)GG\ ]
;GG] ^
ifHH 
(HH 
assigneeHH 
==HH 
nullHH  $
)HH$ %
{II 
throwJJ 
newJJ %
InvalidOperationExceptionJJ 7
(JJ7 8
$strJJ8 x
)JJx y
;JJy z
}KK 
assignedToUserIdLL  
=LL! "
dtoLL# &
.LL& '
AssignedToUserIdLL' 7
.LL7 8
ValueLL8 =
;LL= >
}MM 
elseNN 
{OO 
assignedToUserIdRR  
=RR! "
currentUserIdRR# 0
;RR0 1
}SS 
varUU 
taskUU 
=UU 
newUU 
TaskItemUU #
{VV 
TitleWW 
=WW 
dtoWW 
.WW 
TitleWW !
,WW! "
DescriptionXX 
=XX 
dtoXX !
.XX! "
DescriptionXX" -
,XX- .
StatusYY 
=YY 

WorkStatusYY #
.YY# $
PendingYY$ +
,YY+ ,
PriorityZZ 
=ZZ 
(ZZ 
TaskPriorityZZ (
)ZZ( )
dtoZZ) ,
.ZZ, -
PriorityZZ- 5
.ZZ5 6
ValueZZ6 ;
,ZZ; <

CategoryId[[ 
=[[ 
dto[[  
.[[  !

CategoryId[[! +
![[+ ,
.[[, -
Value[[- 2
,[[2 3
DueDate\\ 
=\\ 
dto\\ 
.\\ 
DueDate\\ %
!\\% &
.\\& '
Value\\' ,
,\\, -
AssignedToUserId]]  
=]]! "
assignedToUserId]]# 3
,]]3 4
CreatedByUserId^^ 
=^^  !
currentUserId^^" /
,^^/ 0
	CreatedAt__ 
=__ 
DateTime__ $
.__$ %
UtcNow__% +
,__+ ,
	UpdatedAt`` 
=`` 
DateTime`` $
.``$ %
UtcNow``% +
,``+ ,
	IsDeletedaa 
=aa 
falseaa !
}bb 
;bb 
awaitdd 
_taskRepositorydd !
.dd! "
AddAsyncdd" *
(dd* +
taskdd+ /
)dd/ 0
;dd0 1
awaitee 
_taskRepositoryee !
.ee! "
SaveChangesAsyncee" 2
(ee2 3
)ee3 4
;ee4 5
_loggergg 
.gg 
LogInformationgg "
(gg" #
$strgg# O
,ggO P
taskggQ U
.ggU V
IdggV X
,ggX Y
currentUserIdggZ g
)ggg h
;ggh i
varii 
createdTaskii 
=ii 
awaitii "
_taskRepositoryii# 2
.ii2 3
GetByIdAsyncii3 ?
(ii? @
taskii@ D
.iiD E
IdiiE G
)iiG H
;iiH I
ifjj 
(jj 
createdTaskjj 
isjj 
nulljj #
)jj# $
{kk 
throwll 
newll %
InvalidOperationExceptionll 3
(ll3 4
$strll4 W
)llW X
;llX Y
}mm 
returnoo 
MapToDtooo 
(oo 
createdTaskoo '
)oo' (
;oo( )
}pp 	
publicss 
asyncss 
Taskss 
<ss 
TaskDTOss !
>ss! "
UpdateTaskAsyncss# 2
(ss2 3
intss3 6
taskIdss7 =
,ss= >
UpdateTaskDTOss? L
dtossM P
,ssP Q
intssR U
currentUserIdssV c
,ssc d
stringsse k
currentUserRolessl {
)ss{ |
{tt 	
varuu 
taskuu 
=uu 
awaituu 
_taskRepositoryuu ,
.uu, -
GetByIdAsyncuu- 9
(uu9 :
taskIduu: @
)uu@ A
;uuA B
ifvv 
(vv 
taskvv 
==vv 
nullvv 
)vv 
{ww 
throwxx 
newxx  
KeyNotFoundExceptionxx .
(xx. /
$strxx/ @
)xx@ A
;xxA B
}yy 
bool{{ 
isAdmin{{ 
={{ 
currentUserRole{{ *
=={{+ -
$str{{. 5
;{{5 6
bool|| 
isOwner|| 
=|| 
task|| 
.||  
CreatedByUserId||  /
==||0 2
currentUserId||3 @
;||@ A
if~~ 
(~~ 
!~~ 
isAdmin~~ 
&&~~ 
!~~ 
isOwner~~ $
)~~$ %
{ 
throw
ÄÄ 
new
ÄÄ &
ForbiddenAccessException
ÄÄ 2
(
ÄÄ2 3
$str
ÄÄ3 b
)
ÄÄb c
;
ÄÄc d
}
ÅÅ 
if
ÉÉ 
(
ÉÉ 
!
ÉÉ 
Enum
ÉÉ 
.
ÉÉ 
	IsDefined
ÉÉ 
(
ÉÉ  
typeof
ÉÉ  &
(
ÉÉ& '

WorkStatus
ÉÉ' 1
)
ÉÉ1 2
,
ÉÉ2 3
dto
ÉÉ4 7
.
ÉÉ7 8
Status
ÉÉ8 >
!
ÉÉ> ?
.
ÉÉ? @
Value
ÉÉ@ E
)
ÉÉE F
)
ÉÉF G
{
ÑÑ 
throw
ÖÖ 
new
ÖÖ '
InvalidOperationException
ÖÖ 3
(
ÖÖ3 4
$str
ÖÖ4 K
)
ÖÖK L
;
ÖÖL M
}
ÜÜ 
if
àà 
(
àà 
!
àà 
Enum
àà 
.
àà 
	IsDefined
àà 
(
àà  
typeof
àà  &
(
àà& '
TaskPriority
àà' 3
)
àà3 4
,
àà4 5
dto
àà6 9
.
àà9 :
Priority
àà: B
!
ààB C
.
ààC D
Value
ààD I
)
ààI J
)
ààJ K
{
ââ 
throw
ää 
new
ää '
InvalidOperationException
ää 3
(
ää3 4
$str
ää4 M
)
ääM N
;
ääN O
}
ãã 
task
çç 
.
çç 
Title
çç 
=
çç 
dto
çç 
.
çç 
Title
çç "
;
çç" #
task
éé 
.
éé 
Description
éé 
=
éé 
dto
éé "
.
éé" #
Description
éé# .
;
éé. /
task
èè 
.
èè 
Status
èè 
=
èè 
(
èè 

WorkStatus
èè %
)
èè% &
dto
èè& )
.
èè) *
Status
èè* 0
.
èè0 1
Value
èè1 6
;
èè6 7
task
êê 
.
êê 
Priority
êê 
=
êê 
(
êê 
TaskPriority
êê )
)
êê) *
dto
êê* -
.
êê- .
Priority
êê. 6
.
êê6 7
Value
êê7 <
;
êê< =
task
ëë 
.
ëë 

CategoryId
ëë 
=
ëë 
dto
ëë !
.
ëë! "

CategoryId
ëë" ,
!
ëë, -
.
ëë- .
Value
ëë. 3
;
ëë3 4
task
íí 
.
íí 
DueDate
íí 
=
íí 
dto
íí 
.
íí 
DueDate
íí &
!
íí& '
.
íí' (
Value
íí( -
;
íí- .
task
ìì 
.
ìì 
	UpdatedAt
ìì 
=
ìì 
DateTime
ìì %
.
ìì% &
UtcNow
ìì& ,
;
ìì, -
await
ïï 
_taskRepository
ïï !
.
ïï! "
SaveChangesAsync
ïï" 2
(
ïï2 3
)
ïï3 4
;
ïï4 5
_logger
óó 
.
óó 
LogInformation
óó "
(
óó" #
$str
óó# O
,
óóO P
task
óóQ U
.
óóU V
Id
óóV X
,
óóX Y
currentUserId
óóZ g
)
óóg h
;
óóh i
return
ôô 
MapToDto
ôô 
(
ôô 
task
ôô  
)
ôô  !
;
ôô! "
}
öö 	
public
ûû 
async
ûû 
Task
ûû 
DeleteTaskAsync
ûû )
(
ûû) *
int
ûû* -
taskId
ûû. 4
,
ûû4 5
int
ûû6 9
currentUserId
ûû: G
,
ûûG H
string
ûûI O
currentUserRole
ûûP _
)
ûû_ `
{
üü 	
var
†† 
task
†† 
=
†† 
await
†† 
_taskRepository
†† ,
.
††, -
GetByIdAsync
††- 9
(
††9 :
taskId
††: @
)
††@ A
;
††A B
if
°° 
(
°° 
task
°° 
==
°° 
null
°° 
)
°° 
{
¢¢ 
throw
££ 
new
££ "
KeyNotFoundException
££ .
(
££. /
$str
££/ @
)
££@ A
;
££A B
}
§§ 
bool
¶¶ 
isAdmin
¶¶ 
=
¶¶ 
currentUserRole
¶¶ *
==
¶¶+ -
$str
¶¶. 5
;
¶¶5 6
bool
ßß 
isSelfCreatedTask
ßß "
=
ßß# $
task
ßß% )
.
ßß) *
CreatedByUserId
ßß* 9
==
ßß: <
task
ßß= A
.
ßßA B
AssignedToUserId
ßßB R
;
ßßR S
bool
®® &
isOwnerOfSelfCreatedTask
®® )
=
®®* +
isSelfCreatedTask
®®, =
&&
®®> @
task
®®A E
.
®®E F
CreatedByUserId
®®F U
==
®®V X
currentUserId
®®Y f
;
®®f g
if
´´ 
(
´´ 
!
´´ 
isAdmin
´´ 
&&
´´ 
!
´´ &
isOwnerOfSelfCreatedTask
´´ 5
)
´´5 6
{
¨¨ 
throw
≠≠ 
new
≠≠ &
ForbiddenAccessException
≠≠ 2
(
≠≠2 3
$str
≠≠3 d
)
≠≠d e
;
≠≠e f
}
ÆÆ 
task
∞∞ 
.
∞∞ 
	IsDeleted
∞∞ 
=
∞∞ 
true
∞∞ !
;
∞∞! "
task
±± 
.
±± 
	DeletedAt
±± 
=
±± 
DateTime
±± %
.
±±% &
UtcNow
±±& ,
;
±±, -
await
≤≤ 
_taskRepository
≤≤ !
.
≤≤! "
SaveChangesAsync
≤≤" 2
(
≤≤2 3
)
≤≤3 4
;
≤≤4 5
_logger
¥¥ 
.
¥¥ 
LogInformation
¥¥ "
(
¥¥" #
$str
¥¥# T
,
¥¥T U
task
¥¥V Z
.
¥¥Z [
Id
¥¥[ ]
,
¥¥] ^
currentUserId
¥¥_ l
)
¥¥l m
;
¥¥m n
}
µµ 	
private
∏∏ 
static
∏∏ 
TaskDTO
∏∏ 
MapToDto
∏∏ '
(
∏∏' (
TaskItem
∏∏( 0
task
∏∏1 5
)
∏∏5 6
{
ππ 	
return
∫∫ 
new
∫∫ 
TaskDTO
∫∫ 
{
ªª 
Id
ºº 
=
ºº 
task
ºº 
.
ºº 
Id
ºº 
,
ºº 
Title
ΩΩ 
=
ΩΩ 
task
ΩΩ 
.
ΩΩ 
Title
ΩΩ "
,
ΩΩ" #
Description
ææ 
=
ææ 
task
ææ "
.
ææ" #
Description
ææ# .
,
ææ. /
Status
øø 
=
øø 
task
øø 
.
øø 
Status
øø $
.
øø$ %
ToString
øø% -
(
øø- .
)
øø. /
,
øø/ 0
Priority
¿¿ 
=
¿¿ 
task
¿¿ 
.
¿¿  
Priority
¿¿  (
.
¿¿( )
ToString
¿¿) 1
(
¿¿1 2
)
¿¿2 3
,
¿¿3 4
CategoryName
¡¡ 
=
¡¡ 
task
¡¡ #
.
¡¡# $
Category
¡¡$ ,
?
¡¡, -
.
¡¡- .
Name
¡¡. 2
??
¡¡3 5
string
¡¡6 <
.
¡¡< =
Empty
¡¡= B
,
¡¡B C
DueDate
¬¬ 
=
¬¬ 
task
¬¬ 
.
¬¬ 
DueDate
¬¬ &
,
¬¬& ' 
AssignedToUsername
√√ "
=
√√# $
task
√√% )
.
√√) *
AssignedToUser
√√* 8
?
√√8 9
.
√√9 :
Username
√√: B
??
√√C E
string
√√F L
.
√√L M
Empty
√√M R
,
√√R S
CreatedByUsername
ƒƒ !
=
ƒƒ" #
task
ƒƒ$ (
.
ƒƒ( )
CreatedByUser
ƒƒ) 6
?
ƒƒ6 7
.
ƒƒ7 8
Username
ƒƒ8 @
??
ƒƒA C
string
ƒƒD J
.
ƒƒJ K
Empty
ƒƒK P
,
ƒƒP Q
	CreatedAt
≈≈ 
=
≈≈ 
task
≈≈  
.
≈≈  !
	CreatedAt
≈≈! *
,
≈≈* +
	UpdatedAt
∆∆ 
=
∆∆ 
task
∆∆  
.
∆∆  !
	UpdatedAt
∆∆! *
}
«« 
;
«« 
}
»» 	
public
ÀÀ 
async
ÀÀ 
Task
ÀÀ 
<
ÀÀ 
List
ÀÀ 
<
ÀÀ 
TaskCategoryDTO
ÀÀ .
>
ÀÀ. /
>
ÀÀ/ 0 
GetCategoriesAsync
ÀÀ1 C
(
ÀÀC D
)
ÀÀD E
{
ÃÃ 	
var
ÕÕ 

categories
ÕÕ 
=
ÕÕ 
await
ÕÕ "
_taskRepository
ÕÕ# 2
.
ÕÕ2 3#
GetAllCategoriesAsync
ÕÕ3 H
(
ÕÕH I
)
ÕÕI J
;
ÕÕJ K
return
ŒŒ 

categories
ŒŒ 
.
ŒŒ 
Select
ŒŒ $
(
ŒŒ$ %
c
ŒŒ% &
=>
ŒŒ' )
new
ŒŒ* -
TaskCategoryDTO
ŒŒ. =
{
ŒŒ> ?
Id
ŒŒ@ B
=
ŒŒC D
c
ŒŒE F
.
ŒŒF G
Id
ŒŒG I
,
ŒŒI J
Name
ŒŒK O
=
ŒŒP Q
c
ŒŒR S
.
ŒŒS T
Name
ŒŒT X
}
ŒŒY Z
)
ŒŒZ [
.
ŒŒ[ \
ToList
ŒŒ\ b
(
ŒŒb c
)
ŒŒc d
;
ŒŒd e
}
œœ 	
public
—— 
async
—— 
Task
—— 
<
—— 
DashboardDTO
—— &
>
——& '
GetDashboardAsync
——( 9
(
——9 :
int
——: =
currentUserId
——> K
,
——K L
string
——M S
currentUserRole
——T c
)
——c d
{
““ 	
bool
”” 
isAdmin
”” 
=
”” 
currentUserRole
”” *
==
””+ -
$str
””. 5
;
””5 6
var
‘‘ 
tasks
‘‘ 
=
‘‘ 
await
‘‘ 
_taskRepository
‘‘ -
.
‘‘- . 
GetAllForUserAsync
‘‘. @
(
‘‘@ A
currentUserId
‘‘A N
,
‘‘N O
isAdmin
‘‘P W
)
‘‘W X
;
‘‘X Y
var
÷÷ 
	dashboard
÷÷ 
=
÷÷ 
new
÷÷ 
DashboardDTO
÷÷  ,
{
◊◊ 
PendingCount
ÿÿ 
=
ÿÿ 
tasks
ÿÿ $
.
ÿÿ$ %
Count
ÿÿ% *
(
ÿÿ* +
t
ÿÿ+ ,
=>
ÿÿ- /
t
ÿÿ0 1
.
ÿÿ1 2
Status
ÿÿ2 8
==
ÿÿ9 ;

WorkStatus
ÿÿ< F
.
ÿÿF G
Pending
ÿÿG N
)
ÿÿN O
,
ÿÿO P
InProgressCount
ŸŸ 
=
ŸŸ  !
tasks
ŸŸ" '
.
ŸŸ' (
Count
ŸŸ( -
(
ŸŸ- .
t
ŸŸ. /
=>
ŸŸ0 2
t
ŸŸ3 4
.
ŸŸ4 5
Status
ŸŸ5 ;
==
ŸŸ< >

WorkStatus
ŸŸ? I
.
ŸŸI J

InProgress
ŸŸJ T
)
ŸŸT U
,
ŸŸU V
CompletedCount
⁄⁄ 
=
⁄⁄  
tasks
⁄⁄! &
.
⁄⁄& '
Count
⁄⁄' ,
(
⁄⁄, -
t
⁄⁄- .
=>
⁄⁄/ 1
t
⁄⁄2 3
.
⁄⁄3 4
Status
⁄⁄4 :
==
⁄⁄; =

WorkStatus
⁄⁄> H
.
⁄⁄H I
	Completed
⁄⁄I R
)
⁄⁄R S
}
€€ 
;
€€ 
if
›› 
(
›› 
isAdmin
›› 
)
›› 
{
ﬁﬁ 
var
ﬂﬂ 
allUsers
ﬂﬂ 
=
ﬂﬂ 
await
ﬂﬂ $
_userRepository
ﬂﬂ% 4
.
ﬂﬂ4 5
GetAllAsync
ﬂﬂ5 @
(
ﬂﬂ@ A
)
ﬂﬂA B
;
ﬂﬂB C
	dashboard
‡‡ 
.
‡‡ 

TotalUsers
‡‡ $
=
‡‡% &
allUsers
‡‡' /
.
‡‡/ 0
Count
‡‡0 5
;
‡‡5 6
	dashboard
·· 
.
·· 

TotalTasks
·· $
=
··% &
await
··' ,
_taskRepository
··- <
.
··< =%
GetTotalTasksCountAsync
··= T
(
··T U
)
··U V
;
··V W
	dashboard
‚‚ 
.
‚‚ 
DeletedTasksCount
‚‚ +
=
‚‚, -
await
‚‚. 3
_taskRepository
‚‚4 C
.
‚‚C D'
GetDeletedTasksCountAsync
‚‚D ]
(
‚‚] ^
)
‚‚^ _
;
‚‚_ `
}
„„ 
return
ÂÂ 
	dashboard
ÂÂ 
;
ÂÂ 
}
ÊÊ 	
}
ÁÁ 
}ËË î>
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Services\AuthService.cs
	namespace

 	
TaskManagement


 
.

 
Application

 $
.

$ %
Services

% -
{ 
public 

class 
AuthService 
{ 
private 
readonly 
IUserRepository (
_userRepository) 8
;8 9
private 
readonly 
IRoleRepository (
_roleRepository) 8
;8 9
private 
readonly 
PasswordHasher '
<' (
User( ,
>, -
_passwordHasher. =
;= >
private 
readonly 
ITokenService &
_tokenService' 4
;4 5
private 
readonly 
ILogger  
<  !
AuthService! ,
>, -
_logger. 5
;5 6
public 
AuthService 
( 
IUserRepository *
userRepository+ 9
,9 :
IRoleRepository; J
roleRepositoryK Y
,Y Z
ITokenService[ h
tokenServicei u
,u v
ILoggerw ~
<~ 
AuthService	 ä
>
ä ã
logger
å í
)
í ì
{ 	
_userRepository 
= 
userRepository ,
;, -
_roleRepository 
= 
roleRepository ,
;, -
_passwordHasher 
= 
new !
PasswordHasher" 0
<0 1
User1 5
>5 6
(6 7
)7 8
;8 9
_tokenService 
= 
tokenService (
;( )
_logger 
= 
logger 
; 
} 	
public 
async 
Task 
< 
UserDTO !
>! "
RegisterAsync# 0
(0 1
RegisterDTO1 <
dto= @
)@ A
{ 	!
ArgumentNullException   !
.  ! "
ThrowIfNull  " -
(  - .
dto  . 1
)  1 2
;  2 3
bool"" 
emailExists"" 
="" 
await"" $
_userRepository""% 4
.""4 5
EmailExistsAsync""5 E
(""E F
dto""F I
.""I J
Email""J O
)""O P
;""P Q
if## 
(## 
emailExists## 
)## 
{$$ 
_logger%% 
.%% 

LogWarning%% "
(%%" #
$str%%# X
,%%X Y
dto%%Z ]
.%%] ^
Email%%^ c
)%%c d
;%%d e
throw&& 
new&& %
InvalidOperationException&& 3
(&&3 4
$str&&4 R
)&&R S
;&&S T
}'' 
var)) 
userRole)) 
=)) 
await))  
_roleRepository))! 0
.))0 1
GetByNameAsync))1 ?
())? @
$str))@ F
)))F G
;))G H
if** 
(** 
userRole** 
==** 
null**  
)**  !
{++ 
throw,, 
new,, %
InvalidOperationException,, 3
(,,3 4
$str,,4 p
),,p q
;,,q r
}-- 
var// 
user// 
=// 
new// 
User// 
{00 
Username11 
=11 
dto11 
.11 
Username11 '
,11' (
Email22 
=22 
dto22 
.22 
Email22 !
,22! "
	CreatedAt33 
=33 
DateTime33 $
.33$ %
UtcNow33% +
,33+ ,
RoleId44 
=44 
userRole44 !
.44! "
Id44" $
}55 
;55 
user77 
.77 
PasswordHash77 
=77 
_passwordHasher77  /
.77/ 0
HashPassword770 <
(77< =
user77= A
,77A B
dto77C F
.77F G
Password77G O
)77O P
;77P Q
await99 
_userRepository99 !
.99! "
AddAsync99" *
(99* +
user99+ /
)99/ 0
;990 1
await:: 
_userRepository:: !
.::! "
SaveChangesAsync::" 2
(::2 3
)::3 4
;::4 5
_logger<< 
.<< 
LogInformation<< "
(<<" #
$str<<# S
,<<S T
user<<U Y
.<<Y Z
Email<<Z _
,<<_ `
user<<a e
.<<e f
Id<<f h
)<<h i
;<<i j
return>> 
new>> 
UserDTO>> 
{?? 
Id@@ 
=@@ 
user@@ 
.@@ 
Id@@ 
,@@ 
UsernameAA 
=AA 
userAA 
.AA  
UsernameAA  (
,AA( )
EmailBB 
=BB 
userBB 
.BB 
EmailBB "
,BB" #
RoleCC 
=CC 
userRoleCC 
.CC  
NameCC  $
}DD 
;DD 
}EE 	
publicGG 
asyncGG 
TaskGG 
<GG 
(GG 
stringGG !
TokenGG" '
,GG' (
stringGG) /
RoleGG0 4
)GG4 5
>GG5 6

LoginAsyncGG7 A
(GGA B
LoginDTOGGB J
dtoGGK N
)GGN O
{HH 	!
ArgumentNullExceptionII !
.II! "
ThrowIfNullII" -
(II- .
dtoII. 1
)II1 2
;II2 3
varKK 
userKK 
=KK 
awaitKK 
_userRepositoryKK ,
.KK, -
GetByEmailAsyncKK- <
(KK< =
dtoKK= @
.KK@ A
EmailKKA F
)KKF G
;KKG H
ifLL 
(LL 
userLL 
==LL 
nullLL 
)LL 
{MM 
_loggerNN 
.NN 

LogWarningNN "
(NN" #
$strNN# N
,NNN O
dtoNNP S
.NNS T
EmailNNT Y
)NNY Z
;NNZ [
throwOO 
newOO '
UnauthorizedAccessExceptionOO 5
(OO5 6
$strOO6 R
)OOR S
;OOS T
}PP 
varRR 
resultRR 
=RR 
_passwordHasherRR (
.RR( ) 
VerifyHashedPasswordRR) =
(RR= >
userRR> B
,RRB C
userRRD H
.RRH I
PasswordHashRRI U
,RRU V
dtoRRW Z
.RRZ [
PasswordRR[ c
)RRc d
;RRd e
ifSS 
(SS 
resultSS 
==SS &
PasswordVerificationResultSS 4
.SS4 5
FailedSS5 ;
)SS; <
{TT 
_loggerUU 
.UU 

LogWarningUU "
(UU" #
$strUU# L
,UUL M
dtoUUN Q
.UUQ R
EmailUUR W
)UUW X
;UUX Y
throwVV 
newVV '
UnauthorizedAccessExceptionVV 5
(VV5 6
$strVV6 R
)VVR S
;VVS T
}WW 
_loggerYY 
.YY 
LogInformationYY "
(YY" #
$strYY# N
,YYN O
userYYP T
.YYT U
EmailYYU Z
,YYZ [
userYY\ `
.YY` a
IdYYa c
)YYc d
;YYd e
var[[ 
token[[ 
=[[ 
_tokenService[[ %
.[[% &
GenerateToken[[& 3
([[3 4
user[[4 8
)[[8 9
;[[9 :
return\\ 
(\\ 
token\\ 
,\\ 
user\\ 
.\\  
Role\\  $
.\\$ %
Name\\% )
)\\) *
;\\* +
}]] 	
}`` 
}aa ™

kD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\IUserRepository.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %

Interfaces% /
{ 
public 

	interface 
IUserRepository $
{		 
Task

 
<

 
User

 
?

 
>

 
GetByEmailAsync

 #
(

# $
string

$ *
email

+ 0
)

0 1
;

1 2
Task 
< 
User 
? 
> 
GetByIdAsync 
(  
int  #
id$ &
)& '
;' (
Task 
< 
bool 
> 
EmailExistsAsync #
(# $
string$ *
email+ 0
)0 1
;1 2
Task 
< 
List 
< 
User 
> 
> 
GetAllAsync $
($ %
)% &
;& '
Task 
AddAsync 
( 
User 
user 
)  
;  !
Task 
SaveChangesAsync 
( 
) 
;  
} 
} È
iD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\ITokenService.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %

Interfaces% /
{ 
public 

	interface 
ITokenService "
{		 
string

 
GenerateToken

 
(

 
User

 !
user

" &
)

& '
;

' (
} 
} î
kD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\ITaskRepository.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %

Interfaces% /
{ 
public 

	interface 
ITaskRepository $
{		 
Task

 
<

 
TaskItem

 
?

 
>

 
GetByIdAsync

 $
(

$ %
int

% (
id

) +
)

+ ,
;

, -
Task 
< 
List 
< 
TaskItem 
> 
> 
GetAllForUserAsync /
(/ 0
int0 3
userId4 :
,: ;
bool< @
isAdminA H
)H I
;I J
Task 
< 
List 
< 
TaskCategory 
> 
>  !
GetAllCategoriesAsync! 6
(6 7
)7 8
;8 9
Task 
AddAsync 
( 
TaskItem 
task #
)# $
;$ %
Task 
< 
int 
> %
GetDeletedTasksCountAsync +
(+ ,
), -
;- .
Task 
< 
int 
> #
GetTotalTasksCountAsync )
() *
)* +
;+ ,
Task 
SaveChangesAsync 
( 
) 
;  
} 
} ≠
kD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Interfaces\IRoleRepository.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %

Interfaces% /
{ 
public		 

	interface		 
IRoleRepository		 $
{

 
Task 
< 
Role 
? 
> 
GetByNameAsync "
(" #
string# )
name* .
). /
;/ 0
} 
} É
tD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\Exceptions\ForbiddenAccessException.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %

Exceptions% /
;/ 0
public 
class $
ForbiddenAccessException %
:& '
	Exception( 1
{ 
public 
$
ForbiddenAccessException #
(# $
string$ *
message+ 2
)2 3
:4 5
base6 :
(: ;
message; B
)B C
{D E
}F G
} ©	
]D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\UserDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
UserDTO 
{ 
public		 
int		 
Id		 
{		 
get		 
;		 
set		  
;		  !
}		" #
public

 
string

 
Username

 
{

  
get

! $
;

$ %
set

& )
;

) *
}

+ ,
=

- .
string

/ 5
.

5 6
Empty

6 ;
;

; <
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
public 
string 
Role 
{ 
get  
;  !
set" %
;% &
}' (
=) *
string+ 1
.1 2
Empty2 7
;7 8
} 
} ‡
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\UpdateTaskDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
UpdateTaskDTO 
{		 
[

 	
Required

	 
]

 
[ 	
StringLength	 
( 
$num 
, 
MinimumLength (
=) *
$num+ ,
), -
]- .
public 
string 
Title 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
[ 	
StringLength	 
( 
$num 
) 
] 
public 
string 
Description !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
[ 	
Required	 
( 
ErrorMessage 
=  
$str! 6
)6 7
]7 8
public 
int 
? 
Status 
{ 
get  
;  !
set" %
;% &
}' (
[ 	
Required	 
( 
ErrorMessage 
=  
$str! 8
)8 9
]9 :
public 
int 
? 
Priority 
{ 
get "
;" #
set$ '
;' (
}) *
[ 	
Required	 
( 
ErrorMessage 
=  
$str! :
): ;
]; <
public 
int 
? 

CategoryId 
{  
get! $
;$ %
set& )
;) *
}+ ,
[ 	
Required	 
( 
ErrorMessage 
=  
$str! 7
)7 8
]8 9
public   
DateTime   
?   
DueDate    
{  ! "
get  # &
;  & '
set  ( +
;  + ,
}  - .
}!! 
}"" ‡
]D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\TaskDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
TaskDTO 
{ 
public		 
int		 
Id		 
{		 
get		 
;		 
set		  
;		  !
}		" #
public

 
string

 
Title

 
{

 
get

 !
;

! "
set

# &
;

& '
}

( )
=

* +
string

, 2
.

2 3
Empty

3 8
;

8 9
public 
string 
Description !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
public 
string 
Status 
{ 
get "
;" #
set$ '
;' (
}) *
=+ ,
string- 3
.3 4
Empty4 9
;9 :
public 
string 
Priority 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
public 
string 
CategoryName "
{# $
get% (
;( )
set* -
;- .
}/ 0
=1 2
string3 9
.9 :
Empty: ?
;? @
public 
DateTime 
DueDate 
{  !
get" %
;% &
set' *
;* +
}, -
public 
string 
AssignedToUsername (
{) *
get+ .
;. /
set0 3
;3 4
}5 6
=7 8
string9 ?
.? @
Empty@ E
;E F
public 
string 
CreatedByUsername '
{( )
get* -
;- .
set/ 2
;2 3
}4 5
=6 7
string8 >
.> ?
Empty? D
;D E
public 
DateTime 
	CreatedAt !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
DateTime 
	UpdatedAt !
{" #
get$ '
;' (
set) ,
;, -
}. /
} 
} ‹
eD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\TaskCategoryDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
TaskCategoryDTO  
{ 
public		 
int		 
Id		 
{		 
get		 
;		 
set		  
;		  !
}		" #
public

 
string

 
Name

 
{

 
get

  
;

  !
set

" %
;

% &
}

' (
=

) *
string

+ 1
.

1 2
Empty

2 7
;

7 8
} 
} ±
aD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\RegisterDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
RegisterDTO 
{		 
[

 	
Required

	 
]

 
[ 	
StringLength	 
( 
$num 
, 
MinimumLength '
=( )
$num* +
)+ ,
], -
public 
string 
Username 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
[ 	
Required	 
] 
[ 	
EmailAddress	 
( 
ErrorMessage "
=# $
$str% <
)< =
]= >
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
[ 	
Required	 
] 
[ 	
	MinLength	 
( 
$num 
, 
ErrorMessage "
=# $
$str% N
)N O
]O P
public 
string 
Password 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
} 
} ò
^D:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\LoginDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
LoginDTO 
{		 
[

 	
Required

	 
]

 
[ 	
EmailAddress	 
] 
public 
string 
Email 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
public 
string 
Password 
{  
get! $
;$ %
set& )
;) *
}+ ,
=- .
string/ 5
.5 6
Empty6 ;
;; <
} 
} ∏

bD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\DashboardDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
DashboardDTO 
{ 
public		 
int		 
PendingCount		 
{		  !
get		" %
;		% &
set		' *
;		* +
}		, -
public

 
int

 
InProgressCount

 "
{

# $
get

% (
;

( )
set

* -
;

- .
}

/ 0
public 
int 
CompletedCount !
{" #
get$ '
;' (
set) ,
;, -
}. /
public 
int 
? 

TotalUsers 
{  
get! $
;$ %
set& )
;) *
}+ ,
public 
int 
? 

TotalTasks 
{  
get! $
;$ %
set& )
;) *
}+ ,
public 
int 
? 
DeletedTasksCount %
{& '
get( +
;+ ,
set- 0
;0 1
}2 3
} 
} ›
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.Application\DTOs\CreateTaskDTO.cs
	namespace 	
TaskManagement
 
. 
Application $
.$ %
DTOs% )
{ 
public 

class 
CreateTaskDTO 
{		 
[

 	
Required

	 
]

 
[ 	
StringLength	 
( 
$num 
, 
MinimumLength (
=) *
$num+ ,
), -
]- .
public 
string 
Title 
{ 
get !
;! "
set# &
;& '
}( )
=* +
string, 2
.2 3
Empty3 8
;8 9
[ 	
StringLength	 
( 
$num 
) 
] 
public 
string 
Description !
{" #
get$ '
;' (
set) ,
;, -
}. /
=0 1
string2 8
.8 9
Empty9 >
;> ?
[ 	
Required	 
( 
ErrorMessage 
=  
$str! 8
)8 9
]9 :
public 
int 
? 
Priority 
{ 
get "
;" #
set$ '
;' (
}) *
[ 	
Required	 
( 
ErrorMessage 
=  
$str! :
): ;
]; <
public 
int 
? 

CategoryId 
{  
get! $
;$ %
set& )
;) *
}+ ,
[ 	
Required	 
( 
ErrorMessage 
=  
$str! 7
)7 8
]8 9
public 
DateTime 
? 
DueDate  
{! "
get# &
;& '
set( +
;+ ,
}- .
public   
int   
?   
AssignedToUserId   $
{  % &
get  ' *
;  * +
set  , /
;  / 0
}  1 2
}!! 
}"" 