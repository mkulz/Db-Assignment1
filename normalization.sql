#
#
# Db-Assignment1
#
# PROF FIREHEART
# I haven't been able to get DataGrip to connect to mysql server,
# so I'm just uploading this as a text file.
# You should be able to just copy and paste this code.
# Some of this code I was not able to actually test,
# but I think this should all work.
#
#


#run my_contacts file to set up initial database
use Normalization1;
# Add a Primary Key to the my_contacts table.
alter table my_contacts
    add column PersonID int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT;


#create gender table
drop table if exists gender;

create table gender (
    gender_ID int(11) not null auto_increment,
    gender varchar(25) not null,
    primary key (gender_ID)
) as
    select distinct gender
    from my_contacts
    where gender is not null
    order by gender;

alter table my_contacts
    add column gender_ID int(11);

update my_contacts
    inner join gender
    on gender.gender = my_contacts.gender
    set my_contacts.gender_ID = gender.gender_ID
    where gender.gender is not null;

#select mc.first_name, mc.last_name, mc.gender, mc.gender_ID, gn.gender
#    from gender as gn
#    inner join my_contacts as mc
#    on gn.gender_ID = mc.gender_ID;

#create professions table
drop table if exists professions;

create table professions (
    profession_ID int(11) not null auto_increment,
    profession varchar(25) not null,
    primary key (profession_ID)
) as
    select distinct profession
    from my_contacts
    where profession is not null
    order by profession;

alter table my_contacts
    add column profession_ID int(11);

update my_contacts
    inner join professions
    on professions.profession = my_contacts.profession
    set my_contacts.profession_ID = professions.profession_ID
    where professions.profession is not null;

#create status table
drop table if exists statuses;

create table statuses(
    status_ID int(11) not null auto_increment,
    status varchar(25) not null,
    primary key (status_ID)
) as
    select distinct status
    from my_contacts
    where status is not null
    order by status;

alter table my_contacts
    add column status_ID int(11);

update my_contacts
    inner join statuses
    on statuses.status = my_contacts.status
    set my_contacts.status_ID = statuses.status_ID
    where statuses.status is not null;

#create emails table
drop table if exists emails;
create table emails(
    PersonID int(11) not null references my_contacts(PersonID),
    Email varchar(100)
)as
    select distinct PersonID, email
    from my_contacts
    where email is not null
    order by PersonID;

#create locations table
drop table if exists locations;
create table locations(
    Location varchar(150),
    City varchar(100),
    State varchar(50),
    LocationID int(11) not null primary key auto_increment
)as
    select distinct location
    from my_contacts
    where location is not null
    order by location;

#create interests table
drop table if exists interests;
create table interests(
    Interest1 varchar(150),
    Interest2 varchar(150),
    Interest3 varchar(150),
    PersonID int(11),
    foreign key (PersonID) references my_contacts(PersonID)
) as
    select distinct
        substring_index(interests, ',', 1) Interest1,
        substring_index(substring_index(interests, ', ', 2), ', ', -1) Interest2,
        substring_index(substring_index(interests, ', ', 3), ', ', -1) Interest3
    from my_contacts
    where interests is not null
    order by interests;
#select * from interests;

#create seeking table
drop table if exists seekings;
create table seekings (
    Seeking1 varchar(150),
    Seeking2 varchar(150),
    PersonID int(11),
    foreign key (PersonID) references my_Contacts (PersonID)
) as
    select distinct
        substring_index(seeking, ',', 1) Seeking1,
        substring_index(substring_index(seeking, ', ', 2), ', ', -1) Seeking2
    from my_contacts
    where seeking is not null
    order by seeking;
		
#drop unnecessary columns
# alter table my_contacts
#     drop column (
#         email,
#         gender,
#         profession,
#         location,
#         status,
#         interests,
#         seeking
#     );
