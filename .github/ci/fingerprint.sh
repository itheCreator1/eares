#!/usr/bin/env bash
# Print a summary of the site's content: posts, users, options that matter,
# and a hash of every uploaded file. CI compares it before a backup and after
# restoring that backup onto a wiped stack.
source "$(dirname "$0")/../../scripts/lib.sh"

# shellcheck disable=SC2016 # PHP code, not shell.
wp eval '
global $wpdb;
foreach ( array( "posts", "postmeta", "terms", "term_relationships", "users", "usermeta", "comments" ) as $t ) {
	echo $t, " ", $wpdb->get_var( "SELECT COUNT(*) FROM {$wpdb->$t}" ), "\n";
}
echo "post titles ", md5( implode( "|", $wpdb->get_col( "SELECT post_title FROM {$wpdb->posts} ORDER BY ID" ) ) ), "\n";
echo "logins ", implode( ",", $wpdb->get_col( "SELECT user_login FROM {$wpdb->users} ORDER BY ID" ) ), "\n";
foreach ( array( "blogname", "blogdescription", "page_on_front", "blog_public" ) as $o ) {
	echo $o, " ", get_option( $o ), "\n";
}'
echo "uploads $(docker compose exec -T -u www-data wordpress sh -c \
  'cd /var/www/html/wp-content/uploads && find . -type f -exec sha256sum {} + | sort' | sha256sum | cut -c1-16)"
