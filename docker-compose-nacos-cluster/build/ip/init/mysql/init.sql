-- 创建数据库
DROP database IF EXISTS `nacos_config`;
CREATE DATABASE `nacos_config` default character set utf8mb4 collate utf8mb4_unicode_ci;
 
-- 切换数据库
USE nacos_config;

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info   */
/******************************************/
CREATE TABLE `config_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) DEFAULT NULL,
  `content` longtext NOT NULL COMMENT 'content',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(20) DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) DEFAULT NULL,
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) DEFAULT NULL,
  `c_use` varchar(64) DEFAULT NULL,
  `effect` varchar(64) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `c_schema` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_aggr   */
/******************************************/
CREATE TABLE `config_info_aggr` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) NOT NULL COMMENT 'datum_id',
  `content` longtext NOT NULL COMMENT '内容',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) DEFAULT NULL,
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='增加租户字段';


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_beta   */
/******************************************/
CREATE TABLE `config_info_beta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `content` longtext NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(20) DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_beta';

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_tag   */
/******************************************/
CREATE TABLE `config_info_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `content` longtext NOT NULL COMMENT 'content',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(20) DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_tag';

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_tags_relation   */
/******************************************/
CREATE TABLE `config_tags_relation` (
  `id` bigint(20) NOT NULL COMMENT 'id',
  `tag_name` varchar(128) NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nid`),
  UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tag_relation';

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = group_capacity   */
/******************************************/
CREATE TABLE `group_capacity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、各Group容量信息表';

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = his_config_info   */
/******************************************/
CREATE TABLE `his_config_info` (
  `id` bigint(64) unsigned NOT NULL,
  `nid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `data_id` varchar(255) NOT NULL,
  `group_id` varchar(128) NOT NULL,
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `content` longtext NOT NULL,
  `md5` varchar(32) DEFAULT NULL,
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `src_user` text,
  `src_ip` varchar(20) DEFAULT NULL,
  `op_type` char(10) DEFAULT NULL,
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`nid`),
  KEY `idx_gmt_create` (`gmt_create`),
  KEY `idx_gmt_modified` (`gmt_modified`),
  KEY `idx_did` (`data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = tenant_capacity   */
/******************************************/
CREATE TABLE `tenant_capacity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';


CREATE TABLE `tenant_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) default '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) default '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint(20) NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint(20) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

CREATE TABLE `users` (
	`username` varchar(50) NOT NULL PRIMARY KEY,
	`password` varchar(500) NOT NULL,
	`enabled` boolean NOT NULL
);

CREATE TABLE `roles` (
	`username` varchar(50) NOT NULL,
	`role` varchar(50) NOT NULL,
	UNIQUE INDEX `idx_user_role` (`username` ASC, `role` ASC) USING BTREE
);

CREATE TABLE `permissions` (
    `role` varchar(50) NOT NULL,
    `resource` varchar(512) NOT NULL,
    `action` varchar(8) NOT NULL,
    UNIQUE INDEX `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
);

INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE);

INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');

INSERT INTO `nacos_config`.`tenant_info`(`id`, `kp`, `tenant_id`, `tenant_name`, `tenant_desc`, `create_source`, `gmt_create`, `gmt_modified`) VALUES (1, '1', 'order-config-namespace', 'order-config', '订单服务工程的命名空间', 'nacos', 1593661967058, 1593661967058);
INSERT INTO `nacos_config`.`tenant_info`(`id`, `kp`, `tenant_id`, `tenant_name`, `tenant_desc`, `create_source`, `gmt_create`, `gmt_modified`) VALUES (2, '1', 'user-config-namespace', 'user-config', '用户服务工程的命名空间', 'nacos', 1593661996397, 1593661996397);


INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (1, 'order-config.yml', 'dev', 'order:\n  data:\n    info: order-config-dev.yml', '73f294f9e5baa6659686cc6856a1814a', '2020-07-02 11:54:43', '2020-07-03 09:38:26', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 开发环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (2, 'mysql.yml', 'dev', 'order:\n  data:\n    info: mysql-dev.yml\n  group: dev\n  ext:\n    name: mysql-dev', 'b7c600f10723de9e22ca3bd7547f43c0', '2020-07-02 11:57:10', '2020-07-03 09:38:41', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 开发环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (3, 'redis.yml', 'dev', 'order:\n  data:\n    info: redis-dev.yml\n  group: dev\n  ext:\n    name: redis-dev', 'd0be14135fd40b6b740f337c20855292', '2020-07-02 11:58:00', '2020-07-03 09:38:55', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 开发环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (4, 'order-config.yml', 'stg', 'order:\n  data:\n    info: order-config-stg.yml', '4f88d2ac93dce42c20319c18c7151eb5', '2020-07-02 13:06:21', '2020-07-03 09:39:11', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 测试环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (5, 'mysql.yml', 'stg', 'order:\n  data:\n    info: mysql-stg.yml\n  group: stg\n  ext:\n    name: mysql-stg', '782e290052337067eebeb790ecb4d8a8', '2020-07-02 13:07:38', '2020-07-03 09:39:26', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 测试环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (6, 'redis.yml', 'stg', 'order:\n  data:\n    info: redis-stg.yml\n  group: stg\n  ext:\n    name: redis-stg', '3cfa37f58aeecd7768b1af097c3e3d72', '2020-07-02 13:08:27', '2020-07-03 09:39:41', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 测试环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (7, 'order-config.yml', 'prd', 'order:\n  data:\n    info: order-config-prd.yml', '381be1ab6d2951e4e1313dc71a608334', '2020-07-02 13:11:31', '2020-07-03 09:39:53', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 生产环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (8, 'mysql.yml', 'prd', 'order:\n  data:\n    info: mysql-prd.yml\n  group: prd\n  ext:\n    name: mysql-prd', '074b10c06054791b4417e9fb32fd41c9', '2020-07-02 13:12:19', '2020-07-03 09:40:05', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 生产环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (9, 'redis.yml', 'prd', 'order:\n  data:\n    info: redis-prd.yml\n  group: prd\n  ext:\n    name: redis-prd', '911be5e3930bb9b1cd87f55f3e453443', '2020-07-02 13:13:05', '2020-07-03 09:40:26', NULL, '0:0:0:0:0:0:0:1', '订单服务工程', 'order-config-namespace', '订单服务工程 - 生产环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (10, 'user-config.yml', 'dev', 'user:\n  data:\n    info: user-config-dev.yml', 'fa9d9e800f01f85e3e0af6c16da34de8', '2020-07-02 13:14:58', '2020-07-03 09:40:53', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 开发环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (11, 'mysql.yml', 'dev', 'user:\n  data:\n    info: mysql-dev.yml\n  group: dev\n  ext:\n    name: mysql-dev', 'e57855ffbc6b667302928360fe613f50', '2020-07-02 13:15:38', '2020-07-03 09:41:08', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 开发环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (12, 'redis.yml', 'dev', 'user:\n  data:\n    info: redis-dev.yml\n  group: dev\n  ext:\n    name: redis-dev', '6faa37de32f864a14bf471db53445860', '2020-07-02 13:16:13', '2020-07-03 09:41:20', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 开发环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (13, 'user-config.yml', 'stg', 'user:\n  data:\n    info: user-config-stg.yml', 'd8ebe3cf0b06b1e5a4a57b4b315f09a0', '2020-07-02 13:17:09', '2020-07-03 09:41:34', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 测试环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (14, 'mysql.yml', 'stg', 'user:\n  data:\n    info: mysql-stg.yml\n  group: stg\n  ext:\n    name: mysql-stg', '5090b73c0c76229dc256ce8982dc5dc4', '2020-07-02 13:17:42', '2020-07-03 09:41:47', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 测试环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (15, 'redis.yml', 'stg', 'user:\n  data:\n    info: redis-stg.yml\n  group: stg\n  ext:\n    name: redis-stg', 'b4d4f4f5afe6eaa8bf17d12428185185', '2020-07-02 13:18:11', '2020-07-03 09:41:59', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 测试环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (16, 'user-config.yml', 'prd', 'user:\n  data:\n    info: user-config-prd.yml', '99119bfc4cf561f8309fbc1b91864991', '2020-07-02 13:19:04', '2020-07-03 09:42:12', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 生产环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (17, 'mysql.yml', 'prd', 'user:\n  data:\n    info: mysql-prd.yml\n  group: prd\n  ext:\n    name: mysql-prd', 'fe9bd19e646cb9777d519cd097ee3c1f', '2020-07-02 13:19:39', '2020-07-03 09:42:24', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 生产环境的配置文件', 'null', 'null', 'yaml', 'null');
INSERT INTO `nacos_config`.`config_info`(`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`) VALUES (18, 'redis.yml', 'prd', 'user:\n  data:\n    info: redis-prd.yml\n  group: prd\n  ext:\n    name: redis-prd', '0305b6cf609245a5e946f11cb85f6f0b', '2020-07-02 13:20:12', '2020-07-03 09:42:39', NULL, '0:0:0:0:0:0:0:1', '用户服务工程', 'user-config-namespace', '用户服务工程 - 生产环境的配置文件', 'null', 'null', 'yaml', 'null');


INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 1, 'order-config.yml', 'dev', '订单服务工程', 'config:\n  data:\n    id: order-config.yml', '90acfaf2d843941786038c97b5b9afde', '2020-07-02 11:54:42', '2020-07-02 11:54:43', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 2, 'mysql.yml', 'dev', '订单服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: dev\n  ext:\n    name: mysql-dev', '60c2cf1a43c6bc7b8011231d804df2b8', '2020-07-02 11:57:09', '2020-07-02 11:57:10', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 3, 'redis.yml', 'dev', '订单服务工程', 'config:\n  data:\n    id: redis.yml\n  group: dev\n  ext:\n    name: redis-dev', '154cb8a92ecaec7ac4ba81ecdebeb152', '2020-07-02 11:58:00', '2020-07-02 11:58:00', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 4, 'order-config.yml', 'stg', '订单服务工程', 'config:\n  data:\n    id: order-config.yml', '90acfaf2d843941786038c97b5b9afde', '2020-07-02 13:06:21', '2020-07-02 13:06:21', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 5, 'mysql.yml', 'stg', '订单服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: stg\n  ext:\n    name: mysql-stg', '063f27ed48a54a82773ef81f786e055c', '2020-07-02 13:07:38', '2020-07-02 13:07:38', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 6, 'redis.yml', 'stg', '订单服务工程', 'config:\n  data:\n    id: redis.yml\n  group: stg\n  ext:\n    name: redis-stg', 'bad00c83691d2dff5df72348fc28c824', '2020-07-02 13:08:27', '2020-07-02 13:08:27', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 7, 'order-config.yml', 'prd', '订单服务工程', 'config:\n  data:\n    id: order-config.yml', '90acfaf2d843941786038c97b5b9afde', '2020-07-02 13:11:30', '2020-07-02 13:11:31', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 8, 'mysql.yml', 'prd', '订单服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: prd\n  ext:\n    name: mysql-prd', '30bf25f8ad9b244001bfb03aba60b97c', '2020-07-02 13:12:18', '2020-07-02 13:12:19', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 9, 'redis.yml', 'prd', '订单服务工程', 'config:\n  data:\n    id: redis.yml\n  group: prd\n  ext:\n    name: redis-prd', 'dfb2667192f731840041bdd22fd65f6c', '2020-07-02 13:13:05', '2020-07-02 13:13:05', NULL, '0:0:0:0:0:0:0:1', 'I', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 10, 'user-config.yml', 'dev', '用户服务工程', 'config:\n  data:\n    id: user-config.yml', '3a34eefa4fc9c03577f9c1ef87abd003', '2020-07-02 13:14:58', '2020-07-02 13:14:58', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 11, 'mysql.yml', 'dev', '用户服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: dev\n  ext:\n    name: mysql-dev', '60c2cf1a43c6bc7b8011231d804df2b8', '2020-07-02 13:15:38', '2020-07-02 13:15:38', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 12, 'redis.yml', 'dev', '用户服务工程', 'config:\n  data:\n    id: redis.yml\n  group: dev\n  ext:\n    name: redis-dev', '154cb8a92ecaec7ac4ba81ecdebeb152', '2020-07-02 13:16:12', '2020-07-02 13:16:13', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 13, 'user-config.yml', 'stg', '用户服务工程', 'config:\n  data:\n    id: user-config.yml', '3a34eefa4fc9c03577f9c1ef87abd003', '2020-07-02 13:17:09', '2020-07-02 13:17:09', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 14, 'mysql.yml', 'stg', '用户服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: stg\n  ext:\n    name: mysql-stg', '063f27ed48a54a82773ef81f786e055c', '2020-07-02 13:17:41', '2020-07-02 13:17:42', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 15, 'redis.yml', 'stg', '用户服务工程', 'config:\n  data:\n    id: redis.yml\n  group: stg\n  ext:\n    name: redis-stg', 'bad00c83691d2dff5df72348fc28c824', '2020-07-02 13:18:11', '2020-07-02 13:18:11', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 16, 'user-config.yml', 'prd', '用户服务工程', 'config:\n  data:\n    id: user-config.yml', '3a34eefa4fc9c03577f9c1ef87abd003', '2020-07-02 13:19:03', '2020-07-02 13:19:04', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 17, 'mysql.yml', 'prd', '用户服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: prd\n  ext:\n    name: mysql-prd', '30bf25f8ad9b244001bfb03aba60b97c', '2020-07-02 13:19:39', '2020-07-02 13:19:39', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (0, 18, 'redis.yml', 'prd', '用户服务工程', 'config:\n  data:\n    id: redis.yml\n  group: prd\n  ext:\n    name: redis-prd', 'dfb2667192f731840041bdd22fd65f6c', '2020-07-02 13:20:12', '2020-07-02 13:20:12', NULL, '0:0:0:0:0:0:0:1', 'I', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (1, 19, 'order-config.yml', 'dev', '订单服务工程', 'config:\n  data:\n    id: order-config.yml', '90acfaf2d843941786038c97b5b9afde', '2020-07-03 09:38:25', '2020-07-03 09:38:26', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (2, 20, 'mysql.yml', 'dev', '订单服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: dev\n  ext:\n    name: mysql-dev', '60c2cf1a43c6bc7b8011231d804df2b8', '2020-07-03 09:38:40', '2020-07-03 09:38:41', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (3, 21, 'redis.yml', 'dev', '订单服务工程', 'config:\n  data:\n    id: redis.yml\n  group: dev\n  ext:\n    name: redis-dev', '154cb8a92ecaec7ac4ba81ecdebeb152', '2020-07-03 09:38:55', '2020-07-03 09:38:55', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (4, 22, 'order-config.yml', 'stg', '订单服务工程', 'config:\n  data:\n    id: order-config.yml', '90acfaf2d843941786038c97b5b9afde', '2020-07-03 09:39:10', '2020-07-03 09:39:11', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (5, 23, 'mysql.yml', 'stg', '订单服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: stg\n  ext:\n    name: mysql-stg', '063f27ed48a54a82773ef81f786e055c', '2020-07-03 09:39:26', '2020-07-03 09:39:26', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (6, 24, 'redis.yml', 'stg', '订单服务工程', 'config:\n  data:\n    id: redis.yml\n  group: stg\n  ext:\n    name: redis-stg', 'bad00c83691d2dff5df72348fc28c824', '2020-07-03 09:39:40', '2020-07-03 09:39:41', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (7, 25, 'order-config.yml', 'prd', '订单服务工程', 'config:\n  data:\n    id: order-config.yml', '90acfaf2d843941786038c97b5b9afde', '2020-07-03 09:39:52', '2020-07-03 09:39:53', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (8, 26, 'mysql.yml', 'prd', '订单服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: prd\n  ext:\n    name: mysql-prd', '30bf25f8ad9b244001bfb03aba60b97c', '2020-07-03 09:40:05', '2020-07-03 09:40:05', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (9, 27, 'redis.yml', 'prd', '订单服务工程', 'config:\n  data:\n    id: redis.yml\n  group: prd\n  ext:\n    name: redis-prd', 'dfb2667192f731840041bdd22fd65f6c', '2020-07-03 09:40:25', '2020-07-03 09:40:26', NULL, '0:0:0:0:0:0:0:1', 'U', 'order-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (10, 28, 'user-config.yml', 'dev', '用户服务工程', 'config:\n  data:\n    id: user-config.yml', '3a34eefa4fc9c03577f9c1ef87abd003', '2020-07-03 09:40:53', '2020-07-03 09:40:53', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (11, 29, 'mysql.yml', 'dev', '用户服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: dev\n  ext:\n    name: mysql-dev', '60c2cf1a43c6bc7b8011231d804df2b8', '2020-07-03 09:41:07', '2020-07-03 09:41:08', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (12, 30, 'redis.yml', 'dev', '用户服务工程', 'config:\n  data:\n    id: redis.yml\n  group: dev\n  ext:\n    name: redis-dev', '154cb8a92ecaec7ac4ba81ecdebeb152', '2020-07-03 09:41:20', '2020-07-03 09:41:20', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (13, 31, 'user-config.yml', 'stg', '用户服务工程', 'config:\n  data:\n    id: user-config.yml', '3a34eefa4fc9c03577f9c1ef87abd003', '2020-07-03 09:41:34', '2020-07-03 09:41:34', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (14, 32, 'mysql.yml', 'stg', '用户服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: stg\n  ext:\n    name: mysql-stg', '063f27ed48a54a82773ef81f786e055c', '2020-07-03 09:41:46', '2020-07-03 09:41:47', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (15, 33, 'redis.yml', 'stg', '用户服务工程', 'config:\n  data:\n    id: redis.yml\n  group: stg\n  ext:\n    name: redis-stg', 'bad00c83691d2dff5df72348fc28c824', '2020-07-03 09:41:58', '2020-07-03 09:41:59', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (16, 34, 'user-config.yml', 'prd', '用户服务工程', 'config:\n  data:\n    id: user-config.yml', '3a34eefa4fc9c03577f9c1ef87abd003', '2020-07-03 09:42:11', '2020-07-03 09:42:12', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (17, 35, 'mysql.yml', 'prd', '用户服务工程', 'config:\n  data:\n    id: mysql.yml\n  group: prd\n  ext:\n    name: mysql-prd', '30bf25f8ad9b244001bfb03aba60b97c', '2020-07-03 09:42:24', '2020-07-03 09:42:24', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
INSERT INTO `nacos_config`.`his_config_info`(`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`) VALUES (18, 36, 'redis.yml', 'prd', '用户服务工程', 'config:\n  data:\n    id: redis.yml\n  group: prd\n  ext:\n    name: redis-prd', 'dfb2667192f731840041bdd22fd65f6c', '2020-07-03 09:42:38', '2020-07-03 09:42:39', NULL, '0:0:0:0:0:0:0:1', 'U', 'user-config-namespace');
