/*
Navicat MySQL Data Transfer

Source Server         : xfz
Source Server Version : 50730
Source Host           : localhost:3306
Source Database       : meituan

Target Server Type    : MYSQL
Target Server Version : 50730
File Encoding         : 65001

Date: 2020-10-25 23:52:18
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
INSERT INTO `auth_group` VALUES ('3', '管理');
INSERT INTO `auth_group` VALUES ('1', '编辑');
INSERT INTO `auth_group` VALUES ('2', '财务');

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------
INSERT INTO `auth_group_permissions` VALUES ('3', '1', '19');
INSERT INTO `auth_group_permissions` VALUES ('4', '1', '20');
INSERT INTO `auth_group_permissions` VALUES ('5', '1', '21');
INSERT INTO `auth_group_permissions` VALUES ('6', '1', '22');
INSERT INTO `auth_group_permissions` VALUES ('7', '1', '23');
INSERT INTO `auth_group_permissions` VALUES ('8', '1', '24');
INSERT INTO `auth_group_permissions` VALUES ('9', '1', '31');
INSERT INTO `auth_group_permissions` VALUES ('1', '1', '32');
INSERT INTO `auth_group_permissions` VALUES ('2', '1', '33');
INSERT INTO `auth_group_permissions` VALUES ('10', '2', '25');
INSERT INTO `auth_group_permissions` VALUES ('11', '2', '26');
INSERT INTO `auth_group_permissions` VALUES ('12', '2', '27');
INSERT INTO `auth_group_permissions` VALUES ('15', '3', '19');
INSERT INTO `auth_group_permissions` VALUES ('16', '3', '20');
INSERT INTO `auth_group_permissions` VALUES ('17', '3', '21');
INSERT INTO `auth_group_permissions` VALUES ('18', '3', '22');
INSERT INTO `auth_group_permissions` VALUES ('19', '3', '23');
INSERT INTO `auth_group_permissions` VALUES ('20', '3', '24');
INSERT INTO `auth_group_permissions` VALUES ('21', '3', '25');
INSERT INTO `auth_group_permissions` VALUES ('22', '3', '26');
INSERT INTO `auth_group_permissions` VALUES ('23', '3', '27');
INSERT INTO `auth_group_permissions` VALUES ('24', '3', '31');
INSERT INTO `auth_group_permissions` VALUES ('13', '3', '32');
INSERT INTO `auth_group_permissions` VALUES ('14', '3', '33');

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES ('1', 'Can add log entry', '1', 'add_logentry');
INSERT INTO `auth_permission` VALUES ('2', 'Can change log entry', '1', 'change_logentry');
INSERT INTO `auth_permission` VALUES ('3', 'Can delete log entry', '1', 'delete_logentry');
INSERT INTO `auth_permission` VALUES ('4', 'Can add permission', '2', 'add_permission');
INSERT INTO `auth_permission` VALUES ('5', 'Can change permission', '2', 'change_permission');
INSERT INTO `auth_permission` VALUES ('6', 'Can delete permission', '2', 'delete_permission');
INSERT INTO `auth_permission` VALUES ('7', 'Can add group', '3', 'add_group');
INSERT INTO `auth_permission` VALUES ('8', 'Can change group', '3', 'change_group');
INSERT INTO `auth_permission` VALUES ('9', 'Can delete group', '3', 'delete_group');
INSERT INTO `auth_permission` VALUES ('10', 'Can add content type', '4', 'add_contenttype');
INSERT INTO `auth_permission` VALUES ('11', 'Can change content type', '4', 'change_contenttype');
INSERT INTO `auth_permission` VALUES ('12', 'Can delete content type', '4', 'delete_contenttype');
INSERT INTO `auth_permission` VALUES ('13', 'Can add session', '5', 'add_session');
INSERT INTO `auth_permission` VALUES ('14', 'Can change session', '5', 'change_session');
INSERT INTO `auth_permission` VALUES ('15', 'Can delete session', '5', 'delete_session');
INSERT INTO `auth_permission` VALUES ('16', 'Can add mt user', '6', 'add_mtuser');
INSERT INTO `auth_permission` VALUES ('17', 'Can change mt user', '6', 'change_mtuser');
INSERT INTO `auth_permission` VALUES ('18', 'Can delete mt user', '6', 'delete_mtuser');
INSERT INTO `auth_permission` VALUES ('19', 'Can add goods category', '7', 'add_goodscategory');
INSERT INTO `auth_permission` VALUES ('20', 'Can change goods category', '7', 'change_goodscategory');
INSERT INTO `auth_permission` VALUES ('21', 'Can delete goods category', '7', 'delete_goodscategory');
INSERT INTO `auth_permission` VALUES ('22', 'Can add merchant', '8', 'add_merchant');
INSERT INTO `auth_permission` VALUES ('23', 'Can change merchant', '8', 'change_merchant');
INSERT INTO `auth_permission` VALUES ('24', 'Can delete merchant', '8', 'delete_merchant');
INSERT INTO `auth_permission` VALUES ('25', 'Can add order', '9', 'add_order');
INSERT INTO `auth_permission` VALUES ('26', 'Can change order', '9', 'change_order');
INSERT INTO `auth_permission` VALUES ('27', 'Can delete order', '9', 'delete_order');
INSERT INTO `auth_permission` VALUES ('28', 'Can add user address', '10', 'add_useraddress');
INSERT INTO `auth_permission` VALUES ('29', 'Can change user address', '10', 'change_useraddress');
INSERT INTO `auth_permission` VALUES ('30', 'Can delete user address', '10', 'delete_useraddress');
INSERT INTO `auth_permission` VALUES ('31', 'Can add goods', '11', 'add_goods');
INSERT INTO `auth_permission` VALUES ('32', 'Can change goods', '11', 'change_goods');
INSERT INTO `auth_permission` VALUES ('33', 'Can delete goods', '11', 'delete_goods');
INSERT INTO `auth_permission` VALUES ('34', 'Can view log entry', '1', 'view_logentry');
INSERT INTO `auth_permission` VALUES ('35', 'Can view group', '3', 'view_group');
INSERT INTO `auth_permission` VALUES ('36', 'Can view permission', '2', 'view_permission');
INSERT INTO `auth_permission` VALUES ('37', 'Can view content type', '4', 'view_contenttype');
INSERT INTO `auth_permission` VALUES ('38', 'Can view session', '5', 'view_session');
INSERT INTO `auth_permission` VALUES ('39', 'Can view mt user', '6', 'view_mtuser');
INSERT INTO `auth_permission` VALUES ('40', 'Can view goods', '11', 'view_goods');
INSERT INTO `auth_permission` VALUES ('41', 'Can view order', '9', 'view_order');
INSERT INTO `auth_permission` VALUES ('42', 'Can view merchant', '8', 'view_merchant');
INSERT INTO `auth_permission` VALUES ('43', 'Can view user address', '10', 'view_useraddress');
INSERT INTO `auth_permission` VALUES ('44', 'Can view goods category', '7', 'view_goodscategory');

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` varchar(22) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_mtauth_mtuser_uid` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_mtauth_mtuser_uid` FOREIGN KEY (`user_id`) REFERENCES `mtauth_mtuser` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES ('1', 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES ('3', 'auth', 'group');
INSERT INTO `django_content_type` VALUES ('2', 'auth', 'permission');
INSERT INTO `django_content_type` VALUES ('4', 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES ('11', 'meituan', 'goods');
INSERT INTO `django_content_type` VALUES ('7', 'meituan', 'goodscategory');
INSERT INTO `django_content_type` VALUES ('8', 'meituan', 'merchant');
INSERT INTO `django_content_type` VALUES ('9', 'meituan', 'order');
INSERT INTO `django_content_type` VALUES ('10', 'meituan', 'useraddress');
INSERT INTO `django_content_type` VALUES ('6', 'mtauth', 'mtuser');
INSERT INTO `django_content_type` VALUES ('5', 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES ('1', 'contenttypes', '0001_initial', '2020-09-03 15:54:59.978420');
INSERT INTO `django_migrations` VALUES ('2', 'contenttypes', '0002_remove_content_type_name', '2020-09-03 15:55:00.014453');
INSERT INTO `django_migrations` VALUES ('3', 'auth', '0001_initial', '2020-09-03 15:55:00.117545');
INSERT INTO `django_migrations` VALUES ('4', 'auth', '0002_alter_permission_name_max_length', '2020-09-03 15:55:00.137562');
INSERT INTO `django_migrations` VALUES ('5', 'auth', '0003_alter_user_email_max_length', '2020-09-03 15:55:00.142566');
INSERT INTO `django_migrations` VALUES ('6', 'auth', '0004_alter_user_username_opts', '2020-09-03 15:55:00.148573');
INSERT INTO `django_migrations` VALUES ('7', 'auth', '0005_alter_user_last_login_null', '2020-09-03 15:55:00.153576');
INSERT INTO `django_migrations` VALUES ('8', 'auth', '0006_require_contenttypes_0002', '2020-09-03 15:55:00.155578');
INSERT INTO `django_migrations` VALUES ('9', 'auth', '0007_alter_validators_add_error_messages', '2020-09-03 15:55:00.160583');
INSERT INTO `django_migrations` VALUES ('10', 'auth', '0008_alter_user_username_max_length', '2020-09-03 15:55:00.166588');
INSERT INTO `django_migrations` VALUES ('11', 'auth', '0009_alter_user_last_name_max_length', '2020-09-03 15:55:00.171592');
INSERT INTO `django_migrations` VALUES ('12', 'mtauth', '0001_initial', '2020-09-03 15:55:00.261673');
INSERT INTO `django_migrations` VALUES ('13', 'admin', '0001_initial', '2020-09-03 15:55:00.310716');
INSERT INTO `django_migrations` VALUES ('14', 'admin', '0002_logentry_remove_auto_add', '2020-09-03 15:55:00.317723');
INSERT INTO `django_migrations` VALUES ('15', 'sessions', '0001_initial', '2020-09-03 15:55:00.330734');
INSERT INTO `django_migrations` VALUES ('17', 'admin', '0003_logentry_add_action_flag_choices', '2020-09-29 12:29:52.684886');
INSERT INTO `django_migrations` VALUES ('18', 'auth', '0010_alter_group_name_max_length', '2020-09-29 12:29:52.733885');
INSERT INTO `django_migrations` VALUES ('19', 'auth', '0011_update_proxy_permissions', '2020-09-29 12:29:52.742892');
INSERT INTO `django_migrations` VALUES ('21', 'meituan', '0001_initial', '2020-09-29 13:42:21.622638');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_session
-- ----------------------------

-- ----------------------------
-- Table structure for meituan_goods
-- ----------------------------
DROP TABLE IF EXISTS `meituan_goods`;
CREATE TABLE `meituan_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `picture` varchar(200) NOT NULL,
  `intro` varchar(200) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `meituan_goods_category_id_406ea987_fk_meituan_goodscategory_id` (`category_id`),
  CONSTRAINT `meituan_goods_category_id_406ea987_fk_meituan_goodscategory_id` FOREIGN KEY (`category_id`) REFERENCES `meituan_goodscategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2022 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meituan_goods
-- ----------------------------
INSERT INTO `meituan_goods` VALUES ('2011', '百威啤酒T', 'http://p1.meituan.net/xianfu/8fd48d2e154953ed306126e2a1eebeb159392.jpg', '主要原料:百威啤酒500毫升\\r\\n未成年人请勿饮酒，孕妇和身体不适者不宜饮酒。喝酒请勿驾车，请适度享用美酒，产品及包装以实物为准。', '15.00', '207');
INSERT INTO `meituan_goods` VALUES ('2012', '八块香辣鸡翅TN', 'http://p1.meituan.net/xianfu/ed8484dc56c80c007690dd77caa0618c34816.jpg', '香辣多汁，口感鲜美。,主要原料:鸡翅，小麦粉', '39.50', '208');
INSERT INTO `meituan_goods` VALUES ('2013', '超级翅桶多人餐T', 'http://p1.meituan.net/xianfu/93bdf390e0a60c0e052836d0d9fa84d036864.jpg', '香辣鸡翅12块+新奥尔良烤翅8块+1.25L瓶装可乐', '109.00', '208');
INSERT INTO `meituan_goods` VALUES ('2014', '十翅分享桶T', 'http://p0.meituan.net/xianfu/8cb29a77c56eec84a5336b21e9dd556e36864.jpg', '十块香辣鸡翅+九珍2杯', '75.00', '208');
INSERT INTO `meituan_goods` VALUES ('2015', '葡式蛋挞6只TN', 'http://p1.meituan.net/xianfu/7f1e7ca278a757d1811f372b540db24923552.jpg', '葡式蛋挞6只,省是指比菜单单品总价省的金额', '42.00', '208');
INSERT INTO `meituan_goods` VALUES ('2016', '冬菇滑鸡粥', 'http://p0.meituan.net/xianfu/6636b167de9c47708f4daf8d3bc9b6fd27648.jpg', '主要原料:大米、冬菇、鸡肉、生菜', '9.50', '209');
INSERT INTO `meituan_goods` VALUES ('2017', '百事可乐(中)TN', 'http://p0.meituan.net/xianfu/56007977d214d7e7526996279afe241960416.jpg', '主要原料： 水，百事可乐糖浆， 二氧化碳', '9.50', '209');
INSERT INTO `meituan_goods` VALUES ('2018', '九珍果汁饮料TN', 'http://p0.meituan.net/xianfu/fb49242499f2b322cb26cb532828ca4f45056.jpg', '主要原料:果汁浓缩液、水', '12.00', '209');

-- ----------------------------
-- Table structure for meituan_goodscategory
-- ----------------------------
DROP TABLE IF EXISTS `meituan_goodscategory`;
CREATE TABLE `meituan_goodscategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `merchant_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `meituan_goodscategor_merchant_id_857fe7ec_fk_meituan_m` (`merchant_id`),
  CONSTRAINT `meituan_goodscategor_merchant_id_857fe7ec_fk_meituan_m` FOREIGN KEY (`merchant_id`) REFERENCES `meituan_merchant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meituan_goodscategory
-- ----------------------------
INSERT INTO `meituan_goodscategory` VALUES ('207', '炸鸡啤酒', '31');
INSERT INTO `meituan_goodscategory` VALUES ('208', '夜宵套餐', '31');
INSERT INTO `meituan_goodscategory` VALUES ('209', '夜宵爆品', '31');
INSERT INTO `meituan_goodscategory` VALUES ('212', '藤椒系列', '31');

-- ----------------------------
-- Table structure for meituan_merchant
-- ----------------------------
DROP TABLE IF EXISTS `meituan_merchant`;
CREATE TABLE `meituan_merchant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `address` varchar(200) NOT NULL,
  `logo` varchar(200) NOT NULL,
  `notice` varchar(200) DEFAULT NULL,
  `up_send` decimal(6,2) NOT NULL,
  `lon` double NOT NULL,
  `lat` double NOT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `created_id` varchar(22) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meituan_merchant_created_id_e14bc127_fk_mtauth_mtuser_uid` (`created_id`),
  CONSTRAINT `meituan_merchant_created_id_e14bc127_fk_mtauth_mtuser_uid` FOREIGN KEY (`created_id`) REFERENCES `mtauth_mtuser` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meituan_merchant
-- ----------------------------
INSERT INTO `meituan_merchant` VALUES ('31', '肯德基(花城店)', '湖南省长沙市天心区花城路211号', 'http://p1.meituan.net/xianfu/33c48a92a31a21e4bf32d3aa7c1c5c0d16649.jpg', '欢迎关林肯德基宅急送，专业外送，全程保温，准时送达！', '0.00', '22', '22', '2020-09-29 21:45:41.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('32', '麦当劳万家丽店', '长沙市', 'http://p1.meituan.net/xianfu/f85a2370d6f23866e8e16efce56ecd1015464.jpg', null, '10.00', '22', '11', '2020-09-29 21:46:40.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('33', '绝味鸭脖', '长沙市', 'http://p1.meituan.net/waimaipoi/bb937d469c2cb7f44ca572797f295fbb35261.jpg', null, '0.00', '12', '0', '2020-09-29 21:47:20.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('34', '香他她煲仔饭', '长沙市', 'http://p0.meituan.net/waimaipoi/ec85ed20652422502d61abd44b0d7dcf36349.jpg', null, '0.00', '12', '22', '2020-09-29 21:47:59.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('35', '老长沙虾馆', '长沙市', 'http://p1.meituan.net/waimaipoi/35843e3d6fca99c7dbe90a106abef027223326.jpg', null, '0.00', '12', '22', '2020-09-29 21:48:39.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('36', '美林烧烤', '长沙市', 'http://p1.meituan.net/waimaipoi/08cd41e5dd478efd2c4cd935eeee5d9e36864.jpg', null, '0.00', '12', '22', '2020-09-29 21:49:17.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('37', '兰州拉面', '长沙市', 'http://p0.meituan.net/waimaipoi/0b183b65e3bbe4ca572dd15e53a9133424018.jpg', null, '0.00', '12', '22', '2020-09-29 21:49:50.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('38', '新佳宜', '长沙市', 'http://p1.meituan.net/waimaipoi/20a3a4ab4fca667e81e602b495936f0c36773.jpg', null, '0.00', '12', '22', '2020-09-29 21:50:22.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('39', '螺蛳粉', '长沙市', 'http://p1.meituan.net/waimaipoi/a953c08c78e5e6ac8c599aaedb7c075d34608.jpg', null, '0.00', '12', '22', '2020-09-29 21:50:56.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('40', '蛮有味麻辣烫', '长沙市', 'http://p0.meituan.net/waimaipoi/4c78f294b8e0996bc936c35bf98656eb38912.jpg', null, '0.00', '12', '22', '2020-09-29 21:51:28.000000', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_merchant` VALUES ('41', '九村烤脑花', '重庆市九龙坡', 'http://127.0.0.1:8000/media/L6YtsLrneTdJJwmqd7p8D4.jpg', '', '0.00', '11', '22', '2020-10-14 13:12:34.339224', 'fTQ2qxY35nZTgMoWPwFjtG');
INSERT INTO `meituan_merchant` VALUES ('42', '麻辣小龙虾', '长沙文和友', 'http://127.0.0.1:8000/media/c7mqGnws63q5D8x5oYMvFP.jpg', '', '0.00', '25', '4', '2020-10-14 14:24:28.487562', null);
INSERT INTO `meituan_merchant` VALUES ('43', '火盆烧烤', '重庆市九龙坡', 'http://127.0.0.1:8000/media/kQrLTM5LD6BTTnAqLqS6XD.jpg', '', '0.00', '22', '11', '2020-10-15 13:29:36.113198', null);
INSERT INTO `meituan_merchant` VALUES ('44', '廖胖子火锅串串', '重庆市渝北回兴', 'http://127.0.0.1:8000/media/SK3Bty6d6t2XecbwT7AZtR.jpg', '', '0.00', '22', '11', '2020-10-15 13:30:21.199385', null);

-- ----------------------------
-- Table structure for meituan_order
-- ----------------------------
DROP TABLE IF EXISTS `meituan_order`;
CREATE TABLE `meituan_order` (
  `order_id` varchar(100) NOT NULL,
  `pay_method` smallint(6) NOT NULL,
  `order_status` smallint(6) NOT NULL,
  `goods_count` smallint(6) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `address_id` int(11) NOT NULL,
  `user_id` varchar(22) NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `meituan_order_address_id_97eebaf2_fk_meituan_useraddress_id` (`address_id`),
  KEY `meituan_order_user_id_eeae4f46_fk_mtauth_mtuser_uid` (`user_id`),
  CONSTRAINT `meituan_order_address_id_97eebaf2_fk_meituan_useraddress_id` FOREIGN KEY (`address_id`) REFERENCES `meituan_useraddress` (`id`),
  CONSTRAINT `meituan_order_user_id_eeae4f46_fk_mtauth_mtuser_uid` FOREIGN KEY (`user_id`) REFERENCES `mtauth_mtuser` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meituan_order
-- ----------------------------
INSERT INTO `meituan_order` VALUES ('202010101627485104', '0', '1', '2', '54.50', '5', 'MtR5YgRugT2vUdhy94ZUQv');
INSERT INTO `meituan_order` VALUES ('202010101649513604', '0', '1', '2', '54.50', '5', 'MtR5YgRugT2vUdhy94ZUQv');

-- ----------------------------
-- Table structure for meituan_order_goods_list
-- ----------------------------
DROP TABLE IF EXISTS `meituan_order_goods_list`;
CREATE TABLE `meituan_order_goods_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(100) NOT NULL,
  `goods_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meituan_order_goods_list_order_id_goods_id_9b37072e_uniq` (`order_id`,`goods_id`),
  KEY `meituan_order_goods_list_goods_id_f63e578f_fk_meituan_goods_id` (`goods_id`),
  CONSTRAINT `meituan_order_goods__order_id_e42b4640_fk_meituan_o` FOREIGN KEY (`order_id`) REFERENCES `meituan_order` (`order_id`),
  CONSTRAINT `meituan_order_goods_list_goods_id_f63e578f_fk_meituan_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `meituan_goods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meituan_order_goods_list
-- ----------------------------
INSERT INTO `meituan_order_goods_list` VALUES ('1', '202010101627485104', '2011');
INSERT INTO `meituan_order_goods_list` VALUES ('2', '202010101627485104', '2012');
INSERT INTO `meituan_order_goods_list` VALUES ('3', '202010101649513604', '2011');
INSERT INTO `meituan_order_goods_list` VALUES ('4', '202010101649513604', '2012');

-- ----------------------------
-- Table structure for meituan_useraddress
-- ----------------------------
DROP TABLE IF EXISTS `meituan_useraddress`;
CREATE TABLE `meituan_useraddress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `realname` varchar(100) NOT NULL,
  `telephone` varchar(11) NOT NULL,
  `province` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `county` varchar(100) NOT NULL,
  `address_detail` varchar(100) NOT NULL,
  `area_code` varchar(10) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL,
  `user_id` varchar(22) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `meituan_useraddress_user_id_46e4f123_fk_mtauth_mtuser_uid` (`user_id`),
  CONSTRAINT `meituan_useraddress_user_id_46e4f123_fk_mtauth_mtuser_uid` FOREIGN KEY (`user_id`) REFERENCES `mtauth_mtuser` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meituan_useraddress
-- ----------------------------
INSERT INTO `meituan_useraddress` VALUES ('5', '陈琦', '15698745625', '北京市', '北京市', '西城区', '东门大街18号', '110102', '1', 'MtR5YgRugT2vUdhy94ZUQv');

-- ----------------------------
-- Table structure for mtauth_mtuser
-- ----------------------------
DROP TABLE IF EXISTS `mtauth_mtuser`;
CREATE TABLE `mtauth_mtuser` (
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `uid` varchar(22) NOT NULL,
  `telephone` varchar(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `avatar` varchar(200) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_merchant` tinyint(1) NOT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `telephone` (`telephone`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mtauth_mtuser
-- ----------------------------
INSERT INTO `mtauth_mtuser` VALUES ('pbkdf2_sha256$150000$FEGP7wBxb7Fd$Htzv8wrXrkkw7QBAjDfFalWs2OeaGVCmtYTTQ82LBbc=', '2020-10-19 08:55:50.130009', '0', 'fTQ2qxY35nZTgMoWPwFjtG', '18856932588', null, 'admin', '', '2020-10-12 11:44:50.668579', '1', '1', '1');
INSERT INTO `mtauth_mtuser` VALUES ('', '2020-10-19 10:06:09.549294', '0', 'MtR5YgRugT2vUdhy94ZUQv', '18584565981', null, 'mtyhu864382', '', '2020-09-28 10:22:19.213757', '1', '0', '0');

-- ----------------------------
-- Table structure for mtauth_mtuser_groups
-- ----------------------------
DROP TABLE IF EXISTS `mtauth_mtuser_groups`;
CREATE TABLE `mtauth_mtuser_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mtuser_id` varchar(22) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mtauth_mtuser_groups_mtuser_id_group_id_b528428d_uniq` (`mtuser_id`,`group_id`),
  KEY `mtauth_mtuser_groups_group_id_7a5ba333_fk_auth_group_id` (`group_id`),
  CONSTRAINT `mtauth_mtuser_groups_group_id_7a5ba333_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `mtauth_mtuser_groups_mtuser_id_355cb2b4_fk_mtauth_mtuser_uid` FOREIGN KEY (`mtuser_id`) REFERENCES `mtauth_mtuser` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mtauth_mtuser_groups
-- ----------------------------
INSERT INTO `mtauth_mtuser_groups` VALUES ('1', 'fTQ2qxY35nZTgMoWPwFjtG', '1');
INSERT INTO `mtauth_mtuser_groups` VALUES ('2', 'fTQ2qxY35nZTgMoWPwFjtG', '2');

-- ----------------------------
-- Table structure for mtauth_mtuser_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `mtauth_mtuser_user_permissions`;
CREATE TABLE `mtauth_mtuser_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mtuser_id` varchar(22) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mtauth_mtuser_user_permi_mtuser_id_permission_id_99e8b21b_uniq` (`mtuser_id`,`permission_id`),
  KEY `mtauth_mtuser_user_p_permission_id_80b5611d_fk_auth_perm` (`permission_id`),
  CONSTRAINT `mtauth_mtuser_user_p_mtuser_id_77b03327_fk_mtauth_mt` FOREIGN KEY (`mtuser_id`) REFERENCES `mtauth_mtuser` (`uid`),
  CONSTRAINT `mtauth_mtuser_user_p_permission_id_80b5611d_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mtauth_mtuser_user_permissions
-- ----------------------------
