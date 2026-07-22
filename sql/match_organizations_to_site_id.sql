-- Set this to the target django_site.id.
-- This will need to change relative to each Grove instance
SET @site_id = 3;

START TRANSACTION;

INSERT INTO openedx.organizations_organization_sites (
    organization_id,
    site_id
)
SELECT
    organization.id,
    site.id
FROM openedx.organizations_organization AS organization
INNER JOIN openedx.django_site AS site
    ON site.id = @site_id
LEFT JOIN openedx.organizations_organization_sites AS existing
    ON existing.organization_id = organization.id
    AND existing.site_id = site.id
WHERE existing.id IS NULL;

-- Verify that every organization is now associated with the site.
SELECT
    COUNT(*) AS total_organizations,
    SUM(existing.id IS NOT NULL) AS associated_organizations,
    SUM(existing.id IS NULL) AS missing_organizations
FROM openedx.organizations_organization AS organization
LEFT JOIN openedx.organizations_organization_sites AS existing
    ON existing.organization_id = organization.id
    AND existing.site_id = @site_id;

COMMIT;