-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 27, 2021 at 05:17 PM
-- Server version: 10.3.27-MariaDB-log-cll-lve
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `root_my_project`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `active_user` (`activeToken` VARCHAR(32))  BEGIN
	UPDATE users SET is_active = '1' WHERE active_token = activeToken;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_address` (IN `u` INT UNSIGNED, IN `f` VARCHAR(20), IN `l` VARCHAR(40), IN `ct` VARCHAR(50), IN `a1` VARCHAR(80), IN `a2` VARCHAR(80), IN `c` VARCHAR(60), IN `s` CHAR(2), IN `z` MEDIUMINT(5) UNSIGNED, IN `p` CHAR(10), IN `e` VARCHAR(80))  BEGIN
	DECLARE num_address TINYINT;
    SELECT COUNT(*) INTO num_address FROM shipping_address WHERE user_id = u;
    IF num_address <= 5 THEN
	INSERT INTO shipping_address (user_id, first_name, last_name, country, address1, address2, city, state, zip, phone, email) VALUES(u, f, l, ct, a1, a2, c, s, z, p, e);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_attribute` (`name_attr` VARCHAR(20))  BEGIN
	INSERT INTO attribute (name) VALUES (name_attr);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_attr_value` (IN `attrId` INT UNSIGNED, IN `attrValue` VARCHAR(20))  BEGIN
	INSERT INTO attribute_value (`attribute_id`, `value`) VALUES (attrId, attrValue);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_category` (IN `category` VARCHAR(40), IN `description` TINYTEXT, IN `image` VARCHAR(45))  BEGIN
	INSERT INTO categories (category, description, image) VALUES (category, description, image);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_category_for_post` (`name` VARCHAR(30))  BEGIN
	INSERT INTO post_categories (`category`) VALUES (name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_charge` (`charge_id` VARCHAR(60), `oid` INT, `trans_type` VARCHAR(18), `amt` INT(10), `charge` TEXT)  BEGIN
	INSERT INTO charges VALUES(NULL, charge_id, oid, trans_type, amt, charge, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_charge_not_login` (`charge_id` VARCHAR(60), `oid` INT, `trans_type` VARCHAR(18), `amt` INT(10), `charge` TEXT)  BEGIN
  INSERT INTO charges_not_login VALUES (NULL, charge_id, oid, trans_type, amt, charge, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_chat_message` (IN `toUserId` INT UNSIGNED, IN `fromUserId` INT UNSIGNED, IN `message` TEXT, IN `statusMessage` BOOLEAN)  BEGIN
	INSERT INTO chat_message 
      (to_user_id, from_user_id, chat_message, status) 
      VALUES (toUserId, fromUserId, message, statusMessage);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_comment` (IN `parentComId` INT UNSIGNED, IN `commentContent` VARCHAR(300), IN `userId` INT UNSIGNED, IN `postId` INT)  BEGIN
	INSERT INTO comments(`parent_comment_id`, `comment`, `user_id`, `post_id`) VALUES(parentComId, commentContent, userId, postId) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_customer` (`e` VARCHAR(80), `f` VARCHAR(20), `l` VARCHAR(40), `a1` VARCHAR(80), `a2` VARCHAR(80), `c` VARCHAR(60), `s` CHAR(2), `z` MEDIUMINT, `p` INT, OUT `cid` INT)  BEGIN
  INSERT INTO customers (email, first_name, last_name, address1, address2, city, state, zip, phone) VALUES (e, f, l, a1, a2, c, s, z, p);
	SELECT LAST_INSERT_ID() INTO cid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_discount_code` (`code` VARCHAR(25), `active` TINYINT(1), `minCost` INT, `operation` ENUM('-','%','s'), `amount` INT, `num` INT, `exp` TIMESTAMP)  BEGIN
	INSERT INTO discount_codes (voucher_code, active, min_basket_cost, discount_operation, discount_amount, num_vouchers, expiry)
    VALUES(code, active, minCost, operation, amount, num, exp);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_email_get_news` (`e` VARCHAR(80))  BEGIN
	DECLARE count_email INT;
	SELECT COUNT(*) INTO count_email FROM emails_get_news WHERE email = e;
    IF count_email = 0 THEN
    INSERT INTO emails_get_news (email) VALUES(e);
    SELECT 1;
    ELSE
    SELECT -1;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_like` (IN `commentId` INT UNSIGNED, IN `userId` INT UNSIGNED)  BEGIN
	DECLARE a INT;
	SELECT COUNT(*) INTO a FROM user_post_like  WHERE comment_id = commentId AND user_id = userId;
    IF a = 0 THEN
    INSERT INTO user_post_like (comment_id, user_id) VALUES (commentId, userId);
    ELSE
    DELETE FROM user_post_like WHERE comment_id = commentId
    AND user_id = userId;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_message` (IN `fromUserId` INT, IN `toUserId` INT, IN `message` TEXT)  BEGIN
INSERT INTO chat_message (from_user_id, to_user_id,  chat_message) 
VALUES (fromUserId, toUserId, message);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_notify_out_of_stock` (`pId` INT UNSIGNED, `name` VARCHAR(50), `email` VARCHAR(100))  BEGIN
	INSERT INTO product_stock_notification (`product_id` ,`name`, `email`) VALUES (pId, name, email);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_num_view` (IN `postId` INT UNSIGNED)  BEGIN
    UPDATE `posts` SET num_view = num_view + 1 WHERE id = postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_order` (IN `customerId` INT, IN `cartId` CHAR(32), IN `ship` INT, IN `discountPrice` INT, IN `discountCode` VARCHAR(25), IN `cc` INT, IN `fn` VARCHAR(20), IN `ln` VARCHAR(40), IN `c` VARCHAR(60), IN `ad1` VARCHAR(80), IN `ad2` VARCHAR(80), IN `ct` VARCHAR(60), IN `st` CHAR(2), IN `z` MEDIUMINT(5) UNSIGNED ZEROFILL, IN `p` CHAR(10), IN `e` VARCHAR(80), OUT `total` INT, OUT `oid` INT)  BEGIN
	DECLARE subtotal INT(10);
    INSERT INTO orders(customer_id, shipping, discount_price, discount_code, credit_card_number, order_date, first_name, last_name, country, address1, address2, city, state, zip, phone, email) VALUES (customerId, ship, discountPrice, discountCode, cc, NOW(), fn, ln, c, ad1, ad2, ct, st, z, p, e);
    SELECT LAST_INSERT_ID() INTO oid;
    
    INSERT INTO order_contents(order_id, product_id, attributes, quantity, price)
    SELECT oid, c.product_id, c.attributes, c.quantity,  IFNULL(sales.price, p.price) as price FROM shopping_cart c
    INNER JOIN phones AS p ON c.product_id = p.id
    LEFT OUTER JOIN sales
    ON (sales.product_id=p.id
    AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
    OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
    WHERE c.cart_id = cartId;
	
    SELECT SUM(quantity * price) INTO subtotal FROM order_contents WHERE order_id = oid;
    UPDATE orders SET total = (subtotal + ship - discountPrice) WHERE order_id = oid;
    SELECT (subtotal + ship - discountPrice) INTO total;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_order_not_login` (IN `cid` INT, IN `uid` CHAR(32), IN `ship` INT(10), IN `discountPrice` INT, IN `discountCode` VARCHAR(25), IN `cc` MEDIUMINT, OUT `total` INT(10), OUT `oid` INT)  BEGIN
	DECLARE subtotal INT(10);
	INSERT INTO orders_not_login (customer_id, shipping, discount_price, discount_code, credit_card_number, order_date) VALUES (cid, ship, discountPrice, discountCode, cc, NOW());
    SELECT LAST_INSERT_ID() INTO oid;
	INSERT INTO order_contents_not_login(order_id, product_id, attributes, quantity, price)
    SELECT oid, c.product_id, c.attributes, c.quantity, IFNULL(sales.price, p.price) as price FROM shopping_cart c
    
    INNER JOIN phones AS p ON c.product_id = p.id
    LEFT OUTER JOIN sales
    ON (sales.product_id=p.id
    AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
    OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
    WHERE c.cart_id = uid;
   
	SELECT SUM(quantity*price) INTO subtotal FROM order_contents_not_login WHERE order_id=oid;
	UPDATE orders_not_login SET total = (subtotal + ship - discountPrice) WHERE order_id=oid;
	SELECT (subtotal + ship - discountPrice) INTO total;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_review` (IN `userId` INT, IN `pid` MEDIUMINT, IN `re` TEXT, IN `ra` VARCHAR(80))  BEGIN
	INSERT INTO reviews (customer_id, product_id, review, rating)
    VALUES (userId, pid, re, ra);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_attribute_to_product` (IN `pId` INT UNSIGNED, IN `attrValueId` TINYINT)  BEGIN
    INSERT INTO product_attribute (product_id, attribute_value_id) VALUES (pId, attrValueId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_product_to_category` (IN `pId` INT UNSIGNED, IN `catId` TINYINT)  BEGIN
    INSERT INTO phone_category(phone_id, category_id) VALUES (pId, catId);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_status_discount_code` (IN `code` VARCHAR(25), IN `status` TINYINT)  BEGIN
	UPDATE discount_codes SET active = status WHERE voucher_code = code;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_active_token` (IN `activeToken` VARCHAR(32))  BEGIN
	SELECT COUNT(*) FROM `users` WHERE `active_token` = activeToken AND `is_active` = '0' AND SUBDATE(NOW(), INTERVAL 5 MINUTE) <= date_created;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_active_user` ()  BEGIN
	SELECT COUNT(*) AS num_user FROM users WHERE type >= 50 AND trashed = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_all_comment` ()  BEGIN
	SELECT COUNT(*) FROM comments;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_all_review` ()  BEGIN
	SELECT COUNT(*) FROM reviews;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_all_slider` ()  BEGIN
	SELECT COUNT(*) FROM slider;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_all_user` ()  BEGIN
	SELECT COUNT(*) FROM users;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_approved_comment` ()  BEGIN
	SELECT COUNT(*) FROM comments WHERE approved = 1 AND trashed = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_approved_review` ()  BEGIN
	SELECT COUNT(*) FROM reviews WHERE approved = 1 AND trashed = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_categories_of_product` (`pId` INT UNSIGNED)  BEGIN
	
	SELECT COUNT(*) AS categories_count FROM phone_category WHERE phone_id = pId;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_disabled_user` ()  BEGIN
	SELECT COUNT(*) AS num_user FROM users WHERE type >= 50 AND trashed = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_like_comment` (`commentId` INT UNSIGNED)  BEGIN
SELECT COUNT(*) FROM `user_post_like` WHERE comment_id = commentId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_pending_comment` ()  BEGIN
	SELECT COUNT(*) FROM comments WHERE approved = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_pending_review` ()  BEGIN
	SELECT COUNT(*) FROM reviews WHERE approved = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_products_in_category` (IN `cat` TINYINT)  BEGIN
	
	SELECT COUNT(*) AS categories_count FROM phones p INNER JOIN phone_category pc ON p.id = pc.phone_id WHERE pc.category_id = cat;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_search_result` (IN `searchString` TEXT, IN `allWord` VARCHAR(3))  BEGIN
	IF allWord = 'on' THEN
	SELECT count(*) FROM phones WHERE MATCH(`name`, `description`) AGAINST (searchString IN BOOLEAN MODE);
    
    ELSE
    
    SELECT count(*) FROM phones WHERE MATCH(`name`, `description`) AGAINST(searchString);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_status_slider` (`status` TINYINT)  BEGIN
	SELECT COUNT(*) FROM slider WHERE trashed = status;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_trashed_review` ()  BEGIN
	SELECT COUNT(*) FROM reviews WHERE approved = 1 AND trashed = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_trash_comment` ()  BEGIN
	SELECT COUNT(*) FROM comments WHERE trashed = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_unseen_like_notify` (IN `userId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*)  FROM user_post_like l
    INNER JOIN comments c ON c.id = l.comment_id
    WHERE c.user_id = userId AND l.status = 'not-seen'
    AND c.approved = 1 AND c.trashed = 0;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_unseen_message` (IN `fromUserId` INT UNSIGNED, IN `toUserId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*)FROM chat_message WHERE from_user_id = fromUserId AND to_user_id = toUserId AND status = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_attribute` (IN `idAttr` TINYINT)  BEGIN
	DECLARE count_attr TINYINT;
    SELECT COUNT(*) FROM attribute_value WHERE attribute_id = idAttr
    INTO count_attr ;
    IF count_attr = 0 THEN
        DELETE FROM attribute WHERE attribute_id  = idAttr;
        SELECT 1;
    ELSE
    	SELECT -1;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_attr_value` (IN `attrValueId` TINYINT)  BEGIN
	DECLARE count_attr_product INT;
    SELECT COUNT(*) FROM  product_attribute
    WHERE attribute_value_id = attrValueId
    INTO count_attr_product;
    IF count_attr_product = 0 THEN
    DELETE FROM attribute_value WHERE attribute_value_id = attrValueId;
            SELECT 1;
        ELSE
            SELECT -1;
     END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_category` (IN `catId` TINYINT)  BEGIN
	DECLARE count_product INT UNSIGNED;

    SELECT COUNT(*) INTO count_product FROM phone_category WHERE category_id = catId ;
        IF count_product = 0 THEN
        DELETE FROM categories WHERE id = catId;
        SELECT 1;
        ELSE
        SELECT -1;
        END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_category_for_post` (`postId` INT UNSIGNED)  BEGIN
	DELETE FROM post_categories WHERE id = postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_discount_code` (`code` VARCHAR(25))  BEGIN
	DELETE FROM discount_codes WHERE voucher_code = code;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_old_carts` (IN `day` TINYINT)  BEGIN
	DELETE FROM shopping_cart 
    WHERE cart_id IN
    	(SELECT cart_id 
             FROM (SELECT cart_id
                    FROM shopping_cart
                    GROUP BY cart_id
                    HAVING DATE_SUB(NOW(), INTERVAL day DAY) > 
                     MAX(date_modified)) 
     			AS sc);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_post` (`postId` INT UNSIGNED)  BEGIN
	DELETE FROM posts WHERE id = postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_post_by_product` (`pId` INT UNSIGNED)  BEGIN

	DELETE FROM posts WHERE product_id = pId;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_products` (IN `pId` INT UNSIGNED)  BEGIN 
     	DELETE FROM product_attribute WHERE product_id = pId;
        DELETE FROM phone_category WHERE phone_id = pId;
        DELETE FROM shopping_cart WHERE product_id = pId;
        DELETE FROM phones WHERE id = pId;
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sale_product` (IN `productId` INT)  BEGIN
	DELETE FROM sales WHERE product_id = productId; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_shipping_address` (`addressId` INT UNSIGNED, `userId` INT UNSIGNED)  BEGIN
	DELETE FROM shipping_address WHERE id = addressId AND user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_is_type_status` (`userId` INT UNSIGNED)  BEGIN
	SELECT is_type FROM login_details 
 WHERE user_id = userId 
 ORDER BY last_activity DESC 
 LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetch_user_last_activity` (IN `userId` INT UNSIGNED)  BEGIN
	SELECT last_activity FROM login_details WHERE user_id = userId ORDER BY last_activity DESC LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_address` (`addressId` INT UNSIGNED, `userId` INT UNSIGNED)  BEGIN
	SELECT first_name, last_name, country, address1, address2, city, state, zip, phone, email FROM shipping_address WHERE id = addressId AND user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_address_by_id` (`userId` INT UNSIGNED, `idAddress` INT UNSIGNED)  BEGIN
	SELECT first_name, last_name, country, address1, address2, city, state, zip, phone, email FROM shipping_address WHERE user_id = userId AND id =  idAddress;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_attr` ()  BEGIN
	SELECT a.name, av.value, av.attribute_value_id FROM `attribute_value` av INNER JOIN `attribute`a ON av.attribute_id = a.attribute_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_comment` ()  BEGIN
	SELECT c.comment_id, c.parent_comment_id, c.comment, c.user_id, c.approved, c.approved, c.trashed, c.post_id, c.date, c.num_like, u.custom_name AS name FROM comments c
    INNER JOIN users u ON c.user_id = u.id
    ORDER BY date DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_attributes` ()  BEGIN
	SELECT attribute_id, name FROM attribute ORDER BY attribute_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_attributes_not_assign_to_product` (IN `pId` INT UNSIGNED)  BEGIN

SELECT a.name, v.attribute_value_id, v.value FROM attribute_value v INNER JOIN attribute a  ON v.attribute_id = a.attribute_id
WHERE v.attribute_value_id NOT IN (SELECT attribute_value_id FROM product_attribute a WHERE a.product_id = pId )
ORDER BY a.name, v.attribute_value_id;
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_attr_detail` (`attrId` TINYINT)  BEGIN
	SELECT attribute_id , name FROM attribute WHERE attribute_id = attrId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_attr_values` (IN `attrId` TINYINT)  BEGIN
	SELECT attribute_value_id, value FROM attribute_value WHERE attribute_id = attrId ORDER BY attribute_value_id ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_avg_rating` (IN `pId` INT UNSIGNED)  BEGIN
	DECLARE avg_rating FLOAT;
	SELECT AVG(rating) INTO avg_rating FROM reviews WHERE product_id = pId;
    IF avg_rating IS NULL THEN SET avg_rating = 0;
    END IF;
    SELECT avg_rating;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_categories_for_product` (IN `pId` INT UNSIGNED)  BEGIN
    SELECT c.id, c.category, c.description, c.image FROM phone_category pc INNER JOIN categories c ON pc.category_id = c.id WHERE pc.phone_id = pId;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_count_old_cart` (IN `inDays` TINYINT)  BEGIN
SELECT COUNT(cart_id) AS old_shopping_carts_count FROM
(SELECT cart_id  FROM shopping_cart GROUP BY cart_id
HAVING DATE_SUB(NOW(), INTERVAL inDays DAY) > MAX(date_modified)) AS old_carts;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_departments_detail` (`id` TINYINT)  BEGIN
	SELECT name, image FROM department WHERE id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_category` (IN `catId` TINYINT)  BEGIN

	SELECT category, description, image FROM categories WHERE id =  catId;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_post` (IN `id` INT UNSIGNED)  BEGIN
	SELECT p.`title`, p.`description`, p.`content`, p.`num_view`, p.`date_created`, u.id, u.name FROM `posts` p
    INNER JOIN `users` u ON p.user_id = u .id
    WHERE p.`id` = id AND p.`status` = 'live';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_discount_code` (IN `discountCode` VARCHAR(25))  BEGIN
	SELECT active, min_basket_cost, discount_operation, discount_amount, num_vouchers, IF(expiry < NOW(), 1, 0) AS expired FROM discount_codes WHERE voucher_code = discountCode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_featured_items` (IN `numProduct` INT UNSIGNED)  BEGIN
SELECT p.id, p.name, p.thumb, p.description, p.price, p.stock, s.price AS sale_price, pm.promotion  FROM phones p
INNER JOIn phone_category pc ON p.id = pc.phone_id
LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))
LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id
WHERE p.is_featured = 1
ORDER By RAND()
LIMIT numProduct;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_images_product` (IN `id` INT UNSIGNED)  BEGIN
	SELECT image FROM img_product i WHERE i.product_id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_image_category` (IN `catId` TINYINT)  BEGIN
    SELECT image FROM categories WHERE id = catId;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_image_products` (IN `type` VARCHAR(7), IN `id` INT UNSIGNED)  BEGIN
    SELECT image FROM `img_product` WHERE product_id = id ORDER BY ip.date_created;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_info_all_attr` ()  BEGIN
	SELECT a.name, av.value, av.attribute_value_id FROM `attribute_value` av INNER JOIN `attribute`a ON av.attribute_id = a.attribute_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_info_user` (IN `userId` INT UNSIGNED)  BEGIN
	SELECT email, pass, name, avatar FROM users WHERE id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_account` ()  BEGIN
	SELECT year, purchase, sale, profit FROM account ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_address` (IN `userId` INT UNSIGNED)  BEGIN
	SELECT id, first_name, last_name , address1, address2, city, state, zip, country FROM shipping_address WHERE user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_attributes` ()  BEGIN
	SELECT a.name, av.attribute_value_id, av.value FROM attribute a INNER JOIN attribute_value av ON a.attribute_id = av.attribute_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_categories` ()  BEGIN
	SELECT id, parent_cat_id, category, description, image FROM categories;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_category` ()  BEGIN
	SELECT id, category, parent_cat_id  FROM categories;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_cat_post` ()  BEGIN
	SELECT id, category FROM `discount_codes`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_comments` (IN `postId` INT UNSIGNED)  BEGIN
	SELECT c.id, c.parent_comment_id, c.comment, c.user_id, c.approved, c.approved, c.trashed, c.post_id, c.date_created, u.name, u.avatar, u.type FROM comments c
    INNER JOIN users u ON c.user_id = u.id
    WHERE c.post_id = postId AND c.approved = 1 AND c.trashed = 0 AND  c.parent_comment_id = 0
    ORDER BY date_created DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_comments_reply` (IN `parentId` INT UNSIGNED, IN `postId` INT UNSIGNED)  BEGIN
	SELECT c.id, c.parent_comment_id, c.comment, c.user_id, c.date_created, u.name, u.avatar, u.type FROM comments c
    INNER JOIN users u ON c.user_id = u.id
    WHERE c.post_id = postId AND c.approved = 1 AND c.trashed = 0 AND c.parent_comment_id = parentId
    ORDER BY date_created ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_comment_by_user` (`userId` INT UNSIGNED)  BEGIN
	SELECT comment_id FROM comments WHERE user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_customer` ()  BEGIN
	SELECT id, CONCAT_WS(' ', first_name, last_name) name FROM customers;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_discount_code` (IN `startItem` INT, IN `perPage` INT)  BEGIN
	SELECT voucher_code, active, min_basket_cost, discount_operation, discount_amount, num_vouchers, expiry FROM discount_codes LIMIT startItem, perPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_featured_posts` (IN `startItem` INT UNSIGNED, IN `perPage` INT UNSIGNED)  BEGIN
	SELECT p.`id`, p.`title`, p.`thumb`, p.`description`, p.`content`, p.`date_created`, u.`name` FROM `posts` p
    INNER JOIN  `users` u ON p.user_id = u.id
    WHERE p.is_featured = 1
    ORDER BY p.`date_created` DESC LIMIT startItem, perPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_inventory_from_to` (IN `fromNumber` MEDIUMINT UNSIGNED, IN `toNumber` MEDIUMINT UNSIGNED)  BEGIN
	SELECT id, name, price, stock, date_created FROM phones WHERE stock BETWEEN fromNumber AND toNumber;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_like_notify` (IN `userId` INT UNSIGNED)  BEGIN
	
	SELECT u.id user_id, u.name, u.avatar, p.id , p.title, l.seen, l.date_created  FROM user_post_like l
    INNER JOIN comments c ON c.id = l.comment_id
    INNER JOIN users u ON u.id = l.user_id
    INNER JOIN posts p ON p.id = c.post_id
    WHERE c.user_id = userId
    AND c.approved = 1 AND c.trashed = 0
    ORDER BY l.date_created DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_message` (IN `fromUserId` INT, IN `toUserId` INT)  BEGIN
	SELECT chat_message_id, to_user_id, from_user_id, chat_message, status, date_created FROM chat_message  
    WHERE (from_user_id = fromUserId  AND to_user_id = toUserId) 
    OR (from_user_id = toUserId AND to_user_id = fromUserId ) ORDER BY date_created ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_most_order_product` (`numItem` INT)  BEGIN
(SELECT COUNT(oc.order_id) num_product, p.id, p.name, p.description, p.thumb, p.content, p.stock, p.price, p.promotion_id, p.video, p.screen, p.os, p.camera_back, p.camera_front, p.cpu, p.sim, p.battery, s.price AS sale_price, pm.promotion FROM phones p 
LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND 
((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS  NULL)))
INNER JOIN order_contents oc ON p.id = oc.product_id GROUP BY oc.product_id)
    
UNION

(SELECT COUNT(oc.order_id) num_product, p.id, p.name, p.description, p.thumb, p.content, p.stock, p.price, p.promotion_id, p.video, p.screen, p.os, p.camera_back, p.camera_front, p.cpu, p.sim, p.battery, s.price AS sale_price, pm.promotion FROM phones p 
LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND 
((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS  NULL)))
INNER JOIN order_contents_not_login oc ON p.id = oc.product_id GROUP BY oc.product_id)
ORDER BY num_product DESC LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_new_posts` (IN `startItem` MEDIUMINT, IN `perPage` MEDIUMINT)  BEGIN
	SELECT p.`id`, p.`title`, p.`thumb`, p.`description`, p.`content`, p.`date_created`, u.`name` FROM `posts` p
    INNER JOIN  `users` u ON p.user_id = u.id
    WHERE status = 'live' 
    ORDER BY p.`date_created` DESC LIMIT startItem, perPage;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_notify_stock` ()  BEGIN
	SELECT id, name, email, product_id FROM product_stock_notification WHERE processed = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_post_by_new_product` (IN `numItem` INT UNSIGNED)  BEGIN
	SELECT p.id, p.name, p.thumb, IFNULL(s.price, p.price) price, po.product_id, COUNT(po.product_id) num_post FROM phones p INNER JOIN posts po ON po.product_id = p.id AND po.status = 'live'
LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
LEFT OUTER JOIN sales s ON (p.id = s.product_id AND 
((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))
GROUP BY po.product_id ORDER BY p.date_created DESC LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_post_by_product` (IN `pId` INT UNSIGNED, IN `numItem` INT)  BEGIN
SELECT po.id, po.title, po.thumb, po.description, po.date_created, u.name  FROM phones p 
INNER JOIN posts po ON po.product_id = p.id 
INNER JOIN users u ON po.user_id = u.id
WHERE po.product_id = pId AND po.status = 'live'
ORDER BY po.date_created DESC LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_post_by_product_id` (IN `pId` INT UNSIGNED, IN `numItem` INT UNSIGNED)  BEGIN
	SELECT p.`id`, p.`title`, p.`thumb` FROM `posts` p
    WHERE p.product_id = pId
    ORDER BY p.`date_created` DESC LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_post_most_comment` (IN `numItem` INT UNSIGNED)  BEGIN
	SELECT p.id, p.title,  p.thumb, p.description, p.date_created, COUNT(c.post_id) num_comment FROM comments c INNER JOIN posts p ON c.post_id = p.id WHERE (c.approved = 1 AND c.trashed = 0) GROUP BY c.post_id  ORDER BY COUNT(c.post_id) DESC  LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_post_most_view` (IN `numItem` TINYINT)  BEGIN
	SELECT p.`id`, p.`title`, p.`thumb`, p.`description`, p.`content`, p.num_view, p.`date_created`, u.`name` FROM `posts` p
    INNER JOIN  `users` u ON p.user_id = u.id
    ORDER BY p.num_view DESC LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_privileges` ()  BEGIN
	SELECT id, type FROM user_type WHERE id != 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_product_not_sale` ()  BEGIN
	SELECT id, name, thumb, price, stock, date_created FROM phones WHERE id NOT IN (SELECT product_id FROM sales) ORDER BY date_created;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_product_sale` (IN `numItem` INT)  BEGIN
	SELECT s.product_id, p.name, p.thumb, p.price, p.stock, p.date_created, s.price AS sale_price, s.start_date, s.end_date, NOW() AS now FROM phones p
    INNER JOIN sales s ON s.product_id = p.id
    ORDER BY p.date_created
    LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_related_products` ()  BEGIN
SELECT product_id, name, thumb FROM ((SELECT r.product_a product_id, p.name, p.thumb FROM related_phone r
INNER JOIN phones p ON r.product_a = p.id
)
UNION
(SELECT r.product_b product_id, p.name, p.thumb FROM related_phone r
INNER JOIN phones p ON r.product_b = p.id
)) as tmp
GROUP BY product_id;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_reply_comment` (IN `userId` INT)  BEGIN
	SELECT c.comment, u.id user_id, u.name, u.avatar, p.id , p.title, c.seen, c.date_created FROM comments c INNER JOIN users u ON u.id = c.user_id INNER JOIN posts p ON p.id = c.post_id
    WHERE c.parent_comment_id  IN (SELECT id FROM comments c WHERE c.user_id = userId)
    AND c.approved = 1 AND c.trashed = 0
    ORDER BY c.date_created;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_sliders` (IN `limitItem` TINYINT)  BEGIN
	SELECT link, image FROM slider ORDER BY order_slider ASC LIMIT limitItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_list_users` ()  BEGIN
	SELECT id, name FROM users;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_most_recent_orders` (IN `isLogin` TINYINT, IN `numItem` INT)  BEGIN
	IF isLogin = 1 THEN
	SELECT CONCAT('Y', o.order_id) order_id, o.customer_id, o.total, o.shipping, o.ship_date, o.order_date, o.status,  CONCAT_WS(' ', o.first_name, o.last_name) name, COUNT(oc.order_id) AS items
 FROM orders o 
 INNER JOIN order_contents oc ON oc.order_id = o.order_id
 INNER JOIN users u ON o.customer_id = u.id
 INNER JOIN charges c ON o.order_id = c.order_id
 WHERE o.ship_date IS NULL
 GROUP BY o.order_id
 ORDER BY o.order_date DESC	LIMIT 0, numItem;
 ELSE
 
 SELECT CONCAT('N', o.order_id) order_id, o.customer_id, o.total, o.shipping, o.ship_date, o.order_date,	o.status, CONCAT_WS(' ', ct.first_name, ct.last_name) name, COUNT(oc.order_id) AS items
 FROM orders_not_login o 
 INNER JOIN order_contents_not_login oc ON oc.order_id = o.order_id
 INNER JOIN customers ct ON o.customer_id = ct.id
 INNER JOIN charges_not_login c ON o.order_id = c.order_id
 WHERE o.ship_date IS NULL
 GROUP BY o.order_id
 ORDER BY o.order_date DESC	LIMIT 0, numItem;
 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_new_items` (IN `numProduct` TINYINT UNSIGNED)  BEGIN
SELECT p.id, p.name, p.thumb, p.description, p.price, p.stock, s.price AS sale_price, pm.promotion  FROM phones p
INNER JOIn phone_category pc ON p.id = pc.phone_id
LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))
LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id
ORDER By p.date_created DESC
LIMIT numProduct;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_num_rating` (IN `pId` INT UNSIGNED, IN `numStart` TINYINT)  BEGIN
	DECLARE num_rating INT;
    IF numStart = 0 THEN
	SELECT COUNT(*) INTO  num_rating FROM reviews WHERE  product_id = pId AND approved = 1 AND trashed = 0;
    ELSE
    SELECT COUNT(*) INTO  num_rating FROM reviews WHERE  product_id = pId AND rating = numStart AND approved = 1 AND trashed = 0;
    END IF;
    
    SELECT num_rating;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_num_view` (`postId` INT UNSIGNED)  BEGIN
	SELECT num_view FROM views WHERE post_id = postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_one_post` ()  BEGIN
	SELECT p.`id`, p.`title`, p.`thumb`, p.`date_created` FROM `posts` p
    WHERE p.`status` = 'live' ORDER BY date_created  DESC LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_orders_content` (IN `isLogin` TINYINT, IN `orderId` INT UNSIGNED)  BEGIN
	IF isLogin = 1 THEN
	SELECT p.name product_name, oc.product_id, oc.attributes, oc.quantity, oc.price, (oc.quantity * oc.price) AS subtotal  FROM order_contents oc
 INNER JOIN phones p ON oc.product_id = p.id
 WHERE order_id = orderId;
	ELSE
    SELECT p.name product_name, oc.product_id, oc.attributes, oc.quantity, oc.price, (oc.quantity * oc.price) AS subtotal  FROM order_contents_not_login oc
 INNER JOIN phones p ON oc.product_id = p.id
 WHERE oc.order_id = orderId;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_between_dates` (IN `isLogin` TINYINT, IN `startDate` DATE, IN `endDate` DATETIME)  BEGIN
	IF isLogin = 1 THEN
	SELECT CONCAT('Y', o.order_id) order_id, o.customer_id, o.total, o.status, o.shipping, o.ship_date, o.order_date,  CONCAT_WS(' ', o.first_name, o.last_name) name, COUNT(oc.order_id) AS items FROM orders o 
INNER JOIN order_contents oc ON o.order_id = oc.order_id
INNER JOIN users u ON o.customer_id = u.id
 INNER JOIN charges c ON o.order_id = c.order_id
WHERE (o.order_date >= startDate) AND (o.order_date <= endDate) AND o.ship_date IS NULL
GROUP BY o.order_id
ORDER BY o.order_date DESC;
	ELSE
    SELECT CONCAT('N', o.order_id) order_id, o.customer_id, o.total, o.status, o.shipping, o.ship_date, o.order_date, CONCAT_WS(' ', ct.first_name, ct.last_name) name, COUNT(oc.order_id) AS items FROM orders_not_login o 
INNER JOIN order_contents_not_login oc ON o.order_id = oc.order_id
INNER JOIN customers ct ON o.customer_id = ct.id
 INNER JOIN charges_not_login c ON o.order_id = c.order_id
WHERE (o.order_date >= startDate) AND (o.order_date <= endDate) AND o.ship_date IS NULL
GROUP BY o.order_id
ORDER BY o.order_date DESC;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_by_customer_id` (IN `isLogin` TINYINT, IN `customerId` INT UNSIGNED)  BEGIN
IF isLogin = 1 THEN
    SELECT CONCAT('Y', o.order_id) order_id, o.total, o.status, o.shipping, o.ship_date, o.order_date, u.name, COUNT(oc.order_id) AS items  FROM orders o 
    INNER JOIN order_contents oc ON oc.order_id = o.order_id
    INNER JOIN users u ON o.customer_id = u.id
     INNER JOIN charges c ON o.order_id = c.order_id
    WHERE customer_id = customerId AND o.ship_date IS NULL
    GROUP BY o.order_id
    ORDER BY o.order_date;
ELSE
        SELECT CONCAT('N', o.order_id) order_id, o.total, o.status, o.shipping, o.ship_date, o.order_date, CONCAT_WS(' ', u.first_name, u.last_name) AS name, COUNT(oc.order_id) AS items  FROM orders_not_login o 
    INNER JOIN order_contents_not_login oc ON oc.order_id = o.order_id
    INNER JOIN customers u ON o.customer_id = u.id
     INNER JOIN charges_not_login c ON o.order_id = c.order_id
    WHERE customer_id = customerId AND o.ship_date IS NULL
    GROUP BY o.order_id
    ORDER BY o.order_date;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_by_id` (IN `isLogin` TINYINT, IN `orderId` INT UNSIGNED)  BEGIN
	IF isLogin = 1 THEN
	SELECT CONCAT('Y', o.order_id) order_id, o.total, o.status, o.order_date, o.shipping, o.ship_date, CONCAT_WS(' ', o.first_name, o.last_name) name, COUNT(oc.order_id) AS items  FROM orders o
 INNER JOIN order_contents oc ON o.order_id = oc.order_id   
 INNER JOIN users u ON o.customer_id = u.id
 INNER JOIN charges c ON o.order_id = c.order_id
 WHERE o.order_id = orderId
 AND o.ship_date IS NULL
 GROUP BY o.order_id
  ORDER BY o.order_date;
  
  ELSE
  
  SELECT CONCAT('N', o.order_id) order_id, o.order_id, o.total, o.status, o.order_date, o.shipping, o.ship_date,  CONCAT_WS(' ', ct.first_name, ct.last_name) name, COUNT(oc.order_id) AS items  FROM orders_not_login o
 INNER JOIN order_contents_not_login oc ON o.order_id = oc.order_id   
 INNER JOIN customers ct ON o.customer_id = ct.id
 INNER JOIN charges_not_login c ON o.order_id = c.order_id
 WHERE o.order_id = orderId
 AND o.ship_date IS NULL
 GROUP BY o.order_id
  ORDER BY o.order_date;
  END IF;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_by_status` (IN `isLogin` TINYINT, IN `statusOrder` TINYINT)  BEGIN
	IF isLogin = 1 THEN
	SELECT CONCAT('Y', o.order_id) order_id, o.customer_id, o.total, o.status, o.shipping, o.ship_date, o.order_date, CONCAT_WS(' ', o.first_name, o.last_name) name, COUNT(oc.order_id) AS items FROM orders o 
INNER JOIN order_contents oc ON o.order_id = oc.order_id    
INNER JOIN users u ON o.customer_id = u.id 
 INNER JOIN charges c ON o.order_id = c.order_id
WHERE o.status = statusOrder
AND o.ship_date IS NULL
GROUP BY o.order_id
ORDER BY o.order_date DESC;
	ELSE 
    
    SELECT CONCAT('N', o.order_id) order_id , o.customer_id, o.total, o.status, o.shipping, o.ship_date, o.order_date, CONCAT_WS(' ', ct.first_name, ct.last_name) name, COUNT(oc.order_id) AS items FROM orders_not_login o 
INNER JOIN order_contents_not_login oc ON o.order_id = oc.order_id   
INNER JOIN customers ct ON o.customer_id = ct.id 
 INNER JOIN charges_not_login c ON o.order_id = c.order_id
WHERE o.status = statusOrder
AND o.ship_date IS NULL
GROUP BY o.order_id
ORDER BY o.order_date DESC;
END IF;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_content_history_by_customer` (IN `orderId` INT UNSIGNED, IN `userId` INT UNSIGNED)  BEGIN
	SELECT p.name product_name, p.thumb, oc.product_id, oc.attributes, oc.quantity, oc.price, (oc.quantity * oc.price) AS subtotal  FROM order_contents oc
 INNER JOIN phones p ON oc.product_id = p.id
 INNER JOIN orders o ON oc.order_id = o.order_id
 INNER JOIN users u ON o.customer_id = u.id
 WHERE u.id = userId AND  oc.order_id = orderId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_history_by_customer` (IN `userId` INT UNSIGNED)  BEGIN
	SELECT o.order_id, o.status, o.total, o.order_date,p.id, p.name, p.thumb FROM orders o
INNER JOIN order_contents oc ON o.order_id = oc.order_id AND o.customer_id = userId
INNER JOIN phones p ON oc.product_id = p.id
GROUP BY oc.order_id
ORDER BY o.order_date DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_info` (IN `isLogin` TINYINT, IN `orderId` INT UNSIGNED)  BEGIN
	IF isLogin = 1 THEN
	SELECT  CONCAT('Y', o.order_id) order_id, o.customer_id, CONCAT_WS(' ', o.first_name, o.last_name) name, u.email, o.total, o.status, o.shipping, o.discount_price, o.ship_date, o.comments, o.credit_card_number, o.order_date,
CONCAT_WS(', ', o.country, o.address1, o.address2, o.city, o.state, o.zip) address, o.phone
    FROM orders o
    INNER JOIN users u ON o.customer_id = u.id
    WHERE order_id = orderId;
    ELSE
    SELECT  CONCAT('N', o.order_id) order_id, o.customer_id, o.total, o.status, o.shipping, o.discount_price, o.ship_date, o.comments, o.credit_card_number, o.order_date,
CONCAT_WS(', ', c.country, c.address1, c.address2, c.city, c.state, c.zip, c.first_name, c.last_name) address, c.phone, c.email, CONCAT_WS(' ', c.first_name, c.last_name) name
    FROM orders_not_login o
    INNER JOIN customers c ON o.customer_id = c.id
    WHERE o.order_id = orderId;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_products_by_category` (IN `catId` MEDIUMINT, IN `startItem` MEDIUMINT, IN `perPage` TINYINT)  BEGIN
    SELECT p.id, p.name, p.thumb, p.description, p.price, p.stock, s.price AS sale_price, pm.promotion  FROM phones p

INNER JOIn phone_category pc ON p.id = pc.phone_id

LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))

 LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id
 
 WHERE pc.category_id = catId ORDER BY p.date_created DESC LIMIT startItem,  perPage;
   
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_product_attributes` (IN `id` INT UNSIGNED)  BEGIN	
SELECT a.name, av.value, av.attribute_value_id FROM `attribute_value` av INNER JOIN `attribute`a ON av.attribute_id = a.attribute_id
WHERE av.attribute_value_id IN (SELECT pa.attribute_value_id FROM `product_attribute` pa WHERE pa.product_id = id) ORDER BY a.name , av.attribute_value_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_product_info` (IN `pId` INT UNSIGNED)  BEGIN
    SELECT p.id, p.name, p.description, p.content, p.stock, p.price, p.thumb,  p.promotion_id, p.video, c.category, s.price AS sale_price, pm.promotion FROM phones p INNER JOIN phone_category pc ON p.id = pc.phone_id INNER JOIN categories c ON pc.category_id = c.id
    LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
    LEFT OUTER JOIN sales s ON (p.id = s.product_id AND 
    ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS  NULL))) WHERE p.id = pId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_product_locations` (`type` VARCHAR(7), `id` INT)  BEGIN
	IF type = 'phone' THEN
SELECT 'phone', ph.category FROM ph_categories ph WHERE ph.id  IN (SELECT pc.category_id FROM phone_category pc WHERE pc.phone_id = id);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_product_most_rating` (IN `numItem` INT)  BEGIN
SELECT AVG(r.rating) rating, COUNT(r.product_id) num, p.id, p.name, p.description, p.thumb, p.content, p.stock, p.price, p.promotion_id, p.video, p.screen, p.os, p.camera_back, p.camera_front, p.cpu, p.sim, p.battery, s.price AS sale_price, pm.promotion FROM phones p 
 LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS  NULL)))
INNER JOIN reviews r ON p.id = r.product_id AND r.approved = 1 AND r.trashed = 0 GROUP BY r.product_id
ORDER BY rating DESC, num DESC
LIMIT numItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_quantity` (`uid` CHAR(32), `type` VARCHAR(7), `id` INT)  BEGIN
	IF type = 'phone' THEN
	SELECT c.quantity qty FROM carts c INNER JOIN phones p ON c.product_id 	= p.id 
 WHERE c.user_session_id = uid AND c.product_type = 'phone' AND c.product_id = id;
    
    ELSEIF type = 'racket' THEN
    
    SELECT c.quantity qty FROM carts c INNER JOIN bad_racket r ON c.product_id = r.id
 WHERE c.user_session_id = uid AND 	c.product_type = 'racket' AND c.product_id = id;
 
 	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recommends_also_bought` (IN `pId` INT UNSIGNED, IN `limitItem` TINYINT)  BEGIN
    SELECT oc2.product_id id, p.name product_name, p.thumb, p.price, s.price AS sale_price, p.stock, pm.promotion FROM order_contents oc1 
	INNER JOIN order_contents oc2 ON (oc1.order_id = oc2.order_id)
    INNER JOIN orders o ON (oc1.order_id = o.order_id)
    INNER JOIN phones p ON oc2.product_id = p.id
    LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id
    

LEFT OUTER JOIN sales s ON (p.id = s.product_id
AND ((NOW() BETWEEN s.start_date AND s.end_date) 
OR (NOW() > s.start_date  AND s.end_date  IS NULL)))
    
    WHERE oc1.product_id = pId AND oc2.product_id != pId
    AND DATE_SUB(NOW(), INTERVAL 30 DAY) <= o.order_date
    GROUP BY oc2.product_id
    ORDER BY COUNT(oc2.product_id) DESC
    LIMIT limitItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recommend_products_same_category` (IN `pId` INT UNSIGNED, IN `numItem` INT)  BEGIN
    SELECT p.id, p.name, p.description, p.thumb, p.stock, p.promotion_id, p.price, s.price AS sale_price FROM phones p INNER JOIN phone_category c ON p.id = c.phone_id 

LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
    LEFT OUTER JOIN sales s ON (p.id = s.product_id AND 
    ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() >
    s.start_date AND s.end_date IS NULL)))
    
WHERE p.id != pId AND c.category_id IN (SELECT c.category_id FROM phones p INNER JOIN phone_category c ON p.id = c.phone_id WHERE id = pId) ORDER BY RAND() LIMIT numItem;
    

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recommend_related_products` (IN `pId` INT UNSIGNED, IN `limitItem` TINYINT)  BEGIN
SELECT
iF(rp.product_a = pId, pB.id, pA.id) AS id,
iF(rp.product_a = pId, pB.name, pA.name) AS name,
iF(rp.product_a = pId, pB.thumb, pA.thumb) AS thumb,
iF(rp.product_a = pId, pB.price, pA.price) AS price,
iF(rp.product_a = pId, sB.price, sA.price) AS sale_price,
iF(rp.product_a = pId, pB.stock, pA.stock) AS stock

FROM related_phone rp 
INNER JOIN phones pA ON rp.product_a = pA.id
INNER JOIN  phones pB ON  rp.product_b = pB.id


LEFT OUTER JOIN sales sA ON (pA.id = sA.product_id
AND ((NOW() BETWEEN sA.start_date AND sA.end_date) 
OR (NOW() > sA.start_date  AND sA.end_date  IS NULL)))

LEFT OUTER JOIN sales sB ON (pB.id = sB.product_id
AND ((NOW() BETWEEN sB.start_date AND sB.end_date) 
OR (NOW() > sB.start_date  AND sA.end_date  IS NULL)))

WHERE (rp.product_a = pId OR rp.product_b = pId) ORDER BY RAND() LIMIT limitItem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_reviews` (IN `pId` INT UNSIGNED)  BEGIN
SELECT u.avatar, u.name, r.review, r.rating, r.date_created FROM reviews r INNER JOIN users u ON r.customer_id = u.id
WHERE r.product_id = pId AND r.approved = 1 ORDER BY r.date_created ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_sale_items` (IN `numItem` INT)  BEGIN
        SELECT p.id, s.price AS sale_price, p.thumb, p.name, p.price AS price, p.stock, p.description, pm.promotion FROM sales as s  
        INNER JOIN phones as p ON s.product_id = p.id
        LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
        WHERE ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)) ORDER BY RAND() LIMIT numItem;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_shipping_info` (`shippingRegionId` TINYINT)  BEGIN
	SELECT shipping_id, shipping_type, shipping_cost, shipping_region_id FROM shipping WHERE shipping_region_id = shippingRegionId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_shipping_religion` ()  BEGIN
	SELECT shipping_region_id, shipping_region FROM  shipping_region ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_subtotal_wishlist` (`uid` CHAR(32), `type` VARCHAR(7), `id` INT UNSIGNED)  BEGIN
	IF type = 'phone' THEN
	SELECT w.quantity * IFNULL(sales.price, p.price) FROM wish_lists w INNER JOIN phones p ON w.product_id 	= p.id LEFT OUTER JOIN sales
ON (sales.product_id=p.id AND sales.product_type='phone'
AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
 WHERE w.user_session_id = uid AND w.product_type = 'phone' AND w.product_id = id;
    
    ELSEIF type = 'racket' THEN
    
    SELECT c.quantity * IFNULL(sales.price, r.price) FROM wish_lists w INNER JOIN bad_racket r ON w.product_id = r.id   LEFT OUTER JOIN sales ON (sales.product_id=r.id AND sales.product_type='racket'
AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
 WHERE w.user_session_id = uid AND 	w.product_type = 'racket' AND w.product_id = id;
 
 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_total_comments` (IN `postId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*) AS total FROM comments WHERE post_id = postId AND approved = 1 AND trashed = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_type_of_user` (IN `typeUser` INT)  BEGIN
	SELECT type FROM user_type WHERE id = typeUser;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_review` (`productId` INT UNSIGNED, `userId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*) FROM reviews WHERE product_id  = productId AND customer_id  = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_user_has_already_like_comment` (IN `commentId` INT UNSIGNED, IN `userId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*) FROM user_post_like  WHERE comment_id = commentId AND user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_valid_admin` (IN `userId` INT)  BEGIN
	SELECT COUNT(*) FROM users WHERE id = userId AND type >= 50;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_valid_attr` (`attrId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*) FROM attribute WHERE attribute_id = attrId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_valid_category` (`catId` INT)  BEGIN
	SELECT COUNT(*) FROM categories WHERE id = catId;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_valid_product` (`pId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*) FROM phones WHERE id = pId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_valid_product_in_category` (`productId` INT UNSIGNED, `categoryId` INT UNSIGNED)  BEGIN
	SELECT COUNT(*) FROM phone_category WHERE phone_id = productId AND category_id = categoryId;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `move_product_to_category` (IN `pId` INT UNSIGNED, IN `sourceCatId` TINYINT, IN `targetCatId` TINYINT)  BEGIN
    UPDATE phone_category SET category_id = targetCatId WHERE phone_id = pId AND category_id = sourceCatId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `num_stock` (IN `productId` INT UNSIGNED)  BEGIN
	SELECT stock FROM phones WHERE id = productId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_from_wish_list` (IN `uid` CHAR(32), IN `type` VARCHAR(7), IN `pid` MEDIUMINT)  BEGIN
	DELETE FROM wish_lists WHERE user_session_id = uid AND product_type = type AND product_id = pid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_message` (`messageId` INT UNSIGNED)  BEGIN
	UPDATE chat_message SET status = 2 WHERE chat_message_id = messageId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_product_attribute_value` (IN `pId` INT UNSIGNED, IN `attrValueId` TINYINT)  BEGIN
    	DELETE FROM product_attribute WHERE product_id = pId AND attribute_value_id = attrValueId;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_product_from_category` (IN `pId` INT UNSIGNED, IN `catId` TINYINT UNSIGNED)  BEGIN
	DECLARE countCat INT UNSIGNED;

     	SELECT COUNT(*) INTO countCat FROM phone_category WHERE phone_id = pId;
        IF countCat = 1 THEN
        	CALL delete_products(pId);
            SELECT 0;
        ELSE
        	DELETE FROM  phone_category WHERE phone_id = pId AND category_id = catId;
        	SELECT -1;
        END IF;
       
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search` (IN `searchString` TEXT, IN `allWord` VARCHAR(3), IN `startItem` INT UNSIGNED, IN `perPage` INT UNSIGNED)  BEGIN
	IF allWord = 'on' THEN
	SELECT p.id, p.name, p.description, p.thumb, p.stock, p.price, pm.promotion, s.price AS sale_price FROM phones AS p 
    LEFT OUTER JOIN promotion AS pm
 ON p.promotion_id = pm.id
 LEFT OUTER JOIN sales AS s ON (p.id = s.product_id
  AND ((NOW()  BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL)))  WHERE MATCH(`name`, `description`) AGAINST (searchString IN BOOLEAN MODE)
    ORDER BY MATCH(`name`, `description`) AGAINST (searchString IN BOOLEAN MODE) DESC LIMIT startItem, perPage;
    
    ELSE
    
    SELECT p.id,  p.name, p.description, p.thumb, p.stock, p.price, pm.promotion, s.price AS sale_price FROM phones AS p 
LEFT OUTER JOIN promotion AS pm ON p.promotion_id = pm.id LEFT OUTER JOIN sales AS s ON (p.id = s.product_id
 AND  ((NOW()  BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS NULL))) WHERE MATCH(`name`, `description`) AGAINST(searchString)
    ORDER BY MATCH(`name`, `description`) AGAINST (searchString) DESC LIMIT startItem, perPage;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `seen_notify_comment` (IN `userId` INT UNSIGNED)  BEGIN
UPDATE comments c SET seen = 1 WHERE id IN (SELECT id FROM comments c WHERE c.parent_comment_id IN (SELECT id FROM  comments c WHERE c.user_id = userId)) AND c.approved = 1 AND c.trashed = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `seen_notify_like` (IN `userId` INT UNSIGNED)  BEGIN
UPDATE user_post_like l SET seen = 1 WHERE l.comment_id IN (SELECT id FROM comments c WHERE c.user_id = userId) AND l.seen = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_categories` ()  BEGIN
	
  SELECT id, category, description, image FROM categories ORDER BY id;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_departments_list` ()  BEGIN 
	SELECT `id`, `name`, `image`, `description` FROM department ORDER BY id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_detail_category` (`type` VARCHAR(7), `id` MEDIUMINT)  BEGIN
	IF type = 'racket' THEN
    	SELECT id, category, description, image FROM bad_categories c WHERE c.id = id;
    ELSEIF type = 'phone' THEN
    	SELECT id, category, description, image FROM ph_categories c WHERE c.id = id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_detail_product` (IN `id` INT UNSIGNED)  BEGIN

    SELECT p.id, p.name, p.description, p.thumb, p.content, p.stock, p.price, p.promotion_id, p.video, p.screen, p.os, p.camera_back, p.camera_front, p.cpu, p.sim, p.battery, s.price AS sale_price, pm.promotion FROM phones p 
    LEFT OUTER JOIN promotion pm ON p.promotion_id = pm.id 
    LEFT OUTER JOIN sales s ON (p.id = s.product_id  AND 
    ((NOW() BETWEEN s.start_date AND s.end_date) OR (NOW() > s.start_date AND s.end_date IS  NULL))) WHERE p.id = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `set_thumb` (`type` VARCHAR(7), `pId` INT UNSIGNED, `nameImg` VARCHAR(45))  BEGIN
	IF type = 'phone' THEN
    	UPDATE phones SET thumb = nameImg WHERE id = pId;
    ELSEIF type = 'racket' THEN
        UPDATE bad_racket SET thumb = nameImg WHERE id = pId;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_add_product` (IN `isLogin` BOOLEAN, IN `isCart` BOOLEAN, IN `cartId` CHAR(32), IN `userId` INT, IN `pid` MEDIUMINT, IN `attr` VARCHAR(50), IN `qty` TINYINT)  BEGIN
DECLARE item_cart_id INT;
IF isLogin = 0 THEN
    SELECT item_id  INTO item_cart_id FROM shopping_cart WHERE 			cart_id = cartId AND product_id = pid AND attributes = attr AND buy_now = isCart AND user_id = 0; 
    IF item_cart_id > 0 THEN
    UPDATE shopping_cart SET quantity = quantity + qty, 				date_modified = NOW() WHERE item_id = item_cart_id; 
    ELSE 
    INSERT INTO shopping_cart (cart_id, product_id, attributes, 		quantity, buy_now) VALUES(cartId, pid, attr, qty, isCart);
    END IF; 
ELSE
	SELECT item_id  INTO item_cart_id FROM shopping_cart WHERE 			user_id = user_id AND product_id = pid AND attributes = attr
    AND buy_now = isCart AND user_id != 0; 
    IF item_cart_id > 0 THEN
    UPDATE shopping_cart SET quantity = quantity + qty, 				date_modified = NOW() WHERE item_id = item_cart_id; 
    ELSE 
    INSERT INTO shopping_cart (cart_id, user_id, product_id, 			attributes, quantity, buy_now) VALUES(cartId, userId, pid, attr, qty, isCart);
    END IF; 
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_check_item_id_belong_to_cart_id` (IN `itemId` INT UNSIGNED, IN `cartId` VARCHAR(32))  BEGIN
	SELECT COUNT(*) FROM shopping_cart WHERE cart_id = cartId AND item_id = itemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_clear` (IN `cartId` CHAR(32))  BEGIN
	DELETE FROM shopping_cart WHERE cart_id = cartId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_count` (IN `isLogin` TINYINT, IN `cartId` CHAR(40), IN `userId` INT)  BEGIN
	IF isLogin = 0 THEN
	SELECT COUNT(*) FROM shopping_cart WHERE cart_id = cartId AND user_id = 0 AND buy_now;
    ELSE 
    SELECT COUNT(*) FROM shopping_cart WHERE user_id = userId AND buy_now;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_products` (IN `isLogin` BOOLEAN, IN `isCart` BOOLEAN, IN `cartId` CHAR(32), IN `userId` INT)  BEGIN
IF isLogin = 0 THEN
    SELECT p.id AS product_id, p.name, p.thumb, p.price, p.stock, 		sales.price AS sale_price, c.item_id, c.cart_id, c.quantity, 		c.quantity * IFNULL(sales.price, p.price) as sub_total, 			c.attributes FROM shopping_cart c
    INNER JOIN phones AS p ON c.product_id=p.id
    LEFT OUTER JOIN sales
    ON (sales.product_id=p.id 
    AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
    OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
    WHERE c.cart_id = cartId AND c.user_id = 0 AND c.buy_now = isCart;
ELSE 
	SELECT p.id AS product_id, p.name, p.thumb, p.price, p.stock, 		sales.price AS sale_price, c.item_id, c.cart_id, c.quantity, 		c.quantity * IFNULL(sales.price, p.price) as sub_total, 			c.attributes FROM shopping_cart c
    INNER JOIN phones AS p ON c.product_id=p.id
    LEFT OUTER JOIN sales
    ON (sales.product_id=p.id 
    AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
    OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
    WHERE c.user_id = userId AND c.buy_now = isCart;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_subtotal` (IN `itemId` INT)  BEGIN
SELECT c.quantity * IFNULL(sales.price, p.price) FROM shopping_cart c INNER JOIN phones p ON c.product_id = p.id 
LEFT OUTER JOIN sales
ON (sales.product_id = p.id
AND ((NOW() BETWEEN sales.start_date AND sales.end_date)
OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
WHERE c.item_id = itemId;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_get_total_amount` (IN `cartId` VARCHAR(32))  BEGIN 
SELECT SUM(c.quantity * IFNULL(sales.price, p.price)) AS total_amount FROM shopping_cart c INNER JOIN phones AS p ON c.product_id=p.id 
LEFT OUTER JOIN sales ON (sales.product_id=p.id AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) 
WHERE  c.cart_id = cartId AND c.buy_now; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_move_product_to_cart` (IN `itemId` INT UNSIGNED)  BEGIN
	UPDATE shopping_cart SET buy_now = true, date_modified = NOW() WHERE item_id = itemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_remove_product` (IN `itemId` INT UNSIGNED)  BEGIN
DELETE FROM shopping_cart WHERE item_id = itemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_save_product_for_later` (IN `itemId` INT UNSIGNED)  BEGIN
	UPDATE shopping_cart SET buy_now = false WHERE item_id = itemId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `shopping_cart_update_product` (IN `itemId` INT UNSIGNED, IN `qty` TINYINT)  BEGIN
IF qty > 0 THEN
UPDATE shopping_cart SET quantity = qty, date_modified = NOW() WHERE
item_id = itemId;
ELSE
CALL shopping_cart_remove_product (itemId);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `transfer_cart_to_user` (IN `userId` INT UNSIGNED, IN `cartId` VARCHAR(32))  BEGIN
    UPDATE shopping_cart SET user_id = userId WHERE cart_id = cartId
    AND user_id = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_address` (IN `addressId` INT UNSIGNED, IN `userId` INT UNSIGNED, IN `fn` VARCHAR(20), IN `ln` VARCHAR(40), IN `ct` VARCHAR(60), IN `a1` VARCHAR(80), IN `a2` VARCHAR(80), IN `c` VARCHAR(60), IN `s` CHAR(2), IN `z` MEDIUMINT(5), IN `p` CHAR(10), IN `e` VARCHAR(80))  BEGIN
	UPDATE shipping_address SET first_name = fn, last_name = ln, country = ct, address1 = a1, address2 = a2, city = c, state = s, zip = z, phone = p, email = e
    WHERE id = addressId AND user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_attribute` (`id_attr` TINYINT, `name_attr` VARCHAR(20))  BEGIN
	UPDATE attribute SET name = name_attr WHERE attribute_id = id_attr;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_attr_value` (`attrValueId` TINYINT, `valueAttrValue` VARCHAR(20))  BEGIN
	UPDATE  attribute_value SET `value` = valueAttrValue  WHERE attribute_value_id = attrValueId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_category` (IN `catId` TINYINT, IN `name` VARCHAR(40), IN `des` TINYTEXT, IN `img` VARCHAR(45))  BEGIN
    UPDATE categories SET category = name, description = des, image = img WHERE id = catId;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_category_for_post` (`postId` INT UNSIGNED, `nameCat` VARCHAR(30))  BEGIN
	UPDATE post_categories SET category = nameCat WHERE id = postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_image_category` (IN `catId` INT UNSIGNED, IN `nameImg` VARCHAR(45))  BEGIN
    UPDATE categories SET image = nameImg WHERE id = catId;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_is_type_status` (`userId` INT UNSIGNED, `type` ENUM('no','yes'))  BEGIN
	UPDATE login_details 
SET is_type = type
WHERE user_id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_order` (IN `orderId` INT UNSIGNED, IN `orderStatus` TINYINT, IN `orderComment` VARCHAR(255), IN `orderAauthcode` VARCHAR(50), IN `orderReference` VARCHAR(50))  BEGIN
	DECLARE currentStatus TINYINT;
	SELECT `status` INTO  currentStatus FROM orders WHERE order_id = orderId;
    
	IF currentStatus != orderStatus AND (orderStatus = 0 OR orderStatus = 1) THEN
    UPDATE orders SET shipping_on = NULL WHERE order_id = orderId;
    
    ELSEIF currentStatus != orderStatus AND orderStatus = 2 THEN
    UPDATE orders SET shipping_on = NOW() WHERE order_id = orderId;
    END IF;    
    UPDATE orders SET `status` = orderStatus, comments = orderComment, auth_code = orderAauthcode, reference = orderReference  WHERE order_id = orderId;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_product` (IN `i` INT UNSIGNED, IN `n` VARCHAR(50), IN `d` TINYTEXT, IN `p` INT UNSIGNED, IN `t` VARCHAR(45))  BEGIN
	UPDATE phones SET name = n, description  = d, price = p, thumb = t
    WHERE id = i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_seen_message` (`fromUserId` INT UNSIGNED, `toUserId` INT UNSIGNED)  BEGIN
	UPDATE chat_message SET status = 0 WHERE from_user_id = fromUserId AND to_user_id = toUserId AND status = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_status_post` (`postId` INT UNSIGNED, `postStatus` ENUM('draft','live'))  BEGIN
	UPDATE posts SET status = postStatus WHERE id = postId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user` (IN `uId` INT UNSIGNED, IN `uAddr1` VARCHAR(100), IN `uAddr2` VARCHAR(100), IN `uCity` VARCHAR(100), IN `uState` VARCHAR(100), IN `uZip` VARCHAR(100), IN `uShippingId` TINYINT, IN `uPhone` VARCHAR(100), IN `uCountry` VARCHAR(100), IN `uName` VARCHAR(40))  BEGIN
	UPDATE users SET address1 = uAddr1, address2 = uAddr2, city = uCity, state = uState, zip = uZip, phone = uPhone, country = uCountry, shipping_region_id = uShippingId, custom_name = Uname WHERE id = uId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `access_tokens`
--

CREATE TABLE `access_tokens` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `token` char(64) NOT NULL,
  `date_expires` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(10) UNSIGNED NOT NULL,
  `year` int(11) NOT NULL,
  `purchase` int(11) NOT NULL,
  `sale` int(11) NOT NULL,
  `profit` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `year`, `purchase`, `sale`, `profit`) VALUES
(1, 2007, 550000, 800000, 250000),
(2, 2008, 678000, 1065000, 387000),
(3, 2009, 787000, 1278500, 491500),
(4, 2010, 895600, 1456000, 560400),
(5, 2011, 967150, 1675600, 708450),
(6, 2012, 1065850, 1701542, 635692);

-- --------------------------------------------------------

--
-- Table structure for table `attribute`
--

CREATE TABLE `attribute` (
  `attribute_id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(20) COLLATE utf8mb4_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `attribute`
--

INSERT INTO `attribute` (`attribute_id`, `name`) VALUES
(1, 'color'),
(2, 'storage'),
(3, 'ram');

-- --------------------------------------------------------

--
-- Table structure for table `attribute_value`
--

CREATE TABLE `attribute_value` (
  `attribute_value_id` tinyint(4) NOT NULL,
  `attribute_id` tinyint(4) NOT NULL,
  `value` varchar(20) COLLATE utf8mb4_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `attribute_value`
--

INSERT INTO `attribute_value` (`attribute_value_id`, `attribute_id`, `value`) VALUES
(1, 2, '32GB'),
(2, 2, '64GB'),
(3, 2, '128GB'),
(4, 2, '256GB'),
(5, 3, '1GB'),
(6, 3, '2GB'),
(7, 3, '4GB'),
(8, 3, '6GB'),
(9, 3, '8GB'),
(10, 3, '16GB'),
(11, 1, 'White'),
(12, 1, 'Red'),
(13, 1, 'Yellow'),
(14, 1, 'Black'),
(15, 1, 'Blue');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `parent_cat_id` int(11) NOT NULL DEFAULT 0,
  `category` varchar(40) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `description` tinytext COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `image` varchar(45) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `parent_cat_id`, `category`, `description`, `image`) VALUES
(1, 0, 'iphone', 'Description', ''),
(2, 0, 'samsung', 'Description', '7aa9a449ca7eba8fa538b880f2d55e1d018978ce.jpg'),
(3, 0, 'oppo', 'Description', 'd77c530177073f02356978f3e6a8c1911c6ec999.jpg'),
(4, 0, 'xiaomi', 'Description', '27f955348a23b18df8db34b4a79d6ef19cb1c15f.jpg'),
(5, 0, 'vivo', 'Description', '3467d7a58cf4af46e1676e6a27a0685a8454a055.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `charges`
--

CREATE TABLE `charges` (
  `id` int(10) UNSIGNED NOT NULL,
  `charge_id` varchar(60) NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(18) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `charge` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `charges_not_login`
--

CREATE TABLE `charges_not_login` (
  `id` int(10) UNSIGNED NOT NULL,
  `charge_id` varchar(60) NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(18) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `charge` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `chat_message`
--

CREATE TABLE `chat_message` (
  `chat_message_id` int(11) NOT NULL,
  `from_user_id` int(11) NOT NULL,
  `to_user_id` int(11) NOT NULL,
  `chat_message` text COLLATE utf8mb4_bin NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `parent_comment_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `comment` varchar(1000) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `trashed` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `post_id`, `parent_comment_id`, `comment`, `user_id`, `seen`, `approved`, `trashed`, `date_created`) VALUES
(3, 7, 0, 'chỉ nghe gọi thì Galaxy A51 pin 4000mAh, sử dụng cả 3 ngày đây này', 2, 0, 1, 0, '2020-11-30 12:54:26'),
(4, 2, 0, 'Sắp tới có ra màu khác không ạ?', 2, 0, 1, 0, '2020-12-01 00:04:52'),
(5, 2, 0, 'Đa nhiệm được hông ta?\r\n', 2, 0, 1, 0, '2020-12-01 00:08:54'),
(6, 2, 4, 'Chào chị,\r\nHiện tại sản phẩm này bên em kinh doanh bản Trắng kiêu hãnh, Đen kiệt xuất thôi ạ\r\nThông tin đến chị.', 1, 1, 1, 0, '2020-12-01 00:08:54'),
(7, 1, 0, 'Tôi đảm bảo với ông chủ nhân của bài viết này. Ông đưa 1 cái máy 11 pro max nào chơi liên quân trong vòng 1 tiếng mà pin chỉ tuột 6% tính từ 100% thì bao nhiêu tiền tôi cũng mua. Bóc phét vừa thôi cha nội.', 2, 0, 1, 0, '2020-12-01 00:16:55'),
(8, 1, 7, 'Chào anh !\r\nDạ bên em xin được ghi nhận lại mọi thông tin đóng góp ý kiến từ anh nha, chân thành cảm ơn anh ạ.\r\nThông tin đến anh.', 1, 1, 1, 0, '2020-12-01 00:18:13'),
(10, 4, 0, '7 tr thì ok chứ trên 9 tr thì thiếu gì bản ngon mà chơi. Hoặc dùng 1 số bản ra đời sau 1 năm còn ok hơn', 2, 0, 1, 0, '2020-12-01 00:28:58'),
(11, 4, 0, '10tr thì mua đc K30 Pro 5G còn hơn hoặc k30 Ultra dùng chip 865 vs Demensity1000+', 2, 0, 1, 0, '2020-12-01 00:29:14'),
(12, 4, 0, 'Giá vẫn cao. Con này tầm 8 triệu là ok.', 2, 0, 1, 0, '2020-12-01 00:29:22'),
(13, 4, 10, 'Quan trọng là pin 7000mah do của samsung thì độ bền của pin trên samsung thì biết rồi đó rất tốt vs lại chip 730G ... con xiaomi còn 9tr9 thì ss có 9tr3 thì quá ngon', 1, 1, 1, 0, '2020-12-01 00:30:34');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(80) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(40) NOT NULL,
  `country` varchar(60) NOT NULL,
  `address1` varchar(80) NOT NULL,
  `address2` varchar(80) DEFAULT NULL,
  `city` varchar(60) NOT NULL,
  `state` char(2) NOT NULL,
  `zip` mediumint(5) UNSIGNED ZEROFILL NOT NULL,
  `phone` char(10) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `email`, `first_name`, `last_name`, `country`, `address1`, `address2`, `city`, `state`, `zip`, `phone`, `date_created`) VALUES
(1, 'nvhr714kzb@gmail.com', 'Nguyen Van', 'Cuong', '', 'Duong 30-4', '', 'Can Tho', 'AL', 62365, '799500203', '2020-11-30 08:32:30');

-- --------------------------------------------------------

--
-- Table structure for table `discount_codes`
--

CREATE TABLE `discount_codes` (
  `voucher_code` varchar(25) CHARACTER SET utf8mb4 NOT NULL,
  `active` tinyint(1) NOT NULL,
  `min_basket_cost` int(11) NOT NULL,
  `discount_operation` enum('-','%','s') CHARACTER SET utf8mb4 NOT NULL,
  `discount_amount` int(11) NOT NULL,
  `num_vouchers` int(11) NOT NULL DEFAULT -1,
  `expiry` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `discount_codes`
--

INSERT INTO `discount_codes` (`voucher_code`, `active`, `min_basket_cost`, `discount_operation`, `discount_amount`, `num_vouchers`, `expiry`) VALUES
('COVID59OWYODULVN3NJ92020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVID7P30Q86RKSJWGNX2020', 1, 1000000, '%', 5, 8, '2021-03-30 17:00:00'),
('COVID7QOYX1QFW89QWIM2020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDB62BZ45J3H19RWX2020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDB9MHS3GXNNEWIH52020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDBSEFTIZJLDSBX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDCXMHADHZICJBF2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDDHMTMLVYZIAFD2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDDIDDXCQFXMCNQ2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDDMCRSABJFGQEM2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDECRBEFCWGRVPE2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDEHQJTFXDHABBI2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDEIZSCJZDHETSG2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDEMYCSMJARDYLP2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDFXGNAENZKXFDQ2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDGLEEXWSPOOFYB2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDGLOPAHDHZLLUD2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDGMIPGCRLTYBYK2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDHAELAS50NMJTHV42020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDHVYSNYYZZMVMS2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDHYKLETJSTMKUE2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDHYOIKICSWOXWG2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDICUBSXSWMFDCU2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDIKOZNIXEGLGYF2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDIRNLFJVEMCOCJ2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDJPEXWJJCYYXUP2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDJVNWASMBPPVHD2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDKZRWIOICFBIAY2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDLPQOTUTLFRIZS2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDNORWWRFPHGRCS2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDOCYIJMTGIZEII2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDONERODBHHXQQP2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDOYQD0E9P2CQX2IB2020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDPIGNDKWSRRHQL2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDPPQCBFDTHSDKD2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDQLMHVUVCRYQUK2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDQSGDYAODFEMQV2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDR4PV4XO5YK81UKT2020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDRGADZRCGUQQZX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDSCFJHBPPK7BC1DU2020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDSDWKMLQOUCEOW2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDSZJWREQXKTGVZ2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDTATKIXCNOTDMX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDTCXBYBENZSYOM2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDTIRUFXRMIBYEX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDTMRHWTUYVLJOS2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDTURNEEMGHBHXX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDUAOVFKXHZHSKS2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDUBOBFBVBWFRGV2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDUZBBEJLAMVLLF2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDVSHIQGKKOGTBX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDWTFAAUMBZNYGF2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDXCBPZRBHQWPEQ2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDXETCTVQIZVUSX2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDXTFUIREDNBMIH2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDYIQOREL4BT7K7372020', 1, 1000000, '%', 5, 9, '2021-03-30 17:00:00'),
('COVIDYOUWGCPKVYSWP2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDYPWCSIUVEZKXZ2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDZCPYFOQZXDCVE2021', 1, 20000000, '-', 2500000, 6, NULL),
('COVIDZMOWSQAYPEURO2021', 1, 20000000, '-', 2500000, 6, NULL),
('HTMLAIADWNDEUOXPCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLAYOTOWBWBXTSCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLBRILVNICUCLHCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLCYYBHZXWYKBACSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLDLZMOSECOLWLCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLGMCQMCYLRBNZCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLKHJXISPXUPYNCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLKHZVWJPHXSDMCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLMSLVJJBNCCAZCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLPETWUSRDCNVNCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLPSKDVAOWXDPWCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLQTPEYEZRQAJTCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('HTMLTLVLBKLUUULQCSS', 1, 5000000, '%', 10, 20, '2021-03-30 17:00:00'),
('JS0ZS4PF5NLGGA0JJPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS1PNI2OXRUC5IRN6PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS1V7NNB5EY5B5EJIPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS32CAGDJXUU5O6BMPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS35P7PEC8QUFJC6LPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS3N415FJMN1OZ12XPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS3UZYAR8HLXEE9XEPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS4DDYX7GYDCBJI6XPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS4EK7CRQJH338GZEPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS4PD3ICC7EGMNL4OPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS56WYJHJTYMT2XH6PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS5IK9UQEOTFBT78ZPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS745NSN5YQ4ZTS6NPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS8LO62EJGNT7CUD8PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS97EXVEQWXLVTPRDPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JS9N6VKOBG0YD1WKGPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSA6QVF76N0GGVHYAPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSBBIM6MFZ9LBCFJIPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSBKXI9FD94R9NRK7PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSC85R92N1CS6L61IPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSCSQA05RLRW1KLEXPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSD5Q8KS3NBWQH7RTPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSDYZ8BPEN8JGW5E8PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSFGV6LFZVL21XXZCPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSGY3S1JBMZ87C0H2PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSHAB50F4S7XG6FRZPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSJ02FE1VUPN0S50RPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSJX4SYGUSIT48JV6PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSLRG69VUATBN73F0PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSM7C1ZCQ444N23K9PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSM9GF3AJV5GB2CVWPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSNCL4S6S4QZ7KY6IPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSNT4OFHI8AES7BT3PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSPXZ80V6I6TSQMOPPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSRV3H21GCGL9AYXTPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSSS892JHRVYFT6LAPHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSUFTJ26ZHBKDULF3PHP', 0, 2000000, '-', 2000000, 5, NULL),
('JSUJRB4YM7C389QF8PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSUOV6KDRIA50LV2APHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSUXPOB9ANYASWE05PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSUYSL00815WGV46NPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSV5G0424AG26NVGKPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSVNDFOQHTVZEQSVUPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSW59EYLAF01L5B2PPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSWK9PKKYB3PKLEA1PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSX1MTA5ZHV8SY0WSPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSX4MS0O4Q7G4X3IMPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSXRSSI45X3ESCITHPHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSY064K51MR9WD3Z6PHP', 1, 2000000, '-', 2000000, 5, NULL),
('JSY9JJ25WHFY1LCVNPHP', 1, 2000000, '-', 2000000, 5, NULL),
('PHPBYKEBXOEGSQZMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPG8QZU2V7CRHTML', 1, 2000000, '%', 5, 3, NULL),
('PHPHGSKTDEWNNQAMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPIWCYGOJQAJXBMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPJCGFSANVGBVPMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPJIGEONXUNRVCMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPKKEUHGWXFNLCMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPMMNUWIKPUAMXMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPORZJAQTUKSTZMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPPSWITSKOJPHYMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPTKUALR344THTML', 1, 2000000, '%', 5, 3, NULL),
('PHPUDGHDEFXTNBSMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPUWNO24W4S6HTML', 1, 2000000, '%', 5, 3, NULL),
('PHPVHOXGFJMLSFYMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPWDLTNGYSDEHXMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPWDYJLDXJCIAMMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPWPKDUIVWHPNMMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPXJZJOHIDKPIXMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('PHPYZFVEQMPDGPTMYSQL', 1, 3000000, '-', 500000, 3, NULL),
('SALE-CLVF-QNY', 1, 1000000, '-', 500000, 6, NULL),
('SALE-CRYR-ZPX', 1, 1000000, '-', 500000, 6, NULL),
('SALE-PVCP-ALJ', 1, 1000000, '-', 500000, 6, NULL),
('SALE-TRYB-KHG', 1, 1000000, '-', 500000, 6, NULL),
('SALE-TYLM-ZMG', 1, 1000000, '-', 500000, 6, NULL),
('SALE-VTVN-EJN', 1, 1000000, '-', 500000, 6, NULL),
('SALE-WWSI-WLV', 1, 1000000, '-', 500000, 6, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `emails_get_news`
--

CREATE TABLE `emails_get_news` (
  `email` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `emails_get_news`
--

INSERT INTO `emails_get_news` (`email`) VALUES
('nguyenduchieutt77@gmail.com'),
('nvhr714kzb@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `favorite_pages`
--

CREATE TABLE `favorite_pages` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `page_id` mediumint(8) UNSIGNED NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `general_coffees`
--

CREATE TABLE `general_coffees` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `category` varchar(40) NOT NULL,
  `description` tinytext DEFAULT NULL,
  `image` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `general_coffees`
--

INSERT INTO `general_coffees` (`id`, `category`, `description`, `image`) VALUES
(1, 'Original Blend', 'Our original blend, featuring a quality mixture of\r\nbean and a medium roast for a rich color and smooth flavor.', 'original_coffee.jpg'),
(2, 'Dark Roast', 'Our darkest, non-espresso roast, with a full flavor and a\r\nslightly bitter aftertaste.', 'dark_roast.jpg'),
(3, 'Kona', 'A real treat! Kona coffee, fresh from the lush mountains of\r\nHawaii. Smooth in flavor and perfectly roasted!', 'kona.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `h_id` int(10) UNSIGNED NOT NULL,
  `h_user_id` int(10) UNSIGNED NOT NULL,
  `h_type` enum('page','pdf') DEFAULT NULL,
  `h_item_id` int(10) UNSIGNED NOT NULL,
  `h_date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `img_product`
--

CREATE TABLE `img_product` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `image` varchar(45) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `img_product`
--

INSERT INTO `img_product` (`id`, `product_id`, `image`, `date_created`) VALUES
(1, 1, 'c8925fb77eefe7e9a22bda91e0bc700443f2e0ee.png', '2020-10-31 00:07:38'),
(2, 2, '5c612c3a52d2508c9cb6abb776cc1fcac3eae5e3.png', '2020-10-31 01:56:42'),
(3, 3, 'fee08e482df00e7001dd58c131c892bef9eebe3a.png', '2020-10-31 02:14:24'),
(4, 4, '9e06e25026e7270519f3e88b4a2400d5eb155688.png', '2020-10-31 02:19:41'),
(5, 5, '874d79599bc89570e26675e19000bb232a39a617.png', '2020-10-31 02:28:41'),
(6, 6, '0853377377b8d805d4f90c10b6c73cf1ae819b12.png', '2020-10-31 02:32:31'),
(7, 7, '3aedcf7470de6171fc25c6c7b120ca4604c9ffd2.png', '2020-10-31 02:51:20'),
(8, 8, '41da8060d1c1b3a3052359e2b5f27ba146c2b7f8.png', '2020-10-31 03:38:14'),
(9, 9, 'f77c840fd0934c3ab1fc8b643a4df3a73b990a02.png', '2020-10-31 07:21:23'),
(10, 10, 'f33648d55767b4241bf554e075ecef81372e53d3.png', '2020-10-31 07:48:51'),
(11, 11, '32e1eea39627a39bb5d2b9af3d89f7a674e98873.png', '2020-10-31 08:09:14'),
(12, 12, 'acc2061148bea74cb3fa395a4766ade514da66db.png', '2020-10-31 08:09:14'),
(13, 13, '437f048cf154c770dfcc34a60740ef77c6ebacaf.png', '2020-10-31 08:20:33'),
(14, 14, '91bfd4aa0161b32848979a74ed25abdf3d50163a.png', '2020-10-31 12:42:41'),
(15, 15, '2e2479b6a892c624baa6d36c77796b538bc274c7.png', '2020-10-31 12:47:19'),
(16, 16, 'ac2397024a691ce8bd9a88d9fa0a920d90649b66.png', '2020-10-31 12:57:28'),
(17, 17, 'dc2cf47632274fba4e5f651f26c6915f3355705d.png', '2020-10-31 13:11:51'),
(18, 18, 'dfed2307faf2317f959101f8a1100d70be7842d2.png', '2020-11-02 05:50:27'),
(19, 19, '7b29e6b828d06a8891e7183e84c9068cca56c2bc.png', '2020-11-28 03:56:24');

-- --------------------------------------------------------

--
-- Table structure for table `login_details`
--

CREATE TABLE `login_details` (
  `login_detail_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_type` enum('no','yes') COLLATE utf8mb4_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `login_details`
--

INSERT INTO `login_details` (`login_detail_id`, `user_id`, `last_activity`, `is_type`) VALUES
(163, 1, '2021-02-27 08:06:05', 'no'),
(164, 1, '2021-02-27 08:14:41', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `non_coffee_categories`
--

CREATE TABLE `non_coffee_categories` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `category` varchar(40) NOT NULL,
  `description` tinytext NOT NULL,
  `image` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `non_coffee_categories`
--

INSERT INTO `non_coffee_categories` (`id`, `category`, `description`, `image`) VALUES
(1, 'Edibles', 'A wonderful assortment of goodies to eat. Includes biscotti,\r\nbaklava, lemon bars, and more!', 'goodies.jpg'),
(2, 'Gift Baskets', 'Gift baskets for any occasion! Including our many coffees\r\nand other goodies.', 'gift_basket.jpg'),
(3, 'Mugs', 'A selection of lovely mugs for enjoying your coffee, tea, hot\r\ncocoa or other hot beverages.', '781426_32573620.jpg'),
(4, 'Books', 'Our recommended books about coffee, goodies, plus anything\r\nwritten by Larry Ullman!', 'books.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `non_coffee_products`
--

CREATE TABLE `non_coffee_products` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `non_coffee_category_id` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(60) NOT NULL,
  `description` tinytext DEFAULT NULL,
  `image` varchar(45) NOT NULL,
  `price` decimal(5,2) UNSIGNED NOT NULL,
  `stock` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `non_coffee_products`
--

INSERT INTO `non_coffee_products` (`id`, `non_coffee_category_id`, `name`, `description`, `image`, `price`, `stock`, `date_created`) VALUES
(1, 3, 'Pretty Flower Coffee Mug', 'A pretty coffee mug with a flower design on a\r\nwhite background.', 'd9996aee5639209b3fb618b07e10a34b27baad12.jpg', 6.50, 6, '2020-07-02 15:58:06'),
(2, 3, 'Red Dragon Mug', 'An elaborate, painted gold dragon on\r\na red background. With partially detached, fancy handle.', '847a1a3bef0fb5c2f2299b06dd63669000f5c6c4.jpg', 7.95, 11, '2020-07-02 15:58:06');

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE `notes` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `page_id` int(10) UNSIGNED NOT NULL,
  `note` text NOT NULL,
  `date_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `notes`
--

INSERT INTO `notes` (`user_id`, `page_id`, `note`, `date_updated`) VALUES
(8, 4, 'huy', '2020-10-09 16:51:44');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `total` int(10) UNSIGNED DEFAULT NULL,
  `status` tinyint(1) UNSIGNED DEFAULT 0,
  `shipping` int(10) UNSIGNED DEFAULT 0,
  `discount_price` int(11) NOT NULL DEFAULT 0,
  `discount_code` varchar(25) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `credit_card_number` mediumint(4) UNSIGNED ZEROFILL NOT NULL,
  `first_name` varchar(20) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `last_name` varchar(40) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `country` varchar(60) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `address1` varchar(80) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `address2` varchar(80) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `city` varchar(60) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `state` char(2) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `zip` mediumint(5) UNSIGNED ZEROFILL NOT NULL,
  `phone` char(10) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `email` varchar(80) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `comments` varchar(255) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `ship_date` timestamp NULL DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders_not_login`
--

CREATE TABLE `orders_not_login` (
  `order_id` int(10) UNSIGNED NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `total` int(10) UNSIGNED DEFAULT NULL,
  `shipping` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `discount_price` int(11) NOT NULL DEFAULT 0,
  `discount_code` varchar(25) DEFAULT NULL,
  `credit_card_number` mediumint(4) UNSIGNED ZEROFILL NOT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `ship_date` date DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `order_contents`
--

CREATE TABLE `order_contents` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `attributes` varchar(50) COLLATE utf8mb4_vietnamese_ci DEFAULT NULL,
  `quantity` tinyint(3) UNSIGNED NOT NULL,
  `price` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_contents_not_login`
--

CREATE TABLE `order_contents_not_login` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `attributes` varchar(50) NOT NULL,
  `quantity` tinyint(3) UNSIGNED NOT NULL,
  `price` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pdfs`
--

CREATE TABLE `pdfs` (
  `id` int(10) UNSIGNED NOT NULL,
  `tmp_name` char(40) NOT NULL,
  `file_name` varchar(40) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` tinytext NOT NULL,
  `size` mediumint(9) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `phones`
--

CREATE TABLE `phones` (
  `id` int(10) UNSIGNED NOT NULL,
  `brand_id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `description` tinytext CHARACTER SET utf8mb4 DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `thumb` varchar(45) DEFAULT NULL,
  `stock` mediumint(9) DEFAULT NULL,
  `promotion_id` tinyint(4) DEFAULT 0,
  `video` varchar(45) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `screen` varchar(100) DEFAULT NULL,
  `os` varchar(100) DEFAULT NULL,
  `camera_back` varchar(100) DEFAULT NULL,
  `camera_front` varchar(100) DEFAULT NULL,
  `cpu` varchar(50) NOT NULL,
  `sim` varchar(50) NOT NULL,
  `battery` varchar(50) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_featured` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `phones`
--

INSERT INTO `phones` (`id`, `brand_id`, `name`, `description`, `content`, `thumb`, `stock`, `promotion_id`, `video`, `price`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`, `battery`, `date_created`, `is_featured`) VALUES
(1, 0, 'Điện thoại iPhone 11 Pro Max 64GB', 'dien', '<h2>Trong năm 2019 thì chiếc smartphone được nhiều người mong muốn sở hữu trên tay và sử dụng nhất không ai khác chính là iPhone 11 Pro Max 64GB tới từ nhà Apple.</h2>\r\n\r\n<h3 dir=\"ltr\">Camera được cải tiến mạnh mẽ</h3>\r\n\r\n<p dir=\"ltr\">Chắc chắn l&yacute; do lớn nhất m&agrave; bạn muốn n&acirc;ng cấp l&ecirc;n iPhone 11 Pro Max ch&iacute;nh l&agrave; cụm camera mới được Apple n&acirc;ng cấp rất nhiều.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd14-1.jpg\" onclick=\"return false;\"><img alt=\"iPhone 11 Pro Max 64GB | Cụm ba camera sau ấn tượng\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd14-1.jpg\" title=\"iPhone 11 Pro Max 64GB | Cụm ba camera sau ấn tượng\" /></a></p>\r\n\r\n<p dir=\"ltr\">Lần đầu ti&ecirc;n ch&uacute;ng ta sẽ c&oacute; một chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo iPhone chính hãng\">iPhone</a>&nbsp;với 3 camera ở mặt sau v&agrave; cả 3 camera n&agrave;y đều c&oacute; độ ph&acirc;n giải l&agrave; 12 MP.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd6-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện chụp ảnh camera\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd6-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện chụp ảnh camera\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ch&uacute;ng ta sẽ c&oacute; một camera g&oacute;c thường, một camera g&oacute;c rộng v&agrave; một camera tele đ&aacute;p ứng đầy đủ nhu cầu chụp ảnh h&agrave;ng ng&agrave;y của người d&ugrave;ng.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd9-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp chân dung bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd9-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp chân dung bằng camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp bằng camera sau tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">Một cải tiến nữa cũng rất đ&aacute;ng ch&uacute; &yacute; ch&iacute;nh l&agrave;&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/night-mode-la-gi-diem-khac-nhau-giu-night-mode-va-1197122\" target=\"_blank\" title=\"Tìm hiểu chế độ Night Mode\" type=\"Tìm hiểu chế độ Night Mode\">chế độ Night Mode</a>&nbsp;mới sẽ gi&uacute;p bạn cải thiện rất nhiều chất lượng ảnh chụp đ&ecirc;m tr&ecirc;n iPhone.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd15-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd15-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp bằng camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp bằng camera sau tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">T&ugrave;y thuộc v&agrave;o điều kiện m&ocirc;i trường bạn chụp m&agrave; iPhone sẽ đưa ra những th&ocirc;ng số ph&ugrave; hợp để bạn c&oacute; thể c&oacute; cho m&igrave;nh được một bức ảnh ưng &yacute; nhất.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd12.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Chế độ Night Mode mới\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd12.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Chế độ Night Mode mới\" /></a></p>\r\n\r\n<p dir=\"ltr\">Chế độ Night Mode mới</p>\r\n\r\n<p dir=\"ltr\">Chế độ ch&acirc;n dung kh&ocirc;ng chỉ tốt hơn trong việc lấy n&eacute;t v&agrave;o đối tượng muốn chụp, m&agrave; c&ograve;n hoạt động được ở khoảng c&aacute;ch &#39;b&igrave;nh thường&#39; nhờ sự trợ gi&uacute;p của cảm biến độ s&acirc;u.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd7-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp bằng chế độ Night Mode\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd7-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp bằng chế độ Night Mode\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp với chế độ Night Mode tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">So với người anh em&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xs-max\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone Xs Max chính hãng\" type=\"Tham khảo giá điện thoại iPhone Xs Max chính hãng\">iPhone Xs Max</a>&nbsp;th&igrave; với việc được t&iacute;ch hợp th&ecirc;m một camera g&oacute;c rộng người d&ugrave;ng iPhone giờ đ&acirc;y sẽ c&oacute; được cho m&igrave;nh những khung h&igrave;nh độc đ&aacute;o hơn.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd8-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp chế độ thường bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd8-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp chế độ thường bằng camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp chế độ cơ bản b&igrave;nh thường với camera ch&iacute;nh</p>\r\n\r\n<p dir=\"ltr\">Bạn muốn chụp một t&ograve;a nh&agrave; cao tầng, bạn muốn ghi lại khung cảnh thi&ecirc;n nhi&ecirc;n h&ugrave;ng vĩ m&agrave; m&igrave;nh nh&igrave;n thấy th&igrave; camera&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại hỗ trợ chụp góc rộng\" type=\"Tham khảo các dòng điện thoại hỗ trợ chụp góc rộng\">g&oacute;c si&ecirc;u rộng</a>&nbsp;sẽ l&agrave;m rất tốt trong những điều kiện n&agrave;y.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd16-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp ngược sáng với HDR\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd16-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp ngược sáng với HDR\" /></a></p>\r\n\r\n<h3 dir=\"ltr\">Camera trước cũng mang lại sự kh&aacute;c biệt</h3>\r\n\r\n<p dir=\"ltr\">Kh&ocirc;ng chỉ c&oacute; camera ch&iacute;nh m&agrave; camera selfie tr&ecirc;n iPhone 11 Pro Max cũng được cải thiện rất nhiều.</p>\r\n\r\n<p dir=\"ltr\">Đầu ti&ecirc;n ch&uacute;ng ta c&oacute; thể kể tới l&agrave; độ ph&acirc;n giải giờ đ&acirc;y đ&atilde; được n&acirc;ng l&ecirc;n th&agrave;nh 12 MP thay v&igrave; 7 MP như tr&ecirc;n thế hệ trước.</p>\r\n\r\n<p dir=\"ltr\">Tiếp theo ch&uacute;ng ta sẽ c&oacute; c&ocirc;ng nghệ quay video độ ph&acirc;n giải 4K ngay tr&ecirc;n camera trước một điều m&agrave; những chiếc iPhone trước đ&acirc;y chưa thể l&agrave;m được.</p>\r\n\r\n<p dir=\"ltr\">Ngo&agrave;i ra bạn cũng c&oacute; thể d&ugrave;ng camera trước để quay video slow motion (quay chậm) gi&uacute;p bạn c&oacute; được những video&nbsp; th&uacute; vị v&agrave; vui vẻ với bạn b&egrave;.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd6.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện chụp ảnh chế độ zoom quang học\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd6.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện chụp ảnh chế độ zoom quang học\" /></a></p>\r\n\r\n<p dir=\"ltr\">Một t&iacute;nh năng mới cũng được Apple t&iacute;ch hợp tr&ecirc;n iPhone mới đ&oacute; ch&iacute;nh l&agrave; khả năng tự động nhận diện để thay đổi g&oacute;c chụp gi&uacute;p bạn lấy được nhiều chi tiết hơn.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max.gif\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp chế độ slofie\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max.gif\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Ảnh chụp chế độ slofie\" /></a></p>\r\n\r\n<p dir=\"ltr\">V&iacute; dụ khi bạn để điện thoại ở chế độ chụp dọc th&igrave; m&aacute;y sẽ chụp ở g&oacute;c b&igrave;nh thường, c&ograve;n khi bạn xoay điện thoại nằm ngang th&igrave; m&aacute;y tự động sẽ điều chỉnh để bạn c&oacute; được một g&oacute;c chụp rộng hơn.</p>\r\n\r\n<p dir=\"ltr\">Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia-chi-tiet-iphone-11-pro-max-1199526\" target=\"_blank\" title=\"Đánh giá chi tiết iPhone 11 Pro Max\" type=\"Đánh giá chi tiết iPhone 11 Pro Max\">Đ&aacute;nh gi&aacute; chi tiết iPhone 11 Pro Max: Chiếc smartphone đỉnh nhất 2019?</a></p>\r\n\r\n<h3 dir=\"ltr\">Hiệu năng &quot;đ&egrave; bẹp&quot; mọi đối thủ</h3>\r\n\r\n<p dir=\"ltr\">Mỗi năm ra mắt iPhone mới th&igrave; Apple lại n&acirc;ng cấp con chip của m&igrave;nh để m&aacute;y c&oacute; thể đạt được một hiệu năng tốt nhất v&agrave; với iPhone 11 Pro Max năm nay cũng kh&ocirc;ng phải l&agrave; một ngoại lệ.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-14.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện màn hình chính\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-14.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện màn hình chính\" /></a></p>\r\n\r\n<p dir=\"ltr\">Chiếc iPhone mới n&agrave;y chạy tr&ecirc;n con chip&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-ve-chip-apple-a13-bionic-tren-iphone-11-n-1197492\" target=\"_blank\" title=\"Tham khảo thêm về chip Apple A13 Bionic\">Apple A13 Bionic</a>, con chip mạnh mẽ nhất d&agrave;nh cho những chiếc iPhone trong năm 2019 gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;dễ d&agrave;ng với mọi thể loại game nặng nhẹ ở mức cấu h&igrave;nh max setting.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-21.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Điểm hiệu năng Antutu Benchmark\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-21.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Điểm hiệu năng Antutu Benchmark\" /></a></p>\r\n\r\n<p dir=\"ltr\">B&ecirc;n cạnh đ&oacute; bạn vẫn sẽ c&oacute; cho m&igrave;nh 4 GB RAM v&agrave; 64 GB bộ nhớ trong thoải m&aacute;i cho bạn c&agrave;i đặt game v&agrave; ứng dụng.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Trải nghiệm chơi game\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-2.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Trải nghiệm chơi game\" /></a></p>\r\n\r\n<p dir=\"ltr\">Tất nhi&ecirc;n m&aacute;y cũng sẽ chạy tr&ecirc;n phi&ecirc;n bản&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tat-ca-nhung-tinh-nang-moi-duoc-cap-nhat-tren-ios-1171206\" target=\"_blank\" title=\"Tìm hiểu những tính năng mới trên iOS 13\" type=\"Tìm hiểu những tính năng mới trên iOS 13\">iOS 13</a>&nbsp;mới nhất với nhiều cải tiến gi&uacute;p tối ưu h&oacute;a hiệu năng đem lại trải nghiệm mượt m&agrave; hơn cho người d&ugrave;ng.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd8.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện iOS 13 mới\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd8.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Giao diện iOS 13 mới\" /></a></p>\r\n\r\n<p dir=\"ltr\">Những t&iacute;nh năng tr&ecirc;n iOS 13 mới</p>\r\n\r\n<p dir=\"ltr\">Mọi game v&agrave; ứng dụng tr&ecirc;n iPhone 11 Pro Max hoạt động rất mượt m&agrave; v&agrave; ổn định, bạn hầu như sẽ kh&ocirc;ng thấy bất cứ độ trễ n&agrave;o trong qu&aacute; tr&igrave;nh sử dụng.</p>\r\n\r\n<p dir=\"ltr\">Năm nay Face ID cũng được cải thiện để c&oacute; thể nhận dạng ở nhiều g&oacute;c kh&aacute;c nhau mang lại trải nghiệm mở kh&oacute;a tốt hơn.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd17.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Công nghệ Haptic Engine mới \" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd17.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Công nghệ Haptic Engine mới \" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ocirc;ng nghệ Haptic Engine mới sẽ dựa tr&ecirc;n thời gian ấn v&agrave; giữ icon để hiện l&ecirc;n những menu chức năng kh&aacute;c nhau thay v&igrave; dựa v&agrave;o lực ấn như 3D Touch.</p>\r\n\r\n<h3 dir=\"ltr\">Dung lượng pin &#39;tr&acirc;u&#39;</h3>\r\n\r\n<p dir=\"ltr\">Apple đ&atilde; tuy&ecirc;n bố rằng iPhone 11 Pro Max c&oacute; thời lượng pin l&acirc;u hơn 5 giờ so với iPhone Xs&nbsp;Max.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-7.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Thời lượng pin tốt\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-7.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Thời lượng pin tốt\" /></a></p>\r\n\r\n<p dir=\"ltr\">V&agrave; nếu bạn chưa biết th&igrave; iPhone 11 Pro Max l&agrave; chiếc iPhone c&oacute; dung lượng pin lớn nhất từ trước tới nay m&agrave; Apple từng sản xuất.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd9.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Thời lượng sử dụng pin trên iOS 13\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd9.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Thời lượng sử dụng pin trên iOS 13\" /></a></p>\r\n\r\n<p dir=\"ltr\">Bạn c&oacute; thể sử dụng m&aacute;y thoải m&aacute;i từ s&aacute;ng tới tối m&agrave; kh&ocirc;ng cần phải bận t&acirc;m về việc nạp năng lượng cho m&aacute;y giữa chừng.</p>\r\n\r\n<p dir=\"ltr\">Tin vui l&agrave; năm nay Apple đ&atilde; trang bị củ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\">sạc nhanh</a>&nbsp;18W đi k&egrave;m b&ecirc;n trong hộp của chiếc iPhone mới n&agrave;y.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd1-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Cổng sạc trên máy\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd1-2.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Cổng sạc trên máy\" /></a></p>\r\n\r\n<p dir=\"ltr\">Tất nhi&ecirc;n bạn vẫn sẽ c&oacute; c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-khong-day\" target=\"_blank\" title=\"Tham khảo điện thoại sạc không dây tại Thế Giới Di Động\">sạc kh&ocirc;ng d&acirc;y</a>&nbsp;v&agrave; thậm ch&iacute; l&agrave; sạc nhanh kh&ocirc;ng d&acirc;y để bạn c&oacute; thể sử dụng h&agrave;ng ng&agrave;y.</p>\r\n\r\n<h3 dir=\"ltr\">Những thay đổi về thiết kế v&agrave; m&agrave;n h&igrave;nh</h3>\r\n\r\n<p dir=\"ltr\">Để ph&acirc;n biệt iPhone 11 Pro Max v&agrave; iPhone Xs Max th&igrave; bạn bắt buộc phải nh&igrave;n v&agrave;o mặt lưng nơi sẽ c&oacute; cụm camera to bản hơn cũng như phần k&iacute;nh được ho&agrave;n thiện k&iacute;nh mờ thay v&igrave; b&oacute;ng như tr&ecirc;n thế trước.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-17.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Thiết kế mặt lưng nổi bật cụm camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-17.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Thiết kế mặt lưng nổi bật cụm camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Thiết kế mới n&agrave;y của Apple gi&uacute;p hạn chế mồ h&ocirc;i v&agrave; bụi bẩn b&aacute;m lại sau qu&aacute; tr&igrave;nh sử dụng, gi&uacute;p thiết bị lu&ocirc;n lu&ocirc;n c&oacute; được sự sang trọng v&agrave; b&oacute;ng bẩy.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd4-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Khay sim\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd4-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Khay sim\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ngo&agrave;i ra logo Apple quen thuộc năm nay đ&atilde; được đặt ở ch&iacute;nh giữa mặt lưng thay v&igrave; đặt lệch về ph&iacute;a cạnh tr&ecirc;n như những chiếc iPhone trước đ&oacute;.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd3-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Thiết kế viền màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd3-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Thiết kế viền màn hình\" /></a></p>\r\n\r\n<p dir=\"ltr\">Một trong những điểm quan trọng được n&acirc;ng cấp trong m&agrave;n h&igrave;nh của iPhone mới đ&oacute; l&agrave; khả năng ph&aacute;t nội dung Dolby Vision.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd5-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Trải nghiệm xem phim\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd5-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Trải nghiệm xem phim\" /></a></p>\r\n\r\n<p dir=\"ltr\">Nhờ đ&oacute;, trải nghiệm xem phim sẽ cho h&igrave;nh ảnh chi tiết hơn v&agrave; mang đến những thước phim điện ảnh hơn nhiều.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-tgdd12-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-tgdd12-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Màn hình\" /></a></p>\r\n\r\n<p dir=\"ltr\">iPhone thường đạt được độ s&aacute;ng 800 nits, nhưng với Dolby Vision mọi thứ thậm ch&iacute; c&ograve;n ấn tượng hơn (l&ecirc;n tới 1200 nits, theo Apple).</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/200533/iphone-11-pro-max-16.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 64GB | Khả năng hiển thị màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/200533/iphone-11-pro-max-16.jpg\" title=\"Điện thoại iPhone 11 Pro Max 64GB | Khả năng hiển thị màn hình\" /></a></p>\r\n\r\n<p dir=\"ltr\">Với những n&acirc;ng cấp kh&aacute; nhiều đặc biệt l&agrave; về mặt camera v&agrave; hiệu năng th&igrave; iPhone 11 Pro Max năm nay hứa hẹn sẽ lại đem về th&agrave;nh c&ocirc;ng lớn cho Apple.</p>\r\n', 'b88f15b0ab5b4fd0253e5186b5c7d12814b32ac2.jpg', 10, 1, NULL, 30990000, 'OLED, 6.5\", Super Retina XDR', 'iOS 13', '3 camera 12 MP ', '12 MP', 'Apple A13 Bionic 6 nhân', '1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '3969 mAh, có sạc nhanh', '2020-10-31 00:07:38', 1),
(2, 0, 'Điện thoại Samsung Galaxy M51', 'Description\r\n', '<h2><a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Tham khảo thêm về các dòng điện thoại Samsung trên thegioididong.com\" type=\"Tham khảo thêm về các dòng điện thoại Samsung trên thegioididong.com\">Samsung</a>&nbsp;lại tiếp tục cho ra mắt chiếc smartphone mới thuộc thế hệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-samsung-galaxy-m\" target=\"_blank\" title=\"Tham khảo thêm các điện thoại dòng Galaxy M tại thegioididong.com\" type=\"Tham khảo thêm các điện thoại dòng Galaxy M tại thegioididong.com\">Galaxy M</a>&nbsp;với t&ecirc;n gọi l&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-m51\" title=\"Tham khảo giá bán điện thoại Samsung Galaxy M51 bán tại thegioididong.com\">Samsung&nbsp;Galaxy M51</a>. Thiết kế mới n&agrave;y tuy nằm trong ph&acirc;n kh&uacute;c tầm trung nhưng được Samsung n&acirc;ng cấp v&agrave; cải tiến với camera g&oacute;c si&ecirc;u rộng, dung lượng pin si&ecirc;u khủng c&ugrave;ng vẻ ngo&agrave;i sang trọng v&agrave; thời thượng.</h2>\r\n\r\n<h3>Thiết kế hiện đại v&agrave; đẳng cấp.</h3>\r\n\r\n<p>Ấn tượng ban đầu với&nbsp;<a href=\"https://www.thegioididong.com/dtdd-tu-6-inch\" target=\"_blank\" title=\"Tham khảo thêm các dòng smartphone có kích thước màn hình từ 6 inch trở lên tại thegioididong.com\" type=\"Tham khảo thêm các dòng smartphone có kích thước màn hình từ 6 inch trở lên tại thegioididong.com\">m&agrave;n h&igrave;nh</a>&nbsp;của Galaxy M51 l&agrave; kiểu m&agrave;n h&igrave;nh Infinity-O rộng 6.7 inch. Kiểu thiết kế n&agrave;y đưa camera selfie thu gọn hơn chỉ bằng một h&igrave;nh tr&ograve;n nhỏ c&ugrave;ng thiết kế&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-tran-vien\" target=\"_blank\" title=\"Tham khảo thêm các dòng smartphone có màn hình tràn viền tại thegioididong.com\" type=\"Tham khảo thêm các dòng smartphone có màn hình tràn viền tại thegioididong.com\">m&agrave;n h&igrave;nh tr&agrave;n viền</a>&nbsp;l&agrave;m tăng khả năng hiển thị h&igrave;nh ảnh hơn.</p>\r\n\r\n<p>Ngo&agrave;i ra, m&aacute;y c&ograve;n sở hữu c&ocirc;ng nghệ m&agrave;n h&igrave;nh Super AMOLED Plus&nbsp;mang đến chất lượng hiển thị sắc n&eacute;t, h&igrave;nh ảnh tươi tắn cho bạn tận hưởng c&aacute;c chương tr&igrave;nh giải tr&iacute; hấp dẫn, thưởng thức c&aacute;c bộ phim bom tấn, chơi những tựa game y&ecirc;u th&iacute;ch v&ocirc; c&ugrave;ng bắt mắt.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-274020-094023.jpg\" onclick=\"return false;\"><img alt=\"Sở hữu màn hình tràn viền với độ phân giải cao | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-274020-094023.jpg\" title=\"Sở hữu màn hình tràn viền với độ phân giải cao | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Mặt lưng của m&aacute;y được thiết kế m&agrave;u gradient, chất liệu vỏ l&agrave;m bằng nhựa n&ecirc;n m&aacute;y rất nhẹ chỉ c&oacute; trọng lượng 213 g v&agrave; với độ mỏng 9.5 mm. B&ecirc;n cạnh đ&oacute;, c&aacute;c cạnh của m&aacute;y bo cong &ocirc;m s&aacute;t phần khung viền mang lại cảm gi&aacute;c vừa chắc chắn m&agrave; rất nhẹ nh&agrave;ng khi cầm nắm tr&ecirc;n tay.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-274020-094029.jpg\" onclick=\"return false;\"><img alt=\"Thiết kê mặt lưng bóng bẩy, sang trọng | Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-274020-094029.jpg\" title=\"Thiết kê mặt lưng bóng bẩy, sang trọng | Galaxy M51\" /></a></p>\r\n\r\n<h3>Camera đột ph&aacute; th&aacute;ch thức mọi g&oacute;c độ</h3>\r\n\r\n<p>Tuy l&agrave; chiếc điện thoại nằm trong ph&acirc;n kh&uacute;c tầm trung nhưng lại sở hữu tới 4 camera sau với độ ph&acirc;n giải cực k&igrave; ấn tượng. Camera cảm biến ch&iacute;nh với độ ph&acirc;n giải l&ecirc;n đến 64 MP mang đến những bức ảnh cực kỳ r&otilde; n&eacute;t ngay cả trong điều kiện thiếu s&aacute;ng.&nbsp;</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-274020-094041.jpg\" onclick=\"return false;\"><img alt=\"Sở hữu 4 camera sau với độ phân giải cực kì ấn tượng | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-274020-094041.jpg\" title=\"Sở hữu 4 camera sau với độ phân giải cực kì ấn tượng | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Kế đến l&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có camera góc siêu rộng tại thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có camera góc siêu rộng tại thegioididong.com\">camera g&oacute;c si&ecirc;u rộng</a>&nbsp;(Ultra wide) với độ ph&acirc;n giải 12 MP kết hợp c&ugrave;ng camera ch&iacute;nh 64 MP cho khả năng chụp bao qu&aacute;t l&ecirc;n tới 123 độ, h&igrave;nh ảnh sắc n&eacute;t. Những khung cảnh n&uacute;i rừng h&ugrave;ng vĩ giờ đ&acirc;y c&oacute; thể g&oacute;i gọn trong chiếc camera của Samsung Galaxy M51.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-272420-102407.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp góc siêu rộng từ camera | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-272420-102407.jpg\" title=\"Ảnh chụp góc siêu rộng từ camera | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh những bức ảnh g&oacute;c rộng, m&aacute;y c&ograve;n c&oacute; khả năng chụp cận cảnh với những chi tiết nhỏ v&agrave; hỗ trợ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-xoa-phong\" target=\"_blank\" title=\"Tham khảo thêm các dòng smartphone có camera chụp hình xoá phông tại thegioididong.com\" type=\"Tham khảo thêm các dòng smartphone có camera chụp hình xoá phông tại thegioididong.com\">xo&aacute; ph&ocirc;ng</a>&nbsp;lấy độ s&acirc;u trường ảnh với hai camera bao gồm&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-macro\" target=\"_blank\" title=\"Tham khảo thêm các mẫu smartphone có camera macro chụp cận cảnh tại thegioididong.com\" type=\"Tham khảo thêm các mẫu smartphone có camera macro chụp cận cảnh tại thegioididong.com\">camera macro</a>&nbsp;chụp cận cảnh với độ ph&acirc;n giải l&agrave; 5 MP v&agrave;&nbsp;camera đo chiều s&acirc;u c&oacute; độ ph&acirc;n giải 5 MP.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-272420-102412.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp cận cảnh macro từ camera | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-272420-102412.jpg\" title=\"Ảnh chụp cận cảnh macro từ camera | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Ngo&agrave;i việc mang đến những bức ảnh đầy ấn tượng, bộ tứ camera của Galaxy M51 cũng mang đến chất lượng quay video 4K cực k&igrave; sắc n&eacute;t, m&agrave;u sắc sống động sẽ lưu giữ được những khoảnh khắc kỉ niệm đ&aacute;ng nhớ.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-800-533-7.jpg\" onclick=\"return false;\"><img alt=\"Chất lượng quay video 4K cực kì sắc nét từ camera | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-800-533-7.jpg\" title=\"Chất lượng quay video 4K cực kì sắc nét từ camera | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Camera selfie của Galaxy M51 cũng kh&ocirc;ng k&eacute;m phần chất lượng khi sở hữu độ ph&acirc;n giải tới 32 MP, với t&iacute;nh năng chụp ảnh HDR, tự l&agrave;m đẹp khu&ocirc;n mặt gi&uacute;p những bức ảnh ch&acirc;n dung hoặc những tấm ảnh chụp ngo&agrave;i trời cho chất lượng tốt hơn, r&otilde; n&eacute;t hơn gi&uacute;p bạn tự tin toả s&aacute;ng trong mọi khung h&igrave;nh.</p>\r\n\r\n<p>Ngo&agrave;i ra t&iacute;nh năng lựa chọn g&oacute;c selfie th&ocirc;ng minh, m&aacute;y sẽ tự động chuyển sang chế độ chụp g&oacute;c rộng khi selfie với nh&oacute;m bạn mang mọi người gắn kết với nhau hơn qua từng khoảnh khắc selfie.&nbsp;Về khả năng quay video, camera selfie c&ograve;n c&oacute; khả năng quay video cho chất lượng h&igrave;nh ảnh Full HD.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-800-533-8.jpg\" onclick=\"return false;\"><img alt=\"Camera selfie với độ phân giải lên đến 32 MP | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-800-533-8.jpg\" title=\"Camera selfie với độ phân giải lên đến 32 MP | Samsung Galaxy M51\" /></a></p>\r\n\r\n<h3>Pin si&ecirc;u khủng, sử dụng thoải m&aacute;i cả ng&agrave;y lẫn đ&ecirc;m</h3>\r\n\r\n<p>Được n&acirc;ng cấp vi&ecirc;n pin khủng l&ecirc;n đến 7000 mAh xứng đ&aacute;ng l&agrave; chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-pin-khung\" target=\"_blank\" title=\"Tham khảo thêm các dòng smartphone có dung lượng pin trên 5000 mAh tại thegioididong.com\" type=\"Tham khảo thêm các dòng smartphone có dung lượng pin trên 5000 mAh tại thegioididong.com\">điện thoại pin tr&acirc;u</a>&nbsp;nhất trong ph&acirc;n kh&uacute;c&nbsp;<a href=\"https://www.thegioididong.com/dtdd?p=tu-4-7-trieu\" target=\"_blank\" title=\"Tham khảo thêm các dòng điện thoại tầm trung kinh doanh tại thegioididong.com\" type=\"Tham khảo thêm các dòng điện thoại tầm trung kinh doanh tại thegioididong.com\">điện thoại tầm trung</a>&nbsp;mang đến cho bạn cả ng&agrave;y d&agrave;i sử dụng kết hợp c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có công nghệ sạc pin nhanh tại thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có công nghệ sạc pin nhanh tại thegioididong.com\">sạc pin nhanh</a>&nbsp;25 W gi&uacute;p bạn nạp lại pin cho m&aacute;y rất nhanh v&agrave; hiệu quả.</p>\r\n\r\n<p>Với lượng pin được sạc đầy 100% bạn sẽ c&oacute; thể đ&agrave;m thoại li&ecirc;n tục 64 giờ, sử dụng internet, xem video l&ecirc;n đến 24 giờ hoặc nghe nhạc li&ecirc;n tục trong khoảng 182 giờ. Giờ đ&acirc;y, bạn sẽ kh&ocirc;ng phải lo lắng về việc sạc pin trước hay mang theo cục sạc dự ph&ograve;ng khi rời khỏi nh&agrave;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-800-533-9.jpg\" onclick=\"return false;\"><img alt=\"Dung lượng pin khủng cùng công nghệ sạc nhanh | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-800-533-9.jpg\" title=\"Dung lượng pin khủng cùng công nghệ sạc nhanh | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Tuyệt vời hơn, Galaxy M51 c&ograve;n c&oacute; t&iacute;nh năng reverse charging, nghĩa l&agrave; Galaxy M51 cũng c&oacute; thể biến th&agrave;nh một cục sạc dự ph&ograve;ng đa năng nếu như một chiếc điện thoại kh&aacute;c của bạn cần được sạc pin.&nbsp;</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-800-533-10.jpg\" onclick=\"return false;\"><img alt=\"Tính năng reverse charging mới | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-800-533-10.jpg\" title=\"Tính năng reverse charging mới | Samsung Galaxy M51\" /></a></p>\r\n\r\n<h3>Hiệu năng mạnh mẽ vượt trội</h3>\r\n\r\n<p>Galaxy M51 sở hữu con chip&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-chip-qualcomm-snapdragon-730-1174819\" target=\"_blank\" title=\"Tìm hiểu chip Qualcomm Snapdragon 730 tại website thegioididong.com\" type=\"Tìm hiểu chip Qualcomm Snapdragon 730 tại website thegioididong.com\">Snapdragon 730 8 nh&acirc;n của Qualcomm</a>&nbsp;với&nbsp;<a href=\"https://www.thegioididong.com/dtdd-ram-8gb-tro-len\" target=\"_blank\" title=\"Tham khảo thêm các dòng smartphone có dung lượng RAM 8GB trở lên tại thegioididong.com\">RAM&nbsp;8 GB</a>, tốc độ xử l&yacute; l&ecirc;n tới 2.2 GHz gi&uacute;p bạn tiết kiệm điện năng cho m&aacute;y đồng thời tăng tốc độ phản hồi cho bạn trải nghiệm mượt m&agrave; hơn khi d&ugrave;ng nhiều t&aacute;c vụ c&ugrave;ng l&uacute;c.</p>\r\n\r\n<p>Samsung Galaxy M51&nbsp;c&ograve;n sở hữu bộ nhớ trong với&nbsp;<a href=\"https://www.thegioididong.com/dtdd-rom-128-den-256gb\" target=\"_blank\" title=\"Tham khảo thêm các dòng smartphone có bộ nhớ trong từ 128GB đến 256GB tại thegioididong.com\" type=\"Tham khảo thêm các dòng smartphone có bộ nhớ trong từ 128GB đến 256GB tại thegioididong.com\">dung lượng 128 GB</a>,&nbsp;cho kh&ocirc;ng gian lưu trữ rộng lớn hơn, thoải m&aacute;i hơn khi lưu phim ảnh, video, game...</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-271120-101154.jpg\" onclick=\"return false;\"><img alt=\"Sở hữu con chip Snapdragon 730 8 nhân | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-271120-101154.jpg\" title=\"Sở hữu con chip Snapdragon 730 8 nhân | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Chip đồ hoạ Adreno 618 gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;th&ecirc;m t&iacute;nh ch&acirc;n thực với đồ họa phong ph&uacute; hơn, xử l&yacute; chất lượng h&igrave;nh ảnh v&agrave; chơi tr&ograve; chơi HDR với nhiều sắc th&aacute;i m&agrave;u.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-274020-094053.jpg\" onclick=\"return false;\"><img alt=\"Hỗ trợ thẻ nhớ ngoài | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-274020-094053.jpg\" title=\"Hỗ trợ thẻ nhớ ngoài | Samsung Galaxy M51\" /></a></p>\r\n\r\n<h3>Linh hoạt hơn với hai hệ thống bảo mật</h3>\r\n\r\n<p>Bạn c&oacute; thể ho&agrave;n to&agrave;n an t&acirc;m khi sử dụng Samsung Galaxy M51 bởi chiếc điện thoại n&agrave;y được trang bị đến 2 hệ thống bảo mật bao gồm&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo thêm các dòng điện thoại cảm biến vân tay tại thegioididong.com\" type=\"Tham khảo thêm các dòng điện thoại cảm biến vân tay tại thegioididong.com\">bảo mật v&acirc;n tay</a>&nbsp;được đặt b&ecirc;n khung viền của m&aacute;y v&agrave; t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-khuon-mat\" target=\"_blank\" title=\"Tham khảo thêm các dòng điện thoại có bảo mật khuôn mặt tại thegioididong.com\" type=\"Tham khảo thêm các dòng điện thoại có bảo mật khuôn mặt tại thegioididong.com\">bảo mật khu&ocirc;n mặt</a>. Với 2 hệ thống bảo mật được t&iacute;ch hợp trong c&ugrave;ng một chiếc điện thoại, bạn sẽ linh động được c&aacute;ch mở kho&aacute; hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217536/samsung-galaxy-m51-274120-094105.jpg\" onclick=\"return false;\"><img alt=\"Tích hợp bảo mật vân tay cạnh viền | Samsung Galaxy M51\" src=\"https://cdn.tgdd.vn/Products/Images/42/217536/samsung-galaxy-m51-274120-094105.jpg\" title=\"Tích hợp bảo mật vân tay cạnh viền | Samsung Galaxy M51\" /></a></p>\r\n\r\n<p>Nh&igrave;n tổng thể, Samsung Galaxy M51 c&oacute; mức gi&aacute; hợp l&yacute; c&ograve;n được sở hữu những t&iacute;nh năng hiện đại về thiết kế đồng thời nổi bật về chất lượng chắc chắn sẽ kh&ocirc;ng l&agrave;m thất vọng người d&ugrave;ng y&ecirc;u c&ocirc;ng nghệ khi lựa chọn Galaxy M51.</p>\r\n', '0592041a9e205159aecc860f6769bcf878137567.jpg', 100, 1, NULL, 10490000, 'Super AMOLED Plus, 6.7\", Full HD+', 'Android 10', ' Chính 64 MP & Phụ 12 MP, 5 MP, 5 MP', '32 MP', 'Snapdragon 730 8 nhân', ' 2 Nano SIM, Hỗ trợ 4G', '7000 mAh, có sạc nhanh', '2020-10-31 01:56:42', 1),
(3, 0, 'Điện thoại iPhone SE 128GB (2020)', 'Description\r\n', '<h2>Sau bao ng&agrave;y chờ đợi,&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-se-128gb-2020\" target=\"_blank\" title=\"Tham khảo giá iPhone SE 2020 128 GB chính hãng tại Thegioididong.com\" type=\"Tham khảo giá iPhone SE 2020 128 GB chính hãng tại Thegioididong.com\">iPhone SE 2020</a>&nbsp;cuối c&ugrave;ng đ&atilde; được ra mắt l&agrave;m thỏa m&atilde;n triệu t&iacute;n đồ T&aacute;o khuyết. Sở hữu thiết kế si&ecirc;u nhỏ gọn như&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-8-64gb\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 8 chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 8 chính hãng tại Thegioididong.com\">iPhone 8</a>, chip A13 Bionic cho hiệu năng khủng như&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-128gb\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 11 chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 11 chính hãng tại Thegioididong.com\">iPhone 11</a>, nhưng iPhone SE 2020 lại c&oacute; một mức gi&aacute; tốt đến bất ngờ.</h2>\r\n\r\n<h3>Thiết kế nhỏ gọn trong l&ograve;ng b&agrave;n tay.</h3>\r\n\r\n<p>Kh&ocirc;ng nằm ngo&agrave;i mọi đồn đo&aacute;n, iPhone SE 2020 mang tr&ecirc;n m&igrave;nh h&igrave;nh d&aacute;ng của iPhone 8 c&aacute;ch đ&acirc;y 3 năm, vẫn mặt lưng bằng&nbsp;<a href=\"https://www.thegioididong.com/dtdd?g=kim-loai-va-kinh\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có chất liệu kính và kim loại tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có chất liệu kính và kim loại tại Thegioididong.com\">k&iacute;nh v&agrave; khung kim loại</a>,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có hỗ trợ mở khóa cảm biến vân tay tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có hỗ trợ mở khóa cảm biến vân tay tại Thegioididong.com\">cảm biến v&acirc;n tay</a>&nbsp;touch ID huyền thoại đ&atilde; quay trở lại v&agrave; nằm ở vị tr&iacute; quen thuộc.</p>\r\n\r\n<p>Đối với những ai ưa th&iacute;ch sự nhỏ gọn, đặc biệt l&agrave; c&aacute;c bạn nữ th&igrave; iPhone SE l&agrave; một sự lựa chọn l&yacute; tưởng. K&iacute;ch thước nhỏ gọn kh&ocirc;ng qu&aacute; to, gi&uacute;p cho iPhone SE 2020 dễ d&agrave;ng cầm nắm v&agrave; sử dụng bằng 1 tay hay nh&eacute;t v&agrave;o t&uacute;i quần dễ d&agrave;ng.</p>\r\n\r\n<p>Giống với iPhone 8 đến 99%, nhưng bạn vẫn c&oacute; thể ph&acirc;n biệt 2 model n&agrave;y th&ocirc;ng qua logo t&aacute;o khuyết ở mặt lưng, nếu ở thiết bị tiền nhiệm tr&aacute;i t&aacute;o đặt hơi lệch ở ph&iacute;a tr&ecirc;n th&igrave; đến iPhone SE 2020 biểu tượng n&agrave;y đ&atilde; dời ngay ch&iacute;nh giữa.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-20201.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone SE 2020 | Thiết kế nhỏ gọn đi ngược xu hướng \" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-20201.jpg\" title=\"Điện thoại Apple iPhone SE 2020 | Thiết kế nhỏ gọn đi ngược xu hướng \" /></a></p>\r\n\r\n<p>Cũng giống như c&aacute;c thế hệ iPhone gần đ&acirc;y, iPhone SE được trang bị khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chống nước chống bụi tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại chống nước chống bụi tại Thegioididong.com\">kh&aacute;ng nước bụi</a>&nbsp;IP67 c&ugrave;ng t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-khong-day\" target=\"_blank\" title=\"Tham khảo điện thoại sạc không dây tại Thegioididong.com\">sạc kh&ocirc;ng d&acirc;y</a>&nbsp;kh&aacute; hữu &iacute;ch trong nhiều điều kiện sử dụng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-2020-205920-125935.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone SE 2020 | Chống nước, kháng bụi IP67\" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-2020-205920-125935.jpg\" title=\"Điện thoại Apple iPhone SE 2020 | Chống nước, kháng bụi IP67\" /></a></p>\r\n\r\n<p>Ở mặt trước, m&aacute;y trang bị một m&agrave;n h&igrave;nh Retina 4.7 inch, tấm nền IPS cho m&agrave;u sắc ch&iacute;nh x&aacute;c, tươi tắn ở nhiều g&oacute;c độ, d&ugrave; độ ph&acirc;n giải chỉ đạt HD nhưng vẫn cho ra h&igrave;nh ảnh r&otilde; n&eacute;t với chi tiết mịn m&agrave;ng m&agrave; kh&ocirc;ng giảm đi chất lượng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-20206.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone SE 2020 | Chất lượng hiển thị rõ nét trung thực dù độ phân giải chỉ HD\" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-20206.jpg\" title=\"Điện thoại Apple iPhone SE 2020 | Chất lượng hiển thị rõ nét trung thực dù độ phân giải chỉ HD\" /></a></p>\r\n\r\n<h3>Cấu h&igrave;nh &ldquo;kh&ocirc;ng đối thủ&rdquo; trong tầm gi&aacute;</h3>\r\n\r\n<p>Tr&aacute;i ngược với vẻ ngo&agrave;i nhỏ gọn, th&igrave; trang bị phần cứng b&ecirc;n trong iPhone SE 2020 cực kỳ mạnh mẽ với chip A13 Bionic cho hiệu năng v&ocirc; c&ugrave;ng ấn tượng. Với tầm gi&aacute; n&agrave;y, kh&oacute; một chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd?g=android\" target=\"_blank\" title=\"Tham khảo điện thoại Android chính hãng, giá tốt tại Thegioididong.com\" type=\"Tham khảo điện thoại Android chính hãng, giá tốt tại Thegioididong.com\">điện thoại Android</a>&nbsp;hiện nay c&oacute; thể đ&aacute;nh bại.</p>\r\n\r\n<p>Sở hữu vi xử l&yacute; c&oacute; tr&ecirc;n bộ 3 iPhone 11,&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone 11 Pro chính hãng tại Thegioididong.com\" type=\"Tham khảo điện thoại iPhone 11 Pro chính hãng tại Thegioididong.com\">iPhone 11 Pro</a>&nbsp;v&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro-max\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 11 Pro Max chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 11 Pro Max chính hãng tại Thegioididong.com\">iPhone 11 Pro Max</a>, gi&uacute;p cho iPhone SE 2020 c&oacute; một tốc độ xử l&yacute; kinh ngạc từ những t&aacute;c vụ nhẹ nh&agrave;ng h&agrave;ng ng&agrave;y cho đến t&aacute;c vụ nặng chơi game hay thậm ch&iacute; chỉnh sửa đồ họa đều mượt m&agrave; nhanh ch&oacute;ng.</p>\r\n\r\n<p>Sau khi đo bằng ứng dụng AnTuTu th&igrave; điểm nhận về l&agrave; 364.049, ở mức n&agrave;y th&igrave; chỉnh sửa h&igrave;nh ảnh bằng Light Room Mobile cũng mượt nữa chứ kh&ocirc;ng kể g&igrave; đến việc chơi game nhẹ Sudway Sufers hay Temple Run,...</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-2020-203520-043535.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone SE 2020 | Đo điểm AnTuTu\" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-2020-203520-043535.jpg\" title=\"Điện thoại Apple iPhone SE 2020 | Đo điểm AnTuTu\" /></a></p>\r\n\r\n<p>iPhone SE 2020 với t&ugrave;y chọn bộ nhớ 128 GB, gi&uacute;p bạn thoải m&aacute;i hơn khi lưu trữ nhạc phim ưa th&iacute;ch, trong khi bộ nhớ 64 GB ng&agrave;y c&agrave;ng tỏ ra hạn chế khi chạy những phi&ecirc;n bản iOS mới.</p>\r\n\r\n<h3>Camera đơn - đa t&iacute;nh năng</h3>\r\n\r\n<p>Tuy chỉ 1 camera duy nhất, nhưng iPhone SE 2020 vẫn xuất sắc cho ra những tấm h&igrave;nh r&otilde; n&eacute;t, dải nhạy s&aacute;ng rộng,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-xoa-phong\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có camera xóa phông tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có camera xóa phông tại Thegioididong.com\">x&oacute;a ph&ocirc;ng</a>&nbsp;bằng AI cực ch&iacute;nh x&aacute;c, tự nhi&ecirc;n, thậm ch&iacute; bạn c&ograve;n c&oacute; thể chỉnh độ x&oacute;a ph&ocirc;ng sau khi chụp, t&iacute;nh năng t&ugrave;y chỉnh n&agrave;y chỉ xuất hiện một v&agrave;i mẫu smartphone cao cấp</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-2020-230720-110704.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone SE 2020 | Camera đơn những vẫn xóa phông cực đẹp\" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-2020-230720-110704.jpg\" title=\"Điện thoại Apple iPhone SE 2020 | Camera đơn những vẫn xóa phông cực đẹp\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh chụp h&igrave;nh, th&igrave; khả năng quay phim tr&ecirc;n iPhone SE 2020 vẫn rất ấn tượng, m&aacute;y c&oacute; thể quay phim l&ecirc;n đến 4K si&ecirc;u n&eacute;t, dải m&agrave;u tuyệt vời. Nhấn giữ n&uacute;t camera để quay phim nhanh gi&uacute;p bạn kh&ocirc;ng bỏ qua khoảnh khắc th&uacute; vị n&agrave;o.</p>\r\n\r\n<p>Ở mặt trước, camera selfie vẫn l&agrave;m kh&aacute; tốt nhiệm vụ của m&igrave;nh, cho ph&eacute;p bạn chụp h&igrave;nh selfie x&oacute;a ph&ocirc;ng hay chụp với nhiều hiệu ứng AI kh&aacute;c nhau, mang đến những tấm h&igrave;nh đẹp đạt chất lượng Studio.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-2020-230820-110820.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone SE 2020 | Camera selfie chất lượng ảnh vô cùng ấn tượng\" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-2020-230820-110820.jpg\" title=\"Điện thoại Apple iPhone SE 2020 | Camera selfie chất lượng ảnh vô cùng ấn tượng\" /></a></p>\r\n\r\n<h3>Sở hữu c&ocirc;ng nghệ đỉnh cao với mức gi&aacute; phải chăng</h3>\r\n\r\n<p>Tuy chỉ trang bị vi&ecirc;n pin khi&ecirc;m tốn 1821 mAh, nhưng nhờ sự tối ưu cực kỳ tốt phần cứng của iOS, cho ph&eacute;p thiết bị mới của Apple c&oacute; thể trụ được đến 13 giờ sử dụng li&ecirc;n tục, gi&uacute;p bạn y&ecirc;n t&acirc;m trải nghiệm thiết bị trong ng&agrave;y d&agrave;i.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222629/iphone-se-128gb-2020-135920-095934.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 2020 | Sạc pin nhanh 18W\" src=\"https://cdn.tgdd.vn/Products/Images/42/222629/iphone-se-128gb-2020-135920-095934.jpg\" title=\"Điện thoại iPhone SE 2020 | Sạc pin nhanh 18W\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute;, trang bị t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có hỗ trợ sạc pin nhanh tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có hỗ trợ sạc pin nhanh tại Thegioididong.com\">sạc nhanh</a>&nbsp;18 W gi&uacute;p cho iPhone SE mới c&oacute; thể sạc đầy 50% pin chỉ mất 30 ph&uacute;t với bộ sạc nhanh của h&atilde;ng. Rất tiếc, trong hộp chỉ c&oacute; bộ sạc ti&ecirc;u chuẩn, muốn sạc nhanh người d&ugrave;ng cần mua th&ecirc;m phụ kiện sạc ri&ecirc;ng.</p>\r\n\r\n<p>M&aacute;y cũng sẽ hỗ trợ 2 sim 2 s&oacute;ng tiện dụng, gi&uacute;p bạn duy tr&igrave; li&ecirc;n lạc giữa c&ocirc;ng việc v&agrave; c&aacute; nh&acirc;n trong c&ugrave;ng 1 thiết bị, so với những model iPhone chỉ hỗ trợ 1 sim.</p>\r\n\r\n<p>T&oacute;m lại, iPhone SE 2020 l&agrave; chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;tốt khi mang trong m&igrave;nh một cấu h&igrave;nh mạnh mẽ cũng như những t&iacute;nh năng mới nhất của nh&agrave; T&aacute;o. iPhone SE 2020 mang đến cho bạn sự trải nghiệm ho&agrave;n hảo với mức gi&aacute; kh&ocirc;ng thể hấp dẫn hơn.</p>\r\n', '937fd83bfdda9fa6fcbafed5d8caf1dbb1aa09fc.jpg', 5, 0, NULL, 14990000, 'IPS LCD, 4.7\"', 'iOS 13', ' 12 MP', '7 MP', 'Apple A13 Bionic 6 nhân', '1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '1821 mAh, có sạc nhanh', '2020-10-31 02:14:23', 0);
INSERT INTO `phones` (`id`, `brand_id`, `name`, `description`, `content`, `thumb`, `stock`, `promotion_id`, `video`, `price`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`, `battery`, `date_created`, `is_featured`) VALUES
(4, 0, 'Điện thoại iPhone Xs 64GB', 'Description\r\n', '<h2>Đến hẹn lại l&ecirc;n, năm nay Apple giới thiệu tới người d&ugrave;ng thế hệ&nbsp;tiếp theo với 3 phi&ecirc;n bản, trong đ&oacute; c&oacute; c&aacute;i t&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xs\" target=\"_blank\" title=\"Chi tiết điện thoại iPhone XS\" type=\"Chi tiết điện thoại iPhone XS\">iPhone Xs 64 GB</a>&nbsp;với những n&acirc;ng cấp mạnh mẽ về phần cứng đến hiệu năng, m&agrave;n h&igrave;nh c&ugrave;ng h&agrave;ng loạt c&aacute;c trang bị cao cấp kh&aacute;c.&nbsp;</h2>\r\n\r\n<h3>Hiệu năng đỉnh cao đến từ con&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/chi-tiet-chip-apple-a12-bionic-ben-trong-iphone-xs-xs-max-1116982\" target=\"_blank\" title=\"Tìm hiểu chip Apple A12\" type=\"Tìm hiểu chip Apple A12\">chip Apple A12</a></h3>\r\n\r\n<p>Ngo&agrave;i&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại tại Thegioididong.com\" type=\"Tham khảo các dòng điện thoại tại Thegioididong.com\">điện thoại</a>&nbsp;th&igrave; năm nay&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại iPhone\" type=\"Tham khảo các dòng điện thoại iPhone\">iPhone</a>&nbsp;cũng đ&atilde; ch&iacute;nh thức ra mắt chip A12 bionic thế hệ mới với những n&acirc;ng cấp vượt trội về mặt hiệu năng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-2-1.jpg\" onclick=\"return false;\"><img alt=\"Chip A12 trên điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-2-1.jpg\" title=\"Chip A12 trên điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Apple A12 Bionic được x&acirc;y dựng tr&ecirc;n tiến tr&igrave;nh 7nm đầu ti&ecirc;n của h&atilde;ng với 6 nh&acirc;n gi&uacute;p iPhone Xs c&oacute; được một hiệu năng &ldquo;v&ocirc; đối&rdquo; c&ugrave;ng khả năng tiết kiệm năng lượng tối ưu.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-8-1.jpg\" onclick=\"return false;\"><img alt=\"Trải nghiệm điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-8-1.jpg\" title=\"Trải nghiệm điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute;, bộ xử l&yacute; đồ họa của m&aacute;y cũng được Apple thiết kế lại gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;hay dựng h&igrave;nh mượt m&agrave; v&agrave; nhanh ch&oacute;ng hơn gấp nhiều lần.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-22.jpg\" onclick=\"return false;\"><img alt=\"Điểm Antutu Benchmark trên iPhone Xs\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-22.jpg\" title=\"Điểm Antutu Benchmark trên iPhone Xs\" /></a></p>\r\n\r\n<p>Chưa dừng lại ở đ&oacute;, iPhone Xs c&ograve;n được t&iacute;ch hợp th&ecirc;m tr&iacute; th&ocirc;ng minh nh&acirc;n tạo gi&uacute;p tối ưu phần cứng để bạn c&oacute; thể xử l&yacute; c&aacute;c t&aacute;c vụ một c&aacute;ch đơn giản nhất.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-7-1.jpg\" onclick=\"return false;\"><img alt=\"iOS trên điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-7-1.jpg\" title=\"iOS trên điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Kết hợp với phần cứng mạnh mẽ l&agrave; hệ điều h&agrave;nh iOS 12 si&ecirc;u mượt, hứa hẹn iPhone Xs sẽ trở th&agrave;nh một con qu&aacute;i th&uacute; trong l&agrave;ng smartphone hiện nay.</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/tren-tay-danh-gia-nhanh-iphone-xs-suc-manh-tu-ben-trong-1116989\" target=\"_blank\" title=\"Trên tay, đánh giá nhanh iPhone XS\" type=\"Trên tay, đánh giá nhanh iPhone XS\">Tr&ecirc;n tay, đ&aacute;nh gi&aacute; nhanh iPhone XS: Sức mạnh từ b&ecirc;n trong</a></p>\r\n\r\n<h3>M&agrave;n h&igrave;nh Super Retina si&ecirc;u sắc n&eacute;t</h3>\r\n\r\n<p>So với đ&agrave;n anh iPhone X th&igrave; iPhone XS được chăm ch&uacute;t hơn về khả năng hiển thị khi được trang bị h&agrave;ng loạt c&aacute;c c&ocirc;ng nghệ cao cấp.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-3-1.jpg\" onclick=\"return false;\"><img alt=\"Màn hình điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-3-1.jpg\" title=\"Màn hình điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Tr&ecirc;n k&iacute;ch thước 5.8 inch kết hợp tấm nền&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/man-hinh-oled-la-gi-smartphone-nao-co-man-hinh-oled-1048951\" target=\"_blank\" title=\"Tìm hiểu về màn hình OLED\" type=\"Tìm hiểu về màn hình OLED\">OLED</a>&nbsp;đem lại cho bạn một trải nghiệm tuyệt vời khi xem phim hay lướt web với dải m&agrave;u rộng v&agrave; độ chi tiết cực k&igrave; cao.</p>\r\n\r\n<p>Hơn nữa, m&agrave;n h&igrave;nh của m&aacute;y c&ograve;n hỗ trợ c&ocirc;ng nghệ HDR10 c&ugrave;ng tần số qu&eacute;t 120 Hz gi&uacute;p h&igrave;nh ảnh sống động cũng chuyển động mượt m&agrave; hơn.</p>\r\n\r\n<h3>Hệ thống &acirc;m thanh cải tiến</h3>\r\n\r\n<p>iPhone XS sở hữu hệ thống &acirc;m thanh 2 chiều cực k&igrave; tuyệt vời được Apple tinh chỉnh mang lại dải &acirc;m rộng v&agrave; chi tiết hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-1-1.jpg\" onclick=\"return false;\"><img alt=\"Cụm loa dưới điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-1-1.jpg\" title=\"Cụm loa dưới điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Nhờ thế m&agrave; bạn c&oacute; thể thưởng thức những bộ phim trở n&ecirc;n th&uacute; vị v&agrave; sống động hơn m&agrave; kh&ocirc;ng cần d&ugrave;ng đến một chiếc tai nghe để c&oacute; một chất &acirc;m tốt.</p>\r\n\r\n<h3><a href=\"https://www.thegioididong.com/hoi-dap/face-id-la-gi-va-cach-hoat-dong-cua-face-id-1021871\" target=\"_blank\" title=\"Tìm hiểu về tính năng Face ID trên điện thoại iPhone\" type=\"Tìm hiểu về tính năng Face ID trên điện thoại iPhone\">Face ID</a>&nbsp;được tăng cường khả năng bảo mật</h3>\r\n\r\n<p>Hệ thống&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-khuon-mat\" target=\"_blank\" title=\"Tham khảo điện thoại có bảo mật khuôn mặt tại Thế Giới Di Động\">bảo mật khu&ocirc;n mặt</a>&nbsp;3D tr&ecirc;n iPhone Xs đ&atilde; được Apple cải tiến cũng như hỗ trợ tr&iacute; th&ocirc;ng minh nh&acirc;n tạo.</p>\r\n\r\n<p>Bạn chỉ cần nh&igrave;n v&agrave;o iPhone Xs th&igrave; m&aacute;y sẽ tự động mở kh&oacute;a v&agrave; hiển thị tất cả c&aacute;c th&ocirc;ng tin tr&ecirc;n m&agrave;n h&igrave;nh nhờ v&agrave;o một thuật to&aacute;n mới của Apple.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/dtdd-iphone-xs-10.jpg\" onclick=\"return false;\"><img alt=\"Face ID trên điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/dtdd-iphone-xs-10.jpg\" title=\"Face ID trên điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Chưa hết, với hệ thống camera n&agrave;y bạn c&ograve;n c&oacute; thể tạo ra những bức ảnh thực tế ảo AR v&ocirc; c&ugrave;ng đ&aacute;ng y&ecirc;u.</p>\r\n\r\n<h3>Camera h&agrave;ng đầu thế giới</h3>\r\n\r\n<p>iPhone Xs vẫn được duy tr&igrave; cụm&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/camera-kep-la-gi-co-phai-la-xu-huong-tren-smartphone-2017-953888\" target=\"_blank\" title=\"Tìm hiểu về cẩm kép trên điện thoại\" type=\"Tìm hiểu về cẩm kép trên điện thoại\">camera k&eacute;p</a>&nbsp;c&oacute; c&ugrave;ng độ ph&acirc;n giải 12 MP giống như đ&agrave;n anh của n&oacute; nhưng được bổ sung nhiều t&iacute;nh năng chụp ảnh hiện đại hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-21.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-21.jpg\" title=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Với điểm nhấn đặc biệt đến từ việc m&aacute;y c&oacute; thể điều chỉnh khả năng x&oacute;a ph&ocirc;ng ngay tr&ecirc;n bức ảnh từ khẩu độ f/1.4 đến f/16 m&agrave; bạn mong muốn sau khi chụp.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-18.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-18.jpg\" title=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>C&ugrave;ng với đ&oacute;&nbsp;iPhone Xs được trang bị th&ecirc;m c&ocirc;ng nghệ Smart HDR cho ph&eacute;p bạn chụp những bức ảnh s&aacute;ng v&agrave; tối sau đ&oacute; gh&eacute;p lại với nhau để cho ra một bức ảnh c&oacute; độ s&aacute;ng tốt nhất.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-20.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-20.jpg\" title=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Ngo&agrave;i ra, AI camera cũng đ&atilde; được xuất hiện tr&ecirc;n&nbsp;iPhone Xs gi&uacute;p m&aacute;y c&oacute; thể nhận biết được c&aacute;c vật thể để tự động điều chỉnh m&agrave;u sắc, độ tương phản sao cho ph&ugrave; hợp nhằm đem lại h&igrave;nh ảnh với chất lượng cao.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-16.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-16.jpg\" title=\"Ảnh chụp từ camera điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Song song với đ&oacute; phải kể đến&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/giai-thich-su-khac-nhau-giua-ar-emoji-cua-samsung-va-animoji-cua-apple-1070052\" target=\"_blank\" title=\"Tìm hiểu về Animoji trên điện thoại Apple\" type=\"Tìm hiểu về Animoji trên điện thoại Apple\">Animoji</a>&nbsp;được t&iacute;ch hợp nhiều biểu tượng th&uacute; vị v&agrave; ngộ nghĩnh hơn gi&uacute;p bạn th&ecirc;m nhiều lựa chọn để giải tr&iacute;.</p>\r\n\r\n<h3>Thiết kế kh&ocirc;ng c&oacute; nhiều sự kh&aacute;c biệt</h3>\r\n\r\n<p>iPhone Xs được thừa hưởng vẻ đẹp từ người đ&agrave;n anh của m&igrave;nh l&agrave; chiếc điện thoại iPhone X với phần khung được l&agrave;m từ khung th&eacute;p kh&ocirc;ng gỉ kết hợp với 2 mặt k&iacute;nh cường lực cao cấp.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-6-1.jpg\" onclick=\"return false;\"><img alt=\"Thiết kế điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-6-1.jpg\" title=\"Thiết kế điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Th&acirc;n h&igrave;nh uyển chuyển với c&aacute;c đường cong mềm mại đem lại cho bạn khả năng cầm nắm chắc chắn v&agrave; v&ocirc; c&ugrave;ng thoải m&aacute;i.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/190323/iphone-xs-5-1.jpg\" onclick=\"return false;\"><img alt=\"Thiết kế điện thoại iPhone Xs chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/190323/iphone-xs-5-1.jpg\" title=\"Thiết kế điện thoại iPhone Xs chính hãng\" /></a></p>\r\n\r\n<p>Đặc biệt,&nbsp;si&ecirc;u phẩm mới n&agrave;y được tăng cường th&ecirc;m khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo điện thoại có chống nước, bụi tại Thế Giới Di Động\">chống nước</a>&nbsp;v&agrave; bụi bẩn với chuẩn IP68 m&agrave; hầu hết c&aacute;c flagship hiện nay được trang bị.</p>\r\n', '3092076ff528b6bc1d78cf4d795cbf9b5207be23.jpg', 60, 0, NULL, 17990000, 'OLED, 5.8\", Super Retina', 'iOS 12', ' 2 camera 12 MP', '7 MP', 'Apple A12 Bionic 6 nhân', '1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '2658 mAh, có sạc nhanh', '2020-10-31 02:19:40', 0),
(5, 0, 'Điện thoại Samsung Galaxy S20', 'Description\r\n', '<h2>Đặc điểm nổi bật của Samsung Galaxy S20</h2>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/217935/Slider/vi-vn-samsung-galaxy-s20-series-thumb-video.jpg\" /><img src=\"https://www.thegioididong.com/Content/desktop/images/V4/icon-yt.png\" /></p>\r\n\r\n<p>Bộ sản phẩm chuẩn: Hộp, Sạc, Tai nghe, S&aacute;ch hướng dẫn, C&aacute;p, C&acirc;y lấy sim, Ốp lưng</p>\r\n\r\n<h2 dir=\"ltr\"><a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-s20\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy S20 chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy S20 chính hãng\">Samsung Galaxy S20</a>&nbsp;l&agrave;&nbsp;chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\" type=\"Tham khảo giá điện thoại smartphone chính hãng\">điện thoại</a>&nbsp;với thiết kế m&agrave;n h&igrave;nh tr&agrave;n viền kh&ocirc;ng khuyết điểm, camera sau ấn tượng, hiệu năng khủng c&ugrave;ng nhiều những đột ph&aacute; c&ocirc;ng nghệ nổi bật, dẫn đầu thế giới.</h2>\r\n\r\n<h3 dir=\"ltr\">M&agrave;n h&igrave;nh si&ecirc;u tr&agrave;n, si&ecirc;u nhanh 120 Hz</h3>\r\n\r\n<p dir=\"ltr\">Chiếc điện thoại Samsung Galaxy S20 được trang bị một m&agrave;n h&igrave;nh k&iacute;ch thước 6.2 inch độ ph&acirc;n giải 2K sử dụng tấm nền Dynamic AMOLED 2X mới nhất từ nh&agrave; sản xuất&nbsp;<a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\" type=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\">Samsung</a>.</p>\r\n\r\n<p dir=\"ltr\">M&agrave;n h&igrave;nh n&agrave;y cho khả năng t&aacute;i tạo m&agrave;u sắc đầy đủ v&agrave; ch&iacute;nh x&aacute;c, đem đến cho bạn những trải nghiệm h&igrave;nh ảnh sống động, ch&acirc;n thực đồng thời giảm lượng &aacute;nh s&aacute;ng xanh bảo vệ sức khỏe người d&ugrave;ng.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s205-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Thiết kế tràn viền không khuyết điểm\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s205-1.jpg\" title=\"Samsung Galaxy S20 | Thiết kế tràn viền không khuyết điểm\" /></a></p>\r\n\r\n<p dir=\"ltr\">So với thế hệ trước th&igrave; viền m&agrave;n h&igrave;nh lần n&agrave;y đ&atilde; được l&agrave;m mỏng hơn đ&aacute;ng kể, gần như biến mất ở c&aacute;c cạnh tr&aacute;i phải v&agrave; cạnh tr&ecirc;n.&nbsp;Thiết kế si&ecirc;u tr&agrave;n viền&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tong-hop-cac-loai-man-hinh-vo-cuc-moi-tren-dien-th-1150900\" target=\"_blank\" title=\"Tìm hiểu 4 loại màn hình vô cực mới trên điện thoại Samsung\" type=\"Tìm hiểu 4 loại màn hình vô cực mới trên điện thoại Samsung\">Infinity O</a>&nbsp;với một điểm kho&eacute;t nhỏ cho camera trước cho bạn trải nghiệm m&agrave;n h&igrave;nh giải tr&iacute; k&iacute;ch thước lớn với độ ph&acirc;n giải cao.&nbsp;</p>\r\n\r\n<p dir=\"ltr\">Loa thoại của m&aacute;y cũng được Samsung đặt trong một r&atilde;nh rất nhỏ ở cạnh tr&ecirc;n, khiến cạnh n&agrave;y c&agrave;ng mỏng v&agrave; &iacute;t chi tiết hơn.</p>\r\n\r\n<p dir=\"ltr\">Cảm gi&aacute;c cầm nắm tr&ecirc;n Samsung Galaxy S20 kh&aacute; tốt, chắc chắn v&agrave; đầm tay, viền m&agrave;n h&igrave;nh của m&aacute;y được Samsung bo cong &iacute;t hơn thế hệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-s10\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy S10 chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy S10 chính hãng\">Galaxy S10</a>&nbsp;trước đ&acirc;y, cho cảm gi&aacute;c vuốt kh&aacute; mềm mại v&agrave; dễ chịu.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s20-tgdd5.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Viền màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s20-tgdd5.jpg\" title=\"Samsung Galaxy S20 | Viền màn hình\" /></a></p>\r\n\r\n<p dir=\"ltr\">Đặc biệt, m&agrave;n h&igrave;nh của m&aacute;y c&oacute; tần số qu&eacute;t cao l&ecirc;n đến 120 Hz, cho mọi thao t&aacute;c từ cuộn trang đến chơi game đều được t&aacute;i hiện si&ecirc;u mượt, người d&ugrave;ng kh&oacute; l&ograve;ng nhận ra độ giật của c&aacute;c khung h&igrave;nh.</p>\r\n\r\n<p dir=\"ltr\">C&ocirc;ng nghệ hiển thị HDR10+ mang tới những thước phim được t&aacute;i hiện một c&aacute;ch sắc n&eacute;t, ch&acirc;n thực nhất.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s202-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Chất lương hiển thị màu sắc sinh động, chân thực\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s202-1.jpg\" title=\"Samsung Galaxy S20 | Chất lương hiển thị màu sắc sinh động, chân thực\" /></a></p>\r\n\r\n<p dir=\"ltr\">Thiết kế của m&aacute;y l&agrave; sự kết hợp độc đ&aacute;o giữa khung viền th&eacute;p c&ugrave;ng mặt k&iacute;nh cường lực&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-ve-cac-mat-kinh-cuong-luc-gorilla-glass-1172198#glass6\" target=\"_blank\" title=\"Tìm hiểu về công nghệ kính cường lực Gorilla Glass 6\" type=\"Tìm hiểu về công nghệ kính cường lực Gorilla Glass 6\">Gorilla Glass 6</a>&nbsp;với độ bền cao, phần khung m&aacute;y được ho&agrave;n thiện một c&aacute;ch v&ocirc; c&ugrave;ng tỉ mỉ, dường như kh&ocirc;ng c&oacute; phần gh&eacute;p nối giữa khung kim loại, viền m&agrave;n h&igrave;nh v&agrave; mặt lưng k&iacute;nh.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s208.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Viền màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s208.jpg\" title=\"Samsung Galaxy S20 | Viền màn hình\" /></a></p>\r\n\r\n<p dir=\"ltr\">Galaxy S20 được trang bị khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo điện thoại chống nước, bụi tại Thegioididong.com\">chống nước, bụi</a>&nbsp;chuẩn&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/chong-nuoc-va-chong-bui-tren-smart-phone-771130\" target=\"_blank\" title=\"Tìm hiểu tính năng chống nước và chống bụi trên smartphone\" type=\"Tìm hiểu tính năng chống nước và chống bụi trên smartphone\">IP68</a>, người d&ugrave;ng ho&agrave;n to&agrave;n c&oacute; thể y&ecirc;n t&acirc;m khi mang chiếc điện thoại n&agrave;y khi đi du lịch, tắm biển m&agrave; kh&ocirc;ng lo bị hỏng h&oacute;c.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s204-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Cảm biến vân tay quang học\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s204-1.jpg\" title=\"Samsung Galaxy S20 | Cảm biến vân tay quang học\" /></a></p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\" type=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\">Cảm biến v&acirc;n tay</a>&nbsp;được t&iacute;ch hợp b&ecirc;n trong m&agrave;n h&igrave;nh được đặt cao hơn so với d&ograve;ng điện thoại Samsung Galaxy S10 với khả năng nhận diện nhanh v&agrave; ch&iacute;nh x&aacute;c. Ngo&agrave;i ra bạn cũng c&oacute; thể mở kh&oacute;a bằng chức năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-khuon-mat\" target=\"_blank\" title=\"Tham khảo điện thoại mở khoá bằng khuôn mặt tại Thegioididong.com \">nhận diện khu&ocirc;n mặt</a>&nbsp;đầy thời thượng với tốc độ cũng nhanh kh&ocirc;ng k&eacute;m.</p>\r\n\r\n<h3 dir=\"ltr\">Camera đột ph&aacute; kh&ocirc;ng tưởng</h3>\r\n\r\n<p dir=\"ltr\">Chiếc điện thoại n&agrave;y được Samsung trang bị cho m&aacute;y hệ thống 3 camera sau bao gồm: 1 camera tele 64 MP, 1 camera&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone camera chụp hình góc rộng\" type=\"Tham khảo giá điện thoại smartphone camera chụp hình góc rộng\">g&oacute;c rộng</a>&nbsp;12 MP v&agrave; 1 camera g&oacute;c si&ecirc;u rộng 12 MP, hỗ trợ nhiều t&iacute;nh năng chụp ảnh chuy&ecirc;n nghiệp lần đầu xuất hiện tr&ecirc;n smartphone.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s207.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Thiết kế camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s207.jpg\" title=\"Samsung Galaxy S20 | Thiết kế camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Đầu ti&ecirc;n phải kể đến l&agrave; t&iacute;nh năng quay phim chất lượng 8K mới được Samsung trang bị tr&ecirc;n một sản phẩm smartphone thế hệ Galaxy S20 của m&igrave;nh, mở ra một bước tiến mới cho lĩnh vực nhiếp ảnh di động.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s203-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Giao diện camera\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s203-1.jpg\" title=\"Samsung Galaxy S20 | Giao diện camera\" /></a></p>\r\n\r\n<p dir=\"ltr\">Với t&iacute;nh năng n&agrave;y Samsung Galaxy S20 sẽ mang tới cho người d&ugrave;ng những thước phim với chất lượng si&ecirc;u khủng, những khoảnh khắc hằng ng&agrave;y sẽ được lưu lại với độ ph&acirc;n giải cực cao.</p>\r\n\r\n<p dir=\"ltr\">Si&ecirc;u phẩm camera với độ ph&acirc;n giải l&ecirc;n đến 64MP từ Galaxy S20 cho bạn thoả sức lưu trọn từng chi tiết, giữ được độ r&otilde; n&eacute;t cho bức ảnh.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s20-3-2.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Camera độ phân giải 64MP \" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s20-3-2.jpg\" title=\"Samsung Galaxy S20 | Camera độ phân giải 64MP \" /></a></p>\r\n\r\n<p dir=\"ltr\">Camera của m&aacute;y c&ograve;n c&oacute; khả năng chụp ảnh hay quay video chất lượng cao với khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-zoom\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone camera zoom\" type=\"Tham khảo giá điện thoại smartphone camera zoom\">zoom</a>&nbsp;tối đa 30X mang tới những bức ảnh chi tiết với khoảng c&aacute;ch xa m&agrave; mắt thường kh&ocirc;ng nh&igrave;n thấy được.</p>\r\n\r\n<p dir=\"ltr\">Ngo&agrave;i ra, camera của m&aacute;y c&ograve;n được t&iacute;ch hợp bộ chỉnh sửa h&igrave;nh ảnh th&ocirc;ng minh, dễ d&agrave;ng chỉnh sửa ngay tr&ecirc;n m&aacute;y để tạo ra một bức h&igrave;nh ưng &yacute; nhất.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s20-tgdd10.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Camera selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s20-tgdd10.jpg\" title=\"Samsung Galaxy S20 | Camera selfie\" /></a></p>\r\n\r\n<p dir=\"ltr\">Camera selfie của m&aacute;y c&oacute; độ ph&acirc;n giải 10 MP được n&acirc;ng cấp mạnh mẽ cả về phần cứng lẫn phần mềm, nổi trội với khả năng quay video chất lượng 4K đ&aacute;p ứng tốt nhu cầu quay&nbsp;vlog chất lượng cao ngay tr&ecirc;n thiết bị di động.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s20-1-2.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Camera selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s20-1-2.jpg\" title=\"Samsung Galaxy S20 | Camera selfie\" /></a></p>\r\n\r\n<h3 dir=\"ltr\">Hiệu năng đứng đầu với Exynos 990</h3>\r\n\r\n<p dir=\"ltr\">Chiếc điện thoại Galaxy S20 mang trong m&igrave;nh con chip c&acirc;y nh&agrave; l&aacute; vườn Exynos 990 8 nh&acirc;n mạnh mẽ đi k&egrave;m với dung lượng RAM 8 GB cho khả năng xử l&yacute; đa nhiệm nhanh ch&oacute;ng, mượt m&agrave;.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s20-tgdd9.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Hiệu năng đứng đầu\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s20-tgdd9.jpg\" title=\"Samsung Galaxy S20 | Hiệu năng đứng đầu\" /></a></p>\r\n\r\n<p dir=\"ltr\">Hiệu năng mạnh mẽ của Galaxy S20 được chứng minh khi gi&uacute;p cho chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;tốt, mượt m&agrave; tr&ecirc;n c&aacute;c d&ograve;ng game nặng y&ecirc;u cầu mức đồ họa cao hay xử l&yacute; tốt c&aacute;c ứng dụng c&ocirc;ng nghệ thực tế ảo VR.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s206-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Hiệu năng mạnh mẽ\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s206-1.jpg\" title=\"Samsung Galaxy S20 | Hiệu năng mạnh mẽ\" /></a></p>\r\n\r\n<p dir=\"ltr\">Bộ nhớ trong 128 GB đạt chuẩn&nbsp;UFS 3.0 mới nhất&nbsp;cho bạn thoải m&aacute;i lưu giữ h&igrave;nh ảnh video hay c&agrave;i đặt c&aacute;c ứng dụng nặng với tốc độ cao.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s201-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Hỗ trợ 2 sim hoặc 1 sim 1 thẻ nhớ\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s201-1.jpg\" title=\"Samsung Galaxy S20 | Hỗ trợ 2 sim hoặc 1 sim 1 thẻ nhớ\" /></a></p>\r\n\r\n<p dir=\"ltr\">Bộ nhớ trong lớn c&oacute; hỗ trợ thẻ nhớ ngo&agrave;i l&ecirc;n đến 1T gi&uacute;p bạn thoải m&aacute;i lưu trữ h&igrave;nh ảnh hay quay video chất lượng cao 8K m&agrave; Samsung đ&atilde; trang bị tr&ecirc;n smartphone n&agrave;y.</p>\r\n\r\n<p dir=\"ltr\">Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/galaxy-s20-quay-video-8k-ton-bao-nhieu-dung-luong-1-phut-1236209\" target=\"_blank\" title=\"Galaxy S20 quay video 8K tốn bao nhiêu dung lượng trong 1 phút? Đây là câu trả lời của Samsung!\" type=\"Galaxy S20 quay video 8K tốn bao nhiêu dung lượng trong 1 phút? Đây là câu trả lời của Samsung!\">Galaxy S20 quay video 8K tốn bao nhi&ecirc;u dung lượng trong 1 ph&uacute;t? Đ&acirc;y l&agrave; c&acirc;u trả lời của Samsung!</a></p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s20-tgdd8.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Trải nghiệm sử dụng\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s20-tgdd8.jpg\" title=\"Samsung Galaxy S20 | Trải nghiệm sử dụng\" /></a></p>\r\n\r\n<p dir=\"ltr\">Cổng tai nghe 3.5 mm đ&atilde; được loại bỏ ho&agrave;n to&agrave;n tr&ecirc;n d&ograve;ng sản phẩm Galaxy S20 b&ugrave; lại m&aacute;y c&oacute; hỗ trợ tai nghe qua cổng USB Type C được Samsung trang bị đi k&egrave;m trong hộp m&aacute;y.</p>\r\n\r\n<h3 dir=\"ltr\">Dung lượng lớn, sạc nhanh v&agrave; sạc kh&ocirc;ng d&acirc;y</h3>\r\n\r\n<p dir=\"ltr\">M&aacute;y được trang bị vi&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd?f=pin-khung-3000-mah\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone pin khủng pin trâu\" type=\"Tham khảo giá điện thoại smartphone pin khủng pin trâu\">pin lớn</a>&nbsp;4.000 mAh cho bạn thời gian sử dụng nguy&ecirc;n ng&agrave;y với chỉ duy nhất một lần sạc. C&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\" type=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\">sạc nhanh</a>&nbsp;25 W&nbsp;tr&ecirc;n Galaxy S20 gi&uacute;p m&aacute;y giảm đ&aacute;ng kể thời gian sạc, tăng thời gian sử dụng m&aacute;y kh&ocirc;ng bị gi&aacute;n đoạn phải sạc đi sạc lại nhiều lần.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/217935/samsung-galaxy-s209-1.jpg\" onclick=\"return false;\"><img alt=\"Samsung Galaxy S20 | Thời lượng pin tốt\" src=\"https://cdn.tgdd.vn/Products/Images/42/217935/samsung-galaxy-s209-1.jpg\" title=\"Samsung Galaxy S20 | Thời lượng pin tốt\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ngo&agrave;i ra, bạn cũng c&oacute; thể sạc pin qua h&igrave;nh thức&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-khong-day\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone hỗ trợ sạc pin không dây\" type=\"Tham khảo giá điện thoại smartphone hỗ trợ sạc pin không dây\">sạc kh&ocirc;ng d&acirc;y</a>&nbsp;15W hay t&iacute;nh năng sạc ngược kh&ocirc;ng d&acirc;y 9W cho c&aacute;c thiết bị kh&aacute;c một c&aacute;ch dễ d&agrave;ng v&agrave; tiện lợi.</p>\r\n', 'fcf5aed3120102d11fbe7514fd5ce368385c4b49.jpg', 55, 0, NULL, 18490000, 'Dynamic AMOLED 2X, 6.2\", Quad HD+ (2K+)', 'Android 10', ' Chính 12 MP & Phụ 64 MP, 12 MP', '10 MP', '	Exynos 990 8 nhân', '2 Nano SIM hoặc 1 Nano SIM + 1 eSIM, Hỗ trợ 4G', '4000 mAh, có sạc nhanh', '2020-10-31 02:28:41', 0);
INSERT INTO `phones` (`id`, `brand_id`, `name`, `description`, `content`, `thumb`, `stock`, `promotion_id`, `video`, `price`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`, `battery`, `date_created`, `is_featured`) VALUES
(6, 0, 'Điện thoại Samsung Galaxy Z Flip', 'Description\r\n', '<h2 dir=\"ltr\">Cuối c&ugrave;ng sau bao nhi&ecirc;u thời gian chờ đợi, chiếc điện thoại&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-z-flip\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy Z Flip chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy Z Flip chính hãng\">Samsung Galaxy Z Flip</a>&nbsp;đ&atilde; được&nbsp;<a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\" type=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\">Samsung</a>&nbsp;ra mắt tại sự kiện&nbsp;Unpacked 2020. Si&ecirc;u phẩm với thiết kế m&agrave;n h&igrave;nh gập vỏ s&ograve; độc đ&aacute;o, hiệu năng tuyệt đỉnh c&ugrave;ng nhiều c&ocirc;ng nghệ thời thượng, dẫn dầu 2020.</h2>\r\n\r\n<h3 dir=\"ltr\">Đột ph&aacute; với thiết kế m&agrave;n h&igrave;nh gập</h3>\r\n\r\n<p dir=\"ltr\">Samsung Galaxy Z Flip được thiết kế với kiểu d&aacute;ng m&agrave;n h&igrave;nh gập lấy &yacute; tưởng từ d&ograve;ng sản phẩm&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-fold\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy Fold chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy Fold chính hãng\">Galaxy Fold</a>&nbsp;từng g&acirc;y nhiều tiếng vang trong năm 2019.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd4-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Khả năng gập với nhiều góc độ khác nhau\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd4-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Khả năng gập với nhiều góc độ khác nhau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Tuy nhi&ecirc;n điểm kh&aacute;c biệt l&agrave; m&agrave;n h&igrave;nh của Z Flip được&nbsp;thiết kế gập theo chiều dọc, khiến cho tổng thể m&aacute;y c&oacute; thể nằm gọn trong l&ograve;ng b&agrave;n tay của người d&ugrave;ng như một phụ kiện thời trang cao cấp.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd2-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Đột phá thiết kế màn hình gập\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd2-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Đột phá thiết kế màn hình gập\" /></a></p>\r\n\r\n<p dir=\"ltr\">Bản lề của m&aacute;y cũng c&oacute; khả năng gập - mở với nhiều g&oacute;c độ kh&aacute;c nhau, khi thiết bị ở trạng th&aacute;i mở một nửa, m&agrave;n h&igrave;nh sẽ tự động chia th&agrave;nh hai m&agrave;n h&igrave;nh 4 inch vừa đủ để bạn c&oacute; thể dễ d&agrave;ng xem h&igrave;nh ảnh, nội dung hoặc video ở nửa tr&ecirc;n của m&agrave;n h&igrave;nh v&agrave; thao t&aacute;c điều khiển ch&uacute;ng ở nửa dưới.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd5-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế bản lề mới với độ bền cao\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd5-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế bản lề mới với độ bền cao\" /></a></p>\r\n\r\n<p dir=\"ltr\">Trải nghiệm sử dụng Samsung Galaxy Z Flip linh hoạt nhờ kết cấu bản lề mới hiện đại, c&oacute; khả năng chống bụi bẩn tốt hơn. Tuy vẫn c&oacute; vết gấp giữa m&agrave;n h&igrave;nh Galaxy Z Flip nhưng ho&agrave;n to&agrave;n kh&ocirc;ng ảnh hưởng đến trải nghiệm người d&ugrave;ng.</p>\r\n\r\n<p dir=\"ltr\">B&ecirc;n cạnh đ&oacute; c&ocirc;ng nghệ n&agrave;y c&ograve;n cho ph&eacute;p Samsung Galaxy Z Flip c&oacute; thể dễ d&agrave;ng gập mở với độ bền l&ecirc;n tới hơn 200.000 lần, mở ra một thập kỷ mới của sự s&aacute;ng tạo d&agrave;nh cho&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\" type=\"Tham khảo giá điện thoại smartphone chính hãng\">điện thoại</a>&nbsp;m&agrave;n h&igrave;nh gập.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd11-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế gọn nhẹ\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd11-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế gọn nhẹ\" /></a></p>\r\n\r\n<p dir=\"ltr\">Khi mở m&aacute;y hết cỡ, m&agrave;n h&igrave;nh của m&aacute;y c&oacute; k&iacute;ch thước 6.7 inch, đ&acirc;y l&agrave; m&agrave;n h&igrave;nh c&oacute; thiết kế gập vỏ s&ograve; bằng k&iacute;nh đầu ti&ecirc;n tr&ecirc;n thế giới với thiết kế&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-tran-vien\" target=\"_blank\" title=\"Điên thoại Tràn viền tại Thegioididong.com\" type=\"Điên thoại Tràn viền tại Thegioididong.com\">m&agrave;n h&igrave;nh tr&agrave;n viền</a>&nbsp;với camera kho&eacute;t lỗ.&nbsp;</p>\r\n\r\n<p dir=\"ltr\">Galaxy Z Flip sở hữu m&agrave;n h&igrave;nh Infinity Flex với c&ocirc;ng nghệ k&iacute;nh uốn dẻo Ultra Thin Glass (UTG) độc đ&aacute;o từ Samsung, c&ocirc;ng nghệ n&agrave;y gi&uacute;p m&aacute;y mỏng hơn, cho cảm gi&aacute;c cầm nắm sang trọng v&agrave; cao cấp.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd10-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Màn hình giải trí sắc nét\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd10-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Màn hình giải trí sắc nét\" /></a></p>\r\n\r\n<p dir=\"ltr\">Sử dụng tấm nền Dynamic AMOLED độ ph&acirc;n giải Full HD+ tỉ lệ m&agrave;n h&igrave;nh 21.9:9 độc đ&aacute;o nhất hiện nay, hỗ trợ HDR10+ gi&uacute;p cho từng h&igrave;nh ảnh m&agrave; bạn xem sống động tr&ecirc;n từng chi tiết, sắc n&eacute;t tr&ecirc;n từng chuyển động mang đến m&agrave;u sắc sống động ch&acirc;n thật.</p>\r\n\r\n<h3 dir=\"ltr\">N&acirc;ng cấp camera k&eacute;p, chụp ảnh ban đ&ecirc;m ấn tượng</h3>\r\n\r\n<p dir=\"ltr\">Samsung Galaxy Z Flip được trang bị camera k&eacute;p c&ugrave;ng độ ph&acirc;n giải 12 MP với khẩu độ lần lượt l&agrave; f/1.8 v&agrave; f/2.2 c&oacute; hỗ trợ chống rung quang học OIS cho khả năng chụp h&igrave;nh thiếu s&aacute;ng tốt đi k&egrave;m c&ocirc;ng nghệ chụp ảnh bằng cử chỉ, dễ d&agrave;ng ghi lại mọi khoảnh khắc hằng ng&agrave;y.&nbsp;</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd8-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Camera kép ấn tượng\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd8-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Camera kép ấn tượng\" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ocirc;ng nghệ nhận diện AI gi&uacute;p m&aacute;y c&oacute; thể nhận biết được nhiều chủ thể kh&aacute;c nhau qua đ&oacute; tối ưu c&aacute;c th&ocirc;ng số kỹ thuật để cho ra những tấm h&igrave;nh sắc n&eacute;t, độ chi tiết cao c&ugrave;ng m&agrave;u sắc sống động.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd12.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Trải nghiệm camera \" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd12.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Trải nghiệm camera \" /></a></p>\r\n\r\n<p dir=\"ltr\">Camera trước của m&aacute;y c&oacute; độ ph&acirc;n giải 10 MP với khẩu độ f2.4 được bố tr&iacute; dạng đục lỗ ở ch&iacute;nh giữa m&agrave;n h&igrave;nh cũng tương tự như Galaxy S20, đ&aacute;p ứng tốt nhu cầu chụp ảnh selfie, quay video với chất lượng tốt.</p>\r\n\r\n<h2>Đặc điểm nổi bật của Samsung Galaxy Z Flip</h2>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/213022/Slider/samsung-galaxy-z-flip-065720-105759-126.jpg\" /><img src=\"https://www.thegioididong.com/Content/desktop/images/V4/icon-yt.png\" /></p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-chip-qualcomm-snapdragon-855-plus-1198387\" target=\"_blank\">T&igrave;m hiểu th&ecirc;m</a></p>\r\n\r\n<p>Bộ sản phẩm chuẩn: Hộp, Sạc, Tai nghe, S&aacute;ch hướng dẫn, C&aacute;p, C&acirc;y lấy sim, Ốp lưng, Adapter chuyển USB</p>\r\n\r\n<h2 dir=\"ltr\">Cuối c&ugrave;ng sau bao nhi&ecirc;u thời gian chờ đợi, chiếc điện thoại&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-z-flip\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy Z Flip chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy Z Flip chính hãng\">Samsung Galaxy Z Flip</a>&nbsp;đ&atilde; được&nbsp;<a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\" type=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\">Samsung</a>&nbsp;ra mắt tại sự kiện&nbsp;Unpacked 2020. Si&ecirc;u phẩm với thiết kế m&agrave;n h&igrave;nh gập vỏ s&ograve; độc đ&aacute;o, hiệu năng tuyệt đỉnh c&ugrave;ng nhiều c&ocirc;ng nghệ thời thượng, dẫn dầu 2020.</h2>\r\n\r\n<h3 dir=\"ltr\">Đột ph&aacute; với thiết kế m&agrave;n h&igrave;nh gập</h3>\r\n\r\n<p dir=\"ltr\">Samsung Galaxy Z Flip được thiết kế với kiểu d&aacute;ng m&agrave;n h&igrave;nh gập lấy &yacute; tưởng từ d&ograve;ng sản phẩm&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-fold\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy Fold chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy Fold chính hãng\">Galaxy Fold</a>&nbsp;từng g&acirc;y nhiều tiếng vang trong năm 2019.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd4-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Khả năng gập với nhiều góc độ khác nhau\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd4-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Khả năng gập với nhiều góc độ khác nhau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Tuy nhi&ecirc;n điểm kh&aacute;c biệt l&agrave; m&agrave;n h&igrave;nh của Z Flip được&nbsp;thiết kế gập theo chiều dọc, khiến cho tổng thể m&aacute;y c&oacute; thể nằm gọn trong l&ograve;ng b&agrave;n tay của người d&ugrave;ng như một phụ kiện thời trang cao cấp.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd2-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Đột phá thiết kế màn hình gập\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd2-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Đột phá thiết kế màn hình gập\" /></a></p>\r\n\r\n<p dir=\"ltr\">Bản lề của m&aacute;y cũng c&oacute; khả năng gập - mở với nhiều g&oacute;c độ kh&aacute;c nhau, khi thiết bị ở trạng th&aacute;i mở một nửa, m&agrave;n h&igrave;nh sẽ tự động chia th&agrave;nh hai m&agrave;n h&igrave;nh 4 inch vừa đủ để bạn c&oacute; thể dễ d&agrave;ng xem h&igrave;nh ảnh, nội dung hoặc video ở nửa tr&ecirc;n của m&agrave;n h&igrave;nh v&agrave; thao t&aacute;c điều khiển ch&uacute;ng ở nửa dưới.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd5-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế bản lề mới với độ bền cao\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd5-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế bản lề mới với độ bền cao\" /></a></p>\r\n\r\n<p dir=\"ltr\">Trải nghiệm sử dụng Samsung Galaxy Z Flip linh hoạt nhờ kết cấu bản lề mới hiện đại, c&oacute; khả năng chống bụi bẩn tốt hơn. Tuy vẫn c&oacute; vết gấp giữa m&agrave;n h&igrave;nh Galaxy Z Flip nhưng ho&agrave;n to&agrave;n kh&ocirc;ng ảnh hưởng đến trải nghiệm người d&ugrave;ng.</p>\r\n\r\n<p dir=\"ltr\">B&ecirc;n cạnh đ&oacute; c&ocirc;ng nghệ n&agrave;y c&ograve;n cho ph&eacute;p Samsung Galaxy Z Flip c&oacute; thể dễ d&agrave;ng gập mở với độ bền l&ecirc;n tới hơn 200.000 lần, mở ra một thập kỷ mới của sự s&aacute;ng tạo d&agrave;nh cho&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\" type=\"Tham khảo giá điện thoại smartphone chính hãng\">điện thoại</a>&nbsp;m&agrave;n h&igrave;nh gập.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd11-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế gọn nhẹ\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd11-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Thiết kế gọn nhẹ\" /></a></p>\r\n\r\n<p dir=\"ltr\">Khi mở m&aacute;y hết cỡ, m&agrave;n h&igrave;nh của m&aacute;y c&oacute; k&iacute;ch thước 6.7 inch, đ&acirc;y l&agrave; m&agrave;n h&igrave;nh c&oacute; thiết kế gập vỏ s&ograve; bằng k&iacute;nh đầu ti&ecirc;n tr&ecirc;n thế giới với thiết kế&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-tran-vien\" target=\"_blank\" title=\"Điên thoại Tràn viền tại Thegioididong.com\" type=\"Điên thoại Tràn viền tại Thegioididong.com\">m&agrave;n h&igrave;nh tr&agrave;n viền</a>&nbsp;với camera kho&eacute;t lỗ.&nbsp;</p>\r\n\r\n<p dir=\"ltr\">Galaxy Z Flip sở hữu m&agrave;n h&igrave;nh Infinity Flex với c&ocirc;ng nghệ k&iacute;nh uốn dẻo Ultra Thin Glass (UTG) độc đ&aacute;o từ Samsung, c&ocirc;ng nghệ n&agrave;y gi&uacute;p m&aacute;y mỏng hơn, cho cảm gi&aacute;c cầm nắm sang trọng v&agrave; cao cấp.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd10-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Màn hình giải trí sắc nét\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd10-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Màn hình giải trí sắc nét\" /></a></p>\r\n\r\n<p dir=\"ltr\">Sử dụng tấm nền Dynamic AMOLED độ ph&acirc;n giải Full HD+ tỉ lệ m&agrave;n h&igrave;nh 21.9:9 độc đ&aacute;o nhất hiện nay, hỗ trợ HDR10+ gi&uacute;p cho từng h&igrave;nh ảnh m&agrave; bạn xem sống động tr&ecirc;n từng chi tiết, sắc n&eacute;t tr&ecirc;n từng chuyển động mang đến m&agrave;u sắc sống động ch&acirc;n thật.</p>\r\n\r\n<h3 dir=\"ltr\">N&acirc;ng cấp camera k&eacute;p, chụp ảnh ban đ&ecirc;m ấn tượng</h3>\r\n\r\n<p dir=\"ltr\">Samsung Galaxy Z Flip được trang bị camera k&eacute;p c&ugrave;ng độ ph&acirc;n giải 12 MP với khẩu độ lần lượt l&agrave; f/1.8 v&agrave; f/2.2 c&oacute; hỗ trợ chống rung quang học OIS cho khả năng chụp h&igrave;nh thiếu s&aacute;ng tốt đi k&egrave;m c&ocirc;ng nghệ chụp ảnh bằng cử chỉ, dễ d&agrave;ng ghi lại mọi khoảnh khắc hằng ng&agrave;y.&nbsp;</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd8-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Camera kép ấn tượng\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd8-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Camera kép ấn tượng\" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ocirc;ng nghệ nhận diện AI gi&uacute;p m&aacute;y c&oacute; thể nhận biết được nhiều chủ thể kh&aacute;c nhau qua đ&oacute; tối ưu c&aacute;c th&ocirc;ng số kỹ thuật để cho ra những tấm h&igrave;nh sắc n&eacute;t, độ chi tiết cao c&ugrave;ng m&agrave;u sắc sống động.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd12.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Trải nghiệm camera \" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd12.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Trải nghiệm camera \" /></a></p>\r\n\r\n<p dir=\"ltr\">Camera trước của m&aacute;y c&oacute; độ ph&acirc;n giải 10 MP với khẩu độ f2.4 được bố tr&iacute; dạng đục lỗ ở ch&iacute;nh giữa m&agrave;n h&igrave;nh cũng tương tự như Galaxy S20, đ&aacute;p ứng tốt nhu cầu chụp ảnh selfie, quay video với chất lượng tốt.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-15-1.jpg\" />Ảnh chụp g&oacute;c si&ecirc;u rộng 0.5x tr&ecirc;n Samsung Galaxy Z Flip</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-14-1.jpg\" />Ảnh chụp g&oacute;c thường 1x tr&ecirc;n Samsung Galaxy Z Flip</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-16-1.jpg\" />Ảnh chụp chế độ zoom 2x tr&ecirc;n Samsung Galaxy Z Flip</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-17-1.jpg\" />Ảnh chụp chế độ zoom 4x tr&ecirc;n&nbsp;Samsung Galaxy Z Flip</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-18-1.jpg\" />Ảnh chụp chế độ zoom 8x tr&ecirc;n&nbsp;Samsung Galaxy Z Flip</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p dir=\"ltr\">Khi gập m&aacute;y lại bạn cũng c&oacute; thể chụp ảnh với m&agrave;n h&igrave;nh phụ k&iacute;ch thước 1.1 inch, thỏa th&iacute;ch trải nghiệm selfie chất lượng với bộ đ&ocirc;i camera k&eacute;p ở mặt sau.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd12-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Trải nghiệm chụp ảnh\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd12-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Trải nghiệm chụp ảnh\" /></a></p>\r\n\r\n<h3 dir=\"ltr\">Hiệu năng đỉnh cao với Snapdragon 855 Plus</h3>\r\n\r\n<p dir=\"ltr\">Samsung Galaxy Z Flip được trang bị con chip mạnh mẽ Snapdragon 855 Plus đi k&egrave;m với m&aacute;y l&agrave; dung lượng RAM 8 GB v&agrave; bộ nhớ trong l&ecirc;n đến 256 GB.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd9-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Điểm Antutu Benchmark\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd9-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Điểm Antutu Benchmark\" /></a></p>\r\n\r\n<p dir=\"ltr\">Mặc d&ugrave; kh&ocirc;ng qu&aacute; nổi trội như so với si&ecirc;u phẩm&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-s20\" target=\"_blank\" title=\"Tham khảo giá điện thoại Samsung Galaxy S20 chính hãng\" type=\"Tham khảo giá điện thoại Samsung Galaxy S20 chính hãng\">Samsung Galaxy S20</a>&nbsp;nhưng vẫn đủ để đảm bảo Z Flip lu&ocirc;n chạy mượt m&agrave; c&aacute;c ứng dụng nặng. Th&ocirc;ng số n&agrave;y cũng thuộc h&agrave;ng top trong thế giới Android đầu 2020.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd3-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Hiệu năng đỉnh cao\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd3-1.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Hiệu năng đỉnh cao\" /></a></p>\r\n\r\n<p dir=\"ltr\">Chiếc m&aacute;y m&agrave;n h&igrave;nh gập của Samsung được trang bị bộ nhớ trong chuẩn UFS 3.0 được đ&aacute;nh gi&aacute; cho tốc độ cực nhanh, c&oacute; thể s&aacute;nh ngang với SSD tr&ecirc;n m&aacute;y t&iacute;nh c&aacute; nh&acirc;n. Tốc độ ổ cứng nhanh kết hợp với vi xử l&yacute; hiệu năng mạnh mẽ g&oacute;p phần l&agrave;m cho m&aacute;y xử l&yacute; mượt m&agrave;, nhanh ch&oacute;ng hơn.</p>\r\n\r\n<p dir=\"ltr\">Với lượng trang bị m&agrave; Samsung Galaxy Z Flip sở hữu dễ d&agrave;ng gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;tốt từ game nhẹ đến nặng ở mức cấu h&igrave;nh max setting m&agrave; kh&ocirc;ng gặp bất cứ trở ngại n&agrave;o.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd9-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Khay sim\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd9-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Khay sim\" /></a></p>\r\n\r\n<p dir=\"ltr\">Galaxy Z Flip được c&agrave;i đặt sẵn hệ điều h&agrave;nh Android 10 t&ugrave;y biến tr&ecirc;n giao diện OneUI 2.0 mới nhất, đồng thời Samsung cũng tối ưu giao điện cho chế độ m&aacute;y gập lại, gập 1 nửa cho người d&ugrave;ng trải nghiệm mới lạ v&agrave; tuyệt vời hơn.</p>\r\n\r\n<h3 dir=\"ltr\">Thời lượng pin tốt đi k&egrave;m sạc kh&ocirc;ng d&acirc;y thời thượng</h3>\r\n\r\n<p dir=\"ltr\">Thời lượng pin cũng l&agrave; điểm mạnh của Samsung Galaxy Z Flip khi được trang bị vi&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd?f=pin-khung-3000-mah\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone pin khủng pin trâu\" type=\"Tham khảo giá điện thoại smartphone pin khủng pin trâu\">pin lớn</a>&nbsp;dung lượng&nbsp;3300 mAh, c&oacute; hỗ trợ c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\" type=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\">sạc nhanh</a>&nbsp;15W gi&uacute;p giảm đ&aacute;ng kể thời gian sạc đầy pin cho m&aacute;y.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd17.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Thời lượng pin tốt \" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd17.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Thời lượng pin tốt \" /></a></p>\r\n\r\n<p dir=\"ltr\">B&ecirc;n cạnh đ&oacute; smartphone Galaxy c&ograve;n được trang bị c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-khong-day\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone hỗ trợ sạc pin không dây\" type=\"Tham khảo giá điện thoại smartphone hỗ trợ sạc pin không dây\">sạc kh&ocirc;ng d&acirc;y</a>&nbsp;hiện đại, kh&aacute; tiện lợi v&agrave; gọn g&agrave;ng kh&ocirc;ng cần phải lo sợ bị đứt d&acirc;y hay r&ograve; rỉ điện như c&aacute;c phương thức sạc truyền thống kh&aacute;c.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\" type=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\">Cảm biến v&acirc;n tay</a>&nbsp;của m&aacute;y được đặt ở cạnh b&ecirc;n, kh&ocirc;ng được t&iacute;ch hợp b&ecirc;n trong m&agrave;n h&igrave;nh đổi lại m&aacute;y lại c&oacute; khả năng nhận diện nhanh v&agrave; ch&iacute;nh x&aacute;c cũng như độ bảo mật cao hơn so với cảm biến v&acirc;n tay trong m&agrave;n h&igrave;nh.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/213022/samsung-galaxy-z-flip-tgdd1-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Z Flip | Cảm biến vân tay\" src=\"https://cdn.tgdd.vn/Products/Images/42/213022/samsung-galaxy-z-flip-tgdd1-2.jpg\" title=\"Điện thoại Samsung Galaxy Z Flip | Cảm biến vân tay\" /></a></p>\r\n\r\n<p dir=\"ltr\">T&oacute;m lại, Galaxy Z Flip l&agrave; sản phẩm mang đẳng cấp kh&aacute;c biệt tiếp theo của Samsung kể từ khi ra mắt chiếc Galaxy Fold. Chiếc m&aacute;y sở hữu đầy đủ c&aacute;c yếu tố: Thời trang, kh&aacute;c lạ, c&ocirc;ng nghệ đỉnh cao.</p>\r\n\r\n<p dir=\"ltr\">Chắc chắn sẽ g&acirc;y hứng th&uacute; với anh em y&ecirc;u c&ocirc;ng nghệ hoặc những ai muốn trở n&ecirc;n thật tự tin khi sở hữu một thiết bị đặc biệt v&agrave; cao cấp so với thế giới c&ograve;n lại.</p>\r\n', '8bfbdf9f70d325e09675a3d0c186b60ed99d7f94.jpg', 46, 0, NULL, 36000000, 'Chính: Dynamic AMOLED, Phụ: Super AMOLED, 6.7\", Quad HD (2K)', 'Android 10', '2 camera 12 MP', '10 MP', 'Snapdragon 855+ 8 nhân', ' 1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '	3300 mAh, có sạc nhanh', '2020-10-31 02:32:30', 1),
(7, 0, 'Điện thoại OPPO Reno4 Pro', 'Description\r\n', '<h3 dir=\"ltr\">Mới đ&acirc;y,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-oppo\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone OPPO chính hãng\" type=\"Tham khảo giá điện thoại smartphone OPPO chính hãng\">OPPO</a>&nbsp;đ&atilde; ch&iacute;nh thức tr&igrave;nh l&agrave;ng chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\" type=\"Tham khảo giá điện thoại smartphone chính hãng\">smartphone</a>&nbsp;mới mang t&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd/oppo-reno4-pro\" target=\"_blank\" title=\"Tham khảo giá điện thoại OPPO Reno4 Pro chính hãng\">OPPO Reno4 Pro</a>. M&aacute;y được trang bị cấu h&igrave;nh v&ocirc; c&ugrave;ng cao cấp với vi xử l&yacute; chip Snapdragon 720G, bộ 4 camera đến 48 MP ấn tượng, c&ugrave;ng c&ocirc;ng nghệ sạc si&ecirc;u nhanh Super VOOC 65 W hướng tới nh&oacute;m kh&aacute;ch h&agrave;ng th&iacute;ch chụp ảnh, chơi game với hiệu năng cao nhưng được b&aacute;n với mức gi&aacute; v&ocirc; c&ugrave;ng tốt.</h3>\r\n\r\n<h3 dir=\"ltr\">Thiết kế tr&agrave;n viền si&ecirc;u ấn tượng</h3>\r\n\r\n<p dir=\"ltr\">OPPO Reno4 Pro được trang bị m&agrave;n h&igrave;nh&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-sieu-tran-vien\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone màn hình siêu tràn viền\" type=\"Tham khảo giá điện thoại smartphone màn hình siêu tràn viền\">si&ecirc;u tr&agrave;n viền</a>&nbsp;k&iacute;ch thước lớn 6.5 inch, tỉ lệ hiển thị l&ecirc;n tới 93.4%, mật độ điểm ảnh đạt ngưỡng 402 ppi, đạt 100% dải m&agrave;u DCI-P3 điều n&agrave;y cho ph&eacute;p h&igrave;nh ảnh hiển thị chi tiết, sắc n&eacute;t v&agrave; sống động nhất.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro9.jpg\" onclick=\"return false;\"><img alt=\"Màn hình siêu tràn viền sắc màu rực rỡ - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro9.jpg\" title=\"Màn hình siêu tràn viền sắc màu rực rỡ - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">B&ecirc;n cạnh đ&oacute;, m&agrave;n h&igrave;nh n&agrave;y c&ograve;n hỗ trợ c&ocirc;ng nghệ HDR10+, tần số qu&eacute;t 90 Hz vượt trội c&ugrave;ng tốc độ lấy mẫu cảm ứng 180 Hz, mang đến cho người d&ugrave;ng những gi&acirc;y ph&uacute;t thư gi&atilde;n trải nghiệm c&aacute;c thước phim m&atilde;n nh&atilde;n hay chơi c&aacute;c tựa game mượt m&agrave;, kh&ocirc;ng bị giật lag.</p>\r\n\r\n<p dir=\"ltr\">Hơn nữa, m&agrave;n h&igrave;nh m&aacute;y được phủ lớp k&iacute;nh bảo vệ cao cấp&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-ve-cac-mat-kinh-cuong-luc-gorilla-glass-1172198#glass5\" target=\"_blank\" title=\"Tìm hiểu về các mặt kính cường lực Gorilla Glass 5\">Gorilla Glass 5</a>, bảo vệ m&aacute;y một c&aacute;ch tối ưu hơn trong qu&aacute; tr&igrave;nh sử dụng trước những t&iacute;nh huống t&aacute;c động va đập hay v&ocirc; t&igrave;nh l&agrave;m rơi m&aacute;y.&nbsp;</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro7.jpg\" onclick=\"return false;\"><img alt=\"Sở hữu lớp kính cường lực Gorilla Glass 6 - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro7.jpg\" title=\"Sở hữu lớp kính cường lực Gorilla Glass 6 - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">Một t&iacute;nh năng m&agrave; người d&ugrave;ng sẽ v&ocirc; c&ugrave;ng th&iacute;ch tr&ecirc;n OPPO Reno4 Pro ch&iacute;nh l&agrave; t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\">bảo mật v&acirc;n tay</a>&nbsp;quang học dưới m&agrave;n h&igrave;nh hiện đại. Nhờ đ&oacute;, bạn chỉ cần thao t&aacute;c một chạm nhẹ nh&agrave;ng để mở kh&oacute;a m&agrave;n h&igrave;nh, nhanh ch&oacute;ng v&agrave; cực đơn giản.&nbsp;</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro11.jpg\" onclick=\"return false;\"><img alt=\"Vân tay dưới màn hiện đại cao cấp - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro11.jpg\" title=\"Vân tay dưới màn hiện đại cao cấp - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ngo&agrave;i ra bạn cũng c&oacute; thể sử dụng th&ecirc;m t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-khuon-mat\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone có bảo mật mở khoá khuôn mặt\" type=\"Tham khảo giá điện thoại smartphone có bảo mật mở khoá khuôn mặt\">nhận diện bằng khu&ocirc;n</a>&nbsp;mặt cũng kh&ocirc;ng k&eacute;m phần hấp dẫn.&nbsp;</p>\r\n\r\n<h3 dir=\"ltr\">Bộ 4 camera si&ecirc;u n&eacute;t, chống rung ấn tượng</h3>\r\n\r\n<p dir=\"ltr\">OPPO Reno4 Pro được trang bị bộ 4 camera sau gồm: cảm biến ch&iacute;nh si&ecirc;u n&eacute;t 48 MP chống rung điện tử EIS, c&ugrave;ng&nbsp;c&aacute;c camera hỗ trợ 8 MP - 2 MP - 2 MP cho bức ảnh lung linh ở nhiều g&oacute;c chụp như ch&acirc;n dung, g&oacute;c rộng, zoom v&agrave; cả khi chụp đ&ecirc;m cũng rất xịn v&agrave; mịn.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-303620-023643.jpg\" />Camera g&oacute;c rộng 119˚ - OPPO Reno4 Pro</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-303620-023638.jpg\" />Camera g&oacute;c thường - OPPO Reno4 Pro</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-303620-023633.jpg\" />Camera zoom 2x - OPPO Reno4 Pro</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-303620-023629.jpg\" />Camera zoom 5x - OPPO Reno4 Pro</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p dir=\"ltr\">Với OPPO Reno4 Pro, chắc chắn chinh phục bạn với những video 4K sắc n&eacute;t đỉnh cao, được hỗ trợ bằng c&ocirc;ng nghệ si&ecirc;u chống rung thế hệ thứ ba, đảm bảo bạn c&oacute; những thước phim với chất lượng tuyệt hảo.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro5.jpg\" onclick=\"return false;\"><img alt=\"Sở hữu cụm 4 camera sau - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro5.jpg\" title=\"Sở hữu cụm 4 camera sau - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p>Ngo&agrave;i ra, OPPO Reno4 Pro c&ograve;n được trang bị c&ocirc;ng nghệ AI lấy n&eacute;t bằng laser cực nhanh v&agrave; ch&iacute;nh x&aacute;c, t&iacute;ch hợp bộ chỉnh sửa video th&ocirc;ng minh, bạn c&oacute; thể cắt gh&eacute;p, th&ecirc;m hiệu ứng để những video tuyệt vời hơn bao giờ hết.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro-selfie1.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp selfie - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-selfie1.jpg\" title=\"Ảnh chụp selfie - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">Mặt trước, m&aacute;y được trang bị camera selfie đơn 32 MP được t&iacute;ch hợp h&agrave;ng loạt c&aacute;c t&iacute;nh năng chụp ảnh th&ocirc;ng minh nhất định sẽ kh&ocirc;ng l&agrave;m người d&ugrave;ng thất vọng trong c&aacute;c chuyến đi chơi tập thể, chụp ảnh nh&oacute;m đ&ocirc;ng người hay ảnh quang cảnh g&oacute;c rộng,...</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro-selfie2.jpg\" onclick=\"return false;\"><img alt=\"Trang bị chế độ làm đẹp nổi tiếng - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-selfie2.jpg\" title=\"Trang bị chế độ làm đẹp nổi tiếng - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<h3 dir=\"ltr\">Hiệu năng mạnh mẽ, chiến game cực đ&atilde;</h3>\r\n\r\n<p dir=\"ltr\">OPPO Reno4 Pro được trang bị cấu h&igrave;nh phần cứng mạnh mẽ khi sở hữu sức mạnh chip Snapdragon 720G đến từ nh&agrave; sản xuất Qualcomm vừa cho ph&eacute;p thiết bị tối ưu h&oacute;a c&ocirc;ng suất hoạt động, vừa mang đến hiệu quả tiết kiệm điện năng tối đa.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro8.jpg\" onclick=\"return false;\"><img alt=\"Khe sim kép và thẻ nhớ của OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro8.jpg\" title=\"Khe sim kép và thẻ nhớ của OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">Đi k&egrave;m với đ&oacute; l&agrave; dung lượng bộ nhớ RAM khủng l&ecirc;n tới 8 GB cho bạn thoải m&aacute;i sử dụng đa nhiệm, chuyển c&aacute;c ứng dụng một c&aacute;ch mượt m&agrave; kh&ocirc;ng hề xảy ra hiện tượng giật lag.</p>\r\n\r\n<p dir=\"ltr\">Hơn thế nữa bộ nhớ trong lớn đảm bảo khả năng lưu trữ được nhiều dữ liệu, h&igrave;nh ảnh, video hay c&agrave;i đặt c&aacute;c ứng dụng nặng. Với hiệu năng tr&ecirc;n th&igrave; khi kiểm tra bằng ứng dụng Antutu th&igrave; m&aacute;y đạt 272.278 điểm gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;đồ hoạ cao cũng kh&ocirc;ng th&agrave;nh vấn&nbsp;đề.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro-303620-023648.jpg\" onclick=\"return false;\"><img alt=\"Điểm Antutu - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-303620-023648.jpg\" title=\"Điểm Antutu - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ugrave;ng với đ&oacute;, Qualcomm c&ograve;n tối ưu Snapdragon 720G gi&uacute;p n&oacute; xử l&yacute; th&ocirc;ng tin đồ họa tốt hơn, nhất l&agrave; khi được đồng bộ h&oacute;a c&ugrave;ng GPU Adreno 620 tr&ecirc;n hệ điều h&agrave;nh&nbsp;<a href=\"https://www.thegioididong.com/dtdd?g=android\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone Android chính hãng\">Android</a>&nbsp;thế hệ thứ 10, cụ thể hơn l&agrave; giao diện ColorOS 7.2 để mang tới những trải nghiệm tuyệt vời nhất cho người d&ugrave;ng.</p>\r\n\r\n<h3 dir=\"ltr\">C&ocirc;ng nghệ sạc si&ecirc;u tốc 65 W</h3>\r\n\r\n<p dir=\"ltr\">Th&ecirc;m một đặc trưng đ&aacute;ng ch&uacute; &yacute; v&agrave; đắt gi&aacute;, ghi điểm kh&aacute;c tr&ecirc;n Reno4 Pro thu h&uacute;t đặc biệt đối với c&aacute;c game thủ l&agrave;: Thời lượng pin 4000 mAh ti&ecirc;u chuẩn đủ đ&aacute;p ứng trải nghiệm trọn vẹn suốt cả ng&agrave;y d&agrave;i chỉ sau một lần sạc.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro6.jpg\" onclick=\"return false;\"><img alt=\"Có dung lượng pin ổn để sử dụng cả ngày - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro6.jpg\" title=\"Có dung lượng pin ổn để sử dụng cả ngày - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo điện thoại sạc pin nhanh tại Thegioididong.com\">sạc pin nhanh</a>&nbsp;si&ecirc;u tốc 65 W cao nhất tr&ecirc;n c&aacute;c thiết bị smartphone hiện đại (t&iacute;nh đến 07/2020), người d&ugrave;ng c&oacute; thể nạp từ 0% l&ecirc;n 100% pin chỉ với 36 ph&uacute;t, từ 0% l&ecirc;n 60% chỉ trong vỏn vẹn 15 ph&uacute;t.&nbsp;</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/223497/oppo-reno4-pro-sacnhanh.jpg\" onclick=\"return false;\"><img alt=\"Trang bị sạc nhanh đến 65W - OPPO Reno4 Pro\" src=\"https://cdn.tgdd.vn/Products/Images/42/223497/oppo-reno4-pro-sacnhanh.jpg\" title=\"Trang bị sạc nhanh đến 65W - OPPO Reno4 Pro\" /></a></p>\r\n\r\n<p dir=\"ltr\">T&iacute;nh năng n&agrave;y thực sự qu&aacute; tuyệt vời v&agrave; thiết thực đối với những người d&ugrave;ng c&oacute; nhu cầu sử dụng cao, mật độ li&ecirc;n hệ c&ocirc;ng việc d&agrave;y đặc v&agrave; nhất l&agrave; những ai phải thường xuy&ecirc;n di chuyển b&ecirc;n ngo&agrave;i.&nbsp;</p>\r\n\r\n<p dir=\"ltr\">Tổng kết, với ưu điểm cấu h&igrave;nh được trang bị gồm: chip Snapdragon 720G, camera si&ecirc;u n&eacute;t chống rung si&ecirc;u ấn tượng, sạc nhanh 65W si&ecirc;u tốc c&ugrave;ng m&agrave;n h&igrave;nh tr&agrave;n viền 90 Hz si&ecirc;u n&eacute;t,&hellip; c&oacute; thể n&oacute;i chiếc điện thoại OPPO Reno4 Pro quả thực l&agrave; si&ecirc;u phẩm c&ocirc;ng nghệ khiến người d&ugrave;ng phải lưu t&acirc;m.</p>\r\n', '6d750b30703af273ae30be7eb96e082a3aca1609.jpg', 60, 0, NULL, 11990000, 'AMOLED, 6.5\", Full HD+', 'Android 10', 'Chính 48 MP & Phụ 8 MP, 2 MP, 2 MP', '32 MP', 'Snapdragon 720G 8 nhân', '2 Nano SIM, Hỗ trợ 4G', '4000 mAh, có sạc nhanh', '2020-10-31 02:51:20', 0);
INSERT INTO `phones` (`id`, `brand_id`, `name`, `description`, `content`, `thumb`, `stock`, `promotion_id`, `video`, `price`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`, `battery`, `date_created`, `is_featured`) VALUES
(8, 0, 'Điện thoại iPhone SE 256GB (2020)', 'Description\r\n', '<h2>Đặc điểm nổi bật của iPhone SE 256GB (2020)</h2>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/222631/Slider/vi-vn-iphone-se-256gb-2020.jpg\" /><img src=\"https://www.thegioididong.com/Content/desktop/images/V4/icon-yt.png\" /></p>\r\n\r\n<p>Bộ sản phẩm chuẩn: Hộp, Sạc, Tai nghe, S&aacute;ch hướng dẫn, C&aacute;p, C&acirc;y lấy sim</p>\r\n\r\n<h2><a href=\"https://www.thegioididong.com/dtdd/iphone-se-256gb-2020\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone SE 256GB 2020 chính hãng tại Thegioididong.com \" type=\"Tham khảo giá điện thoại iPhone SE 256GB 2020 chính hãng tại Thegioididong.com\">iPhone SE 256GB 2020</a>&nbsp;cuối c&ugrave;ng đ&atilde; được&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo giá điện thoại Apple iPhone chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại Apple iPhone chính hãng tại Thegioididong.com\">Apple</a>&nbsp;ra mắt, với ngoại h&igrave;nh nhỏ gọn được sao ch&eacute;p từ&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-8-256gb\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 8 256GB chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 8 256GB chính hãng tại Thegioididong.com\">iPhone 8</a>&nbsp;nhưng mang trong m&igrave;nh một hiệu năng mạnh mẽ với vi xử l&yacute; A13 Bionic, mức gi&aacute; hấp dẫn hứa hẹn sẽ l&agrave; yếu tố &ldquo;h&uacute;t kh&aacute;ch&rdquo; của&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại, smartphone chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại, smartphone chính hãng tại Thegioididong.com\">smartphone</a>&nbsp;đ&igrave;nh đ&aacute;m đến từ nh&agrave; T&aacute;o khuyết.</h2>\r\n\r\n<h3>Gọn nhẹ chắc chắn thoải m&aacute;i sử dụng</h3>\r\n\r\n<p>iPhone SE 2020 c&oacute; thiết kế kh&aacute; nhỏ b&eacute; khi đặt cạnh c&aacute;c smartphone&nbsp;<a href=\"https://www.thegioididong.com/dtdd-tu-6-inch\" target=\"_blank\" title=\"Tham khảo giá các mẫu điện thoại có màn hình khủng từ 6 inch trở lên tại Thegioididong.com\" type=\"Tham khảo giá các mẫu điện thoại có màn hình khủng từ 6 inch trở lên tại Thegioididong.com\">m&agrave;n h&igrave;nh khủng</a>&nbsp;hiện nay, nhưng với những ai kh&ocirc;ng th&iacute;ch kiểu&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-tran-vien\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có màn hình tràn viền tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có màn hình tràn viền tại Thegioididong.com\">thiết kế tr&agrave;n viền</a>&nbsp;v&agrave; m&agrave;n h&igrave;nh lớn, th&igrave; đ&acirc;y sẽ l&agrave; lựa chọn tốt nhất cho họ.</p>\r\n\r\n<p>Với m&agrave;n h&igrave;nh 4.7 inch, viền m&agrave;n h&igrave;nh kh&aacute; d&agrave;y, c&ugrave;ng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có cảm biến vân tay tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có cảm biến vân tay tại Thegioididong.com\">cảm biến v&acirc;n tay</a>&nbsp;Touch ID, c&aacute;c cạnh bo cong ho&agrave;n hảo, iPhone SE 2020 mang lại cảm gi&aacute;c cầm nắm quen thuộc,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-nho-gon\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có kích thước nhỏ dễ cầm tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có kích thước nhỏ dễ cầm tại Thegioididong.com\">k&iacute;ch thước nhỏ gọn</a>&nbsp;để bạn sử dụng 1 tay một c&aacute;ch dễ d&agrave;ng.</p>\r\n\r\n<p>Chiếc điện thoại mới nh&agrave; T&aacute;o trang bị m&agrave;n h&igrave;nh Retina 4.7 inch, tuy chỉ c&oacute; độ ph&acirc;n giải HD nhưng vẫn cho chất lượng hiển thị tốt với c&ocirc;ng nghệ True Tone tự c&acirc;n chỉnh m&agrave;u theo m&ocirc;i trường xung quanh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-20206.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Màn hình Rentina sắc nét màu sắc chuẩn xác dù độ phân giải HD\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-20206.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Màn hình Rentina sắc nét màu sắc chuẩn xác dù độ phân giải HD\" /></a></p>\r\n\r\n<p>Cũng giống như thế hệ&nbsp;<a href=\"https://thegioididong.com/dtdd/iphone-7\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 7 chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 7 chính hãng tại Thegioididong.com\">iPhone 7</a>&nbsp;v&agrave; iPhone 8, iPhone SE 2020 vẫn trang bị n&uacute;t home cảm ứng lực phản hồi rung quen thuộc, t&iacute;ch hợp cảm biến v&acirc;n tay Touch ID thế hệ thứ 2 cho tốc độ nhận diện nhanh v&agrave; cực kỳ ch&iacute;nh x&aacute;c d&ugrave; chỉ chạm nhẹ.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-20205.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Cảm biến vân tay Touch ID thế hệ 2, nhanh và chính xác\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-20205.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Cảm biến vân tay Touch ID thế hệ 2, nhanh và chính xác\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute;, mẫu điện thoại iPhone rẻ c&ograve;n c&oacute; khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có tính năng chống nước chống bụi tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có tính năng chống nước chống bụi tại Thegioididong.com\">chống nước</a>&nbsp;IP67 hạn chế rủi ro khi rơi v&agrave;o nước hay đi mưa, chiếc điện thoại c&ograve;n c&oacute; thể&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-khong-day\" target=\"_blank\" title=\"Tham khảo các mẫu smartphone có tính năng sạc không dây tại Thegioididong.com\" type=\"Tham khảo các mẫu smartphone có tính năng sạc không dây tại Thegioididong.com\">sạc kh&ocirc;ng d&acirc;y</a>&nbsp;qua mặt lưng k&iacute;nh ph&iacute;a sau kh&aacute; tiện lợi.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-2020-223220-013217.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Chuẩn chống nước IP67\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-2020-223220-013217.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Chuẩn chống nước IP67\" /></a></p>\r\n\r\n<h3>Cấu h&igrave;nh v&ocirc; địch trong tầm gi&aacute;</h3>\r\n\r\n<p>C&oacute; thể n&oacute;i, trong tầm gi&aacute; hiện tại hầu như kh&ocirc;ng một chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd?g=android\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại, smartphone Android chính hãng tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại, smartphone Android chính hãng tại Thegioididong.com\">điện thoại Android</a>&nbsp;n&agrave;o c&oacute; hiệu năng vượt mặt iPhone SE.</p>\r\n\r\n<p>D&ugrave; ngoại h&igrave;nh kh&aacute; nhỏ gọn, nhưng b&ecirc;n trong iPhone SE 2020 l&agrave; một cấu h&igrave;nh &ldquo;khủng long&rdquo; với vi xử l&yacute; Bionic A13, cho ph&eacute;p m&aacute;y hoạt động cực kỳ nhanh ch&oacute;ng v&agrave; mượt m&agrave;, thậm ch&iacute; trong một số trường hợp c&ograve;n nhanh hơn cả&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone 11 chính hãng tại Thegioididong.com\" type=\"Tham khảo điện thoại iPhone 11 chính hãng tại Thegioididong.com\">iPhone 11</a>&nbsp;hay&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 11 Pro chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 11 Pro chính hãng tại Thegioididong.com\">iPhone 11 Pro</a>.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-2020-131420-111401.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Giải trí chơi game cực mượt mà\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-2020-131420-111401.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Giải trí chơi game cực mượt mà\" /></a></p>\r\n\r\n<p>Đo hiệu năng AnTuTu, iPhone SE 2020 đạt số điểm364.049 điểm, với th&ocirc;ng số n&agrave;y gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;tốt hơn cũng như&nbsp;tự tin chiến h&agrave;ng loạt tựa game đồ họa khủng hiện nay, m&agrave; kh&ocirc;ng gặp bất cứ t&igrave;nh trạng giật rớt khung h&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-2020-203320-053311.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 2020 sau khi đo hiệu năng\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-2020-203320-053311.jpg\" title=\"Điện thoại iPhone SE 2020 sau khi đo hiệu năng\" /></a></p>\r\n\r\n<p>Ngo&agrave;i hiệu năng si&ecirc;u khủng, th&igrave; ri&ecirc;ng với phi&ecirc;n bản 256 GB sẽ mang đến cho bạn một kh&ocirc;ng gian lưu trữ kh&aacute; thoải m&aacute;i, ở những mẫu điện thoại kh&ocirc;ng hỗ trợ&nbsp;<a href=\"https://www.thegioididong.com/the-nho-dien-thoai\" target=\"_blank\" title=\"Tham khảo phụ kiện thẻ nhớ điện thoại chất lượng bảo hành 1 đổi 1 tại Thegioididong.com\" type=\"Tham khảo phụ kiện thẻ nhớ điện thoại chất lượng bảo hành 1 đổi 1 tại Thegioididong.com\">thẻ nhớ</a>&nbsp;như iPhone th&igrave; dung lượng bộ nhớ lớn l&agrave; điều thật sự cần thiết.</p>\r\n\r\n<h3>Một camera vẫn x&oacute;a ph&ocirc;ng mượt m&agrave;</h3>\r\n\r\n<p>Tuy chỉ trang bị vỏn vẹn 1 camera ở ph&iacute;a sau v&agrave; 1 ph&iacute;a trước, nhưng iPhone SE 2020 l&agrave; điện thoại một camera sau tốt nhất hiện nay ở thời điểm hiện tại.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-20203.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Chụp ảnh bằng camera thường\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-20203.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Chụp ảnh bằng camera thường\" /></a></p>\r\n\r\n<p>Chất ảnh từ camera sau 12 MP rất tốt, thu v&agrave; t&aacute;i tạo được nhiều chi tiết, dải nhạy s&aacute;ng rộng. B&ecirc;n cạnh đ&oacute;, chip A13 Bionic cho ph&eacute;p thiết bị k&iacute;ch hoạt chế độ Smart HDR hỗ trợ chụp một loạt bức ảnh, d&ugrave;ng c&ocirc;ng nghệ Semantic rendering để ph&acirc;n t&iacute;ch m&agrave;u sắc, &aacute;nh s&aacute;ng từ đ&oacute; cho ra bức ảnh tốt nhất.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-2020-251720-091756.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Ảnh chụp camera sau 12 MP\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-2020-251720-091756.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Ảnh chụp camera sau 12 MP\" /></a></p>\r\n\r\n<p>Kh&ocirc;ng chỉ camera sau, m&agrave; camera trước của iPhone SE 2020 cũng cho ra những tấm ảnh selfie đẹp ấn tượng, nước da được xử l&yacute; mịn m&agrave;ng hơn trước rất nhiều.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-2020-251620-091611.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Ảnh chụp camera selfie 7 MP\" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-2020-251620-091611.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Ảnh chụp camera selfie 7 MP\" /></a></p>\r\n\r\n<p>Với c&ocirc;ng nghệ đặc biệt của m&igrave;nh, Apple cho biết cả camera trước v&agrave; sau tr&ecirc;n iPhone SE 2020 c&oacute; thể&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-xoa-phong\" target=\"_blank\" title=\"Tham khảo giá điện thoại có camera xóa phông tại Thegioididong.com\" type=\"Tham khảo giá điện thoại có camera xóa phông tại Thegioididong.com\">x&oacute;a ph&ocirc;ng</a>&nbsp;ch&iacute;nh x&aacute;c một c&aacute;ch tự nhi&ecirc;n kh&ocirc;ng thua k&eacute;m chiếc điện thoại n&agrave;o c&oacute; 2 ống k&iacute;nh trở l&ecirc;n.</p>\r\n\r\n<h3>Pin đủ d&ugrave;ng, hỗ trợ sạc nhanh</h3>\r\n\r\n<p>Trang bị mức dung lượng pin kh&aacute; &iacute;t ỏi chỉ 1821 mAh n&ecirc;n thời lượng pin tr&ecirc;n iPhone SE 2020 kh&ocirc;ng qu&aacute; ấn tượng, với những t&aacute;c vụ nhẹ nh&agrave;ng cơ bản, chiếc iPhone vẫn c&oacute; thể hoạt động vừa vặn một ng&agrave;y.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/222631/iphone-se-256gb-2020-130320-100344.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone SE 256GB (2020) | Sạc pin nhanh 18W qua cổng Lightning \" src=\"https://cdn.tgdd.vn/Products/Images/42/222631/iphone-se-256gb-2020-130320-100344.jpg\" title=\"Điện thoại iPhone SE 256GB (2020) | Sạc pin nhanh 18W qua cổng Lightning \" /></a></p>\r\n\r\n<p>B&ugrave; lại, thiết bị sẽ c&oacute; hỗ trợ<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" title=\"Tham khảo điện thoại sạc pin nhanh tại Thegioididong.com\">&nbsp;sạc pin nhanh</a>&nbsp;18 W, gi&uacute;p r&uacute;t ngắn tối đa thời gian sạc pin. Tuy nhi&ecirc;n, để sử dụng t&iacute;nh năng n&agrave;y, người d&ugrave;ng cần mua th&ecirc;m bộ sạc 18 W hoặc sử dụng chung bộ sạc của iPhone 11 hoặc 11 Pro.</p>\r\n\r\n<p>Để c&oacute; thể sử dụng chiếc iPhone SE 2020 thoải m&aacute;i hơn, bạn n&ecirc;n sắm th&ecirc;m&nbsp;<a href=\"https://www.thegioididong.com/sac-dtdd\" target=\"_blank\" title=\"Tham khảo giá phụ kiện pin sạc dự phòng tại Thegioididong,com\" type=\"Tham khảo giá phụ kiện pin sạc dự phòng tại Thegioididong,com\">pin sạc dự ph&ograve;ng</a>&nbsp;để cấp năng lượng cho dế y&ecirc;u của m&igrave;nh khi cần thiết.</p>\r\n\r\n<p>Sở hữu h&agrave;ng loạt c&ocirc;ng nghệ khủng, vi xử l&yacute; mới nhất đến từ h&atilde;ng điện danh tiếng bậc nhất Apple, nhưng iPhone SE 2020 lại g&acirc;y cho&aacute;ng ngợp bởi mức gi&aacute; hấp dẫn, tiếp tục sẽ l&agrave; model b&aacute;n chạy tiếp theo của Apple trong thời gian sắp tới.</p>\r\n', 'f49fcb39716cbcfc5447cee4c35628daa0df0064.jpg', 26, 0, NULL, 17990000, 'IPS LCD, 4.7\"', 'iOS 13', ' 12 MP', '7 MP', 'Apple A13 Bionic 6 nhân', ' 1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '	1821 mAh, có sạc nhanh', '2020-10-31 03:38:13', 0),
(9, 0, 'Điện thoại Vivo V19', 'Description\r\n', '<h2><a href=\"https://www.thegioididong.com/dtdd/vivo-v19\" target=\"_blank\" title=\"Tham khảo thông tin chi tiết về điện thoại Vivo V19 tại thegioididong.com\" type=\"Tham khảo thông tin chi tiết về điện thoại Vivo V19 tại thegioididong.com\">Vivo V19</a>&nbsp;l&agrave; mẫu&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá các mẫu điện thoại chính hãng đang bán tại thegioididong.com\" type=\"Tham khảo giá các mẫu điện thoại chính hãng đang bán tại thegioididong.com\">smartphone</a>&nbsp;tầm trung ra mắt v&agrave;o đầu năm 2020 của&nbsp;<a href=\"https://www.thegioididong.com/dtdd-vivo\" target=\"_blank\" title=\"Tham khảo giá các dòng smartphone Vivo chính hãng đang bán tại thegioididong.com\" type=\"Tham khảo giá các dòng smartphone Vivo chính hãng đang bán tại thegioididong.com\">Vivo</a>. Thiết bị ghi điểm ở thiết kế&nbsp;thời trang, khả năng chụp ảnh đ&ecirc;m ấn tượng, cụm 4 camera đa dụng v&agrave; c&ocirc;ng nghệ sạc nhanh vượt trội 33W.</h2>\r\n\r\n<h3>Thiết kế nổi bật, trải nghiệm h&igrave;nh ảnh kh&ocirc;ng giới hạn</h3>\r\n\r\n<p>Vivo V19 sở hữu một thiết kế hiện đại bắt kịp xu hướng smartphone mới hiện nay. Mặt trước l&agrave; một m&agrave;n h&igrave;nh tr&agrave;n viền chuẩn mực với&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\" type=\"Tham khảo giá điện thoại smartphone có bảo mật cảm biến vân tay\">bảo mật v&acirc;n tay</a>&nbsp;đặt dưới m&agrave;n h&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-den-4-org-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Mặt trước\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-den-4-org-2.jpg\" title=\"Điện thoại Vivo V19 | Mặt trước\" /></a></p>\r\n\r\n<p>Cụm camera sau h&igrave;nh chữ L nổi bật, mặt lưng b&oacute;ng bẩy với gam m&agrave;u trung t&iacute;nh. Kiểu thiết kế n&agrave;y kh&aacute; &quot;hợp thời&quot; v&agrave; đang được ứng dụng rất nhiều tr&ecirc;n cả smartphone cao cấp lẫn phổ th&ocirc;ng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-den-5-org-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Mặt sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-den-5-org-2.jpg\" title=\"Điện thoại Vivo V19 | Mặt sau\" /></a></p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/dtdd?p=tu-4-7-trieu\" target=\"_blank\" title=\"Tham khảo điện thoại tầm trung chính hãng tại Thế Giới Di Động\">Điện thoại tầm trung</a>&nbsp;của&nbsp;<a href=\"https://www.thegioididong.com/dtdd-vivo\" target=\"_blank\" title=\"Tham khảo giá các dòng smartphone Vivo chính hãng đang bán tại thegioididong.com\" type=\"Tham khảo giá các dòng smartphone Vivo chính hãng đang bán tại thegioididong.com\">Vivo</a>&nbsp;được trang bị m&agrave;n h&igrave;nh Super AMOLED độ ph&acirc;n giải Full HD+, k&iacute;ch thước 6.44 inch.&nbsp;Tỷ lệ khung h&igrave;nh 20:9 tăng trải nghiệm chơi game 3D hay xem video chất lượng cao.</p>\r\n\r\n<p>C&ocirc;ng nghệ Super AMOLED độ ph&acirc;n giải Full HD+ tr&ecirc;n Vivo V19 cho chất lượng hiển thị sống động, m&agrave;u đen s&acirc;u c&ugrave;ng khả năng tiết kiệm năng lượng hơn thế hệ trước.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-den-10-org-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Trên tay\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-den-10-org-2.jpg\" title=\"Điện thoại Vivo V19 | Trên tay\" /></a></p>\r\n\r\n<p>Phần camera &ldquo;nốt ruồi&rdquo; si&ecirc;u nhỏ 32 MP c&ugrave;ng cảm biến v&acirc;n tay được đặt ẩn trong m&agrave;n h&igrave;nh, cho ph&eacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-tran-vien\" target=\"_blank\" title=\"Tham khảo các mẫu smartphone tràn viền tại thegioididong.com\" type=\"Tham khảo các mẫu smartphone tràn viền tại thegioididong.com\">m&agrave;n h&igrave;nh tr&agrave;n viền</a>&nbsp;tối đa ra c&aacute;c cạnh. V&igrave; thế, d&ugrave; trang bị m&agrave;n h&igrave;nh lớn nhưng Vivo V19 lại kh&aacute; thanh tho&aacute;t, nhỏ gọn.</p>\r\n\r\n<h3>4 camera ấn tượng, chụp đ&ecirc;m cực chất</h3>\r\n\r\n<p>Điểm ăn kh&aacute;ch ở Vivo V19 nằm ở cụm 4 camera sau với thiết kế chữ L nhỏ gọn c&acirc;n đối khiến tổng thể m&aacute;y kh&ocirc;ng bị th&ocirc; cứng.&nbsp;</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-den-6-org-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Cụm camera\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-den-6-org-2.jpg\" title=\"Điện thoại Vivo V19 | Cụm camera\" /></a></p>\r\n\r\n<p>Th&ocirc;ng số của 4 camera theo thứ tự bao gồm 1 camera ch&iacute;nh độ ph&acirc;n giải khủng 48 MP cho chất lượng si&ecirc;u n&eacute;t, camera&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo các smartphone có camera góc rộng tại thegioididong.com\" type=\"Tham khảo các smartphone có camera góc rộng tại thegioididong.com\">g&oacute;c si&ecirc;u rộng</a>&nbsp;8 MP hỗ trợ chụp to&agrave;n cảnh, camera macro 2 MP chục cận cảnh độc đ&aacute;o, v&agrave; cuối c&ugrave;ng l&agrave; ống k&iacute;nh hỗ trợ đo chiều s&acirc;u cho t&iacute;nh năng chụp&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-xoa-phong\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có hỗ trợ chụp xóa phông tại thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có hỗ trợ chụp xóa phông tại thegioididong.com\">x&oacute;a ph&ocirc;ng</a>.&nbsp;</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-hinh--2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Ảnh chụp bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-hinh--2.jpg\" title=\"Điện thoại Vivo V19 | Ảnh chụp bằng camera sau\" /></a></p>\r\n\r\n<p>Ở ph&iacute;a trước, Vivo V19 được trang bị camera nốt ruồi k&eacute;p với độ ph&acirc;n giải 32 MP v&agrave; 8 MP ở mặt trước, chụp ảnh selfie si&ecirc;u n&eacute;t, selfie g&oacute;c rộng. Hơn nữa camera trước c&ograve;n nhận diện gương mặt chủ nh&acirc;n nhanh ch&oacute;ng nhằm tăng khả năng bảo mật cho thiết bị của bạn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-goc-ring-1.gif\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Selfie góc rộng\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-goc-ring-1.gif\" title=\"Điện thoại Vivo V19 | Selfie góc rộng\" /></a></p>\r\n\r\n<p>Về t&iacute;nh năng camera, cả camera trước v&agrave; sau của Vivo V19 đều đi k&egrave;m nhiều chế độ chụp ảnh đa dạng, đặc biệt l&agrave; chế độ Super Night Mode c&oacute; t&aacute;c dụng t&aacute;i tạo m&agrave;u sắc trong điều kiện thiếu s&aacute;ng, mang đến những bức ảnh chụp đ&ecirc;m đẹp v&agrave; r&otilde; r&agrave;ng c&aacute;c chi tiết.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-hinh-4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Ảnh chụp đêm\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-hinh-4.jpg\" title=\"Điện thoại Vivo V19 | Ảnh chụp đêm\" /></a></p>\r\n\r\n<p>Để chụp selfie đ&ecirc;m tốt hơn, Vivo cũng trang bị chế độ &quot;V&ograve;ng tr&ograve;n b&ugrave; s&aacute;ng&quot; để phản chiếu &aacute;nh s&aacute;ng từ m&agrave;n h&igrave;nh đến người chụp, cho ra bức ảnh rạng rỡ hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-hinh-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Ảnh chụp selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-hinh-1.jpg\" title=\"Điện thoại Vivo V19 | Ảnh chụp selfie\" /></a></p>\r\n\r\n<h3>Cấu h&igrave;nh mạnh mẽ, sạc si&ecirc;u nhanh 33W</h3>\r\n\r\n<p>Vivo V19 c&oacute; một cấu h&igrave;nh kh&aacute; tốt với xử l&yacute; Snapdragon 712&nbsp;8 nh&acirc;n, dung lượng RAM 8 GB gi&uacute;p xử l&yacute; c&aacute;c t&aacute;c vụ h&agrave;ng ng&agrave;y mượt m&agrave;, trơn tru,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;ở mức kh&aacute; tốt.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Đo hiệu năng CPU bằng phần mềm GeekBench 5\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-.jpg\" title=\"Điện thoại Vivo V19 | Đo hiệu năng CPU bằng phần mềm GeekBench 5\" /></a></p>\r\n\r\n<p>Đo hiệu năng CPU bằng phần mềm GeekBench 5.</p>\r\n\r\n<p>Mẫu điện thoại nh&agrave; Vivo c&oacute; dung lượng bộ nhớ l&agrave; 128 GB, đồng thời hỗ trợ&nbsp;<a href=\"https://www.thegioididong.com/the-nho-dien-thoai-micro-sd\" target=\"_blank\" title=\"Tham khảo giá phụ kiện thẻ nhớ Micro SD cho điện thoại tại thegioididong.com \" type=\"Tham khảo giá phụ kiện thẻ nhớ Micro SD cho điện thoại tại thegioididong.com\">thẻ nhớ Micro SD</a>&nbsp;mở rộng l&ecirc;n đến 256 GB, kh&aacute; dư dả để bạn c&agrave;i đặt c&aacute;c ứng dụng hoặc lưu trữ file, nhạc, h&igrave;nh t&ugrave;y &yacute;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-den-9-org-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Khe đựng SIM\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-den-9-org-2.jpg\" title=\"Điện thoại Vivo V19 | Khe đựng SIM\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute;, m&aacute;y được c&agrave;i đặt sẵn Android 10 c&ugrave;ng giao diện Funtouch OS 10 mới nhất hỗ trợ nhiều t&iacute;nh năng tối ưu d&agrave;nh ri&ecirc;ng cho điện thoại tr&agrave;n viền.</p>\r\n\r\n<p>Vivo V19 được trang bị pin 4.500 mAh hỗ trợ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có hỗ trợ sạc nhanh trên thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có hỗ trợ sạc nhanh trên thegioididong.com\">sạc si&ecirc;u nhanh</a>&nbsp;33W th&ocirc;ng qua cổng USB Type-C, V19 c&oacute; thể sử dụng được hơn 1 ng&agrave;y m&agrave; kh&ocirc;ng cần sạc lại, thời gian chờ để sạc đầy của chiếc m&aacute;y cũng kh&ocirc;ng khiến bạn phải chờ l&acirc;u.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/217859/vivo-v19-den-8-org-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Vivo V19 | Cạnh dưới\" src=\"https://cdn.tgdd.vn/Products/Images/42/217859/vivo-v19-den-8-org-2.jpg\" title=\"Điện thoại Vivo V19 | Cạnh dưới\" /></a></p>\r\n', 'e4418f43cdc8574f55346c71667da8408058a47e.jpg', 60, 0, NULL, 7990000, 'Super AMOLED, 6.44\", Full HD+', 'Android 10', 'Chính 48 MP & Phụ 8 MP, 2 MP, 2 MP', 'Chính 32 MP & Phụ 8 MP', 'Snapdragon 712 8 nhân', '2 Nano SIM, Hỗ trợ 4G', '4500 mAh, có sạc nhanh', '2020-10-31 07:21:22', 0),
(10, 0, 'Điện thoại iPhone 11 Pro Max 512GB', 'Description\r\n', '<h2>Để t&igrave;m kiếm một chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\">smartphone</a>&nbsp;c&oacute; hiệu năng mạnh mẽ v&agrave; c&oacute; thể sử dụng mượt m&agrave; trong 2-3 năm tới th&igrave; kh&ocirc;ng c&oacute; chiếc m&aacute;y n&agrave;o xứng đang hơn chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro-max-512gb\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone 11 Pro Max 512GB chính hãng\">iPhone 11 Pro Max 512GB</a>&nbsp;mới ra mắt trong năm 2019 của Apple.</h2>\r\n\r\n<h3>Hiệu năng &quot;đ&egrave; bẹp&quot; mọi đối thủ</h3>\r\n\r\n<p>iPhone 11 Pro Max 512GB năm nay sử dụng chip&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-ve-chip-apple-a13-bionic-tren-iphone-11-n-1197492\" target=\"_blank\" title=\"Tìm hiểu về chip Apple A13 Bionic\" type=\"Tìm hiểu về chip Apple A13 Bionic\">Apple A13 Bionic</a>&nbsp;mới nhất, nhanh v&agrave; tiết kiệm điện hơn so với A12 năm ngo&aacute;i dễ d&agrave;ng gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;tốt v&agrave; mượt m&agrave; ở mức cấu h&igrave;nh max setting m&agrave; kh&ocirc;ng phải lo về vấn đề giật lag.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd10.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Trải nghiệm chơi game\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd10.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Trải nghiệm chơi game\" /></a></p>\r\n\r\n<p>M&aacute;y cũng sở hữu ri&ecirc;ng một con chip&nbsp;AI Neural Engine sẽ phụ tr&aacute;ch c&aacute;c t&iacute;nh năng xử l&yacute; h&igrave;nh ảnh như&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/deep-fusion-tren-dong-iphone-11-pro-la-gi-tinh-nan-1197418\" target=\"_blank\" title=\"Tìm hiểu tính năng Deel Fusion\" type=\"Tìm hiểu tính năng Deel Fusion\">Deep Fusion</a>&nbsp;v&agrave; Night Mode.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Điểm hiệu năng Antutu Benchmark\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Điểm hiệu năng Antutu Benchmark\" /></a></p>\r\n\r\n<p>Điểm Geekbench của iPhone 11 Pro Max</p>\r\n\r\n<p>Theo Apple th&igrave; đ&acirc;y l&agrave; điện thoại th&ocirc;ng minh c&oacute; hiệu suất nhanh nhất thế giới ở thời điểm ra mắt.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd12.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Hiệu năng mạnh mẽ\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd12.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Hiệu năng mạnh mẽ\" /></a></p>\r\n\r\n<p>Cụ thể, hiệu năng của bộ vi xử l&yacute; A13 Bionic mới của Apple c&oacute; sức mạnh vượt trội, nhanh hơn đến 20% v&agrave; tiết ki&ecirc;m điện đến 40% so với chip A12, mang đến cho&nbsp;bạn trải nghiệm mượt m&agrave;, ổn định tất cả c&aacute;c t&aacute;c vụ, đa nhiệm.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd8.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện iOS 13 mới\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd8.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện iOS 13 mới\" /></a></p>\r\n\r\n<p>M&aacute;y sẽ chạy tr&ecirc;n phi&ecirc;n bản iOS 13 mới với nhiều t&iacute;nh năng tiện dụng gi&uacute;p bạn khai th&aacute;c chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo iPhone chính hãng\">iPhone</a>&nbsp;của m&igrave;nh hiệu quả hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd9.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện iOS 13 mới\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd9.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện iOS 13 mới\" /></a></p>\r\n\r\n<p>iOS 13 mới tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">Năm nay Face ID cũng được cải thiện để c&oacute; thể nhận dạng ở nhiều g&oacute;c kh&aacute;c nhau mang lại trải nghiệm mở kh&oacute;a tốt hơn.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd11.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện màn hình chính\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd11.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện màn hình chính\" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ocirc;ng nghệ Haptic Engine mới sẽ dựa tr&ecirc;n thời gian ấn v&agrave; giữ icon để hiện l&ecirc;n những menu chức năng kh&aacute;c nhau thay v&igrave; dựa v&agrave;o lực ấn như 3D Touch.</p>\r\n\r\n<h3 dir=\"ltr\">Camera l&agrave; điểm nhấn đ&aacute;ng ch&uacute; &yacute;</h3>\r\n\r\n<p dir=\"ltr\">Tại buổi ra mắt chiếc iPhone mới của m&igrave;nh, Apple d&agrave;nh rất nhiều thời gian để giới thiệu bộ 3 camera ho&agrave;n to&agrave;n mới tr&ecirc;n chiếc&nbsp;iPhone 11 Pro Max.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd22.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện camera\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd22.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện camera\" /></a></p>\r\n\r\n<p dir=\"ltr\">V&agrave; quả thực camera ch&iacute;nh l&agrave; điểm n&acirc;ng cấp đ&aacute;ng gi&aacute; nhất tr&ecirc;n chiếc&nbsp;iPhone 11 Pro Max.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb16-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb16-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp bằng camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp bằng camera sau tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">Chiếc iPhone n&agrave;y sẽ c&oacute; 3 camera với&nbsp;1 camera ch&iacute;nh g&oacute;c rộng 12 MP, 1 camera tele 12 MP v&agrave; 1 camera&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại hỗ trợ chụp góc rộng\" type=\"Tham khảo các dòng điện thoại hỗ trợ chụp góc rộng\">g&oacute;c si&ecirc;u rộng</a>&nbsp;12 MP.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb3-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb3-2.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp bằng camera sau\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp bằng camera sau tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">C&aacute;c camera n&agrave;y đều c&oacute; sự li&ecirc;n hệ mật thiết với nhau v&igrave; vậy khi người d&ugrave;ng chuyển đổi giữa c&aacute;c loại camera, th&igrave; độ s&aacute;ng hay m&agrave;u sắc của bức ảnh hầu như kh&ocirc;ng thay đổi nhiều.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd19.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Chế độ Night Mode mới\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd19.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Chế độ Night Mode mới\" /></a></p>\r\n\r\n<p dir=\"ltr\">Chế độ Night Mode mới</p>\r\n\r\n<p dir=\"ltr\">Đ&acirc;y l&agrave; điềm m&agrave; chưa một chiếc smartphone Android n&agrave;o c&oacute; nhiều camera hiện nay c&oacute; thể l&agrave;m tốt hơn iPhone 11 Pro Max.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb17-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp bằng chế độ Night Mode mới\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb17-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp bằng chế độ Night Mode mới\" /></a></p>\r\n\r\n<p dir=\"ltr\">Sự kh&aacute;c biệt với Night Mode tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">Ngo&agrave;i ra tr&ecirc;n chiếc iPhone n&agrave;y c&ograve;n c&oacute; th&ecirc;m chế độ chụp đ&ecirc;m Night Mode gi&uacute;p cải thiện r&otilde; rệt chất lượng chụp ảnh trong điều kiện thiếu s&aacute;ng của những chiếc iPhone.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb1-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp chế độ cơ bản\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb1-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp chế độ cơ bản\" /></a></p>\r\n\r\n<p dir=\"ltr\">Ảnh chụp chế độ cơ bản b&igrave;nh thường với camera ch&iacute;nh</p>\r\n\r\n<p dir=\"ltr\">Những bức ảnh với chế độ Night Mode c&oacute; chất lượng rất tốt, đủ sắc n&eacute;t, m&agrave;u sắc tuyệt vời, độ tương phản xuất sắc v&agrave; độ phơi s&aacute;ng rất c&acirc;n bằng.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd16.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện chuyển đổi các ống kính camera\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd16.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện chuyển đổi các ống kính camera\" /></a></p>\r\n\r\n<p dir=\"ltr\">Khả năng quay video tr&ecirc;n iPhone từ trước tới nay vẫn được đ&aacute;nh gi&aacute; rất cao v&agrave; năm nay Apple n&acirc;ng cấp l&ecirc;n độ ph&acirc;n giải 4K 60fps sẽ l&agrave; một tin kh&ocirc;ng thể vui hơn d&agrave;nh cho những bạn hay quay video tr&ecirc;n chiếc iPhone của m&igrave;nh.</p>\r\n\r\n<h3 dir=\"ltr\">Camera trước độ ph&acirc;n giải cao hơn</h3>\r\n\r\n<p dir=\"ltr\">12 MP v&agrave; độ ph&acirc;n giải mới của camera trước tr&ecirc;n chiếc&nbsp;iPhone 11 Pro Max, n&oacute; cao hơn kh&aacute; nhiều nếu so s&aacute;nh với 7 MP tr&ecirc;n những chiếc iPhone năm ngo&aacute;i.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb5-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Camera trước\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb5-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Camera trước\" /></a></p>\r\n\r\n<p dir=\"ltr\">Giờ đ&acirc;y người d&ugrave;ng sẽ c&oacute; những bức ảnh selfie với độ chi tiết cao hơn v&agrave; đặc biệt c&ograve;n c&oacute; thể quay video 4K với ch&iacute;nh camera trước của m&aacute;y.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb2-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | So sánh chất lượng ảnh selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb2-1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | So sánh chất lượng ảnh selfie\" /></a></p>\r\n\r\n<p dir=\"ltr\">Anh selfie tr&ecirc;n iPhone 11 Pro Max</p>\r\n\r\n<p dir=\"ltr\">Những ai l&agrave; t&iacute;n đồ của selfie th&igrave; cũng c&oacute; thể tự tin hơn khi chụp h&igrave;nh với camera trước của iPhone 11 Pro Max với t&iacute;nh năng selfie g&oacute;c rộng m&agrave; Apple vừa trang bị.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd13.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện chụp ảnh\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd13.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện chụp ảnh\" /></a></p>\r\n\r\n<p dir=\"ltr\">T&iacute;nh năng n&agrave;y sẽ tự động k&iacute;ch hoạt khi n&agrave;o bạn xoay ngang chiếc iPhone của m&igrave;nh, vậy l&agrave; từ nay bạn kh&ocirc;ng cần mang theo gậy selfie với chiếc iPhone mới của m&igrave;nh rồi nh&eacute;!</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd1.gif\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp Slofie bằng camera trước\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd1.gif\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Ảnh chụp Slofie bằng camera trước\" /></a></p>\r\n\r\n<p dir=\"ltr\">Th&ecirc;m một trang bị kh&aacute;c kh&aacute; th&uacute; vị l&agrave; khả năng quay video si&ecirc;u chậm slofie với camera trước của m&aacute;y để bạn c&oacute; thể s&aacute;ng tạo nhiều video vui vẻ hơn.</p>\r\n\r\n<p dir=\"ltr\">Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/tren-tay-va-danh-gia-nhanh-iphone-xs-max-tai-viet-nam-1118861\" target=\"_blank\" title=\"Trên tay và đánh giá nhanh iPhone Xs Max tại Việt Nam\" type=\"Trên tay và đánh giá nhanh iPhone Xs Max tại Việt Nam\">Tr&ecirc;n tay v&agrave; đ&aacute;nh gi&aacute; nhanh iPhone Xs Max tại Việt Nam: Sức h&uacute;t kh&oacute; cưỡng</a></p>\r\n\r\n<h3 dir=\"ltr\">Pin lớn thoải m&aacute;i cả ng&agrave;y</h3>\r\n\r\n<p dir=\"ltr\">iPhone 11 Pro Max 512GB sở hữu vi&ecirc;n pin c&oacute; dung lượng lớn hơn 25% so với&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xs-max\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone Xs Max chính hãng\">iPhone Xs Max</a>&nbsp;năm ngo&aacute;i nhờ vậy m&agrave; thời gian sử dụng pin cũng được cải thiện đ&aacute;ng kể.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd7.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Thời lượng pin\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd7.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Thời lượng pin\" /></a></p>\r\n\r\n<p dir=\"ltr\">Apple c&ocirc;ng bố chiếc iPhone mới n&agrave;y sẽ cho thời gian d&ugrave;ng pin nhiều hơn 5 tiếng so với iPhone Xs Max nhưng thực tế con số n&agrave;y c&ograve;n tốt hơn thế.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd6.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện thời lượng pin trên iOS 13\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd6.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Giao diện thời lượng pin trên iOS 13\" /></a></p>\r\n\r\n<p dir=\"ltr\">Nếu bạn chỉ sử dụng ở mức b&igrave;nh thường, &iacute;t chơi game th&igrave; chiếc iPhone n&agrave;y ho&agrave;n to&agrave;n c&oacute; thể đ&aacute;p ứng l&ecirc;n tới 2 ng&agrave;y sử dụng cho bạn.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd5.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Thời lượng sử dụng pin lâu\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd5.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Thời lượng sử dụng pin lâu\" /></a></p>\r\n\r\n<p dir=\"ltr\">C&ograve;n nếu nhu cầu nhiều hơn th&igrave; việc đ&aacute;p ứng với cường độ cao từ s&aacute;ng tới tối cũng kh&ocirc;ng phải l&agrave; điều g&igrave; qu&aacute; kh&oacute; khăn với chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-pin-khung\" target=\"_blank\" title=\"Tham khảo điện thoại pin trâu kinh doanh tại thegioididong.com\">điện thoại pin tr&acirc;u</a>&nbsp;n&agrave;y.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Công nghệ sạc nhanh 18W\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd4.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Công nghệ sạc nhanh 18W\" /></a></p>\r\n\r\n<p dir=\"ltr\">Tin vui l&agrave; năm nay bạn đ&atilde; được Apple tặng k&egrave;m&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\">sạc nhanh</a>&nbsp;18W b&ecirc;n trong hộp m&aacute;y gi&uacute;p bạn sạc được 50% pin chỉ trong v&ograve;ng 30 ph&uacute;t.</p>\r\n\r\n<p dir=\"ltr\">B&ecirc;n cạnh đ&oacute;&nbsp;iPhone 11 Pro Max 512GB cũng hỗ trợ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-khong-day\" target=\"_blank\" title=\"Tham khảo điện thoại có sạc không dây tại Thế Giới Di Động\">sạc nhanh kh&ocirc;ng d&acirc;y</a>&nbsp;l&ecirc;n tới 10W để bạn c&oacute; thể sử dụng hằng ng&agrave;y.</p>\r\n\r\n<h3 dir=\"ltr\">Vẫn c&ograve;n nhiều cải tiến m&agrave; bạn n&ecirc;n biết</h3>\r\n\r\n<p dir=\"ltr\">iPhone 11 Pro Max đ&atilde; giải quyết được t&igrave;nh trạng để lại nhiều mồ h&ocirc;i v&agrave; dấu v&acirc;n tay trong qu&aacute; tr&igrave;nh sử dụng tr&ecirc;n những chiếc iPhone đời trước với mặt lưng được ho&agrave;n thiện dưới dạng k&iacute;nh mờ.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd3.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Thiết kế kính không để lại mồ hôi, dấu vân tay\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd3.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Thiết kế kính không để lại mồ hôi, dấu vân tay\" /></a></p>\r\n\r\n<p dir=\"ltr\">Đặc biệt, m&agrave;u sắc của iPhone 11 Pro Max rất hấp dẫn, bao gồm xanh b&oacute;ng đ&ecirc;m, x&aacute;m kh&ocirc;ng gian, bạc v&agrave; v&agrave;ng.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Trải nghiệm giải trí\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd2.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Trải nghiệm giải trí\" /></a></p>\r\n\r\n<p dir=\"ltr\">Theo Apple th&igrave; k&iacute;nh m&agrave; h&atilde;ng sử dụng tr&ecirc;n chiếc iPhone n&agrave;y l&agrave; loại k&iacute;nh bền nhất từ trước tới nay từng được sử dụng cho smartphone.</p>\r\n\r\n<p dir=\"ltr\">Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia-iphone-xs-max-review-dang-mua-1128868\" target=\"_blank\" title=\"Đánh giá chi tiết iPhone Xs Max\" type=\"Đánh giá chi tiết iPhone Xs Max\">Đ&aacute;nh gi&aacute; chi tiết iPhone Xs Max: Qu&aacute; x&aacute; đ&atilde;! C&oacute; tiền n&ecirc;n mua liền!</a></p>\r\n\r\n<p dir=\"ltr\">Để tăng khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chống nước chống bụi\">chống nước</a>&nbsp;cho m&aacute;y th&igrave; h&atilde;ng cũng n&oacute;i rằng đ&atilde; ho&agrave;n thiện c&aacute;c chi tiết một c&aacute;ch bền bỉ hơn để m&aacute;y c&oacute; thể chịu được độ s&acirc;u l&ecirc;n tới 4m.</p>\r\n\r\n<p dir=\"ltr\"><a href=\"https://www.thegioididong.com/images/42/210654/iphone-11-pro-max-512gb-tgdd1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 Pro Max 512GB | Trải nghiệm cầm nắm, thao tác\" src=\"https://cdn.tgdd.vn/Products/Images/42/210654/iphone-11-pro-max-512gb-tgdd1.jpg\" title=\"Điện thoại iPhone 11 Pro Max 512GB | Trải nghiệm cầm nắm, thao tác\" /></a></p>\r\n\r\n<p dir=\"ltr\">Bạn cảm thấy thế n&agrave;o về những trang bị tr&ecirc;n chiếc iPhone cao cấp nhất trong năm 2019, c&ograve;n chần chờ g&igrave; nữa m&agrave; kh&ocirc;ng đặt mua ngay cho m&igrave;nh một chiếc về trải nghiệm đi n&agrave;o!</p>\r\n', 'bb0f2a29458951ec632ebb241b79cb17a9b21eab.jpg', 63, 0, NULL, 38990000, 'OLED, 6.5\", Super Retina XDR', 'iOS 13', ' 3 camera 12 MP', '12 MP', 'Apple A13 Bionic 6 nhân', ' 1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '3969 mAh, có sạc nhanh', '2020-10-31 07:48:51', 0);
INSERT INTO `phones` (`id`, `brand_id`, `name`, `description`, `content`, `thumb`, `stock`, `promotion_id`, `video`, `price`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`, `battery`, `date_created`, `is_featured`) VALUES
(11, 0, 'Điện thoại iPhone 11 256GB', 'Description\r\n', '<h2><a href=\"https://www.thegioididong.com/dtdd/iphone-11-256gb\" target=\"_blank\" title=\"Tham khảo iPhone 11 256GB chính hãng\">iPhone 11 256GB</a>&nbsp;l&agrave; chiếc m&aacute;y c&oacute; mức gi&aacute; &quot;dễ chịu&quot; trong bộ 3&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone iPhone chính hãng\">iPhone</a>&nbsp;vừa được&nbsp;Apple&nbsp;giới thiệu v&agrave; nếu bạn muốn được trải nghiệm những n&acirc;ng cấp về camera mới hay hiệu năng h&agrave;ng đầu m&agrave; lại kh&ocirc;ng muốn bỏ ra qu&aacute; nhiều tiền th&igrave; đ&acirc;y thực sự l&agrave; lựa chọn h&agrave;ng đầu d&agrave;nh cho bạn.</h2>\r\n\r\n<h3>Hiệu năng vẫn tương đương phi&ecirc;n bản Pro Max</h3>\r\n\r\n<p>Mặc d&ugrave; c&oacute; mức gi&aacute; rẻ hơn nhưng kh&ocirc;ng v&igrave; vậy m&agrave; iPhone 11 bị cắt giảm đi về mặt cấu h&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd9-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Hiệu năng mạnh mẽ\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd9-1.jpg\" title=\"Điện thoại iPhone 11 256GB | Hiệu năng mạnh mẽ\" /></a></p>\r\n\r\n<p>M&aacute;y vẫn sẽ sở hữu cho m&igrave;nh con chip&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-ve-chip-apple-a13-bionic-tren-iphone-11-n-1197492\" target=\"_blank\" title=\"Tìm hiểu về chip Apple A13 Bionic\" type=\"Tìm hiểu về chip Apple A13 Bionic\">Apple A13 Bionic</a>&nbsp;mạnh mẽ c&ugrave;ng 4 GB RAM tương đương với người anh em đắt tiền&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro-max\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone 11 Pro Max 64GB chính hãng\">iPhone 11 Pro Max</a>.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Trải nghiệm chơi game trên iPhone 11\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd4.jpg\" title=\"Điện thoại iPhone 11 256GB | Trải nghiệm chơi game trên iPhone 11\" /></a></p>\r\n\r\n<p>Phi&ecirc;n bản n&agrave;y sẽ c&oacute; bộ nhớ l&ecirc;n tới 256 GB thoải m&aacute;i cho bạn c&agrave;i đặt game ứng dụng hay lưu trữ video độ ph&acirc;n giải cao.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd44.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Trải nghiệm chơi game trên iPhone 11\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd44.jpg\" title=\"Điện thoại iPhone 11 256GB | Trải nghiệm chơi game trên iPhone 11\" /></a></p>\r\n\r\n<p>Hiệu năng của những chiếc iPhone lu&ocirc;n được đ&aacute;nh gi&aacute; rất cao v&agrave; hiện tại để t&igrave;m được một đối thủ c&oacute; thể đ&aacute;nh bại&nbsp;iPhone 11 256GB l&agrave; điều kh&ocirc;ng hề dễ d&agrave;ng ch&uacute;t n&agrave;o.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd6-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Điểm hiệu năng Antutu Benchmark\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd6-2.jpg\" title=\"Điện thoại iPhone 11 256GB | Điểm hiệu năng Antutu Benchmark\" /></a></p>\r\n\r\n<p>Trong sự kiện ra mắt sản phẩm, Apple đ&atilde; cho biết Apple A13 l&agrave; CPU nhanh nhất tr&ecirc;n giới&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\">smartphone</a>&nbsp;hiện nay v&agrave; bạn sẽ cảm thấy rất h&agrave;i l&ograve;ng với n&oacute;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd40.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Giao diện chụp ảnh\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd40.jpg\" title=\"Điện thoại iPhone 11 256GB | Giao diện chụp ảnh\" /></a></p>\r\n\r\n<p>Với việc trang bị con chip mạnh đến vậy ho&agrave;n to&agrave;n dễ d&agrave;ng gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;tốt ở mức cấu h&igrave;nh max setting với mọi tựa game từ nhẹ nh&agrave;ng như Temple Run hay thậm ch&iacute; PUBG Mobile v&agrave; nặng hơn thế th&igrave; chiếc&nbsp;iPhone 11 256GB đều đ&aacute;p ứng một c&aacute;ch rất mượt m&agrave; v&agrave; nhanh ch&oacute;ng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd34.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Giao diện màn hình chính\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd34.jpg\" title=\"Điện thoại iPhone 11 256GB | Giao diện màn hình chính\" /></a></p>\r\n\r\n<p>iOS 13 mới</p>\r\n\r\n<p>iPhone 11 256GB chạy sẵn phi&ecirc;n bản&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tat-ca-nhung-tinh-nang-moi-duoc-cap-nhat-tren-ios-1171206\" target=\"_blank\" title=\"Tìm hiểu những tính năng mới trên iOS 13\" type=\"Tìm hiểu những tính năng mới trên iOS 13\">iOS 13</a>&nbsp;mới được Apple tối ưu hiệu v&agrave; giật lag sẽ l&agrave; điều m&agrave; bạn kh&oacute; c&oacute; thể bắt gặp.</p>\r\n\r\n<h3>Camera cải tiến lớn</h3>\r\n\r\n<p>So với&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xr-128gb\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone Xr chính hãng\">iPhone Xr</a>&nbsp;năm ngo&aacute;i th&igrave; iPhone 11 năm nay thực sự l&agrave; một &quot;cuộc c&aacute;ch mạng của Appe&quot; về camera.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd4-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Cụm camera kép ở mặt sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd4-1.jpg\" title=\"Điện thoại iPhone 11 256GB | Cụm camera kép ở mặt sau\" /></a></p>\r\n\r\n<p>Ch&uacute;ng ta sẽ c&oacute; th&ecirc;m một ống k&iacute;nh g&oacute;c si&ecirc;u rộng mới cũng với độ ph&acirc;n giải 12 MP v&agrave; th&ecirc;m nhiều chế độ chụp ảnh mới cho bạn kh&aacute;m ph&aacute;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd9-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Ảnh chụp bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd9-2.jpg\" title=\"Điện thoại iPhone 11 256GB | Ảnh chụp bằng camera sau\" /></a></p>\r\n\r\n<p>Ảnh chụp với camera sau</p>\r\n\r\n<p>Đầu ti&ecirc;n l&agrave; chế độ chụp ảnh g&oacute;c si&ecirc;u rộng, đ&acirc;y sẽ l&agrave; lần đầu ti&ecirc;n 1 chiếc iPhone c&oacute; thể chụp những to&agrave;n nh&agrave; cao tầng đầy đủ chi tiết một c&aacute;ch đơn giản m&agrave; kh&ocirc;ng cần di chuyển ra xa.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd12-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Ảnh chụp đủ sáng\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd12-1.jpg\" title=\"Điện thoại iPhone 11 256GB | Ảnh chụp đủ sáng\" /></a></p>\r\n\r\n<p>Ảnh chụp g&oacute;c th&ocirc;ng thường</p>\r\n\r\n<p>Với sự trợ gi&uacute;p của camera thứ 2 th&igrave; iPhone 11 cũng đ&atilde; c&oacute; thể chụp x&oacute;a ph&ocirc;ng với vật thể, điều m&agrave; nhiều người cảm thấy thiếu s&oacute;t tr&ecirc;n chiếc iPhone Xr.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210648/iphone-11-256gb-tgdd13-2.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 256GB | Ảnh chụp bằng camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/210648/iphone-11-256gb-tgdd13-2.jpg\" title=\"Điện thoại iPhone 11 256GB | Ảnh chụp bằng camera sau\" /></a></p>\r\n\r\n<p>Ảnh chụp g&oacute;c si&ecirc;u rộng bằng camera sau</p>\r\n\r\n<p>Tuy nhi&ecirc;n, chế độ chụp đ&ecirc;m mới ch&iacute;nh l&agrave; điểm nhấn tr&ecirc;n camera của bộ 3 iPhone năm nay.</p>\r\n\r\n<p>Khi chụp ảnh trong m&ocirc;i trường thiếu s&aacute;ng iPhone 11 sẽ tự động k&iacute;ch hoạt chế độ Night Mode v&agrave; bạn sẽ nhận thấy sự kh&aacute;c biệt ngay tức th&igrave;.</p>\r\n', 'af6935f17b720ca41221872b9704b3235a49d098.jpg', 20, 0, NULL, 21000000, 'IPS LCD, 6.1', 'iOS 13', '2 camera 12 MP ', '	12 MP', 'Apple A13 Bionic 6 nhân', '1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '	3110 mAh, có sạc nhanh', '2020-10-31 08:09:13', 0),
(13, 0, 'Điện thoại iPhone Xr 128GB', 'Description\r\n', '<h2>Được xem l&agrave; phi&ecirc;n bản&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại iPhone\" type=\"Tham khảo các dòng điện thoại iPhone\">iPhone</a>&nbsp;gi&aacute; rẻ đầy ho&agrave;n hảo,&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xr-128gb\" target=\"_blank\" title=\"Chi tiết điện thoại iPhone XR 128GB\" type=\"Chi tiết điện thoại iPhone XR 128GB\">iPhone Xr 128GB</a>&nbsp;khiến người d&ugrave;ng c&oacute; nhiều sự lựa chọn hơn về m&agrave;u sắc&nbsp;đa dạng nhưng vẫn sở hữu cấu h&igrave;nh mạnh mẽ v&agrave; thiết kế sang trọng.</h2>\r\n\r\n<h3>M&agrave;n h&igrave;nh tr&agrave;n viền c&ocirc;ng nghệ LCD - True Tone</h3>\r\n\r\n<p>Thay v&igrave; sở hữu m&agrave;n h&igrave;nh OLED truyền thống, chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại tại Thegioididong.com\" type=\"Tham khảo các dòng điện thoại tại Thegioididong.com\">smartphone</a>&nbsp;n&agrave;y sở hữu m&agrave;n h&igrave;nh LCD.</p>\r\n\r\n<p>B&ugrave; lại với c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-cong-nghe-man-hinh-true-tone-992705\" target=\"_blank\" title=\"Tìm hiểu công nghệ màn hình True Tone\" type=\"Tìm hiểu công nghệ màn hình True Tone\">True Tone</a>&nbsp;c&ugrave;ng m&agrave;n h&igrave;nh tr&agrave;n viền rộng tới 6.1 inch, mọi trải nghiệm tr&ecirc;n m&aacute;y vẫn đem lại sự th&iacute;ch th&uacute; v&agrave; ho&agrave;n hảo, như d&ograve;ng cao cấp kh&aacute;c của Apple.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/191483/iphone-xr-128gb-1-1.jpg\" onclick=\"return false;\"><img alt=\"Màn hình điện thoại iPhone Xr chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/191483/iphone-xr-128gb-1-1.jpg\" title=\"Màn hình điện thoại iPhone Xr chính hãng\" /></a></p>\r\n\r\n<p>Ngo&agrave;i ra, Apple cũng giới thiệu rằng, iPhone Xr được trang bị một loại c&ocirc;ng nghệ mới c&oacute; t&ecirc;n&nbsp;Liquid Retina. M&aacute;y c&oacute; độ ph&acirc;n giải 1792 x 828 Pixels c&ugrave;ng 1.4 triệu điểm ảnh.</p>\r\n\r\n<h3>Mượt m&agrave; mọi trải nghiệm nhờ&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/chi-tiet-chip-apple-a12-bionic-ben-trong-iphone-xs-xs-max-1116982\" target=\"_blank\" title=\"Tìm hiểu chip Apple A12\" type=\"Tìm hiểu chip Apple A12\">chip Apple A12</a></h3>\r\n\r\n<p>Với mỗi lần ra mắt, Apple lại giới thiệu một con chip mới v&agrave; Apple A12 Bionic l&agrave; con chip đầu ti&ecirc;n sản xuất với tiến tr&igrave;nh 7nm được t&iacute;ch hợp tr&ecirc;n iPhone Xr.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/191483/iphone-xr-128gb-a12.jpg\" onclick=\"return false;\"><img alt=\"Chip A12 trên điện thoại iPhone Xr chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/191483/iphone-xr-128gb-a12.jpg\" title=\"Chip A12 trên điện thoại iPhone Xr chính hãng\" /></a></p>\r\n\r\n<p>Apple A12 được t&iacute;ch hợp tr&iacute; tuệ th&ocirc;ng minh nh&acirc;n tạo, mọi phản hồi tr&ecirc;n m&aacute;y đều nhanh ch&oacute;ng v&agrave; gần như l&agrave; ngay lập tức, kể cả khi bạn chơi game hay thao t&aacute;c b&igrave;nh thường.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/191483/iphone-xr-128gb-6-1.jpg\" onclick=\"return false;\"><img alt=\"iOS trên điện thoại iPhone Xr chính hãng\" src=\"https://cdn.tgdd.vn/Products/Images/42/191483/iphone-xr-128gb-6-1.jpg\" title=\"iOS trên điện thoại iPhone Xr chính hãng\" /></a></p>\r\n\r\n<p>Hơn nữa với AI tr&ecirc;n Apple A12,&nbsp;iPhone Xr c&oacute; thể ghi nhớ được thao t&aacute;c hằng ng&agrave;y của bạn để ho&agrave;n thiện v&agrave; hỗ trợ người d&ugrave;ng tốt hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/191483/iphone-xr-128gb-14.jpg\" onclick=\"return false;\"><img alt=\"Điểm Antutu Benchmark điện thoại iPhone Xr\" src=\"https://cdn.tgdd.vn/Products/Images/42/191483/iphone-xr-128gb-14.jpg\" title=\"Điểm Antutu Benchmark điện thoại iPhone Xr\" /></a></p>\r\n\r\n<p>Thực tế khi chơi game tr&ecirc;n iPhone Xr, m&ocirc;i trường v&agrave; hiệu ứng trong game rất thật. Hơn nữa tr&ecirc;n chiếc iPhone c&ograve;n hỗ trợ&nbsp;thực tế tăng cường: Chơi game thực tế ảo với nhiều người c&ugrave;ng chơi, trải nghiệm c&ugrave;ng 1 m&ocirc;i trường với nhau.</p>\r\n', '2f7e7b80c4fa8cecb5d204e6b9a776f18a6e8c33.jpg', 15, 0, NULL, 11990000, 'IPS LCD, 6.1\", Liquid Retina', 'iOS 12', '12 MP', '7 MP', 'Apple A12 Bionic 6 nhân', ' 1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '2942 mAh, có sạc nhanh', '2020-10-31 08:20:32', 0),
(14, 0, 'Điện thoại iPhone 7 128GB', 'Description\r\n', '<h2>Đặc điểm nổi bật của iPhone 7 128GB</h2>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/87837/Slider/vi-vn-iphone-7-128gb-tinhnang.jpg\" /></p>\r\n\r\n<p>Bộ sản phẩm chuẩn: Hộp, Sạc, Tai nghe, S&aacute;ch hướng dẫn, C&aacute;p, C&acirc;y lấy sim</p>\r\n\r\n<h2><a href=\"https://www.thegioididong.com/dtdd/iphone-7-128gb\" target=\"_blank\" title=\"Tham khảo điện thoại Apple iPhone 7 128 GB chính hãng tại Thegioididong.com\" type=\"Tham khảo điện thoại Apple iPhone 7 128 GB chính hãng tại Thegioididong.com\">iPhone 7</a>&nbsp;l&agrave; chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại, smartphone chính hãng tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại, smartphone chính hãng tại Thegioididong.com\">smartphone</a>&nbsp;c&oacute; thiết kế kim loại nguy&ecirc;n khối cuối c&ugrave;ng của&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại Apple iPhone chính hãng tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại Apple iPhone chính hãng tại Thegioididong.com\">Apple</a>, nhưng đồng thời lại sở hữu &ldquo;h&agrave;ng t&aacute;&rdquo; t&iacute;nh năng mới xuất hiện lần đầu như: n&uacute;t home cảm ứng lực, khả năng kh&aacute;ng bụi nước, &acirc;m thanh stereo 2 k&ecirc;nh. V&agrave; đặc biệt, hiệu năng từ con chip A10 Fusion vẫn tỏ ra rất ổn định ở thời điểm hiện tại.</h2>\r\n\r\n<h3>Thiết kế kh&ocirc;ng đổi nhưng đ&atilde; c&oacute; sự cải thiện</h3>\r\n\r\n<p>iPhone 7 gần như giữ nguy&ecirc;n thiết kế từ iPhone 6 v&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-6s-plus-32gb\" target=\"_blank\" title=\"Tham khảo giá điện thoại iPhone 6s chính hãng tại Thegioididong.com\" type=\"Tham khảo giá điện thoại iPhone 6s chính hãng tại Thegioididong.com\">iPhone 6s</a>&nbsp;với khung kim loại được bo cong, nối liền ho&agrave;n hảo với phần m&agrave;n h&igrave;nh nổi 2.5D, độ ho&agrave;n thiện cực cao tạo cho người d&ugrave;ng cảm gi&aacute;c cầm nắm dễ chịu kh&ocirc;ng bị cấn tay.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-den-8-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Điện thoại có thiết kế kim loại nguyên khối cuối cùng của Apple\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-den-8-1.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Điện thoại có thiết kế kim loại nguyên khối cuối cùng của Apple\" /></a></p>\r\n\r\n<p>Hai dải anten tr&ecirc;n dưới vốn bị nhiều ph&agrave;n n&agrave;n từ ph&iacute;a người d&ugrave;ng nay đ&atilde; được Apple kh&eacute;o l&eacute;o che giấu bằng c&aacute;ch đưa l&ecirc;n phần cạnh viền tr&ecirc;n v&agrave; dưới, để lại một mặt lưng c&acirc;n đối, nổi bật với logo t&aacute;o khuyết đặc trưng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-mau-den-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Phần Anten được thiết kế lại để lại mặt lưng trơn nhẵn\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-mau-den-1.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Phần Anten được thiết kế lại để lại mặt lưng trơn nhẵn\" /></a></p>\r\n\r\n<p>iPhone 7 cũng l&agrave; chiếc điện thoại đầu ti&ecirc;n của nh&agrave; T&aacute;o trang bị chuẩn&nbsp;<a href=\"https://www.thegioididong.com/dtdd?f=chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có hỗ trợ chuẩn kháng nước, kháng bụi tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có hỗ trợ chuẩn kháng nước, kháng bụi tại Thegioididong.com\">kh&aacute;ng nước kh&aacute;ng bụi</a>&nbsp;IP67, gi&uacute;p m&aacute;y c&oacute; thể sử dụng được dưới trời mưa, đồng thời hạn chế những hư hỏng kh&ocirc;ng mong muốn khi v&agrave;o nước.</p>\r\n\r\n<h3>N&uacute;t home mới, loại bỏ jack tai nghe</h3>\r\n\r\n<p>N&uacute;t Home tr&ecirc;n iPhone 7 được Apple l&agrave;m mới ho&agrave;n to&agrave;n. Kh&ocirc;ng c&ograve;n l&agrave; n&uacute;t bấm vật l&yacute; th&ocirc;ng thường m&agrave; đ&atilde; l&agrave; một ph&iacute;m cứng c&ugrave;ng c&ocirc;ng nghệ cảm ứng lực. Khi ấn, n&uacute;t home sẽ cảm nhận lực v&agrave; rung phản hồi lại để tạo cảm gi&aacute;c giống như khi nhấn v&agrave;o ph&iacute;m vật l&yacute;.</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/nut-home-cam-ung-moi-tren-iphone-7-hoat-dong-nhu-the-nao--884969\" target=\"_blank\" title=\"Tìm hiểu thêm về nút home cảm ứng lực mới trên iPhone 7 là gì?\" type=\"Tìm hiểu thêm về nút home cảm ứng lực mới trên iPhone 7 là gì?\">N&uacute;t Home cảm ứng mới tr&ecirc;n iPhone 7 hoạt động như thế n&agrave;o?</a></p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-mau-jet-black-1-4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Nút home cảm ứng lực lần đầu xuất hiện\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-mau-jet-black-1-4.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Nút home cảm ứng lực lần đầu xuất hiện\" /></a></p>\r\n\r\n<p>Đ&aacute;nh gi&aacute; khi trải nghiệm với n&uacute;t home cảm ứng lực của iPhone 7 l&agrave; nhanh ch&oacute;ng, phản hồi lực rất chuẩn x&aacute;c. Ph&iacute;m home cứng sẽ c&oacute; độ bền cao v&agrave; &iacute;t bị hư hỏng hơn so với n&uacute;t home vật l&yacute; trước đ&acirc;y.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/dtdd?f=bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại có bảo mật vân tay tại Thegioididong.com\" type=\"Tham khảo các mẫu điện thoại có bảo mật vân tay tại Thegioididong.com\">Cảm biến v&acirc;n tay</a>&nbsp;được t&iacute;ch hợp tr&ecirc;n n&uacute;t home cho tốc độ nhận diện nhanh, hỗ trợ trong c&aacute;c thao t&aacute;c mở kh&oacute;a, tải ứng dụng tr&ecirc;n AppStore, x&aacute;c thực thanh to&aacute;n cực kỳ dễ d&agrave;ng v&agrave; độ bảo mật cao.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-den-13.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Cảm biến vân tay nhận diện cực nhanh\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-den-13.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Cảm biến vân tay nhận diện cực nhanh\" /></a></p>\r\n\r\n<p>Cuối c&ugrave;ng, với iPhone 7 th&igrave; người d&ugrave;ng cũng đ&atilde; n&oacute;i lời chia tay với jack tai nghe 3.5 mm đ&atilde; tồn tại 10 năm cho đến thế hệ iPhone 6s. Nếu sử dụng tai nghe c&oacute; d&acirc;y, bạn bắt buộc phải d&ugrave;ng c&aacute;p chuyển jack 3.5 mm sang lightning. Đ&acirc;y cũng l&agrave; bước đệm để&nbsp;<a href=\"https://www.thegioididong.com/tim-kiem?key=tai+nghe+airpod\" target=\"_blank\" title=\"Tham khảo giá tai nghe Airpod chính hãng tại Thegioididong.com\" type=\"Tham khảo giá tai nghe Airpod chính hãng tại Thegioididong.com\">tai nghe Airpod</a>&nbsp;ra đời. Hiện thực h&oacute;a việc d&ugrave;ng ho&agrave;n to&agrave;n kết nối kh&ocirc;ng d&acirc;y của Apple trong tương lai.</p>\r\n\r\n<h2><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-mau-den-4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Jack 3.5mm đã chính thức bị \" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-mau-den-4.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Jack 3.5mm đã chính thức bị \" /></a></h2>\r\n\r\n<h3>&Acirc;m thanh nổi với hệ thống loa Stereo 2.0</h3>\r\n\r\n<p>&Acirc;m thanh loa ngo&agrave;i tr&ecirc;n iPhone lu&ocirc;n được đ&aacute;nh gi&aacute; cao khi so s&aacute;nh với những đối thủ kh&aacute;c, nay sẽ c&ograve;n hay hơn khi Apple n&acirc;ng cấp th&agrave;nh hệ thống loa k&eacute;p stereo 2 k&ecirc;nh với 1 loa ngo&agrave;i ở cạnh dưới v&agrave; h&atilde;ng tận dụng từ loa thoại ở cạnh tr&ecirc;n để l&agrave;m k&ecirc;nh loa c&ograve;n lại.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-mau-jet-black-3.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Âm thanh Stereo 2.0 có chất lượng vượt trội\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-mau-jet-black-3.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Âm thanh Stereo 2.0 có chất lượng vượt trội\" /></a></p>\r\n\r\n<p>Với hệ thống loa stereo 2 k&ecirc;nh, chất lượng &acirc;m thanh tr&ecirc;n iPhone 7 c&oacute; phần vượt trội hẳn so với c&aacute;c thế hệ trước, nhạc hay hơn, bass chắc v&agrave; &acirc;m lượng to hơn so với những thiết bị iPhone tiền nhiệm.</p>\r\n\r\n<h3>Camera n&acirc;ng cấp với nhiều t&iacute;nh năng</h3>\r\n\r\n<p>iPhone 7 được trang bị 1 camera trước v&agrave; 1 camera sau c&oacute; độ ph&acirc;n giải lần lượt l&agrave; 7 MP v&agrave; 12 MP.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-mau-jet-black-12.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Camera bổ sung nhiều tính năng, chất lượng chụp ấn tượng\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-mau-jet-black-12.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Camera bổ sung nhiều tính năng, chất lượng chụp ấn tượng\" /></a></p>\r\n\r\n<p>Camera sau tr&ecirc;n iPhone 7 t&iacute;ch hợp nhiều t&iacute;nh năng nổi bật như tự động lấy n&eacute;t (AF), HDR, to&agrave;n cảnh Panorama, chống rung quang học (OIS). Nhờ vậy iPhone 7 c&oacute; thể lấy lấy n&eacute;t nhanh ch&oacute;ng, cho bạn những bức ảnh đẹp v&agrave; chất lượng trong nhiều điều kiện kh&aacute;c nhau.</p>\r\n\r\n<p>Camera trước của iPhone 7 cũng c&oacute; sự tăng nhẹ về th&ocirc;ng số l&ecirc;n 7 MP gi&uacute;p chụp ảnh đẹp v&agrave; n&eacute;t hơn, đồng thời, t&iacute;nh năng Retina Flash biến m&agrave;n h&igrave;nh trở th&agrave;nh 1 chiếc đ&egrave;n flash gi&uacute;p cung cấp &aacute;nh s&aacute;ng tự nhi&ecirc;n khi chụp ảnh trong điều kiện thiếu s&aacute;ng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-7-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Camera bổ sung nhiều tính năng, chất lượng chụp ấn tượng\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-7-1.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Ảnh chụp từ camera trước đủ sáng\" /></a></p>\r\n\r\n<h3>Vi xử l&yacute; A10 Fusion chiến game vẫn mượt</h3>\r\n\r\n<p>Đ&atilde; gần 5 năm đến hiện nay, vi xử l&yacute; A10 Fusion vẫn l&agrave; con chịp được đ&aacute;nh gi&aacute; mạnh khi so với c&aacute;c đối thủ kh&aacute;c trong tầm gi&aacute;.</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tong-quan-ve-chip-a10-fusion-cua-apple-885052\" target=\"_blank\" title=\"Tìm hiểu thêm về chip A10 Fusion được trang bị trên iPhone 7\" type=\"Tìm hiểu thêm về chip A10 Fusion được trang bị trên iPhone 7\">Tổng quan về chip A10 Fusion của Apple</a></p>\r\n\r\n<h2><a href=\"https://www.thegioididong.com/images/42/87837/iphone-7-128gb-den-9-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Apple iPhone 7 128 GB | Chip A10 Fusion cho chất lượng vượt trội\" src=\"https://cdn.tgdd.vn/Products/Images/42/87837/iphone-7-128gb-den-9-1.jpg\" title=\"Điện thoại Apple iPhone 7 128 GB | Chip A10 Fusion cho chất lượng vượt trội\" /></a></h2>\r\n\r\n<p>A10 Fusion với 4 nh&acirc;n xử l&yacute;, 64 bit, cho hiệu nhanh nhanh hơn 40% với A9 v&agrave; gấp đ&ocirc;i A8. nhưng vẫn kiểm so&aacute;t việc ti&ecirc;u hao pin tốt. Theo Apple, hiệu năng của A10 Fushion gần như tương đương m&aacute;y chơi game PS4 hay Xbox.</p>\r\n\r\n<p>Nhờ hiệu năng ổn định, A10 Fushion cho đến hiện nay vẫn được Apple trang bị tr&ecirc;n m&aacute;y t&iacute;nh bảng&nbsp;<a href=\"https://www.thegioididong.com/may-tinh-bang/ipad-10-2-inch-wifi-32gb-2019\" target=\"_blank\" title=\"Tham khảo giá Máy tính bảng iPad 10.2 inch Wifi 32GB (2019) tại Thegioididong.com\" type=\"Tham khảo giá Máy tính bảng iPad 10.2 inch Wifi 32GB (2019) tại Thegioididong.com\">iPad 2019 10.2 inch</a>&nbsp;v&agrave; cho hiệu năng kh&aacute; cao, gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;vẫn mượt m&agrave;.&nbsp;</p>\r\n\r\n<p>Đặc biệt, người d&ugrave;ng iPhone 7 chắc chắn sẽ được n&acirc;ng cấp l&ecirc;n iOS 14 mới nhất v&agrave; trong tương lai c&oacute; thể l&agrave; iOS 15, trải nghiệm những t&iacute;nh năng mới nhất đến từ nh&agrave; t&aacute;o.</p>\r\n', '857dfe8d30a7b7c5f552b7b5ed96c76d142aa5ac.jpg', 23, 0, NULL, 9990000, 'LED-backlit IPS LCD, 4.7\", Retina HD', 'iOS 11', ' 12 MP', '7 MP', 'Apple A10 Fusion 4 nhân', '1 Nano SIM, Hỗ trợ 4G', '	1960 mAh', '2020-10-31 12:42:41', 0),
(15, 0, 'Điện thoại Samsung Galaxy Note 10+', 'Description\r\n', '<h2>Tr&ocirc;ng ngoại h&igrave;nh kh&aacute; giống nhau, tuy nhi&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-note-10-plus\" target=\"_blank\" title=\"Tham khảo điện thoại Samsung Galaxy Note 10+ chính hãng, giá rẻ\" type=\"Tham khảo điện thoại Samsung Galaxy Note 10+ chính hãng, giá rẻ\">Samsung Galaxy Note 10+</a>&nbsp;sở hữu kh&aacute; nhiều điểm kh&aacute;c biệt so với&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-note-10\" target=\"_blank\" title=\"Tham khảo điện thoại Samsung Galaxy Note 10 chính hãng, giá rẻ\" type=\"Tham khảo điện thoại Samsung Galaxy Note 10 chính hãng, giá rẻ\">Galaxy Note 10</a>&nbsp;v&agrave; đ&acirc;y được xem l&agrave; một trong những chiếc m&aacute;y đ&aacute;ng mua nhất trong năm 2019, đặc biệt d&agrave;nh cho những người th&iacute;ch một chiếc m&aacute;y m&agrave;n h&igrave;nh lớn, camera chất lượng h&agrave;ng đầu.</h2>\r\n\r\n<h3>Camera đứng đầu thế giới</h3>\r\n\r\n<p>DxOMark l&agrave; chuy&ecirc;n trang đ&aacute;nh gi&aacute; camera uy t&iacute;n thế giới mới đ&acirc;y đ&atilde; khẳng định, Galaxy Note 10+ l&agrave; chiếc smartphone c&oacute; camera tốt nhất hiện nay.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-26.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Giao diện camera sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-26.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Giao diện camera sau\" /></a></p>\r\n\r\n<p>Galaxy Note 10+ c&oacute; camera ch&iacute;nh 12 MP với khẩu độ c&oacute; thể thay đổi từ F/1.5 &ndash; F/2.4, hỗ trợ&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/che-do-chong-rung-quang-hoc-ois-chup-anh-tren-sm-906416\" target=\"_blank\" title=\"Tìm hiểu về công nghệ chống rung quang học OIS\" type=\"Tìm hiểu về công nghệ chống rung quang học OIS\">chống rung quang học OIS</a>&nbsp;v&agrave; tự động lấy n&eacute;t dual-pixel.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-34.jpg\" />Ảnh chụp g&oacute;c si&ecirc;u rộng 0.5x tr&ecirc;n Note 10</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-33.jpg\" />Ảnh chụp g&oacute;c rộng 1x tr&ecirc;n Note 10</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-35.jpg\" />Ảnh chụp g&oacute;c thường 2x tr&ecirc;n Note 10</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Tiếp theo l&agrave; cảm biến camera g&oacute;c si&ecirc;u rộng 16 MP khẩu độ F/2.2 c&ugrave;ng ống k&iacute;nh tele 12 MP khẩu độ F/2.1 v&agrave; n&oacute; cũng c&oacute; th&ecirc;m 1 cảm biến 3D ToF, điều m&agrave; Samsung Galaxy Note 10 kh&ocirc;ng được trang bị.</p>\r\n\r\n<p>Samsung đ&atilde; cải thiện c&aacute;c thuật to&aacute;n xử l&yacute; b&ecirc;n trong phần mềm gi&uacute;p m&aacute;y c&oacute; khả năng phơi s&aacute;ng tốt, nhất qu&aacute;n v&agrave; ch&iacute;nh x&aacute;c cho d&ugrave; trong điều kiện &aacute;nh s&aacute;ng thế n&agrave;o.</p>\r\n\r\n<p>Galaxy Note 10+ cũng hỗ trợ zoom quang 2x, n&oacute; c&oacute; thể chụp h&igrave;nh ảnh với m&agrave;u sắc sống động, độ chi tiết cao v&agrave; độ nhiễu thấp.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-31.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Ảnh chụp ban đêm\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-31.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Ảnh chụp ban đêm\" /></a></p>\r\n\r\n<p>Galaxy Note 10+ cũng c&oacute; một t&iacute;nh năng mới l&agrave; Live Focus Video cho ph&eacute;p &aacute;p dụng hiệu ứng bokeh v&agrave;o c&aacute;c video quay được cũng như h&igrave;nh ảnh, c&ugrave;ng c&aacute;c hiệu ứng kh&aacute;c như thay đổi m&agrave;u ph&ocirc;ng nền.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-32.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Ảnh chụp ban đêm\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-32.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Ảnh chụp ban đêm\" /></a></p>\r\n\r\n<p>Galaxy Note 10+ vẫn c&ograve;n những t&iacute;nh năng mới kh&aacute;c như chế độ AR cho ph&eacute;p vẽ l&ecirc;n c&aacute;c video gọi l&agrave; AR Doodle, t&iacute;nh năng ph&oacute;ng to mic để thu &acirc;m thanh r&otilde; hơn ở từng phần cụ thể của cảnh khi đang quay video.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-30.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Ảnh chụp thiếu sáng\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-30.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Ảnh chụp thiếu sáng\" /></a></p>\r\n\r\n<p>Galaxy Note 10+ c&oacute; t&iacute;nh năng Si&ecirc;u chống rung cực ấn tượng, gi&uacute;p người d&ugrave;ng c&oacute; được những thước phim mượt m&agrave;, giảm thiểu tối đa sự giật lag ảnh hưởng tới sự tập trung khi xem.</p>\r\n\r\n<p>Camera selfie 10 MP ở mặt trước với t&iacute;nh năng l&agrave;m đẹp được t&iacute;ch hợp sẵn hứa hẹn sẽ kh&ocirc;ng l&agrave;m người d&ugrave;ng phải thất vọng với chất lượng ảnh mang lại.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-blue-g2_800x600.jpg\" onclick=\"return false;\"><img alt=\" Galaxy Note 10+ | Camera selfie 10 MP\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-blue-g2_800x600.jpg\" title=\" Galaxy Note 10+ | Camera selfie 10 MP\" /></a></p>\r\n\r\n<h3>C&ocirc;ng nghệ sạc nhanh&nbsp;Superfast Charge 45W</h3>\r\n\r\n<p>Samsung Galaxy Note 10+ ch&iacute;nh l&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\">smartphone</a>&nbsp;duy nhất tại thời điểm hiện tại hỗ trợ sạc nhanh l&ecirc;n tới 45W của Samsung.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-23.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh trên Type-C\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-23.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh trên Type-C\" /></a></p>\r\n\r\n<p>C&ocirc;ng nghệ sạc nhanh Superfast Charge mới n&agrave;y cung cấp nhiều năng lượng hơn so với chuẩn sạc xuất hiện tr&ecirc;n c&aacute;c flagship&nbsp;<a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone Samsung chính hãng\">Samsung</a>&nbsp;trước đ&acirc;y.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-21.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-21.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh\" /></a></p>\r\n\r\n<p>Nhanh gấp ba lần Adaptive Fast Charge v&agrave; nhanh hơn 6 lần so với sạc qua cổng USB ti&ecirc;u chuẩn.</p>\r\n\r\n<p>C&ocirc;ng nghệ sạc si&ecirc;u nhanh n&agrave;y gi&uacute;p bạn c&oacute; thể sạc đầy vi&ecirc;n pin c&oacute; dung lượng 4300 mAh của m&aacute;y chỉ trong chưa đầy một giờ đồng hồ.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-12.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-12.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh\" /></a></p>\r\n\r\n<p>Khi m&agrave; dung lượng pin đang tụt lại ph&iacute;a sau so với những cải tiến về camera hay cấu h&igrave;nh th&igrave; việc hỗ trợ c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\">sạc nhanh</a>&nbsp;đến như vậy cũng sẽ gi&uacute;p người d&ugrave;ng Samsung phần n&agrave;o bớt được thời gian chờ đợi nạp năng lượng cho m&aacute;y.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-10.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-10.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Khả năng sạc nhanh\" /></a></p>\r\n\r\n<p>Bạn cũng cần lưu &yacute; l&agrave; m&aacute;y chỉ đi k&egrave;m với cục sạc 25W v&agrave; để sử dụng c&ocirc;ng nghệ sạc nhanh tối đa n&agrave;y th&igrave; bạn phải mua th&ecirc;m củ sạc 45W b&ecirc;n ngo&agrave;i nhưng d&ugrave; sao hỗ trợ sạc nhanh tới 45W đ&atilde; l&agrave; điểm cộng qu&aacute; lớn so với những chiếc m&aacute;y đầu bảng kh&aacute;c.</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia-samsung-galaxy-note-10--flagship-cao-cap-voi-dua-than-s-pen-1185800\" target=\"_blank\" title=\"Đánh giá Samsung Galaxy Note 10+\" type=\"Đánh giá Samsung Galaxy Note 10+\">Đ&aacute;nh gi&aacute; Samsung Galaxy Note 10+: Flagship cao cấp với &#39;đũa thần&#39; S-Pen</a></p>\r\n\r\n<h3>M&agrave;n h&igrave;nh lớn thoải m&aacute;i sử dụng</h3>\r\n\r\n<p>Samsung Galaxy Note 10+ l&agrave; một chiếc điện thoại rất lớn, rất c&oacute; thể l&agrave; chiếc điện thoại lớn nhất bạn từng sử dụng, với m&agrave;n h&igrave;nh AMOLED Infinity-O 6.8 inch c&oacute; độ ph&acirc;n giải 3.040 x 1.440 pixels (498 ppi).</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-7.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Thiết kế màn hình lớn\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-7.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Thiết kế màn hình lớn\" /></a></p>\r\n\r\n<p>C&ocirc;ng nghệ m&agrave;n h&igrave;nh&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/cong-nghe-ma-hinh-dynamic-amoled-co-gi-noi-bat-1151123\" target=\"_blank\" title=\"Tìm hiểu màn hình Dynamic AMOLED\">Dynamic AMOLED</a>&nbsp;ti&ecirc;n tiến n&agrave;y c&ograve;n cho ra m&agrave;n h&igrave;nh &iacute;t &aacute;nh s&aacute;ng xanh hơn nhằm gi&uacute;p mắt thoải m&aacute;i.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-14.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Màn hình phủ lớp HDR10+\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-14.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Màn hình phủ lớp HDR10+\" /></a></p>\r\n\r\n<p>M&agrave;n h&igrave;nh hỗ trợ cả nội dung HDR10+ v&igrave; thế c&aacute;c chương tr&igrave;nh phim ảnh, game v&agrave; c&aacute;c nội dung kh&aacute;c được hiển thị rất đẹp.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-20.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-20.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Màn hình\" /></a></p>\r\n\r\n<p>Với thiết kế những cạnh tr&ograve;n ở mặt sau khiến điện thoại rất thoải m&aacute;i khi cầm, trong trường hợp bạn c&oacute; b&agrave;n tay đủ lớn để cầm v&agrave; giữ n&oacute;.</p>\r\n\r\n<p>Mặt sau của Note 10+ được l&agrave;m bằng k&iacute;nh, c&ograve;n khung th&igrave; được l&agrave;m bằng kim loại, mang đến sự tinh tế v&agrave; sang trọng cho điện thoại.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-24.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Màn hình\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-24.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Màn hình\" /></a></p>\r\n\r\n<p>Galaxy Note 10+ c&oacute; hỗ trợ chuẩn chống nước, chống bụi IP68 v&igrave; thế c&oacute; thể sử dụng ở b&atilde;i biển m&agrave; kh&ocirc;ng sợ bắn nước hay c&aacute;c x&acirc;m nhập v&agrave;o c&aacute;c cổng kết nối.</p>\r\n\r\n<h3>B&uacute;t S Pen ng&agrave;y c&agrave;ng nhiều t&iacute;nh năng</h3>\r\n\r\n<p>S Pen ch&iacute;nh l&agrave; một trong những yếu tố cốt l&otilde;i khiến d&ograve;ng Galaxy Note trở n&ecirc;n đặc biệt v&agrave; hấp dẫn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-29.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ |Trải nghiệm Bút S-Pen\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-29.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ |Trải nghiệm Bút S-Pen\" /></a></p>\r\n\r\n<p>B&uacute;t S Pen c&oacute; nhiều t&iacute;nh năng hơn b&uacute;t cảm ứng stylus th&ocirc;ng thường, từ ghi ch&uacute; nhanh bằng c&aacute;ch viết tr&ecirc;n m&agrave;n h&igrave;nh kh&oacute;a, đến chụp ảnh từ xa với S Pen.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-28.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Khe cắm bút S-Pen\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-28.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Khe cắm bút S-Pen\" /></a></p>\r\n\r\n<p>Giờ đ&acirc;y b&uacute;t S Pen tr&ecirc;n Note 10+ đ&atilde; được n&acirc;ng cấp, v&agrave; hiện tại đ&atilde; hỗ trợ điều khiển bằng cử chỉ.</p>\r\n\r\n<p>T&iacute;nh năng n&agrave;y cho ph&eacute;p người d&ugrave;ng điều khiển một số ứng dụng của Samsung như camera,&hellip; từ xa m&agrave; kh&ocirc;ng cần chạm v&agrave;o điện thoại.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/206176/samsung-galaxy-note-10-plus-tgdd-17.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại Samsung Galaxy Note 10+ | Bút S-Pen\" src=\"https://cdn.tgdd.vn/Products/Images/42/206176/samsung-galaxy-note-10-plus-tgdd-17.jpg\" title=\"Điện thoại Samsung Galaxy Note 10+ | Bút S-Pen\" /></a></p>\r\n\r\n<p>V&iacute; dụ ứng dụng camera tr&ecirc;n m&aacute;y hỗ trợ kết nối với S Pen, cho ph&eacute;p bạn biến b&uacute;t S Pen th&agrave;nh c&ocirc;ng cụ gi&uacute;p bạn điều chỉnh ống k&iacute;nh camera, thay đổi m&agrave;u sắc, zoom,...giống như đang thao t&aacute;c bằng tay.</p>\r\n', 'f691b415c1c669b513024ffd86114acb6b4ff503.jpg', 4, 0, NULL, 17990000, 'Dynamic AMOLED, 6.8\", Quad HD+ (2K+)', 'Android 9 (Pie)', ' Chính 12 MP & Phụ 12 MP, 16 MP, TOF 3D', '10 MP', 'Exynos 9825 8 nhân', '2 Nano SIM (SIM 2 chung khe thẻ nhớ), Hỗ trợ 4G', '	4300 mAh, có sạc nhanh', '2020-10-31 12:47:18', 1);
INSERT INTO `phones` (`id`, `brand_id`, `name`, `description`, `content`, `thumb`, `stock`, `promotion_id`, `video`, `price`, `screen`, `os`, `camera_back`, `camera_front`, `cpu`, `sim`, `battery`, `date_created`, `is_featured`) VALUES
(16, 0, 'Điện thoại OPPO Find X2', 'Description\r\n', '\r\n<h3>Tiếp nối th&agrave;nh c&ocirc;ng vang dội của thế hệ Find X,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-oppo\" target=\"_blank\" title=\"Tham khảo giá smartphone Oppo chính hãng\">OPPO</a>&nbsp;ch&iacute;nh thức ra mắt&nbsp;<a href=\"https://www.thegioididong.com/dtdd/oppo-find-x2\" target=\"_blank\" title=\"Tham khảo giá Oppo Find X2 chính hãng\">Find X2</a>&nbsp;với những đường n&eacute;t thanh lịch từ thiết kế phần cứng cho đến trải nghiệm phần mềm, hứa hẹn một vẻ đẹp ho&agrave;n hảo, một sức mạnh xứng tầm.</h3>\r\n\r\n<h3>Trải nghiệm thị gi&aacute;c tuyệt vời</h3>\r\n\r\n<p>Find X2 sở hữu m&agrave;n h&igrave;nh AMOLED Ultra Vision cao cấp với k&iacute;ch thước&nbsp;<a href=\"https://www.thegioididong.com/dtdd-tu-6-inch\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone màn hình lớn trên 6 inch\">l&ecirc;n đến 6.78 inch</a>&nbsp;c&ugrave;ng độ ph&acirc;n giải 2K+ cực n&eacute;t được bảo vệ bằng k&iacute;nh cường lực&nbsp;Corning Gorilla Glass 6 cao cấp.</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/oppo-find-x2-vs-oppo-find-x-1243396\" target=\"_blank\" title=\"OPPO Find X2 VS OPPO Find X: Phương trình tìm X bậc 2 có gì hấp dẫn hơn?\" type=\"OPPO Find X2 VS OPPO Find X: Phương trình tìm X bậc 2 có gì hấp dẫn hơn?\">OPPO Find X2 VS OPPO Find X: Phương tr&igrave;nh t&igrave;m X bậc 2 c&oacute; g&igrave; hấp dẫn hơn?</a></p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd2-1.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Màn hình Ultra Vision \" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd2-1.jpg\" title=\"Oppo Find X2 | Màn hình Ultra Vision \" /></a></p>\r\n\r\n<p>M&agrave;n h&igrave;nh n&agrave;y c&oacute; độ s&aacute;ng cao, h&igrave;nh ảnh sống động với hơn 1 tỷ m&agrave;u, c&ugrave;ng c&ocirc;ng nghệ HDR10+ ti&ecirc;n tiến v&agrave; nhiều t&iacute;nh năng th&ocirc;ng minh kh&aacute;c, hứa hẹn sẽ đem đến một trải nghiệm thị gi&aacute;c tuyệt vời, m&agrave;n h&igrave;nh Find X2 được Displaymate đ&aacute;nh gi&aacute; rất cao, nằm trong top những chiếc smartphone c&oacute; m&agrave;n h&igrave;nh tốt nhất t&iacute;nh đến thời điểm hiện tại (3/2020).</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd6-1.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Thiết kế độc đáo\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd6-1.jpg\" title=\"Oppo Find X2 | Thiết kế độc đáo\" /></a></p>\r\n\r\n<p>Đặc biệt hơn, m&agrave;n h&igrave;nh Ultra Vision của Find X2 cung cấp tốc độ l&agrave;m mới 120 Hz c&oacute; thể k&iacute;ch hoạt c&ugrave;ng độ ph&acirc;n giải QHD+, cho mọi h&igrave;nh ảnh chuyển động mượt m&agrave;, trơn tru nhất. Tốc độ lấy mẫu cảm ứng l&ecirc;n tới 240 Hz đ&aacute;p ứng ngay lập tức mọi thao t&aacute;c chạm, vuốt của bạn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd12.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Công nghệ màn hình hiện đại\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd12.jpg\" title=\"Oppo Find X2 | Công nghệ màn hình hiện đại\" /></a></p>\r\n\r\n<p>C&oacute; phần cứng cao cấp, OPPO c&ograve;n hỗ trợ bằng bằng phần mềm để n&acirc;ng cấp c&aacute;c đoạn phim th&ocirc;ng thường l&ecirc;n chuẩn HDR v&agrave; tăng mức khung h&igrave;nh l&ecirc;n đến 60 Hz bằng AI, gi&uacute;p trải nghiệm xem tr&ecirc;n OPPO Find X2 lu&ocirc;n đ&atilde; mắt v&agrave; mượt m&agrave; tr&ecirc;n bất k&igrave; loại nội dung n&agrave;o.&nbsp;</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-o1.jpg\" onclick=\"return false;\"><img alt=\"Công nghệ nâng cấp hình ảnh bằng AI trên OPPO Find X2\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-o1.jpg\" title=\"Công nghệ nâng cấp hình ảnh bằng AI trên OPPO Find X2\" /></a></p>\r\n\r\n<p>Ngo&agrave;i ra, hệ thống bảo vệ mắt th&iacute;ch ứng AI tr&ecirc;n OPPO Find X2 c&ograve;n gi&uacute;p tự động tối ưu nhiệt độ, độ s&aacute;ng m&agrave;n h&igrave;nh dựa v&agrave;o m&ocirc;i trường.&nbsp;</p>\r\n\r\n<p>B&ecirc;n cạnh c&ocirc;ng nghệ m&agrave;n h&igrave;nh đỉnh, OPPO Find X2 c&ograve;n sở hữu hệ thống loa k&eacute;p c&ugrave;ng c&ocirc;ng nghệ Dolby Atmos cung cấp trải nghiệm giải tr&iacute; cực đ&atilde;, đắm ch&igrave;m trong từng m&agrave;n game, thước phim.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd3-1.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Công nghệ âm thanh sống động, chân thực\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd3-1.jpg\" title=\"Oppo Find X2 | Công nghệ âm thanh sống động, chân thực\" /></a></p>\r\n\r\n<p>C&ograve;n lại, mặt lưng của m&aacute;y cũng được thiết kế bằng k&iacute;nh cường lực cao cấp&nbsp;với c&aacute;c họa tiết hoa văn cắt ch&eacute;o, c&ugrave;ng hiệu ứng chuyển đổi m&agrave;u sắc theo g&oacute;c nh&igrave;n mang lại cảm gi&aacute;c tinh tế v&agrave; hiện đại.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd5-1.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Thiết kế phím nguồn\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd5-1.jpg\" title=\"Oppo Find X2 | Thiết kế phím nguồn\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute;, m&aacute;y chỉ nhẹ 209 gram đối với phi&ecirc;n bản đen (gốm) v&agrave; nặng 192 gram đối với phi&ecirc;n bản m&agrave;u xanh (k&iacute;nh cường lực) c&ugrave;ng độ mỏng&nbsp;8.0 mm cũng l&agrave; một ưu điểm vượt trội tr&ecirc;n flagship nh&agrave; OPPO.</p>\r\n\r\n<h3>Hệ thống camera đỉnh cao</h3>\r\n\r\n<p>Find X2 tự tin l&agrave; một trong những&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\">smartphone</a>&nbsp;c&oacute; chất lượng camera h&agrave;ng đầu hiện nay với bộ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone camera chụp hình góc rộng\">camera g&oacute;c rộng</a>&nbsp;48 MP, camera zoom quang 13 MP v&agrave; g&oacute;c si&ecirc;u rộng 12 MP.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd4-1.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Camera đỉnh cao\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd4-1.jpg\" title=\"Oppo Find X2 | Camera đỉnh cao\" /></a></p>\r\n\r\n<p>Find X2 sở hữu khả năng chống rung quang học OIS k&eacute;p, zoom kỹ thuật số 20x, zoom&nbsp;kết hợp quang/số&nbsp;5x, chụp ảnh g&oacute;c si&ecirc;u rộng 120 độ v&agrave; chụp cận cảnh macro với khoảng c&aacute;ch si&ecirc;u gần 3 cm.</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia-camera-oppo-find-x2-1244124\" target=\"_blank\" title=\"Đánh giá camera OPPO Find X2: Chụp macro tốt dù không có camera macro\" type=\"Đánh giá camera OPPO Find X2: Chụp macro tốt dù không có camera macro\">Đ&aacute;nh gi&aacute; camera OPPO Find X2: Chụp macro tốt d&ugrave; kh&ocirc;ng c&oacute; camera macro</a></p>\r\n\r\n<p>B&ecirc;n cạnh th&ocirc;ng số khủng, OPPO Find X2 được trang bị nhiều chế độ chụp ảnh n&acirc;ng cao, điển h&igrave;nh như chế độ si&ecirc;u chụp đ&ecirc;m 3.0, với khả năng khử nhiễu vượt trội, giữ được tối đa c&aacute;c chi tiết một c&aacute;ch r&otilde; r&agrave;ng, trong trẻo trong điều kiện thiếu s&aacute;ng.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-hinh-3-1.jpg\" />Ảnh chụp từ camera sau tr&ecirc;n điện thoại Oppo Find X2</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-hinh-4-1.jpg\" />Ảnh chụp từ camera sau tr&ecirc;n điện thoại Oppo Find X2</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-hinh-5-2.jpg\" />Ảnh chụp từ camera sau tr&ecirc;n điện thoại Oppo Find X2</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-hinh-1-1.jpg\" />Ảnh chụp từ camera sau tr&ecirc;n điện thoại Oppo Find X2</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>OPPO cũng đặt nhiều t&acirc;m huyết với khả năng quay phim của Find X2 bằng c&aacute;ch trang bị c&ocirc;ng nghệ Si&ecirc;u chống rung Pro. Khi bật t&iacute;nh năng n&agrave;y, những đoạn video quay được sẽ c&oacute; độ ổn định cao kể cả trong nhiều điều khiện rung lắc mạnh như gắn tr&ecirc;n xe đạp, cầm chạy bộ... m&agrave; kh&ocirc;ng cần d&ugrave;ng đến gi&aacute; đỡ ổn định.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-chong-rung-3.gif\" onclick=\"return false;\"><img alt=\"Khả năng chống rung trên Find X2\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-chong-rung-3.gif\" title=\"Khả năng chống rung trên Find X2\" /></a></p>\r\n\r\n<p>Camera trước của Find X2 c&oacute; độ ph&acirc;n giải 32 MP, gi&uacute;p bạn tự tin tỏa s&aacute;ng trong mọi điều kiện. Độ ph&acirc;n giải cao v&agrave; c&aacute;c thuật to&aacute;n AI gi&uacute;p ảnh selfie của bạn tr&ocirc;ng bắt mắt nhưng vẫn đảm bảo sự tự nhi&ecirc;n cao nhất.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-tgdd8.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Camera selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-tgdd8.jpg\" title=\"Oppo Find X2 | Camera selfie\" /></a></p>\r\n\r\n<p>Vốn nổi tiếng về khả năng chụp ảnh ch&acirc;n dung cho nước ảnh v&agrave; m&agrave;u da nịnh mắt. Camera trước của OPPO Find X2 cũng hỗ trợ khả năng chụp đ&ecirc;m ấn tượng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/198150/oppo-find-x2-hinh-2-1.jpg\" onclick=\"return false;\"><img alt=\"Oppo Find X2 | Chụp selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/198150/oppo-find-x2-hinh-2-1.jpg\" title=\"Oppo Find X2 | Chụp selfie\" /></a></p>\r\n', 'a964aa83cbd116cb8bf14b3199ba9aef500a750d.jpg', 10, 0, NULL, 19990000, 'AMOLED, 6.78\", Quad HD+ (2K+)', 'Android 10', ' Chính 48 MP & Phụ 13 MP, 12 MP', '32 MP', 'Snapdragon 865 8 nhân', ' 2 Nano SIM, Hỗ trợ 5G', '4200 mAh, có sạc nhanh', '2020-10-31 12:57:28', 0),
(17, 0, 'Điện thoại Xiaomi POCO X3 NFC', 'Description\r\n', '<h3>Tiếp nối sự th&agrave;nh c&ocirc;ng về thế mạnh l&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd?p=tu-4-7-trieu\" target=\"_blank\" title=\"Tham khảo điện thoại tầm trung chính hãng tại Thế Giới Di Động\">điện thoại tầm trung</a>&nbsp;với thiết kế hiện đại sang trọng,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-xiaomi\" target=\"_blank\" title=\"Tham khảo điện thoại Xiaomi tại Thế Giới Di Động\">Xiaomi</a>&nbsp;đ&atilde; cho ra mắt&nbsp;<a href=\"https://www.thegioididong.com/dtdd/xiaomi-poco-x3\" target=\"_blank\" title=\"Tham khảo điện thoại Xiaomi POCO X3 tại Thế Giới Di Động\">Xiaomi POCO X3 NFC</a>&nbsp;mang theo nhiều t&iacute;nh năng hấp dẫn tr&ecirc;n 1 chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo điện thoại chính hãng tại Thế Giới Di Động\">điện thoại th&ocirc;ng minh</a>, cụm camera chất lượng, hiệu năng mạnh mẽ, dung lượng pin khủng c&ugrave;ng khả năng sạc nhanh vượt trội 33W.</h3>\r\n\r\n<h3>Hệ thống camera đột ph&aacute;, ấn tượng</h3>\r\n\r\n<p>Cụm 4 camera của POCO X3 được đặt ph&iacute;a tr&ecirc;n ở giữa mặt lưng với cảm biến ch&iacute;nh 64 MP hỗ trợ khả năng chụp đ&ecirc;m (<a href=\"https://www.thegioididong.com/hoi-dap/che-do-chup-dem-night-mode-la-gi-907873\" target=\"_blank\" title=\"Tìm hiểu chế độ chụp Night Mode là gì?\">Night Mode</a>) ấn tượng gi&uacute;p lấy n&eacute;t nhanh, giảm nhiễu v&agrave; thu s&aacute;ng tốt hơn cho bạn những tấm ảnh trong m&agrave;n đ&ecirc;m r&otilde; n&eacute;t v&agrave; chi tiết.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-220820-100848.jpg\" onclick=\"return false;\"><img alt=\"Cụm camera chất lượng đa tính năng | POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-220820-100848.jpg\" title=\"Cụm camera chất lượng đa tính năng | POCO X3 NFC\" /></a></p>\r\n\r\n<p>Ba camera c&ograve;n lại bao gồm camera g&oacute;c si&ecirc;u rộng 13 MP,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-xoa-phong\" target=\"_blank\" title=\"Tham khảo điện thoại có camera xóa phông tại Thế Giới Di Động\">camera x&oacute;a ph&ocirc;ng</a>&nbsp;2 MP v&agrave; cuối c&ugrave;ng l&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-macro\" target=\"_blank\" title=\"Tham khảo điện thoại có camera macro tại Thế Giới Di Động\">camera macro</a>&nbsp;2 MP hỗ trợ chụp cận cảnh.</p>\r\n\r\n<p>Thiết bị cũng hỗ trợ c&aacute;c t&iacute;nh năng chụp ảnh th&ocirc;ng minh, tối ưu m&agrave;u sắc, quay phim 4K gi&uacute;p người d&ugrave;ng c&oacute; những tấm ảnh hay video chất lượng cao nhất trong mỗi khung h&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-203020-063050.jpg\" onclick=\"return false;\"><img alt=\"Ảnh chụp trên camera trước | POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-203020-063050.jpg\" title=\"Ảnh chụp trên camera trước | POCO X3 NFC\" /></a></p>\r\n\r\n<p>Chế độ chụp ch&acirc;n dung tr&ecirc;n POCO X3 c&oacute; những n&eacute;t cải tiến r&otilde; rệt khi c&oacute; thể x&oacute;a ph&ocirc;ng sắc n&eacute;t d&ugrave; l&agrave; khoảng c&aacute;ch gần hay xa. Đồng thời tr&iacute; tuệ nh&acirc;n tạo AI sẽ can thiệp để khu&ocirc;n mặt của bạn r&otilde; n&eacute;t d&ugrave; chụp ở những m&ocirc;i trường phức tạp.</p>\r\n\r\n<p>Ở mặt trước l&agrave; camera selfie 20 MP được t&iacute;ch hợp c&aacute;c thuật to&aacute;n th&ocirc;ng minh, l&agrave;m đẹp gi&uacute;p bạn tự tin tỏa s&aacute;ng với bạn b&egrave;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-220820-100857.jpg\" onclick=\"return false;\"><img alt=\"Camera selfie 20 MP | POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-220820-100857.jpg\" title=\"Giải trí trên màn hình siêu mượt 120Hz | POCO X3 NFC\" /></a></p>\r\n\r\n<h3>M&agrave;n h&igrave;nh giải tr&iacute; si&ecirc;u mượt 120 Hz</h3>\r\n\r\n<p>Xiaomi POCO X3 được trang bị&nbsp;<a href=\"https://www.thegioididong.com/dtdd-man-hinh-tran-vien\" target=\"_blank\" title=\"Tham khảo điện thoại có màn hình tràn viền tại Thế Giới Di Động\">m&agrave;n h&igrave;nh tr&agrave;n viền</a>&nbsp;IPS LCD 6.67 inch với độ ph&acirc;n giải Full HD+ cho chất lượng hiển thị sắc n&eacute;t, m&agrave;u sắc ch&acirc;n thực. B&ecirc;n cạnh đ&oacute;, m&agrave;n h&igrave;nh hỗ trợ tốc độ l&agrave;m mới 120 Hz gi&uacute;p cho mọi hoạt động hay chơi game mượt m&agrave; v&agrave; trơn tru hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-203120-063128.jpg\" onclick=\"return false;\"><img alt=\"Giải trí trên màn hình siêu mượt 120Hz | POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-203120-063128.jpg\" title=\"Giải trí trên màn hình siêu mượt 120Hz | POCO X3 NFC\" /></a></p>\r\n\r\n<p>M&aacute;y được thiết kế nguy&ecirc;n khối v&agrave; bọc k&iacute;nh cường lực Corning Gorilla Glass 5 ở mặt trước v&agrave; lớp nhựa giả k&iacute;nh cao cấp mặt lưng g&oacute;p phần tăng độ cứng c&aacute;p lẫn n&eacute;t sang trọng cho m&aacute;y.</p>\r\n\r\n<p>Giờ đ&acirc;y&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-van-tay\" target=\"_blank\" title=\"Tham khảo điện thoại có bảo mật vân tay tại Thế Giới Di Động\">bảo mật v&acirc;n tay</a>&nbsp;được trang bị b&ecirc;n cạnh viền của m&aacute;y gi&uacute;p bạn dễ d&agrave;ng mở kh&oacute;a một c&aacute;ch nhanh ch&oacute;ng. Ngo&agrave;i ra bạn c&oacute; thể sử dụng t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-bao-mat-khuon-mat\" target=\"_blank\" title=\"Tham khảo điện thoại có bảo mật khuôn mặt tại Thế Giới Di Động\">bảo mật khu&ocirc;n mặt</a>&nbsp;trong l&uacute;c kh&ocirc;ng tay bạn kh&ocirc;ng thuận tiện cho việc mở kh&oacute;a.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-203120-063110.jpg\" onclick=\"return false;\"><img alt=\"Cảm biến vân tay đặt ở cạnh viền | POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-203120-063110.jpg\" title=\"Cảm biến vân tay đặt ở cạnh viền | POCO X3 NFC\" /></a></p>\r\n\r\n<h3>Chiến game mượt m&agrave; với Snapdragon 732G</h3>\r\n\r\n<p>Dung lượng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-ram-4-den-6gb\" target=\"_blank\" title=\"Tham khảo điện thoại có RAM từ 4 GB đến 6 GB tại Thế Giới Di Động\">RAM 6 GB</a>&nbsp;đem lại khả năng đa nhiệm tốt,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-rom-128-den-256gb\" target=\"_blank\" title=\"Tham khảo điện thoại có bộ nhớ trong 128 GB đến 256 GB tại Thế Giới Di Động\">bộ nhớ trong 128 GB</a>&nbsp;v&agrave; thẻ nhớ ngo&agrave;i MicroSD hỗ trợ tối đa 256 GB cho người d&ugrave;ng kh&ocirc;ng gian lưu trữ lớn với c&aacute;c ứng dụng nặng hay video.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-203120-063100.jpg\" onclick=\"return false;\"><img alt=\"Dung lượng RAM 6 GB và ROM 128 GB |  POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-203120-063100.jpg\" title=\"Dung lượng RAM 6 GB và ROM 128 GB |  POCO X3 NFC\" /></a></p>\r\n\r\n<p>Điểm số m&agrave; POCO X3 đo được tr&ecirc;n Antutu l&agrave; 282.004 điểm, k&egrave;m theo đ&oacute; l&agrave; bộ vi xử l&yacute; Snapdragon 732G v&agrave; chip đồ họa GPU Adreno 618 gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo điện thoại chơi game - cấu hình cao tại Thegioididong.com \">điện thoại chơi game</a>&nbsp;đồ hoạ cao hot nhất hiện nay một c&aacute;ch mượt m&agrave;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-131720-081751.jpg\" onclick=\"return false;\"><img alt=\"Điểm Antutu 282.004 điểm | Xiaomi POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-131720-081751.jpg\" title=\"Điểm Antutu 282.004 điểm | Xiaomi POCO X3 NFC\" /></a></p>\r\n\r\n<h3>Vi&ecirc;n pin khủng 5160 mAh, thoải m&aacute;i sử dụng</h3>\r\n\r\n<p>Xiaomi POCO X3 l&agrave; chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-pin-khung\" target=\"_blank\" title=\"Tham khảo điện thoại pin khủng tại Thế Giới Di Động\">điện thoại pin tr&acirc;u</a>&nbsp;khi sở hữu vi&ecirc;n pin khủng 5160 mAh đ&aacute;p ứng tốt nhu cầu sử dụng c&aacute;c t&aacute;c vụ th&ocirc;ng thường cả ng&agrave;y d&agrave;i.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/227900/xiaomi-poco-x3-220920-100919.jpg\" onclick=\"return false;\"><img alt=\"Viên pin khủng 5160 mAh thoải mái sử dụng ngày dài | POCO X3 NFC\" src=\"https://cdn.tgdd.vn/Products/Images/42/227900/xiaomi-poco-x3-220920-100919.jpg\" title=\"Viên pin khủng 5160 mAh thoải mái sử dụng ngày dài | POCO X3 NFC\" /></a></p>\r\n\r\n<p>Để sạc cho vi&ecirc;n pin khủng th&igrave; Xiaomi đ&atilde; t&iacute;ch hợp cho m&aacute;y c&ocirc;ng nghệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo điện thoại có sạc pin nhanh tại Thế Giới Di Động\">sạc pin nhanh</a>&nbsp;33W qua cổng Type-C gi&uacute;p bạn nhanh ch&oacute;ng trở lại những trận đấu game gay cấn.</p>\r\n\r\n<p>Với những t&iacute;nh năng hấp dẫn được trang bị tr&ecirc;n m&aacute;y, Xiaomi POCO X3 NFC l&agrave; sản phẩm tầm trung rất ph&ugrave; hợp đa số người d&ugrave;ng ưa th&iacute;ch một thiết kế s&aacute;ng trọng, cụm camera chất lượng v&agrave; hiệu năng mạnh mẽ.</p>\r\n', '613c8157f67cac2a72c9ba3cd6cc5de0591e5a8f.jpg', 79, 0, NULL, 6990000, 'IPS LCD, 6.67\", Full HD+', 'Android 10', ' Chính 64 MP & Phụ 13 MP, 2 MP, 2 MP', '20 MP', 'Snapdragon 732G 8 nhân', '2 Nano SIM (SIM 2 chung khe thẻ nhớ), Hỗ trợ 4G', '5160 mAh, có sạc nhanh', '2020-10-31 13:11:50', 0),
(18, 0, 'Điện thoại iPhone 11 128GB', 'Description\r\n', '<h2>Được xem l&agrave; phi&ecirc;n bản iPhone &quot;gi&aacute; rẻ&quot; trong bộ 3 iPhone mới ra mắt nhưng&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-128gb\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone 11 128GB chính hãng\">iPhone 11 128GB</a>&nbsp;vẫn sở hữu cho m&igrave;nh rất nhiều ưu điểm m&agrave; hiếm c&oacute; một chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chính hãng\">smartphone</a>&nbsp;n&agrave;o kh&aacute;c sở hữu.</h2>\r\n\r\n<h3>N&acirc;ng cấp mạnh mẽ về cụm camera</h3>\r\n\r\n<p>Năm nay với iPhone 11 th&igrave; Apple đ&atilde; n&acirc;ng cấp kh&aacute; nhiều về camera nếu so s&aacute;nh với chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xr-128gb\" target=\"_blank\" title=\"Tham khảo điện thoại iPhone Xr chính hãng\">iPhone Xr 128GB</a>&nbsp;năm ngo&aacute;i.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd7-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Cụm camera kép phía sau\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd7-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Cụm camera kép phía sau\" /></a></p>\r\n\r\n<p>Ch&uacute;ng ta đ&atilde; c&oacute; bộ đ&ocirc;i&nbsp;<a href=\"https://www.thegioididong.com/dtdd-nhieu-camera\" target=\"_blank\" title=\"Tham khảo giá điện thoại có camera kép và nhiều camera\" type=\"Tham khảo giá điện thoại có camera kép và nhiều camera\">camera k&eacute;p</a>&nbsp;thay v&igrave; camera đơn như tr&ecirc;n thế hệ cũ v&agrave; với một camera g&oacute;c si&ecirc;u rộng th&igrave; bạn cũng c&oacute; nhiều hơn những lựa chọn khi chụp h&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd9.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Giao diện chụp ảnh\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd9.jpg\" title=\"Điện thoại iPhone 11 128GB | Giao diện chụp ảnh\" /></a></p>\r\n\r\n<p>Trước đ&acirc;y để lấy được hết kiến tr&uacute;c của một t&ograve;a nh&agrave;, để ghi lại hết sự h&ugrave;ng vĩ của một ngọn n&uacute;i th&igrave; kh&ocirc;ng c&ograve;n c&aacute;ch n&agrave;o kh&aacute;c l&agrave; bạn phải di chuyển ra kh&aacute; xa để chụp.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd1-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Ảnh chụp góc siêu rộng\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd1-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Ảnh chụp góc siêu rộng\" /></a></p>\r\n\r\n<p>Ảnh chụp chế độ g&oacute;c si&ecirc;u rộng</p>\r\n\r\n<p>Nhưng với&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo các dòng điện thoại hỗ trợ chụp góc rộng\" type=\"Tham khảo các dòng điện thoại hỗ trợ chụp góc rộng\">g&oacute;c si&ecirc;u rộng</a>&nbsp;tr&ecirc;n iPhone 11 th&igrave; c&oacute; thể cho bạn những bức ảnh với hiệu ứng g&oacute;c rộng rất ấn tượng v&agrave; th&iacute;ch mắt.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd7.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Ảnh chụp chế độ chân dung\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd7.jpg\" title=\"Điện thoại iPhone 11 128GB | Ảnh chụp chế độ chân dung\" /></a></p>\r\n\r\n<p>Ảnh camera chế độ ch&acirc;n dung</p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute; l&agrave; t&iacute;nh năng&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/deep-fusion-tren-dong-iphone-11-pro-la-gi-tinh-nan-1197418\" target=\"_blank\" title=\"Tìm hiểu tính năng Deel Fusion\" type=\"Tìm hiểu tính năng Deel Fusion\">Deep Fusion</a>&nbsp;được quảng c&aacute;o l&agrave; cơ chế chụp h&igrave;nh mới, đem lại h&igrave;nh ảnh với độ chi tiết cao, dải tần nhạy s&aacute;ng rộng v&agrave; rất &iacute;t bị nhiễu.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd16-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Ảnh chụp đủ sáng\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd16-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Ảnh chụp đủ sáng\" /></a></p>\r\n\r\n<p>Một bức ảnh chụp đủ s&aacute;ng tr&ecirc;n iPhone 11</p>\r\n\r\n<p>Cụ thể, khi người d&ugrave;ng bấm n&uacute;t chụp, thiết bị sẽ thực hiện tổng cộng 9 bức h&igrave;nh c&ugrave;ng l&uacute;c, gồm một tấm ch&iacute;nh v&agrave; t&aacute;m tấm phụ, sau đ&oacute; chọn ra c&aacute;c điểm ảnh tốt nhất để đưa v&agrave;o tấm ảnh cuối c&ugrave;ng nhằm cải thiện chi tiết v&agrave; khử nhiễu.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd18-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Ảnh chụp chế độ bình thường\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd18-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Ảnh chụp chế độ bình thường\" /></a></p>\r\n\r\n<p>Quả b&oacute;ng qua ống k&iacute;nh chế độ b&igrave;nh thường của iPhone 11</p>\r\n\r\n<p>V&agrave; điều được người d&ugrave;ng mong chờ nhất ch&iacute;nh l&agrave; t&iacute;nh năng chụp đ&ecirc;m cũng xuất hiện tr&ecirc;n chiếc iPhone mới n&agrave;y với t&ecirc;n gọi Night Mode.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd15-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Ảnh chụp chế độ Night Mode\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd15-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Ảnh chụp chế độ Night Mode\" /></a></p>\r\n\r\n<p>Ảnh chụp với chế độ Night Mode</p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia-chi-tiet-apple-iphone-11-iphone-2019-1191805\" target=\"_blank\" title=\"Đánh giá chi tiết iPhone 11\" type=\"Đánh giá chi tiết iPhone 11\">Đ&aacute;nh gi&aacute; chi tiết iPhone 11: H&oacute;a &#39;b&atilde;o tố&#39; hay th&agrave;nh &#39;bom xịt&#39;?</a></p>\r\n\r\n<p>Night Mode sẽ tự động k&iacute;ch hoạt khi bạn chụp ảnh trong điều kiện thiếu s&aacute;ng v&agrave; chất lượng ảnh cho ra l&agrave; rất ấn tượng khi so s&aacute;nh với những chiếc iPhone đời cũ.</p>\r\n\r\n<h3>Camera trước cũng đ&atilde; tốt hơn nhiều</h3>\r\n\r\n<p>Đầu ti&ecirc;n phải kể đến l&agrave; độ ph&acirc;n giải camera trước đ&atilde; được n&acirc;ng từ 7 MP l&ecirc;n th&agrave;nh 12 MP cho người d&ugrave;ng những bức ảnh chi tiết hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd12-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Cụm camera phía trước ở tai thỏ\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd12-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Cụm camera phía trước ở tai thỏ\" /></a></p>\r\n\r\n<p>iPhone 11 cũng l&agrave; chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone iPhone chính hãng\">iPhone</a>&nbsp;đầu ti&ecirc;n hỗ trợ quay video si&ecirc;u chậm ở camera trước với t&ecirc;n gọi l&agrave;&nbsp;Slofies, bạn c&oacute; thể c&oacute; được cho m&igrave;nh những thước phim kh&aacute; th&uacute; vị với t&iacute;nh năng n&agrave;y.</p>\r\n\r\n<p>Apple cũng rất &quot;t&acirc;m l&yacute;&quot; khi trang bị th&ecirc;m t&iacute;nh năng tự động thay đổi g&oacute;c chụp rộng hơn khi bạn xoay ngang chiếc iPhone của m&igrave;nh để c&oacute; thể thoải m&aacute;i selfie với bạn b&egrave;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd13-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Ảnh selfie bằng camera trước\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd13-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Ảnh selfie bằng camera trước\" /></a></p>\r\n\r\n<p>Ảnh chụp selfie tr&ecirc;n iPhone 11</p>\r\n\r\n<p>V&agrave; Face ID tr&ecirc;n iPhone 11 cũng được cải tiến để c&oacute; thể nhận diện ở g&oacute;c rộng hơn v&agrave; c&oacute; tốc độ nhanh hơn so với iPhone Xr cũ.</p>\r\n\r\n<h3>Hiệu năng mạnh mẽ h&agrave;ng đầu thế giới</h3>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd4-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Điểm hiệu năng Antutu Benchmark\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd4-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Điểm hiệu năng Antutu Benchmark\" /></a></p>\r\n\r\n<p>Hiệu năng lu&ocirc;n l&agrave; vấn đề m&agrave; người d&ugrave;ng iPhone chưa bao giờ phải ph&agrave;n n&agrave;n v&agrave; với&nbsp;iPhone 11 128 GB năm nay cũng kh&ocirc;ng phải l&agrave; ngoại lệ.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Trải nghiệm chơi game trên iPhone 11\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd4.jpg\" title=\"Điện thoại iPhone 11 128GB | Trải nghiệm chơi game trên iPhone 11\" /></a></p>\r\n\r\n<p>M&aacute;y sở hữu con chip mạnh mẽ nhất của Apple cho những chiếc iPhone năm 2019&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/tim-hieu-ve-chip-apple-a13-bionic-tren-iphone-11-n-1197492\" target=\"_blank\" title=\"Tìm hiểu về chip Apple A13 Bionic\" type=\"Tìm hiểu về chip Apple A13 Bionic\">Apple A13 Bionic</a>&nbsp;c&ugrave;ng 4 GB RAM v&agrave; 128 GB bộ nhớ trong gi&uacute;p&nbsp;<a href=\"https://www.thegioididong.com/dtdd-choi-game\" target=\"_blank\" title=\"Tham khảo các mẫu điện thoại chơi game tại Thế Giới Di Động\">điện thoại chơi game</a>&nbsp;tốt mượt m&agrave; với mức cấu h&igrave;nh max setting cũng như mọi thao t&aacute;c cơ bản đều cho tốc độ phản hồi nhanh ch&oacute;ng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd6-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Hiệu năng mạng mẽ\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd6-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Hiệu năng mạng mẽ\" /></a></p>\r\n\r\n<p>Con chip mới n&agrave;y cũng l&agrave; CPU&nbsp;di động tiết kiệm năng lượng nhất từ ​​trước đến nay nhờ x&acirc;y dựng tr&ecirc;n kiến tr&uacute;c 7 nm v&agrave; cung cấp đến 8.5 ngh&igrave;n tỷ b&oacute;ng b&aacute;n dẫn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd5-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Cụm camera phía trước ở tai thỏ\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd5-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Cụm camera phía trước ở tai thỏ\" /></a></p>\r\n\r\n<p>Với những trang bị như vậy th&igrave; bạn c&oacute; thể chơi mọi tựa game, sử dụng mọi ứng dụng nặng nhất hiện nay m&agrave; vẫn đảm bảo m&aacute;y hoạt động trơn tru v&agrave; mượt m&agrave;.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd44.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Trải nghiệm chơi game trên iPhone 11\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd44.jpg\" title=\"Điện thoại iPhone 11 128GB | Trải nghiệm chơi game trên iPhone 11\" /></a></p>\r\n\r\n<p>C&ugrave;ng với iPhone 11 th&igrave; Apple cũng ch&iacute;nh thức mang iOS 13 tới với người d&ugrave;ng với nhiều cải tiến đ&aacute;ng gi&aacute; như&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/loi-ich-cua-che-do-dark-mode-cua-ios-13-1181013\" target=\"_blank\" title=\"Tìm hiểu chế độ Dark Mode\" type=\"Tìm hiểu chế độ Dark Mode\">chế độ Dark Mode</a>&nbsp;hay khả năng tối ưu h&oacute;a khi sạc pin.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd10-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Thời lượng pin dài\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd10-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Thời lượng pin dài\" /></a></p>\r\n\r\n<p>Ngo&agrave;i ra chiếc iPhone n&agrave;y c&ograve;n hỗ trợ&nbsp;Wi-Fi 6 với tốc độ nhanh hơn v&agrave; kết nối ổn định hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd11-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Khay sim\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd11-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Khay sim\" /></a></p>\r\n\r\n<p>Xem th&ecirc;m:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/thu-nghiem-do-ben-iphone-11-cao-xuoc-nung-nong-va-be-cong-1203631\" target=\"_blank\" title=\"Thử nghiệm độ bền iPhone 11\" type=\"Thử nghiệm độ bền iPhone 11\">Thử nghiệm độ bền iPhone 11: C&agrave;o xước, nung n&oacute;ng v&agrave; bẻ cong</a></p>\r\n\r\n<h3>Pin đ&atilde; tốt nay c&ograve;n tốt hơn</h3>\r\n\r\n<p>Như c&aacute;c bạn đ&atilde; biết th&igrave; iPhone Xr năm ngo&aacute;i l&agrave; chiếc iPhone c&oacute; thời lượng pin tốt nhất từ trước tới nay của Apple.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd45.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Giao diện hiển thị pin trên máy\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd45.jpg\" title=\"Điện thoại iPhone 11 128GB | Giao diện hiển thị pin trên máy\" /></a></p>\r\n\r\n<p>V&agrave; iPhone 11 năm nay thậm ch&iacute; Apple c&ograve;n l&agrave;m tốt hơn thế với th&ecirc;m 1 giờ sử dụng pin.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd39.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Thời lượng sử dụng pin\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd39.jpg\" title=\"Điện thoại iPhone 11 128GB | Thời lượng sử dụng pin\" /></a></p>\r\n\r\n<p>Apple cũng n&oacute;i rằng họ đ&atilde; cải tiến b&ecirc;n trong để chiếc iPhone 11 mới c&oacute; thể&nbsp;<a href=\"https://www.thegioididong.com/dtdd-chong-nuoc-bui\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone chống nước chống bụi\">chống nước</a>&nbsp;tốt hơn thế hệ cũ.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd9-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Thiết kế thời trang\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd9-1.jpg\" title=\"Điện thoại iPhone 11 128GB | Thiết kế thời trang\" /></a></p>\r\n\r\n<p>V&agrave; cũng kh&ocirc;ng thể kh&ocirc;ng nhắc tới thiết kế&nbsp;k&iacute;nh mới ở cả mặt trước v&agrave; mặt sau của iPhone 11 v&agrave; được Apple giới thiệu l&agrave; loại k&iacute;nh bền nhất từng được sử dụng tr&ecirc;n smartphone.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/210644/iphone-11-128gb-tgdd41.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại iPhone 11 128GB | Nhiều màu sắc đa dạng\" src=\"https://cdn.tgdd.vn/Products/Images/42/210644/iphone-11-128gb-tgdd41.jpg\" title=\"Điện thoại iPhone 11 128GB | Nhiều màu sắc đa dạng\" /></a></p>\r\n\r\n<p>M&agrave;u sắc mới tr&ecirc;n chiếc iPhone n&agrave;y hứa hẹn cũng sẽ khiến người d&ugrave;ng phải m&ecirc; mệt v&agrave; muốn bỏ tiền ra sở hữu ngay v&agrave; lu&ocirc;n một chiếc.</p>\r\n', '691934c7d13a911b164c3dc0f77ea3383897a0c6.jpg', 15, 0, NULL, 21990000, 'IPS LCD, 6.1\", Liquid Retina', 'iOS 13', ' 2 camera 12 MP', '12 MP', 'Apple A13 Bionic 6 nhân', ' 1 Nano SIM & 1 eSIM, Hỗ trợ 4G', '3110 mAh, có sạc nhanh', '2020-11-02 05:50:27', 0),
(19, 0, 'Điện thoại OPPO Reno3 Pro', 'Description\r\n', '<h2><a href=\"https://www.thegioididong.com/dtdd/oppo-reno3-pro\" target=\"_blank\" title=\"Tham khảo giá bán điện thoại OPPO Reno3 Pro chính hãng\">OPPO Reno3 Pro</a>&nbsp;tiếp nối truyền thống d&ograve;ng Reno, vẫn sở hữu cụm camera sau chất lượng cao v&agrave; bổ sung t&iacute;nh năng quay video Si&ecirc;u chống rung 2.0 ấn tượng.&nbsp;<a href=\"https://www.thegioididong.com/dtdd-oppo\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone OPPO chính hãng\">OPPO</a>&nbsp;cũng trang bị cho m&aacute;y cụm camera selfie k&eacute;p t&iacute;ch hợp AI, thiết kế cao cấp theo kịp xu hướng.</h2>\r\n\r\n<h3>M&agrave;n h&igrave;nh Sunlight Super AMOLED cao cấp</h3>\r\n\r\n<p>Nếu so s&aacute;nh với flagship&nbsp;<a href=\"https://www.thegioididong.com/dtdd/oppo-find-x2\" target=\"_blank\" title=\"Tham khảo giá điện thoại OPPO Find X2 chính hãng\" type=\"Tham khảo giá điện thoại OPPO Find X2 chính hãng\">OPPO Find X2</a>, OPPO Reno3 Pro cũng sở hữu thiết kế cao cấp v&agrave; kh&ocirc;ng k&eacute;m phần sang trọng.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024720-024744.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Thiết kế cao cấp\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024720-024744.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Thiết kế cao cấp\" /></a></p>\r\n\r\n<p>Thiết bị vẫn sở hữu tổng thể liền lạc v&agrave; b&oacute;ng bẩy, phần m&agrave;n h&igrave;nh được l&agrave;m cong mềm mại, mang t&iacute;nh thẩm mỹ cao m&agrave; c&ograve;n gi&uacute;p cho người d&ugrave;ng c&oacute; cảm gi&aacute;c cầm nắm, vuốt chạm mượt tay, liền lạc hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024720-024753.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Thiết kế bỏng bẩy cao cấp\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024720-024753.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Thiết kế bỏng bẩy cao cấp\" /></a></p>\r\n\r\n<p>Thế hệ Reno3 Pro đ&atilde; kh&ocirc;ng c&ograve;n kiểu thiết kế camera v&acirc;y c&aacute; mập hay th&ograve; thụt như tr&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd/oppo-reno2\" target=\"_blank\" title=\"Tham khảo giá điện thoại OPPO Reno2 chính hãng\" type=\"Tham khảo giá điện thoại OPPO Reno2 chính hãng\">OPPO Reno2</a>,&nbsp;<a href=\"https://www.thegioididong.com/dtdd/oppo-reno\" target=\"_blank\" title=\"Xem thông tin điện thoại OPPO Reno\" type=\"Xem thông tin điện thoại OPPO Reno\">Reno</a>&nbsp;m&agrave; thay v&agrave;o đ&oacute; l&agrave; kiểu thiết kế m&agrave;n h&igrave;nh &quot;nốt ruồi&quot; với cụm camera k&eacute;p đặt ở g&oacute;c tr&aacute;i m&agrave;n h&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro8-1.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Màn hình tràn viền\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro8-1.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Màn hình tràn viền\" /></a></p>\r\n\r\n<p>Ưu điểm của kiểu thiết kế n&agrave;y ch&iacute;nh l&agrave; camera trước của m&aacute;y sẽ hoạt động ổn định v&agrave; bền hơn so với cơ chế cũ. Kh&ocirc;ng gian hiển thị hầu như kh&ocirc;ng bị ảnh hưởng, vẫn rất thoải m&aacute;i khi chơi game hay l&agrave;m việc tr&ecirc;n chiếc smartphone n&agrave;y.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024820-024810.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Thiết kế cạnh viền\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024820-024810.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Thiết kế cạnh viền\" /></a></p>\r\n\r\n<p>M&aacute;y sử dụng tấm nền Sunlight Super&nbsp;<a href=\"https://www.thegioididong.com/hoi-dap/man-hinh-amoled-la-gi-905766\" target=\"_blank\" title=\"Tìm hiểu màn hình AMOLED\">AMOLED</a>&nbsp;Full HD+&nbsp;cho m&agrave;u sắc v&agrave; độ tương phản tốt, bảo vệ sức khỏe mắt với t&iacute;nh năng lọc &aacute;nh s&aacute;ng xanh v&agrave; thay đổi độ s&aacute;ng theo m&ocirc;i trường nhanh v&agrave; ch&iacute;nh x&aacute;c hơn.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024820-024849.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Trải nghiệm mượt mà\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024820-024849.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Trải nghiệm mượt mà\" /></a></p>\r\n\r\n<h3>Camera chất lượng h&agrave;ng đầu</h3>\r\n\r\n<p>OPPO Reno3 Pro sở hữu cụm 4 camera với đầy đủ t&iacute;nh năng v&agrave; c&ocirc;ng dụng m&agrave; người d&ugrave;ng mong muốn ở một chiếc smartphone hiện nay.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024820-024801.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Cụm camera cao cấp\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024820-024801.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Cụm camera cao cấp\" /></a></p>\r\n\r\n<p>Bạn sẽ c&oacute; một camera ch&iacute;nh với độ ph&acirc;n giải lớn 64 MP, một camera tele 13 MP chụp những vật thể ở xa, một camera&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-goc-rong\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone camera chụp hình góc rộng\" type=\"Tham khảo giá điện thoại smartphone camera chụp hình góc rộng\">g&oacute;c si&ecirc;u rộng</a>&nbsp;8 MP v&agrave; một&nbsp;ống k&iacute;nh macro 2 MP cho chụp cận cảnh đối tượng ở khoảng c&aacute;ch 2.5 cm.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro5.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Ảnh chụp chế độ ban đêm\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro5.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Ảnh chụp chế độ ban đêm\" /></a></p>\r\n\r\n<p>Camera tr&ecirc;n Reno3 Pro cho ra h&igrave;nh ảnh xuất sắc trong điều kiện đủ s&aacute;ng. Camera tele cũng cho ra kết quả xuất sắc khi c&oacute; khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-camera-zoom\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone camera zoom\" type=\"Tham khảo giá điện thoại smartphone camera zoom\">zoom quang</a>&nbsp;5X, zoom số đến 20X cực xa.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro9.jpg\" />Ảnh chụp g&oacute;c si&ecirc;u rộng tr&ecirc;n Reno3 Pro</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro10.jpg\" />Ảnh chụp chế độ zoom 5X tr&ecirc;n Reno3 Pro</p>\r\n\r\n<p><img src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro1.jpg\" />Ảnh chụp chế độ zoom&nbsp;10X tr&ecirc;n Reno3 Pro</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>Thiết bị cũng c&oacute; chế độ n&acirc;ng độ ph&acirc;n giải ảnh l&ecirc;n đến 108 MP cho ra bức ảnh si&ecirc;u n&eacute;t, tối ưu cho việc in ấn hay zoom cận c&aacute;c chi tiết nhỏ.</p>\r\n\r\n<p>M&aacute;y sở hữu nhiều chế độ chụp ảnh chuy&ecirc;n nghiệp c&ugrave;ng với sự trợ gi&uacute;p của AI gi&uacute;p bạn c&oacute; thể l&agrave;m chủ được camera tr&ecirc;n chiếc smartphone của m&igrave;nh.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro8.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Ảnh chụp chế độ macro\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro8.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Ảnh chụp chế độ macro\" /></a></p>\r\n\r\n<p>C&ocirc;ng nghệ video Si&ecirc;u chống rung 2.0 với 2 chế độ Si&ecirc;u chống rung v&agrave; Si&ecirc;u chống rung Pro, cho ra c&aacute;c đoạn video ổn định đến bất ngờ m&agrave; kh&ocirc;ng cần đến thiết bị hỗ trợ n&agrave;o kh&aacute;c.</p>\r\n\r\n<p>Camera selfie k&eacute;p chắc chắn cũng sẽ kh&ocirc;ng l&agrave;m c&aacute;c bạn trẻ phải thất vọng bởi m&aacute;y sở hữu bộ đ&ocirc;i ống k&iacute;nh c&oacute; độ ph&acirc;n giải l&ecirc;n tới 44 MP v&agrave; 2 MP.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro4.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Ảnh selfie\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro4.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Ảnh selfie\" /></a></p>\r\n\r\n<p>Với chế độ Si&ecirc;u chụp đ&ecirc;m 2.0 cho ph&eacute;o chụp ảnh selfie trong tối r&otilde; n&eacute;t hơn. Reno3 Pro dễ d&agrave;ng xử l&yacute; c&aacute;c bức ảnh ảo diệu dưới &aacute;nh đ&egrave;n neon hay trong c&aacute;c qu&aacute;n cafe lung linh.</p>\r\n\r\n<p>T&iacute;nh năng l&agrave;m đẹp bằng AI gi&uacute;p loại bỏ những khuyết điểm tr&ecirc;n khu&ocirc;n mặt của bạn một c&aacute;ch tự nhi&ecirc;n để c&oacute; thể đăng ngay l&ecirc;n facebook sau khi chụp m&agrave; kh&ocirc;ng cần phải hậu kỳ.</p>\r\n\r\n<h3>Pin d&ugrave;ng cả ng&agrave;y, sạc si&ecirc;u nhanh VOOC 4.0</h3>\r\n\r\n<p>Chiếc smartphone OPPO n&agrave;y đi k&egrave;m với vi&ecirc;n&nbsp;<a href=\"https://www.thegioididong.com/dtdd?f=pin-khung-3000-mah\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone pin khủng pin trâu\">pin khủng</a>&nbsp;4.025 mAh hứa hẹn cho bạn thời gian trải nghiệm cả ng&agrave;y.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024820-024827.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Thời lượng pin tốt hỗ trợ sạc nhanh 30W\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024820-024827.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Thời lượng pin tốt hỗ trợ sạc nhanh 30W\" /></a></p>\r\n\r\n<p>B&ecirc;n cạnh đ&oacute; l&agrave; khả năng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-sac-pin-nhanh\" target=\"_blank\" title=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\" type=\"Tham khảo giá điện thoại smartphone sạc pin nhanh\">sạc nhanh</a>&nbsp;VOOC 4.0 30W gi&uacute;p m&aacute;y c&oacute; thể sạc&nbsp;từ 0 đến 50% trong 20 ph&uacute;t v&agrave; 0 đến 70% trong nửa giờ.</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/images/42/216172/oppo-reno3-pro-024820-024840.jpg\" onclick=\"return false;\"><img alt=\"Điện thoại OPPO Reno 3 Pro | Hiệu năng vượt trội\" src=\"https://cdn.tgdd.vn/Products/Images/42/216172/oppo-reno3-pro-024820-024840.jpg\" title=\"Điện thoại OPPO Reno 3 Pro | Hiệu năng vượt trội\" /></a></p>\r\n\r\n<p>OPPO Reno3 Pro sở hữu dung lượng RAM 8 GB, bộ nhớ khủng 256 GB, c&ugrave;ng với hệ thống tệp F2FS cho tốc độ nhanh, trải nghiệm mượt m&agrave;. CPU Helio P95 mạnh mẽ cho bạn chiến game thỏa th&iacute;ch.</p>\r\n', '4e212fe1e5a661df11ade625f388d8594d2df6b7.jpg', 10, 0, NULL, 8490000, 'Sunlight Super AMOLED, 6.4\", Full HD+', 'Android 10', ' Chính 64 MP & Phụ 13 MP, 8 MP, 2 MP', 'Chính 44 MP & Phụ 2 MP', 'MediaTek Helio P95 8 nhân', '2 Nano SIM, Hỗ trợ 4G', '4025 mAh, có sạc nhanh', '2020-11-28 03:56:24', 0);

-- --------------------------------------------------------

--
-- Table structure for table `phone_category`
--

CREATE TABLE `phone_category` (
  `phone_id` int(10) UNSIGNED NOT NULL,
  `category_id` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `phone_category`
--

INSERT INTO `phone_category` (`phone_id`, `category_id`) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 1),
(5, 2),
(6, 2),
(7, 3),
(8, 1),
(9, 5),
(10, 1),
(11, 1),
(13, 1),
(14, 1),
(15, 2),
(16, 3),
(17, 4),
(18, 1),
(19, 3);

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` enum('draft','live') DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `thumb` varchar(45) NOT NULL,
  `description` mediumtext NOT NULL,
  `content` longtext DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `num_view` int(11) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `status`, `title`, `thumb`, `description`, `content`, `is_featured`, `user_id`, `product_id`, `num_view`, `date_created`) VALUES
(1, 'live', 'Đánh giá chi tiết iPhone 11 Pro Max cập nhật iOS 14: Vốn đã hấp dẫn nhưng nay lại càng hấp dẫn bội phần', 'dc0b08d5c520a9531cfb393b6c09262857255ecb.jpg', 'Description', '<h3>1. Hiệu năng iPhone 11 Pro Max vượt bậc với iOS 14</h3>\r\n\r\n<p>N&oacute;i thật nếu bạn n&agrave;o muốn n&acirc;ng cấp hiệu năng của chiếc iPhone th&igrave; n&ecirc;n update l&ecirc;n iOS 14. Cũng như chiếc iPhone 11 Pro Max m&agrave; m&igrave;nh đang đ&aacute;nh gi&aacute; đ&acirc;y, m&igrave;nh đ&atilde; sẵn s&agrave;ng update l&ecirc;n iOS 14 v&agrave; nhận được kết quả xứng đ&aacute;ng. Trước hết cho ph&eacute;p m&igrave;nh điểm qua th&ocirc;ng số phần cứng trước nh&eacute;:</p>\r\n\r\n<ul>\r\n	<li>M&agrave;n h&igrave;nh 6.5 inch, độ ph&acirc;n giải&nbsp;1.242 x 2.688 pixels, tấm nền OLED.</li>\r\n	<li>CPU: Apple A13 Boinic.</li>\r\n	<li>RAM: 4 GB.</li>\r\n	<li>Bộ nhớ trong: 64 GB.</li>\r\n</ul>\r\n\r\n<p><img alt=\"iOS 14 mang đến sự cải thiện rõ rệt về hiệu năng bên trong\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08813_1280x720.jpg\" title=\"iOS 14 mang đến sự cải thiện rõ rệt về hiệu năng bên trong\" /></p>\r\n\r\n<p>iOS 14 mang đến sự cải thiện r&otilde; rệt về hiệu năng b&ecirc;n trong.</p>\r\n\r\n<p>Trước hết, m&igrave;nh đ&atilde; đo số điểm hiệu năng qua phần mềm AnTuTu trước v&agrave; sau khi update l&ecirc;n iOS 14 đế c&aacute;c bạn thấy được sự thay đổi về điểm số hiệu năng r&otilde; r&agrave;ng như thế n&agrave;o:</p>\r\n\r\n<p><img alt=\"Đo hiệu năng trước và sau khi cập nhật lên iOS 14\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/b11_800x735.jpg\" title=\"Đo hiệu năng trước và sau khi cập nhật lên iOS 14\" /></p>\r\n\r\n<p>Test hiệu năng trước (tr&aacute;i) v&agrave; sau (phải) khi l&ecirc;n iOS 14.</p>\r\n\r\n<p>Với điểm số tr&ecirc;n hẳn ch&uacute;ng ta đ&atilde; phần n&agrave;o nhận thấy được việc n&acirc;ng&nbsp; cấp l&ecirc;n iOS 14 l&agrave; một lợi thế gi&uacute;p cải thiện hiệu năng của chiếc m&aacute;y. Lưu &yacute;, để đo được số điểm hiệu năng một c&aacute;ch ch&iacute;nh x&aacute;c nhất th&igrave; mức pin l&uacute;c đo phải tr&ecirc;n 80% nh&eacute;. Bởi lẽ pin yếu cũng ảnh hưởng nhiều đến qu&aacute; tr&igrave;nh đo v&agrave; cho ra điểm số kh&ocirc;ng ch&iacute;nh x&aacute;c với những g&igrave; m&agrave; chiếc iPhone 11 Pro Max n&agrave;y mang lại.</p>\r\n\r\n<p><img alt=\"Pin cũng ảnh hưởng tới hiệu năng của chiếc máy\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/a2_800x736.jpg\" title=\"Pin cũng ảnh hưởng tới hiệu năng của chiếc máy\" /></p>\r\n\r\n<p>Pin cũng ảnh hưởng tới hiệu năng của chiếc m&aacute;y, b&ecirc;n tr&aacute;i l&agrave; đo hiệu năng l&uacute;c pin tr&ecirc;n 80% v&agrave; b&ecirc;n phải l&agrave; đo hiệu năng l&uacute;c pin dưới 20%.</p>\r\n\r\n<p>N&oacute;i về trải nghiệm thực tế, m&igrave;nh đ&atilde; đ&aacute;nh gi&aacute; 3 trong số những tựa game phổ biến nhất tr&ecirc;n Mobile gồm: Li&ecirc;n Qu&acirc;n Mobile, PUBG Mobile v&agrave; Call Of Duty. Ở tựa game Li&ecirc;n Qu&acirc;n Mobile m&igrave;nh đ&atilde; mở FPS cao (tối đa l&agrave; 60) v&agrave; trải nghiệm được sự mượt m&agrave; nhất l&agrave; ở những pha combat. V&agrave; rất đơn giản, m&igrave;nh đ&atilde; Quadkill chỉ trong 30 gi&acirc;y.</p>\r\n\r\n<p><img alt=\"Test Liên Quân Mobile trên iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/ggg1_600x278.gif\" title=\"Test Liên Quân Mobile trên iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Test Li&ecirc;n Qu&acirc;n Mobile tr&ecirc;n iPhone 11 Pro Max.</p>\r\n\r\n<p>Tựa game thứ hai l&agrave; PUBG Mobile, m&igrave;nh đ&atilde; bật cấu h&igrave;nh l&ecirc;n mức Ultra v&agrave; tốc độ khung h&igrave;nh l&agrave; Cực cao. Nếu bạn chọn đồ họa HDR th&igrave; tốc độ khung h&igrave;nh c&oacute; thể đẩy l&ecirc;n Cực độ đấy. Bản th&acirc;n m&igrave;nh rất h&agrave;i l&ograve;ng với những g&igrave; m&agrave; Apple A13 mang lại, nhất l&agrave; khả năng xử l&yacute; ổn định ở những pha solo 1 vs 1.</p>\r\n\r\n<p><img alt=\"Test PUBG Mobile trên iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/ggg2_600x278.gif\" title=\"Test PUBG Mobile trên iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Test PUBG Mobile tr&ecirc;n iPhone 11 Pro Max.</p>\r\n\r\n<p>V&agrave; cuối c&ugrave;ng m&igrave;nh trải nghiệm th&ecirc;m một tựa game FPS nữa đ&oacute; l&agrave; Call Of Duty Mobile. Với tựa game n&agrave;y th&igrave; mức cấu h&igrave;nh m&igrave;nh setup l&agrave; chất lượng h&igrave;nh ảnh Rất cao v&agrave; tốc độ khung h&igrave;nh l&agrave; Tối đa. Trải nghiệm th&igrave; &ocirc;i th&ocirc;i khỏi n&oacute;i mấy bạn ạ, nhờ CPU mạnh c&ugrave;ng m&agrave;n h&igrave;nh rộng lớn gi&uacute;p m&igrave;nh kiểm so&aacute;t được to&agrave;n trận v&agrave; dễ d&agrave;ng hạ gục hơn 20 mạng, d&agrave;nh nốt cả MVP.</p>\r\n\r\n<p><img alt=\"Test Call Of Duty Mobile trên iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/ggg3_600x278.gif\" title=\"Test Call Of Duty Mobile trên iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Test Call Of Duty Mobile tr&ecirc;n iPhone 11 Pro Max.</p>\r\n\r\n<p>M&agrave; n&egrave;, l&uacute;c m&igrave;nh mới update l&ecirc;n iOS 14 th&igrave; thật m&aacute;y kh&aacute; n&oacute;ng v&agrave; khiến m&igrave;nh bắt đầu ho&agrave;i nghi về phi&ecirc;n bản cập nhật mới n&agrave;y đến từ nh&agrave; T&aacute;o. Tuy nhi&ecirc;n khi v&agrave;o trận th&igrave; nhiệt độ th&acirc;n m&aacute;y bắt đầu &ocirc;n h&ograve;a hơn v&agrave; bớt n&oacute;ng hơn. Trải nghiệm hơn 20 ph&uacute;t chơi Li&ecirc;n Qu&acirc;n Mobile th&igrave; m&aacute;y chỉ hơi ấm l&ecirc;n một t&iacute; v&agrave; sau đ&oacute; m&igrave;nh chơi th&ecirc;m v&agrave;i trận, m&aacute;y cũng kh&ocirc;ng ph&aacute;t n&oacute;ng như l&uacute;c ban đầu.</p>\r\n\r\n<h3>2. Thời lượng pin c&oacute; sụt giảm hay kh&ocirc;ng?</h3>\r\n\r\n<p>Phần tiếp theo m&igrave;nh sẽ đ&aacute;nh gi&aacute; trong b&agrave;i viết n&agrave;y ch&iacute;nh l&agrave; thời lượng pin của iPhone 11 Pro Max. N&oacute;i sao nhỉ, khi l&ecirc;n iOS 14 m&igrave;nh nhận được kh&aacute; nhiều phản hồi rằng m&aacute;y giảm thời lượng xuống qu&aacute; nhanh v&agrave; khiến người d&ugrave;ng kh&oacute; chịu. Nhưng thật chất m&igrave;nh thấy pin kh&ocirc;ng thay đổi nhiều cho lắm. Vậy với trải nghiệm c&aacute;c t&aacute;c vụ thực tế, vi&ecirc;n pin dung lượng&nbsp;3.969 mAh cho thời lượng bao l&acirc;u? Điều kiện m&igrave;nh đ&aacute;nh gi&aacute; như sau:</p>\r\n\r\n<ul>\r\n	<li>Trải nghiệm 4 t&aacute;c vụ xoay v&ograve;ng gồm: Chơi Li&ecirc;n Qu&acirc;n, xem YouTube, lướt Facebook v&agrave; x&agrave;i Chrome.</li>\r\n	<li>Mỗi t&aacute;c vụ sử dụng 1 tiếng đồng hồ.</li>\r\n	<li>Độ s&aacute;ng m&agrave;n h&igrave;nh: 100%.</li>\r\n	<li>Cắm tai nghe c&oacute; d&acirc;y xuy&ecirc;n suốt.</li>\r\n	<li>Bật WiFi v&agrave; c&aacute;c th&ocirc;ng b&aacute;o từ mạng x&atilde; hội.</li>\r\n	<li>Kh&ocirc;ng bật tiết kiệm pin, m&agrave;n h&igrave;nh th&iacute;ch ứng, GPS v&agrave; Bluetooth.</li>\r\n	<li>Chấm từ 100% đến 0%.</li>\r\n</ul>\r\n\r\n<p><img alt=\"Đo thời lượng pin của iPhone 11 Pro Max qua trải nghiệm thực tế\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/a1_800x573.jpg\" title=\"Đo thời lượng pin của iPhone 11 Pro Max qua trải nghiệm thực tế\" /></p>\r\n\r\n<p>Đo thời lượng pin iPhone 11 Pro Max qua trải nghiệm thực tế.</p>\r\n\r\n<p>Như vậy với cường độ l&agrave;m việc cao như tr&ecirc;n, iPhone 11 Pro Max chạy iOS 14 đ&atilde; cho thời lượng sử dụng li&ecirc;n tục l&agrave; 8 tiếng 37 ph&uacute;t. Bản th&acirc;n m&igrave;nh đ&aacute;nh gi&aacute; đ&acirc;y l&agrave; mức thời lượng tốt với một d&ograve;ng sản phẩm thường được đ&aacute;nh gi&aacute; c&oacute; pin yếu như iPhone đ&acirc;y. Kh&ocirc;ng chỉ vậy, việc n&acirc;ng l&ecirc;n iOS 14 kh&ocirc;ng ảnh hưởng qu&aacute; nhiều đến thời lượng của pin (m&aacute;y m&igrave;nh kh&ocirc;ng gắn sim nh&eacute;).</p>\r\n\r\n<p>Ngo&agrave;i ra m&igrave;nh c&ograve;n đo tốc độ sạc của củ sạc trong hộp đựng v&agrave; thu được kết quả như sau:</p>\r\n\r\n<p><img alt=\"Đo tốc độ sạc của củ sạc trong hộp đựng\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/a3_600x467.jpg\" title=\"Đo tốc độ sạc của củ sạc trong hộp đựng\" /></p>\r\n\r\n<p>Đo tốc độ sạc của củ sạc trong hộp đựng.</p>\r\n\r\n<h3>3. iOS 14 mang đến giao diện iPhone 11 Pro Max đẹp hơn, th&ocirc;ng minh hơn</h3>\r\n\r\n<p>C&oacute; n&ecirc;n n&acirc;ng cấp iOS 14 hay kh&ocirc;ng nhỉ? N&ecirc;n chứ sao kh&ocirc;ng v&igrave; iOS 14 đ&atilde; mang đến giao diện mới khiến m&igrave;nh v&ocirc; c&ugrave;ng th&iacute;ch th&uacute;. Giao diện iOS 14 giờ đ&acirc;y tr&ocirc;ng kh&aacute; mềm mại, dễ chịu, kh&ocirc;ng bị g&ograve; b&oacute; trong khu&ocirc;n khổ v&agrave; c&oacute; sự đa dạng trong c&aacute;ch sắp xếp c&aacute;c ứng dụng trong điện thoại. Đồng thời giao diện mới khiến m&igrave;nh kh&ocirc;ng c&ograve;n cảm thấy nh&agrave;m ch&aacute;n như trước kia nữa, tạo cảm hứng sử dụng điện thoại.</p>\r\n\r\n<p><img alt=\"Giao diện mới của iOS 14 trên iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/21/1292069/b1_1280x894.jpg\" title=\"Giao diện mới của iOS 14 trên iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Giao diện mới của iOS 14 tr&ecirc;n iPhone 11 Pro Max.</p>\r\n\r\n<p><img alt=\"Giao diện cũ tức giao diện của iOS 13\" src=\"https://cdn.tgdd.vn/Files/2020/09/21/1292069/c15_1280x736.jpg\" title=\"Giao diện cũ tức giao diện của iOS 13\" /></p>\r\n\r\n<p>Giao diện cũ tức giao diện của iOS 13.</p>\r\n\r\n<p>iOS 14 c&ograve;n tự sắp xếp c&aacute;c ứng dụng lại với nhau v&agrave; dể v&agrave;o trang cuối của m&agrave;n h&igrave;nh ch&iacute;nh của iPhone 11 Pro Max. Thường th&igrave; m&agrave;n h&igrave;nh h&igrave;nh ch&iacute;nh l&agrave; một trang s&aacute;ch mở v&agrave; kh&ocirc;ng c&oacute; trang kết th&uacute;c (hoặc được thiết kế xoay v&ograve;ng). Ri&ecirc;ng ở iOS 14, Apple đ&atilde; gộp ứng dụng lại một c&aacute;ch v&ocirc; c&ugrave;ng th&ocirc;ng minh, game ra game, mạng x&atilde; hội th&igrave; ra mạng x&atilde; hội đ&agrave;ng ho&agrave;ng ở trang cuối c&ugrave;ng.</p>\r\n\r\n<p><img alt=\"Tùy chỉnh va tìm kiếm ứng dụng nhanh chóng\" src=\"https://cdn.tgdd.vn/Files/2020/09/21/1292069/b3_1280x891.jpg\" title=\"Tùy chỉnh va tìm kiếm ứng dụng nhanh chóng\" /></p>\r\n\r\n<p>T&ugrave;y chỉnh v&agrave; t&igrave;m kiếm ứng dụng nhanh ch&oacute;ng tr&ecirc;n iPhone 11 Pro Max.</p>\r\n\r\n<p>Tất nhi&ecirc;n iOS 14 mang đến rất nhiều t&iacute;nh năng thật sự bổ &iacute;ch. Trong b&agrave;i đ&aacute;nh gi&aacute; iOS 14 gần đ&acirc;y, m&igrave;nh đ&atilde; t&igrave;m được những t&iacute;nh năng qu&aacute; ư l&agrave; th&iacute;ch th&uacute; như&nbsp;Xuất hiện đ&egrave;n nh&aacute;y, t&iacute;nh năng Picture in Picture cho ph&eacute;p vừa xem video vừa đa nhiệm, n&acirc;ng cấp t&iacute;nh năng cho camera hay t&iacute;nh năng Widgets c&oacute; thể t&ugrave;y chỉnh ngay tr&ecirc;n giao diện ch&iacute;nh....</p>\r\n\r\n<p>Bạn c&ograve;n c&oacute; thể th&ecirc;m App Library mới tr&ecirc;n iOS 14 chứa c&aacute;c Widgets l&ecirc;n m&agrave;n h&igrave;nh ch&iacute;nh v&agrave; c&aacute;c ứng dụng v&agrave;o trong một thư mục. Ứng dụng App Library mang đến kh&ocirc;ng gian hiển thị mới mẻ tr&ecirc;n m&agrave;n h&igrave;nh ch&iacute;nh, điều m&agrave; m&igrave;nh kh&ocirc;ng t&igrave;m thấy tr&ecirc;n giao diện cũ.</p>\r\n\r\n<p><img alt=\"Bạn có thể tùy chỉnh tính năng Widget trên màn hình chính\" src=\"https://cdn.tgdd.vn/Files/2020/09/21/1292069/b6_800x559.jpg\" title=\"Bạn có thể tùy chỉnh tính năng Widget trên màn hình chính\" /></p>\r\n\r\n<p>Bạn c&oacute; thể t&ugrave;y chỉnh t&iacute;nh năng Widget tr&ecirc;n m&agrave;n h&igrave;nh ch&iacute;nh.</p>\r\n\r\n<p>Khi n&acirc;ng cấp l&ecirc;n iOS 14, ch&uacute;ng ta c&oacute; thể th&ecirc;m trực tiếp những cửa sổ Widgets với k&iacute;ch thước t&ugrave;y th&iacute;ch ngay tại m&agrave;n h&igrave;nh ch&iacute;nh. Bạn c&oacute; thể th&ecirc;m những g&igrave; bạn th&iacute;ch, chẳng hạn như dự b&aacute;o thời tiết n&egrave;, đồng hồ to v&agrave; một số ứng dụng y&ecirc;u th&iacute;ch kh&aacute;c. C&oacute; một số điều m&igrave;nh cần phải n&oacute;i tr&ecirc;n iOS 14. Thứ nhất, một số t&iacute;nh năng hoạt động kh&ocirc;ng hiệu quả v&agrave; thứ hai, iOS 14 kh&ocirc;ng qu&aacute; tệ (như giảm thời lượng pin, giảm hiệu suất,...) như bạn nghĩ.</p>\r\n\r\n<p><img alt=\"Các thao tác tiếp theo để sử dụng PiP\" src=\"https://cdn.tgdd.vn/Files/2020/09/21/1292069/b8_1280x896.jpg\" title=\"Các thao tác tiếp theo để sử dụng PiP\" /></p>\r\n\r\n<p>C&aacute;c thao t&aacute;c tiếp theo để sử dụng PiP.</p>\r\n\r\n<p>Đầu ti&ecirc;n l&agrave; t&iacute;nh năng PiP, t&iacute;nh năng n&agrave;y cho ph&eacute;p người d&ugrave;ng iPhone c&oacute; thể vừa xem YouTube, vừa đa nhiệm một c&aacute;ch qu&aacute; th&ocirc;ng minh. Khi m&igrave;nh l&agrave;m b&agrave;i iOS 14 th&igrave; t&iacute;nh năng n&agrave;y vẫn hoạt động mượt m&agrave;, thế nhưng sau v&agrave;i ng&agrave;y th&igrave; bỗng chốt m&igrave;nh kh&ocirc;ng thể sử dụng t&iacute;nh năng n&agrave;y nữa. Thứ hai l&agrave; t&iacute;nh năng g&otilde; 2, 3 lần v&agrave;o mặt lưng hoạt động rất ng&agrave;y nắng ng&agrave;y mưa, l&uacute;c được l&uacute;c kh&ocirc;ng kh&aacute; kh&oacute; chịu.</p>\r\n\r\n<p><img alt=\"Thao tác gõ vào mặt lưng hoạt động không hiệu quả cho lắm\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08807_1280x720.jpg\" title=\"Thao tác gõ vào mặt lưng hoạt động không hiệu quả cho lắm\" /></p>\r\n\r\n<p>Thao t&aacute;c g&otilde; v&agrave;o mặt lưng hoạt động kh&ocirc;ng hiệu quả cho lắm.</p>\r\n\r\n<p>C&ograve;n về vấn đề pin yếu hay hiệu suất giảm th&igrave; chắc m&igrave;nh kh&ocirc;ng cần phải n&oacute;i nhiều. Ngay ở 2 mục đầu ti&ecirc;n của b&agrave;i viết n&agrave;y m&igrave;nh đ&atilde; cho c&aacute;c bạn xem những g&igrave; m&agrave; bạn đang ho&agrave;i nghi bấy l&acirc;u. Hiệu năng ổn định hơn v&agrave; pin kh&ocirc;ng giảm nhiều l&agrave; những g&igrave; m&igrave;nh nhận được, c&ograve;n bạn th&igrave; sao?</p>\r\n\r\n<h3>2. Camera iPhone 11 Pro Max vẫn xứng tầm cạnh tranh ở top đầu</h3>\r\n\r\n<p>Bạn muốn xem ảnh chụp từ camera iPhone 11 Pro Max chứ? Khoan đợi m&igrave;nh một t&iacute;, để m&igrave;nh điểm nhanh qua th&ocirc;ng số camera trước đ&atilde; nh&eacute;:</p>\r\n\r\n<ul>\r\n	<li>Ống kinh g&oacute;c rộng: Độ ph&acirc;n giải 12 MP, khẩu độ f/1.8, ti&ecirc;u cự 26 mm, hỗ trợ PDAF, chống rung OIS.</li>\r\n	<li>Ống k&iacute;nh tele: Độ ph&acirc;n giải 12 MP, khẩu độ f/2.0, ti&ecirc;u cự 52 mm, hỗ trợ PDAF, chống rung OIS, zoom quang học 2x.</li>\r\n	<li>Ống k&iacute;nh g&oacute;c si&ecirc;u rộng: Độ ph&acirc;n giải 12 MP, khẩu độ f/2.4, ti&ecirc;u cự 13 mm.</li>\r\n</ul>\r\n\r\n<p><img alt=\"iPhone 11 Pro Max sở hữu 3 camera sau với độ phân giải đều 12 MP\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08760_1280x720-800-resize.jpg\" title=\"iPhone 11 Pro Max sở hữu 3 camera sau với độ phân giải đều 12 MP\" /></p>\r\n\r\n<p>iPhone 11 Pro Max sở hữu 3 camera sau với độ ph&acirc;n giải đều 12 MP.</p>\r\n\r\n<p>C&ograve;n b&acirc;y giờ, c&ugrave;ng m&igrave;nh trải nghiệm những bức ảnh được chụp bằng chế độ tự động tr&ecirc;n iPhone 11 Pro Max. Kh&ocirc;ng biết với c&aacute;c bạn th&igrave; sao nhưng m&igrave;nh kh&aacute; th&iacute;ch những bức ảnh được chụp ở điều kiện thiếu s&aacute;ng. Thật ra đa số c&aacute;c smartphone chụp đ&ecirc;m đều cho ảnh noise, tuy nhi&ecirc;n điểm m&igrave;nh đ&aacute;nh gi&aacute; cao ở đ&acirc;y l&agrave; khả năng bắt khoảnh khắc tốt.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện thiếu sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c11_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện thiếu sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện thiếu s&aacute;ng bằng iPhone 11 Pro Max.</p>\r\n\r\n<p>Như bạn c&oacute; thể thấy ở bức ảnh b&ecirc;n dưới, m&igrave;nh đ&atilde; chụp được khoảnh khắc ngọn lửa đang ch&aacute;y hừng hực khi c&oacute; dịp về Bến Tre c&ugrave;ng b&egrave; bạn. Thật iPhone 11 Pro Max mang đến bức ảnh qu&aacute; ch&acirc;n thật, đồng thời chuyển động v&agrave;i gi&acirc;y (chế độ live) khi bạn chạm v&agrave;o bức ảnh trong khoảng hơn 1 gi&acirc;y.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện thiếu sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c1_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện thiếu sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện thiếu s&aacute;ng bằng iPhone 11 Pro Max.</p>\r\n\r\n<p>Với những điểm mạnh tr&ecirc;n, iPhone 11 Pro Max sẽ khiến người d&ugrave;ng h&agrave;i l&ograve;ng d&ugrave; kh&ocirc;ng mang đến một bức ảnh thật sự r&otilde; n&eacute;t v&agrave; đầy đủ chi tiết. Nhưng nếu bạn chụp ảnh ở điều kiện đủ s&aacute;ng th&igrave; mọi chuyện dễ d&agrave;ng hơn rất nhiều. Ảnh kh&ocirc;ng chỉ đẹp, r&otilde; r&agrave;ng, m&agrave;u sắc tươi, độ tương phản cao đ&atilde; khiến iPhone 11 Pro Max xứng đ&aacute;ng l&agrave; đối thủ nặng k&iacute; của c&aacute;c &ocirc;ng lớn c&ocirc;ng nghệ kh&aacute;c.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c3_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện đủ s&aacute;ng bằng iPhone 11 Pro Max.</p>\r\n\r\n<p>Đứng trước một khung cảnh rộng lớn với những t&ograve;a nh&agrave; cao tầng b&ecirc;n đường thế n&agrave;y, bạn n&ecirc;n thử chế độ chụp ảnh g&oacute;c rộng tr&ecirc;n iPhone 11 Pro Max. Chế độ g&oacute;c rộng kh&ocirc;ng qu&aacute; mới với người d&ugrave;ng Android nhưng với người d&ugrave;ng iOS th&igrave; đ&acirc;y l&agrave; một t&iacute;nh năng chỉ c&oacute; thể hệ mới nhất mới sở hữu.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện đủ sáng bằng chế độ góc rộng của iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c4_1280x960.jpg\" title=\"Ảnh chụp ở điều kiện đủ sáng bằng chế độ góc rộng của iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện đủ s&aacute;ng bằng chế độ g&oacute;c rộng của iPhone 11 Pro Max.</p>\r\n\r\n<p>Nhiều bạn cứ bảo m&igrave;nh &quot;chế độ n&agrave;y chả khi n&agrave;o cần đến&quot;, nhưng bản th&acirc;n m&igrave;nh lại d&ugrave;ng rất nhiều. T&ugrave;y theo nhu cầu sử dụng v&agrave; ho&agrave;n cảnh, như m&igrave;nh l&agrave; một người hay ra ngo&agrave;i, thường xuy&ecirc;n chụp khung cảnh xung quanh th&igrave; việc được trang bị t&iacute;nh năng chụp ảnh g&oacute;c rộng gi&uacute;p m&igrave;nh c&oacute; được một bức ảnh to&agrave;n cảnh đẹp mắt v&agrave; đầy đủ chi tiết.</p>\r\n\r\n<p><img alt=\"Ảnh chụp bằng chế độ góc rộng của iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c8_960x1280.jpg\" title=\"Ảnh chụp bằng chế độ góc rộng của iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện đủ s&aacute;ng bằng chế độ g&oacute;c rộng của iPhone 11 Pro Max.</p>\r\n\r\n<p>Điều kiện đủ s&aacute;ng l&agrave; một lợi thế lớn với ống k&iacute;nh tr&ecirc;n smartphone, gi&uacute;p c&aacute;c ống k&iacute;nh c&oacute; thể ph&aacute;t huy hết khả năng tiềm t&agrave;ng m&agrave; nh&agrave; sản xuất đ&atilde; cất c&ocirc;ng đầu tư v&agrave; ph&aacute;t triển suốt nhiều th&aacute;ng trời. Nh&igrave;n v&agrave;o những bức ảnh n&agrave;y chắc m&igrave;nh kh&ocirc;ng cần phải n&oacute;i nhiều nữa khi iPhone 11 Pro Max mang đến độ chi tiết tốt v&agrave; hấp dẫn hơn hết l&agrave; độ tương phản ở mức kh&aacute;.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c5_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện đủ s&aacute;ng bằng iPhone 11 Pro Max.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c6_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp g&oacute;c phố nhỏ tr&ecirc;n đường Nguyễn Huệ bằng iPhone 11 Pro Max.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c7_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện đủ sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp t&ograve;a Hoang Phuc tại đường Nguyễn Huệ bằng iPhone 11 Pro Max.</p>\r\n\r\n<p>Ở chế độ chụp tự động, iPhone 11 Pro Max cho ra những bức ảnh kh&aacute; ưng &yacute; nhưng ch&uacute;ng ta c&oacute; thể thay đổi để hợp với sở th&iacute;ch của m&igrave;nh hơn. Thanh EV, chắc m&igrave;nh kh&ocirc;ng cần phải n&oacute;i nhiều nếu bạn l&agrave; một người d&ugrave;ng iPhone l&acirc;u năm. Đ&acirc;y hẳn l&agrave; một t&iacute;nh năng hữu dụng khi gi&uacute;p bạn c&oacute; được những bức ảnh s&aacute;ng hơn hoặc chill hơn một c&aacute;ch đơn giản.</p>\r\n\r\n<p><img alt=\"Ảnh chụp bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c9_960x1280.jpg\" title=\"Ảnh chụp bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp bằng iPhone 11 Pro Max khi giảm thanh EV.</p>\r\n\r\n<p><img alt=\"Ảnh chụp ở điều kiện thiếu sáng bằng iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c10_960x1280.jpg\" title=\"Ảnh chụp ở điều kiện thiếu sáng bằng iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện thiếu s&aacute;ng bằng iPhone 11 Pro Max khi m&igrave;nh giảm thanh EV.</p>\r\n\r\n<p>Ngo&agrave;i ra th&igrave; với iPhone 11 Pro Max đ&acirc;y, việc t&iacute;ch hợp chế độ chụp đ&ecirc;m kh&ocirc;ng chỉ gi&uacute;p bạn tự tin hơn khi chụp ảnh trong điều kiện đủ s&aacute;ng m&agrave; c&ograve;n mang đến bức h&igrave;nh được phơi s&aacute;ng tốt, thấy dược c&aacute;c chi tiết bị khuất.</p>\r\n\r\n<p><img alt=\"Ảnh chụp bằng chế độ chụp đêm của iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/c13_1280x960.jpg\" title=\"Ảnh chụp bằng chế độ chụp đêm của iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp bằng chế độ chụp đ&ecirc;m của iPhone 11 Pro Max.</p>\r\n\r\n<p>N&oacute;i về camera selfie th&igrave; iPhone 11 Pro Max chỉ c&oacute; 1 camera ở mặt trước với độ ph&acirc;n giải l&agrave;&nbsp;12 MP, khẩu độ f/2.2. Camera selfie kh&ocirc;ng c&oacute; sự cải tiến khi n&acirc;ng cấp l&ecirc;n iOS 14 v&agrave; m&igrave;nh đ&aacute;nh gi&aacute; chất lượng ảnh ở mức trung b&igrave;nh, kh&ocirc;ng qu&aacute; nổi bật v&igrave; t&iacute;nh năng l&agrave;m tươi v&agrave; mịn da chưa đủ thuyết phục.</p>\r\n\r\n<p><img alt=\"Ảnh chụp bằng camera selfie trên iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/a4_960x1280.jpg\" title=\"Ảnh chụp bằng camera selfie trên iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Ảnh chụp bằng camera selfie tr&ecirc;n iPhone 11 Pro Max.</p>\r\n\r\n<h3>4. Thiết kế đầy sang trọng l&agrave; điểm mạnh của iPhone 11 Pro Max</h3>\r\n\r\n<p>Theo những th&ocirc;ng tin r&ograve; rỉ trong thời gian gần đ&acirc;y th&igrave; d&ograve;ng&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11\" target=\"_blank\" title=\"iPhone 11\" type=\"iPhone 11\">iPhone 11</a>&nbsp;Series c&oacute; lẽ l&agrave; phi&ecirc;n bản iPhone cuối c&ugrave;ng sử dụng thiết kế được bo cong ở c&aacute;c cạnh b&ecirc;n, vốn được thịnh h&agrave;nh trong suốt hơn 5 năm vừa qua. Dự đo&aacute;n từ c&aacute;c reviewer rằng iPhone 12 Series sẽ c&oacute; thiết kế vu&ocirc;ng vức của thế hệ iPhone 4, tr&ocirc;ng cũng đẹp đ&oacute; nhưng m&igrave;nh vẫn thiết phong c&aacute;ch thiết kế của iPhone 11 Pro Max đang sử dụng đ&acirc;y.</p>\r\n\r\n<p><img alt=\"Thiết kế tổng thể của iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08777_1280x720.jpg\" title=\"Thiết kế tổng thể của iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Thiết kế tổng thể của iPhone 11 Pro Max.</p>\r\n\r\n<p>Phi&ecirc;n bản m&igrave;nh đang sử dụng l&agrave; iPhone 11 Pro Max với m&agrave;u v&agrave;ng &oacute;ng &aacute;nh v&agrave; g&acirc;y hấp dẫn ngay từ c&aacute;i nh&igrave;n đầu ti&ecirc;n. M&agrave;u sắc n&agrave;y kết hợp c&ugrave;ng m&agrave;u đen của cụm camera khiến m&igrave;nh li&ecirc;n tưởng đến ly tr&agrave; sữa m&agrave; cuối tuần thường uống v&agrave; chuyện tr&ograve; c&ugrave;ng đ&aacute;m bạn th&acirc;n. Kh&ocirc;ng cần phải qu&aacute; ph&ocirc; trương v&agrave; nhiều chi tiết cấu k&igrave;, iPhone 11 Pro Max đơn giản chỉ c&oacute; m&agrave;u v&agrave;ng nhạt ở mặt lưng v&agrave; m&agrave;u v&agrave;ng &aacute;nh của c&aacute;c cạnh b&ecirc;n đầy hấp dẫn v&agrave; l&ocirc;i cuốn.</p>\r\n\r\n<p><img alt=\"Thiết kế cụm 3 camera không quá lồi như bạn nghĩ\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08781_1280x720.jpg\" title=\"Thiết kế cụm 3 camera không quá lồi như bạn nghĩ\" /></p>\r\n\r\n<p>Thiết kế viền cạnh v&agrave;ng &oacute;ng của iPhone 11 Pro Max.</p>\r\n\r\n<p>Mặt lưng của chiếc m&aacute;y được l&agrave;m nh&aacute;m gi&uacute;p cầm nắm chắc tay hơn, đồng thời gi&uacute;p hạn chế b&aacute;m dấu v&acirc;n tay so với phi&ecirc;n bản c&oacute; mặt lưng bằng k&iacute;nh (mặt d&ugrave; vẫn c&oacute; b&aacute;m đ&ocirc;i ch&uacute;t). Cảm gi&aacute;c cầm nắm th&igrave; kh&ocirc;ng c&oacute; g&igrave; mới lạ so với cảm gi&aacute;c khi cầm iPhone X Series cả khi m&agrave; hai d&ograve;ng m&aacute;y c&oacute; theietsa kế từa tựa nhau, tức l&agrave; kh&aacute; trơn đấy.</p>\r\n\r\n<p><img alt=\"Cảm giác cầm nắm iPhone 11 Pro Max trên tay rất sang\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08766_1280x720.jpg\" title=\"Cảm giác cầm nắm iPhone 11 Pro Max trên tay rất sang\" /></p>\r\n\r\n<p>Cảm gi&aacute;c cầm nắm iPhone 11 Pro Max tr&ecirc;n tay rất sang.</p>\r\n\r\n<p>L&uacute;c mới ra mắt th&igrave; nhiều bạn bảo với m&igrave;nh rằng camera lồi qu&aacute; n&egrave;, to qu&aacute; tr&ocirc;ng kh&aacute; th&ocirc; v&agrave; giống như những hạt tr&acirc;n ch&acirc;u trong ly tr&agrave; sữa. Nhưng sau gần 1 năm ra mắt, gu thẩm mỹ của ch&uacute;ng ta đ&atilde; thay đổi v&agrave; thấy phong c&aacute;ch của iPhone 11 Pro Max đẹp, hay do ch&uacute;ng ta kh&ocirc;ng nhận ra được c&aacute;i đẹp v&agrave; độ độc đ&aacute;o của cụm camera?</p>\r\n\r\n<p><img alt=\"Thiết kế camera sau của iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08755_1280x720.jpg\" title=\"Thiết kế camera sau của iPhone 11 Pro Max\" /></p>\r\n\r\n<p>Thiết kế cụm 3 camera kh&ocirc;ng qu&aacute; lồi như bạn nghĩ.</p>\r\n\r\n<p>N&oacute;i về m&agrave;n h&igrave;nh th&igrave; iPhone 11 Pro Max sở hữu phong c&aacute;ch thiết kế đặt trưng với notch tai thỏ, với &aacute;c viền cạnh xung quanh được tối ưu h&oacute;a nhằm tăng diện t&iacute;ch m&agrave;n ảnh l&ecirc;n. iPhone 11 Pro Max được trang bị m&agrave;n h&igrave;nh 6.5 inch với độ ph&acirc;n giải 1.242 x 2.688 pixels. Trải nghiệm thực tế m&igrave;nh đ&aacute;nh gi&aacute; khả năng mang đến chi tiết rất tốt v&agrave; xứng đ&aacute;ng với gi&aacute; tiền cao ngất.</p>\r\n\r\n<p><img alt=\"iPhone 11 Pro Max sở hữu màn hình lớn và đẹp mắt\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08834_1280x720.jpg\" title=\"iPhone 11 Pro Max sở hữu màn hình lớn và đẹp mắt\" /></p>\r\n\r\n<p>iPhone 11 Pro Max sở hữu m&agrave;n h&igrave;nh lớn v&agrave; đẹp mắt.</p>\r\n\r\n<p>Đừng qu&ecirc;n rằng iPhone 11 Pro Max sử dụng tấm nền OLED cho m&agrave;u sắc rực rỡ v&agrave; tươi tắn. Chiếc m&aacute;y c&oacute; độ s&aacute;ng&nbsp;1200 nits mang đến trải nghiệm tuyệt hơn bạn nghĩ nhiều. Tất nhi&ecirc;n rằng iPhone 11 Pro Max được trang bị đầy đủ c&aacute;c t&iacute;nh năng cần thiết như m&agrave;n h&igrave;nh từ động hay Ture Tone gi&uacute;p hạn chế &aacute;nh s&aacute;ng xanh.&nbsp;Trải nghiệm xem phim tr&ecirc;n iPhone 11 Pro Max rất th&uacute; vị với kh&ocirc;ng gian hiển thị rộng lớn.</p>\r\n\r\n<p><img alt=\"Trải nghiệm xem phim trên iPhone 11 Pro Max rất thú vị\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08821_1280x720.jpg\" title=\"Trải nghiệm xem phim trên iPhone 11 Pro Max rất thú vị\" /></p>\r\n\r\n<p>Trải nghiệm xem phim tr&ecirc;n iPhone 11 Pro Max rất th&uacute; vị.</p>\r\n\r\n<h3>Tổng kết</h3>\r\n\r\n<p>Khi n&acirc;ng cấp iOS 14, một trong những điểm m&igrave;nh ưng &yacute; nhất đ&oacute; l&agrave; một giao diện mới v&agrave; ch&uacute;ng ta đ&atilde; sở hữu được một chiếc điện thoại c&oacute; hiệu năng vượt trội v&agrave; ổn định hơn so với thế hệ iOS 13.7 trước đ&oacute;. M&igrave;nh đ&atilde; kh&ocirc;ng sử dụng bất k&igrave; một bản beta n&agrave;o trước đ&oacute; v&igrave; mong nhờ bản ch&iacute;nh thức đến từ Apple v&agrave; kết quả nhận được qu&aacute; xứng đ&aacute;ng.</p>\r\n\r\n<p><img alt=\"iOS 14 trên iPhone 11 Pro Max\" src=\"https://cdn.tgdd.vn/Files/2020/09/17/1290908/dsc08797_1280x720.jpg\" title=\"iOS 14 trên iPhone 11 Pro Max\" /></p>\r\n\r\n<p>iPhone 11 Pro Max đ&atilde; qu&aacute; tuyệt vời rồi, khi n&acirc;ng cấp l&ecirc;n iOS 14 nữa với sự cải tiến cả về phần mềm v&agrave; hiệu suất hoạt động ch&iacute;nh l&agrave; những yếu tố khiến m&igrave;nh bị hấp dẫn khi đ&aacute;nh gi&aacute; trong suốt tuần vừa qua. Bạn thấy iPhone 11 Pro Max l&ecirc;n iOS 14 thế n&agrave;o? H&atilde;y để lại b&igrave;nh luận b&ecirc;n dưới v&agrave; cho m&igrave;nh biết với nh&eacute;.</p>', 0, 1, 1, 10, '2020-10-31 00:38:33'),
(2, 'live', 'Samsung Galaxy M51 ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730 và camera chính 64M', '2187ae1df1ce04b2d21a00aea0df375fbef2c1d3.gif', 'Sau một thời gian chờ đợi th&igrave; h&ocirc;m nay (30/10), chiếc&nbsp;smartphone&nbsp;tầm trung&nbsp;Galaxy M51&nbsp;đ&atilde; ch&iacute;nh thức ra mắt tại Việt Nam. Galaxy M51 đi k&egrave;m với nhiều chi tiết ấn tượng, ', '<p><img alt=\"Galaxy M51\" src=\"https://cdn.tgdd.vn/Files/2020/10/28/1302643/galaxym51trang-14_800x450.jpg\" title=\"Galaxy M51\" /></p>\r\n\r\n<h2>Sau một thời gian chờ đợi th&igrave; h&ocirc;m nay (30/10), chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd/\" target=\"_blank\" title=\"smartphone \" type=\"smartphone \">smartphone</a>&nbsp;tầm trung&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-m51\" target=\"_blank\" title=\"Galaxy M51\" type=\"Galaxy M51\">Galaxy M51</a>&nbsp;đ&atilde; ch&iacute;nh thức ra mắt tại Việt Nam. Galaxy M51 đi k&egrave;m với nhiều chi tiết ấn tượng, một trong số đ&oacute; ch&iacute;nh l&agrave; thỏi pin dung lượng l&ecirc;n tới 7.000 mAh.</h2>\r\n\r\n<p>Về thiết kế, Galaxy M51 c&oacute; vẻ ngo&agrave;i sang chảnh với thiết kế m&agrave;n h&igrave;nh tr&agrave;n cạnh hiện đại, viền tr&ecirc;n c&oacute; một lỗ kho&eacute;t ở ch&iacute;nh giữa để chứa camera selfie l&ecirc;n tới 32 MP.</p>\r\n\r\n<p><img alt=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" src=\"https://cdn.tgdd.vn/Files/2020/10/28/1302643/samsung-galaxy-m51-5_800x450.jpg\" title=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" /></p>\r\n\r\n<p>Ph&iacute;a g&oacute;c tr&ecirc;n b&ecirc;n tr&aacute;i mặt sau của Galaxy M51 l&agrave; cụm camera h&igrave;nh chữ nhật, trong đ&oacute; c&oacute; c&aacute;c ống k&iacute;nh được xếp theo h&igrave;nh chữ L. Được biết, Galaxy M51 c&oacute; mặt sau bằng nhựa với lớp phủ b&oacute;ng mờ, gi&uacute;p chống b&aacute;m dấu v&acirc;n tay kh&aacute; tốt. Ngo&agrave;i ra, việc l&agrave;m bằng nhựa cũng g&oacute;p phần gi&uacute;p m&aacute;y c&oacute; trọng lượng nhẹ hơn, cho d&ugrave; đi k&egrave;m với thỏi pin l&ecirc;n tới 7.000 mAh.</p>\r\n\r\n<p><img alt=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" src=\"https://cdn.tgdd.vn/Files/2020/10/28/1302643/samsung-galaxy-m51-4_800x450.jpg\" title=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" /></p>\r\n\r\n<p>Về cấu h&igrave;nh, ngo&agrave;i thỏi pin khủng ra th&igrave; Galaxy M51 cũng đi k&egrave;m với nhiều th&agrave;nh phần rất ấn tượng. Đ&oacute; l&agrave; m&agrave;n h&igrave;nh Super AMOLED 6.7 inch độ ph&acirc;n giải Full HD+, chip Snapdragon 730 8 nh&acirc;n mạnh mẽ, kết hợp c&ugrave;ng bộ nhớ RAM 8 GB v&agrave; bộ nhớ trong 128 GB, c&oacute; cả khe cắm mở rộng microSD.</p>\r\n\r\n<p><img alt=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" src=\"https://cdn.tgdd.vn/Files/2020/10/28/1302643/samsung-galaxy-m51-2_800x450.jpg\" title=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" /></p>\r\n\r\n<p>Galaxy M51 đi k&egrave;m 4 camera mặt sau bao gồm: Camera ch&iacute;nh 64 MP, camera g&oacute;c si&ecirc;u rộng 12 MP, camera macro 5 MP v&agrave; cảm biến đo độ s&acirc;u 5 MP. Với 4 camera n&agrave;y, bạn sẽ thoải m&aacute;i để thể hiện khả năng chụp ảnh, linh hoạt trong mọi t&igrave;nh huống.</p>\r\n\r\n<p><img alt=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" src=\"https://cdn.tgdd.vn/Files/2020/10/28/1302643/samsung-galaxy-m51-3_800x533.jpg\" title=\"Samsung Galaxy M51 chính thức ra mắt tại Việt Nam: Pin khủng 7.000 mAh, chip Snapdragon 730, camera chính lên tới 64MP\" /></p>\r\n\r\n<p>C&aacute;c chi tiết kh&aacute;c của m&aacute;y bao gồm: Hai t&ugrave;y chọn m&agrave;u sắc Trắng + Đen, hỗ trợ sạc nhanh 25W, chạy Android 10, 2 SIM tiện lợi v&agrave; cảm biến v&acirc;n tay nằm ở cạnh phải.</p>\r\n\r\n<p>Về gi&aacute; b&aacute;n, Galaxy M51 c&oacute; gi&aacute; 9.49 triệu đồng v&agrave; nếu bạn đặt mua trước (giao h&agrave;ng từ 2 &ndash; 5/11), tại&nbsp;<a href=\"https://www.thegioididong.com/\" target=\"_blank\" title=\"Thế Giới Di Động\" type=\"Thế Giới Di Động\">Thế Giới Di Động</a>, bạn sẽ nhận được khuyến m&atilde;i giảm sốc 1 triệu đồng.</p>\r\n\r\n<p>Bạn thấy Galaxy M51 thế n&agrave;o? C&oacute; đ&aacute;ng gi&aacute; nhất trong tầm gi&aacute; khoảng 10 triệu đồng?</p>', 1, 1, 2, 27, '2020-10-31 02:06:43'),
(3, 'live', 'Xuất hiện bằng chứng cho thấy dòng smartphone Samsung màn hình gập thế hệ tiếp theo sẽ hỗ trợ bút cả', 'f1c88ea5243f0113d67065a7199fedc9e9b98b4c.jpg', 'Mục ti&ecirc;u cuối c&ugrave;ng của d&ograve;ng Galaxy Fold l&agrave; sẽ hỗ trợ b&uacute;t cảm ứng, nhưng Samsung được cho l&agrave; đang gặp kh&oacute; khăn về độ bền m&agrave;n h&igrave;nh uốn dẻo khi sử dụng lo', '<p><img alt=\"Xuất hiện bằng chứng cho thấy dòng smartphone Samsung màn hình gập thế hệ tiếp theo sẽ hỗ trợ bút cảm ứng S Pen\" src=\"https://cdn.tgdd.vn/Files/2020/10/30/1303441/samsung-galaxy-z-fold-3-s-pen-_1440x806-800-resize.jpg\" title=\"Xuất hiện bằng chứng cho thấy dòng smartphone Samsung màn hình gập thế hệ tiếp theo sẽ hỗ trợ bút cảm ứng S Pen\" /></p>\r\n\r\n<h2>Mục ti&ecirc;u cuối c&ugrave;ng của d&ograve;ng&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-fold\" target=\"_blank\" title=\"Galaxy Fold\">Galaxy Fold</a>&nbsp;l&agrave; sẽ hỗ trợ b&uacute;t cảm ứng, nhưng&nbsp;<a href=\"https://www.thegioididong.com/samsung\" target=\"_blank\" title=\"Samsung\">Samsung</a>&nbsp;được cho l&agrave; đang gặp kh&oacute; khăn về độ bền m&agrave;n h&igrave;nh uốn dẻo khi sử dụng loại b&uacute;t n&agrave;y.</h2>\r\n\r\n<p>B&acirc;y giờ, một bằng s&aacute;ng chế mới xuất hiện từ Samsung Electronics cho thấy họ c&oacute; thể đ&atilde; giải quyết được c&aacute;c vấn đề của m&igrave;nh. Bằng s&aacute;ng chế được nộp l&ecirc;n WIPO (Văn ph&ograve;ng Sở hữu Tr&iacute; tuệ Thế giới) v&agrave;o th&aacute;ng 4/2020, m&ocirc; tả c&aacute;ch Samsung muốn&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"smartphone\">smartphone</a>&nbsp;m&agrave;n h&igrave;nh gập gập của m&igrave;nh tương th&iacute;ch với b&uacute;t S-Pen của họ.</p>\r\n\r\n<p>C&aacute;c h&igrave;nh ảnh cho thấy smartphone m&agrave;n h&igrave;nh gập sẽ c&oacute; một lỗ kho&eacute;t để chứa b&uacute;t S Pen, v&igrave; vậy m&agrave; m&aacute;y sẽ kh&ocirc;ng bị tăng độ d&agrave;y.</p>\r\n\r\n<p><img alt=\"Xuất hiện bằng chứng cho thấy dòng smartphone Samsung màn hình gập thế hệ tiếp theo sẽ hỗ trợ bút cảm ứng S Pen\" src=\"https://cdn.tgdd.vn/Files/2020/10/30/1303441/samsung-z-fold-3-1-_1440x1038-800-resize.jpg\" title=\"Xuất hiện bằng chứng cho thấy dòng smartphone Samsung màn hình gập thế hệ tiếp theo sẽ hỗ trợ bút cảm ứng S Pen\" /></p>\r\n\r\n<p>C&aacute;c b&aacute;o c&aacute;o trước đ&acirc;y từ H&agrave;n Quốc cũng cho biết, Samsung đang t&igrave;m kiếm giải ph&aacute;p để đưa b&uacute;t S Pen đi k&egrave;m với smartphone m&agrave;n h&igrave;nh gập. Một l&agrave; tăng độ d&agrave;y k&iacute;nh Ultrathin Glass từ 30 micromet l&ecirc;n 60 micromet, hai l&agrave; chuyển sang c&ocirc;ng nghệ gọi l&agrave; &quot;Active Electrostatic Solution&quot; (AES) cho b&uacute;t S Pen, n&oacute; đắt hơn nhưng sẽ hỗ trợ m&agrave;n h&igrave;nh uốn dẻo tốt hơn.</p>\r\n\r\n<p>Bằng s&aacute;ng chế vẫn chỉ đề cập tới c&ocirc;ng nghệ &quot;Electromagnetic Resonance&quot; (EMR) đang được sử dụng tr&ecirc;n d&ograve;ng Note, nhưng Samsung vẫn chưa đưa ra lựa chọn cuối c&ugrave;ng.</p>\r\n\r\n<p>Theo bạn th&igrave; S Pen c&oacute; cần thiết tr&ecirc;n d&ograve;ng smartphone m&agrave;n h&igrave;nh gập kh&ocirc;ng?</p>', 1, 1, 6, 64, '2020-10-31 02:35:54'),
(4, 'live', 'Smartphone tầm trung Galaxy M51 lộ khung thời gian ra mắt, giá bán dự kiến tăng lên gần 9.3 triệu tạ', 'd87efe9f50d8292e5681f0427968eae25c13ecb7.png', 'C&oacute; th&ocirc;ng tin cho rằng Samsung đ&atilde; l&ecirc;n kế hoạch ra mắt Galaxy M51 v&agrave;o th&aacute;ng 7/2020, nhưng sau đ&oacute; bị đẩy l&ugrave;i sang th&aacute;ng 9 do c&aacute;c vấn đề li&ecirc;n quan đến dịch Cov', '<p><img alt=\"Galaxy M51\" src=\"https://cdn.tgdd.vn/Files/2020/08/25/1283701/galaxy-m51-1_800x450.png\" title=\"Galaxy M51\" /></p>\r\n\r\n<p>H&igrave;nh ảnh render của Galaxy M51</p>\r\n\r\n<h2>C&oacute; th&ocirc;ng tin cho rằng&nbsp;<a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Samsung\" type=\"Samsung\">Samsung</a>&nbsp;đ&atilde; l&ecirc;n kế hoạch ra mắt&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-m51\" target=\"_blank\" title=\"Galaxy M51\" type=\"Galaxy M51\">Galaxy M51</a>&nbsp;v&agrave;o th&aacute;ng 7/2020, nhưng sau đ&oacute; bị đẩy l&ugrave;i sang th&aacute;ng 9 do c&aacute;c vấn đề li&ecirc;n quan đến dịch Covid-19. Hiện tại, một nguồn tin cho rằng Galaxy M51 sẽ được tr&igrave;nh l&agrave;ng tại Ấn Độ v&agrave;o tuần thứ hai của th&aacute;ng 9.</h2>\r\n\r\n<p>B&aacute;o c&aacute;o cho biết th&ecirc;m, Galaxy M51 sẽ c&oacute; gi&aacute; từ 336 USD (khoảng 7.7 triệu đồng) đến 403 USD (khoảng 9.3 triệu đồng). C&aacute;c trang hỗ trợ sản phẩm đ&atilde; được cập nhật tr&ecirc;n trang web tiếp thị ch&iacute;nh thức của Samsung tại Ấn Độ. Galaxy M51 cũng đ&atilde; được c&aacute;c cơ quan như FCC v&agrave; WiFi Alliance chứng nhận.</p>\r\n\r\n<p>Galaxy M51 dự kiến sở hữu m&agrave;n h&igrave;nh Super AMOLED 6.7 inch theo thiết kế Infinity-O với độ ph&acirc;n giải Full HD+. Thiết bị được cho sẽ c&oacute; bộ xử l&yacute; Snapdragon 730G, bộ nhớ RAM 6 GB v&agrave; 8 GB, bộ nhớ lưu trữ UFS 128 GB, hỗ trợ cắm th&ecirc;m thẻ microSD mở rộng.</p>\r\n\r\n<p><img alt=\"Galaxy M51\" src=\"https://cdn.tgdd.vn/Files/2020/08/25/1283701/galaxy-m51_800x417.jpg\" title=\"Galaxy M51\" /></p>\r\n\r\n<p>H&igrave;nh ảnh render của Galaxy M51</p>\r\n\r\n<p><a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"điện thoại\" type=\"điện thoại\">Điện thoại</a>&nbsp;sẽ chạy One UI 2.1 t&ugrave;y biến tr&ecirc;n Android 10 khi xuất xưởng. Điểm nhấn kế tiếp của Galaxy M51 l&agrave; vi&ecirc;n pin dung lượng khủng 7.000 mAh v&agrave; hỗ trợ sạc nhanh 25 W. K&iacute;ch thước thổng thể của thiết bị lần lượt l&agrave; 163.9 x 76.3 x 9.5 mm v&agrave; nặng 213 gram.</p>\r\n\r\n<p>Galaxy M51 sẽ c&oacute; camera trước 32 MP với khẩu độ F/2.2. Mặt sau của thiết bị sẽ l&agrave; thiết lập 4 camera, bao gồm một camera g&oacute;c rộng 64 MP, một camera si&ecirc;u rộng 12 MP, cảm biến độ s&acirc;u 5 MP v&agrave; camera macro 5 MP.</p>\r\n\r\n<p>Một số trang bị v&agrave; t&iacute;nh năng dự kiến kh&aacute;c của Galaxy M51: Cảm biến v&acirc;n tay gắn ph&iacute;a cạnh b&ecirc;n, hỗ trợ LTE, GPS, khe cắm thẻ SIM k&eacute;p, Bluetooth 5.0, cổng USB-C v&agrave; cổng tai nghe 3.5 mm.</p>\r\n\r\n<p>Bạn kỳ vọng điều g&igrave; tr&ecirc;n Galaxy M51?</p>', 0, 1, 2, 15, '2020-10-31 02:56:57'),
(5, 'live', 'Đố các fan \'Táo khuyết\', iPhone SE 2020 màu nào được nhiều người chọn mua nhất, đã có hơn 1000 người đặt trước rồi đấy', '871c3c792f1feaa4884c479c04225620209c718b.gif', 'Description', '<p><img alt=\"Hình ảnh iPhone SE 2020\" src=\"https://cdn.tgdd.vn/Files/2020/06/05/1261000/3_800x450.jpg\" title=\"Hình ảnh iPhone SE 2020\" /></p>\r\n\r\n<h2>Theo như th&ocirc;ng tin m&igrave;nh vừa cập nhật, số người đặt&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-se-2020\" target=\"_blank\" title=\"iPHONE SE 2020\" type=\"iPHONE SE 2020\">iPhone SE 2020</a>&nbsp;đặt trước vượt mốc 1000 v&agrave; vẫn kh&ocirc;ng c&oacute; dấu hiệu hạ nhiệt. Vậy bạn biết những m&agrave;u n&agrave;o của chiếc điện thoại n&agrave;y được nhiều người chọn mua nhất kh&ocirc;ng? Dẫn đầu l&agrave; m&agrave;u đen mạnh mẽ, kế tiếp l&agrave; đỏ c&aacute; t&iacute;nh v&agrave; cuối c&ugrave;ng l&agrave; trắng tinh kh&ocirc;i.</h2>\r\n\r\n<p><img alt=\"Hỉnh ảnh iPhone SE 2020 Black\" src=\"https://cdn.tgdd.vn/Files/2020/06/05/1261000/4_800x450.jpg\" title=\"Hỉnh ảnh iPhone SE 2020 Black\" /></p>\r\n\r\n<p>V&igrave; sao lại vậy ư? V&igrave; m&agrave;u đen thời thượng hơn, tối giản hơn v&agrave; chất hơn so với 2 m&agrave;u c&ograve;n lại.&nbsp; Đ&oacute; l&agrave; &yacute; kiến của m&igrave;nh, c&ograve;n bạn th&igrave; sao? M&agrave;u n&agrave;o l&agrave;m bạn thấy ưng &yacute; nhất n&agrave;o?</p>\r\n\r\n<p>&Agrave; m&igrave;nh qu&ecirc;n nhắc cho bạn biết, ưu đ&atilde;i giảm ngay 1.5 triệu đồng hoặc trả g&oacute;p 0% khi đặt trước&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-se-2020\" target=\"_blank\" title=\"iPHONE SE 2020\" type=\"iPHONE SE 2020\">iPhone SE 2020</a>&nbsp;đ&atilde; gần chốt rồi đấy, số lượng c&oacute; hạn n&ecirc;n h&atilde;y nhanh đặt ngay từ h&ocirc;m nay để sở hữu cực phẩm mới của nh&agrave; &quot;T&aacute;o khuyết&quot; với gi&aacute; tốt nhất n&agrave;o.</p>\r\n', 1, 1, 8, 43, '2020-10-31 03:40:04');
INSERT INTO `posts` (`id`, `status`, `title`, `thumb`, `description`, `content`, `is_featured`, `user_id`, `product_id`, `num_view`, `date_created`) VALUES
(6, 'live', 'Lý do nào khiến Vivo Y12s trở thành smartphone đáng mua nhất trong phân khúc giá rẻ: Thiết kế ấn tượng, màn hình lớn và hơn thế nữa', '5331227de780f5c48c30980372b19e29f89cbcae.jpg', 'Lựa chọn một chiếc smartphone với mức giá rẻ nhưng phải đáp ứng tốt mọi nhu cầu là một điều không hề dễ. Và Vivo đã hiểu được vấn đề đó của khách hàng, mới đây, hãng đã cho ra mắt sản phẩm Vivo Y12s với thiết kế ấn tượng, pin khủng và đi kèm với một mức giá cực kỳ tốt.', '<p><img alt=\"Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-6_800x450.jpg\" title=\"Vivo Y12s\" /></p>\r\n\r\n<h2>Lựa chọn một chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"smartphone\" type=\"smartphone\">smartphone</a>&nbsp;với mức gi&aacute; rẻ nhưng phải đ&aacute;p ứng tốt mọi nhu cầu l&agrave; một điều kh&ocirc;ng hề dễ. V&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd-vivo\" target=\"_blank\" title=\"Vivo\" type=\"Vivo\">Vivo</a>&nbsp;đ&atilde; hiểu được vấn đề đ&oacute; của kh&aacute;ch h&agrave;ng, mới đ&acirc;y, h&atilde;ng đ&atilde; cho ra mắt sản phẩm&nbsp;<a href=\"https://www.thegioididong.com/dtdd/vivo-y12s\" target=\"_blank\" title=\"Vivo Y12s\" type=\"Vivo Y12s\">Vivo Y12s</a>&nbsp;với thiết kế ấn tượng, pin khủng v&agrave; đi k&egrave;m với một mức gi&aacute; cực kỳ tốt.</h2>\r\n\r\n<p>Với mức gi&aacute; chỉ khoảng 3 triệu đồng, ch&uacute;ng ta c&ugrave;ng xem thử chiếc m&aacute;y Vivo Y12s sẽ l&agrave;m được những điều g&igrave; nh&eacute;!</p>\r\n\r\n<h3>Ngoại h&igrave;nh cuốn h&uacute;t, cảm gi&aacute;c cầm nắm tốt</h3>\r\n\r\n<p>Vivo Y12s được thiết kế với phong c&aacute;ch hiện đại, ấn tượng với những hiệu ứng chuyển m&agrave;u độc đ&aacute;o v&agrave; b&oacute;ng bẩy. M&aacute;y được ho&agrave;n thiện từ nhựa, tuy nhi&ecirc;n vẫn c&oacute; được sự cứng c&aacute;p v&agrave; kh&ocirc;ng bị ọp ẹp khi cầm tr&ecirc;n tay.</p>\r\n\r\n<p><img alt=\"Thiết kế mặt sau của Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-3_800x450.jpg\" title=\"Thiết kế mặt sau của Vivo Y12s\" /></p>\r\n\r\n<p>Thiết kế mặt sau của Vivo Y12s</p>\r\n\r\n<p>C&ugrave;ng với đ&oacute;, mặt lưng của m&aacute;y được bo cong mềm mại, kết hợp với phần th&acirc;n m&aacute;y c&oacute; trọng lượng vừa phải (191 gram) mang đến cảm gi&aacute;c cầm nắm tương đối đầm tay v&agrave; kh&ocirc;ng hề c&oacute; t&igrave;nh trạng bị cấn.</p>\r\n\r\n<p><img alt=\"Phần thân máy của Vivo Y12s tương đối mỏng\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-10_800x450.jpg\" title=\"Phần thân máy của Vivo Y12s tương đối mỏng\" /></p>\r\n\r\n<p>Phần th&acirc;n m&aacute;y của Vivo Y12s tương đối mỏng</p>\r\n\r\n<p>M&aacute;y c&oacute; hai t&ugrave;y chọn m&agrave;u sắc l&agrave; Đen v&agrave; Xanh da trời tạo n&ecirc;n những c&aacute; t&iacute;nh ho&agrave;n to&agrave;n kh&aacute;c nhau. Trong khi m&agrave;u đen hướng tới sự sang trọng, lịch l&atilde;m th&igrave; m&agrave;u xanh lại to&aacute;t l&ecirc;n vẻ trẻ trung, năng động cho người d&ugrave;ng.</p>\r\n\r\n<p><img alt=\"Hiệu ứng màu sắc mặt lưng của Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-1_800x450.jpg\" title=\"Hiệu ứng màu sắc mặt lưng của Vivo Y12s\" /></p>\r\n\r\n<p>Hiệu ứng m&agrave;u sắc mặt lưng của Vivo Y12s</p>\r\n\r\n<p>Ch&iacute;nh v&igrave; thế, Vivo Y12s sẽ c&oacute; thể ph&ugrave; hợp với hầu hết kh&aacute;ch h&agrave;ng với c&aacute;c độ tuổi kh&aacute;c nhau v&agrave; lu&ocirc;n tạo được sự nổi bật trong mọi trường hợp.</p>\r\n\r\n<h3>Kh&ocirc;ng gian hiển thị rộng lớn</h3>\r\n\r\n<p>Vivo Y12s sở hữu m&agrave;n h&igrave;nh Halo tr&agrave;n viền k&iacute;ch thước 6.51 inch v&agrave; được l&agrave;m cong 2.5D cho cảm gi&aacute;c vuốt chạm từ c&aacute;c cạnh trở n&ecirc;n mượt m&agrave; hơn.</p>\r\n\r\n<p><img alt=\"Hình ảnh sản phẩm Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-14_800x450.jpg\" title=\"Hình ảnh sản phẩm Vivo Y12s\" /></p>\r\n\r\n<p>Thiết kế mặt trước của Vivo Y12s</p>\r\n\r\n<p>Cạnh viền kh&aacute; c&acirc;n đối cho tỷ lệ m&agrave;n h&igrave;nh tr&ecirc;n th&acirc;n m&aacute;y l&ecirc;n đến 89%, mang đến trải nghiệm h&igrave;nh ảnh chất lượng, c&aacute;c thao t&aacute;c bằng một tay tr&ecirc;n m&agrave;n h&igrave;nh đều hết sức dễ d&agrave;ng.</p>\r\n\r\n<p><img alt=\"Giao diện thanh trạng thái trên Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-22_800x450.jpg\" title=\"Giao diện thanh trạng thái trên Vivo Y12s\" /></p>\r\n\r\n<p>Giao diện thanh trạng th&aacute;i tr&ecirc;n Vivo Y12s</p>\r\n\r\n<p>Hơn nữa, m&agrave;n h&igrave;nh tr&ecirc;n Vivo Y12s c&ograve;n được t&iacute;ch hợp c&ocirc;ng nghệ In-cell mới nhất. Trong nhiều điều kiện sử dụng kh&aacute;c nhau như chơi game hay xem video th&igrave; m&agrave;u sắc hiển thị đều rực rỡ v&agrave; chi tiết, nhưng vẫn đảm bảo giảm lượng &aacute;nh s&aacute;ng xanh c&oacute; hại v&agrave; bảo vệ thị lực của bạn.</p>\r\n\r\n<h3>Hiệu năng ổn, chế độ chơi game th&ocirc;ng minh</h3>\r\n\r\n<p>Với một mức gi&aacute; rẻ, ch&uacute;ng ta kh&ocirc;ng thể y&ecirc;u cầu qu&aacute; cao về hiệu năng của thiết bị. Tuy nhi&ecirc;n, với vi xử l&yacute; MediaTek Helio P35 kết hợp c&ugrave;ng 3 GB RAM v&agrave; 32 GB bộ nhớ trong, Vivo Y12s vẫn c&oacute; thể đ&aacute;p ứng được tốt c&aacute;c t&aacute;c vụ h&agrave;ng ng&agrave;y. Bạn vẫn c&oacute; thể giải tr&iacute; với những tựa game nhẹ nh&agrave;ng tr&ecirc;n chiếc m&aacute;y n&agrave;y. &nbsp;</p>\r\n\r\n<p><img alt=\"Vivo Y12s được trang bị vi xử lý MediaTek Helio P35\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-20_800x450.jpg\" title=\"Vivo Y12s được trang bị vi xử lý MediaTek Helio P35\" /></p>\r\n\r\n<p>Vivo Y12s được trang bị vi xử l&yacute; MediaTek Helio P35</p>\r\n\r\n<p>Th&ecirc;m v&agrave;o đ&oacute;, Vivo Y12s c&ograve;n mang đến những trải nghiệm chơi game chuy&ecirc;n nghiệp với chế độ Ultra-Game Mode, Rung 4D 2.0 c&ugrave;ng h&agrave;ng loạt c&aacute;c chức năng tối ưu h&oacute;a hiệu năng, ngăn cửa sổ bật l&ecirc;n, chặn th&ocirc;ng b&aacute;o, cuộc gọi đến,...gi&uacute;p bạn ho&agrave;n to&agrave;n tập trung v&agrave; h&ograve;a m&igrave;nh v&agrave;o kh&ocirc;ng gian giải tr&iacute; bất tận.</p>\r\n\r\n<p><img alt=\"Vivo Y12s hỗ trợ chế độ chơi game thông minh\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-23_800x450.jpg\" title=\"Vivo Y12s hỗ trợ chế độ chơi game thông minh\" /></p>\r\n\r\n<p>Vivo Y12s hỗ trợ chế độ chơi game th&ocirc;ng minh</p>\r\n\r\n<p>Vivo Y12s c&agrave;i sẵn giao diện người d&ugrave;ng Funtouch OS 10.5 dựa tr&ecirc;n hệ điều h&agrave;nh Android 10 gi&uacute;p m&aacute;y c&oacute; được sự t&ugrave;y biến th&ocirc;ng minh c&ugrave;ng nhiều t&iacute;nh năng mới mẻ, đa dạng.</p>\r\n\r\n<p><img alt=\"Vivo Y12s được cài sẵn Funtouch OS 10.5\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-21_800x450.jpg\" title=\"Vivo Y12s được cài sẵn Funtouch OS 10.5\" /></p>\r\n\r\n<p>Vivo Y12s được c&agrave;i sẵn Funtouch OS 10.5</p>\r\n\r\n<h3>Camera t&iacute;ch hợp nhiều t&iacute;nh năng l&agrave;m đẹp</h3>\r\n\r\n<p>Vivo Y12s được trang bị hệ thống camera sau gồm hai ống k&iacute;nh với độ ph&acirc;n giải lần lượt l&agrave; 13 MP v&agrave; 2 MP t&iacute;ch hợp nhiều t&iacute;nh năng chụp ảnh, l&agrave;m đẹp th&ocirc;ng minh bao gồm nhận diện khu&ocirc;n mặt, tự động lấy n&eacute;t,&hellip;</p>\r\n\r\n<p><img alt=\"Cận cảnh cụm camera sau của Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-4_800x450.jpg\" title=\"Cận cảnh cụm camera sau của Vivo Y12s\" /></p>\r\n\r\n<p>Cận cảnh cụm camera sau của Vivo Y12s</p>\r\n\r\n<p>Với điều kiện đủ s&aacute;ng, m&aacute;y cho ra h&igrave;nh ảnh với chất lượng chi tiết v&agrave; độ tương phản tương đối tốt. V&igrave; vậy, người d&ugrave;ng ho&agrave;n to&agrave;n c&oacute; thể ghi lại mọi khoảnh khắc đẹp trong cuộc sống một c&aacute;ch dễ d&agrave;ng.</p>\r\n\r\n<p><img alt=\"Giao diện chụp ảnh của Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-24_800x450.jpg\" title=\"Giao diện chụp ảnh của Vivo Y12s\" /></p>\r\n\r\n<p>Giao diện chụp ảnh của Vivo Y12s</p>\r\n\r\n<p>Th&ecirc;m v&agrave;o đ&oacute;, camera trước của m&aacute;y c&oacute; độ ph&acirc;n giải 8 MP hỗ trợ c&acirc;n chỉnh đường n&eacute;t tr&ecirc;n gương mặt, mang đến những tấm ảnh selfie lung linh để chia sẻ c&ugrave;ng người th&acirc;n v&agrave; gia đ&igrave;nh.</p>\r\n\r\n<h3>Dung lượng pin khủng 5.000 mAh</h3>\r\n\r\n<p>Vivo Y12s được trang bị vi&ecirc;n cực khủng dung lượng 5.000 mAh, đ&aacute;p ứng tốt nhu cầu sử dụng của bạn trong một ng&agrave;y d&agrave;i m&agrave; kh&ocirc;ng cần lo ngại về vấn đề pin.</p>\r\n\r\n<p><img alt=\"Vivo Y12s sở hữu viên pin 5.000 mAh\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivo-y12s_800x378.png\" title=\"Vivo Y12s sở hữu viên pin 5.000 mAh\" /></p>\r\n\r\n<p>Vivo Y12s sở hữu vi&ecirc;n pin 5.000 mAh</p>\r\n\r\n<p>Ngo&agrave;i ra, m&aacute;y c&ograve;n được t&iacute;ch hợp chế độ tiết kiệm pin th&ocirc;ng minh, gi&uacute;p bạn c&oacute; thể thoải m&aacute;i xem phim HD l&ecirc;n đến 15 giờ hoặc chơi game li&ecirc;n tục suốt 9 giờ.</p>\r\n\r\n<h3>Tổng kết</h3>\r\n\r\n<p>Với thiết kế đẹp mắt, cấu h&igrave;nh ổn v&agrave; dung lượng pin lớn, Vivo Y12s l&agrave; một trong những sản phẩm gi&aacute; rẻ hiếm hoi c&oacute; thể đ&aacute;p ứng mọi nhu cầu của bạn từ học tập, giải tr&iacute;, lướt web hay chơi c&aacute;c tựa game nhẹ nh&agrave;ng. Đ&acirc;y l&agrave; một sản phẩm cực kỳ th&iacute;ch hợp cho người d&ugrave;ng phổ th&ocirc;ng.</p>\r\n\r\n<p><img alt=\"Hình ảnh sản phẩm Vivo Y12s\" src=\"https://cdn.tgdd.vn/Files/2020/10/23/1301484/vivoy12s-26_800x450.jpg\" title=\"Hình ảnh sản phẩm Vivo Y12s\" /></p>\r\n\r\n<p>H&igrave;nh ảnh sản phẩm Vivo Y12s</p>\r\n\r\n<p>Nếu bạn đang c&oacute; nhu cầu th&igrave; nhanh tay l&ecirc;n, Vivo vừa bất ngờ tung ra hotsale giảm sốc 300 ngh&igrave;n đồng cho Vivo Y12s. Hiện sản phẩm được b&aacute;n độc quyền tại&nbsp;<a href=\"https://www.thegioididong.com/\" target=\"_blank\" title=\"Thế Giới Di Động\" type=\"Thế Giới Di Động\">Thế Giới Di Động</a>&nbsp;v&agrave; thời gian hotsale chỉ diễn ra vỏn vẹn trong 2 ng&agrave;y cuối tuần (từ ng&agrave;y 24 - 25/10/2020). Đừng bỏ lỡ nh&eacute;!</p>', 0, 1, 9, 2, '2020-10-31 07:24:59'),
(7, 'live', 'Đánh giá chi tiết Vivo V19 Neo: Camera chụp đẹp mê, cầm đi chơi thì khỏi chê nha!', '282d21ee09110d617ac264097a9eeda320306d51.jpg', 'Vivo kh&ocirc;ng nỡ giảm chất lượng của camera v&igrave; đ&acirc;y l&agrave; một trong những yếu tố được đ&aacute;nh mạnh v&agrave;o nhất. Vivo đ&atilde; n&oacute;i rằng chiếc Vivo V19 Neo n&agrave;y được tập trung v&agrave;o khả năng chụp ảnh thiếu s&aacute;ng, do đ&oacute; m&igrave;nh đ&atilde; cầm m&aacute;y ra Landmark 81 để test ngay.', '<h2>Sau&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia-chi-tiet-vivo-v19-1250533\" target=\"_blank\" title=\"Đánh giá Vivo V19\" type=\"Đánh giá Vivo V19\">b&agrave;i đ&aacute;nh gi&aacute; Vivo V19</a>, m&igrave;nh đ&atilde; nhận được&nbsp;<a href=\"https://www.thegioididong.com/dtdd/vivo-v19-neo\" target=\"_blank\" title=\"Vivo V19 Neo\" type=\"Vivo V19 Neo\">Vivo V19 Neo</a>&nbsp;từ sếp với c&acirc;u n&oacute;i quen thuộc:&nbsp;<a href=\"https://www.thegioididong.com/tin-tuc/danh-gia/210\" target=\"_blank\" title=\"đánh giá TGDĐ\" type=\"đánh giá TGDĐ\">Đ&aacute;nh gi&aacute;</a>&nbsp;đi em. Ch&agrave;, một phi&ecirc;n bản được cắt giảm đi một số yếu tố kh&aacute; quan trọng, chẳng hạn như cấu h&igrave;nh v&agrave; hiệu năng. Thế nhưng,&nbsp;<a href=\"https://www.thegioididong.com/dtdd-vivo\" target=\"_blank\" title=\"Vivo\" type=\"Vivo\">Vivo</a>&nbsp;vẫn kh&ocirc;ng nỡ giảm khả năng chụp ảnh của chiếc&nbsp;<a href=\"https://www.thegioididong.com/dtdd\" target=\"_blank\" title=\"smartphone\" type=\"smartphone\">smartphone</a>&nbsp;v&agrave; ch&iacute;nh điều đ&oacute; đ&atilde; trở th&agrave;nh điểm mạnh của V19 Neo.</h2>\r\n\r\n<p><img alt=\"Vivo V19 Neo\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/vivov19neo-1_1280x720.jpg\" title=\"Vivo V19 Neo\" /></p>\r\n\r\n<p>Thiết kế tổng thể của Vivo V19 Neo.</p>\r\n\r\n<h3>1. Camera đ&aacute;ng gi&aacute; đến mức n&agrave;o?</h3>\r\n\r\n<p>Trước khi bước v&agrave;o đ&aacute;nh gi&aacute; camera của Vivo V19 Neo, m&igrave;nh xin ph&eacute;p được điểm qua th&ocirc;ng số phần cứng của chiếc m&aacute;y một ch&uacute;t nh&eacute;:</p>\r\n\r\n<ul>\r\n	<li>Ống k&iacute;nh g&oacute;c rộng: Độ ph&acirc;n giải 48 MP, khẩu độ f/1.8.</li>\r\n	<li>Ống k&iacute;nh g&oacute;c si&ecirc;u rộng: Độ ph&acirc;n giải 8 MP, khẩu độ f/2.2, ti&ecirc;u cự 13 mm.</li>\r\n	<li>Ống k&iacute;nh macro: Độ ph&acirc;n giải 2 MP, khẩu độ f/2.4.</li>\r\n	<li>Ống k&iacute;nh độ s&acirc;u: Độ ph&acirc;n giải 2 MP, khẩu độ f/2.4.</li>\r\n</ul>\r\n\r\n<p><img alt=\"So sánh 1\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d4_1280x843.jpg\" title=\"So sánh 1\" /></p>\r\n\r\n<p>Ảnh chụp ở chế độ tự động (b&ecirc;n tr&aacute;i) v&agrave; ảnh chụp bằng chế độ chụp đ&ecirc;m (b&ecirc;n phải).</p>\r\n\r\n<p>Mặc d&ugrave; l&agrave; phi&ecirc;n bản cắt giảm nhưng c&oacute; lẽ, Vivo kh&ocirc;ng nỡ giảm chất lượng của camera v&igrave; đ&acirc;y l&agrave; một trong những yếu tố được đ&aacute;nh mạnh v&agrave;o nhất. Vivo đ&atilde; n&oacute;i rằng chiếc Vivo V19 Neo n&agrave;y được tập trung v&agrave;o khả năng chụp ảnh thiếu s&aacute;ng, do đ&oacute; m&igrave;nh đ&atilde; cầm m&aacute;y ra Landmark 81 để test ngay.</p>\r\n\r\n<p>Như bạn c&oacute; thể thấy, yếu tố quan trọng nhất của chế độ chụp đ&ecirc;m đ&oacute; l&agrave; l&agrave;m s&aacute;ng khung h&igrave;nh, v&agrave; Vivo V19 Neo đ&atilde; l&agrave;m được. H&atilde;y nh&igrave;n xem, cả khung cảnh tối đen như mực thế kia m&agrave; vẫn được phơi s&aacute;ng một c&aacute;ch nhẹ nh&agrave;ng, gi&uacute;p bạn nh&igrave;n thấy những chi tiết bị mất một c&aacute;ch r&otilde; r&agrave;ng.</p>\r\n\r\n<p><img alt=\"So sánh 2\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d5_1280x846.jpg\" title=\"So sánh 2\" /></p>\r\n\r\n<p>Ảnh chụp ở chế độ tự động (b&ecirc;n tr&aacute;i) v&agrave; ảnh chụp bằng chế độ chụp đ&ecirc;m (b&ecirc;n phải).</p>\r\n\r\n<p>Kh&ocirc;ng chỉ vậy, chế độ chụp đ&ecirc;m c&ograve;n tối ưu bối cảnh gi&uacute;p ảnh kh&ocirc;ng bị bệt v&agrave; nh&ograve;e. Ở bức ảnh chụp tự động b&ecirc;n tr&aacute;i bạn sẽ thấy c&aacute;c &ocirc; cửa sổ bị bệt, trong khi ảnh chụp bằng chế độ chụp đ&ecirc;m mang đến sự tươi s&aacute;ng, rạng rỡ v&agrave; sắc n&eacute;t.</p>\r\n\r\n<p><img alt=\"So sánh 3\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d6_1280x845.jpg\" title=\"So sánh 3\" /></p>\r\n\r\n<p>Ảnh chụp ở chế độ tự động (b&ecirc;n tr&aacute;i) v&agrave; ảnh chụp bằng chế độ chụp đ&ecirc;m (b&ecirc;n phải).</p>\r\n\r\n<p>Tuy nhi&ecirc;n, kh&ocirc;ng phải l&uacute;c n&agrave;o ch&uacute;ng ta cũng chụp bằng chế độ chụp đ&ecirc;m. Ở một số ho&agrave;n cảnh đặc biệt bạn vẫn n&ecirc;n ưu ti&ecirc;n chế độ chụp tự động, nếu ảnh bị nh&ograve;e th&igrave; mới d&ugrave;ng đến chế độ chụp đ&ecirc;m nh&eacute;.</p>\r\n\r\n<p>Ảnh chụp đ&ecirc;m đ&atilde; đẹp, nhưng bạn n&agrave;o biết ảnh chụp ở điều kiện đủ s&aacute;ng cũng đẹp kh&ocirc;ng k&eacute;m g&igrave; chất ảnh từ người anh&nbsp;<a href=\"https://www.thegioididong.com/dtdd/vivo-v19\" target=\"_blank\" title=\"Vivo V19\" type=\"Vivo V19\">Vivo V19</a>. Kh&ocirc;ng chỉ t&aacute;i tạo m&agrave;u sắc th&ecirc;m phần đậm đ&agrave; m&agrave; Vivo V19 Neo c&ograve;n mang đến độ chi tiết cao, khiến m&igrave;nh ưng &yacute; ngay khi nh&igrave;n v&agrave;o bức ảnh.</p>\r\n\r\n<p><img alt=\"ảnh đủ sáng\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d8_960x1279.jpg\" title=\"ảnh đủ sáng\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện đủ s&aacute;ng bằng chế độ tự động.</p>\r\n\r\n<p>Ở bức ảnh chụp ngược s&aacute;ng, Vivo V19 Neo tỏ ra kh&aacute; vụng về trong việc lấy n&eacute;t. M&igrave;nh c&oacute; chạm lấy n&eacute;t v&agrave;o mặt trời v&agrave; giảm thanh EV với mong muốn nhận được một bức ảnh chill, nhưng m&aacute;y lại kh&ocirc;ng lấy n&eacute;t được cơ chứ.</p>\r\n\r\n<p><img alt=\"ảnh ngược sáng\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d9_960x1280.jpg\" title=\"ảnh ngược sáng\" /></p>\r\n\r\n<p>Ảnh chụp ở điều kiện ngược s&aacute;ng bằng chế độ tự động.</p>\r\n\r\n<p>M&igrave;nh cũng kh&ocirc;ng qu&ecirc;n test cả khả năng chụp ảnh ch&acirc;n dung tr&ecirc;n Vivo V19 Neo. Th&iacute;ch th&uacute; l&agrave;m sao khi phần t&oacute;c rối &iacute;t ỏi của c&ocirc; g&aacute;i kh&ocirc;ng hề bị x&oacute;a mất m&agrave; vẫn được giữ một c&aacute;ch tự nhi&ecirc;n, khiến ảnh th&ecirc;m h&agrave;i h&ograve;a v&agrave; ưu nh&igrave;n. Da của chủ thể được l&agrave;m mịn nhẹ nh&agrave;ng v&agrave; kh&ocirc;ng hề ảo l&ograve;i ch&uacute;t n&agrave;o.</p>\r\n\r\n<p><img alt=\"ảnh chụp chân dung\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d11_1280x960.jpg\" title=\"ảnh chụp chân dung\" /></p>\r\n\r\n<p>Ảnh chụp bằng chế độ chụp ch&acirc;n dung tr&ecirc;n Vivo V19 Neo.</p>\r\n\r\n<p>Cắt giảm camera selfie từ 2 xuống c&ograve;n 1 n&ecirc;n hẳn nhiều bạn sẽ th&ecirc;m phần lo lắng v&igrave; kh&ocirc;ng liệu chất lượng c&oacute; giảm hay kh&ocirc;ng. M&igrave;nh đ&atilde; c&oacute; test thử lu&ocirc;n n&egrave; v&agrave; thấy da được l&agrave;m mịn rất chỉnh chu v&agrave; t&ocirc;ng m&agrave;u khung h&igrave;nh kh&ocirc;ng hề nhợt nhạt.</p>\r\n\r\n<p><img alt=\"Selfie\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/d10_960x1280.jpg\" title=\"Selfie\" /></p>\r\n\r\n<p>Ảnh chụp bằng camera selfie tr&ecirc;n Vivo V19 Neo.</p>\r\n\r\n<h3>2. Đ&aacute;nh mạnh camera, cũng kh&ocirc;ng qu&ecirc;n n&acirc;ng cấp hiệu năng mượt m&agrave;</h3>\r\n\r\n<p>Như thường lệ, trước khi bước v&agrave;o đ&aacute;nh gi&aacute; hiệu năng của Vivo V19 Neo m&igrave;nh xin ph&eacute;p điểm nhanh về cấu h&igrave;nh phần cứng một ch&uacute;t:</p>\r\n\r\n<ul>\r\n	<li>CPU: Snapdragon 675 8 nh&acirc;n.</li>\r\n	<li>GPU:&nbsp;Adreno 612.</li>\r\n	<li>RAM: 8 GB.</li>\r\n	<li>Bộ nhớ trong: 128 GB.</li>\r\n	<li>HĐH: Android 10.</li>\r\n</ul>\r\n\r\n<p><img alt=\"Thông số chip Snapdragon 675\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/cauhinh_1280x720-800-resize.jpg\" title=\"Thông số chip Snapdragon 675\" /></p>\r\n\r\n<p>Vivo V19 Neo sở hữu chip Snapdragon 675 mang đến hiệu năng mượt m&agrave; trong ph&acirc;n kh&uacute;c tầm trung.</p>\r\n\r\n<p>So với Vivo V19, phi&ecirc;n bản Vivo V19 Neo đ&atilde; bị cắt giảm chip xử l&yacute; từ Snapdragon 712 xuống Snapdragon 675. Thật ra m&igrave;nh đ&atilde; đ&aacute;nh gi&aacute; rất nhiều sản phẩm d&ugrave;ng Snapdragon 675 rồi v&agrave; thấy rằng, đ&acirc;y l&agrave; một con chip cho khả năng xử l&yacute; rất tốt trong ph&acirc;n ph&uacute;c tầm trung. Thực tế trải nghiệm tế n&agrave;o?</p>\r\n\r\n<p>M&igrave;nh đ&atilde; test cả ba tựa game đang rất hot hiện nay gồm: Li&ecirc;n Qu&acirc;n Mobile, PUBG Mobile v&agrave; Call Of Duty. M&igrave;nh đ&atilde; trải nghiệm tựa game Li&ecirc;n Qu&acirc;n trước với cấu h&igrave;nh được đề xuất ở mức trung b&igrave;nh (FPS tối đa l&agrave; 30). Tuy nhi&ecirc;n m&igrave;nh khuy&ecirc;n c&aacute;c bạn n&ecirc;n bật FPS cao (tối đa l&agrave; 60) v&agrave; trải nghiệm độ mượt của Snapdragon 675.</p>\r\n\r\n<p><img alt=\"Liên Quân Mobile\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/gg1_600x270.gif\" title=\"Liên Quân Mobile\" /></p>\r\n\r\n<p>Với Li&ecirc;n Qu&acirc;n Mobile, FPS dao động từ 58-61 FPS.</p>\r\n\r\n<p>FPS dao động ổn định trong tầm từ 58-61 FPS, tuy nhi&ecirc;n ở những pha combat tổng th&igrave; mức FPS c&oacute; thể sụt giảm xuống mức 51 FPS. Bản th&acirc;n m&igrave;nh thấy m&aacute;y c&oacute; hơi giật một t&iacute;, nhưng vấn đề n&agrave;y rất &iacute;t khi xảy ra v&agrave; chỉ xuất hiện khi bạn chơi tướng cơ động.</p>\r\n\r\n<p>Chuyển sang tựa game thứ hai l&agrave; PUBG Mobile, đồ họa được đề xuất l&agrave; HD v&agrave; tốc độ khung h&igrave;nh Cao. Đ&acirc;y cũng l&agrave; cấu h&igrave;nh cao nhất bạn thể setup trong PUBG v&agrave; y&ecirc;n t&acirc;m nh&eacute;, Snapdragon 675 vẫn cho độ ổn định v&agrave; gi&uacute;p m&igrave;nh dễ d&agrave;ng nả đạn li&ecirc;n thanh.</p>\r\n\r\n<p><img alt=\"PUBG Mobile\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/gg2_600x270.gif\" title=\"PUBG Mobile\" /></p>\r\n\r\n<p>Với PUBG Mobile, m&aacute;y cho ph&eacute;p m&igrave;nh bật đồ họa Cao v&agrave; tốc độ khung h&igrave;nh cao.</p>\r\n\r\n<p>M&igrave;nh c&ograve;n trải nghiệm th&ecirc;m một tựa game FPS mang t&ecirc;n Call Of Duty Mobile. Từ l&uacute;c ch&iacute;nh thức c&oacute; mặt tr&ecirc;n mobile đến nay, m&igrave;nh đ&atilde; kh&ocirc;ng ngừng trải nghiệm v&agrave; đ&aacute;nh gi&aacute; CODM qua c&aacute;c b&agrave;i viết trước đ&oacute;. Với Vivo V19 Neo, bạn ho&agrave;n to&agrave;n c&oacute; thể tự tin đi r&igrave;nh đối thủ v&agrave; xử đẹp trong 1 nốt nhạc.</p>\r\n\r\n<p><img alt=\"Call Of Duty\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/gg3_600x270.gif\" title=\"Call Of Duty\" /></p>\r\n\r\n<p>Ở tựa game Call Of Duty, bạn cứ tự tin mở đồ họa rất cao v&agrave; tốc độ khung h&igrave;nh rất cao để trải nghiệm.</p>\r\n\r\n<p>Vivo V19 Neo cho ph&eacute;p bạn mở đồ họa Rất cao v&agrave; tốc độ khung h&igrave;nh Rất cao, thế th&igrave; ngại g&igrave; m&agrave; kh&ocirc;ng mở l&ecirc;n tối đa để trải nghiệm độ mượt m&agrave; của Snapdragon 675 mang lại. Trong thời gian tới, team m&igrave;nh sẽ c&oacute; b&agrave;i so s&aacute;nh giữa hai tựa game Call Of Duty v&agrave; PUBG Mobile, c&aacute;c bạn đ&oacute;n chờ nh&eacute;.</p>\r\n\r\n<p>Ngo&agrave;i việc đ&aacute;nh gi&aacute; hiệu năng qua trải nghiệm thực tế, m&igrave;nh c&ograve;n sử dụng th&ecirc;m một số phần mềm chấm điểm quen thuộc. Hai phần mềm m&igrave;nh lựa chọn bao gồm: 3DMark v&agrave; GeekBench 5.</p>\r\n\r\n<p><img alt=\"3DMark\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/c3_960x1057-800-resize.jpg\" title=\"3DMark\" /></p>\r\n\r\n<p>Đo hiệu năng v&agrave; đồ họa của VivoV19 Neo bằng phần mềm 3DMark.</p>\r\n\r\n<p><img alt=\"GeekBench 5\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/c1_960x1046-800-resize.jpg\" title=\"GeekBench 5\" />Đo hiệu năng của Vivo V19 Neo bằng phần mềm GeekBench 5.</p>\r\n\r\n<h3>3. Thiết kế s&aacute;ng lo&aacute;ng v&agrave; tinh tế</h3>\r\n\r\n<p>Như ở đầu b&agrave;i viết m&igrave;nh cũng đ&atilde; c&oacute; n&oacute;i, c&aacute;ch đ&acirc;y 2 tuần trước m&igrave;nh c&oacute; đ&aacute;nh gi&aacute; chiếc Vivo V19 v&agrave; theo m&igrave;nh ấy, đ&acirc;y l&agrave; một sản phẩm c&oacute; thiết đẹp v&agrave; đầy sang trọng. So với người anh Vivo V19, chiếc Vivo V19 Neo n&agrave;y cũng kh&ocirc;ng c&oacute; nhiều sự kh&aacute;c biệt khi vẫn được gia c&ocirc;ng bằng chất liệu nhựa nhẹ nh&agrave;ng.</p>\r\n\r\n<p><img alt=\"bộ đôi Vivo V19 Neo\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/vivov19neo-38_1280x720.jpg\" title=\"bộ đôi Vivo V19 Neo\" /></p>\r\n\r\n<p>Vivo V19 Neo c&oacute; tổng cộng hai phi&ecirc;n bản gồm m&agrave;u Đen v&agrave; m&agrave;u Xanh dương.</p>\r\n\r\n<p>Nhựa th&igrave; rẻ tiền hơn kim loại, nhưng chất liệu n&agrave;y cũng mang đến nhiều ưu điểm chẳng hạn như gi&uacute;p việc cầm nắm sản phẩm tr&ecirc;n tay dễ chịu hơn n&egrave;. Nhờ đ&oacute; m&agrave; bạn c&oacute; thể dễ d&agrave;ng mang Vivo V19 Neo đi chơi, bỏ v&ocirc; t&uacute;i quần thuận tiện v&agrave; trải nghiệm cầm nắm kh&ocirc;ng nặng tay. Vivo c&ograve;n tinh tế hơn khi l&agrave;m b&oacute;ng mặt lưng gi&uacute;p m&aacute;y l&aacute;p l&aacute;nh dưới &aacute;nh s&aacute;ng trực tiếp, nhưng bạn n&ecirc;n lau ch&ugrave;i thường xuy&ecirc;n v&igrave; bề mặt rất dễ b&aacute;m v&acirc;n tay.</p>\r\n\r\n<p><img alt=\"mặt lưng màu đen\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/vivov19neo-5_1280x720.jpg\" title=\"mặt lưng màu đen\" /></p>\r\n\r\n<p>Vivo c&ograve;n tinh tế hơn khi l&agrave;m b&oacute;ng mặt lưng gi&uacute;p m&aacute;y l&aacute;p l&aacute;nh dưới &aacute;nh s&aacute;ng trực tiếp.</p>\r\n\r\n<p>Kho&aacute;c l&ecirc;n m&igrave;nh bộ &aacute;o m&agrave;u đen huyền ảo, Vivo V19 Neo giống như một v&ugrave;ng kh&ocirc;ng gian v&ocirc; tận v&agrave; g&acirc;y ấn tượng với người d&ugrave;ng. Nhưng điểm g&acirc;y thu h&uacute;t với m&igrave;nh lại ch&iacute;nh l&agrave; cụm camera sau cơ. Thiết kế camera kh&ocirc;ng c&oacute; nhiều thay đổi, phải chăng l&agrave; sự thay đổi vị tr&iacute; đ&egrave;n LED b&ecirc;n trong v&agrave; cụm camera kh&ocirc;ng nằm s&aacute;t g&oacute;c tr&ecirc;n m&agrave; lệch v&agrave;o trong một t&iacute;.</p>\r\n\r\n<p><img alt=\"Camera sau Vivo V19 Neo\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/vivov19neo-4_1280x720.jpg\" title=\"Camera sau Vivo V19 Neo\" /></p>\r\n\r\n<p>Kho&aacute;c l&ecirc;n m&igrave;nh bộ &aacute;o m&agrave;u đen huyền ảo, Vivo V19 Neo giống như một v&ugrave;ng kh&ocirc;ng gian v&ocirc; tận.</p>\r\n\r\n<p>Vivo V19 Neo l&agrave; r&uacute;t gọn của Vivo V19 n&ecirc;n hiển nhi&ecirc;n một số yếu tố tr&ecirc;n người anh V19 sẽ bị cắt giảm, chẳng hạn như camera selfie. Vivo V19 Neo giờ đ&acirc;y chỉ c&ograve;n một camera selfie nằm trong lỗ đục ở g&oacute;c tr&ecirc;n b&ecirc;n phải của m&agrave;n h&igrave;nh nhưng k&iacute;ch thước tấm nền vẫn được giữ nguy&ecirc;n l&agrave; 6.44 inch.</p>\r\n\r\n<p><img alt=\"màn hình V19 Neo\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/vivov19neo-20_1280x720.jpg\" title=\"màn hình V19 Neo\" /></p>\r\n\r\n<p>Vivo V19 Neo giờ đ&acirc;y chỉ c&ograve;n một camera selfie nằm trong lỗ đục ở g&oacute;c tr&ecirc;n b&ecirc;n phải.</p>\r\n\r\n<p>Cắt giảm camera trước th&igrave; c&oacute;, nhưng Vivo hiểu tầm quan trọng của m&agrave;n h&igrave;nh n&ecirc;n kh&ocirc;ng cắt giảm đi độ ph&acirc;n giải (vẫn l&agrave; Full HD+) v&agrave; c&ocirc;ng nghệ tấm nền (Super AMOLED). Nhờ đ&oacute; m&agrave; khả năng hiển thị m&agrave;u sắc của Vivo V19 Neo vẫn rất tốt, độ tương phản cao v&agrave; chi tiết vẫn r&otilde; r&agrave;ng.</p>\r\n\r\n<p>Bản th&acirc;n m&igrave;nh sau một tuần trải nghiệm Vivo V19 Neo th&igrave; thấy rằng chiếc m&aacute;y cho khả năng hiển thị thật sự rất tốt. Trong tầm gi&aacute; n&agrave;y rất kh&oacute; để bạn t&igrave;m được một chiếc smartphone cho m&agrave;n h&igrave;nh đẹp như Vivo V19 Neo nhờ c&ocirc;ng nghệ Super AMOLED. Một sản phẩm tầm trung đ&aacute;ng trải nghiệm, l&agrave;m việc v&agrave; giải tr&iacute; thỏa th&iacute;ch.</p>\r\n\r\n<p><img alt=\"màn hình Vivo V19 Neo\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/vivov19neo-25-copy_1280x720.jpg\" title=\"màn hình Vivo V19 Neo\" /></p>\r\n\r\n<p>Vivo V19 Neo sở hữu m&agrave;n h&igrave;nh 6.44 inch, độ ph&acirc;n giải Full HD+ với tấm nền Super AMOLED.</p>\r\n\r\n<h3>4. Nhắc đến Vivo th&igrave; khỏi sợ pin yếu bạn ơi!</h3>\r\n\r\n<p>Cuối c&ugrave;ng, m&igrave;nh sẽ đ&aacute;nh gi&aacute; thời lượng pin của chiếc Vivo V19 Neo. Nh&igrave;n qua người anh Vivo V19, m&igrave;nh thấy cả hai phi&ecirc;n bản n&agrave;y đều c&oacute; c&ugrave;ng dung lượng pin l&agrave; 4.500 mAh. C&oacute; thể nhiều bạn cho rằng hai chiếc m&aacute;y chắc sẽ cho thời lượng sử dụng như nhau, nhưng điều n&agrave;y vẫn chưa được x&aacute;c thực v&igrave; hai chiếc m&aacute;y x&agrave;i chip xử l&yacute; kh&aacute;c nhau.</p>\r\n\r\n<p>Để c&aacute;c bạn c&oacute; một c&aacute;i nh&igrave;n kh&aacute;ch quan nhất th&igrave; m&igrave;nh đ&atilde; bỏ ra cả ng&agrave;y trời để ngồi test pin của Vivo V19 Neo qua trải nghiệm thực tế, với điều kiện như sau:</p>\r\n\r\n<ul>\r\n	<li>Trải nghiệm 4 t&aacute;c vụ xoay v&ograve;ng gồm: Chiến Li&ecirc;n Qu&acirc;n, xem YouTube, lướt Facebook v&agrave; d&ugrave;ng tr&igrave;nh duyệt (Chrome).</li>\r\n	<li>Mỗi t&aacute;c vụ 1 tiếng đồng hồ.</li>\r\n	<li>Đ&egrave;n nền 100%.</li>\r\n	<li>Cắm tai nghe c&oacute; d&acirc;y xuy&ecirc;n suốt.</li>\r\n	<li>Kh&ocirc;ng bật chế độ tiết kiệm pin hay m&agrave;n h&igrave;nh th&iacute;ch ứng.</li>\r\n	<li>Bật chế độ hiệu suất cao.</li>\r\n	<li>Mở WiFi v&agrave; c&aacute;c th&ocirc;ng b&aacute;o từ mạng x&atilde; hội.</li>\r\n	<li>Kh&ocirc;ng bật GPS, Bluetooth v&agrave; NFC.</li>\r\n	<li>Đo từ 100% đến 0%.</li>\r\n</ul>\r\n\r\n<p><img alt=\"thời lượng pin\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/thoiluongpin_800x462.jpg\" title=\"thời lượng pin\" /></p>\r\n\r\n<p>Đo thời lượng pin của Vivo V19 Neo bằng trải nghiệm thực tế.</p>\r\n\r\n<p>Với thời lượng đạt gần 10 tiếng sử dụng li&ecirc;n tục, m&igrave;nh đảm bảo rằng nếu bạn hạn chế cầm điện thoại hoặc chỉ d&ugrave;ng để nghe gọi th&igrave; Vivo V19 Neo c&oacute; thể hoạt động đến hết 2 ng&agrave;y. Ngo&agrave;i việc đo pin th&igrave; m&igrave;nh c&ograve;n đo cả củ sạc trong hộp đựng. Nhờ được t&iacute;ch hợp c&ocirc;ng nghệ sạc k&eacute;p n&ecirc;n chưa đầy 2 tiếng th&igrave; m&aacute;y đ&atilde; đầy pin.</p>\r\n\r\n<p><img alt=\"tốc độ sạc\" src=\"https://cdn.tgdd.vn/Files/2020/05/28/1258953/sacpin3_600x470.jpg\" title=\"tốc độ sạc\" /></p>\r\n\r\n<p>Đo tốc độ sạc của củ sạc trong hộp đựng.</p>\r\n\r\n<h3>Tổng kết</h3>\r\n\r\n<p>V&agrave; đ&oacute; l&agrave; tất cả trải nghiệm của m&igrave;nh về chiếc Vivo V19 Neo. Mặc d&ugrave; ban đầu m&igrave;nh c&oacute; một ch&uacute;t lo lắng khi trải nghiệm Vivo V19 Neo, khi m&agrave; chiếc m&aacute;y chỉ l&agrave; phi&ecirc;n bản được cắt giảm của Vivo V19. Thế nhưng những sự cắt giảm n&agrave;y chẳng đ&aacute;ng kể l&agrave; bao, khi chất ảnh vẫn đẹp, hiệu năng vẫn ngon m&agrave; gi&aacute; lại rẻ.</p>\r\n\r\n<p>Coi bộ m&oacute;n qu&agrave; n&agrave;y từ Vivo lại đ&aacute;ng tiền thế nhờ. Kh&ocirc;ng biết c&aacute;c bạn nghĩ sao về Vivo V19 Neo n&egrave;? H&atilde;y để lại b&igrave;nh luận b&ecirc;n dưới v&agrave; cho m&igrave;nh biết với nh&eacute;. C&aacute;m ơn c&aacute;c bạn đ&atilde; xem hết b&agrave;i viết của ch&uacute;ng m&igrave;nh.</p>', 0, 1, 9, 26, '2020-11-28 09:17:47'),
(9, 'live', 'Cận cảnh iPhone 11 Pro Max màu Green Mid Night: Chỉ 1 chữ \'Đẹp\'!', 'b8a1ac3f97dc27602d95d7d6824c151cd7e236c0.jpg', 'Chắc bạn c&oacute; xem seri phim Qu&aacute; nhanh qu&aacute; nguy hiểm (c&ograve;n chưa xem th&igrave; Google)? V&acirc;ng, tốc độ tr&ecirc;n tay iPhone 2019 của người d&ugrave;ng Việt cũng nhanh kh&ocirc;ng k&eacute;m. Mới đ&acirc;y, t&agrave;i khoản Facebook Nguyễn Quang Th&aacute;i đ&atilde; chia sẻ loạt ảnh tr&ecirc;n tay iPhone 11 Pro Max m&agrave;u Green Mid Night.', '<p><img alt=\"Cận cảnh iPhone 11 Pro Max màu Green Mid Night, chắc sắp trở thành color trends\" src=\"https://cdn.tgdd.vn/Files/2019/09/20/1199930/iphone-11-pro-max-green-mid-night_800x450.jpg\" title=\"Cận cảnh iPhone 11 Pro Max màu Green Mid Night, chắc sắp trở thành color trends\" /></p>\r\n\r\n<h2>Chắc bạn c&oacute; xem seri phim Qu&aacute; nhanh qu&aacute; nguy hiểm (c&ograve;n chưa xem th&igrave; Google)? V&acirc;ng, tốc độ tr&ecirc;n tay&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11\" target=\"_blank\" title=\"Đặt mua iPhone 11 tại Thegioididong.com\" type=\"Đặt mua iPhone 11 tại Thegioididong.com\">iPhone 2019</a>&nbsp;của người d&ugrave;ng Việt cũng nhanh kh&ocirc;ng k&eacute;m. Mới đ&acirc;y, t&agrave;i khoản&nbsp;<a href=\"https://www.facebook.com/100000454856937/posts/3279220845436378\" rel=\"nofollow\" target=\"_blank\" title=\"Facebooker Nguyễn Quang Thái\" type=\"Facebooker Nguyễn Quang Thái\">Facebook&nbsp;Nguyễn Quang Th&aacute;i</a>&nbsp;đ&atilde; chia sẻ loạt ảnh tr&ecirc;n tay&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro-max\" target=\"_blank\" title=\"Đặt mua iPhone 11 Pro Max tại Thegioididong.com\" type=\"Đặt mua iPhone 11 Pro Max tại Thegioididong.com\">iPhone 11 Pro Max</a>&nbsp;m&agrave;u Green Mid Night.</h2>\r\n\r\n<p>Theo chia sẻ của&nbsp;Facebooker Nguyễn Quang Th&aacute;i:&nbsp;&quot;iPhone 11 Pro Max Green Mid Night&nbsp;l&agrave; m&agrave;u mới v&agrave; lạ nhất năm nay, c&oacute; đẹp hay kh&ocirc;ng th&igrave; c&ograve;n tuỳ người, anh em xem h&igrave;nh tự nhận định nghen. C&oacute; lẽ m&igrave;nh sẽ x&agrave;i phi&ecirc;n bản n&agrave;y lu&ocirc;n.&quot;</p>\r\n\r\n<p>&quot;Lưng nh&aacute;m, n&oacute;i nh&aacute;m kh&ocirc;ng c&oacute; nghĩa l&agrave; n&oacute; sần s&ugrave;i, chỉ l&agrave; kh&ocirc;ng b&oacute;ng m&agrave; th&ocirc;i. V&igrave; kh&ocirc;ng b&oacute;ng n&ecirc;n sẽ kh&ocirc;ng b&aacute;m v&acirc;n tay như c&aacute;c thế hệ&nbsp;<a href=\"https://www.thegioididong.com/dtdd-apple-iphone\" target=\"_blank\" title=\"Đặt mua iPhone tại Thegioididong.com\" type=\"Đặt mua iPhone tại Thegioididong.com\">iPhone</a>&nbsp;trước d&ugrave;ng mặt k&iacute;nh truyền thống. C&ograve;n&nbsp;về trọng lượng th&igrave; iPhone 11 Pro Max sẽ nặng hơn&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-xs-max\" target=\"_blank\" title=\"Đặt mua iPhone Xs Max tại Thegioididong.com\" type=\"Đặt mua iPhone Xs Max tại Thegioididong.com\">iPhone Xs Max</a>&nbsp;một x&iacute;u nữa. Trước m&igrave;nh d&ugrave;ng iPhone Xs Max cũng thấy kh&aacute; nặng rồi nhưng v&igrave; m&agrave;n h&igrave;nh to m&igrave;nh sẽ hy sinh,&quot;&nbsp;Facebooker Nguyễn Quang Th&aacute;i đưa ra nhận x&eacute;t.</p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<ul>\r\n	<li><a href=\"javascript:void(0)\" rel=\"gallerynews1\"><img src=\"https://cdn.tgdd.vn/Files/2019/09/20/1199930/Gallery/15.jpg\" /></a></li>\r\n	<li><a href=\"javascript:void(0)\" rel=\"gallerynews1\"><img src=\"https://cdn.tgdd.vn/Files/2019/09/20/1199930/Gallery/14-120x120.jpg\" /></a></li>\r\n	<li><a href=\"javascript:void(0)\" rel=\"gallerynews1\"><img src=\"https://cdn.tgdd.vn/Files/2019/09/20/1199930/Gallery/13-120x120.jpg\" /></a></li>\r\n	<li><a href=\"javascript:void(0)\" rel=\"gallerynews1\"><img src=\"https://cdn.tgdd.vn/Files/2019/09/20/1199930/Gallery/12-120x120.jpg\" /></a>\r\n	<p><a href=\"javascript:void(0)\" rel=\"gallerynews1\">+11</a></p>\r\n	</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p>C&oacute; thể n&oacute;i camera v&agrave; pin l&agrave; hai chi tiết được cải tiến đ&aacute;ng kể tr&ecirc;n iPhone 11 Pro Max. Trang&nbsp;<a href=\"https://www.theverge.com/2019/9/17/20868727/apple-iphone-11-pro-max-review-camera-battery-life-screen-midnight-green-price\" rel=\"nofollow\" target=\"_blank\" title=\"APPLE IPHONE 11 PRO AND PRO MAX REVIEW: THE BATTERY LIFE IS REAL\" type=\"APPLE IPHONE 11 PRO AND PRO MAX REVIEW: THE BATTERY LIFE IS REAL\">The Verge</a>&nbsp;đ&aacute;nh gi&aacute; khả năng chụp ảnh của iPhone 11 Pro Max tốt hơn&nbsp;<a href=\"https://www.thegioididong.com/dtdd/google-pixel-3\" target=\"_blank\" title=\"Chi tiết Google Pixel 3\" type=\"Chi tiết Google Pixel 3\">Google Pixel 3&nbsp;</a>v&agrave; cả&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-note-10-plus\" target=\"_blank\" title=\"Đặt mua Samsung Galaxy Note 10+ tại Thegioididong.com\" type=\"Đặt mua Samsung Galaxy Note 10+ tại Thegioididong.com\">Samsung Galaxy Note 10+</a>.</p>\r\n\r\n<p>Tr&ecirc;n thế hệ iPhone 11, Apple đ&atilde; hy sinh độ mỏng, nhẹ của m&aacute;y để t&iacute;ch hợp pin c&oacute; dung lượng lớn hơn. Kết quả l&agrave; cả 2 phi&ecirc;n bản&nbsp;<a href=\"https://www.thegioididong.com/dtdd/iphone-11-pro\" target=\"_blank\" title=\"Đặt mua iPhone 11 Pro tại Thegioididong.com\" type=\"Đặt mua iPhone 11 Pro tại Thegioididong.com\">iPhone 11 Pro</a>&nbsp;v&agrave; iPhone 11 Pro Max đều cải thiện đ&aacute;ng kể thời lượng d&ugrave;ng pin.</p>\r\n\r\n<p>Bạn nhận x&eacute;t thế n&agrave;o về thiết kế cũng như phi&ecirc;n bản m&agrave;u&nbsp;Green Mid Night của iPhone 11 Pro Max, v&agrave; liệu c&oacute; trở th&agrave;nh &quot;color trends&quot; (xu hướng m&agrave;u mới) trong thời gian tới?</p>', 0, 1, 1, 6, '2020-10-31 07:56:03'),
(10, 'live', 'Samsung phát hành bản cập nhật mới cho Galaxy Note 10 và Note 10+, cải thiện tính năng nhận dạng khuôn mặt và các cử chỉ điều hướng', 'c354aaa870a5df6ed08cf979b99fa59de155380e.jpg', 'Bản cập nhật c&oacute; t&ecirc;n m&atilde; l&agrave; N97xFXXU2BTB5, hầu như kh&ocirc;ng c&oacute; t&iacute;nh năng g&igrave; mới m&agrave; chỉ chủ yếu tập trung v&agrave;o việc cải tiến t&iacute;nh năng nhận dạng mở kho&aacute; bằng khu&ocirc;n mặt v&agrave; cử chỉ điều hướng to&agrave;n m&agrave;n h&igrave;nh, nhưng kh&aacute; lạ khi n&oacute; lại kh&ocirc;ng đi k&egrave;m bản v&aacute; bảo mật th&aacute;ng 3/2020 của Google.', '<p><img alt=\"Samsung phát hành bản cập nhật mới cho Galaxy Note 10 và Note 10+\" src=\"https://cdn.tgdd.vn/Files/2020/02/28/1239093/n102_800x450.jpg\" title=\"Samsung phát hành bản cập nhật mới cho Galaxy Note 10 và Note 10+\" /></p>\r\n\r\n<p>H&igrave;nh minh họa</p>\r\n\r\n<h2><a href=\"https://www.thegioididong.com/dtdd-samsung\" target=\"_blank\" title=\"Samsung\" type=\"Samsung\">Samsung</a>&nbsp;mới đ&acirc;y vừa ph&aacute;t h&agrave;nh bản cập nhật nhật mềm mới cho bộ đ&ocirc;i&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-note-10\" target=\"_blank\" title=\"Galaxy Note 10\" type=\"Galaxy Note 10\">Galaxy Note 10</a>&nbsp;v&agrave;&nbsp;<a href=\"https://www.thegioididong.com/dtdd/samsung-galaxy-note-10-plus\" target=\"_blank\" title=\"Galaxy Note 10+\" type=\"Galaxy Note 10+\">Note 10+</a>&nbsp;sau hơn 2 th&aacute;ng tung ra bản cập nhật Android 10.</h2>\r\n\r\n<p>Bản cập nhật c&oacute; t&ecirc;n m&atilde; l&agrave; N97xFXXU2BTB5, hầu như kh&ocirc;ng c&oacute; t&iacute;nh năng g&igrave; mới m&agrave; chỉ chủ yếu tập trung v&agrave;o việc cải tiến t&iacute;nh năng nhận dạng mở kho&aacute; bằng khu&ocirc;n mặt v&agrave; cử chỉ điều hướng to&agrave;n m&agrave;n h&igrave;nh, nhưng kh&aacute; lạ khi n&oacute; lại kh&ocirc;ng đi k&egrave;m bản v&aacute; bảo mật th&aacute;ng 3/2020 của Google.</p>\r\n\r\n<p><img alt=\"Samsung phát hành bản cập nhật mới cho Galaxy Note 10 và Note 10+\" src=\"https://cdn.tgdd.vn/Files/2020/02/28/1239093/n101_600x534.jpg\" title=\"Samsung phát hành bản cập nhật mới cho Galaxy Note 10 và Note 10+\" /></p>\r\n\r\n<p>Hiện tại, bản cập nhật phần mềm mới của Galaxy Note 10 series đ&atilde; c&oacute; sẵn để tải về cho người d&ugrave;ng tại Đức v&agrave; Malaysia. Như thường lệ, Samsung sẽ sớm ph&aacute;t h&agrave;nh bản cập nhật cho người d&ugrave;ng ở c&aacute;c quốc gia kh&aacute;c trong v&agrave;i tuần với v&agrave; khả năng cao sẽ đi k&egrave;m với bản v&aacute;n bảo mật th&aacute;ng 3/2020.</p>\r\n\r\n<p>Để kiểm tra cập nhật, mời bạn truy cập v&agrave;o&nbsp;C&agrave;i đặt &gt; Cập nhật phần mềm&nbsp;sau đố tiến h&agrave;nh&nbsp;Tải về v&agrave; c&agrave;i đặt. Nếu chưa c&oacute; cập nhật th&igrave; bạn r&aacute;ng đợi th&ecirc;m một thời gian nữa nh&eacute;.</p>\r\n\r\n<p>C&aacute;c bạn d&ugrave;ng Galaxy Note 10/Note10+ đ&atilde; nhận được bản cập nhật mới chưa?</p>', 0, 1, 15, 29, '2020-10-31 12:49:37');

-- --------------------------------------------------------

--
-- Table structure for table `product_attribute`
--

CREATE TABLE `product_attribute` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `attribute_value_id` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `product_attribute`
--

INSERT INTO `product_attribute` (`product_id`, `attribute_value_id`) VALUES
(1, 2),
(1, 3),
(1, 7),
(1, 8),
(1, 11),
(1, 14),
(2, 2),
(2, 3),
(2, 4),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(3, 3),
(3, 7),
(3, 8),
(3, 11),
(3, 12),
(3, 14),
(4, 2),
(4, 3),
(4, 7),
(4, 9),
(4, 12),
(4, 13),
(4, 14),
(5, 2),
(5, 3),
(5, 7),
(5, 8),
(5, 11),
(5, 12),
(5, 13),
(6, 2),
(6, 3),
(6, 4),
(6, 8),
(6, 9),
(6, 10),
(6, 11),
(6, 12),
(6, 13),
(6, 14),
(7, 3),
(7, 9),
(7, 11),
(7, 12),
(8, 1),
(8, 2),
(8, 7),
(8, 8),
(8, 11),
(9, 2),
(9, 3),
(9, 7),
(9, 8),
(9, 15),
(10, 7),
(10, 14),
(10, 16),
(11, 4),
(11, 7),
(11, 12),
(11, 14),
(13, 2),
(13, 3),
(13, 6),
(13, 7),
(13, 11),
(14, 3),
(14, 6),
(14, 7),
(14, 11),
(15, 4),
(15, 10),
(15, 14),
(15, 15),
(16, 3),
(16, 4),
(16, 6),
(16, 7),
(16, 11),
(16, 15),
(17, 3),
(17, 8),
(17, 13),
(17, 14),
(18, 3),
(18, 7),
(18, 11),
(18, 15),
(19, 4),
(19, 8),
(19, 9),
(19, 14),
(19, 15);

-- --------------------------------------------------------

--
-- Table structure for table `product_stock_notification`
--

CREATE TABLE `product_stock_notification` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `product_id` int(11) NOT NULL,
  `processed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `product_stock_notification`
--

INSERT INTO `product_stock_notification` (`id`, `name`, `email`, `product_id`, `processed`) VALUES
(1, 'Nguyen Van Huy', 'nvhr714kzc@gmail.com', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE `promotion` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `promotion` tinytext COLLATE utf8mb4_vietnamese_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `promotion`
--

INSERT INTO `promotion` (`id`, `promotion`) VALUES
(1, 'Tặng 2 suất mua Đồng hồ thời trang giảm 40% (không áp dụng thêm khuyến mãi khác)'),
(2, 'Phiếu mua hàng Samsung 650.000đ (áp dụng đặt và nhận hàng từ 16 - 31/7)');

-- --------------------------------------------------------

--
-- Table structure for table `related_phone`
--

CREATE TABLE `related_phone` (
  `product_a` int(10) UNSIGNED NOT NULL,
  `product_b` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `related_phone`
--

INSERT INTO `related_phone` (`product_a`, `product_b`) VALUES
(1, 10),
(3, 2),
(3, 6),
(3, 11),
(6, 2),
(11, 2),
(11, 6);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `customer_id` int(11) NOT NULL,
  `review` text NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `trashed` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `customer_id`, `review`, `rating`, `approved`, `trashed`, `date_created`) VALUES
(1, 15, 2, 'Less than 30 days- that\'s how long it took for the poorly seated replacement screen to crack. It wasn\'t from a drop or from an impact. This was from sitting in my large male sized pocket that every phone I have owned has sat in. I didn\'t fall or trip with it in there. I have a pricey case protecting the phone and there is zero impact damage to the phone. The screen simply cracked.', 4, 1, 0, '2020-11-30 09:04:52'),
(2, 2, 2, 'Este teléfono es de Verizon y esta bloqueado, la descripción del artículo es incorrecta y no recomiendo que alguien lo compre porque solo te meterás en problemas ya que amazon tarda mucho en ayudarte porque este teléfono no lo vende directamente Amazon sino es un vendedor independiente y lo que más enoja son las pólizas donde el comprador no recibe su reembolso rápido, casi un mes y no se resuelve mi problema con este vendedor, lo veo injusto que amazon no proteja un poco más al cliente', 5, 1, 0, '2020-11-30 09:05:15'),
(3, 6, 2, 'For the price, I was kinda iffy about the condition when I brought it. Received it yesterday, the condition was near perfect. I love it. Great value too.', 4, 1, 0, '2020-11-30 09:13:35'),
(4, 10, 1, 'The phone does not work needs ssimcard. cannot be unlockedd without a PASSWORD?\r\nI was informed that this phome was made in China, I do not like thinks from China\r\nIO cannot use the phone without the needed SIM CARD', 1, 1, 0, '2020-11-30 09:14:37'),
(5, 2, 1, 'There was an issue but it was resolved very quickly. I hope they checked future products because mines was sent with a Pro Max barcode on the plastic but if you read the box itself it reads Pro. Customer service was very helpful in helping me with my replacement it shipped and delivered in one day.', 5, 1, 0, '2020-11-30 09:15:19'),
(6, 15, 1, 'Switched over from Android before owning this one and I am very happy with it. Runs great, insanely long battery life even with constant use, and it is just so smooth. The phone itself even feels high quality, I always had cases on all my phones but this one I do not have a case for. I do recommend a screen protector though, it does tend to scratch relatively easily but that is the trade off for having a more durable screen so it does not break when you drop it.', 4, 1, 0, '2020-11-30 09:15:37'),
(7, 6, 1, 'Good product', 4, 0, 0, '2020-12-20 12:45:53'),
(8, 11, 1, 'wegfwegwegwe', 4, 1, 0, '2021-02-01 02:33:01');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `price` int(11) NOT NULL,
  `start_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `end_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `product_id`, `price`, `start_date`, `end_date`) VALUES
(1, 2, 9490000, '2020-10-19 17:00:00', '2021-02-26 17:00:00'),
(2, 6, 35000000, '2020-10-09 17:00:00', NULL),
(3, 1, 28000362, '2020-10-23 17:00:00', NULL),
(4, 7, 8490000, '2020-10-23 17:00:00', '2021-02-24 17:00:00'),
(6, 15, 16490000, '2020-10-31 17:00:00', '2021-03-29 17:00:00'),
(7, 19, 7590000, '2021-02-25 17:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `shipping_address`
--

CREATE TABLE `shipping_address` (
  `id` int(11) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(20) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `last_name` varchar(40) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `country` varchar(60) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `address1` varchar(80) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `address2` varchar(80) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `city` varchar(60) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `state` char(2) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `zip` mediumint(5) UNSIGNED ZEROFILL NOT NULL,
  `phone` char(10) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `email` varchar(80) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `shipping_address`
--

INSERT INTO `shipping_address` (`id`, `user_id`, `first_name`, `last_name`, `country`, `address1`, `address2`, `city`, `state`, `zip`, `phone`, `email`, `date_created`) VALUES
(2, 2, 'Nguyen', 'Van Huy', 'Viet Nam', 'Tinh Dong', 'Tinh Thoi', 'Cao Lanh', 'AL', 82365, '799500203', 'nvhr714kzb@gmail.com', '2020-11-30 08:47:37'),
(3, 1, 'dfgde', 'egewgwe', 'gwegwe', 'gweg', 'wegwe', 'gwegew', 'AL', 02356, '799500203', 'wegwegwe@gmail.com', '2021-02-01 02:32:08');

-- --------------------------------------------------------

--
-- Table structure for table `shopping_cart`
--

CREATE TABLE `shopping_cart` (
  `item_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `cart_id` char(32) NOT NULL,
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `attributes` varchar(50) DEFAULT NULL,
  `quantity` tinyint(3) UNSIGNED NOT NULL,
  `buy_now` tinyint(1) NOT NULL DEFAULT 1,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `slider`
--

CREATE TABLE `slider` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `link` varchar(100) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `image` varchar(45) COLLATE utf8mb4_vietnamese_ci NOT NULL,
  `order_slider` int(11) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `trashed` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_vietnamese_ci;

--
-- Dumping data for table `slider`
--

INSERT INTO `slider` (`id`, `name`, `description`, `link`, `image`, `order_slider`, `date_created`, `date_modified`, `trashed`) VALUES
(1, 'Giảm 1.000.000 đ Galaxy M51', 'Description', 'http://vanbinh.unitopcv.com/phone/detail/dien-thoai-samsung-galaxy-m51/2', 'fe7a18eabf4c4d16ae3d4e53086223e22b8a06be.png', 1, '2020-10-31 01:52:30', '2020-11-28 03:47:15', 0),
(2, 'Oppo Reno4 Pro Tôi  nổi bật, tạo khác biệt', 'Description', 'http://vanbinh.unitopcv.com/phone/detail/dien-thoai-oppo-reno4-pro/7', '490eabab08aa143ed1c86c8a7b78553dbca8603a.png', 2, '2020-10-31 12:18:15', '2020-11-28 03:46:48', 0),
(3, 'Galaxy note 10 giảm 1.5 triệu', 'Description', 'http://vanbinh.unitopcv.com/phone/detail/dien-thoai-samsung-galaxy-note-10-/15', '1e7a69c3179787b513fcf9b1188680f0c611e829.png', 3, '2020-11-02 12:50:50', '2020-11-28 03:46:22', 0);

-- --------------------------------------------------------

--
-- Table structure for table `specific_coffees`
--

CREATE TABLE `specific_coffees` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `general_coffee_id` tinyint(3) UNSIGNED NOT NULL,
  `size_id` tinyint(3) UNSIGNED NOT NULL,
  `caf_decaf` enum('caf','decaf') DEFAULT NULL,
  `ground_whole` enum('ground','whole') DEFAULT NULL,
  `price` decimal(5,2) UNSIGNED NOT NULL,
  `stock` mediumint(8) UNSIGNED NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `specific_coffees`
--

INSERT INTO `specific_coffees` (`id`, `general_coffee_id`, `size_id`, `caf_decaf`, `ground_whole`, `price`, `stock`, `date_created`) VALUES
(1, 3, 1, 'caf', 'ground', 2.00, 28, '2020-07-02 15:49:35'),
(26, 1, 3, 'caf', 'ground', 22.00, 24, '2020-07-10 08:09:30'),
(27, 1, 3, 'caf', 'ground', 22.00, 23, '2020-07-10 08:09:30');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(18) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `response_code` tinyint(3) UNSIGNED NOT NULL,
  `response_reason` tinytext DEFAULT NULL,
  `transaction_id` bigint(20) UNSIGNED NOT NULL,
  `response` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `email` varchar(80) NOT NULL,
  `username` varchar(45) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `name` varchar(45) NOT NULL,
  `avatar` varchar(45) NOT NULL DEFAULT 'avatar.svg',
  `active_token` varchar(40) DEFAULT NULL,
  `is_active` enum('0','1') NOT NULL DEFAULT '0',
  `trashed` tinyint(1) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `type`, `email`, `username`, `pass`, `name`, `avatar`, `active_token`, `is_active`, `trashed`, `date_created`, `date_modified`) VALUES
(1, 150, 'nvhr714kzb@gmail.com', 'binh0799500203', '$2y$10$JKsDAKlCLrsQ1322bWVkmuyARDQAgusWEyPKx5SqJpXK9si5nSYn.', 'Nguyen Van Binh', 'avatar.svg', 'f95327b02b59f23291d2863ad45417c6', '1', 0, '2020-11-27 04:00:27', '2020-11-27 04:00:27'),
(2, 0, 'nvhr714kzc@gmail.com', 'huy123', '$2y$10$WCZrWZvUHbnaZLv3NwSJIurTagcMhdC2l43KWlcAcOAIZ0KRK411G', 'Nguyen Van Huy', 'avatar.svg', '280d160b5da179071020bd200368cebd', '1', 0, '2020-11-30 08:18:45', '2020-11-30 08:18:45');

-- --------------------------------------------------------

--
-- Table structure for table `user_discount_codes`
--

CREATE TABLE `user_discount_codes` (
  `user_id` int(11) NOT NULL,
  `discount_code` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_discount_codes`
--

INSERT INTO `user_discount_codes` (`user_id`, `discount_code`) VALUES
(1, 'aaaa'),
(1, 'binh'),
(1, 'binh'),
(1, 'aaaa');

-- --------------------------------------------------------

--
-- Table structure for table `user_post_like`
--

CREATE TABLE `user_post_like` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `comment_id` int(10) UNSIGNED NOT NULL,
  `seen` tinyint(4) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user_post_like`
--

INSERT INTO `user_post_like` (`user_id`, `comment_id`, `seen`, `date_created`) VALUES
(1, 4, 1, '2020-12-01 00:12:02'),
(1, 5, 1, '2020-12-01 00:32:30'),
(1, 7, 1, '2020-12-01 00:18:10'),
(1, 10, 1, '2020-12-01 00:32:46'),
(1, 11, 1, '2020-12-01 00:32:47');

-- --------------------------------------------------------

--
-- Table structure for table `user_type`
--

CREATE TABLE `user_type` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `type` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_type`
--

INSERT INTO `user_type` (`id`, `type`) VALUES
(150, 'Admin'),
(50, 'Author'),
(100, 'Editor'),
(0, 'Member');

-- --------------------------------------------------------

--
-- Table structure for table `views`
--

CREATE TABLE `views` (
  `post_id` int(10) UNSIGNED NOT NULL,
  `num_view` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `views`
--

INSERT INTO `views` (`post_id`, `num_view`) VALUES
(1, 16),
(2, 15),
(3, 11),
(5, 38),
(6, 6),
(7, 2),
(8, 1),
(9, 4),
(10, 2);

-- --------------------------------------------------------

--
-- Table structure for table `wish_lists`
--

CREATE TABLE `wish_lists` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_session_id` char(32) NOT NULL,
  `product_type` enum('racket','phone') NOT NULL,
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `quantity` tinyint(3) UNSIGNED NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp(),
  `attributes` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `access_tokens`
--
ALTER TABLE `access_tokens`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `t_token` (`token`);

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attribute`
--
ALTER TABLE `attribute`
  ADD PRIMARY KEY (`attribute_id`);

--
-- Indexes for table `attribute_value`
--
ALTER TABLE `attribute_value`
  ADD PRIMARY KEY (`attribute_value_id`),
  ADD KEY `attribute_id` (`attribute_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `charges`
--
ALTER TABLE `charges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `charge_id` (`charge_id`);

--
-- Indexes for table `charges_not_login`
--
ALTER TABLE `charges_not_login`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `charge_id` (`charge_id`);

--
-- Indexes for table `chat_message`
--
ALTER TABLE `chat_message`
  ADD PRIMARY KEY (`chat_message_id`),
  ADD KEY `from_user_id` (`from_user_id`,`to_user_id`),
  ADD KEY `date_created` (`date_created`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `parent_comment_id` (`parent_comment_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `discount_codes`
--
ALTER TABLE `discount_codes`
  ADD PRIMARY KEY (`voucher_code`),
  ADD KEY `vouchercode` (`voucher_code`);

--
-- Indexes for table `emails_get_news`
--
ALTER TABLE `emails_get_news`
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `favorite_pages`
--
ALTER TABLE `favorite_pages`
  ADD PRIMARY KEY (`user_id`,`page_id`);

--
-- Indexes for table `general_coffees`
--
ALTER TABLE `general_coffees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category` (`category`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`h_id`),
  ADD KEY `h_type` (`h_type`,`h_item_id`);

--
-- Indexes for table `img_product`
--
ALTER TABLE `img_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`) USING BTREE;

--
-- Indexes for table `login_details`
--
ALTER TABLE `login_details`
  ADD PRIMARY KEY (`login_detail_id`),
  ADD KEY `user_id` (`user_id`,`last_activity`);

--
-- Indexes for table `non_coffee_categories`
--
ALTER TABLE `non_coffee_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category` (`category`);

--
-- Indexes for table `non_coffee_products`
--
ALTER TABLE `non_coffee_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `non_coffee_category_id` (`non_coffee_category_id`);

--
-- Indexes for table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`user_id`,`page_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `order_date` (`order_date`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `idx_orders_customer_id` (`customer_id`);

--
-- Indexes for table `orders_not_login`
--
ALTER TABLE `orders_not_login`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `order_date` (`order_date`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `order_contents`
--
ALTER TABLE `order_contents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_type` (`product_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_contents_not_login`
--
ALTER TABLE `order_contents_not_login`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `pdfs`
--
ALTER TABLE `pdfs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pdf_tmp_name` (`tmp_name`),
  ADD KEY `pdf_date_created` (`date_created`);

--
-- Indexes for table `phones`
--
ALTER TABLE `phones`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `phones` ADD FULLTEXT KEY `name` (`name`,`description`);

--
-- Indexes for table `phone_category`
--
ALTER TABLE `phone_category`
  ADD PRIMARY KEY (`phone_id`,`category_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date_created` (`date_created`);

--
-- Indexes for table `product_attribute`
--
ALTER TABLE `product_attribute`
  ADD PRIMARY KEY (`product_id`,`attribute_value_id`) USING BTREE;

--
-- Indexes for table `product_stock_notification`
--
ALTER TABLE `product_stock_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `related_phone`
--
ALTER TABLE `related_phone`
  ADD PRIMARY KEY (`product_a`,`product_b`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_id_2` (`product_id`,`customer_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_id` (`product_id`) USING BTREE,
  ADD KEY `start_date` (`start_date`),
  ADD KEY `end_date` (`end_date`);

--
-- Indexes for table `shipping_address`
--
ALTER TABLE `shipping_address`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `shopping_cart`
--
ALTER TABLE `shopping_cart`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `cart_id` (`cart_id`) USING BTREE,
  ADD KEY `product_id` (`product_id`) USING BTREE;

--
-- Indexes for table `slider`
--
ALTER TABLE `slider`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_slider` (`order_slider`);

--
-- Indexes for table `specific_coffees`
--
ALTER TABLE `specific_coffees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `general_coffee_id` (`general_coffee_id`),
  ADD KEY `size` (`size_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`) USING BTREE,
  ADD KEY `login` (`email`,`pass`) USING BTREE;

--
-- Indexes for table `user_post_like`
--
ALTER TABLE `user_post_like`
  ADD UNIQUE KEY `user_id` (`user_id`,`comment_id`),
  ADD KEY `user_id_2` (`user_id`),
  ADD KEY `comment_id` (`comment_id`);

--
-- Indexes for table `user_type`
--
ALTER TABLE `user_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `type` (`type`);

--
-- Indexes for table `views`
--
ALTER TABLE `views`
  ADD PRIMARY KEY (`post_id`);

--
-- Indexes for table `wish_lists`
--
ALTER TABLE `wish_lists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_type` (`product_type`,`product_id`),
  ADD KEY `user_session_id` (`user_session_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `attribute`
--
ALTER TABLE `attribute`
  MODIFY `attribute_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attribute_value`
--
ALTER TABLE `attribute_value`
  MODIFY `attribute_value_id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `charges`
--
ALTER TABLE `charges`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `charges_not_login`
--
ALTER TABLE `charges_not_login`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `chat_message`
--
ALTER TABLE `chat_message`
  MODIFY `chat_message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `general_coffees`
--
ALTER TABLE `general_coffees`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `h_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `img_product`
--
ALTER TABLE `img_product`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `login_details`
--
ALTER TABLE `login_details`
  MODIFY `login_detail_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT for table `non_coffee_categories`
--
ALTER TABLE `non_coffee_categories`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `non_coffee_products`
--
ALTER TABLE `non_coffee_products`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `notes`
--
ALTER TABLE `notes`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=294;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders_not_login`
--
ALTER TABLE `orders_not_login`
  MODIFY `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_contents`
--
ALTER TABLE `order_contents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `order_contents_not_login`
--
ALTER TABLE `order_contents_not_login`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `pdfs`
--
ALTER TABLE `pdfs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `phones`
--
ALTER TABLE `phones`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `product_stock_notification`
--
ALTER TABLE `product_stock_notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `promotion`
--
ALTER TABLE `promotion`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `shipping_address`
--
ALTER TABLE `shipping_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `shopping_cart`
--
ALTER TABLE `shopping_cart`
  MODIFY `item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `slider`
--
ALTER TABLE `slider`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `specific_coffees`
--
ALTER TABLE `specific_coffees`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wish_lists`
--
ALTER TABLE `wish_lists`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
