select location from my_contacts;
update my_contacts
set location = "San Francisco, CA"
where location = "San Fran, CA";

drop table if exists locations;
create table locations(
    LocationID int(11) primary key auto_increment,
    City varchar(50),
    State varchar(5)
) as
    select distinct
        substring_index(mc.location, ',', 1) City,
        substring_index(mc.location, ', ', -1) State
from my_contacts as mc
where mc.location is not null
order by State, City;

alter table my_contacts
add column LocationID int(11);

update my_contacts
set my_contacts.LocationID = (select locations.LocationID from locations
    where my_contacts.location = CONCAT(City, ", ", State))
where my_contacts.location is not null;

alter table my_contacts
drop column location;

select * from my_contacts;