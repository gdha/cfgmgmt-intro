name 'nginx_test'
maintainer 'Gratien Dhaese'
maintainer_email 'gratien.dhaese@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures nginx_test'
long_description 'Installs/Configures nginx_test'
version '0.1.1'
chef_version '>= 13.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/nginx_test/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/nginx_test'
depends 'nginx'
depends 'yum'
depends 'os-hardening'
