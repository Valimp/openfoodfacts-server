#!/usr/bin/perl

# This file is part of Product Opener.
#
# Product Opener
# Copyright (C) 2011-2023 Association Open Food Facts
# Contact: contact@openfoodfacts.org
# Address: 21 rue des Iles, 94100 Saint-Maur des Fossés, France
#
# Product Opener is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

use ProductOpener::PerlStandards;

use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:cgi :form escapeHTML/;

use ProductOpener::Config qw/:all/;
use ProductOpener::Store qw/:all/;
use ProductOpener::Index qw/:all/;
use ProductOpener::Display qw/display_recent_changes init_request/;
use ProductOpener::HTTP qw/single_param/;
use ProductOpener::Users qw/:all/;
use ProductOpener::Products qw/:all/;
use ProductOpener::Food qw/:all/;
use ProductOpener::Tags qw/:all/;

use CGI qw/:cgi :form escapeHTML/;
use URI::Escape::XS;
use Storable qw/dclone/;
use Encode;
use JSON::MaybeXS;

use ProductOpener::Lang qw/:all/;

my $request_ref = ProductOpener::Display::init_request();

my $query_ref = {};

my $limit = 0 + (single_param('page_size') || $options{default_recent_changes_page_size});
if ($limit > $options{max_recent_changes_page_size}) {
	$limit = $options{max_recent_changes_page_size};
}

my $page = 0 + (single_param('page') || 1);
if (($page < 1) or ($page > 1000)) {
	$page = 1;
}

my $request_ref = {current_link_query => ''};

foreach my $parameter ('json') {

	if (defined single_param($parameter)) {
		$request_ref->{$parameter} = single_param($parameter);
	}
}

display_recent_changes($request_ref, $query_ref, $limit, $page);
