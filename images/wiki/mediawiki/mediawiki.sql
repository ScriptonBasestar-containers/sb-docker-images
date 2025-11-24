create table abuse_filter
(
    af_id              bigint unsigned auto_increment
        primary key,
    af_pattern         blob                              not null,
    af_user            bigint unsigned default 0         not null,
    af_user_text       varbinary(255)  default ''        not null,
    af_actor           bigint unsigned default 0         not null,
    af_timestamp       binary(14)                        not null,
    af_enabled         tinyint(1)      default 1         not null,
    af_comments        blob                              null,
    af_public_comments tinyblob                          null,
    af_hidden          tinyint(1)      default 0         not null,
    af_hit_count       bigint          default 0         not null,
    af_throttled       tinyint(1)      default 0         not null,
    af_deleted         tinyint(1)      default 0         not null,
    af_actions         varbinary(255)  default ''        not null,
    af_global          tinyint(1)      default 0         not null,
    af_group           varbinary(64)   default 'default' not null
)
    charset = `binary`;

create index af_actor
    on abuse_filter (af_actor);

create index af_group_enabled
    on abuse_filter (af_group, af_enabled, af_id);

create index af_user
    on abuse_filter (af_user);

create table abuse_filter_action
(
    afa_filter      bigint unsigned not null,
    afa_consequence varbinary(255)  not null,
    afa_parameters  tinyblob        not null,
    primary key (afa_filter, afa_consequence)
)
    charset = `binary`;

create index afa_consequence
    on abuse_filter_action (afa_consequence);

create table abuse_filter_history
(
    afh_id              bigint unsigned auto_increment
        primary key,
    afh_filter          bigint unsigned            not null,
    afh_user            bigint unsigned default 0  not null,
    afh_user_text       varbinary(255)  default '' not null,
    afh_actor           bigint unsigned default 0  not null,
    afh_timestamp       binary(14)                 not null,
    afh_pattern         blob                       not null,
    afh_comments        blob                       not null,
    afh_flags           tinyblob                   not null,
    afh_public_comments tinyblob                   null,
    afh_actions         blob                       null,
    afh_deleted         tinyint(1)      default 0  not null,
    afh_changed_fields  varbinary(255)  default '' not null,
    afh_group           varbinary(64)              null
)
    charset = `binary`;

create index afh_actor
    on abuse_filter_history (afh_actor);

create index afh_filter
    on abuse_filter_history (afh_filter);

create index afh_timestamp
    on abuse_filter_history (afh_timestamp);

create index afh_user
    on abuse_filter_history (afh_user);

create index afh_user_text
    on abuse_filter_history (afh_user_text);

create table abuse_filter_log
(
    afl_id           bigint unsigned auto_increment
        primary key,
    afl_global       tinyint(1)             not null,
    afl_filter_id    bigint unsigned        not null,
    afl_user         bigint unsigned        not null,
    afl_user_text    varbinary(255)         not null,
    afl_ip           varbinary(255)         not null,
    afl_action       varbinary(255)         not null,
    afl_actions      varbinary(255)         not null,
    afl_var_dump     blob                   not null,
    afl_timestamp    binary(14)             not null,
    afl_namespace    int                    not null,
    afl_title        varbinary(255)         not null,
    afl_wiki         varbinary(64)          null,
    afl_deleted      tinyint(1)   default 0 not null,
    afl_patrolled_by int unsigned default 0 not null,
    afl_rev_id       int unsigned           null
)
    charset = `binary`;

create index afl_filter_timestamp_full
    on abuse_filter_log (afl_global, afl_filter_id, afl_timestamp);

create index afl_ip_timestamp
    on abuse_filter_log (afl_ip, afl_timestamp);

create index afl_page_timestamp
    on abuse_filter_log (afl_namespace, afl_title, afl_timestamp);

create index afl_rev_id
    on abuse_filter_log (afl_rev_id);

create index afl_timestamp
    on abuse_filter_log (afl_timestamp);

create index afl_user_timestamp
    on abuse_filter_log (afl_user, afl_user_text, afl_timestamp);

create index afl_wiki_timestamp
    on abuse_filter_log (afl_wiki, afl_timestamp);

create table actor
(
    actor_id   bigint unsigned auto_increment
        primary key,
    actor_user int unsigned   null,
    actor_name varbinary(255) not null,
    constraint actor_name
        unique (actor_name),
    constraint actor_user
        unique (actor_user)
)
    charset = `binary`;

create table archive
(
    ar_id         int unsigned auto_increment
        primary key,
    ar_namespace  int              default 0  not null,
    ar_title      varbinary(255)   default '' not null,
    ar_comment_id bigint unsigned             not null,
    ar_actor      bigint unsigned             not null,
    ar_timestamp  binary(14)                  not null,
    ar_minor_edit tinyint          default 0  not null,
    ar_rev_id     int unsigned                not null,
    ar_deleted    tinyint unsigned default 0  not null,
    ar_len        int unsigned                null,
    ar_page_id    int unsigned                null,
    ar_parent_id  int unsigned                null,
    ar_sha1       varbinary(32)    default '' not null,
    constraint ar_revid_uniq
        unique (ar_rev_id)
)
    charset = `binary`;

create index ar_actor_timestamp
    on archive (ar_actor, ar_timestamp);

create index ar_name_title_timestamp
    on archive (ar_namespace, ar_title, ar_timestamp);

create table block
(
    bl_id               int unsigned auto_increment
        primary key,
    bl_target           int unsigned         not null,
    bl_by_actor         bigint unsigned      not null,
    bl_reason_id        bigint unsigned      not null,
    bl_timestamp        binary(14)           not null,
    bl_anon_only        tinyint(1) default 0 not null,
    bl_create_account   tinyint(1) default 1 not null,
    bl_enable_autoblock tinyint(1) default 1 not null,
    bl_expiry           varbinary(14)        not null,
    bl_deleted          tinyint(1) default 0 not null,
    bl_block_email      tinyint(1) default 0 not null,
    bl_allow_usertalk   tinyint(1) default 0 not null,
    bl_parent_block_id  int unsigned         null,
    bl_sitewide         tinyint(1) default 1 not null
)
    charset = `binary`;

create index bl_expiry
    on block (bl_expiry);

create index bl_parent_block_id
    on block (bl_parent_block_id);

create index bl_target
    on block (bl_target);

create index bl_timestamp
    on block (bl_timestamp);

create table block_target
(
    bt_id          int unsigned auto_increment
        primary key,
    bt_address     tinyblob             null,
    bt_user        int unsigned         null,
    bt_user_text   varbinary(255)       null,
    bt_auto        tinyint(1) default 0 not null,
    bt_range_start tinyblob             null,
    bt_range_end   tinyblob             null,
    bt_ip_hex      tinyblob             null,
    bt_count       int        default 0 not null
)
    charset = `binary`;

create index bt_address
    on block_target (bt_address(42));

create index bt_ip_user_text
    on block_target (bt_ip_hex(35), bt_user_text);

create index bt_range
    on block_target (bt_range_start(35), bt_range_end(35));

create index bt_user
    on block_target (bt_user);

create table bot_passwords
(
    bp_user         int unsigned                                                                          not null,
    bp_app_id       varbinary(32)                                                                         not null,
    bp_password     tinyblob                                                                              not null,
    bp_token        binary(32) default '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' not null,
    bp_restrictions blob                                                                                  not null,
    bp_grants       blob                                                                                  not null,
    primary key (bp_user, bp_app_id)
)
    charset = `binary`;

create table category
(
    cat_id      int unsigned auto_increment
        primary key,
    cat_title   varbinary(255) not null,
    cat_pages   int default 0  not null,
    cat_subcats int default 0  not null,
    cat_files   int default 0  not null,
    constraint cat_title
        unique (cat_title)
)
    charset = `binary`;

create index cat_pages
    on category (cat_pages);

create table categorylinks
(
    cl_from           int unsigned                    default 0      not null,
    cl_to             varbinary(255)                  default ''     not null,
    cl_sortkey        varbinary(230)                  default ''     not null,
    cl_sortkey_prefix varbinary(255)                  default ''     not null,
    cl_timestamp      timestamp                                      not null,
    cl_collation      varbinary(32)                   default ''     not null,
    cl_type           enum ('page', 'subcat', 'file') default 'page' not null,
    primary key (cl_from, cl_to)
)
    charset = `binary`;

create index cl_sortkey
    on categorylinks (cl_to, cl_type, cl_sortkey, cl_from);

create index cl_timestamp
    on categorylinks (cl_to, cl_timestamp);

create table change_tag
(
    ct_id     int unsigned auto_increment
        primary key,
    ct_rc_id  int unsigned null,
    ct_log_id int unsigned null,
    ct_rev_id int unsigned null,
    ct_params blob         null,
    ct_tag_id int unsigned not null,
    constraint ct_log_tag_id
        unique (ct_log_id, ct_tag_id),
    constraint ct_rc_tag_id
        unique (ct_rc_id, ct_tag_id),
    constraint ct_rev_tag_id
        unique (ct_rev_id, ct_tag_id)
)
    charset = `binary`;

create index ct_tag_id_id
    on change_tag (ct_tag_id, ct_rc_id, ct_rev_id, ct_log_id);

create table change_tag_def
(
    ctd_id           int unsigned auto_increment
        primary key,
    ctd_name         varbinary(255)            not null,
    ctd_user_defined tinyint(1)                not null,
    ctd_count        bigint unsigned default 0 not null,
    constraint ctd_name
        unique (ctd_name)
)
    charset = `binary`;

create index ctd_count
    on change_tag_def (ctd_count);

create index ctd_user_defined
    on change_tag_def (ctd_user_defined);

create table comment
(
    comment_id   bigint unsigned auto_increment
        primary key,
    comment_hash int  not null,
    comment_text blob not null,
    comment_data blob null
)
    charset = `binary`;

create index comment_hash
    on comment (comment_hash);

create table content
(
    content_id      bigint unsigned auto_increment
        primary key,
    content_size    int unsigned      not null,
    content_sha1    varbinary(32)     not null,
    content_model   smallint unsigned not null,
    content_address varbinary(255)    not null
)
    charset = `binary`;

create table content_models
(
    model_id   int auto_increment
        primary key,
    model_name varbinary(64) not null,
    constraint model_name
        unique (model_name)
)
    charset = `binary`;

create table discussiontools_item_ids
(
    itid_id     int unsigned auto_increment
        primary key,
    itid_itemid varbinary(255) not null,
    constraint itid_itemid
        unique (itid_itemid)
)
    charset = `binary`;

create table discussiontools_item_pages
(
    itp_id                 int unsigned auto_increment
        primary key,
    itp_items_id           int unsigned    not null,
    itp_page_id            bigint unsigned not null,
    itp_oldest_revision_id bigint unsigned not null,
    itp_newest_revision_id bigint unsigned not null,
    constraint itp_items_id_newest_revision_id
        unique (itp_items_id, itp_newest_revision_id),
    constraint itp_items_id_page_id
        unique (itp_items_id, itp_page_id)
)
    charset = `binary`;

create table discussiontools_item_revisions
(
    itr_id              int unsigned auto_increment
        primary key,
    itr_itemid_id       int             not null,
    itr_revision_id     bigint unsigned not null,
    itr_items_id        int             not null,
    itr_parent_id       int             null,
    itr_transcludedfrom bigint unsigned null,
    itr_level           tinyint         not null,
    itr_headinglevel    tinyint         null,
    constraint itr_itemid_id_revision_id
        unique (itr_itemid_id, itr_revision_id)
)
    charset = `binary`;

create index itr_revision_id
    on discussiontools_item_revisions (itr_revision_id);

create table discussiontools_items
(
    it_id        int unsigned auto_increment
        primary key,
    it_itemname  varbinary(255)  not null,
    it_timestamp binary(14)      null,
    it_actor     bigint unsigned null,
    constraint it_itemname
        unique (it_itemname)
)
    charset = `binary`;

create table discussiontools_subscription
(
    sub_id        int unsigned auto_increment
        primary key,
    sub_item      varbinary(255) not null,
    sub_namespace int default 0  not null,
    sub_title     varbinary(255) not null,
    sub_section   varbinary(255) not null,
    sub_state     int default 1  not null,
    sub_user      int unsigned   not null,
    sub_created   binary(14)     not null,
    sub_notified  binary(14)     null,
    constraint discussiontools_subscription_itemuser
        unique (sub_item, sub_user)
)
    charset = `binary`;

create index discussiontools_subscription_user
    on discussiontools_subscription (sub_user);

create table echo_email_batch
(
    eeb_id             int unsigned auto_increment
        primary key,
    eeb_user_id        int unsigned                not null,
    eeb_event_priority tinyint unsigned default 10 not null,
    eeb_event_id       int unsigned                not null,
    eeb_event_hash     varbinary(32)               not null,
    constraint echo_email_batch_user_event
        unique (eeb_user_id, eeb_event_id)
)
    charset = `binary`;

create index echo_email_batch_user_hash_priority
    on echo_email_batch (eeb_user_id, eeb_event_hash, eeb_event_priority);

create table echo_event
(
    event_id       int unsigned auto_increment
        primary key,
    event_type     varbinary(64)              not null,
    event_variant  varbinary(64)              null,
    event_agent_id int unsigned               null,
    event_agent_ip varbinary(39)              null,
    event_extra    blob                       null,
    event_page_id  int unsigned               null,
    event_deleted  tinyint unsigned default 0 not null
)
    charset = `binary`;

create index echo_event_page_id
    on echo_event (event_page_id);

create index echo_event_type
    on echo_event (event_type);

create table echo_notification
(
    notification_event          int unsigned  not null,
    notification_user           int unsigned  not null,
    notification_timestamp      binary(14)    not null,
    notification_read_timestamp binary(14)    null,
    notification_bundle_hash    varbinary(32) not null,
    primary key (notification_user, notification_event)
)
    charset = `binary`;

create index echo_notification_event
    on echo_notification (notification_event);

create index echo_notification_user_read_timestamp
    on echo_notification (notification_user, notification_read_timestamp);

create index echo_user_timestamp
    on echo_notification (notification_user, notification_timestamp);

create table echo_push_provider
(
    epp_id   tinyint unsigned auto_increment
        primary key,
    epp_name tinyblob not null
)
    charset = `binary`;

create table echo_push_subscription
(
    eps_id           int unsigned auto_increment
        primary key,
    eps_user         int unsigned     not null,
    eps_token        blob             not null,
    eps_token_sha256 binary(64)       not null,
    eps_provider     tinyint unsigned not null,
    eps_updated      timestamp        not null,
    eps_data         blob             null,
    eps_topic        tinyint unsigned null,
    constraint eps_token_sha256
        unique (eps_token_sha256)
)
    charset = `binary`;

create index eps_provider
    on echo_push_subscription (eps_provider);

create index eps_token
    on echo_push_subscription (eps_token(10));

create index eps_topic
    on echo_push_subscription (eps_topic);

create index eps_user
    on echo_push_subscription (eps_user);

create table echo_push_topic
(
    ept_id   tinyint unsigned auto_increment
        primary key,
    ept_text tinyblob not null
)
    charset = `binary`;

create table echo_target_page
(
    etp_id    int unsigned auto_increment
        primary key,
    etp_page  int unsigned default 0 not null,
    etp_event int unsigned default 0 not null
)
    charset = `binary`;

create index echo_target_page_event
    on echo_target_page (etp_event);

create index echo_target_page_page_event
    on echo_target_page (etp_page, etp_event);

create table externallinks
(
    el_id              int unsigned auto_increment
        primary key,
    el_from            int unsigned   default 0  not null,
    el_to_domain_index varbinary(255) default '' not null,
    el_to_path         blob                      null
)
    charset = `binary`;

create index el_from
    on externallinks (el_from);

create index el_to_domain_index_to_path
    on externallinks (el_to_domain_index, el_to_path(60));

create table filearchive
(
    fa_id                int unsigned auto_increment
        primary key,
    fa_name              varbinary(255)                                                                                                  default ''        not null,
    fa_archive_name      varbinary(255)                                                                                                  default ''        null,
    fa_storage_group     varbinary(16)                                                                                                                     null,
    fa_storage_key       varbinary(64)                                                                                                   default ''        null,
    fa_deleted_user      int                                                                                                                               null,
    fa_deleted_timestamp binary(14)                                                                                                                        null,
    fa_deleted_reason_id bigint unsigned                                                                                                                   not null,
    fa_size              bigint unsigned                                                                                                 default 0         null,
    fa_width             int                                                                                                             default 0         null,
    fa_height            int                                                                                                             default 0         null,
    fa_metadata          mediumblob                                                                                                                        null,
    fa_bits              int                                                                                                             default 0         null,
    fa_media_type        enum ('UNKNOWN', 'BITMAP', 'DRAWING', 'AUDIO', 'VIDEO', 'MULTIMEDIA', 'OFFICE', 'TEXT', 'EXECUTABLE', 'ARCHIVE', '3D')            null,
    fa_major_mime        enum ('unknown', 'application', 'audio', 'image', 'text', 'video', 'message', 'model', 'multipart', 'chemical') default 'unknown' null,
    fa_minor_mime        varbinary(100)                                                                                                  default 'unknown' null,
    fa_description_id    bigint unsigned                                                                                                                   not null,
    fa_actor             bigint unsigned                                                                                                                   not null,
    fa_timestamp         binary(14)                                                                                                                        null,
    fa_deleted           tinyint unsigned                                                                                                default 0         not null,
    fa_sha1              varbinary(32)                                                                                                   default ''        not null
)
    charset = `binary`;

create index fa_actor_timestamp
    on filearchive (fa_actor, fa_timestamp);

create index fa_deleted_timestamp
    on filearchive (fa_deleted_timestamp);

create index fa_name
    on filearchive (fa_name, fa_timestamp);

create index fa_sha1
    on filearchive (fa_sha1(10));

create index fa_storage_group
    on filearchive (fa_storage_group, fa_storage_key);

create table image
(
    img_name           varbinary(255)                                                                                                  default ''        not null
        primary key,
    img_size           bigint unsigned                                                                                                 default 0         not null,
    img_width          int                                                                                                             default 0         not null,
    img_height         int                                                                                                             default 0         not null,
    img_metadata       mediumblob                                                                                                                        not null,
    img_bits           int                                                                                                             default 0         not null,
    img_media_type     enum ('UNKNOWN', 'BITMAP', 'DRAWING', 'AUDIO', 'VIDEO', 'MULTIMEDIA', 'OFFICE', 'TEXT', 'EXECUTABLE', 'ARCHIVE', '3D')            null,
    img_major_mime     enum ('unknown', 'application', 'audio', 'image', 'text', 'video', 'message', 'model', 'multipart', 'chemical') default 'unknown' not null,
    img_minor_mime     varbinary(100)                                                                                                  default 'unknown' not null,
    img_description_id bigint unsigned                                                                                                                   not null,
    img_actor          bigint unsigned                                                                                                                   not null,
    img_timestamp      binary(14)                                                                                                                        not null,
    img_sha1           varbinary(32)                                                                                                   default ''        not null
)
    charset = `binary`;

create index img_actor_timestamp
    on image (img_actor, img_timestamp);

create index img_media_mime
    on image (img_media_type, img_major_mime, img_minor_mime);

create index img_sha1
    on image (img_sha1(10));

create index img_size
    on image (img_size);

create index img_timestamp
    on image (img_timestamp);

create table imagelinks
(
    il_from           int unsigned   default 0  not null,
    il_to             varbinary(255) default '' not null,
    il_from_namespace int            default 0  not null,
    primary key (il_from, il_to)
)
    charset = `binary`;

create index il_backlinks_namespace
    on imagelinks (il_from_namespace, il_to, il_from);

create index il_to
    on imagelinks (il_to, il_from);

create table interwiki
(
    iw_prefix varbinary(32)     not null
        primary key,
    iw_url    blob              not null,
    iw_api    blob              not null,
    iw_wikiid varbinary(64)     not null,
    iw_local  tinyint(1)        not null,
    iw_trans  tinyint default 0 not null
)
    charset = `binary`;

create table ip_changes
(
    ipc_rev_id        int unsigned  default 0  not null
        primary key,
    ipc_rev_timestamp binary(14)               not null,
    ipc_hex           varbinary(35) default '' not null
)
    charset = `binary`;

create index ipc_hex_time
    on ip_changes (ipc_hex, ipc_rev_timestamp);

create index ipc_rev_timestamp
    on ip_changes (ipc_rev_timestamp);

create table ipblocks
(
    ipb_id               int unsigned auto_increment
        primary key,
    ipb_address          tinyblob               not null,
    ipb_user             int unsigned default 0 not null,
    ipb_by_actor         bigint unsigned        not null,
    ipb_reason_id        bigint unsigned        not null,
    ipb_timestamp        binary(14)             not null,
    ipb_auto             tinyint(1)   default 0 not null,
    ipb_anon_only        tinyint(1)   default 0 not null,
    ipb_create_account   tinyint(1)   default 1 not null,
    ipb_enable_autoblock tinyint(1)   default 1 not null,
    ipb_expiry           varbinary(14)          not null,
    ipb_range_start      tinyblob               not null,
    ipb_range_end        tinyblob               not null,
    ipb_deleted          tinyint(1)   default 0 not null,
    ipb_block_email      tinyint(1)   default 0 not null,
    ipb_allow_usertalk   tinyint(1)   default 0 not null,
    ipb_parent_block_id  int unsigned           null,
    ipb_sitewide         tinyint(1)   default 1 not null,
    constraint ipb_address_unique
        unique (ipb_address(255), ipb_user, ipb_auto)
)
    charset = `binary`;

create index ipb_expiry
    on ipblocks (ipb_expiry);

create index ipb_parent_block_id
    on ipblocks (ipb_parent_block_id);

create index ipb_range
    on ipblocks (ipb_range_start(8), ipb_range_end(8));

create index ipb_timestamp
    on ipblocks (ipb_timestamp);

create index ipb_user
    on ipblocks (ipb_user);

create table ipblocks_restrictions
(
    ir_ipb_id int unsigned not null,
    ir_type   tinyint      not null,
    ir_value  int unsigned not null,
    primary key (ir_ipb_id, ir_type, ir_value)
)
    charset = `binary`;

create index ir_type_value
    on ipblocks_restrictions (ir_type, ir_value);

create table iwlinks
(
    iwl_from   int unsigned   default 0  not null,
    iwl_prefix varbinary(32)  default '' not null,
    iwl_title  varbinary(255) default '' not null,
    primary key (iwl_from, iwl_prefix, iwl_title)
)
    charset = `binary`;

create index iwl_prefix_title_from
    on iwlinks (iwl_prefix, iwl_title, iwl_from);

create table job
(
    job_id              int unsigned auto_increment
        primary key,
    job_cmd             varbinary(60) default '' not null,
    job_namespace       int                      not null,
    job_title           varbinary(255)           not null,
    job_timestamp       binary(14)               null,
    job_params          mediumblob               not null,
    job_random          int unsigned  default 0  not null,
    job_attempts        int unsigned  default 0  not null,
    job_token           varbinary(32) default '' not null,
    job_token_timestamp binary(14)               null,
    job_sha1            varbinary(32) default '' not null
)
    charset = `binary`;

create index job_cmd
    on job (job_cmd, job_namespace, job_title, job_params(128));

create index job_cmd_token
    on job (job_cmd, job_token, job_random);

create index job_cmd_token_id
    on job (job_cmd, job_token, job_id);

create index job_sha1
    on job (job_sha1);

create index job_timestamp
    on job (job_timestamp);

create table l10n_cache
(
    lc_lang  varbinary(35)  not null,
    lc_key   varbinary(255) not null,
    lc_value mediumblob     not null,
    primary key (lc_lang, lc_key)
)
    charset = `binary`;

create table langlinks
(
    ll_from  int unsigned   default 0  not null,
    ll_lang  varbinary(35)  default '' not null,
    ll_title varbinary(255) default '' not null,
    primary key (ll_from, ll_lang)
)
    charset = `binary`;

create index ll_lang
    on langlinks (ll_lang, ll_title);

create table linktarget
(
    lt_id        bigint unsigned auto_increment
        primary key,
    lt_namespace int            not null,
    lt_title     varbinary(255) not null,
    constraint lt_namespace_title
        unique (lt_namespace, lt_title)
)
    charset = `binary`;

create table linter
(
    linter_id        int unsigned auto_increment
        primary key,
    linter_page      int unsigned              not null,
    linter_namespace int                       null,
    linter_cat       int unsigned              not null,
    linter_start     int unsigned              not null,
    linter_end       int unsigned              not null,
    linter_params    blob                      not null,
    linter_template  varbinary(255) default '' not null,
    linter_tag       varbinary(32)  default '' not null,
    constraint linter_cat_page_position
        unique (linter_cat, linter_page, linter_start, linter_end)
)
    charset = `binary`;

create index linter_cat_namespace
    on linter (linter_cat, linter_namespace);

create index linter_cat_tag
    on linter (linter_cat, linter_tag);

create index linter_cat_template
    on linter (linter_cat, linter_template);

create index linter_page
    on linter (linter_page);

create table log_search
(
    ls_field  varbinary(32)          not null,
    ls_value  varbinary(255)         not null,
    ls_log_id int unsigned default 0 not null,
    primary key (ls_field, ls_value, ls_log_id)
)
    charset = `binary`;

create index ls_log_id
    on log_search (ls_log_id);

create table logging
(
    log_id         int unsigned auto_increment
        primary key,
    log_type       varbinary(32)    default ''               not null,
    log_action     varbinary(32)    default ''               not null,
    log_timestamp  binary(14)       default '19700101000000' not null,
    log_actor      bigint unsigned                           not null,
    log_namespace  int              default 0                not null,
    log_title      varbinary(255)   default ''               not null,
    log_page       int unsigned                              null,
    log_comment_id bigint unsigned                           not null,
    log_params     blob                                      not null,
    log_deleted    tinyint unsigned default 0                not null
)
    charset = `binary`;

create index log_actor_time
    on logging (log_actor, log_timestamp);

create index log_actor_type_time
    on logging (log_actor, log_type, log_timestamp);

create index log_page_id_time
    on logging (log_page, log_timestamp);

create index log_page_time
    on logging (log_namespace, log_title, log_timestamp);

create index log_times
    on logging (log_timestamp);

create index log_type_action
    on logging (log_type, log_action, log_timestamp);

create index log_type_time
    on logging (log_type, log_timestamp);

create table loginnotify_seen_net
(
    lsn_id          int unsigned auto_increment
        primary key,
    lsn_time_bucket smallint unsigned not null,
    lsn_user        int unsigned      not null,
    lsn_subnet      bigint            not null,
    constraint loginnotify_seen_net_user
        unique (lsn_user, lsn_subnet, lsn_time_bucket)
)
    charset = `binary`;

create table module_deps
(
    md_module varbinary(255) not null,
    md_skin   varbinary(32)  not null,
    md_deps   mediumblob     not null,
    primary key (md_module, md_skin)
)
    charset = `binary`;

create table oathauth_devices
(
    oad_id      int auto_increment
        primary key,
    oad_user    int            not null,
    oad_type    int            not null,
    oad_name    varbinary(255) null,
    oad_created binary(14)     null,
    oad_data    blob           null
)
    charset = `binary`;

create index oad_user
    on oathauth_devices (oad_user);

create table oathauth_types
(
    oat_id   int auto_increment
        primary key,
    oat_name varbinary(255) not null,
    constraint oat_name
        unique (oat_name)
)
    charset = `binary`;

create table objectcache
(
    keyname  varbinary(255) default ''                  not null
        primary key,
    value    mediumblob                                 null,
    exptime  binary(14)                                 not null,
    modtoken varbinary(17)  default '00000000000000000' not null,
    flags    int unsigned                               null
)
    charset = `binary`;

create index exptime
    on objectcache (exptime);

create table oldimage
(
    oi_name           varbinary(255)                                                                                                  default ''        not null,
    oi_archive_name   varbinary(255)                                                                                                  default ''        not null,
    oi_size           bigint unsigned                                                                                                 default 0         not null,
    oi_width          int                                                                                                             default 0         not null,
    oi_height         int                                                                                                             default 0         not null,
    oi_bits           int                                                                                                             default 0         not null,
    oi_description_id bigint unsigned                                                                                                                   not null,
    oi_actor          bigint unsigned                                                                                                                   not null,
    oi_timestamp      binary(14)                                                                                                                        not null,
    oi_metadata       mediumblob                                                                                                                        not null,
    oi_media_type     enum ('UNKNOWN', 'BITMAP', 'DRAWING', 'AUDIO', 'VIDEO', 'MULTIMEDIA', 'OFFICE', 'TEXT', 'EXECUTABLE', 'ARCHIVE', '3D')            null,
    oi_major_mime     enum ('unknown', 'application', 'audio', 'image', 'text', 'video', 'message', 'model', 'multipart', 'chemical') default 'unknown' not null,
    oi_minor_mime     varbinary(100)                                                                                                  default 'unknown' not null,
    oi_deleted        tinyint unsigned                                                                                                default 0         not null,
    oi_sha1           varbinary(32)                                                                                                   default ''        not null
)
    charset = `binary`;

create index oi_actor_timestamp
    on oldimage (oi_actor, oi_timestamp);

create index oi_name_archive_name
    on oldimage (oi_name, oi_archive_name(14));

create index oi_name_timestamp
    on oldimage (oi_name, oi_timestamp);

create index oi_sha1
    on oldimage (oi_sha1(10));

create index oi_timestamp
    on oldimage (oi_timestamp);

create table page
(
    page_id            int unsigned auto_increment
        primary key,
    page_namespace     int                        not null,
    page_title         varbinary(255)             not null,
    page_is_redirect   tinyint unsigned default 0 not null,
    page_is_new        tinyint unsigned default 0 not null,
    page_random        double unsigned            not null,
    page_touched       binary(14)                 not null,
    page_links_updated varbinary(14)              null,
    page_latest        int unsigned               not null,
    page_len           int unsigned               not null,
    page_content_model varbinary(32)              null,
    page_lang          varbinary(35)              null,
    constraint page_name_title
        unique (page_namespace, page_title)
)
    charset = `binary`;

create index page_len
    on page (page_len);

create index page_random
    on page (page_random);

create index page_redirect_namespace_len
    on page (page_is_redirect, page_namespace, page_len);

create table page_props
(
    pp_page     int unsigned  not null,
    pp_propname varbinary(60) not null,
    pp_value    blob          not null,
    pp_sortkey  float         null,
    primary key (pp_page, pp_propname),
    constraint pp_propname_page
        unique (pp_propname, pp_page),
    constraint pp_propname_sortkey_page
        unique (pp_propname, pp_sortkey, pp_page)
)
    charset = `binary`;

create table page_restrictions
(
    pr_id      int unsigned auto_increment
        primary key,
    pr_page    int unsigned  not null,
    pr_type    varbinary(60) not null,
    pr_level   varbinary(60) not null,
    pr_cascade tinyint       not null,
    pr_expiry  varbinary(14) null,
    constraint pr_pagetype
        unique (pr_page, pr_type)
)
    charset = `binary`;

create index pr_cascade
    on page_restrictions (pr_cascade);

create index pr_level
    on page_restrictions (pr_level);

create index pr_typelevel
    on page_restrictions (pr_type, pr_level);

create table pagelinks
(
    pl_from           int unsigned   default 0  not null,
    pl_namespace      int            default 0  not null,
    pl_title          varbinary(255) default '' not null,
    pl_from_namespace int            default 0  not null,
    pl_target_id      bigint unsigned           null,
    primary key (pl_from, pl_namespace, pl_title)
)
    charset = `binary`;

create index pl_backlinks_namespace
    on pagelinks (pl_from_namespace, pl_namespace, pl_title, pl_from);

create index pl_backlinks_namespace_target_id
    on pagelinks (pl_from_namespace, pl_target_id, pl_from);

create index pl_namespace
    on pagelinks (pl_namespace, pl_title, pl_from);

create index pl_target_id
    on pagelinks (pl_target_id, pl_from);

create table protected_titles
(
    pt_namespace   int             not null,
    pt_title       varbinary(255)  not null,
    pt_user        int unsigned    not null,
    pt_reason_id   bigint unsigned not null,
    pt_timestamp   binary(14)      not null,
    pt_expiry      varbinary(14)   not null,
    pt_create_perm varbinary(60)   not null,
    primary key (pt_namespace, pt_title)
)
    charset = `binary`;

create index pt_timestamp
    on protected_titles (pt_timestamp);

create table querycache
(
    qc_type      varbinary(32)             not null,
    qc_value     int unsigned   default 0  not null,
    qc_namespace int            default 0  not null,
    qc_title     varbinary(255) default '' not null
)
    charset = `binary`;

create index qc_type
    on querycache (qc_type, qc_value);

create table querycache_info
(
    qci_type      varbinary(32) default ''               not null
        primary key,
    qci_timestamp binary(14)    default '19700101000000' not null
)
    charset = `binary`;

create table querycachetwo
(
    qcc_type         varbinary(32)             not null,
    qcc_value        int unsigned   default 0  not null,
    qcc_namespace    int            default 0  not null,
    qcc_title        varbinary(255) default '' not null,
    qcc_namespacetwo int            default 0  not null,
    qcc_titletwo     varbinary(255) default '' not null
)
    charset = `binary`;

create index qcc_title
    on querycachetwo (qcc_type, qcc_namespace, qcc_title);

create index qcc_titletwo
    on querycachetwo (qcc_type, qcc_namespacetwo, qcc_titletwo);

create index qcc_type
    on querycachetwo (qcc_type, qcc_value);

create table recentchanges
(
    rc_id         int unsigned auto_increment
        primary key,
    rc_timestamp  binary(14)                  not null,
    rc_actor      bigint unsigned             not null,
    rc_namespace  int              default 0  not null,
    rc_title      varbinary(255)   default '' not null,
    rc_comment_id bigint unsigned             not null,
    rc_minor      tinyint unsigned default 0  not null,
    rc_bot        tinyint unsigned default 0  not null,
    rc_new        tinyint unsigned default 0  not null,
    rc_cur_id     int unsigned     default 0  not null,
    rc_this_oldid int unsigned     default 0  not null,
    rc_last_oldid int unsigned     default 0  not null,
    rc_type       tinyint unsigned default 0  not null,
    rc_source     varbinary(16)    default '' not null,
    rc_patrolled  tinyint unsigned default 0  not null,
    rc_ip         varbinary(40)    default '' not null,
    rc_old_len    int                         null,
    rc_new_len    int                         null,
    rc_deleted    tinyint unsigned default 0  not null,
    rc_logid      int unsigned     default 0  not null,
    rc_log_type   varbinary(255)              null,
    rc_log_action varbinary(255)              null,
    rc_params     blob                        null
)
    charset = `binary`;

create index rc_actor
    on recentchanges (rc_actor, rc_timestamp);

create index rc_cur_id
    on recentchanges (rc_cur_id);

create index rc_ip
    on recentchanges (rc_ip);

create index rc_name_type_patrolled_timestamp
    on recentchanges (rc_namespace, rc_type, rc_patrolled, rc_timestamp);

create index rc_namespace_title_timestamp
    on recentchanges (rc_namespace, rc_title, rc_timestamp);

create index rc_new_name_timestamp
    on recentchanges (rc_new, rc_namespace, rc_timestamp);

create index rc_ns_actor
    on recentchanges (rc_namespace, rc_actor);

create index rc_this_oldid
    on recentchanges (rc_this_oldid);

create index rc_timestamp
    on recentchanges (rc_timestamp);

create table redirect
(
    rd_from      int unsigned   default 0  not null
        primary key,
    rd_namespace int            default 0  not null,
    rd_title     varbinary(255) default '' not null,
    rd_interwiki varbinary(32)             null,
    rd_fragment  varbinary(255)            null
)
    charset = `binary`;

create index rd_ns_title
    on redirect (rd_namespace, rd_title, rd_from);

create table revision
(
    rev_id         int unsigned auto_increment
        primary key,
    rev_page       int unsigned                not null,
    rev_comment_id bigint unsigned  default 0  not null,
    rev_actor      bigint unsigned  default 0  not null,
    rev_timestamp  binary(14)                  not null,
    rev_minor_edit tinyint unsigned default 0  not null,
    rev_deleted    tinyint unsigned default 0  not null,
    rev_len        int unsigned                null,
    rev_parent_id  int unsigned                null,
    rev_sha1       varbinary(32)    default '' not null
)
    charset = `binary`;

create index rev_actor_timestamp
    on revision (rev_actor, rev_timestamp, rev_id);

create index rev_page_actor_timestamp
    on revision (rev_page, rev_actor, rev_timestamp);

create index rev_page_timestamp
    on revision (rev_page, rev_timestamp);

create index rev_timestamp
    on revision (rev_timestamp);

create table searchindex
(
    si_page  int unsigned            not null,
    si_title varchar(255) default '' not null,
    si_text  mediumtext              not null,
    constraint si_page
        unique (si_page)
)
    engine = MyISAM
    collate = utf8mb3_uca1400_ai_ci;

create fulltext index si_text
    on searchindex (si_text);

create fulltext index si_title
    on searchindex (si_title);

create table site_identifiers
(
    si_type varbinary(32) not null,
    si_key  varbinary(32) not null,
    si_site int unsigned  not null,
    primary key (si_type, si_key)
)
    charset = `binary`;

create index si_key
    on site_identifiers (si_key);

create index si_site
    on site_identifiers (si_site);

create table site_stats
(
    ss_row_id        int unsigned    not null
        primary key,
    ss_total_edits   bigint unsigned null,
    ss_good_articles bigint unsigned null,
    ss_total_pages   bigint unsigned null,
    ss_users         bigint unsigned null,
    ss_active_users  bigint unsigned null,
    ss_images        bigint unsigned null
)
    charset = `binary`;

create table sites
(
    site_id         int unsigned auto_increment
        primary key,
    site_global_key varbinary(64)  not null,
    site_type       varbinary(32)  not null,
    site_group      varbinary(32)  not null,
    site_source     varbinary(32)  not null,
    site_language   varbinary(35)  not null,
    site_protocol   varbinary(32)  not null,
    site_domain     varbinary(255) not null,
    site_data       blob           not null,
    site_forward    tinyint(1)     not null,
    site_config     blob           not null,
    constraint site_global_key
        unique (site_global_key)
)
    charset = `binary`;

create table slot_roles
(
    role_id   int auto_increment
        primary key,
    role_name varbinary(64) not null,
    constraint role_name
        unique (role_name)
)
    charset = `binary`;

create table slots
(
    slot_revision_id bigint unsigned   not null,
    slot_role_id     smallint unsigned not null,
    slot_content_id  bigint unsigned   not null,
    slot_origin      bigint unsigned   not null,
    primary key (slot_revision_id, slot_role_id)
)
    charset = `binary`;

create index slot_revision_origin_role
    on slots (slot_revision_id, slot_origin, slot_role_id);

create table templatelinks
(
    tl_from           int unsigned default 0 not null,
    tl_target_id      bigint unsigned        not null,
    tl_from_namespace int          default 0 not null,
    primary key (tl_from, tl_target_id)
)
    charset = `binary`;

create index tl_backlinks_namespace_target_id
    on templatelinks (tl_from_namespace, tl_target_id, tl_from);

create index tl_target_id
    on templatelinks (tl_target_id, tl_from);

create table text
(
    old_id    int unsigned auto_increment
        primary key,
    old_text  mediumblob not null,
    old_flags tinyblob   not null
)
    charset = `binary`;

create table updatelog
(
    ul_key   varbinary(255) not null
        primary key,
    ul_value blob           null
)
    charset = `binary`;

create table uploadstash
(
    us_id           int unsigned auto_increment
        primary key,
    us_user         int unsigned                                                                                                           not null,
    us_key          varbinary(255)                                                                                                         not null,
    us_orig_path    varbinary(255)                                                                                                         not null,
    us_path         varbinary(255)                                                                                                         not null,
    us_source_type  varbinary(50)                                                                                                          null,
    us_timestamp    binary(14)                                                                                                             not null,
    us_status       varbinary(50)                                                                                                          not null,
    us_chunk_inx    int unsigned                                                                                                           null,
    us_props        blob                                                                                                                   null,
    us_size         bigint unsigned                                                                                                        not null,
    us_sha1         varbinary(31)                                                                                                          not null,
    us_mime         varbinary(255)                                                                                                         null,
    us_media_type   enum ('UNKNOWN', 'BITMAP', 'DRAWING', 'AUDIO', 'VIDEO', 'MULTIMEDIA', 'OFFICE', 'TEXT', 'EXECUTABLE', 'ARCHIVE', '3D') null,
    us_image_width  int unsigned                                                                                                           null,
    us_image_height int unsigned                                                                                                           null,
    us_image_bits   smallint unsigned                                                                                                      null,
    constraint us_key
        unique (us_key)
)
    charset = `binary`;

create index us_timestamp
    on uploadstash (us_timestamp);

create index us_user
    on uploadstash (us_user);

create table user
(
    user_id                  int unsigned auto_increment
        primary key,
    user_name                varbinary(255) default ''                                                                 not null,
    user_real_name           varbinary(255) default ''                                                                 not null,
    user_password            tinyblob                                                                                  not null,
    user_newpassword         tinyblob                                                                                  not null,
    user_newpass_time        binary(14)                                                                                null,
    user_email               tinyblob                                                                                  not null,
    user_touched             binary(14)                                                                                not null,
    user_token               binary(32)     default '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0' not null,
    user_email_authenticated binary(14)                                                                                null,
    user_email_token         binary(32)                                                                                null,
    user_email_token_expires binary(14)                                                                                null,
    user_registration        binary(14)                                                                                null,
    user_editcount           int unsigned                                                                              null,
    user_password_expires    varbinary(14)                                                                             null,
    user_is_temp             tinyint(1)     default 0                                                                  not null,
    constraint user_name
        unique (user_name)
)
    charset = `binary`;

create index user_email
    on user (user_email(50));

create index user_email_token
    on user (user_email_token);

create table user_autocreate_serial
(
    uas_shard int unsigned      not null,
    uas_year  smallint unsigned not null,
    uas_value int unsigned      not null,
    primary key (uas_shard, uas_year)
)
    charset = `binary`;

create table user_former_groups
(
    ufg_user  int unsigned   default 0  not null,
    ufg_group varbinary(255) default '' not null,
    primary key (ufg_user, ufg_group)
)
    charset = `binary`;

create table user_groups
(
    ug_user   int unsigned   default 0  not null,
    ug_group  varbinary(255) default '' not null,
    ug_expiry varbinary(14)             null,
    primary key (ug_user, ug_group)
)
    charset = `binary`;

create index ug_expiry
    on user_groups (ug_expiry);

create index ug_group
    on user_groups (ug_group);

create table user_newtalk
(
    user_id             int unsigned  default 0  not null,
    user_ip             varbinary(40) default '' not null,
    user_last_timestamp binary(14)               null
)
    charset = `binary`;

create index un_user_id
    on user_newtalk (user_id);

create index un_user_ip
    on user_newtalk (user_ip);

create table user_properties
(
    up_user     int unsigned   not null,
    up_property varbinary(255) not null,
    up_value    blob           null,
    primary key (up_user, up_property)
)
    charset = `binary`;

create index up_property
    on user_properties (up_property);

create table watchlist
(
    wl_id                    int unsigned auto_increment
        primary key,
    wl_user                  int unsigned              not null,
    wl_namespace             int            default 0  not null,
    wl_title                 varbinary(255) default '' not null,
    wl_notificationtimestamp binary(14)                null,
    constraint wl_user
        unique (wl_user, wl_namespace, wl_title)
)
    charset = `binary`;

create index wl_namespace_title
    on watchlist (wl_namespace, wl_title);

create index wl_user_notificationtimestamp
    on watchlist (wl_user, wl_notificationtimestamp);

create table watchlist_expiry
(
    we_item   int unsigned not null
        primary key,
    we_expiry binary(14)   not null
)
    charset = `binary`;

create index we_expiry
    on watchlist_expiry (we_expiry);

