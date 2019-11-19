drop table if exists temp_interests;
create table temp_interests (
    PersonID int(11),
    interest1 varchar(50),
    interest2 varchar(50),
    interest3 varchar(50),
    foreign key (PersonID) references my_contacts(PersonID)
) as
    select distinct
        substring_index(mc.interests, ',', 1) Interest1,
        substring_index(substring_index(mc.interests, ', ', 2), ', ', -1) Interest2,
        substring_index(substring_index(mc.interests, ', ', 3), ', ', -1) Interest3,
        PersonID
    from my_contacts AS mc
     where mc.interests is not null;
#select * from temp_interests;

drop table if exists interests;
create table interests(
    InterestID int(11) primary key not null auto_increment
    #Interest varchar(50)
) as
select distinct Interest1 as Interest from temp_interests
union select distinct Interest2 as Interest from temp_interests
union select distinct Interest3 as Interest from temp_interests
order by interest;
#select * from interests;

drop table if exists people_interests;
create table people_interests (
    PersonID int(11),
    InterestID varchar(50)
) ;

insert into people_interests
select distinct ti.PersonID, ti.Interest1 from temp_interests as ti;
insert into people_interests
select distinct ti.PersonID, ti.Interest2 from temp_interests as ti
where Interest1 != Interest2;
insert into people_interests
select distinct ti.PersonID, ti.Interest3 from temp_interests as ti
where Interest3 != Interest2
and Interest3 != Interest1;

update people_interests
set people_interests.InterestID = (select interests.InterestID from interests
where people_interests.InterestID = interests.Interest);

alter table people_interests
modify column InterestID int(11);

#shows names and interests
/*select mc.first_name, i.Interest
from my_contacts as mc, people_interests as pi, interests as i
where mc.PersonID = pi.PersonID
and pi.Interest = i.InterestID
order by mc.PersonID;*/

drop table if exists temp_interests; #remove temp table
alter table my_contacts drop column interests; #remove interests col from mc