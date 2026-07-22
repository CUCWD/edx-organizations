-- Insert or backfill classifications for the SkilRedi Open edX site.
-- Run after organizations migration 0007_organization_and_parent_website_location.
-- The unique short_name key makes
-- each statement idempotent. New records retain the source created, modified,
-- and active values. Existing records update the reviewed description plus
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

-- Parent organizations must be inserted before the child organizations that reference them.
INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES
    -- Parent organization: Clemson University
    ('Clemson University', 'Clemson', 'A public research university offering academic, continuing, and workforce education in Clemson, SC.', 'https://www.clemson.edu/', 'Clemson', 'SC', '29634', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'college_university', 'postsecondary', 'public'),
    -- Parent organization: Colleton County School District
    ('Colleton County School District', 'ColletonCountySD', 'A public K-12 school district serving Colleton County, SC.', 'https://www.colleton.k12.sc.us/', null, 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: School District of Pickens County
    ('School District of Pickens County', 'PickensCountySD', 'A public K-12 school district serving Pickens County, SC.', 'https://www.pickens.k12.sc.us/', null, 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Sumter School District
    ('Sumter School District', 'SumterSD', 'A public K-12 school district serving Sumter County, SC.', 'https://www.sumterschools.net/', 'Sumter', 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Greenville County Schools
    ('Greenville County Schools', 'GreenvilleCS', 'A public K-12 school district for Greenville, SC.', 'https://www.greenville.k12.sc.us/', 'Greenville', 'SC', '29601', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Richland One School District
    ('Richland One School District', 'RichlandOneSD', 'A public K-12 school district serving Columbia, SC.', 'https://www.richlandone.org/', 'Columbia', 'SC', '29201', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Lexington County School District Two
    ('Lexington County School District Two', 'LexingtonTwoSD', 'A public K-12 school district serving communities in Lexington County, SC.', 'https://www.lex2.org/', null, 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Richland School District Two
    ('Richland School District Two', 'RichlandTwoSD', 'A public K-12 school district serving communities in Richland County, SC.', 'https://www.richland2.org/', 'Columbia', 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Kershaw County School District
    ('Kershaw County School District', 'KershawCountySD', 'A public K-12 school district serving Kershaw County, SC.', 'https://www.kcsdschools.net/', 'Camden', 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public'),
    -- Parent organization: Abbeville County School District
    ('Abbeville County School District', 'AbbevilleCountySD', 'A public K-12 school district serving Abbeville County, SC.', 'https://www.acsdsc.org/', 'Abbeville', 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    short_name = VALUES(short_name);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('SkilRedi', 'SKILREDI', 'An online learning platform that delivers immersive technical education and workforce-development content.', 'https://skilredi.com', 'Greenville', 'SC', '29607', '2025-07-06 13:45:36.485378', '2026-06-10 14:19:33.794785', 1, 'education_technology', 'adult_workforce', 'private')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('RECITEXR', 'RECITEXR', 'An NSF-supported collaborative that advances the use of extended reality technologies in STEM technician education.', 'https://recitexr.org/', null, null, null, '2025-07-09 14:28:35.604230', '2025-07-09 14:28:35.604230', 1, 'education_nonprofit', 'postsecondary', 'unknown')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Alabama Industrial Development Training', 'AIDT', 'A state workforce-development agency that provides recruitment, training, and leadership-development services.', 'https://www.aidt.edu/', 'Montgomery', 'AL', '36116', '2025-07-18 15:33:43.045197', '2025-07-18 15:33:43.045197', 1, 'workforce_agency', 'adult_workforce', 'state_government')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Revolutionizing Electric Vehicle Education', 'REVVED', 'A Clemson-led consortium developing electric-vehicle education, training resources, and workforce pathways.', 'https://news.clemson.edu/revved-consortium/', 'Clemson', 'SC', '29634', '2025-07-18 17:21:15.247776', '2025-07-18 17:21:15.247776', 1, 'education_nonprofit', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Trident Technical College', 'TridentTC', 'A public postsecondary institution offering academic, career, and workforce education in North Charleston, SC.', 'https://www.tridenttech.edu/', 'North Charleston', 'SC', '29406', '2025-08-14 11:15:59.198248', '2025-08-14 11:15:59.198248', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Thunderbolt Career and Technology Center', 'ThunderboltCTC', 'Provides career and technical education and workforce preparation for secondary students in Walterboro, SC.', 'https://tctc.colleton.k12.sc.us/o/tct', 'Walterboro', 'SC', '29488', '2025-08-19 16:00:27.075956', '2025-08-19 16:00:27.075956', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Gettys Middle School', 'GettysMS', 'A public middle school serving students in Easley, SC.', 'https://gms.pickens.k12.sc.us/o/gms/', 'Easley', 'SC', '29640', '2025-08-20 14:11:24.154312', '2025-08-20 14:11:24.154312', 1, 'k12_school', 'middle_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Pickens County Career and Technology Center', 'PCCTC', 'Provides career and technical education and workforce preparation for secondary students in Liberty, SC.', 'https://ctc.pickens.k12.sc.us/o/ctc/', 'Liberty', 'SC', '29657', '2025-08-20 14:12:53.145898', '2025-12-09 18:44:40.801325', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Daniel Morgan Technology Center', 'DanielMorganTC', 'Provides career and technical education and workforce preparation for secondary students in Spartanburg, SC.', 'https://www.dmtconline.org/o/dmts', 'Spartanburg', 'SC', '29307', '2025-08-20 14:21:45.027315', '2025-08-20 14:21:45.027315', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Sumter Career and Technology Center', 'SumterCTC', 'Provides career and technical education and workforce preparation for secondary students in Sumter, SC.', 'https://sctc.sumterschools.net/', 'Sumter', 'SC', '29154', '2025-08-20 14:23:20.466770', '2025-08-20 14:23:20.466770', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Enoree Career Center', 'EnoreeCC', 'Provides career and technical education and workforce preparation for secondary students in Greenville, SC.', 'https://www.greenville.k12.sc.us/enoree/', 'Greenville', 'SC', '29617', '2025-08-20 14:25:28.419342', '2025-08-20 14:25:28.419342', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Heyward Career and Technology Center', 'HeywardCTC', 'Provides career and technical education and workforce preparation for secondary students in Columbia, SC.', 'https://heyward.richlandone.org/', 'Columbia', 'SC', '29204', '2025-08-28 15:14:32.304989', '2025-12-09 18:44:31.429687', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Lexington Two Innovation Center', 'LexingtonTwoIC', 'Provides career and technical education and workforce preparation for secondary students in Cayce, SC.', 'https://l2ic.lex2.org/', 'Cayce', 'SC', '29033', '2025-08-28 16:57:50.372410', '2026-06-23 19:30:47.350772', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Piedmont Technical College', 'PiedmontTC', 'A public postsecondary institution offering academic, career, and workforce education in Greenwood, SC.', 'https://www.ptc.edu/', 'Greenwood', 'SC', '29648', '2025-09-09 17:28:51.315993', '2025-09-09 17:28:51.315993', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organization (source record; already inserted above): Clemson University
INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Clemson University', 'Clemson', 'A public postsecondary institution offering academic, career, and workforce education in Clemson, SC.', 'https://www.clemson.edu/', 'Clemson', 'SC', '29634', '2025-10-08 15:38:35.948046', '2025-10-08 18:02:22.184756', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Lakeview Middle School', 'LakeviewMS', 'A public middle school serving students in Greenville, SC.', 'https://www.greenville.k12.sc.us/lakeview/', 'Greenville', 'SC', '29617', '2025-12-02 16:20:20.608730', '2025-12-02 16:20:20.608730', 1, 'k12_school', 'middle_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Technical College of the Lowcountry', 'TCLowcountry', 'A public postsecondary institution offering academic, career, and workforce education in Beaufort, SC.', 'https://www.tcl.edu/', 'Beaufort', 'SC', '29902', '2026-01-05 18:40:32.262994', '2026-01-05 18:40:32.262994', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Richland Two Innovation Center', 'RichlandTwoInnovationCenter', 'Provides career and technical education and workforce preparation for secondary students in Columbia, SC.', 'https://r2i2.org/', 'Columbia', 'SC', '29223', '2026-02-10 20:09:35.227286', '2026-02-10 20:09:35.227286', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Denmark Technical College', 'DenmarkTC', 'A public postsecondary institution offering academic, career, and workforce education in Denmark, SC.', 'https://www.denmarktech.edu/', 'Denmark', 'SC', '29042', '2026-02-11 20:40:50.750946', '2026-02-11 20:40:50.750946', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Greenville Technical College', 'GreenvilleTC', 'A public postsecondary institution offering academic, career, and workforce education in Greenville, SC.', 'https://www.gvltec.edu/', 'Greenville', 'SC', '29606', '2026-02-26 18:01:17.709236', '2026-02-26 18:01:17.709236', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('CUCWD', 'CUCWD', 'Develops educational resources, digital learning tools, and research supporting the technical workforce.', 'https://cecas.clemson.edu/cucwd/about/', null, null, null, '2026-05-15 13:06:53.697115', '2026-05-15 13:06:53.697115', 1, 'workforce_agency', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organization (source record; already inserted above): Greenville County Schools
INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Greenville County Schools', 'GreenvilleCS', 'A public K-12 school district for Greenville, SC.', 'https://www.greenville.k12.sc.us/', 'Greenville', 'SC', '29601', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Beck Academy', 'GCSBeckAcademy', 'A public middle school serving students in Greenville County School district.', 'https://www.greenville.k12.sc.us/', 'Greenville', 'SC', '29607', '2026-05-29 13:36:52.681094', '2026-06-04 15:58:13.620973', 1, 'k12_school', 'middle_school', 'public')
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

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Anderson School District 4', 'AndersonSD4', 'A public education agency serving K-12 students and communities in Pendleton, SC.', 'https://www.anderson4.org/', 'Pendleton', 'SC', '29670', '2026-06-01 17:06:16.241673', '2026-06-01 17:06:16.241673', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

-- Parent organization (source record; already inserted above): Richland One School District
INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Richland One School District', 'RichlandOneSD', 'A public education agency serving K-12 students and communities in Columbia, SC.', 'https://www.richlandone.org/', 'Columbia', 'SC', '29201', '2026-06-01 18:19:18.055570', '2026-06-01 18:19:18.055570', 1, 'school_district', 'k12', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Woolard Technology Center', 'WoolardTC', 'Provides career and technical education and workforce preparation for secondary students in Camden, SC.', 'https://www.kcsdschools.net/', 'Camden', 'SC', '29020', '2026-06-01 18:53:45.802345', '2026-06-01 18:53:45.802345', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Abbeville County Career Center', 'AbbevilleCountyCC', 'Provides career and technical education and workforce preparation for secondary students in Abbeville, SC.', 'https://www.acsdsc.org/', 'Abbeville', 'SC', '29620', '2026-06-01 19:43:28.008023', '2026-06-01 19:43:28.008023', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Hughes Academy', 'HughesAcademy', 'A public middle school serving students in Greenville, SC.', 'https://www.greenville.k12.sc.us/hughes/', 'Greenville', 'SC', '29605', '2026-06-01 20:09:43.566770', '2026-06-01 20:09:43.566770', 1, 'k12_school', 'middle_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Dorchester County Career Technology Center', 'DorchesterCountyCTC', 'Provides career and technical education and workforce preparation for secondary students in Dorchester, SC.', 'https://www.dcctc.net/', 'Dorchester', 'SC', '29437', '2026-06-22 15:34:55.028398', '2026-06-22 15:34:55.028398', 1, 'career_technical_center', 'high_school', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO skilredi_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Monroe County Community College', 'MonroeCountyCC', 'A public postsecondary institution offering academic, career, and workforce education in Monroe, MI.', 'https://www.monroeccc.edu/', 'Monroe', 'MI', '48161', '2026-06-22 19:33:31.855844', '2026-06-22 19:33:31.855844', 1, 'college_university', 'postsecondary', 'public')
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
UPDATE skilredi_prod_openedx.organizations_organization AS child
INNER JOIN (
    SELECT 'REVVED' AS child_short_name, 'Clemson' AS parent_short_name
    UNION ALL SELECT 'ThunderboltCTC', 'ColletonCountySD'
    UNION ALL SELECT 'GettysMS', 'PickensCountySD'
    UNION ALL SELECT 'PCCTC', 'PickensCountySD'
    UNION ALL SELECT 'SumterCTC', 'SumterSD'
    UNION ALL SELECT 'EnoreeCC', 'GreenvilleCS'
    UNION ALL SELECT 'HeywardCTC', 'RichlandOneSD'
    UNION ALL SELECT 'LexingtonTwoIC', 'LexingtonTwoSD'
    UNION ALL SELECT 'LakeviewMS', 'GreenvilleCS'
    UNION ALL SELECT 'RichlandTwoInnovationCenter', 'RichlandTwoSD'
    UNION ALL SELECT 'CUCWD', 'Clemson'
    UNION ALL SELECT 'GCSBeckAcademy', 'GreenvilleCS'
    UNION ALL SELECT 'WoolardTC', 'KershawCountySD'
    UNION ALL SELECT 'AbbevilleCountyCC', 'AbbevilleCountySD'
    UNION ALL SELECT 'HughesAcademy', 'GreenvilleCS'
) AS relationship
    ON relationship.child_short_name = child.short_name
INNER JOIN skilredi_prod_openedx.organizations_organization AS parent
    ON parent.short_name = relationship.parent_short_name
SET child.parent_organization_id = parent.id
WHERE NOT (child.parent_organization_id <=> parent.id);

COMMIT;

-- Verification: this should return 30 SkilRedi organizations whose type is
-- valid under the compact organization_type taxonomy.
SELECT COUNT(*) AS classified_organization_count
FROM skilredi_prod_openedx.organizations_organization
WHERE short_name IN ('SKILREDI', 'RECITEXR', 'AIDT', 'REVVED', 'TridentTC', 'ThunderboltCTC', 'GettysMS', 'PCCTC', 'DanielMorganTC', 'SumterCTC', 'EnoreeCC', 'HeywardCTC', 'LexingtonTwoIC', 'PiedmontTC', 'Clemson', 'LakeviewMS', 'TCLowcountry', 'RichlandTwoInnovationCenter', 'DenmarkTC', 'GreenvilleTC', 'CUCWD', 'GreenvilleCS', 'GCSBeckAcademy', 'AndersonSD4', 'RichlandOneSD', 'WoolardTC', 'AbbevilleCountyCC', 'HughesAcademy', 'DorchesterCountyCTC', 'MonroeCountyCC')
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

-- Verification: this should return the Beck Academy-to-district relationship.
SELECT
    child.short_name AS child_short_name,
    parent.short_name AS parent_short_name
FROM skilredi_prod_openedx.organizations_organization AS child
INNER JOIN skilredi_prod_openedx.organizations_organization AS parent
    ON parent.id = child.parent_organization_id
WHERE child.short_name = 'GCSBeckAcademy'
  AND parent.short_name = 'GreenvilleCS';

-- Verification: every configured relationship should resolve to its expected parent.
SELECT child.short_name AS child_short_name, parent.short_name AS parent_short_name
FROM skilredi_prod_openedx.organizations_organization AS child
INNER JOIN skilredi_prod_openedx.organizations_organization AS parent
    ON parent.id = child.parent_organization_id
WHERE child.short_name IN (
    'REVVED', 'ThunderboltCTC', 'GettysMS', 'PCCTC', 'SumterCTC',
    'EnoreeCC', 'HeywardCTC', 'LexingtonTwoIC', 'LakeviewMS',
    'RichlandTwoInnovationCenter', 'CUCWD', 'GCSBeckAcademy', 'WoolardTC',
    'AbbevilleCountyCC', 'HughesAcademy'
)
ORDER BY child.short_name;
