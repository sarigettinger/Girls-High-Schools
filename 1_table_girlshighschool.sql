use GirlsHighSchoolsDB
go
drop table if exists GirlsHighSchools
go
create table dbo.GirlsHighSchools
(
    SchoolId int not null identity primary key,
    SchoolName varchar (35) not null 
        constraint u_school_name_must_be_unique unique (SchoolName)
        constraint ck_SchoolName_cannot_be_blank check (SchoolName <> ''),
    SchoolAddress varchar (75) not null
        constraint ck_SchoolAddress_cannot_be_blank check (SchoolAddress <> ''),
    SchoolPhoneNumber varchar (15) not null
        constraint ck_SchoolPhoneNumber_begins_with_732 check (SchoolPhoneNumber like '(732)%'),
    SchoolPrincipal varchar (40) not null 
        constraint ck_SchoolPrincipal_cannot_be_blank check (SchoolPrincipal <> ''),
    NumOfFreshies int not null 
        constraint ck_NumofFreshies_positive check (NumOfFreshies > 0),
    NumOfSophies int
        constraint ck_NumofSophies_positive check (NumOfSophies > 0),
    NumOfJuniors int
        constraint ck_NumofJuniors_positive check (NumOfJuniors > 0),
    NumOfSeniors int
        constraint ck_NumofSeniors_positive check (NumOfSeniors > 0),
    FullTuition decimal (10, 2) not null 
        constraint ck_FullTuition_positive check (FullTuition > 0),
    DiscountedTuition decimal (10, 2) not null 
        constraint ck_DiscountedTuition_positive check (DiscountedTuition > 0),
    PercentagePayingFull int not null 
        constraint ck_percentage_paying_full_between_0_and_100 check (PercentagePayingFull between 0 and 100),
    ConnectedToElementary bit not null default 0,
    YearlyBudget decimal (20, 2) not null
    constraint ck_school_budget_positive check (YearlyBudget > 0),
    TotalStudentBody as  (NumOfFreshies + isnull (NumOfSophies, 0)+ isnull (NumOfJuniors, 0) + isnull (NumOfSeniors, 0)),
    GrowingOrShrinking as case 
    when NumOfFreshies < NumOfSophies and NumOfSophies < NumOfJuniors  and NumOfJuniors < NumOfSeniors
    then 'shrinking'
    when (NumOfFreshies > NumOfSophies or NumOfSophies is null)  
    and (NumOfSophies > NumOfJuniors or NumOfJuniors is null)  
    and (NumOfJuniors > NumOfSeniors  or NumOfSeniors is null)  then 'growing'
    else 'neither' end
    persisted
    )
go

