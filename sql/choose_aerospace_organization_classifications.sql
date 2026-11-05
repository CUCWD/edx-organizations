-- Insert or backfill classifications for the Choose Aerospace Open edX site.
-- Run after organizations migration 0008_remove_historicalorganization_parent_organization_and_more.
-- The unique short_name key makes
-- each statement idempotent. New records retain the source created and modified
-- values. Parent organizations are inactive; existing parent rows are updated
-- to the same inactive status. Existing records update the reviewed description plus
-- the seven location and classification fields listed in ON DUPLICATE KEY UPDATE.
-- Incoming NULL locations preserve any location already stored on a duplicate.
-- website_url stores the supporting organization page separately from the
-- concise, human-readable description.
-- Classifications were reviewed against the consolidated migration taxonomy and public
-- organization descriptions. General values remain where greater specificity
-- could not be verified.
--
-- Current organization_type values used by the application are:
-- k12_school, school_district, career_technical_center, homeschool,
-- college_university, training_provider, workforce_agency,
-- education_nonprofit, education_technology, employer, government_agency,
-- internal_program, other, and unknown.
--
-- The implemented Django field is named education_level (not educational_level).

START TRANSACTION;

-- Parent organization: Choose Aerospace
INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Choose Aerospace', 'CA', 'A nonprofit that develops industry-aligned aviation maintenance curriculum and pathways to aerospace careers.', 'https://www.chooseaerospace.org/', 'Jenks', 'OK', '74037', '2025-07-07 00:27:56.711635', '2025-08-14 23:09:51.512840', 0, 'education_nonprofit', 'secondary_adult', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    active = VALUES(active),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organizations must be inserted before the child organizations that reference them.
INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES
    -- Parent organization: Hillsboro School District
    ('Hillsboro School District', 'HillsboroSD', 'A public K-12 school district serving Hillsboro, OR.', 'https://www.hsd.k12.or.us/', 'Hillsboro', 'OR', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Sand Springs Public Schools
    ('Sand Springs Public Schools', 'SandSpringsPS', 'A public K-12 school district serving Sand Springs, OK.', 'https://www.sandites.org/', 'Sand Springs', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Pryor Public Schools
    ('Pryor Public Schools', 'PryorPS', 'A public K-12 school district serving Pryor, OK.', 'https://www.pryorschools.org/', 'Pryor', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Newcastle Public Schools
    ('Newcastle Public Schools', 'NewcastlePS', 'A public K-12 school district serving Newcastle, OK.', 'https://www.newcastle.k12.ok.us/', 'Newcastle', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Bartlesville Public Schools
    ('Bartlesville Public Schools', 'BartlesvillePS', 'A public K-12 school district serving Bartlesville, OK.', 'https://www.bps-ok.org/', 'Bartlesville', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Bristow Public Schools
    ('Bristow Public Schools', 'BristowPS', 'A public K-12 school district serving Bristow, OK.', 'https://www.bristow.k12.ok.us/', 'Bristow', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Oilton Public Schools
    ('Oilton Public Schools', 'OiltonPS', 'A public K-12 school district serving Oilton, OK.', 'https://oilton.k12.ok.us/', 'Oilton', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Broken Arrow Public Schools
    ('Broken Arrow Public Schools', 'BrokenArrowPS', 'A public K-12 school district serving Broken Arrow, OK.', 'https://www.baschools.org/', 'Broken Arrow', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Moore Public Schools
    ('Moore Public Schools', 'MoorePS', 'A public K-12 school district serving Moore, OK.', 'https://www.mooreschools.com/', 'Moore', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: School District of Philadelphia
    ('School District of Philadelphia', 'PhiladelphiaSD', 'A public K-12 school district serving Philadelphia, PA.', 'https://www.philasd.org/', 'Philadelphia', 'PA', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Western Heights Public Schools
    ('Western Heights Public Schools', 'WesternHeightsPS', 'A public K-12 school district serving Oklahoma City, OK.', 'https://www.westernheights.k12.ok.us/', 'Oklahoma City', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Collinsville Public Schools
    ('Collinsville Public Schools', 'CollinsvillePS', 'A public K-12 school district serving Collinsville, OK.', 'https://www.collinsville.k12.ok.us/', 'Collinsville', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Detroit Public Schools Community District
    ('Detroit Public Schools Community District', 'DetroitPSCD', 'A public K-12 school district serving Detroit, MI.', 'https://www.detroitk12.org/', 'Detroit', 'MI', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Tulsa Public Schools
    ('Tulsa Public Schools', 'TulsaPS', 'A public K-12 school district serving Tulsa, OK.', 'https://www.tulsaschools.org/', 'Tulsa', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Okmulgee Public Schools
    ('Okmulgee Public Schools', 'OkmulgeePS', 'A public K-12 school district serving Okmulgee, OK.', 'https://www.okmulgeeps.com/', 'Okmulgee', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Wellington USD 353
    ('Wellington USD 353', 'WellingtonUSD353', 'A public K-12 school district serving Wellington, KS.', 'https://www.usd353.com/', 'Wellington', 'KS', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Durant Independent School District
    ('Durant Independent School District', 'DurantISD', 'A public K-12 school district serving Durant, OK.', 'https://www.durantisd.org/', 'Durant', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Olive Public Schools
    ('Olive Public Schools', 'OlivePS', 'A public K-12 school district serving Drumright, OK.', 'https://www.olive.k12.ok.us/', 'Drumright', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Christian County Public Schools
    ('Christian County Public Schools', 'ChristianCountyPS', 'A public K-12 school district serving Christian County, KY.', 'https://www.christian.kyschools.us/', null, 'KY', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Hood River County School District
    ('Hood River County School District', 'HoodRiverCountySD', 'A public K-12 school district serving Hood River County, OR.', 'https://www.hoodriver.k12.or.us/', null, 'OR', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Roswell Independent School District
    ('Roswell Independent School District', 'RoswellISD', 'A public K-12 school district serving Roswell, NM.', 'https://www.risd.k12.nm.us/', 'Roswell', 'NM', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: McKinney Independent School District
    ('McKinney Independent School District', 'McKinneyISD', 'A public K-12 school district serving McKinney, TX.', 'https://www.mckinneyisd.net/', 'McKinney', 'TX', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Chelsea Public Schools
    ('Chelsea Public Schools', 'ChelseaPS', 'A public K-12 school district serving Chelsea, OK.', 'https://www.chelseadragons.net/', 'Chelsea', 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Marion Community Unit School District 2
    ('Marion Community Unit School District 2', 'MarionCUSD2', 'A public K-12 school district serving Marion, IL.', 'https://www.marionunit2.org/', 'Marion', 'IL', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Silver Lake Regional School District
    ('Silver Lake Regional School District', 'SilverLakeRSD', 'A public school district serving communities in Massachusetts.', 'https://www.slrsd.org/', null, 'MA', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Houston Independent School District
    ('Houston Independent School District', 'HoustonISD', 'A public K-12 school district serving Houston, TX.', 'https://www.houstonisd.org/', 'Houston', 'TX', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Williston Basin School District 7
    ('Williston Basin School District 7', 'WillistonBasinSD7', 'A public K-12 school district serving Williston, ND.', 'https://www.willistonschools.org/', 'Williston', 'ND', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Grand Prairie Independent School District
    ('Grand Prairie Independent School District', 'GrandPrairieISD', 'A public K-12 school district serving Grand Prairie, TX.', 'https://www.gpisd.org/', 'Grand Prairie', 'TX', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Mid-Del Public Schools
    ('Mid-Del Public Schools', 'MidDelPS', 'A public K-12 school district serving Midwest City and Del City, OK.', 'https://www.mid-del.net/', null, 'OK', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Norfolk Public Schools
    ('Norfolk Public Schools', 'NorfolkPS', 'A public K-12 school district serving Norfolk, VA.', 'https://www.npsk12.com/', 'Norfolk', 'VA', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Omaha Public Schools
    ('Omaha Public Schools', 'OmahaPS', 'A public K-12 school district serving Omaha, NE.', 'https://www.ops.org/', 'Omaha', 'NE', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Evergreen Public Schools
    ('Evergreen Public Schools', 'EvergreenPS', 'A public K-12 school district serving Vancouver, WA.', 'https://www.evergreenps.org/', 'Vancouver', 'WA', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Dodge City Public Schools USD 443
    ('Dodge City Public Schools USD 443', 'DodgeCityUSD443', 'A public K-12 school district serving Dodge City, KS.', 'https://www.usd443.org/', 'Dodge City', 'KS', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Sahuarita Unified School District
    ('Sahuarita Unified School District', 'SahuaritaUSD', 'A public K-12 school district serving Sahuarita, AZ.', 'https://susd30.us/', 'Sahuarita', 'AZ', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Wayne County Schools
    ('Wayne County Schools', 'WayneCS', 'A public K-12 school district serving Wayne County, WV.', 'https://www.wayneschoolswv.org/', null, 'WV', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Fayette County Public Schools
    ('Fayette County Public Schools', 'FayetteCountyPS', 'A public K-12 school district serving Fayette County, KY.', 'https://www.fcps.net/', 'Lexington', 'KY', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Salem-Keizer Public Schools
    ('Salem-Keizer Public Schools', 'SalemKeizerPS', 'A public K-12 school district serving Salem and Keizer, OR.', 'https://salkeiz.k12.or.us/', 'Salem', 'OR', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public'),
    -- Parent organization: Bismarck Public Schools
    ('Bismarck Public Schools', 'BismarckPSD', 'A public K-12 school district serving Bismarck, ND.', 'https://www.bismarckschools.org/', 'Bismarck', 'ND', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 0, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    short_name = VALUES(short_name),
    active = VALUES(active);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Des Moines Public Schools', 'DesMoinesPS', 'A public education agency serving K-12 students and communities in Des Moines, IA.', 'https://centralcampus.dmschools.org/', 'Des Moines', 'IA', '50321', '2022-10-05 19:54:01.518544', '2024-09-12 03:24:44.180422', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Liberty High School', 'LibertyHS', 'A public high school serving students in Hillsboro, OR.', 'https://www.hsd.k12.or.us/liberty', 'Hillsboro', 'OR', '97124', '2022-10-05 19:59:40.139512', '2024-09-10 21:08:07.224214', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('SAMS (Southwest Aeronautics, Mathematics and Science) Academy', 'SAMSAcademy', 'A public charter secondary school focused on aeronautics, mathematics, science, and career preparation.', 'https://www.samsacademy.com/', 'Albuquerque', 'NM', '87114', '2022-10-05 19:57:17.693733', '2024-09-10 21:08:15.258794', 1, 'k12_school', 'secondary', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Charles Page High School', 'CharlesPageHS', 'A public high school serving students in Sand Springs, OK.', 'https://www.sandites.org/o/charles-page-high-school', 'Sand Springs', 'OK', '74063', '2024-09-12 02:11:22.774057', '2024-09-12 02:11:22.774057', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Bethlehem Area Vocational-Technical School', 'BethlehemAVTS', 'Provides career and technical education and workforce preparation for secondary and adult learners in Bethlehem, PA.', 'https://www.bethlehemavts.org/', 'Bethlehem', 'PA', '18020', '2024-09-12 02:12:45.995474', '2024-09-12 02:12:45.995474', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Metro Technology Centers', 'MetroTC', 'Provides career and technical training at its Aviation Career Campus in Oklahoma City.', 'https://www.metrotech.edu/about/locations/aviation-campus', 'Oklahoma City', 'OK', '73179', '2024-09-12 02:13:55.868008', '2024-09-12 02:14:15.055424', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Pryor High School', 'PryorHS', 'A public high school serving students in Pryor, OK.', 'https://www.pryorschools.org/o/phs', 'Pryor', 'OK', '74362', '2024-09-12 02:15:26.328780', '2024-09-12 02:15:26.328780', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Newcastle High School', 'NewcastleHS', 'A public high school serving students in Newcastle, OK.', 'https://www.newcastle.k12.ok.us/newcastlehighschool_home.aspx', 'Newcastle', 'OK', '73065', '2024-09-12 02:16:37.986787', '2024-09-12 02:16:37.986787', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Bartlesville High School', 'BartlesvilleHS', 'A public high school serving students in Bartlesville, OK.', 'https://bhs.bps-ok.org/o/bhs', 'Bartlesville', 'OK', '74003', '2024-09-12 02:17:39.631250', '2024-09-12 02:17:39.631250', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Bristow High School', 'BristowHS', 'A public high school serving students in Bristow, OK.', 'https://www.bristow.k12.ok.us/o/hs', 'Bristow', 'OK', '74010', '2024-09-12 02:18:40.332684', '2024-09-12 02:18:40.332684', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Oilton High School', 'OiltonHS', 'A public high school serving students in Oilton, OK.', 'https://oilton.k12.ok.us/366894_2', 'Oilton', 'OK', '74052', '2024-09-12 02:20:03.959614', '2024-09-12 02:20:03.959614', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Great Plains Technology Center', 'GreatPlainsTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Lawton, OK.', 'https://www.greatplains.edu/', 'Lawton', 'OK', '73505', '2024-09-12 02:21:29.869704', '2024-09-12 02:21:39.238717', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Rising Aviation High School', 'RisingAviationHS', 'A private aviation-focused high school offering academics, flight, and aerospace career preparation.', 'https://www.risingaviation.com/', 'Addison', 'TX', '75001', '2024-09-12 02:22:40.551978', '2024-09-12 02:22:40.551978', 1, 'k12_school', 'high_school', 'private')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Vanguard Academy', 'VanguardAcademy', 'A public high school serving students in Broken Arrow, OK.', 'https://www.baschools.org/o/vaoba', 'Broken Arrow', 'OK', '74012', '2024-09-12 02:24:15.064468', '2024-09-12 02:24:15.064468', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Westmoore', 'MoorePublicSchoolsWestmoore', 'A public high school serving students in Oklahoma City, OK.', 'https://westmoorehigh.mooreschools.com/', 'Oklahoma City', 'OK', '73170', '2024-09-12 02:25:18.307413', '2024-10-31 14:51:26.681814', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Yukon Public Schools', 'YukonPS', 'A public education agency serving K-12 students and communities in Yukon, OK.', 'https://www.yukonps.com/', 'Yukon', 'OK', '73099', '2024-09-12 02:26:12.218480', '2024-09-12 02:26:12.218480', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Frankford High School', 'FrankfordHS', 'A public high school serving students in Philadelphia, PA.', 'https://frankfordhs.philasd.org/', 'Philadelphia', 'PA', '19124', '2024-09-12 02:27:30.786965', '2024-09-12 02:27:30.786965', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Western Heights High School', 'WesternHeightsHS', 'A public high school serving students in Oklahoma City, OK.', 'https://hs.westernheights.k12.ok.us/o/hs', 'Oklahoma City', 'OK', '73179', '2024-09-12 02:28:41.836909', '2024-09-12 02:28:41.836909', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Collinsville High School', 'CollinsvilleHS', 'A public high school serving students in Collinsville, OK.', 'https://www.collinsville.k12.ok.us/o/chs', 'Collinsville', 'OK', '74021', '2024-09-12 02:29:35.882745', '2024-09-12 02:29:35.882745', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Payette River Technical Academy', 'PayetteRiverTA', 'A public charter school providing project-based career and technical education for secondary students.', 'https://www.pr2ta.com/', 'Emmett', 'ID', '83617', '2024-09-12 02:30:59.785680', '2024-09-12 02:30:59.785680', 1, 'career_technical_center', 'secondary', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Davis Aerospace Technical High School', 'DavisAerospaceTHS', 'A Detroit public high school focused on aviation, aerospace, and technical career pathways.', 'https://www.detroitk12.org/davisaerospace', 'Detroit', 'MI', '48215', '2024-09-12 02:32:21.037492', '2024-09-12 02:32:21.037492', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Weatherford Public Schools', 'WeatherfordPS', 'A public education agency serving K-12 students and communities in Weatherford, OK.', 'https://www.wpsok.org/', 'Weatherford', 'OK', '73096', '2024-09-12 02:33:13.289027', '2024-09-12 02:33:13.289027', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Cleveland Public Schools', 'ClevelandPS', 'A public education agency serving K-12 students and communities in Cleveland, OK.', 'https://www.clevelandtigers.com/', 'Cleveland', 'OK', '74020', '2024-09-12 02:34:06.316611', '2024-09-12 02:34:06.316611', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Somerset County Technology Center', 'SomersetCTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Somerset, PA.', 'https://sctc.net/', 'Somerset', 'PA', '15501', '2024-09-12 02:34:54.410241', '2024-09-12 02:34:54.410241', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Eagles Nest Projects Wisconsin', 'EaglesNestPW', 'A nonprofit that provides hands-on aviation STEM education, aircraft-building projects, and mentorship for high school students.', 'https://enpwi.com/', 'Salem', 'WI', '53168', '2024-09-12 02:35:44.317991', '2024-09-12 02:35:44.317991', 1, 'education_nonprofit', 'high_school', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('US Aviation Academy', 'USAviationAcademy', 'Provides professional pilot and aviation maintenance technician training.', 'https://www.usaviationacademy.com/', 'Denton', 'TX', '76207', '2024-09-12 02:36:36.748071', '2024-09-12 02:36:36.748071', 1, 'career_technical_center', 'postsecondary_nondegree', 'private_for_profit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Vienna High School', 'ViennaHS', 'A public high school serving students in Vienna, IL.', 'https://www.viennahighschool.com/', 'Vienna', 'IL', '62995', '2024-09-12 02:37:22.408363', '2024-09-12 02:37:22.408363', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Alabama Aerospace and Aviation High School', 'AlabamaAAHS', 'A public charter school preparing students for aerospace, aviation, and STEM careers.', 'https://alaahs.org/', 'Bessemer', 'AL', '35020', '2024-09-12 02:38:11.845378', '2024-09-12 03:39:20.192055', 1, 'k12_school', 'high_school', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('West Michigan Aviation Academy', 'WestMichiganAA', 'A public charter high school integrating college preparation with aviation and STEM education.', 'https://www.westmichiganaviation.org/', 'Grand Rapids', 'MI', '49512', '2024-09-12 02:39:07.306450', '2024-09-12 02:39:07.306450', 1, 'k12_school', 'high_school', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('East Central High School', 'EastCentralHS', 'A public high school serving students in Tulsa, OK.', 'https://eastcentral.tulsaschools.org/', 'Tulsa', 'OK', '74128', '2024-09-12 02:40:18.589727', '2024-09-12 02:40:18.589727', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Southmoore', 'MoorePublicSchoolsSouthmoore', 'A public high school serving students in Moore, OK.', 'https://southmoorehigh.mooreschools.com/', 'Moore', 'OK', '73160', '2024-09-12 02:41:22.374369', '2024-10-31 14:50:42.936869', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Putnam City Schools', 'PutnamCitySchools', 'A public education agency serving K-12 students and communities in Oklahoma City, OK.', 'https://www.putnamcityschools.org/', 'Oklahoma City', 'OK', '73122', '2024-09-12 02:44:07.273151', '2024-09-12 02:44:07.273151', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Moore High', 'MoorePublicSchoolsMooreHigh', 'A public high school serving students in Moore, OK.', 'https://moorehs.mooreschools.com/', 'Moore', 'OK', '73160', '2024-09-12 02:44:59.874253', '2025-08-08 16:51:08.900202', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('ATS Airframe', 'ATSmro', 'An aviation industry employer providing aircraft maintenance and related technical services in Everett, WA.', 'https://www.atsmro.com/', 'Everett', 'WA', '98204', '2024-09-12 02:48:15.773445', '2024-10-31 14:49:41.627383', 1, 'employer', 'adult_workforce', 'private_for_profit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Workforce Training Academy USA LLC', 'WTA4USA', 'A private specialty trade school providing hands-on career and technical training.', 'https://wta4usa.com/', 'Tucson', 'AZ', '85714', '2024-09-12 02:49:15.995816', '2024-09-12 02:49:15.995816', 1, 'career_technical_center', 'postsecondary_nondegree', 'private_for_profit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Flight Expo, Inc.', 'FlightExpo', 'A nonprofit aviation organization offering youth aircraft-building programs, scholarships, and hands-on aerospace education.', 'https://flightexpo.org/', 'Zimmerman', 'MN', '55398', '2024-09-12 02:50:35.165207', '2024-09-12 02:50:35.165207', 1, 'education_nonprofit', 'secondary_adult', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Greenbrier Christian Academy', 'GreenbrierCA', 'A private Christian school providing early-childhood through grade 12 education in Chesapeake, Virginia.', 'https://www.gcagators.org/', 'Chesapeake', 'VA', '23320', '2024-09-12 02:52:21.977623', '2024-09-12 02:52:21.977623', 1, 'k12_school', 'k12', 'private')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Cape Cod Community College', 'CapeCodCC', 'A public postsecondary institution offering academic, career, and workforce education in West Barnstable, MA.', 'https://capecod.edu/', 'West Barnstable', 'MA', '02668', '2024-09-12 02:53:20.474572', '2024-09-12 02:53:20.474572', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Okmulgee High School', 'OkmulgeeHS', 'A public high school serving students in Okmulgee, OK.', 'https://www.okmulgeeps.com/377282_2', 'Okmulgee', 'OK', '74447', '2024-09-12 02:54:33.465447', '2024-09-12 02:54:33.465447', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Southern Tech Center Aviation', 'SouthernTech', 'Provides career and technical education, including aviation maintenance training, for secondary and adult learners.', 'https://www.sotech.edu/', 'Ardmore', 'OK', '73401', '2024-09-12 02:55:18.011806', '2024-09-12 02:55:18.011806', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Wellington High School', 'WellingtonHS', 'A public high school serving students in Wellington, Kansas.', 'https://www.usd353.com/', 'Wellington', 'KS', '67152', '2024-09-12 02:56:27.976377', '2024-09-12 02:56:27.976377', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Durant High School', 'DurantHS', 'A public high school serving students in Durant, OK.', 'https://www.durantisd.org/schools/durant-high-school', 'Durant', 'OK', '74701', '2024-09-12 02:57:38.419643', '2024-09-12 02:57:38.419643', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Southwestern Illinois College', 'SouthwesternIllinoisCollege', 'A public community college offering academic, workforce, and aviation education programs.', 'https://www.swic.edu/academics/career-degrees/aviation/', 'Murphysboro', 'IL', '62966', '2024-09-12 03:06:45.894728', '2024-09-12 03:06:45.894728', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Olive High School', 'OliveHS', 'A public high school serving students in Drumright, OK.', 'https://www.olive.k12.ok.us/', 'Drumright', 'OK', '74030', '2024-09-12 03:08:18.805185', '2024-09-12 03:08:18.805185', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Accende, Inc. dba Mentoring Mission', 'MentoringMission', 'A nonprofit mentoring organization whose AMPLIFI program builds aviation career pathways for young people.', 'https://www.mentoringmission.org/#amplifi-aviation-pipeline', 'Chicago', 'IL', '60618', '2024-09-12 03:18:10.697246', '2024-09-12 03:18:10.697246', 1, 'education_nonprofit', 'high_school', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Gateway Academy', 'GatewayAcademy', 'A Christian County Schools career and technical academy offering hands-on programs in technology, health sciences, skilled trades, and other career pathways.', 'https://gatewayacademy.christian.kyschools.us/', 'Hopkinsville', 'KY', '42240', '2024-09-12 03:19:25.557565', '2024-09-12 03:19:25.557565', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organization (source record; already inserted above): Wayne County Schools
INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Wayne County Schools', 'WayneCS', 'A public education agency serving K-12 students and communities in Huntington, WV.', 'https://www.wayneschoolswv.org/', 'Huntington', 'WV', '25704', '2024-09-12 03:22:17.146905', '2024-10-31 14:53:19.124613', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Hood River Valley High School', 'HoodRiverValleyHS', 'A public high school serving students in Hood River, OR.', 'https://hrvhs.hoodriver.k12.or.us/', 'Hood River', 'OR', '97031', '2024-09-12 03:26:12.291874', '2024-09-12 03:26:12.291874', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Goddard High School', 'GoddardHS', 'A public high school serving students in Roswell, NM.', 'https://ghs.risd.k12.nm.us/', 'Roswell', 'NM', '88201', '2024-09-12 03:27:51.163136', '2024-09-12 03:27:51.163136', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('McKinney North High School', 'McKinneyNorthHS', 'A public high school serving students in McKinney, TX.', 'https://www.mckinneyisd.net/o/mnhs', 'McKinney', 'TX', '75071', '2024-09-12 03:28:53.489649', '2024-09-12 03:28:53.489649', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Polaris Career Center', 'PolarisCC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Middleburg Heights, OH.', 'https://www.polaris.edu/', 'Middleburg Heights', 'OH', '44130', '2024-09-12 03:30:53.954305', '2024-09-12 03:30:53.954305', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Chelsea High School', 'ChelseaHS', 'A public high school serving students in Chelsea, OK.', 'https://www.chelseadragons.net/o/chs', 'Chelsea', 'OK', '74016', '2024-09-12 03:31:58.494856', '2024-09-12 03:31:58.494856', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Southern Illinois University', 'SIU', 'A public postsecondary institution offering academic, career, and workforce education in Carbondale, IL.', 'https://siu.edu/', 'Carbondale', 'IL', '62901', '2024-09-12 03:33:07.551918', '2024-09-12 03:33:07.551918', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Southwest Technology Center', 'SWTech', 'Provides career and technical education and workforce preparation for secondary and adult learners in Altus, OK.', 'https://www.swtech.edu/', 'Altus', 'OK', '73521', '2024-09-12 03:34:26.200439', '2024-09-12 03:34:26.200439', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Shenandoah Valley Governor''s School', 'ShenandoahValleyGS', 'A public secondary school serving students in Fishersville, VA.', 'https://svgs.k12.va.us/', 'Fishersville', 'VA', '22939', '2024-09-12 03:35:37.785212', '2024-09-12 03:35:37.785212', 1, 'k12_school', 'secondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organization (source record; already inserted above): Broken Arrow Public Schools
INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Broken Arrow Public Schools', 'BrokenArrowPS', 'A public education agency serving K-12 students and communities in Broken Arrow, OK.', 'https://www.baschools.org/', 'Broken Arrow', 'OK', '74012', '2024-09-12 03:37:46.208391', '2024-09-12 03:37:46.208391', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Marion High School', 'MarionHS', 'A public high school serving students in Marion, IL.', 'https://www.marionunit2.org/Domain/69', 'Marion', 'IL', '62959', '2024-09-12 03:38:58.264055', '2024-09-12 03:38:58.264055', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Rising Tide Charter Public School', 'RisingTideCPS', 'A public charter secondary school serving students in Plymouth, MA.', 'https://risingtide.org/', 'Plymouth', 'MA', '02360', '2024-09-12 03:40:19.376081', '2024-09-12 03:40:19.376081', 1, 'k12_school', 'secondary', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Silver Lake High School', 'SilverLakeHS', 'A public high school serving students in Kingston, MA.', 'https://www.slrsd.org/schools/slrhs/index', 'Kingston', 'MA', '02364', '2024-09-12 03:46:51.149829', '2024-09-12 03:46:51.149829', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Fulton Leadership Academy', 'FultonLA', 'A public charter high school serving students in East Point, GA.', 'https://fultonleadershipacademy.net/', 'East Point', 'GA', '30344', '2024-09-12 03:50:12.899428', '2024-09-12 03:50:12.899428', 1, 'k12_school', 'high_school', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('American International Academy', 'AmericanIntlAcademy', 'A public charter K-12 school serving students in Westland, MI.', 'https://www.americanintlacademy.com/', 'Westland', 'MI', '48186', '2024-09-12 03:51:16.942210', '2024-09-12 03:51:16.942210', 1, 'k12_school', 'k12', 'public_charter')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Ross Sterling Aviation High School', 'RossSterlingAHS', 'A Houston public high school offering aviation and aerospace career pathways.', 'https://www.houstonisd.org/Page/162655', 'Houston', 'TX', '77081', '2024-09-12 03:53:22.087601', '2024-09-12 03:53:22.087601', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Williston High School', 'WillistonHS', 'A public high school serving students in Williston, ND.', 'https://www.willistonschools.org/o/whs', 'Williston', 'ND', '58801', '2024-09-12 03:55:24.085817', '2025-08-27 17:15:03.414109', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('IDEA Homeschool', 'IDEAFamilies', 'Supports K-12 homeschool students and families with flexible public education programs in Anchorage, AK.', 'https://www.ideafamilies.org/', 'Anchorage', 'AK', '99503', '2024-09-12 03:59:34.819968', '2024-09-12 03:59:34.819968', 1, 'homeschool', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Butler Tech', 'ButlerTech', 'Provides career and technical education and workforce preparation for secondary and adult learners in Fairfield Township, OH.', 'https://www.butlertech.org/', 'Fairfield Township', 'OH', '45011', '2024-09-12 04:01:43.197740', '2024-09-12 04:01:43.197740', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Tuskegee Airmen National Museum', 'TuskegeeAirmenNM', 'Preserves the history and legacy of the Tuskegee Airmen through exhibits and educational programs.', 'https://tuskegeemuseum.org/', 'Detroit', 'MI', '48213', '2024-09-12 04:02:37.963685', '2024-09-12 04:02:37.963685', 1, 'education_nonprofit', 'high_school', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Ada City Schools', 'AdaCitySchools', 'A public education agency serving K-12 students and communities in Ada, OK.', 'https://www.adacougars.net/', 'Ada', 'OK', '74820', '2024-09-13 15:14:53.225164', '2024-09-13 15:14:53.225164', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Dubiski Career High School', 'DubiskiCareerHS', 'A public high school serving students in Grand Prairie, TX.', 'https://www.gpisd.org/dubiski', 'Grand Prairie', 'TX', '75052', '2024-09-13 15:32:18.208000', '2024-09-13 15:32:18.208000', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Grand Island Public Schools', 'GrandIslandPS', 'A public education agency serving K-12 students and communities in Grand Island, NE.', 'https://www.gips.org/', 'Grand Island', 'NE', '68802', '2024-09-13 15:40:55.909109', '2024-09-13 15:40:55.909109', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Jefferson Union', 'JeffersonUnion', 'Provides secondary and adult education through comprehensive and alternative high schools serving communities near Daly City, California.', 'https://www.juhsd.net/', 'Daly City', 'CA', '94015', '2024-09-13 15:42:01.565287', '2024-09-13 15:42:01.565287', 1, 'school_district', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('McAlester Public Schools', 'McAlesterPublicSchools', 'A public education agency serving K-12 students and communities in McAlester, OK.', 'https://mcalester.k12.ok.us/', 'McAlester', 'OK', '74501', '2024-09-13 15:43:24.636080', '2024-09-13 15:43:24.636080', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Mid-Del Technology Center', 'MidDelTechCenter', 'Provides career and technical education and workforce preparation for secondary and adult learners in Midwest City, OK.', 'https://www.mid-del.net/', 'Midwest City', 'OK', '73110', '2024-09-13 15:44:38.236857', '2024-09-13 15:44:38.236857', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Bristol Bay Region Career and Technical Education', 'BristolBayRegionCTE', 'A regional school-district consortium providing career and technical programs in rural Alaska.', 'https://bbrcte.org/', 'Palmer', 'AK', '99635', '2024-10-08 19:52:29.796802', '2024-10-08 19:52:29.796802', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Broward College', 'BrowardCollege', 'A public postsecondary institution offering academic, career, and workforce education in Fort Lauderdale, FL.', 'https://www.broward.edu/', 'Fort Lauderdale', 'FL', '33301', '2024-10-08 20:01:04.693360', '2024-10-08 20:01:04.693360', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Crowley Independent School District', 'CrowleyISD', 'A public education agency serving K-12 students and communities in Fort Worth, TX.', 'https://www.crowleyisdtx.org/', 'Fort Worth', 'TX', '76036', '2024-10-08 20:13:16.372261', '2024-10-08 20:13:16.372261', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Green Country Technology Center', 'GreenCountryTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Okmulgee, OK.', 'https://gctcok.edu/', 'Okmulgee', 'OK', '74447', '2024-10-08 20:32:36.204585', '2024-10-08 20:32:36.204585', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Greenville Technical College', 'GreenvilleTech', 'A public postsecondary institution offering academic, career, and workforce education in Greenville, SC.', 'https://gvltec.edu/', 'Greenville', 'SC', '29606', '2024-10-08 20:36:52.616612', '2024-10-08 20:36:52.616612', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Jersey City Public Schools', 'JerseyCityPS', 'A public education agency serving K-12 students and communities in Jersey City, NJ.', 'https://www.jcboe.org/', 'Jersey City', 'NJ', '07305', '2024-10-08 20:45:18.789404', '2024-10-08 20:45:18.789404', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Lake Taylor High School', 'LakeTaylorHS', 'A public high school serving students in Norfolk, VA.', 'https://www.npsk12.com/lths', 'Norfolk', 'VA', '23502', '2024-10-08 20:50:45.807064', '2024-10-08 20:50:45.807064', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Moore Norman Technology Center', 'MooreNormanTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Norman, OK.', 'https://www.mntc.edu/', 'Norman', 'OK', '73069', '2024-10-08 22:17:48.705825', '2024-10-08 22:17:48.705825', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Veteran Internships Providing Employment Readiness (VIPER) Transitions', 'ViperTransitions', 'A nonprofit that prepares veterans and transitioning service members for civilian employment through training, internships, and apprenticeships.', 'https://www.vipertransitions.org/', 'Anchorage', 'AK', '99502', '2024-10-08 22:32:06.800472', '2024-10-08 22:32:06.800472', 1, 'training_provider', 'adult_workforce', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Cape Fear Community College', 'CapeFearCC', 'A public community college offering academic and workforce programs, including career pilot training.', 'https://cfcc.edu/job-training/career-pilot-training/', 'Castle Hayne', 'NC', '28429', '2024-12-16 20:56:07.312608', '2024-12-16 20:56:07.312608', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Burke High School', 'BurkeHS', 'A public high school serving students in Omaha, NE.', 'https://www.ops.org/burke', 'Omaha', 'NE', '68154', '2024-12-16 21:09:34.492192', '2024-12-16 21:09:34.492192', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Franklin County Technical School', 'FranklinCTS', 'Provides career and technical education and workforce preparation for secondary and adult learners in Turners Falls, MA.', 'https://www.fcts.us/', 'Turners Falls', 'MA', '01376', '2025-01-06 14:17:54.692717', '2025-01-06 14:17:54.692717', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Tri County Tech', 'TriCountyTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Bartlesville, OK.', 'https://tricountytech.edu/', 'Bartlesville', 'OK', '74006', '2025-07-16 13:49:55.275254', '2025-09-19 15:25:09.626933', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('College Community School District', 'CollegeCommunitySD', 'A public education agency serving K-12 students and communities in Cedar Rapids, IA.', 'https://www.crprairie.org/', 'Cedar Rapids', 'IA', '52404', '2025-07-17 18:01:20.554622', '2025-07-17 18:01:20.554622', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Choose Aerospace Support', 'ChooseAerospace_Support', 'The internal organization used to administer and support the Choose Aerospace learning platform.', 'https://www.chooseaerospace.org/', 'Jenks', 'OK', '74037', '2025-07-18 19:05:33.915880', '2025-08-14 23:14:43.442238', 1, 'internal_program', 'not_applicable', 'internal')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('STAY Indiana', 'STAYIndiana', 'A nonprofit that introduces teenagers to aviation through aircraft building, flight instruction, and mentorship.', 'https://www.stayindiana.org/', 'Elkhart', 'IN', '46514', '2025-07-22 17:23:34.956091', '2025-07-22 17:23:34.956091', 1, 'education_nonprofit', 'high_school', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Union Public Schools', 'UnionPS', 'A public education agency serving K-12 students and communities in Tulsa, OK.', 'https://www.unionps.org/', 'Tulsa', 'OK', '74133', '2025-07-23 14:45:26.830733', '2025-07-23 14:45:26.830733', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Kiamichi Technology Center', 'KiamichiTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Wilburton, OK.', 'https://www.ktc.edu/', 'Wilburton', 'OK', '74578', '2025-07-24 12:48:27.024987', '2025-07-24 12:48:27.024987', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('North Arkansas College', 'NorthArkansasCollege', 'A public postsecondary institution offering academic, career, and workforce education in Harrison, AR.', 'https://www.northark.edu/', 'Harrison', 'AR', '72601', '2025-07-29 14:06:48.268883', '2025-07-29 14:06:48.268883', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Express Aviation Academy', 'ExpressAA', 'Prepares students ages 13 to 18 for aviation careers through STEM education, technical training, and FAA exam preparation.', 'https://expressaviationacademy.org/', 'Jenks', 'OK', '74037', '2025-07-29 18:35:51.828737', '2025-07-29 18:35:51.828737', 1, 'career_technical_center', 'high_school', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Ascension Academy', 'AscensionAcademy', 'A private high school serving students in Amarillo, TX.', 'https://www.ascensionacademy.org/', 'Amarillo', 'TX', '79119', '2025-08-04 13:48:32.279863', '2025-08-04 13:48:32.279863', 1, 'k12_school', 'high_school', 'private')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Cascadia Tech Academy', 'CascadiaTechAcademy', 'Provides career and technical education and workforce preparation for secondary and adult learners in Vancouver, WA.', 'https://www.evergreenps.org/', 'Vancouver', 'WA', '98668', '2025-08-04 19:47:54.098762', '2025-08-04 19:47:54.098762', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Dodge City High School', 'DodgeCityHS', 'A public high school serving students in Dodge City, KS.', 'https://usd443.org/', 'Dodge City', 'KS', '67801', '2025-08-05 14:27:12.926884', '2025-08-05 14:27:12.926884', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Bismarck Public Schools CRACTC', 'BismarckPS', 'A Bismarck Public Schools partnership providing virtual and hands-on CTE opportunities to member-school students.', 'https://cractc.org/', 'Bismarck', 'ND', '58501', '2025-08-18 13:32:54.332650', '2025-08-18 14:36:48.376884', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('SEKCTEC', 'SEKCTEC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Pittsburg, KS.', 'https://wsutech.edu/', 'Pittsburg', 'KS', '66762', '2025-08-19 16:00:34.920317', '2025-08-19 16:00:34.920317', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Walden Grove High School', 'WaldenGroveHS', 'A public high school serving students in Sahuarita, AZ.', 'https://susd30.us/schools/walden-grove-high-school/', 'Sahuarita', 'AZ', '85629', '2025-08-27 14:13:29.121448', '2025-08-27 14:13:29.121448', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organization (source record; already inserted above): School District of Philadelphia
INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('School District of Philadelphia', 'PhiladelphiaSD', 'A public education agency serving K-12 students and communities in Philadelphia, PA.', 'https://www.philasd.org/', 'Philadelphia', 'PA', '19130', '2025-08-28 18:08:55.434303', '2025-08-28 18:08:55.434303', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Calhoun Community College', 'CalhounCC', 'A public postsecondary institution offering academic, career, and workforce education in Decatur, AL.', 'https://www.calhoun.edu/', 'Decatur', 'AL', '35609', '2025-08-28 19:04:13.153051', '2025-08-28 19:04:13.153051', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Spring Valley High School', 'SpringValleyHS', 'A public high school serving students in Huntington, WV.', 'https://svhs.wayn.k12.wv.us/o/spvhs/', 'Huntington', 'WV', '25704', '2025-08-28 19:13:27.313592', '2025-09-03 18:21:28.044688', 1, 'k12_school', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Ponca City Public Schools', 'poncacityps', 'A public education agency serving K-12 students and communities in Ponca City, OK.', 'https://www.pcps.us/', 'Ponca City', 'OK', '74601', '2025-09-10 17:18:19.752009', '2025-09-10 17:18:19.752009', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('The Hub For Innovative Learning & Leadership', 'hubforinnovativell', 'A Fayette County public career and technical school connecting students with hands-on career pathways.', 'https://hill.fcps.net/about-us', 'Lexington', 'KY', '40508', '2025-09-10 19:34:34.665538', '2025-09-10 19:34:34.665538', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('AAR Aircraft Services, Inc.', 'AARAircraftServices', 'An aviation services company providing aircraft maintenance, repair, overhaul, and workforce opportunities.', 'https://www.aarcorp.com/', 'Wood Dale', 'IL', '60191', '2025-10-31 20:10:41.645898', '2025-10-31 20:11:10.351382', 1, 'employer', 'adult_workforce', 'private_for_profit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Trumbull Career and Technical Center', 'TrumbullCareerTC', 'Provides career and technical education and workforce preparation for secondary and adult learners in Warren, OH.', 'https://www.tctchome.com/', 'Warren', 'OH', '44483', '2026-01-08 13:17:08.109160', '2026-01-08 13:17:08.109160', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('CTEC Salem-Keizer School District', 'CTECSalemKeizerSD', 'A public career and technical education center offering high school students hands-on professional and technical programs.', 'https://ctec.salkeiz.k12.or.us/about', 'Salem', 'OR', '97305', '2026-01-30 18:23:58.219078', '2026-01-30 18:23:58.219078', 1, 'career_technical_center', 'secondary_adult', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Madisonville Community College', 'MadisonvilleCC', 'A public comprehensive community college offering transfer, technical, workforce, adult-education, and enrichment programs.', 'https://madisonville.kctcs.edu/', 'Madisonville', 'KY', '42431', '2026-02-03 14:18:09.220325', '2026-02-03 14:18:09.220325', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Colorado River BOCES', 'ColoradoRiverBOCES', 'A public education agency serving K-12 students and communities in Parachute, CO.', 'https://www.crboces.org/', 'Parachute', 'CO', '81635', '2026-02-03 19:34:42.627642', '2026-02-03 19:34:42.627642', 1, 'school_district', 'k12', 'government')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('ATEC Academy', 'ATECAcademy', 'The Choose Aerospace independent-study program for online FAA Mechanic General coursework and aviation maintenance preparation.', 'https://www.chooseaerospace.org/independent-study.html', 'Jenks', 'OK', '74037', '2026-03-06 16:36:56.119431', '2026-03-06 16:36:56.119431', 1, 'internal_program', 'secondary_adult', 'internal')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Catawba Valley Community College', 'CatawbaValleyCC', 'A public postsecondary institution offering academic, career, and workforce education in Hickory, NC.', 'https://www.cvcc.edu/', 'Hickory', 'NC', '28602', '2026-05-08 14:34:45.066380', '2026-05-08 14:34:45.066380', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Pueblo Community College', 'PuebloCC', 'A public postsecondary institution offering academic, career, and workforce education in Pueblo, CO.', 'https://pueblocc.edu/', 'Pueblo', 'CO', '81004', '2026-05-26 17:41:00.817757', '2026-05-26 17:41:00.817757', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO chooseaerospace_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('St. Joseph School District', 'StJosephSD', 'A public education agency serving K-12 students and communities in St. Joseph, MO.', 'https://www.sjsd.k12.mo.us/', 'St. Joseph', 'MO', '64506', '2026-07-07 14:15:47.611384', '2026-07-07 14:15:47.611384', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Assign child organizations to the parent organizations inserted above.
INSERT IGNORE INTO chooseaerospace_prod_openedx.organizations_organization_parent_organizations (
    from_organization_id,
    to_organization_id
)
SELECT child.id, parent.id
FROM chooseaerospace_prod_openedx.organizations_organization AS child
INNER JOIN (
    SELECT 'LibertyHS' AS child_short_name, 'HillsboroSD' AS parent_short_name
    UNION ALL SELECT 'CharlesPageHS', 'SandSpringsPS'
    UNION ALL SELECT 'PryorHS', 'PryorPS'
    UNION ALL SELECT 'NewcastleHS', 'NewcastlePS'
    UNION ALL SELECT 'BartlesvilleHS', 'BartlesvillePS'
    UNION ALL SELECT 'BristowHS', 'BristowPS'
    UNION ALL SELECT 'OiltonHS', 'OiltonPS'
    UNION ALL SELECT 'VanguardAcademy', 'BrokenArrowPS'
    UNION ALL SELECT 'MoorePublicSchoolsWestmoore', 'MoorePS'
    UNION ALL SELECT 'FrankfordHS', 'PhiladelphiaSD'
    UNION ALL SELECT 'WesternHeightsHS', 'WesternHeightsPS'
    UNION ALL SELECT 'CollinsvilleHS', 'CollinsvillePS'
    UNION ALL SELECT 'DavisAerospaceTHS', 'DetroitPSCD'
    UNION ALL SELECT 'EastCentralHS', 'TulsaPS'
    UNION ALL SELECT 'MoorePublicSchoolsSouthmoore', 'MoorePS'
    UNION ALL SELECT 'MoorePublicSchoolsMooreHigh', 'MoorePS'
    UNION ALL SELECT 'OkmulgeeHS', 'OkmulgeePS'
    UNION ALL SELECT 'WellingtonHS', 'WellingtonUSD353'
    UNION ALL SELECT 'DurantHS', 'DurantISD'
    UNION ALL SELECT 'OliveHS', 'OlivePS'
    UNION ALL SELECT 'GatewayAcademy', 'ChristianCountyPS'
    UNION ALL SELECT 'HoodRiverValleyHS', 'HoodRiverCountySD'
    UNION ALL SELECT 'GoddardHS', 'RoswellISD'
    UNION ALL SELECT 'McKinneyNorthHS', 'McKinneyISD'
    UNION ALL SELECT 'ChelseaHS', 'ChelseaPS'
    UNION ALL SELECT 'MarionHS', 'MarionCUSD2'
    UNION ALL SELECT 'SilverLakeHS', 'SilverLakeRSD'
    UNION ALL SELECT 'RossSterlingAHS', 'HoustonISD'
    UNION ALL SELECT 'WillistonHS', 'WillistonBasinSD7'
    UNION ALL SELECT 'DubiskiCareerHS', 'GrandPrairieISD'
    UNION ALL SELECT 'MidDelTechCenter', 'MidDelPS'
    UNION ALL SELECT 'LakeTaylorHS', 'NorfolkPS'
    UNION ALL SELECT 'BurkeHS', 'OmahaPS'
    UNION ALL SELECT 'ChooseAerospace_Support', 'CA'
    UNION ALL SELECT 'CascadiaTechAcademy', 'EvergreenPS'
    UNION ALL SELECT 'DodgeCityHS', 'DodgeCityUSD443'
    UNION ALL SELECT 'BismarckPS', 'BismarckPSD'
    UNION ALL SELECT 'WaldenGroveHS', 'SahuaritaUSD'
    UNION ALL SELECT 'SpringValleyHS', 'WayneCS'
    UNION ALL SELECT 'hubforinnovativell', 'FayetteCountyPS'
    UNION ALL SELECT 'CTECSalemKeizerSD', 'SalemKeizerPS'
    UNION ALL SELECT 'ATECAcademy', 'CA'
) AS relationship
    ON relationship.child_short_name = child.short_name
INNER JOIN chooseaerospace_prod_openedx.organizations_organization AS parent
    ON parent.short_name = relationship.parent_short_name;

COMMIT;

-- Verification: this should return 113 Choose Aerospace organizations whose
-- type is valid under the compact organization_type taxonomy.
SELECT COUNT(*) AS classified_organization_count
FROM chooseaerospace_prod_openedx.organizations_organization
WHERE short_name IN ('CA', 'DesMoinesPS', 'LibertyHS', 'SAMSAcademy', 'CharlesPageHS', 'BethlehemAVTS', 'MetroTC', 'PryorHS', 'NewcastleHS', 'BartlesvilleHS', 'BristowHS', 'OiltonHS', 'GreatPlainsTC', 'RisingAviationHS', 'VanguardAcademy', 'MoorePublicSchoolsWestmoore', 'YukonPS', 'FrankfordHS', 'WesternHeightsHS', 'CollinsvilleHS', 'PayetteRiverTA', 'DavisAerospaceTHS', 'WeatherfordPS', 'ClevelandPS', 'SomersetCTC', 'EaglesNestPW', 'USAviationAcademy', 'ViennaHS', 'AlabamaAAHS', 'WestMichiganAA', 'EastCentralHS', 'MoorePublicSchoolsSouthmoore', 'PutnamCitySchools', 'MoorePublicSchoolsMooreHigh', 'ATSmro', 'WTA4USA', 'FlightExpo', 'GreenbrierCA', 'CapeCodCC', 'OkmulgeeHS', 'SouthernTech', 'WellingtonHS', 'DurantHS', 'SouthwesternIllinoisCollege', 'OliveHS', 'MentoringMission', 'GatewayAcademy', 'WayneCS', 'HoodRiverValleyHS', 'GoddardHS', 'McKinneyNorthHS', 'PolarisCC', 'ChelseaHS', 'SIU', 'SWTech', 'ShenandoahValleyGS', 'BrokenArrowPS', 'MarionHS', 'RisingTideCPS', 'SilverLakeHS', 'FultonLA', 'AmericanIntlAcademy', 'RossSterlingAHS', 'WillistonHS', 'IDEAFamilies', 'ButlerTech', 'TuskegeeAirmenNM', 'AdaCitySchools', 'DubiskiCareerHS', 'GrandIslandPS', 'JeffersonUnion', 'McAlesterPublicSchools', 'MidDelTechCenter', 'BristolBayRegionCTE', 'BrowardCollege', 'CrowleyISD', 'GreenCountryTC', 'GreenvilleTech', 'JerseyCityPS', 'LakeTaylorHS', 'MooreNormanTC', 'ViperTransitions', 'CapeFearCC', 'BurkeHS', 'FranklinCTS', 'TriCountyTC', 'CollegeCommunitySD', 'ChooseAerospace_Support', 'STAYIndiana', 'UnionPS', 'KiamichiTC', 'NorthArkansasCollege', 'ExpressAA', 'AscensionAcademy', 'CascadiaTechAcademy', 'DodgeCityHS', 'BismarckPS', 'SEKCTEC', 'WaldenGroveHS', 'PhiladelphiaSD', 'CalhounCC', 'SpringValleyHS', 'poncacityps', 'hubforinnovativell', 'AARAircraftServices', 'TrumbullCareerTC', 'CTECSalemKeizerSD', 'MadisonvilleCC', 'ColoradoRiverBOCES', 'ATECAcademy', 'CatawbaValleyCC', 'PuebloCC', 'StJosephSD')
  AND organization_type IN (
    'k12_school', 'school_district', 'career_technical_center', 'homeschool',
    'college_university', 'training_provider', 'workforce_agency',
    'education_nonprofit', 'education_technology', 'employer',
    'government_agency', 'internal_program', 'other', 'unknown'
  )
  AND education_level IS NOT NULL
  AND governance_type IS NOT NULL
  AND description IS NOT NULL
  AND description <> '';

-- Verification: every configured relationship should resolve to its expected parent.
SELECT child.short_name AS child_short_name, parent.short_name AS parent_short_name
FROM chooseaerospace_prod_openedx.organizations_organization AS child
INNER JOIN chooseaerospace_prod_openedx.organizations_organization_parent_organizations AS relationship
    ON relationship.from_organization_id = child.id
INNER JOIN chooseaerospace_prod_openedx.organizations_organization AS parent
    ON parent.id = relationship.to_organization_id
WHERE child.short_name IN (
    'LibertyHS', 'CharlesPageHS', 'PryorHS', 'NewcastleHS', 'BartlesvilleHS',
    'BristowHS', 'OiltonHS', 'VanguardAcademy', 'MoorePublicSchoolsWestmoore',
    'FrankfordHS', 'WesternHeightsHS', 'CollinsvilleHS', 'DavisAerospaceTHS',
    'EastCentralHS', 'MoorePublicSchoolsSouthmoore', 'MoorePublicSchoolsMooreHigh',
    'OkmulgeeHS', 'WellingtonHS', 'DurantHS', 'OliveHS', 'GatewayAcademy',
    'HoodRiverValleyHS', 'GoddardHS', 'McKinneyNorthHS', 'ChelseaHS', 'MarionHS',
    'SilverLakeHS', 'RossSterlingAHS', 'WillistonHS', 'DubiskiCareerHS',
    'MidDelTechCenter', 'LakeTaylorHS', 'BurkeHS', 'ChooseAerospace_Support',
    'CascadiaTechAcademy', 'DodgeCityHS', 'BismarckPS', 'WaldenGroveHS',
    'SpringValleyHS', 'hubforinnovativell', 'CTECSalemKeizerSD', 'ATECAcademy'
)
ORDER BY child.short_name;
