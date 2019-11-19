select * from my_contacts;

drop table if exists temp_seekings;
create table temp_seekings(
    PersonID int(11),
    Seeking1 varchar(50),
    Seeking2 varchar(50),
    foreign key (PersonID) references my_contacts(PersonID)
) as
    select distinct
        substring_index(mc.seeking, ',', 1) Seeking1,
        substring_index(mc.seeking, ', ', -1) Seeking2,
        PersonID
    from my_contacts as mc
    where mc.seeking is not null;
#select * from temp_seekings;

drop table if exists seekings;
create table seekings(
    SeekingID int(11) auto_increment primary key
) as
select distinct Seeking1 as Seeking from temp_seekings
union select distinct Seeking2 as Seeking from temp_seekings;
#select * from seekings;

drop table if exists people_seekings;
create table people_seekings(
    PersonID int(11),
    SeekingID varchar(50)
);

insert into people_seekings
select distinct ts.PersonID, ts.Seeking1 from temp_seekings as ts;
insert into people_seekings
select distinct ts.PersonID, ts.Seeking2 from temp_seekings as ts
where ts.Seeking1 != ts.Seeking2;

update people_seekings
set people_seekings.SeekingID = (select seekings.SeekingID from seekings
where people_seekings.SeekingID = seekings.Seeking);

alter table people_seekings
modify column SeekingID int(11);

#select * from temp_seekings;
#select * from seekings;
#select * from people_seekings;

drop table if exists temp_seekings;
alter table my_contacts
drop column seeking;