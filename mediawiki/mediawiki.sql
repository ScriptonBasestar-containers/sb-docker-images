CREATE TABLE `abuse_filter` (
  `af_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `af_pattern` blob NOT NULL,
  `af_user` bigint(20) unsigned NOT NULL DEFAULT 0,
  `af_user_text` varbinary(255) NOT NULL DEFAULT '',
  `af_actor` bigint(20) unsigned NOT NULL DEFAULT 0,
  `af_timestamp` binary(14) NOT NULL,
  `af_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `af_comments` blob DEFAULT NULL,
  `af_public_comments` tinyblob DEFAULT NULL,
  `af_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `af_hit_count` bigint(20) NOT NULL DEFAULT 0,
  `af_throttled` tinyint(1) NOT NULL DEFAULT 0,
  `af_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `af_actions` varbinary(255) NOT NULL DEFAULT '',
  `af_global` tinyint(1) NOT NULL DEFAULT 0,
  `af_group` varbinary(64) NOT NULL DEFAULT 'default',
  PRIMARY KEY (`af_id`),
  KEY `af_user` (`af_user`),
  KEY `af_actor` (`af_actor`),
  KEY `af_group_enabled` (`af_group`,`af_enabled`,`af_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `abuse_filter_action` (
  `afa_filter` bigint(20) unsigned NOT NULL,
  `afa_consequence` varbinary(255) NOT NULL,
  `afa_parameters` tinyblob NOT NULL,
  PRIMARY KEY (`afa_filter`,`afa_consequence`),
  KEY `afa_consequence` (`afa_consequence`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `abuse_filter_history` (
  `afh_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `afh_filter` bigint(20) unsigned NOT NULL,
  `afh_user` bigint(20) unsigned NOT NULL DEFAULT 0,
  `afh_user_text` varbinary(255) NOT NULL DEFAULT '',
  `afh_actor` bigint(20) unsigned NOT NULL DEFAULT 0,
  `afh_timestamp` binary(14) NOT NULL,
  `afh_pattern` blob NOT NULL,
  `afh_comments` blob NOT NULL,
  `afh_flags` tinyblob NOT NULL,
  `afh_public_comments` tinyblob DEFAULT NULL,
  `afh_actions` blob DEFAULT NULL,
  `afh_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `afh_changed_fields` varbinary(255) NOT NULL DEFAULT '',
  `afh_group` varbinary(64) DEFAULT NULL,
  PRIMARY KEY (`afh_id`),
  KEY `afh_filter` (`afh_filter`),
  KEY `afh_user` (`afh_user`),
  KEY `afh_user_text` (`afh_user_text`),
  KEY `afh_actor` (`afh_actor`),
  KEY `afh_timestamp` (`afh_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `abuse_filter_log` (
  `afl_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `afl_global` tinyint(1) NOT NULL,
  `afl_filter_id` bigint(20) unsigned NOT NULL,
  `afl_user` bigint(20) unsigned NOT NULL,
  `afl_user_text` varbinary(255) NOT NULL,
  `afl_ip` varbinary(255) NOT NULL,
  `afl_action` varbinary(255) NOT NULL,
  `afl_actions` varbinary(255) NOT NULL,
  `afl_var_dump` blob NOT NULL,
  `afl_timestamp` binary(14) NOT NULL,
  `afl_namespace` int(11) NOT NULL,
  `afl_title` varbinary(255) NOT NULL,
  `afl_wiki` varbinary(64) DEFAULT NULL,
  `afl_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `afl_patrolled_by` int(10) unsigned NOT NULL DEFAULT 0,
  `afl_rev_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`afl_id`),
  KEY `afl_filter_timestamp_full` (`afl_global`,`afl_filter_id`,`afl_timestamp`),
  KEY `afl_user_timestamp` (`afl_user`,`afl_user_text`,`afl_timestamp`),
  KEY `afl_timestamp` (`afl_timestamp`),
  KEY `afl_page_timestamp` (`afl_namespace`,`afl_title`,`afl_timestamp`),
  KEY `afl_ip_timestamp` (`afl_ip`,`afl_timestamp`),
  KEY `afl_rev_id` (`afl_rev_id`),
  KEY `afl_wiki_timestamp` (`afl_wiki`,`afl_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `actor` (
  `actor_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `actor_user` int(10) unsigned DEFAULT NULL,
  `actor_name` varbinary(255) NOT NULL,
  PRIMARY KEY (`actor_id`),
  UNIQUE KEY `actor_name` (`actor_name`),
  UNIQUE KEY `actor_user` (`actor_user`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=binary

CREATE TABLE `archive` (
  `ar_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ar_namespace` int(11) NOT NULL DEFAULT 0,
  `ar_title` varbinary(255) NOT NULL DEFAULT '',
  `ar_comment_id` bigint(20) unsigned NOT NULL,
  `ar_actor` bigint(20) unsigned NOT NULL,
  `ar_timestamp` binary(14) NOT NULL,
  `ar_minor_edit` tinyint(4) NOT NULL DEFAULT 0,
  `ar_rev_id` int(10) unsigned NOT NULL,
  `ar_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ar_len` int(10) unsigned DEFAULT NULL,
  `ar_page_id` int(10) unsigned DEFAULT NULL,
  `ar_parent_id` int(10) unsigned DEFAULT NULL,
  `ar_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ar_id`),
  UNIQUE KEY `ar_revid_uniq` (`ar_rev_id`),
  KEY `ar_name_title_timestamp` (`ar_namespace`,`ar_title`,`ar_timestamp`),
  KEY `ar_actor_timestamp` (`ar_actor`,`ar_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `block` (
  `bl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bl_target` int(10) unsigned NOT NULL,
  `bl_by_actor` bigint(20) unsigned NOT NULL,
  `bl_reason_id` bigint(20) unsigned NOT NULL,
  `bl_timestamp` binary(14) NOT NULL,
  `bl_anon_only` tinyint(1) NOT NULL DEFAULT 0,
  `bl_create_account` tinyint(1) NOT NULL DEFAULT 1,
  `bl_enable_autoblock` tinyint(1) NOT NULL DEFAULT 1,
  `bl_expiry` varbinary(14) NOT NULL,
  `bl_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `bl_block_email` tinyint(1) NOT NULL DEFAULT 0,
  `bl_allow_usertalk` tinyint(1) NOT NULL DEFAULT 0,
  `bl_parent_block_id` int(10) unsigned DEFAULT NULL,
  `bl_sitewide` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`bl_id`),
  KEY `bl_timestamp` (`bl_timestamp`),
  KEY `bl_target` (`bl_target`),
  KEY `bl_expiry` (`bl_expiry`),
  KEY `bl_parent_block_id` (`bl_parent_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `block_target` (
  `bt_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bt_address` tinyblob DEFAULT NULL,
  `bt_user` int(10) unsigned DEFAULT NULL,
  `bt_user_text` varbinary(255) DEFAULT NULL,
  `bt_auto` tinyint(1) NOT NULL DEFAULT 0,
  `bt_range_start` tinyblob DEFAULT NULL,
  `bt_range_end` tinyblob DEFAULT NULL,
  `bt_ip_hex` tinyblob DEFAULT NULL,
  `bt_count` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`bt_id`),
  KEY `bt_address` (`bt_address`(42)),
  KEY `bt_ip_user_text` (`bt_ip_hex`(35),`bt_user_text`),
  KEY `bt_range` (`bt_range_start`(35),`bt_range_end`(35)),
  KEY `bt_user` (`bt_user`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `bot_passwords` (
  `bp_user` int(10) unsigned NOT NULL,
  `bp_app_id` varbinary(32) NOT NULL,
  `bp_password` tinyblob NOT NULL,
  `bp_token` binary(32) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `bp_restrictions` blob NOT NULL,
  `bp_grants` blob NOT NULL,
  PRIMARY KEY (`bp_user`,`bp_app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `category` (
  `cat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cat_title` varbinary(255) NOT NULL,
  `cat_pages` int(11) NOT NULL DEFAULT 0,
  `cat_subcats` int(11) NOT NULL DEFAULT 0,
  `cat_files` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`cat_id`),
  UNIQUE KEY `cat_title` (`cat_title`),
  KEY `cat_pages` (`cat_pages`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `categorylinks` (
  `cl_from` int(10) unsigned NOT NULL DEFAULT 0,
  `cl_to` varbinary(255) NOT NULL DEFAULT '',
  `cl_sortkey` varbinary(230) NOT NULL DEFAULT '',
  `cl_sortkey_prefix` varbinary(255) NOT NULL DEFAULT '',
  `cl_timestamp` timestamp NOT NULL,
  `cl_collation` varbinary(32) NOT NULL DEFAULT '',
  `cl_type` enum('page','subcat','file') NOT NULL DEFAULT 'page',
  PRIMARY KEY (`cl_from`,`cl_to`),
  KEY `cl_sortkey` (`cl_to`,`cl_type`,`cl_sortkey`,`cl_from`),
  KEY `cl_timestamp` (`cl_to`,`cl_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `change_tag` (
  `ct_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ct_rc_id` int(10) unsigned DEFAULT NULL,
  `ct_log_id` int(10) unsigned DEFAULT NULL,
  `ct_rev_id` int(10) unsigned DEFAULT NULL,
  `ct_params` blob DEFAULT NULL,
  `ct_tag_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ct_id`),
  UNIQUE KEY `ct_rc_tag_id` (`ct_rc_id`,`ct_tag_id`),
  UNIQUE KEY `ct_log_tag_id` (`ct_log_id`,`ct_tag_id`),
  UNIQUE KEY `ct_rev_tag_id` (`ct_rev_id`,`ct_tag_id`),
  KEY `ct_tag_id_id` (`ct_tag_id`,`ct_rc_id`,`ct_rev_id`,`ct_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `change_tag_def` (
  `ctd_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ctd_name` varbinary(255) NOT NULL,
  `ctd_user_defined` tinyint(1) NOT NULL,
  `ctd_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`ctd_id`),
  UNIQUE KEY `ctd_name` (`ctd_name`),
  KEY `ctd_count` (`ctd_count`),
  KEY `ctd_user_defined` (`ctd_user_defined`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `comment` (
  `comment_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_hash` int(11) NOT NULL,
  `comment_text` blob NOT NULL,
  `comment_data` blob DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comment_hash` (`comment_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `content` (
  `content_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content_size` int(10) unsigned NOT NULL,
  `content_sha1` varbinary(32) NOT NULL,
  `content_model` smallint(5) unsigned NOT NULL,
  `content_address` varbinary(255) NOT NULL,
  PRIMARY KEY (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `content_models` (
  `model_id` int(11) NOT NULL AUTO_INCREMENT,
  `model_name` varbinary(64) NOT NULL,
  PRIMARY KEY (`model_id`),
  UNIQUE KEY `model_name` (`model_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `discussiontools_item_ids` (
  `itid_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `itid_itemid` varbinary(255) NOT NULL,
  PRIMARY KEY (`itid_id`),
  UNIQUE KEY `itid_itemid` (`itid_itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `discussiontools_item_pages` (
  `itp_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `itp_items_id` int(10) unsigned NOT NULL,
  `itp_page_id` bigint(20) unsigned NOT NULL,
  `itp_oldest_revision_id` bigint(20) unsigned NOT NULL,
  `itp_newest_revision_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`itp_id`),
  UNIQUE KEY `itp_items_id_page_id` (`itp_items_id`,`itp_page_id`),
  UNIQUE KEY `itp_items_id_newest_revision_id` (`itp_items_id`,`itp_newest_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `discussiontools_item_revisions` (
  `itr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `itr_itemid_id` int(11) NOT NULL,
  `itr_revision_id` bigint(20) unsigned NOT NULL,
  `itr_items_id` int(11) NOT NULL,
  `itr_parent_id` int(11) DEFAULT NULL,
  `itr_transcludedfrom` bigint(20) unsigned DEFAULT NULL,
  `itr_level` tinyint(4) NOT NULL,
  `itr_headinglevel` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`itr_id`),
  UNIQUE KEY `itr_itemid_id_revision_id` (`itr_itemid_id`,`itr_revision_id`),
  KEY `itr_revision_id` (`itr_revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `discussiontools_items` (
  `it_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `it_itemname` varbinary(255) NOT NULL,
  `it_timestamp` binary(14) DEFAULT NULL,
  `it_actor` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`it_id`),
  UNIQUE KEY `it_itemname` (`it_itemname`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `discussiontools_subscription` (
  `sub_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sub_item` varbinary(255) NOT NULL,
  `sub_namespace` int(11) NOT NULL DEFAULT 0,
  `sub_title` varbinary(255) NOT NULL,
  `sub_section` varbinary(255) NOT NULL,
  `sub_state` int(11) NOT NULL DEFAULT 1,
  `sub_user` int(10) unsigned NOT NULL,
  `sub_created` binary(14) NOT NULL,
  `sub_notified` binary(14) DEFAULT NULL,
  PRIMARY KEY (`sub_id`),
  UNIQUE KEY `discussiontools_subscription_itemuser` (`sub_item`,`sub_user`),
  KEY `discussiontools_subscription_user` (`sub_user`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_email_batch` (
  `eeb_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eeb_user_id` int(10) unsigned NOT NULL,
  `eeb_event_priority` tinyint(3) unsigned NOT NULL DEFAULT 10,
  `eeb_event_id` int(10) unsigned NOT NULL,
  `eeb_event_hash` varbinary(32) NOT NULL,
  PRIMARY KEY (`eeb_id`),
  UNIQUE KEY `echo_email_batch_user_event` (`eeb_user_id`,`eeb_event_id`),
  KEY `echo_email_batch_user_hash_priority` (`eeb_user_id`,`eeb_event_hash`,`eeb_event_priority`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_event` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_type` varbinary(64) NOT NULL,
  `event_variant` varbinary(64) DEFAULT NULL,
  `event_agent_id` int(10) unsigned DEFAULT NULL,
  `event_agent_ip` varbinary(39) DEFAULT NULL,
  `event_extra` blob DEFAULT NULL,
  `event_page_id` int(10) unsigned DEFAULT NULL,
  `event_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`event_id`),
  KEY `echo_event_type` (`event_type`),
  KEY `echo_event_page_id` (`event_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_notification` (
  `notification_event` int(10) unsigned NOT NULL,
  `notification_user` int(10) unsigned NOT NULL,
  `notification_timestamp` binary(14) NOT NULL,
  `notification_read_timestamp` binary(14) DEFAULT NULL,
  `notification_bundle_hash` varbinary(32) NOT NULL,
  PRIMARY KEY (`notification_user`,`notification_event`),
  KEY `echo_user_timestamp` (`notification_user`,`notification_timestamp`),
  KEY `echo_notification_event` (`notification_event`),
  KEY `echo_notification_user_read_timestamp` (`notification_user`,`notification_read_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_push_provider` (
  `epp_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `epp_name` tinyblob NOT NULL,
  PRIMARY KEY (`epp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_push_subscription` (
  `eps_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eps_user` int(10) unsigned NOT NULL,
  `eps_token` blob NOT NULL,
  `eps_token_sha256` binary(64) NOT NULL,
  `eps_provider` tinyint(3) unsigned NOT NULL,
  `eps_updated` timestamp NOT NULL,
  `eps_data` blob DEFAULT NULL,
  `eps_topic` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`eps_id`),
  UNIQUE KEY `eps_token_sha256` (`eps_token_sha256`),
  KEY `eps_provider` (`eps_provider`),
  KEY `eps_topic` (`eps_topic`),
  KEY `eps_user` (`eps_user`),
  KEY `eps_token` (`eps_token`(10))
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_push_topic` (
  `ept_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `ept_text` tinyblob NOT NULL,
  PRIMARY KEY (`ept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `echo_target_page` (
  `etp_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `etp_page` int(10) unsigned NOT NULL DEFAULT 0,
  `etp_event` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`etp_id`),
  KEY `echo_target_page_event` (`etp_event`),
  KEY `echo_target_page_page_event` (`etp_page`,`etp_event`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `externallinks` (
  `el_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `el_from` int(10) unsigned NOT NULL DEFAULT 0,
  `el_to_domain_index` varbinary(255) NOT NULL DEFAULT '',
  `el_to_path` blob DEFAULT NULL,
  PRIMARY KEY (`el_id`),
  KEY `el_from` (`el_from`),
  KEY `el_to_domain_index_to_path` (`el_to_domain_index`,`el_to_path`(60))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=binary

CREATE TABLE `filearchive` (
  `fa_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fa_name` varbinary(255) NOT NULL DEFAULT '',
  `fa_archive_name` varbinary(255) DEFAULT '',
  `fa_storage_group` varbinary(16) DEFAULT NULL,
  `fa_storage_key` varbinary(64) DEFAULT '',
  `fa_deleted_user` int(11) DEFAULT NULL,
  `fa_deleted_timestamp` binary(14) DEFAULT NULL,
  `fa_deleted_reason_id` bigint(20) unsigned NOT NULL,
  `fa_size` bigint(20) unsigned DEFAULT 0,
  `fa_width` int(11) DEFAULT 0,
  `fa_height` int(11) DEFAULT 0,
  `fa_metadata` mediumblob DEFAULT NULL,
  `fa_bits` int(11) DEFAULT 0,
  `fa_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `fa_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') DEFAULT 'unknown',
  `fa_minor_mime` varbinary(100) DEFAULT 'unknown',
  `fa_description_id` bigint(20) unsigned NOT NULL,
  `fa_actor` bigint(20) unsigned NOT NULL,
  `fa_timestamp` binary(14) DEFAULT NULL,
  `fa_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `fa_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`fa_id`),
  KEY `fa_name` (`fa_name`,`fa_timestamp`),
  KEY `fa_storage_group` (`fa_storage_group`,`fa_storage_key`),
  KEY `fa_deleted_timestamp` (`fa_deleted_timestamp`),
  KEY `fa_actor_timestamp` (`fa_actor`,`fa_timestamp`),
  KEY `fa_sha1` (`fa_sha1`(10))
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `image` (
  `img_name` varbinary(255) NOT NULL DEFAULT '',
  `img_size` bigint(20) unsigned NOT NULL DEFAULT 0,
  `img_width` int(11) NOT NULL DEFAULT 0,
  `img_height` int(11) NOT NULL DEFAULT 0,
  `img_metadata` mediumblob NOT NULL,
  `img_bits` int(11) NOT NULL DEFAULT 0,
  `img_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `img_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') NOT NULL DEFAULT 'unknown',
  `img_minor_mime` varbinary(100) NOT NULL DEFAULT 'unknown',
  `img_description_id` bigint(20) unsigned NOT NULL,
  `img_actor` bigint(20) unsigned NOT NULL,
  `img_timestamp` binary(14) NOT NULL,
  `img_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`img_name`),
  KEY `img_actor_timestamp` (`img_actor`,`img_timestamp`),
  KEY `img_size` (`img_size`),
  KEY `img_timestamp` (`img_timestamp`),
  KEY `img_sha1` (`img_sha1`(10)),
  KEY `img_media_mime` (`img_media_type`,`img_major_mime`,`img_minor_mime`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `imagelinks` (
  `il_from` int(10) unsigned NOT NULL DEFAULT 0,
  `il_to` varbinary(255) NOT NULL DEFAULT '',
  `il_from_namespace` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`il_from`,`il_to`),
  KEY `il_to` (`il_to`,`il_from`),
  KEY `il_backlinks_namespace` (`il_from_namespace`,`il_to`,`il_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `interwiki` (
  `iw_prefix` varbinary(32) NOT NULL,
  `iw_url` blob NOT NULL,
  `iw_api` blob NOT NULL,
  `iw_wikiid` varbinary(64) NOT NULL,
  `iw_local` tinyint(1) NOT NULL,
  `iw_trans` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`iw_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `ip_changes` (
  `ipc_rev_id` int(10) unsigned NOT NULL DEFAULT 0,
  `ipc_rev_timestamp` binary(14) NOT NULL,
  `ipc_hex` varbinary(35) NOT NULL DEFAULT '',
  PRIMARY KEY (`ipc_rev_id`),
  KEY `ipc_rev_timestamp` (`ipc_rev_timestamp`),
  KEY `ipc_hex_time` (`ipc_hex`,`ipc_rev_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `ipblocks` (
  `ipb_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ipb_address` tinyblob NOT NULL,
  `ipb_user` int(10) unsigned NOT NULL DEFAULT 0,
  `ipb_by_actor` bigint(20) unsigned NOT NULL,
  `ipb_reason_id` bigint(20) unsigned NOT NULL,
  `ipb_timestamp` binary(14) NOT NULL,
  `ipb_auto` tinyint(1) NOT NULL DEFAULT 0,
  `ipb_anon_only` tinyint(1) NOT NULL DEFAULT 0,
  `ipb_create_account` tinyint(1) NOT NULL DEFAULT 1,
  `ipb_enable_autoblock` tinyint(1) NOT NULL DEFAULT 1,
  `ipb_expiry` varbinary(14) NOT NULL,
  `ipb_range_start` tinyblob NOT NULL,
  `ipb_range_end` tinyblob NOT NULL,
  `ipb_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `ipb_block_email` tinyint(1) NOT NULL DEFAULT 0,
  `ipb_allow_usertalk` tinyint(1) NOT NULL DEFAULT 0,
  `ipb_parent_block_id` int(10) unsigned DEFAULT NULL,
  `ipb_sitewide` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ipb_id`),
  UNIQUE KEY `ipb_address_unique` (`ipb_address`(255),`ipb_user`,`ipb_auto`),
  KEY `ipb_user` (`ipb_user`),
  KEY `ipb_range` (`ipb_range_start`(8),`ipb_range_end`(8)),
  KEY `ipb_timestamp` (`ipb_timestamp`),
  KEY `ipb_expiry` (`ipb_expiry`),
  KEY `ipb_parent_block_id` (`ipb_parent_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `ipblocks_restrictions` (
  `ir_ipb_id` int(10) unsigned NOT NULL,
  `ir_type` tinyint(4) NOT NULL,
  `ir_value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ir_ipb_id`,`ir_type`,`ir_value`),
  KEY `ir_type_value` (`ir_type`,`ir_value`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `iwlinks` (
  `iwl_from` int(10) unsigned NOT NULL DEFAULT 0,
  `iwl_prefix` varbinary(32) NOT NULL DEFAULT '',
  `iwl_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`iwl_from`,`iwl_prefix`,`iwl_title`),
  KEY `iwl_prefix_title_from` (`iwl_prefix`,`iwl_title`,`iwl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `job` (
  `job_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `job_cmd` varbinary(60) NOT NULL DEFAULT '',
  `job_namespace` int(11) NOT NULL,
  `job_title` varbinary(255) NOT NULL,
  `job_timestamp` binary(14) DEFAULT NULL,
  `job_params` mediumblob NOT NULL,
  `job_random` int(10) unsigned NOT NULL DEFAULT 0,
  `job_attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `job_token` varbinary(32) NOT NULL DEFAULT '',
  `job_token_timestamp` binary(14) DEFAULT NULL,
  `job_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`job_id`),
  KEY `job_sha1` (`job_sha1`),
  KEY `job_cmd_token` (`job_cmd`,`job_token`,`job_random`),
  KEY `job_cmd_token_id` (`job_cmd`,`job_token`,`job_id`),
  KEY `job_cmd` (`job_cmd`,`job_namespace`,`job_title`,`job_params`(128)),
  KEY `job_timestamp` (`job_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `l10n_cache` (
  `lc_lang` varbinary(35) NOT NULL,
  `lc_key` varbinary(255) NOT NULL,
  `lc_value` mediumblob NOT NULL,
  PRIMARY KEY (`lc_lang`,`lc_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `langlinks` (
  `ll_from` int(10) unsigned NOT NULL DEFAULT 0,
  `ll_lang` varbinary(35) NOT NULL DEFAULT '',
  `ll_title` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ll_from`,`ll_lang`),
  KEY `ll_lang` (`ll_lang`,`ll_title`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `linktarget` (
  `lt_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `lt_namespace` int(11) NOT NULL,
  `lt_title` varbinary(255) NOT NULL,
  PRIMARY KEY (`lt_id`),
  UNIQUE KEY `lt_namespace_title` (`lt_namespace`,`lt_title`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `linter` (
  `linter_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `linter_page` int(10) unsigned NOT NULL,
  `linter_namespace` int(11) DEFAULT NULL,
  `linter_cat` int(10) unsigned NOT NULL,
  `linter_start` int(10) unsigned NOT NULL,
  `linter_end` int(10) unsigned NOT NULL,
  `linter_params` blob NOT NULL,
  `linter_template` varbinary(255) NOT NULL DEFAULT '',
  `linter_tag` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`linter_id`),
  UNIQUE KEY `linter_cat_page_position` (`linter_cat`,`linter_page`,`linter_start`,`linter_end`),
  KEY `linter_page` (`linter_page`),
  KEY `linter_cat_namespace` (`linter_cat`,`linter_namespace`),
  KEY `linter_cat_template` (`linter_cat`,`linter_template`),
  KEY `linter_cat_tag` (`linter_cat`,`linter_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `log_search` (
  `ls_field` varbinary(32) NOT NULL,
  `ls_value` varbinary(255) NOT NULL,
  `ls_log_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`ls_field`,`ls_value`,`ls_log_id`),
  KEY `ls_log_id` (`ls_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `logging` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_type` varbinary(32) NOT NULL DEFAULT '',
  `log_action` varbinary(32) NOT NULL DEFAULT '',
  `log_timestamp` binary(14) NOT NULL DEFAULT '19700101000000',
  `log_actor` bigint(20) unsigned NOT NULL,
  `log_namespace` int(11) NOT NULL DEFAULT 0,
  `log_title` varbinary(255) NOT NULL DEFAULT '',
  `log_page` int(10) unsigned DEFAULT NULL,
  `log_comment_id` bigint(20) unsigned NOT NULL,
  `log_params` blob NOT NULL,
  `log_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`log_id`),
  KEY `log_type_time` (`log_type`,`log_timestamp`),
  KEY `log_actor_time` (`log_actor`,`log_timestamp`),
  KEY `log_page_time` (`log_namespace`,`log_title`,`log_timestamp`),
  KEY `log_times` (`log_timestamp`),
  KEY `log_actor_type_time` (`log_actor`,`log_type`,`log_timestamp`),
  KEY `log_page_id_time` (`log_page`,`log_timestamp`),
  KEY `log_type_action` (`log_type`,`log_action`,`log_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `loginnotify_seen_net` (
  `lsn_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lsn_time_bucket` smallint(5) unsigned NOT NULL,
  `lsn_user` int(10) unsigned NOT NULL,
  `lsn_subnet` bigint(20) NOT NULL,
  PRIMARY KEY (`lsn_id`),
  UNIQUE KEY `loginnotify_seen_net_user` (`lsn_user`,`lsn_subnet`,`lsn_time_bucket`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `module_deps` (
  `md_module` varbinary(255) NOT NULL,
  `md_skin` varbinary(32) NOT NULL,
  `md_deps` mediumblob NOT NULL,
  PRIMARY KEY (`md_module`,`md_skin`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `oathauth_devices` (
  `oad_id` int(11) NOT NULL AUTO_INCREMENT,
  `oad_user` int(11) NOT NULL,
  `oad_type` int(11) NOT NULL,
  `oad_name` varbinary(255) DEFAULT NULL,
  `oad_created` binary(14) DEFAULT NULL,
  `oad_data` blob DEFAULT NULL,
  PRIMARY KEY (`oad_id`),
  KEY `oad_user` (`oad_user`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `oathauth_types` (
  `oat_id` int(11) NOT NULL AUTO_INCREMENT,
  `oat_name` varbinary(255) NOT NULL,
  PRIMARY KEY (`oat_id`),
  UNIQUE KEY `oat_name` (`oat_name`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `objectcache` (
  `keyname` varbinary(255) NOT NULL DEFAULT '',
  `value` mediumblob DEFAULT NULL,
  `exptime` binary(14) NOT NULL,
  `modtoken` varbinary(17) NOT NULL DEFAULT '00000000000000000',
  `flags` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`keyname`),
  KEY `exptime` (`exptime`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `oldimage` (
  `oi_name` varbinary(255) NOT NULL DEFAULT '',
  `oi_archive_name` varbinary(255) NOT NULL DEFAULT '',
  `oi_size` bigint(20) unsigned NOT NULL DEFAULT 0,
  `oi_width` int(11) NOT NULL DEFAULT 0,
  `oi_height` int(11) NOT NULL DEFAULT 0,
  `oi_bits` int(11) NOT NULL DEFAULT 0,
  `oi_description_id` bigint(20) unsigned NOT NULL,
  `oi_actor` bigint(20) unsigned NOT NULL,
  `oi_timestamp` binary(14) NOT NULL,
  `oi_metadata` mediumblob NOT NULL,
  `oi_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `oi_major_mime` enum('unknown','application','audio','image','text','video','message','model','multipart','chemical') NOT NULL DEFAULT 'unknown',
  `oi_minor_mime` varbinary(100) NOT NULL DEFAULT 'unknown',
  `oi_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `oi_sha1` varbinary(32) NOT NULL DEFAULT '',
  KEY `oi_actor_timestamp` (`oi_actor`,`oi_timestamp`),
  KEY `oi_name_timestamp` (`oi_name`,`oi_timestamp`),
  KEY `oi_name_archive_name` (`oi_name`,`oi_archive_name`(14)),
  KEY `oi_sha1` (`oi_sha1`(10)),
  KEY `oi_timestamp` (`oi_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `page` (
  `page_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `page_namespace` int(11) NOT NULL,
  `page_title` varbinary(255) NOT NULL,
  `page_is_redirect` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `page_is_new` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `page_random` double unsigned NOT NULL,
  `page_touched` binary(14) NOT NULL,
  `page_links_updated` varbinary(14) DEFAULT NULL,
  `page_latest` int(10) unsigned NOT NULL,
  `page_len` int(10) unsigned NOT NULL,
  `page_content_model` varbinary(32) DEFAULT NULL,
  `page_lang` varbinary(35) DEFAULT NULL,
  PRIMARY KEY (`page_id`),
  UNIQUE KEY `page_name_title` (`page_namespace`,`page_title`),
  KEY `page_random` (`page_random`),
  KEY `page_len` (`page_len`),
  KEY `page_redirect_namespace_len` (`page_is_redirect`,`page_namespace`,`page_len`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `page_props` (
  `pp_page` int(10) unsigned NOT NULL,
  `pp_propname` varbinary(60) NOT NULL,
  `pp_value` blob NOT NULL,
  `pp_sortkey` float DEFAULT NULL,
  PRIMARY KEY (`pp_page`,`pp_propname`),
  UNIQUE KEY `pp_propname_page` (`pp_propname`,`pp_page`),
  UNIQUE KEY `pp_propname_sortkey_page` (`pp_propname`,`pp_sortkey`,`pp_page`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `page_restrictions` (
  `pr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pr_page` int(10) unsigned NOT NULL,
  `pr_type` varbinary(60) NOT NULL,
  `pr_level` varbinary(60) NOT NULL,
  `pr_cascade` tinyint(4) NOT NULL,
  `pr_expiry` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`pr_id`),
  UNIQUE KEY `pr_pagetype` (`pr_page`,`pr_type`),
  KEY `pr_typelevel` (`pr_type`,`pr_level`),
  KEY `pr_level` (`pr_level`),
  KEY `pr_cascade` (`pr_cascade`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `pagelinks` (
  `pl_from` int(10) unsigned NOT NULL DEFAULT 0,
  `pl_namespace` int(11) NOT NULL DEFAULT 0,
  `pl_title` varbinary(255) NOT NULL DEFAULT '',
  `pl_from_namespace` int(11) NOT NULL DEFAULT 0,
  `pl_target_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`pl_from`,`pl_namespace`,`pl_title`),
  KEY `pl_namespace` (`pl_namespace`,`pl_title`,`pl_from`),
  KEY `pl_backlinks_namespace` (`pl_from_namespace`,`pl_namespace`,`pl_title`,`pl_from`),
  KEY `pl_target_id` (`pl_target_id`,`pl_from`),
  KEY `pl_backlinks_namespace_target_id` (`pl_from_namespace`,`pl_target_id`,`pl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `protected_titles` (
  `pt_namespace` int(11) NOT NULL,
  `pt_title` varbinary(255) NOT NULL,
  `pt_user` int(10) unsigned NOT NULL,
  `pt_reason_id` bigint(20) unsigned NOT NULL,
  `pt_timestamp` binary(14) NOT NULL,
  `pt_expiry` varbinary(14) NOT NULL,
  `pt_create_perm` varbinary(60) NOT NULL,
  PRIMARY KEY (`pt_namespace`,`pt_title`),
  KEY `pt_timestamp` (`pt_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `querycache` (
  `qc_type` varbinary(32) NOT NULL,
  `qc_value` int(10) unsigned NOT NULL DEFAULT 0,
  `qc_namespace` int(11) NOT NULL DEFAULT 0,
  `qc_title` varbinary(255) NOT NULL DEFAULT '',
  KEY `qc_type` (`qc_type`,`qc_value`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `querycache_info` (
  `qci_type` varbinary(32) NOT NULL DEFAULT '',
  `qci_timestamp` binary(14) NOT NULL DEFAULT '19700101000000',
  PRIMARY KEY (`qci_type`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `querycachetwo` (
  `qcc_type` varbinary(32) NOT NULL,
  `qcc_value` int(10) unsigned NOT NULL DEFAULT 0,
  `qcc_namespace` int(11) NOT NULL DEFAULT 0,
  `qcc_title` varbinary(255) NOT NULL DEFAULT '',
  `qcc_namespacetwo` int(11) NOT NULL DEFAULT 0,
  `qcc_titletwo` varbinary(255) NOT NULL DEFAULT '',
  KEY `qcc_type` (`qcc_type`,`qcc_value`),
  KEY `qcc_title` (`qcc_type`,`qcc_namespace`,`qcc_title`),
  KEY `qcc_titletwo` (`qcc_type`,`qcc_namespacetwo`,`qcc_titletwo`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `recentchanges` (
  `rc_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rc_timestamp` binary(14) NOT NULL,
  `rc_actor` bigint(20) unsigned NOT NULL,
  `rc_namespace` int(11) NOT NULL DEFAULT 0,
  `rc_title` varbinary(255) NOT NULL DEFAULT '',
  `rc_comment_id` bigint(20) unsigned NOT NULL,
  `rc_minor` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rc_bot` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rc_new` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rc_cur_id` int(10) unsigned NOT NULL DEFAULT 0,
  `rc_this_oldid` int(10) unsigned NOT NULL DEFAULT 0,
  `rc_last_oldid` int(10) unsigned NOT NULL DEFAULT 0,
  `rc_type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rc_source` varbinary(16) NOT NULL DEFAULT '',
  `rc_patrolled` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rc_ip` varbinary(40) NOT NULL DEFAULT '',
  `rc_old_len` int(11) DEFAULT NULL,
  `rc_new_len` int(11) DEFAULT NULL,
  `rc_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rc_logid` int(10) unsigned NOT NULL DEFAULT 0,
  `rc_log_type` varbinary(255) DEFAULT NULL,
  `rc_log_action` varbinary(255) DEFAULT NULL,
  `rc_params` blob DEFAULT NULL,
  PRIMARY KEY (`rc_id`),
  KEY `rc_timestamp` (`rc_timestamp`),
  KEY `rc_namespace_title_timestamp` (`rc_namespace`,`rc_title`,`rc_timestamp`),
  KEY `rc_cur_id` (`rc_cur_id`),
  KEY `rc_new_name_timestamp` (`rc_new`,`rc_namespace`,`rc_timestamp`),
  KEY `rc_ip` (`rc_ip`),
  KEY `rc_ns_actor` (`rc_namespace`,`rc_actor`),
  KEY `rc_actor` (`rc_actor`,`rc_timestamp`),
  KEY `rc_name_type_patrolled_timestamp` (`rc_namespace`,`rc_type`,`rc_patrolled`,`rc_timestamp`),
  KEY `rc_this_oldid` (`rc_this_oldid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `redirect` (
  `rd_from` int(10) unsigned NOT NULL DEFAULT 0,
  `rd_namespace` int(11) NOT NULL DEFAULT 0,
  `rd_title` varbinary(255) NOT NULL DEFAULT '',
  `rd_interwiki` varbinary(32) DEFAULT NULL,
  `rd_fragment` varbinary(255) DEFAULT NULL,
  PRIMARY KEY (`rd_from`),
  KEY `rd_ns_title` (`rd_namespace`,`rd_title`,`rd_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `revision` (
  `rev_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rev_page` int(10) unsigned NOT NULL,
  `rev_comment_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `rev_actor` bigint(20) unsigned NOT NULL DEFAULT 0,
  `rev_timestamp` binary(14) NOT NULL,
  `rev_minor_edit` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rev_deleted` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rev_len` int(10) unsigned DEFAULT NULL,
  `rev_parent_id` int(10) unsigned DEFAULT NULL,
  `rev_sha1` varbinary(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`rev_id`),
  KEY `rev_timestamp` (`rev_timestamp`),
  KEY `rev_page_timestamp` (`rev_page`,`rev_timestamp`),
  KEY `rev_actor_timestamp` (`rev_actor`,`rev_timestamp`,`rev_id`),
  KEY `rev_page_actor_timestamp` (`rev_page`,`rev_actor`,`rev_timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `searchindex` (
  `si_page` int(10) unsigned NOT NULL,
  `si_title` varchar(255) NOT NULL DEFAULT '',
  `si_text` mediumtext NOT NULL,
  UNIQUE KEY `si_page` (`si_page`),
  FULLTEXT KEY `si_title` (`si_title`),
  FULLTEXT KEY `si_text` (`si_text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci

CREATE TABLE `site_identifiers` (
  `si_type` varbinary(32) NOT NULL,
  `si_key` varbinary(32) NOT NULL,
  `si_site` int(10) unsigned NOT NULL,
  PRIMARY KEY (`si_type`,`si_key`),
  KEY `si_site` (`si_site`),
  KEY `si_key` (`si_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `site_stats` (
  `ss_row_id` int(10) unsigned NOT NULL,
  `ss_total_edits` bigint(20) unsigned DEFAULT NULL,
  `ss_good_articles` bigint(20) unsigned DEFAULT NULL,
  `ss_total_pages` bigint(20) unsigned DEFAULT NULL,
  `ss_users` bigint(20) unsigned DEFAULT NULL,
  `ss_active_users` bigint(20) unsigned DEFAULT NULL,
  `ss_images` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`ss_row_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `sites` (
  `site_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `site_global_key` varbinary(64) NOT NULL,
  `site_type` varbinary(32) NOT NULL,
  `site_group` varbinary(32) NOT NULL,
  `site_source` varbinary(32) NOT NULL,
  `site_language` varbinary(35) NOT NULL,
  `site_protocol` varbinary(32) NOT NULL,
  `site_domain` varbinary(255) NOT NULL,
  `site_data` blob NOT NULL,
  `site_forward` tinyint(1) NOT NULL,
  `site_config` blob NOT NULL,
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `site_global_key` (`site_global_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `slot_roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varbinary(64) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `slots` (
  `slot_revision_id` bigint(20) unsigned NOT NULL,
  `slot_role_id` smallint(5) unsigned NOT NULL,
  `slot_content_id` bigint(20) unsigned NOT NULL,
  `slot_origin` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`slot_revision_id`,`slot_role_id`),
  KEY `slot_revision_origin_role` (`slot_revision_id`,`slot_origin`,`slot_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `templatelinks` (
  `tl_from` int(10) unsigned NOT NULL DEFAULT 0,
  `tl_target_id` bigint(20) unsigned NOT NULL,
  `tl_from_namespace` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`tl_from`,`tl_target_id`),
  KEY `tl_target_id` (`tl_target_id`,`tl_from`),
  KEY `tl_backlinks_namespace_target_id` (`tl_from_namespace`,`tl_target_id`,`tl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `text` (
  `old_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `old_text` mediumblob NOT NULL,
  `old_flags` tinyblob NOT NULL,
  PRIMARY KEY (`old_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=binary

CREATE TABLE `updatelog` (
  `ul_key` varbinary(255) NOT NULL,
  `ul_value` blob DEFAULT NULL,
  PRIMARY KEY (`ul_key`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `uploadstash` (
  `us_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `us_user` int(10) unsigned NOT NULL,
  `us_key` varbinary(255) NOT NULL,
  `us_orig_path` varbinary(255) NOT NULL,
  `us_path` varbinary(255) NOT NULL,
  `us_source_type` varbinary(50) DEFAULT NULL,
  `us_timestamp` binary(14) NOT NULL,
  `us_status` varbinary(50) NOT NULL,
  `us_chunk_inx` int(10) unsigned DEFAULT NULL,
  `us_props` blob DEFAULT NULL,
  `us_size` bigint(20) unsigned NOT NULL,
  `us_sha1` varbinary(31) NOT NULL,
  `us_mime` varbinary(255) DEFAULT NULL,
  `us_media_type` enum('UNKNOWN','BITMAP','DRAWING','AUDIO','VIDEO','MULTIMEDIA','OFFICE','TEXT','EXECUTABLE','ARCHIVE','3D') DEFAULT NULL,
  `us_image_width` int(10) unsigned DEFAULT NULL,
  `us_image_height` int(10) unsigned DEFAULT NULL,
  `us_image_bits` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`us_id`),
  UNIQUE KEY `us_key` (`us_key`),
  KEY `us_user` (`us_user`),
  KEY `us_timestamp` (`us_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varbinary(255) NOT NULL DEFAULT '',
  `user_real_name` varbinary(255) NOT NULL DEFAULT '',
  `user_password` tinyblob NOT NULL,
  `user_newpassword` tinyblob NOT NULL,
  `user_newpass_time` binary(14) DEFAULT NULL,
  `user_email` tinyblob NOT NULL,
  `user_touched` binary(14) NOT NULL,
  `user_token` binary(32) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
  `user_email_authenticated` binary(14) DEFAULT NULL,
  `user_email_token` binary(32) DEFAULT NULL,
  `user_email_token_expires` binary(14) DEFAULT NULL,
  `user_registration` binary(14) DEFAULT NULL,
  `user_editcount` int(10) unsigned DEFAULT NULL,
  `user_password_expires` varbinary(14) DEFAULT NULL,
  `user_is_temp` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  KEY `user_email_token` (`user_email_token`),
  KEY `user_email` (`user_email`(50))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=binary

CREATE TABLE `user_autocreate_serial` (
  `uas_shard` int(10) unsigned NOT NULL,
  `uas_year` smallint(5) unsigned NOT NULL,
  `uas_value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`uas_shard`,`uas_year`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `user_former_groups` (
  `ufg_user` int(10) unsigned NOT NULL DEFAULT 0,
  `ufg_group` varbinary(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`ufg_user`,`ufg_group`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `user_groups` (
  `ug_user` int(10) unsigned NOT NULL DEFAULT 0,
  `ug_group` varbinary(255) NOT NULL DEFAULT '',
  `ug_expiry` varbinary(14) DEFAULT NULL,
  PRIMARY KEY (`ug_user`,`ug_group`),
  KEY `ug_group` (`ug_group`),
  KEY `ug_expiry` (`ug_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `user_newtalk` (
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `user_ip` varbinary(40) NOT NULL DEFAULT '',
  `user_last_timestamp` binary(14) DEFAULT NULL,
  KEY `un_user_id` (`user_id`),
  KEY `un_user_ip` (`user_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `user_properties` (
  `up_user` int(10) unsigned NOT NULL,
  `up_property` varbinary(255) NOT NULL,
  `up_value` blob DEFAULT NULL,
  PRIMARY KEY (`up_user`,`up_property`),
  KEY `up_property` (`up_property`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `watchlist` (
  `wl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wl_user` int(10) unsigned NOT NULL,
  `wl_namespace` int(11) NOT NULL DEFAULT 0,
  `wl_title` varbinary(255) NOT NULL DEFAULT '',
  `wl_notificationtimestamp` binary(14) DEFAULT NULL,
  PRIMARY KEY (`wl_id`),
  UNIQUE KEY `wl_user` (`wl_user`,`wl_namespace`,`wl_title`),
  KEY `wl_namespace_title` (`wl_namespace`,`wl_title`),
  KEY `wl_user_notificationtimestamp` (`wl_user`,`wl_notificationtimestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

CREATE TABLE `watchlist_expiry` (
  `we_item` int(10) unsigned NOT NULL,
  `we_expiry` binary(14) NOT NULL,
  PRIMARY KEY (`we_item`),
  KEY `we_expiry` (`we_expiry`)
) ENGINE=InnoDB DEFAULT CHARSET=binary

