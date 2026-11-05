-- Insert or backfill classifications for the EducateWorkforce Open edX site.
-- Run after organizations migration 0008_remove_historicalorganization_parent_organization_and_more.
-- The unique short_name key makes each statement idempotent. New records retain
-- the source created, modified, and active values. Existing records update the
-- reviewed description plus the location, website, and classification fields
-- listed in ON DUPLICATE KEY UPDATE.
-- Parent organization upserts also synchronize the active field.
-- Incoming NULL locations preserve any location already stored on a duplicate.
-- website_url stores the supporting organization page separately from the
-- concise, human-readable description.
-- Classifications were reviewed against the consolidated migration taxonomy and
-- the organizations' public descriptions. Internal Clemson project workspaces
-- are classified conservatively when no public project page was available.
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
INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES
    -- Parent organization: Clemson University
    ('Clemson University', 'Clemson', 'A public research university offering undergraduate, graduate, continuing, and workforce education in Clemson, SC.', 'https://www.clemson.edu/', 'Clemson', 'SC', '29634', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'college_university', 'postsecondary', 'public'),
    -- Parent organization: State University of New York
    ('State University of New York', 'SUNY', 'A public system of colleges and universities serving learners throughout New York.', 'https://www.suny.edu/', null, 'NY', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'college_university', 'postsecondary', 'public'),
    -- Parent organization: Cybersecurity Manufacturing Innovation Institute
    ('Cybersecurity Manufacturing Innovation Institute', 'CyManII', 'A public-private manufacturing innovation institute advancing cybersecurity for U.S. manufacturers.', 'https://cymanii.org/', 'San Antonio', 'TX', '78249', CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'workforce_agency', 'adult_workforce', 'cooperative'),
    -- Parent organization: South Carolina Technical College System
    ('South Carolina Technical College System', 'SCTCS', 'A public statewide system supporting technical colleges and workforce education in South Carolina.', 'https://www.sctechsystem.edu/', null, 'SC', null, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), 1, 'government_agency', 'postsecondary', 'state_government')
ON DUPLICATE KEY UPDATE
    short_name = VALUES(short_name),
    active = VALUES(active);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Revolutionizing Electric Vehicle Education', 'REVVED', 'A Clemson-led consortium developing electric-vehicle education, training resources, and workforce pathways.', 'https://news.clemson.edu/revved-consortium/', 'Clemson', 'SC', '29634', '2025-09-11 15:50:05.783435', '2025-09-22 18:28:11.245876', 1, 'education_nonprofit', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Co-DREAM OER', 'CO-DREAM-OER', 'A Clemson-led U.S. Department of Education project creating open textbooks, virtual-reality simulations, and interactive materials for mechatronics and advanced-manufacturing education.', 'https://libraries.clemson.edu/teaching/open-ed/oer-development-projects/co-dream-oer-supplemental-grant/', 'Clemson', 'SC', '29634', '2025-09-11 16:23:46.350437', '2025-09-11 16:23:46.350437', 1, 'internal_program', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Manufacturing Engineering Education Program', 'MEEP', 'A Clemson manufacturing-engineering education project developing robotics and advanced-manufacturing training resources for the technical workforce.', 'https://clemson.sharepoint.com/teams/TIME-for-Robotics-MEEP', 'Clemson', 'SC', '29634', '2025-09-22 13:59:57.099189', '2025-09-22 13:59:57.099189', 1, 'internal_program', 'adult_workforce', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('U.S. Department of Energy', 'USDOE', 'The federal agency addressing national energy, environmental, and nuclear-security challenges through science and technology.', 'https://www.energy.gov/', 'Washington', 'DC', '20585', '2025-09-22 14:36:06.834933', '2025-09-22 14:36:06.834933', 1, 'government_agency', 'not_applicable', 'federal_government')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('The Composites IACMI Institute', 'IACMI', 'A public-private manufacturing innovation institute that advances composite technologies through research, commercialization, and workforce development.', 'https://iacmi.org/', 'Knoxville', 'TN', '37932', '2025-09-22 18:02:49.435142', '2025-09-22 18:02:49.435142', 1, 'workforce_agency', 'adult_workforce', 'cooperative')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Manufacturing Skill Standards Council', 'MSSC', 'An industry-led nonprofit training, assessment, and certification system for front-line production and material-handling technicians.', 'https://www.msscusa.org/', 'Alexandria', 'VA', '22314', '2025-09-22 18:30:15.157532', '2025-09-22 18:30:15.157532', 1, 'training_provider', 'postsecondary_nondegree', 'nonprofit')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Automotive and Aviation Grant', 'A2Grant', 'A Clemson workforce-education project developing technical training resources for the automotive and aviation sectors.', 'https://clemson.sharepoint.com/teams/A2Grant', 'Clemson', 'SC', '29634', '2025-09-26 12:17:25.048050', '2025-09-26 13:18:54.758216', 1, 'internal_program', 'adult_workforce', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('SUNY Ulster Community College', 'SUNYUlsterCC', 'A public community college offering academic programs, career education, and workforce training in Stone Ridge, NY.', 'https://www.sunyulster.edu/', 'Stone Ridge', 'NY', '12484', '2025-10-01 00:30:04.310834', '2025-10-01 00:30:04.310834', 1, 'college_university', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('WaterDROPS (Developing Resources for Water OPeratorS)', 'WaterDROPS', 'A Clemson workforce-education project developing accessible training resources for water operators.', 'https://clemson.sharepoint.com/teams/WaterDROPS', 'Clemson', 'SC', '29634', '2025-10-01 17:53:12.870605', '2025-10-01 17:53:12.870605', 1, 'internal_program', 'adult_workforce', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('AIM Photonics', 'AIMPhotonics', 'A public-private manufacturing innovation institute that advances integrated photonics and provides education and workforce-development programs.', 'https://www.aimphotonics.com/education-workforce-development-2', 'Albany', 'NY', '12203', '2025-10-02 13:48:03.296444', '2025-10-02 13:48:03.296444', 1, 'workforce_agency', 'adult_workforce', 'cooperative')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Clemson University Center for Workforce Development', 'CUCWD', 'Develops educational resources, digital learning tools, and research supporting the technical workforce.', 'https://cecas.clemson.edu/cucwd/', 'Clemson', 'SC', '29634', '2025-10-03 13:07:32.291155', '2025-10-03 13:07:32.291155', 1, 'workforce_agency', 'postsecondary', 'public')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Transportation Cyber-Physical-Social Systems Laboratory', 'TraCR', 'A Clemson-led national research center developing tools, testbeds, and guidance to improve transportation cybersecurity and resiliency.', 'https://www.clemson.edu/cecas/tracr/index.html', 'Greenville', 'SC', '29607', '2025-10-03 13:41:01.120167', '2025-10-03 13:41:01.120167', 1, 'internal_program', 'postsecondary', 'public')
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
INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Clemson University', 'Clemson', 'A public research university offering undergraduate, graduate, continuing, and workforce education in Clemson, SC.', 'https://www.clemson.edu/', 'Clemson', 'SC', '29634', '2025-10-08 18:02:55.140247', '2025-10-08 18:02:55.140247', 1, 'college_university', 'postsecondary', 'public')
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

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('TrustWorks-aaS CyManII', 'TRUSTWORKS', 'A CyManII education and workforce-development program that provides cybersecurity learning resources for U.S. manufacturers.', 'https://cymanii.org/education-and-workforce-development/', 'San Antonio', 'TX', '78249', '2025-10-09 12:48:47.879545', '2025-10-09 12:48:47.879545', 1, 'training_provider', 'adult_workforce', 'cooperative')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    city = COALESCE(VALUES(city), city),
    state = COALESCE(VALUES(state), state),
    zipcode = COALESCE(VALUES(zipcode), zipcode),
    website_url = COALESCE(NULLIF(VALUES(website_url), ''), website_url),
    organization_type = VALUES(organization_type),
    education_level = VALUES(education_level),
    governance_type = VALUES(governance_type);

INSERT INTO educateworkforce_prod_openedx.organizations_organization (name, short_name, description, website_url, city, state, zipcode, created, modified, active, organization_type, education_level, governance_type) VALUES ('Central Carolina Technical College', 'CentralCarolinaTC', 'A public postsecondary institution offering academic programs, career education, and workforce training in Sumter, SC.', 'https://www.cctech.edu/', 'Sumter', 'SC', '29150', '2026-02-20 17:33:36.094140', '2026-02-20 17:33:36.094140', 1, 'college_university', 'postsecondary', 'public')
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
INSERT IGNORE INTO educateworkforce_prod_openedx.organizations_organization_parent_organizations (
    from_organization_id,
    to_organization_id
)
SELECT child.id, parent.id
FROM educateworkforce_prod_openedx.organizations_organization AS child
INNER JOIN (
    SELECT 'REVVED' AS child_short_name, 'Clemson' AS parent_short_name
    UNION ALL SELECT 'CO-DREAM-OER', 'Clemson'
    UNION ALL SELECT 'MEEP', 'Clemson'
    UNION ALL SELECT 'A2Grant', 'Clemson'
    UNION ALL SELECT 'SUNYUlsterCC', 'SUNY'
    UNION ALL SELECT 'WaterDROPS', 'Clemson'
    UNION ALL SELECT 'CUCWD', 'Clemson'
    UNION ALL SELECT 'TraCR', 'Clemson'
    UNION ALL SELECT 'TRUSTWORKS', 'CyManII'
    UNION ALL SELECT 'CentralCarolinaTC', 'SCTCS'
) AS relationship
    ON relationship.child_short_name = child.short_name
INNER JOIN educateworkforce_prod_openedx.organizations_organization AS parent
    ON parent.short_name = relationship.parent_short_name;

COMMIT;

-- Verification: this should return 15 EducateWorkforce organizations whose
-- type is valid under the compact organization_type taxonomy and whose new
-- descriptive fields are populated.
SELECT COUNT(*) AS classified_organization_count
FROM educateworkforce_prod_openedx.organizations_organization
WHERE short_name IN ('REVVED', 'CO-DREAM-OER', 'MEEP', 'USDOE', 'IACMI', 'MSSC', 'A2Grant', 'SUNYUlsterCC', 'WaterDROPS', 'AIMPhotonics', 'CUCWD', 'TraCR', 'Clemson', 'TRUSTWORKS', 'CentralCarolinaTC')
  AND organization_type IN (
    'k12_school', 'school_district', 'career_technical_center', 'homeschool',
    'college_university', 'training_provider', 'workforce_agency',
    'education_nonprofit', 'education_technology', 'employer',
    'government_agency', 'internal_program', 'other', 'unknown'
  )
  AND education_level IS NOT NULL
  AND governance_type IS NOT NULL
  AND description IS NOT NULL
  AND description <> ''
  AND website_url <> '';

-- Verification: every configured relationship should resolve to its expected parent.
SELECT child.short_name AS child_short_name, parent.short_name AS parent_short_name
FROM educateworkforce_prod_openedx.organizations_organization AS child
INNER JOIN educateworkforce_prod_openedx.organizations_organization_parent_organizations AS relationship
    ON relationship.from_organization_id = child.id
INNER JOIN educateworkforce_prod_openedx.organizations_organization AS parent
    ON parent.id = relationship.to_organization_id
WHERE child.short_name IN (
    'REVVED', 'CO-DREAM-OER', 'MEEP', 'A2Grant', 'SUNYUlsterCC',
    'WaterDROPS', 'CUCWD', 'TraCR', 'TRUSTWORKS', 'CentralCarolinaTC'
)
ORDER BY child.short_name;
