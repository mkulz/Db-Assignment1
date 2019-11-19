select * from my_contacts;
use normalization;
#add primary key to my_contacts table
alter table my_contacts
    add column PersonID int(11) primary key not null auto_increment;

#create genders table
drop table if exists genders;
create table genders(
    genderID int(11) not null auto_increment,
    gender char(1) not null,
    primary key (genderID)
) as
    select distinct gender
    from my_contacts
    where gender is not null
    order by gender;

alter table my_contacts
    add column genderID int(11);
update my_contacts
    inner join genders
    on genders.gender = my_contacts.gender
    set my_contacts.genderID = genders.genderID
    where genders.gender is not null;

alter table my_contacts drop column gender;

#create emails table
drop table if exists emails;
create table emails(
    PersonID int(11) not null references my_contacts(PersonID),
    email varchar(100)
) as
    select distinct PersonID, email
    from my_contacts
    where email is not null
    order by PersonID;

alter table my_contacts drop column email;

#create professions table
drop table if exists professions;
create table professions(
    professionID int(11) not null primary key auto_increment,
    profession varchar(50)
) as
    select distinct profession
    from my_contacts
    where profession is not null
    order by profession;

alter table my_contacts
    add column professionID int(11);
update my_contacts
    inner join professions
    on professions.profession = my_contacts.profession
    set my_contacts.professionID = professions.professionID
    where professions.profession is not null;

alter table my_contacts drop column profession;

#create statuses table
drop table if exists statuses;
create table statuses (
    statusID int(11) not null auto_increment primary key,
    status varchar(30)
) as
    select distinct status
    from my_contacts
    where status is not null
    order by status;

alter table my_contacts
    add column statusID int(11);
update my_contacts
    inner join statuses
    on statuses.status = my_contacts.status
    set my_contacts.statusID = statuses.statusID
    where statuses.status is not null;

update statuses
    set status = "committed relationship"
    where status = "committed relationsh";

alter table my_contacts drop column status;

select * from my_contacts;
select * from genders;
select * from emails;
select * from professions;
select * from statuses;

