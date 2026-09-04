Ü
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Controllers\UserController.cs
	namespace 	
TaskManagement
 
. 
API 
. 
Controllers (
{ 
[ 
ApiController 
] 
[		 
Route		 

(		
 
$str		 
)		 
]		 
[

 
	Authorize

 
]

 
public 

class 
UsersController  
:! "
ControllerBase# 1
{ 
private 
readonly 
UserService $
_userService% 1
;1 2
public 
UsersController 
( 
UserService *
userService+ 6
)6 7
{ 	
_userService 
= 
userService &
;& '
} 	
[ 	
HttpGet	 
] 
[ 	
	Authorize	 
( 
Roles 
= 
$str "
)" #
]# $
public 
async 
Task 
< 
IActionResult '
>' (
GetAll) /
(/ 0
)0 1
{ 	
var 
users 
= 
await 
_userService *
.* +
GetAllUsersAsync+ ;
(; <
)< =
;= >
return 
Ok 
( 
users 
) 
; 
} 	
[ 	
HttpGet	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (
GetCurrentUser) 7
(7 8
)8 9
{ 	
var 
userId 
= 
int 
. 
Parse "
(" #
User# '
.' (
	FindFirst( 1
(1 2

ClaimTypes2 <
.< =
NameIdentifier= K
)K L
!L M
.M N
ValueN S
)S T
;T U
var   
user   
=   
await   
_userService   )
.  ) *
GetUserByIdAsync  * :
(  : ;
userId  ; A
)  A B
;  B C
return!! 
Ok!! 
(!! 
user!! 
)!! 
;!! 
}"" 	
}## 
}$$ ˚W
PD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Program.cs
Log 
. 
Logger 

= 
new 
LoggerConfiguration $
($ %
)% &
. 
MinimumLevel 
. 
Information 
( 
) 
. 
WriteTo 
. 
Console 
( 
) 
. 
WriteTo 
. 
File 
( 
$str !
,! "
rollingInterval# 2
:2 3
RollingInterval4 C
.C D
DayD G
)G H
. 
CreateLogger 
( 
) 
; 
try 
{ 
Log 
. 
Information 
( 
$str 1
)1 2
;2 3
var 
builder 
= 
WebApplication  
.  !
CreateBuilder! .
(. /
args/ 3
)3 4
;4 5
builder 
. 
Host 
. 

UseSerilog 
( 
) 
; 
builder 
. 
Services 
. #
AddEndpointsApiExplorer ,
(, -
)- .
;. /
builder 
. 
Services 
. 
AddSwaggerGen "
(" #
options# *
=>+ -
{ 
options 
. !
AddSecurityDefinition %
(% &
$str& .
,. /
new0 3!
OpenApiSecurityScheme4 I
{   	
Name!! 
=!! 
$str!! "
,!!" #
Type"" 
="" 
SecuritySchemeType"" %
.""% &
Http""& *
,""* +
Scheme## 
=## 
$str## 
,## 
BearerFormat$$ 
=$$ 
$str$$  
,$$  !
In%% 
=%% 
ParameterLocation%% "
.%%" #
Header%%# )
,%%) *
Description&& 
=&& 
$str&& Y
}'' 	
)''	 

;''
 
options)) 
.)) "
AddSecurityRequirement)) &
())& '
document))' /
=>))0 2
new))3 6
())6 7
)))7 8
{** 	
[++ 
new++ *
OpenApiSecuritySchemeReference++ /
(++/ 0
$str++0 8
,++8 9
document++: B
)++B C
]++C D
=++E F
new++G J
List++K O
<++O P
string++P V
>++V W
(++W X
)++X Y
},, 	
),,	 

;,,
 
}-- 
)-- 
;-- 
builder// 
.// 
Services// 
.// 
AddDbContext// !
<//! "
AppDbContext//" .
>//. /
(/// 0
options//0 7
=>//8 :
options00 
.00 
UseSqlServer00 
(00 
builder00 $
.00$ %
Configuration00% 2
.002 3
GetConnectionString003 F
(00F G
$str00G Z
)00Z [
)00[ \
)00\ ]
;00] ^
builder22 
.22 
Services22 
.22 
	AddScoped22 
<22 
IUserRepository22 .
,22. /
UserRepository220 >
>22> ?
(22? @
)22@ A
;22A B
builder33 
.33 
Services33 
.33 
	AddScoped33 
<33 
ITokenService33 ,
,33, -
TokenService33. :
>33: ;
(33; <
)33< =
;33= >
builder44 
.44 
Services44 
.44 
	AddScoped44 
<44 
IRoleRepository44 .
,44. /
RoleRepository440 >
>44> ?
(44? @
)44@ A
;44A B
builder55 
.55 
Services55 
.55 
	AddScoped55 
<55 
AuthService55 *
>55* +
(55+ ,
)55, -
;55- .
builder66 
.66 
Services66 
.66 
	AddScoped66 
<66 
ITaskRepository66 .
,66. /
TaskRepository660 >
>66> ?
(66? @
)66@ A
;66A B
builder77 
.77 
Services77 
.77 
	AddScoped77 
<77 
TaskService77 *
>77* +
(77+ ,
)77, -
;77- .
builder88 
.88 
Services88 
.88 
	AddScoped88 
<88 
UserService88 *
>88* +
(88+ ,
)88, -
;88- .
builder:: 
.:: 
Services:: 
.:: 
AddCors:: 
(:: 
options:: $
=>::% '
{;; 
options<< 
.<< 
	AddPolicy<< 
(<< 
$str<< )
,<<) *
policy<<+ 1
=><<2 4
{== 	
policy>> 
.>> 
WithOrigins>> 
(>> 
$str>> 6
)>>6 7
.?? 
AllowAnyHeader?? !
(??! "
)??" #
.@@ 
AllowAnyMethod@@ !
(@@! "
)@@" #
;@@# $
}AA 	
)AA	 

;AA
 
}BB 
)BB 
;BB 
varDD 
jwtKeyDD 
=DD 
builderDD 
.DD 
ConfigurationDD &
[DD& '
$strDD' 8
]DD8 9
;DD9 :
ifEE 
(EE 
stringEE 
.EE 
IsNullOrWhiteSpaceEE !
(EE! "
jwtKeyEE" (
)EE( )
||EE* ,
EncodingEE- 5
.EE5 6
UTF8EE6 :
.EE: ;
GetByteCountEE; G
(EEG H
jwtKeyEEH N
)EEN O
<EEP Q
$numEER T
)EET U
{FF 
throwGG 
newGG %
InvalidOperationExceptionGG +
(GG+ ,
$strHH Q
)HHQ R
;HHR S
}II 
builderKK 
.KK 
ServicesKK 
.KK 
AddAuthenticationKK &
(KK& '
optionsKK' .
=>KK/ 1
{LL 
optionsMM 
.MM %
DefaultAuthenticateSchemeMM )
=MM* +
JwtBearerDefaultsMM, =
.MM= > 
AuthenticationSchemeMM> R
;MMR S
optionsNN 
.NN "
DefaultChallengeSchemeNN &
=NN' (
JwtBearerDefaultsNN) :
.NN: ; 
AuthenticationSchemeNN; O
;NNO P
}OO 
)OO 
.PP 
AddJwtBearerPP 
(PP 
optionsPP 
=>PP 
{QQ 
optionsRR 
.RR %
TokenValidationParametersRR )
=RR* +
newRR, /%
TokenValidationParametersRR0 I
{SS 	
ValidateIssuerTT 
=TT 
trueTT !
,TT! "
ValidateAudienceUU 
=UU 
trueUU #
,UU# $
ValidateLifetimeVV 
=VV 
trueVV #
,VV# $$
ValidateIssuerSigningKeyWW $
=WW% &
trueWW' +
,WW+ ,
ValidIssuerXX 
=XX 
builderXX !
.XX! "
ConfigurationXX" /
[XX/ 0
$strXX0 D
]XXD E
,XXE F
ValidAudienceYY 
=YY 
builderYY #
.YY# $
ConfigurationYY$ 1
[YY1 2
$strYY2 H
]YYH I
,YYI J
IssuerSigningKeyZZ 
=ZZ 
newZZ " 
SymmetricSecurityKeyZZ# 7
(ZZ7 8
EncodingZZ8 @
.ZZ@ A
UTF8ZZA E
.ZZE F
GetBytesZZF N
(ZZN O
jwtKeyZZO U
)ZZU V
)ZZV W
}[[ 	
;[[	 

}\\ 
)\\ 
;\\ 
builder^^ 
.^^ 
Services^^ 
.^^ 
AddControllers^^ #
(^^# $
)^^$ %
;^^% &
var`` 
app`` 
=`` 
builder`` 
.`` 
Build`` 
(`` 
)`` 
;`` 
appbb 
.bb $
UseSerilogRequestLoggingbb  
(bb  !
)bb! "
;bb" #
appcc 
.cc 
UseMiddlewarecc 
<cc '
ExceptionHandlingMiddlewarecc 1
>cc1 2
(cc2 3
)cc3 4
;cc4 5
ifee 
(ee 
appee 
.ee 
Environmentee 
.ee 
IsDevelopmentee %
(ee% &
)ee& '
)ee' (
{ff 
appgg 
.gg 

UseSwaggergg 
(gg 
)gg 
;gg 
apphh 
.hh 
UseSwaggerUIhh 
(hh 
)hh 
;hh 
}ii 
appkk 
.kk 
UseHttpsRedirectionkk 
(kk 
)kk 
;kk 
appll 
.ll 
UseCorsll 
(ll 
$strll 
)ll  
;ll  !
appmm 
.mm 
UseAuthenticationmm 
(mm 
)mm 
;mm 
appnn 
.nn 
UseAuthorizationnn 
(nn 
)nn 
;nn 
appoo 
.oo 
MapControllersoo 
(oo 
)oo 
;oo 
usingqq 	
(qq
 
varqq 
scopeqq 
=qq 
appqq 
.qq 
Servicesqq #
.qq# $
CreateScopeqq$ /
(qq/ 0
)qq0 1
)qq1 2
{rr 
varss 
dbss 
=ss 
scopess 
.ss 
ServiceProviderss &
.ss& '
GetRequiredServicess' 9
<ss9 :
AppDbContextss: F
>ssF G
(ssG H
)ssH I
;ssI J
vartt 
configtt 
=tt 
scopett 
.tt 
ServiceProvidertt *
.tt* +
GetRequiredServicett+ =
<tt= >
IConfigurationtt> L
>ttL M
(ttM N
)ttN O
;ttO P
awaituu 
TaskManagementuu 
.uu 
Infrastructureuu +
.uu+ ,
Datauu, 0
.uu0 1
DBSeederuu1 9
.uu9 :
	SeedAsyncuu: C
(uuC D
dbuuD F
,uuF G
configuuH N
)uuN O
;uuO P
}vv 
appxx 
.xx 
Runxx 
(xx 
)xx 
;xx 
}yy 
catchzz 
(zz 
	Exceptionzz 
exzz 
)zz 
{{{ 
Log|| 
.|| 
Fatal|| 
(|| 
ex|| 
,|| 
$str|| 7
)||7 8
;||8 9
}}} 
finally~~ 
{ 
Log
ÄÄ 
.
ÄÄ 
CloseAndFlush
ÄÄ 
(
ÄÄ 
)
ÄÄ 
;
ÄÄ 
}ÅÅ ê%
oD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Middleware\ExceptionHandlingMiddleware.cs
	namespace 	
TaskManagement
 
. 
API 
. 

Middleware '
{ 
public 

class '
ExceptionHandlingMiddleware ,
{		 
private

 
readonly

 
RequestDelegate

 ,
_next

- 2
;

2 3
private 
readonly 
ILogger $
<$ %'
ExceptionHandlingMiddleware% @
>@ A
_loggerB I
;I J
public '
ExceptionHandlingMiddleware .
(. /
RequestDelegate/ >
next? C
,C D
ILoggerE L
<L M'
ExceptionHandlingMiddlewareM h
>h i
loggerj p
)p q
{ 
_next 
= 
next 
; 
_logger 
= 
logger  
;  !
} 
public 
async 
Task 
InvokeAsync )
() *
HttpContext* 5
context6 =
)= >
{ 
try 
{ 
await 
_next 
(  
context  '
)' (
;( )
} 
catch 
( 
	Exception  
ex! #
)# $
{ 
await  
HandleExceptionAsync .
(. /
context/ 6
,6 7
ex8 :
): ;
;; <
} 
} 
private 
Task  
HandleExceptionAsync )
() *
HttpContext* 5
context6 =
,= >
	Exception? H
exI K
)K L
{   	
context!! 
.!! 
Response!! 
.!! 
ContentType!! (
=!!) *
$str!!+ =
;!!= >
var$$ 
($$ 

statusCode$$ 
,$$ 
message$$ $
,$$$ %
logAsWarning$$& 2
)$$2 3
=$$4 5
ex$$6 8
switch$$9 ?
{%% %
InvalidOperationException&& )
=>&&* ,
(&&- .
HttpStatusCode&&. <
.&&< =

BadRequest&&= G
,&&G H
ex&&I K
.&&K L
Message&&L S
,&&S T
true&&U Y
)&&Y Z
,&&Z [ 
KeyNotFoundException'' $
=>''% '
(''( )
HttpStatusCode'') 7
.''7 8
NotFound''8 @
,''@ A
ex''B D
.''D E
Message''E L
,''L M
true''N R
)''R S
,''S T'
UnauthorizedAccessException(( +
=>((, .
(((/ 0
HttpStatusCode((0 >
.((> ?
Unauthorized((? K
,((K L
ex((M O
.((O P
Message((P W
,((W X
true((Y ]
)((] ^
,((^ _$
ForbiddenAccessException)) (
=>))) +
()), -
HttpStatusCode))- ;
.)); <
	Forbidden))< E
,))E F
ex))G I
.))I J
Message))J Q
,))Q R
true))S W
)))W X
,))X Y
_** 
=>** 
(** 
HttpStatusCode** $
.**$ %
InternalServerError**% 8
,**8 9
$str**: q
,**q r
false**s x
)**x y
}++ 
;++ 
if-- 
(-- 
logAsWarning-- 
)-- 
{.. 
_logger// 
.// 

LogWarning// "
(//" #
$str//# A
,//A B
ex//C E
.//E F
Message//F M
)//M N
;//N O
}00 
else11 
{22 
_logger33 
.33 
LogError33  
(33  !
ex33! #
,33# $
$str33% N
,33N O
ex33P R
.33R S
Message33S Z
)33Z [
;33[ \
}44 
context66 
.66 
Response66 
.66 

StatusCode66 '
=66( )
(66* +
int66+ .
)66. /

statusCode66/ 9
;669 :
var77 
response77 
=77 
JsonSerializer77 )
.77) *
	Serialize77* 3
(773 4
new774 7
{778 9
message77: A
}77B C
)77C D
;77D E
return88 
context88 
.88 
Response88 #
.88# $

WriteAsync88$ .
(88. /
response88/ 7
)887 8
;888 9
}99 	
}<< 
}== Õ<
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Controllers\TaskController.cs
	namespace 	
TaskManagement
 
. 
API 
. 
Controllers (
{ 
[		 
ApiController		 
]		 
[

 
Route

 

(


 
$str

 
)

 
]

 
[ 
	Authorize 
] 
public 

class 
TasksController  
:! "
ControllerBase# 1
{ 
private 
readonly 
TaskService $
_taskService% 1
;1 2
public 
TasksController 
( 
TaskService *
taskService+ 6
)6 7
{ 	
_taskService 
= 
taskService &
;& '
} 	
private 
int 
GetCurrentUserId $
($ %
)% &
{ 	
var 
idClaim 
= 
User 
. 
	FindFirst (
(( )

ClaimTypes) 3
.3 4
NameIdentifier4 B
)B C
?C D
.D E
ValueE J
;J K
if 
( 
! 
int 
. 
TryParse 
( 
idClaim %
,% &
out' *
var+ .
userId/ 5
)5 6
||7 9
userId: @
<=A C
$numD E
)E F
{ 
throw 
new '
UnauthorizedAccessException 5
(5 6
$str6 h
)h i
;i j
} 
return 
userId 
; 
} 	
private   
string   
GetCurrentUserRole   )
(  ) *
)  * +
{!! 	
return"" 
User"" 
."" 
	FindFirst"" !
(""! "

ClaimTypes""" ,
."", -
Role""- 1
)""1 2
?""2 3
.""3 4
Value""4 9
??"": <
string""= C
.""C D
Empty""D I
;""I J
}## 	
[%% 	
HttpGet%%	 
]%% 
public&& 
async&& 
Task&& 
<&& 
IActionResult&& '
>&&' (
GetAll&&) /
(&&/ 0
)&&0 1
{'' 	
var(( 
tasks(( 
=(( 
await(( 
_taskService(( *
.((* + 
GetTasksForUserAsync((+ ?
(((? @
GetCurrentUserId((@ P
(((P Q
)((Q R
,((R S
GetCurrentUserRole((T f
(((f g
)((g h
)((h i
;((i j
return)) 
Ok)) 
()) 
tasks)) 
))) 
;)) 
}** 	
[,, 	
HttpGet,,	 
(,, 
$str,, 
),, 
],, 
public-- 
async-- 
Task-- 
<-- 
IActionResult-- '
>--' (
GetById--) 0
(--0 1
int--1 4
id--5 7
)--7 8
{.. 	
var// 
task// 
=// 
await// 
_taskService// )
.//) *
GetTaskByIdAsync//* :
(//: ;
id//; =
,//= >
GetCurrentUserId//? O
(//O P
)//P Q
,//Q R
GetCurrentUserRole//S e
(//e f
)//f g
)//g h
;//h i
return00 
Ok00 
(00 
task00 
)00 
;00 
}11 	
[33 	
HttpPost33	 
]33 
public44 
async44 
Task44 
<44 
IActionResult44 '
>44' (
Create44) /
(44/ 0
[440 1
FromBody441 9
]449 :
CreateTaskDTO44; H
dto44I L
)44L M
{55 	
var66 
task66 
=66 
await66 
_taskService66 )
.66) *
CreateTaskAsync66* 9
(669 :
dto66: =
,66= >
GetCurrentUserId66? O
(66O P
)66P Q
,66Q R
GetCurrentUserRole66S e
(66e f
)66f g
)66g h
;66h i
return77 
CreatedAtAction77 "
(77" #
nameof77# )
(77) *
GetById77* 1
)771 2
,772 3
new774 7
{778 9
id77: <
=77= >
task77? C
.77C D
Id77D F
}77G H
,77H I
task77J N
)77N O
;77O P
}88 	
[:: 	
HttpPut::	 
(:: 
$str:: 
):: 
]:: 
public;; 
async;; 
Task;; 
<;; 
IActionResult;; '
>;;' (
Update;;) /
(;;/ 0
int;;0 3
id;;4 6
,;;6 7
[;;8 9
FromBody;;9 A
];;A B
UpdateTaskDTO;;C P
dto;;Q T
);;T U
{<< 	
var== 
task== 
=== 
await== 
_taskService== )
.==) *
UpdateTaskAsync==* 9
(==9 :
id==: <
,==< =
dto==> A
,==A B
GetCurrentUserId==C S
(==S T
)==T U
,==U V
GetCurrentUserRole==W i
(==i j
)==j k
)==k l
;==l m
return>> 
Ok>> 
(>> 
task>> 
)>> 
;>> 
}?? 	
[AA 	

HttpDeleteAA	 
(AA 
$strAA 
)AA 
]AA 
publicBB 
asyncBB 
TaskBB 
<BB 
IActionResultBB '
>BB' (
DeleteBB) /
(BB/ 0
intBB0 3
idBB4 6
)BB6 7
{CC 	
awaitDD 
_taskServiceDD 
.DD 
DeleteTaskAsyncDD .
(DD. /
idDD/ 1
,DD1 2
GetCurrentUserIdDD3 C
(DDC D
)DDD E
,DDE F
GetCurrentUserRoleDDG Y
(DDY Z
)DDZ [
)DD[ \
;DD\ ]
returnEE 
	NoContentEE 
(EE 
)EE 
;EE 
}FF 	
[HH 	
HttpGetHH	 
(HH 
$strHH 
)HH 
]HH 
publicII 
asyncII 
TaskII 
<II 
IActionResultII '
>II' (
GetCategoriesII) 6
(II6 7
)II7 8
{JJ 	
varKK 

categoriesKK 
=KK 
awaitKK "
_taskServiceKK# /
.KK/ 0
GetCategoriesAsyncKK0 B
(KKB C
)KKC D
;KKD E
returnLL 
OkLL 
(LL 

categoriesLL  
)LL  !
;LL! "
}MM 	
[OO 	
HttpGetOO	 
(OO 
$strOO 
)OO 
]OO 
publicPP 
asyncPP 
TaskPP 
<PP 
IActionResultPP '
>PP' (
GetDashboardPP) 5
(PP5 6
)PP6 7
{QQ 	
varRR 
	dashboardRR 
=RR 
awaitRR !
_taskServiceRR" .
.RR. /
GetDashboardAsyncRR/ @
(RR@ A
GetCurrentUserIdRRA Q
(RRQ R
)RRR S
,RRS T
GetCurrentUserRoleRRU g
(RRg h
)RRh i
)RRi j
;RRj k
returnSS 
OkSS 
(SS 
	dashboardSS 
)SS  
;SS  !
}TT 	
}UU 
}VV à
cD:\10pearls_internship\cohort-9-dotnet-7843-hooria\TaskManagement.API\Controllers\AuthController.cs
	namespace 	
TaskManagement
 
. 
API 
. 
Controllers (
{ 
[		 
ApiController		 
]		 
[

 
Route

 

(


 
$str

 
)

 
]

 
public 

class 
AuthController 
:  !
ControllerBase" 0
{ 
private 
readonly 
AuthService $
_authService% 1
;1 2
public 
AuthController 
( 
AuthService )
authService* 5
)5 6
{ 	
_authService 
= 
authService &
;& '
} 	
[ 	
HttpPost	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (
Register) 1
(1 2
[2 3
FromBody3 ;
]; <
RegisterDTO= H
dtoI L
)L M
{ 	
var 
result 
= 
await "
_authService# /
./ 0
RegisterAsync0 =
(= >
dto> A
)A B
;B C
return 
Ok 
( 
result  
)  !
;! "
} 	
[ 	
HttpPost	 
( 
$str 
) 
] 
public 
async 
Task 
< 
IActionResult '
>' (
Login) .
(. /
[/ 0
FromBody0 8
]8 9
LoginDTO: B
dtoC F
)F G
{ 	
var 
( 
token 
, 
role  
)  !
=" #
await$ )
_authService* 6
.6 7

LoginAsync7 A
(A B
dtoB E
)E F
;F G
return 
Ok 
( 
new 
{ 
token  %
,% &
role' +
}, -
)- .
;. /
}   	
["" 	
	Authorize""	 
("" 
Roles"" 
="" 
$str"" "
)""" #
]""# $
[## 	
HttpGet##	 
(## 
$str## 
)## 
]## 
public$$ 
IActionResult$$ 
	AdminOnly$$ &
($$& '
)$$' (
{%% 	
return&& 
Ok&& 
(&& 
new&& 
{&& 
message&& #
=&&$ %
$str&&& 9
}&&: ;
)&&; <
;&&< =
}'' 	
}++ 
},, 